Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F326CC48BD7
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 17:52:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE0342086D
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 17:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561657956;
	bh=WZ7rXnnnAnrb96btAiRFvykHZa25vzbyKG+semorW/w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=IB3Ask1AQSkilYifFgJV2c9EKe1A686H9IMWOM018LoDUDMZQGE9NXug38WdjPPPr
	 CM7/zlIbBLaJG6uNP2L5zE603c58O4n8mgh1seLSvnH2HHmPN1o67xDBhQrBsTPvKO
	 4n4gChwKND2uoHnBnmRliRb962EBV6a6MJqanajQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbfF0Rwg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 13:52:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726405AbfF0Rwf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 13:52:35 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A91FE20659;
        Thu, 27 Jun 2019 17:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561657954;
        bh=WZ7rXnnnAnrb96btAiRFvykHZa25vzbyKG+semorW/w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FpW4KiX6yjztudsxjUS9ymUbuSgRar8XjoKm+tIq+tzezsbed8GNxodos3lVYR1oF
         CTYgDc0x6E4jb8xFJQDs1zIUiZ2ovdKNBndkSeH83/HU8tOk+dT0/FRJfeff/qNNWS
         LfhZZY849OyKpVDWUTU9CmgVWoGPKlV6oeFarnRo=
Date:   Thu, 27 Jun 2019 10:52:33 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Subject: Re: [PATCH v3 28/32] crypto: lib/aes - export sbox and inverse sbox
Message-ID: <20190627175233.GI686@sol.localdomain>
References: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
 <20190627102647.2992-29-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190627102647.2992-29-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 27, 2019 at 12:26:43PM +0200, Ard Biesheuvel wrote:
> There are a few copies of the AES S-boxes floating around, so export
> the ones from the AES library so that we can reuse them in other
> modules.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  include/crypto/aes.h | 3 +++
>  lib/crypto/aes.c     | 6 ++++++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/include/crypto/aes.h b/include/crypto/aes.h
> index df8426fd8051..8e0f4cf948e5 100644
> --- a/include/crypto/aes.h
> +++ b/include/crypto/aes.h
> @@ -67,4 +67,7 @@ void aes_encrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in);
>   */
>  void aes_decrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in);
>  
> +extern const u8 crypto_aes_sbox[];
> +extern const u8 crypto_aes_inv_sbox[];
> +
>  #endif
> diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
> index 9928b23e0a8a..467f0c35a0e0 100644
> --- a/lib/crypto/aes.c
> +++ b/lib/crypto/aes.c
> @@ -82,6 +82,12 @@ static volatile const u8 __cacheline_aligned aes_inv_sbox[] = {
>  	0xe1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0c, 0x7d,
>  };
>  
> +extern const u8 crypto_aes_sbox[] __alias(aes_sbox);
> +extern const u8 crypto_aes_inv_sbox[] __alias(aes_inv_sbox);
> +
> +EXPORT_SYMBOL(crypto_aes_sbox);
> +EXPORT_SYMBOL(crypto_aes_inv_sbox);

I got a compiler warning:

In file included from ./include/linux/linkage.h:7,
                 from ./include/linux/kernel.h:8,
                 from ./include/linux/crypto.h:16,
                 from ./include/crypto/aes.h:10,
                 from lib/crypto/aes.c:6:
lib/crypto/aes.c:88:15: warning: array ‘crypto_aes_sbox’ assumed to have one element
 EXPORT_SYMBOL(crypto_aes_sbox);
               ^~~~~~~~~~~~~~~
./include/linux/export.h:79:21: note: in definition of macro ‘___EXPORT_SYMBOL’
  extern typeof(sym) sym;      \
                     ^~~
lib/crypto/aes.c:88:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(crypto_aes_sbox);
 ^~~~~~~~~~~~~
lib/crypto/aes.c:89:15: warning: array ‘crypto_aes_inv_sbox’ assumed to have one element
 EXPORT_SYMBOL(crypto_aes_inv_sbox);
               ^~~~~~~~~~~~~~~~~~~
./include/linux/export.h:79:21: note: in definition of macro ‘___EXPORT_SYMBOL’
  extern typeof(sym) sym;      \
                     ^~~
lib/crypto/aes.c:89:1: note: in expansion of macro ‘EXPORT_SYMBOL’
 EXPORT_SYMBOL(crypto_aes_inv_sbox);
 ^~~~~~~~~~~~~
