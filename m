Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59559C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Oct 2022 08:16:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbiJJIQK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Oct 2022 04:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbiJJIQJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Oct 2022 04:16:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00FB580B5
        for <linux-crypto@vger.kernel.org>; Mon, 10 Oct 2022 01:16:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69FF4B80D39
        for <linux-crypto@vger.kernel.org>; Mon, 10 Oct 2022 08:16:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB8CC43142
        for <linux-crypto@vger.kernel.org>; Mon, 10 Oct 2022 08:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665389765;
        bh=B9f6M1D2jX62mSJPBxEvHGNDg2iYr2XbOaQv8AyQy9M=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=E2XnQiFPPaneN1QRX8QPk79Nh2diBDCuq40Zn0MwDZX3ipM6UP3r7M2rLOCM/2/pY
         c1e7e9+U6/5prKS5v43sSpTpf5iBEV7A5ogD1BQACdNGLZWSJscOrI0AMpqjsl1hQH
         fbg23bMgpjaDWkx7rCE3GjSigTdlxHDSXMKeu3XlG6HCaJOBGqRuW6K+IJUECpPWSU
         3nIite91F9ybeHVogTFToAOl0Z1YjF+cVDmmZvlIfR9uXOKQpBOi3zGASLNC7mLC4I
         H7dvd/JDRCj77meUxVav5IBj3zPFB5oEFCdvoqu0uSTWPaw0iDGZlEBY8GWYob3aWh
         8XvgtF8az3j8A==
Received: by mail-lf1-f41.google.com with SMTP id j4so15606391lfk.0
        for <linux-crypto@vger.kernel.org>; Mon, 10 Oct 2022 01:16:04 -0700 (PDT)
X-Gm-Message-State: ACrzQf3wp34YZ8CSG3HdYPSKMm+v4YKcPPWz5ExkOGi3oU5rmOAunXQf
        8nUaU+vM2KL1XLXLOLtEP83iDZt8Y7evZMBxyYM=
X-Google-Smtp-Source: AMsMyM5WisfRQFTUyjENCaV+ThICoLFtIdTPZ56yVTiKKYxkf5AYtDL+EQFS0zV+0duw450b/Bqkj1RTE/Sz8B384v0=
X-Received: by 2002:a19:c20b:0:b0:4a2:40e5:78b1 with SMTP id
 l11-20020a19c20b000000b004a240e578b1mr6147903lfc.228.1665389763060; Mon, 10
 Oct 2022 01:16:03 -0700 (PDT)
MIME-Version: 1.0
References: <20221007152105.3057788-1-ardb@kernel.org> <3e395ad2-48f6-87f6-9042-a3ca21c0baba@amd.com>
In-Reply-To: <3e395ad2-48f6-87f6-9042-a3ca21c0baba@amd.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 10 Oct 2022 10:15:51 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGNXYvS9_-RwzzO-VeZN8+ZErhxGiCbfbBA5thJ84RxYA@mail.gmail.com>
Message-ID: <CAMj1kXGNXYvS9_-RwzzO-VeZN8+ZErhxGiCbfbBA5thJ84RxYA@mail.gmail.com>
Subject: Re: [PATCH] crypto: gcm - Provide minimal library implementation
To:     "Nikunj A. Dadhania" <nikunj@amd.com>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        ebiggers@kernel.org, keescook@chromium.org, jason@zx2c4.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 10 Oct 2022 at 09:27, Nikunj A. Dadhania <nikunj@amd.com> wrote:
>
> Hi Ard,
>
> On 07/10/22 20:51, Ard Biesheuvel wrote:
> > Implement a minimal library version of GCM based on the existing library
> > implementations of AES and multiplication in GF(2^128). Using these
> > primitives, GCM can be implemented in a straight-forward manner.
> >
> > GCM has a couple of sharp edges, i.e., the amount of input data
> > processed with the same initialization vector (IV) should be capped to
> > protect the counter from 32-bit rollover (or carry), and the size of the
> > authentication tag should be fixed for a given key. [0]
> >
> > The former concern is addressed trivially, given that the function call
> > API uses 32-bit signed types for the input lengths. It is still up to
> > the caller to avoid IV reuse in general, but this is not something we
> > can police at the implementation level.
> >
> > As for the latter concern, let's make the authentication tag size part
> > of the key schedule, and only permit it to be configured as part of the
> > key expansion routine.
> >
> > Note that table based AES implementations are susceptible to known
> > plaintext timing attacks on the encryption key. The AES library already
> > attempts to mitigate this to some extent, but given that the counter
> > mode encryption used by GCM operates exclusively on known plaintext by
> > construction (the IV and therefore the initial counter value are known
> > to an attacker), let's take some extra care to mitigate this, by calling
> > the AES library with interrupts disabled.
> >
> > [0] https://nvlpubs.nist.gov/nistpubs/legacy/sp/nistspecialpublication800-38d.pdf
> >
> > Cc: "Nikunj A. Dadhania" <nikunj@amd.com>
> > Link: https://lore.kernel.org/all/c6fb9b25-a4b6-2e4a-2dd1-63adda055a49@amd.com/
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> > +/**
> > + * gcm_decrypt - Perform GCM decryption on a block of data
> > + * @ctx:     The GCM key schedule
> > + * @dst:     Pointer to the plaintext output buffer
> > + * @src:     Pointer the ciphertext (may equal @dst for decryption in place)
> > + * @crypt_len:       The size in bytes of the plaintext and ciphertext.
> > + * @assoc:   Pointer to the associated data,
> > + * @assoc_len:       The size in bytes of the associated data
> > + * @iv:              The initialization vector (IV) to use for this block of data
> > + *           (must be 12 bytes in size as per the GCM spec recommendation)
> > + * @authtag: The address of the buffer in memory where the authentication
> > + *           tag is stored.
> > + *
> > + * Returns 0 on success, or -EBADMSG if the ciphertext failed authentication.
> > + * On failure, no plaintext will be returned.
> > + */
> > +int __must_check gcm_decrypt(const struct gcm_ctx *ctx, u8 *dst, const u8 *src,
> > +                          int crypt_len, const u8 *assoc, int assoc_len,
> > +                          const u8 iv[GCM_AES_IV_SIZE], const u8 *authtag)
> > +{
> > +     u8 tagbuf[AES_BLOCK_SIZE];
> > +     __be32 ctr[4];
> > +
> > +     memcpy(ctr, iv, GCM_AES_IV_SIZE);
> > +
> > +     gcm_mac(ctx, src, crypt_len, assoc, assoc_len, ctr, tagbuf);
> > +     if (crypto_memneq(authtag, tagbuf, ctx->authsize)) {
> > +             memzero_explicit(tagbuf, sizeof(tagbuf));
> > +             return -EBADMSG;
> > +     }
>
> The gcm_mac computation seems to be broken in this version. When I receive the encrypted
> packet back from the security processor the authtag does not match. Will debug further
> and report back.
>

Sorry to hear that. If you find out what's wrong, can you please
provide a test vector that reproduces it so we can add it to the list?
