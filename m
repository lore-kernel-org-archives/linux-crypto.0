From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/8] crypto: hash: add zero length message hash for shax
 and md5
Date: Wed, 14 Oct 2015 18:08:02 +0800
Message-ID: <20151014100802.GA15884@gondor.apana.org.au>
References: <1444668826-6531-1-git-send-email-clabbe.montjoie@gmail.com>
 <1444668826-6531-2-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, thomas.lendacky@amd.com,
	geert+renesas@glider.be, ulf.hansson@linaro.org, wsa@the-dreams.de,
	keescook@chromium.org, maxime.ripard@free-electrons.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41830 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbbJNKI3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Oct 2015 06:08:29 -0400
Content-Disposition: inline
In-Reply-To: <1444668826-6531-2-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 12, 2015 at 06:53:39PM +0200, LABBE Corentin wrote:
> Some crypto drivers cannot process empty data message and return a
> precalculated hash for md5/sha1/sha224/sha256.
> 
> This patch add thoses precalculated hash in include/crypto.
> 
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> ---
>  include/crypto/md5.h |  5 +++++
>  include/crypto/sha.h | 20 ++++++++++++++++++++
>  2 files changed, 25 insertions(+)
> 
> diff --git a/include/crypto/md5.h b/include/crypto/md5.h
> index 146af82..6496ee0 100644
> --- a/include/crypto/md5.h
> +++ b/include/crypto/md5.h
> @@ -13,6 +13,11 @@
>  #define MD5_H2	0x98badcfeUL
>  #define MD5_H3	0x10325476UL
>  
> +static const u8 md5_zero_message_hash[MD5_DIGEST_SIZE] = {
> +	0xd4, 0x1d, 0x8c, 0xd9, 0x8f, 0x00, 0xb2, 0x04,
> +	0xe9, 0x80, 0x09, 0x98, 0xec, 0xf8, 0x42, 0x7e,
> +};
> +

This potentially creates this structure in every file that includes
md5.h.  How about putting it into md5_generic and exporting it?

> diff --git a/include/crypto/sha.h b/include/crypto/sha.h
> index dd7905a..02d7ffb 100644
> --- a/include/crypto/sha.h
> +++ b/include/crypto/sha.h
> @@ -64,6 +64,26 @@
>  #define SHA512_H6	0x1f83d9abfb41bd6bULL
>  #define SHA512_H7	0x5be0cd19137e2179ULL
>  
> +static const u8 sha1_zero_message_hash[SHA1_DIGEST_SIZE] = {
> +	0xda, 0x39, 0xa3, 0xee, 0x5e, 0x6b, 0x4b, 0x0d,
> +	0x32, 0x55, 0xbf, 0xef, 0x95, 0x60, 0x18, 0x90,
> +	0xaf, 0xd8, 0x07, 0x09
> +};

Ditto.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
