From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH] s390: crypto: aes_s390: Remove 'const' to avoid compiler
 warnings
Date: Wed, 7 Jan 2015 09:24:14 +0100
Message-ID: <20150107082414.GA4365@osiris>
References: <54A56002.3000301@sunrus.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	schwidefsky@de.ibm.com, linux390@de.ibm.com,
	linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Chen Gang <gang.chen@sunrus.com.cn>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:42232 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbbAGIYZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 Jan 2015 03:24:25 -0500
Received: from /spool/local
	by e06smtp15.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <heiko.carstens@de.ibm.com>;
	Wed, 7 Jan 2015 08:24:23 -0000
Content-Disposition: inline
In-Reply-To: <54A56002.3000301@sunrus.com.cn>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 01, 2015 at 10:56:02PM +0800, Chen Gang wrote:
> In aes_encrypt() and aes_decrypt(), need let 'sctx->key' be modified,
> so remove 'const' for it. The related warnings:
...
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  arch/s390/crypto/aes_s390.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
> index 1f272b2..5566ce8 100644
> --- a/arch/s390/crypto/aes_s390.c
> +++ b/arch/s390/crypto/aes_s390.c
> @@ -134,7 +134,7 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
> 
>  static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>  {
> -	const struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
> +	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
> 
>  	if (unlikely(need_fallback(sctx->key_len))) {
>  		crypto_cipher_encrypt_one(sctx->fallback.cip, out, in);
> @@ -159,7 +159,7 @@ static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
> 
>  static void aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>  {
> -	const struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
> +	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
> 
>  	if (unlikely(need_fallback(sctx->key_len))) {
>  		crypto_cipher_decrypt_one(sctx->fallback.cip, out, in);

Applied, thanks.
