From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH] crypto: fix ctx pointer in sha512-mb
Date: Fri, 12 Aug 2016 09:18:04 -0700
Message-ID: <1471018684.2888.41.camel@linux.intel.com>
References: <1470997711-118507-1-git-send-email-xiaodong.liu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, megha.dey@intel.com,
	linux-kernel@vger.kernel.org
To: Xiaodong Liu <xiaodong.liu@intel.com>, herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1470997711-118507-1-git-send-email-xiaodong.liu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, 2016-08-12 at 06:28 -0400, Xiaodong Liu wrote:
> Signed-off-by: Xiaodong Liu <xiaodong.liu@intel.com>
> ---
>  arch/x86/crypto/sha512-mb/sha512_mb.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/crypto/sha512-mb/sha512_mb.c b/arch/x86/crypto/sha512-mb/sha512_mb.c
> index f4cf5b7..d210174 100644
> --- a/arch/x86/crypto/sha512-mb/sha512_mb.c
> +++ b/arch/x86/crypto/sha512-mb/sha512_mb.c
> @@ -497,10 +497,10 @@ static int sha_complete_job(struct mcryptd_hash_request_ctx *rctx,
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

Changes look fine to me.

Acked.

Tim
