From: Stefano Brivio <sbrivio@redhat.com>
Subject: Re: [PATCH v13 net-next 01/12] tls: support for Inline tls record
Date: Tue, 27 Mar 2018 20:23:29 +0200
Message-ID: <20180327202329.6d0d8896@epycfail>
References: <1522172201-7629-1-git-send-email-atul.gupta@chelsio.com>
        <1522172201-7629-2-git-send-email-atul.gupta@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        davejwatson@fb.com, sd@queasysnail.net,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        werner@chelsio.com, leedom@chelsio.com,
        swise@opengridcomputing.com, indranil@chelsio.com,
        ganeshgr@chelsio.com
To: Atul Gupta <atul.gupta@chelsio.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1522172201-7629-2-git-send-email-atul.gupta@chelsio.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 27 Mar 2018 23:06:30 +0530
Atul Gupta <atul.gupta@chelsio.com> wrote:

> +static struct tls_context *create_ctx(struct sock *sk)
> +{
> +	struct inet_connection_sock *icsk = inet_csk(sk);
> +	struct tls_context *ctx;
> +
> +	/* allocate tls context */
> +	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
> +	if (!ctx)
> +		return NULL;
> +
> +	icsk->icsk_ulp_data = ctx;
> +	return ctx;
> +}
>
> [...]
>
>  static int tls_init(struct sock *sk)
>  {
>  	int ip_ver = sk->sk_family == AF_INET6 ? TLSV6 : TLSV4;
> -	struct inet_connection_sock *icsk = inet_csk(sk);
>  	struct tls_context *ctx;
>  	int rc = 0;
>  
> +	if (tls_hw_prot(sk))
> +		goto out;
> +
>  	/* The TLS ulp is currently supported only for TCP sockets
>  	 * in ESTABLISHED state.
>  	 * Supporting sockets in LISTEN state will require us
> @@ -530,12 +624,11 @@ static int tls_init(struct sock *sk)
>  		return -ENOTSUPP;
>  
>  	/* allocate tls context */
> -	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
> +	ctx = create_ctx(sk);
>  	if (!ctx) {
>  		rc = -ENOMEM;
>  		goto out;
>  	}
> -	icsk->icsk_ulp_data = ctx;

Why are you changing this?

This is now equivalent to the original implementation, except that you
are "hiding" the assignment of icsk->icsk_ulp_data into a function named
"create_ctx".

Please also note that you are duplicating the "allocate tls context"
comment.

-- 
Stefano
