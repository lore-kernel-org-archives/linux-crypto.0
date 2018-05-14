From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 2/5] crypto: chtls: wait for memory sendmsg, sendpage
Date: Mon, 14 May 2018 14:29:54 +0300
Message-ID: <20180514112954.fg3utsv7rvd3n4js@mwanda>
References: <1526295659-29839-1-git-send-email-atul.gupta@chelsio.com>
 <1526295659-29839-3-git-send-email-atul.gupta@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        gustavo@embeddedor.com, netdev@vger.kernel.org, davem@davemloft.net
To: Atul Gupta <atul.gupta@chelsio.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1526295659-29839-3-git-send-email-atul.gupta@chelsio.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, May 14, 2018 at 04:30:56PM +0530, Atul Gupta wrote:
> Reported-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>

There isn't a commit message for this.  It should say what the user
visible effects of this bug are.  I haven't seen Gustavo's bug report,
but probably copy and pasting that would be good?

> ---
>  drivers/crypto/chelsio/chtls/chtls.h      |  1 +
>  drivers/crypto/chelsio/chtls/chtls_io.c   | 90 +++++++++++++++++++++++++++++--
>  drivers/crypto/chelsio/chtls/chtls_main.c |  1 +
>  3 files changed, 89 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/chelsio/chtls/chtls.h b/drivers/crypto/chelsio/chtls/chtls.h
> index f4b8f1e..778c194 100644
> --- a/drivers/crypto/chelsio/chtls/chtls.h
> +++ b/drivers/crypto/chelsio/chtls/chtls.h
> @@ -149,6 +149,7 @@ struct chtls_dev {
>  	struct list_head rcu_node;
>  	struct list_head na_node;
>  	unsigned int send_page_order;
> +	int max_host_sndbuf;
>  	struct key_map kmap;
>  };
>  
> diff --git a/drivers/crypto/chelsio/chtls/chtls_io.c b/drivers/crypto/chelsio/chtls/chtls_io.c
> index 5a75be4..a4c7d2d 100644
> --- a/drivers/crypto/chelsio/chtls/chtls_io.c
> +++ b/drivers/crypto/chelsio/chtls/chtls_io.c
> @@ -914,6 +914,78 @@ static u16 tls_header_read(struct tls_hdr *thdr, struct iov_iter *from)
>  	return (__force u16)cpu_to_be16(thdr->length);
>  }
>  
> +static int csk_mem_free(struct chtls_dev *cdev, struct sock *sk)
> +{
> +	return (cdev->max_host_sndbuf - sk->sk_wmem_queued) > 0;

Why not just say:

	return (max_host_sndbuf > sk->sk_wmem_queued);

> +}
> +
> +static int csk_wait_memory(struct chtls_dev *cdev,
> +			   struct sock *sk, long *timeo_p)
> +{
> +	DEFINE_WAIT_FUNC(wait, woken_wake_function);
> +	int sndbuf, err = 0;
> +	long current_timeo;
> +	long vm_wait = 0;
> +	bool noblock;
> +
> +	current_timeo = *timeo_p;
> +	noblock = (*timeo_p ? false : true);
> 	sndbuf = cdev->max_host_sndbuf;
> +	if (sndbuf > sk->sk_wmem_queued) {

You could use it here:

	if (csk_mem_free(cdev, sk)) {


> +		current_timeo = (prandom_u32() % (HZ / 5)) + 2;
> +		vm_wait = (prandom_u32() % (HZ / 5)) + 2;
> +	}
> +
> +	add_wait_queue(sk_sleep(sk), &wait);
> +	while (1) {
> +		sk_set_bit(SOCKWQ_ASYNC_NOSPACE, sk);
> +
> +		if (sk->sk_err || (sk->sk_shutdown & SEND_SHUTDOWN))
> +			goto do_error;
> +		if (!*timeo_p) {
> +			if (noblock)
> +				set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
> +				goto do_nonblock;

There are missing curly braces here.  I feel like these gotos make the
code worse.  They don't remove duplicate lines of code.  They just
spread things out so that you have to jump around to understand this
code.  It's like being a kangaroo.

			if (noblock) {
				set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
				err = -EAGAIN;
				goto remove_queue;
			}

I always like picking a descriptive label names instead of "out:"

> +		}
> +		if (signal_pending(current))
> +			goto do_interrupted;
> +		sk_clear_bit(SOCKWQ_ASYNC_NOSPACE, sk);
> +		if (sndbuf > sk->sk_wmem_queued && !vm_wait)
> +			break;

		if (csk_mem_free(cdev, sk) && !vm_wait)


> +
> +		set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
> +		sk->sk_write_pending++;
> +		sk_wait_event(sk, &current_timeo, sk->sk_err ||
> +			      (sk->sk_shutdown & SEND_SHUTDOWN) ||
> +			      (sndbuf > sk->sk_wmem_queued && !vm_wait), &wait);


			      (csk_mem_free(cdev, sk) && !vm_wait), &wait);


> +		sk->sk_write_pending--;
> +
> +		if (vm_wait) {
> +			vm_wait -= current_timeo;
> +			current_timeo = *timeo_p;
> +			if (current_timeo != MAX_SCHEDULE_TIMEOUT) {
> +				current_timeo -= vm_wait;
> +				if (current_timeo < 0)
> +					current_timeo = 0;
> +			}
> +			vm_wait = 0;
> +		}
> +		*timeo_p = current_timeo;
> +	}
> +out:
> +	remove_wait_queue(sk_sleep(sk), &wait);
> +	return err;
> +do_error:
> +	err = -EPIPE;
> +	goto out;
> +do_nonblock:
> +	err = -EAGAIN;
> +	goto out;
> +do_interrupted:
> +	err = sock_intr_errno(*timeo_p);
> +	goto out;
> +}
> +

regards,
dan carpenter
