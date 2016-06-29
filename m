From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] crypto: sha256-mb - cleanup a || vs | typo
Date: Wed, 29 Jun 2016 10:05:53 -0700
Message-ID: <8538242a-eab7-127e-e47e-26027fee4f6d@zytor.com>
References: <20160629144242.GE22818@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Megha Dey <megha.dey@intel.com>,
	"Wang, Rui Y" <rui.y.wang@intel.com>,
	Denys Vlasenko <dvlasenk@redhat.com>,
	Xiaodong Liu <xiaodong.liu@intel.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20160629144242.GE22818@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 06/29/16 07:42, Dan Carpenter wrote:
> || and | behave basically the same here but || is intended.  It causes a
> static checker warning to mix up bitwise and logical operations.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/arch/x86/crypto/sha256-mb/sha256_mb.c b/arch/x86/crypto/sha256-mb/sha256_mb.c
> index c9d5dcc..4ec895a 100644
> --- a/arch/x86/crypto/sha256-mb/sha256_mb.c
> +++ b/arch/x86/crypto/sha256-mb/sha256_mb.c
> @@ -299,7 +299,7 @@ static struct sha256_hash_ctx *sha256_ctx_mgr_submit(struct sha256_ctx_mgr *mgr,
>  	 * Or if the user's buffer contains less than a whole block,
>  	 * append as much as possible to the extra block.
>  	 */
> -	if ((ctx->partial_block_buffer_length) | (len < SHA256_BLOCK_SIZE)) {
> +	if ((ctx->partial_block_buffer_length) || (len < SHA256_BLOCK_SIZE)) {
>  		/* Compute how many bytes to copy from user buffer into
>  		 * extra block
>  		 */
> 

As far as I know the | was an intentional optimization, so you may way
to look at the generated code.

	-hpa

