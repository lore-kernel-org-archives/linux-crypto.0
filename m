From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH] crypto: Add ECB dependency for XTS mode
Date: Fri, 3 Mar 2017 07:25:21 +0100
Message-ID: <02f80ce3-4c85-78ea-7b15-4467a2ae5be4@gmail.com>
References: <20170221231717.GA7186@nicolas-laptop>
 <20170223073826.19066-1-gmazyland@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: stable@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170223073826.19066-1-gmazyland@gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Patch below should be backported to 4.10 stable
(only 4.10, older kernels are ok).
We have reports some systems fail to boot from LUKS now
(missing ecb module in initramdisk) ...

Upstream commit is 12cb3a1c4184f891d965d1f39f8cfcc9ef617647

Thanks,
Milan

On 02/23/2017 08:38 AM, Milan Broz wrote:
> Since the
>    commit f1c131b45410a202eb45cc55980a7a9e4e4b4f40
>    crypto: xts - Convert to skcipher
> the XTS mode is based on ECB, so the mode must select
> ECB otherwise it can fail to initialize.
> 
> Signed-off-by: Milan Broz <gmazyland@gmail.com>
> ---
>  crypto/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 160f08e721cc..9c245eb0dd83 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -374,6 +374,7 @@ config CRYPTO_XTS
>  	select CRYPTO_BLKCIPHER
>  	select CRYPTO_MANAGER
>  	select CRYPTO_GF128MUL
> +	select CRYPTO_ECB
>  	help
>  	  XTS: IEEE1619/D16 narrow block cipher use with aes-xts-plain,
>  	  key size 256, 384 or 512 bits. This implementation currently
> 
