Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EED87C4332F
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Nov 2022 10:41:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbiKDKlN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Nov 2022 06:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiKDKlM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Nov 2022 06:41:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 074EF2633
        for <linux-crypto@vger.kernel.org>; Fri,  4 Nov 2022 03:41:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E43CA62093
        for <linux-crypto@vger.kernel.org>; Fri,  4 Nov 2022 10:41:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B93C433C1
        for <linux-crypto@vger.kernel.org>; Fri,  4 Nov 2022 10:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667558470;
        bh=x6RXnSCC8R1Q4IWqepjMiDryZOO2RhDAxFMu+AxeR2I=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=gRgdkgJr2Ie4bqa45xrhYEWg+UFYPjgUBFnhiHMAhGnUW+JX4wn6tQPups4+nIZLN
         MSmAoU62jAtBrJx5UWg5bGfHqqFgFBso9oThsto7qkqKsYURKIAc35zbPnNb6Ok+6D
         k8PDJWB0BvnhsHAauTFSvHyj9esCZB5zBjE7LfXoiQ1eBu/0EHSjFV95g8jAtcVbfN
         zRN3f5dV/16ky6H1JefDqgPL8jUFGjFTfMjfoUPRXt45pEeET4A2a0EmhbQSV8sBDT
         ntQb780O+iFUKOvOKEtweRCOVJr8OrSgPvxgsvmURSe9ytb7DO+RjmDZMSCakenLuS
         bUBHiAZsKdRWg==
Received: by mail-lj1-f176.google.com with SMTP id s24so5720447ljs.11
        for <linux-crypto@vger.kernel.org>; Fri, 04 Nov 2022 03:41:10 -0700 (PDT)
X-Gm-Message-State: ACrzQf2qumm6ihRgaVuOUgFBmlFp/LAqCtz8wssBmi+u6KU4kW9eOTam
        IrXpaHbeok78nMNGZdKV7W0FKNE/M+bOn7zefLs=
X-Google-Smtp-Source: AMsMyM5Q4HE1M3fj+M4pxPC7xJH/5eTkuWr982BXKYuDn/jWij3hVsxaWqnHuRdxUu42n2xi/bOtiwudKsV3xt0T+UM=
X-Received: by 2002:a2e:3a1a:0:b0:277:7eef:1d97 with SMTP id
 h26-20020a2e3a1a000000b002777eef1d97mr637408lja.516.1667558468353; Fri, 04
 Nov 2022 03:41:08 -0700 (PDT)
MIME-Version: 1.0
References: <20221103192259.2229-1-ardb@kernel.org> <20221103192259.2229-4-ardb@kernel.org>
 <MW5PR84MB18427E0F1886F8A0273A8553AB389@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <MW5PR84MB18427E0F1886F8A0273A8553AB389@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 4 Nov 2022 11:40:56 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHbG2o+-xSva0tcptNK77L8Ve8zXkftOFxCrDkqtz+rTg@mail.gmail.com>
Message-ID: <CAMj1kXHbG2o+-xSva0tcptNK77L8Ve8zXkftOFxCrDkqtz+rTg@mail.gmail.com>
Subject: Re: [PATCH v5 3/3] crypto: aesgcm - Provide minimal library implementation
To:     "Elliott, Robert (Servers)" <elliott@hpe.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "keescook@chromium.org" <keescook@chromium.org>,
        Eric Biggers <ebiggers@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Nikunj A Dadhania <nikunj@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 3 Nov 2022 at 22:16, Elliott, Robert (Servers) <elliott@hpe.com> wrote:
