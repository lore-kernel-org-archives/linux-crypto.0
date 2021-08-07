Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D934C4338F
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Aug 2021 05:33:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42FDF6115C
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Aug 2021 05:33:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbhHGFdq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 7 Aug 2021 01:33:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:51282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230377AbhHGFdq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 7 Aug 2021 01:33:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F25261050;
        Sat,  7 Aug 2021 05:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628314409;
        bh=HNt1FmbyVPf6HRrgnnW4+/eZ4HV+Da68T9WAMEWLK3M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ys9/0zUkuvZinfMRS6ci6qvNyzySEyediZANpXqbzYr/+QWF0VUNmEEiol0cqBz0E
         QWJTcubDIqtjEo3A6le8bL9H5DcaQtkwwBoaEQgq31ZZHnr/3Z/ec+3MJVYvUuNtzI
         UUfvrBLaCOkySARDvGOeTnRsJJjirvsAU4xL6+/+P2iuExk5PaIiqber+FZ3yJB4XF
         gzfQ4jG93YtRK8CmLjNVX9CwKj3SwOBJtCsmj1Gg107ZqdbQrDX26gZaYHQX3eVBzt
         bgymv2ZejYFrSRx0x7ukoAiw4moGzZfmFTj3MUH6YdscaTVJ0r3nOpdQCalApdMh5g
         GbB5ajJLTNyvQ==
Date:   Fri, 6 Aug 2021 22:33:27 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Chen Li <chenli@uniontech.com>
Cc:     herbert <herbert@gondor.apana.org.au>, davem <davem@davemloft.net>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: lib/sha256 - add sha256_value function
Message-ID: <YQ4bJ56Ow1hY79Lf@sol.localdomain>
References: <tencent_458D0EFD76ABAEB726882C2D@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_458D0EFD76ABAEB726882C2D@qq.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Aug 07, 2021 at 11:06:39AM +0800, Chen Li wrote:
> Add a function sha256_value() which accepts a string and store SHA256 hash
> of this string into dest.
> 
> Signed-off-by: Chen Li <chenli@uniontech.com>
> ---
>  include/crypto/sha2.h |  1 +
>  lib/crypto/sha256.c   | 23 +++++++++++++++++++++++
>  2 files changed, 24 insertions(+)
> 
> diff --git a/include/crypto/sha2.h b/include/crypto/sha2.h
> index 2838f529f31e..ce17954cab38 100644
> --- a/include/crypto/sha2.h
> +++ b/include/crypto/sha2.h
> @@ -115,6 +115,7 @@ static inline void sha256_init(struct sha256_state *sctx)
>  void sha256_update(struct sha256_state *sctx, const u8 *data, unsigned int len);
>  void sha256_final(struct sha256_state *sctx, u8 *out);
>  void sha256(const u8 *data, unsigned int len, u8 *out);
> +int  sha256_value(u8 **dest, const u8 *src);
>  
>  static inline void sha224_init(struct sha256_state *sctx)
>  {
> diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
> index 72a4b0b1df28..ce1de7a3e32e 100644
> --- a/lib/crypto/sha256.c
> +++ b/lib/crypto/sha256.c
> @@ -13,6 +13,8 @@
>  
>  #include <linux/bitops.h>
>  #include <linux/export.h>
> +#include <linux/mm.h>
> +#include <linux/slab.h>
>  #include <linux/module.h>
>  #include <linux/string.h>
>  #include <crypto/sha2.h>
> @@ -206,4 +208,25 @@ void sha256(const u8 *data, unsigned int len, u8 *out)
>  }
>  EXPORT_SYMBOL(sha256);
>  
> +int sha256_value(u8 **dest, const u8 *src)
> +{
> +	u8 out[SHA256_DIGEST_SIZE];
> +	int i, k;
> +	unsigned char hex[2];
> +
> +	*dest = kvmalloc(sizeof(u8) * (SHA256_BLOCK_SIZE + 1), GFP_KERNEL);
> +	if (ZERO_OR_NULL_PTR(*dest))
> +		return -ENOMEM;
> +	sha256(src, strlen(src), out);
> +
> +	for (i = 0, k = 0; i < SHA256_DIGEST_SIZE; i++) {
> +		sprintf(hex, "%02x", out[i]);
> +		(*dest)[k++] = hex[0];
> +		(*dest)[k++] = hex[1];
> +	}
> +	(*dest)[k] = '\0';
> +	return 0;
> +}
> +EXPORT_SYMBOL(sha256_value);

You forgot to include something that actually calls this function.

Anyway, there should be no need for this.  If you're trying to convert a SHA-256
hash value to a string, just use the %*phN printk format specifier which
converts bytes to hex.

- Eric
