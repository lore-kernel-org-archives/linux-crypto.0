From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH 12/12] crypto/sha-mb/sha1_mb.c : Syntax error
Date: Fri, 13 Mar 2015 14:33:18 -0700
Message-ID: <1426282398.660.22.camel@schen9-desk2.jf.intel.com>
References: <1426281204-10219-1-git-send-email-ameenali023@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Ameen Ali <ameenali023@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426281204-10219-1-git-send-email-ameenali023@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, 2015-03-13 at 23:13 +0200, Ameen Ali wrote:
> fixing a syntax-error .
> 
> Signed-off-by : Ameen Ali <AmeenAli023@gmail.com>
> ---
>  arch/x86/crypto/sha-mb/sha1_mb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/crypto/sha-mb/sha1_mb.c b/arch/x86/crypto/sha-mb/sha1_mb.c
> index fd9f6b0..ec0b989 100644
> --- a/arch/x86/crypto/sha-mb/sha1_mb.c
> +++ b/arch/x86/crypto/sha-mb/sha1_mb.c
> @@ -828,7 +828,7 @@ static unsigned long sha1_mb_flusher(struct mcryptd_alg_cstate *cstate)
>  	while (!list_empty(&cstate->work_list)) {
>  		rctx = list_entry(cstate->work_list.next,
>  				struct mcryptd_hash_request_ctx, waiter);
> -		if time_before(cur_time, rctx->tag.expire)
> +		if(time_before(cur_time, rctx->tag.expire))

Can you add a space and make it 
		if (time_before(cur_time, rctx->tag.expire))

Thanks.

Tim
>  			break;
>  		kernel_fpu_begin();
>  		sha_ctx = (struct sha1_hash_ctx *) sha1_ctx_mgr_flush(cstate->mgr);