>
>
>
> > -----Original Message-----
> > From: Ard Biesheuvel <ardb@kernel.org>
> > Sent: Thursday, November 3, 2022 2:23 PM
> > Subject: [PATCH v5 3/3] crypto: aesgcm - Provide minimal library implementation
> >
>
> Given include/crypto/aes.h:
> struct crypto_aes_ctx {
>         u32 key_enc[AES_MAX_KEYLENGTH_U32];
>         u32 key_dec[AES_MAX_KEYLENGTH_U32];
>         u32 key_length;
> };
>
> plus:
> ...
> +struct aesgcm_ctx {
> +       be128                   ghash_key;
> +       struct crypto_aes_ctx   aes_ctx;
> +       unsigned int            authsize;
> +};
> ...
> > +static void aesgcm_encrypt_block(const struct crypto_aes_ctx *ctx, void *dst,
> ...
> > +     local_irq_save(flags);
> > +     aes_encrypt(ctx, dst, src);
> > +     local_irq_restore(flags);
> > +}
> ...
> > +int aesgcm_expandkey(struct aesgcm_ctx *ctx, const u8 *key,
> > +                  unsigned int keysize, unsigned int authsize)
> > +{
> > +     u8 kin[AES_BLOCK_SIZE] = {};
> > +     int ret;
> > +
> > +     ret = crypto_gcm_check_authsize(authsize) ?:
> > +           aes_expandkey(&ctx->aes_ctx, key, keysize);
>
> Since GCM uses the underlying cipher's encrypt algorithm for both
> encryption and decryption, is there any need for the 240-byte
> aesctx->key_dec decryption key schedule that aes_expandkey
> also prepares?
>

No. But this applies to all uses of AES in CTR, XCTR, CMAC, CCM modes,
not just to the AES library.

> For modes like this, it might be worth creating a specialized
> struct that only holds the encryption key schedule (key_enc),
> with a derivative of aes_expandkey() that only updates it.
>

I'm not sure what problem we would be solving here tbh. AES key
expansion is unlikely to occur on a hot path, and the 240 byte
overhead doesn't seem that big of a deal either.

Note that only full table based C implementations of AES have a need
for the decryption key schedule, the AES library version could be
tweaked to use the encryption key schedule for decryption as well (see
below). But the instruction based versions are constructed in a way
that also requires the modified schedule for decryption.

So I agree that there appears to be /some/ room for improvement here,
but I'm not sure it's worth anyone's time tbh. We could explore
splitting off the expandkey routine that is exposed to other AES
implementations, and use a reduced schedule inside the library itself.

Beyond that, I don't see the need to clutter up the API and force all
AES code in the tree to choose between an encryption-only or a full
key schedule.


-------------8<-----------------
--- a/lib/crypto/aes.c
+++ b/lib/crypto/aes.c
@@ -310,3 +310,3 @@
 {
-       const u32 *rkp = ctx->key_dec + 4;
+       const u32 *rkp = ctx->key_enc + ctx->key_length + 16;
        int rounds = 6 + ctx->key_length / 4;
@@ -315,6 +315,6 @@

-       st0[0] = ctx->key_dec[0] ^ get_unaligned_le32(in);
-       st0[1] = ctx->key_dec[1] ^ get_unaligned_le32(in + 4);
-       st0[2] = ctx->key_dec[2] ^ get_unaligned_le32(in + 8);
-       st0[3] = ctx->key_dec[3] ^ get_unaligned_le32(in + 12);
+       st0[0] = rkp[ 8] ^ get_unaligned_le32(in);
+       st0[1] = rkp[ 9] ^ get_unaligned_le32(in + 4);
+       st0[2] = rkp[10] ^ get_unaligned_le32(in + 8);
+       st0[3] = rkp[11] ^ get_unaligned_le32(in + 12);

@@ -331,7 +331,7 @@

-       for (round = 0;; round += 2, rkp += 8) {
-               st1[0] = inv_mix_columns(inv_subshift(st0, 0)) ^ rkp[0];
-               st1[1] = inv_mix_columns(inv_subshift(st0, 1)) ^ rkp[1];
-               st1[2] = inv_mix_columns(inv_subshift(st0, 2)) ^ rkp[2];
-               st1[3] = inv_mix_columns(inv_subshift(st0, 3)) ^ rkp[3];
+       for (round = 0;; round += 2, rkp -= 8) {
+               st1[0] = inv_mix_columns(inv_subshift(st0, 0) ^ rkp[4]);
+               st1[1] = inv_mix_columns(inv_subshift(st0, 1) ^ rkp[5]);
+               st1[2] = inv_mix_columns(inv_subshift(st0, 2) ^ rkp[6]);
+               st1[3] = inv_mix_columns(inv_subshift(st0, 3) ^ rkp[7]);

@@ -340,12 +340,12 @@

-               st0[0] = inv_mix_columns(inv_subshift(st1, 0)) ^ rkp[4];
-               st0[1] = inv_mix_columns(inv_subshift(st1, 1)) ^ rkp[5];
-               st0[2] = inv_mix_columns(inv_subshift(st1, 2)) ^ rkp[6];
-               st0[3] = inv_mix_columns(inv_subshift(st1, 3)) ^ rkp[7];
+               st0[0] = inv_mix_columns(inv_subshift(st1, 0) ^ rkp[0]);
+               st0[1] = inv_mix_columns(inv_subshift(st1, 1) ^ rkp[1]);
+               st0[2] = inv_mix_columns(inv_subshift(st1, 2) ^ rkp[2]);
+               st0[3] = inv_mix_columns(inv_subshift(st1, 3) ^ rkp[3]);
        }

-       put_unaligned_le32(inv_subshift(st1, 0) ^ rkp[4], out);
-       put_unaligned_le32(inv_subshift(st1, 1) ^ rkp[5], out + 4);
-       put_unaligned_le32(inv_subshift(st1, 2) ^ rkp[6], out + 8);
-       put_unaligned_le32(inv_subshift(st1, 3) ^ rkp[7], out + 12);
+       put_unaligned_le32(inv_subshift(st1, 0) ^ rkp[0], out);
+       put_unaligned_le32(inv_subshift(st1, 1) ^ rkp[1], out + 4);
+       put_unaligned_le32(inv_subshift(st1, 2) ^ rkp[2], out + 8);
+       put_unaligned_le32(inv_subshift(st1, 3) ^ rkp[3], out + 12);
