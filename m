Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BFEFC48BDF
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Jun 2021 23:19:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C6E5613F5
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Jun 2021 23:19:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbhFJXVg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Jun 2021 19:21:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:52178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230212AbhFJXVf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Jun 2021 19:21:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DE0D613CB;
        Thu, 10 Jun 2021 23:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623367178;
        bh=ABUBXcQetZjJYDHEJU4gE1xB6jxKYpJ007+1HHni69k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gJQk4dL+oaaSh7lv0haLYu3WPkfNq8qxzgzF2ItGERpIMb3/lT2YE7U500XG7FJLT
         UkQCXOJX5JPCIijZMKJd9Px1oVQ3LWfoKqRYM7GvDSwnMPi6YpkPhECW3FFrII6/dL
         nu+I1vSGPcELw+IP1IxvsY+sR4Avp7ouN5XqDQZ9yLZnYl4lB+zZnpRjO53hiSsTKI
         yMx94mFgcHqpaog4X7wbFZ9ruwfAdP1qvqmApmCza4hCCxhyEsp0wsTk1Na761+f7E
         +YGOPx6bSI6NbAOa/JLfykAUcwzt6XHNR/RwJq6oXj5XoXxYG/fwQo0MIyh/SNtQ8b
         pYCqtklYF48tg==
Date:   Thu, 10 Jun 2021 16:19:36 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "Markku-Juhani O . Saarinen" <mjos@iki.fi>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] crypto: sm4 - create SM4 library based on sm4
 generic code
Message-ID: <YMKeCIfSWZCVX+BT@gmail.com>
References: <20210610134459.28541-1-tianjia.zhang@linux.alibaba.com>
 <20210610134459.28541-2-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210610134459.28541-2-tianjia.zhang@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 10, 2021 at 09:44:57PM +0800, Tianjia Zhang wrote:
> Take the existing small footprint and mostly time invariant C code

It is using an S-box without any prefetching.  That doesn't look very
"time invariant" to me.

> diff --git a/lib/crypto/sm4.c b/lib/crypto/sm4.c
> new file mode 100644
> index 000000000000..cbdd14a254d0
[..]
> +/**
> + * crypto_sm4_expand_key - Expands the SM4 key as described in GB/T 32907-2016
> + * @ctx:	The location where the computed key will be stored.
> + * @in_key:	The supplied key.
> + * @key_len:	The length of the supplied key.
> + *
> + * Returns 0 on success. The function fails only if an invalid key size (or
> + * pointer) is supplied.
> + */
> +int crypto_sm4_expand_key(struct crypto_sm4_ctx *ctx, const u8 *in_key,
> +			  unsigned int key_len)
[...]
> +/**
> + * crypto_sm4_do_crypt - Encrypt or decrypt a single SM4 block
> + * @rk:		The rkey_enc for encrypt or rkey_dec for decrypt
> + * @out:	Buffer to store output data
> + * @in: 	Buffer containing the input data
> + */
> +void crypto_sm4_do_crypt(const u32 *rk, u8 *out, const u8 *in)

Calling these "sm4_expandkey()" and "sm4_crypt_block()" would be more consistent
with the other lib/crypto/ functions such as the AES ones.  The other
lib/crypto/ functions don't have a "crypto_" prefix, as that is used for
functions related to the traditional crypto API rather than the library API.

- Eric
