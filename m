From: Gary R Hook <gary.hook@amd.com>
Subject: Re: [PATCH 2/3] crypto: ccp - return an actual key size from RSA
 max_size callback
Date: Wed, 28 Feb 2018 18:34:09 -0600
Message-ID: <510c8c85-8619-5fe6-9275-1549a73bd545@amd.com>
References: <51c265e4-6153-3e5e-316a-ebef059ac36a@maciej.szmigiero.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Cc: David Howells <dhowells@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <51c265e4-6153-3e5e-316a-ebef059ac36a@maciej.szmigiero.name>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 02/24/2018 10:03 AM, Maciej S. Szmigiero wrote:
> rsa-pkcs1pad uses a value returned from a RSA implementation max_size
> callback as a size of an input buffer passed to the RSA implementation for
> encrypt and sign operations.
> 
> CCP RSA implementation uses a hardware input buffer which size depends only
> on the current RSA key length, so it should return this key length in
> the max_size callback, too.
> This also matches what the kernel software RSA implementation does.
> 
> Previously, the value returned from this callback was always the maximum
> RSA key size the CCP hardware supports.
> This resulted in this huge buffer being passed by rsa-pkcs1pad to CCP even
> for smaller key sizes and then in a buffer overflow when ccp_run_rsa_cmd()
> tried to copy this large input buffer into a RSA key length-sized hardware
> input buffer.
> 
> Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>

Acked-by: Gary R Hook <gary.hook@amd.com>

> Fixes: ceeec0afd684 ("crypto: ccp - Add support for RSA on the CCP")
> Cc: stable@vger.kernel.org
> ---
>   drivers/crypto/ccp/ccp-crypto-rsa.c | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/ccp-crypto-rsa.c b/drivers/crypto/ccp/ccp-crypto-rsa.c
> index e6db8672d89c..05850dfd7940 100644
> --- a/drivers/crypto/ccp/ccp-crypto-rsa.c
> +++ b/drivers/crypto/ccp/ccp-crypto-rsa.c
> @@ -60,10 +60,9 @@ static int ccp_rsa_complete(struct crypto_async_request *async_req, int ret)
>   
>   static unsigned int ccp_rsa_maxsize(struct crypto_akcipher *tfm)
>   {
> -	if (ccp_version() > CCP_VERSION(3, 0))
> -		return CCP5_RSA_MAXMOD;
> -	else
> -		return CCP_RSA_MAXMOD;
> +	struct ccp_ctx *ctx = akcipher_tfm_ctx(tfm);
> +
> +	return ctx->u.rsa.n_len;
>   }
>   
>   static int ccp_rsa_crypt(struct akcipher_request *req, bool encrypt)
> 
