From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [patch] crypto: sha-mb - remove a bogus NULL check
Date: Mon, 24 Nov 2014 09:47:34 -0800
Message-ID: <1416851254.18250.14.camel@schen9-desk2.jf.intel.com>
References: <20141122183628.GD6994@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	Fengguang Wu <fengguang.wu@intel.com>,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20141122183628.GD6994@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, 2014-11-22 at 21:36 +0300, Dan Carpenter wrote:
> This can't be NULL and we dereferenced it earlier.  Smatch used to
> ignore these things where the pointer was obviously non-NULL but I've
> found that sometimes the intention was to check something else so we
> were maybe missing bugs.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/arch/x86/crypto/sha-mb/sha1_mb.c b/arch/x86/crypto/sha-mb/sha1_mb.c
> index 99eefd8..a225a5ca 100644
> --- a/arch/x86/crypto/sha-mb/sha1_mb.c
> +++ b/arch/x86/crypto/sha-mb/sha1_mb.c
> @@ -204,8 +204,7 @@ static struct sha1_hash_ctx *sha1_ctx_mgr_resubmit(struct sha1_ctx_mgr *mgr, str
>  			continue;
>  		}
>  
> -		if (ctx)
> -			ctx->status = HASH_CTX_STS_IDLE;
> +		ctx->status = HASH_CTX_STS_IDLE;
>  		return ctx;
>  	}
>  

Agree.  This NULL pointer check is not necessary.

Acked-by: Tim Chen <tim.c.chen@linux.intel.com>


