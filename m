From: Harsh Jain <harsh@chelsio.com>
Subject: Re: [PATCH] crypto: chelsio: move chcr_ahash_continue declation out
 of header
Date: Thu, 29 Mar 2018 17:13:20 +0530
Message-ID: <865ba49d-b24f-b3b6-1440-54cfa7b4c2e6@chelsio.com>
References: <20180328140539.2694734-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Ganesh Goudar <ganeshgr@chelsio.com>,
        Atul Gupta <atul.gupta@chelsio.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180328140539.2694734-1-arnd@arndb.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

Fix for that is already submitted in below patch.

https://patchwork.kernel.org/patch/10292333/

Thanks


On 28-03-2018 19:35, Arnd Bergmann wrote:
> static function declarations don't belong in a header file, as shown
> by this compiler warning:
>
> In file included from /git/arm-soc/drivers/crypto/chelsio/chcr_ipsec.c:66:
> drivers/crypto/chelsio/chcr_crypto.h:343:12: error: 'chcr_ahash_continue' declared 'static' but never defined [-Werror=unused-function]
>
> This moves the declaration into the file that actually needs it.
>
> Fixes: 5110e65536f3 ("crypto: chelsio -Split Hash requests for large scatter gather list")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/crypto/chelsio/chcr_algo.c   | 1 +
>  drivers/crypto/chelsio/chcr_crypto.h | 1 -
>  2 files changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
> index 4617c7acf4da..ebc96f2fae01 100644
> --- a/drivers/crypto/chelsio/chcr_algo.c
> +++ b/drivers/crypto/chelsio/chcr_algo.c
> @@ -95,6 +95,7 @@ static u32 round_constant[11] = {
>  
>  static int chcr_handle_cipher_resp(struct ablkcipher_request *req,
>  				   unsigned char *input, int err);
> +static int chcr_ahash_continue(struct ahash_request *req);
>  
>  static inline  struct chcr_aead_ctx *AEAD_CTX(struct chcr_context *ctx)
>  {
> diff --git a/drivers/crypto/chelsio/chcr_crypto.h b/drivers/crypto/chelsio/chcr_crypto.h
> index 71025ea9c3db..c8e8972af283 100644
> --- a/drivers/crypto/chelsio/chcr_crypto.h
> +++ b/drivers/crypto/chelsio/chcr_crypto.h
> @@ -340,5 +340,4 @@ void chcr_add_hash_src_ent(struct ahash_request *req, struct ulptx_sgl *ulptx,
>  			   struct hash_wr_param *param);
>  int chcr_hash_dma_map(struct device *dev, struct ahash_request *req);
>  void chcr_hash_dma_unmap(struct device *dev, struct ahash_request *req);
> -static int chcr_ahash_continue(struct ahash_request *req);
>  #endif /* __CHCR_CRYPTO_H__ */
