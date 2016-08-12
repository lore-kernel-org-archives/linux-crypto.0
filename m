From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH] crypto: fix ctx pointer and digest copy in sha256-mb
Date: Fri, 12 Aug 2016 09:17:00 -0700
Message-ID: <1471018620.2888.40.camel@linux.intel.com>
References: <1470997482-118327-1-git-send-email-xiaodong.liu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, megha.dey@intel.com,
	linux-kernel@vger.kernel.org
To: Xiaodong Liu <xiaodong.liu@intel.com>, herbert@gondor.apana.org.au,
	Megha Dey <megha.dey@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:50422 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbcHLQRQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Aug 2016 12:17:16 -0400
In-Reply-To: <1470997482-118327-1-git-send-email-xiaodong.liu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 2016-08-12 at 06:24 -0400, Xiaodong Liu wrote:
> 1. fix ctx pointer
> Use req_ctx which is the ctx for the next job that have
> been completed in the lanes instead of the first
> completed job rctx, whose completion could have been
> called and released.
> 2. fix digest copy
> Use XMM register to copy another 16 bytes sha256 digest
> instead of a regular register.

The changes look fine to me.  Megha, can you double check?

Tim

> 
> Signed-off-by: Xiaodong Liu <xiaodong.liu@intel.com>
> ---
>  arch/x86/crypto/sha256-mb/sha256_mb.c                | 4 ++--
>  arch/x86/crypto/sha256-mb/sha256_mb_mgr_flush_avx2.S | 7 ++++---
>  2 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/crypto/sha256-mb/sha256_mb.c b/arch/x86/crypto/sha256-mb/sha256_mb.c
> index 89fa85e..6f97fb3 100644
> --- a/arch/x86/crypto/sha256-mb/sha256_mb.c
> +++ b/arch/x86/crypto/sha256-mb/sha256_mb.c
> @@ -485,10 +485,10 @@ static int sha_complete_job(struct mcryptd_hash_request_ctx *rctx,
>  
>  			req = cast_mcryptd_ctx_to_req(req_ctx);
>  			if (irqs_disabled())
> -				rctx->complete(&req->base, ret);
> +				req_ctx->complete(&req->base, ret);
>  			else {
>  				local_bh_disable();
> -				rctx->complete(&req->base, ret);
> +				req_ctx->complete(&req->base, ret);
>  				local_bh_enable();
>  			}
>  		}
> diff --git a/arch/x86/crypto/sha256-mb/sha256_mb_mgr_flush_avx2.S b/arch/x86/crypto/sha256-mb/sha256_mb_mgr_flush_avx2.S
> index b691da9..a78a069 100644
> --- a/arch/x86/crypto/sha256-mb/sha256_mb_mgr_flush_avx2.S
> +++ b/arch/x86/crypto/sha256-mb/sha256_mb_mgr_flush_avx2.S
> @@ -265,13 +265,14 @@ ENTRY(sha256_mb_mgr_get_comp_job_avx2)
>  	vpinsrd	$1, _args_digest+1*32(state, idx, 4), %xmm0, %xmm0
>  	vpinsrd	$2, _args_digest+2*32(state, idx, 4), %xmm0, %xmm0
>  	vpinsrd	$3, _args_digest+3*32(state, idx, 4), %xmm0, %xmm0
> -	movl	_args_digest+4*32(state, idx, 4), tmp2_w
> +	vmovd   _args_digest(state , idx, 4) , %xmm0
>  	vpinsrd	$1, _args_digest+5*32(state, idx, 4), %xmm1, %xmm1
>  	vpinsrd	$2, _args_digest+6*32(state, idx, 4), %xmm1, %xmm1
>  	vpinsrd	$3, _args_digest+7*32(state, idx, 4), %xmm1, %xmm1
>  
> -	vmovdqu	%xmm0, _result_digest(job_rax)
> -	movl	tmp2_w, _result_digest+1*16(job_rax)
> +        vmovdqu %xmm0, _result_digest(job_rax)
> +        offset =  (_result_digest + 1*16)
> +        vmovdqu %xmm1, offset(job_rax)
>  
>  	pop	%rbx
>  
