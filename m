Return-Path: <SRS0=USLa=UP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE9DEC31E50
	for <linux-crypto@archiver.kernel.org>; Sun, 16 Jun 2019 19:04:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8090120665
	for <linux-crypto@archiver.kernel.org>; Sun, 16 Jun 2019 19:04:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SKEZmeWX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbfFPTEM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 16 Jun 2019 15:04:12 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:42429 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbfFPTEM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 16 Jun 2019 15:04:12 -0400
Received: by mail-io1-f65.google.com with SMTP id u19so16544420ior.9
        for <linux-crypto@vger.kernel.org>; Sun, 16 Jun 2019 12:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K+O1vROgbaIC00QQ7pa++UCFLreWPFhc0fVLESZ4iss=;
        b=SKEZmeWXoFE9YRlGE9AX2wfJf6hC0tKLC8XcG19tli8hxkgYr6hSkOV0caYlpakBRj
         39oj0z9ImhRVMK4vaFycjnSTM1jndDio6Sobhk7Zvjl9oQ2fx9Ff76I7ao8GF0f/5yGA
         xhFFyA8VTySR+E7hrGWkdtms5rYHujBCK+JPWAR10r2aTadJP6V+cjAn+gsSbFsf8Fs4
         p76G8zIIr+JzKnGPjT2wrS2LByiEl7IuP9xxJAoN2Su20bL0rC7OWPuhf8KmXPJPN3QC
         kOnaDcYmDv0zeOkCUfDtMdTrS70d/OhH5vI6Y+ocZTMpcJa47ezr2snMHozEGflzqAan
         f54g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K+O1vROgbaIC00QQ7pa++UCFLreWPFhc0fVLESZ4iss=;
        b=RZ3QDl44fJ1aGIfKgglEWjZaAJmNwIxDYJwMX/5ej4f926ujAtDTbcAzY3dYLSID8O
         ksw/ngEfaKyWS0H6u+ilHSotxBUtx47KsOdjgDcjismQgN3Ou4F24mNJ1Fnppm/srKNk
         8Kodpodws8NmdDWaw/4flzfGYxXYyULRIXM6VvOu75VedL1Zn4Y2ORW/oqGJ80nstmzs
         o3ubqyG+ge/XI1qGiV6+YFVAzS4P7TreiepalxjJ65Sp6+VMvRTE96IDH/bjPd+LzTcY
         9aBLJCpj5lX6dRSCG7uSKxaqsLfotXl60iO0uwbfXpNFVrX+YEdlKQnxDmNTaqBqO1AA
         QahA==
X-Gm-Message-State: APjAAAVZ1phk8aeqeTBREybA/vOAuc55cO330Qyikj839iGLfh4UdBFj
        L9HvgILuqnsZp4YWRF3sYiqnxcHaid2CbIkw0yCUTg==
X-Google-Smtp-Source: APXvYqzW11J9cuTueAtc+f/K3UoctbM7IHAGBhyShw3khGyMHGGZ+nvFH/XGf/gAdflu0kWR86DBMOOTbrRT9pFIi6M=
X-Received: by 2002:a02:c90d:: with SMTP id t13mr57853661jao.62.1560711851475;
 Sun, 16 Jun 2019 12:04:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190614093603.22771-1-ard.biesheuvel@linaro.org> <20190616071206.GB698@sol.localdomain>
In-Reply-To: <20190616071206.GB698@sol.localdomain>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sun, 16 Jun 2019 21:03:58 +0200
Message-ID: <CAKv+Gu97xkz5qxycyjqmukFhWAD6p=eYbTqoPWt-ZNbBFDbNAw@mail.gmail.com>
Subject: Re: [PATCH] wireless: airo: switch to skcipher interface
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, 16 Jun 2019 at 09:12, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Fri, Jun 14, 2019 at 11:36:03AM +0200, Ard Biesheuvel wrote:
> > The AIRO driver applies a ctr(aes) on a buffer of considerable size
> > (2400 bytes), and instead of invoking the crypto API to handle this
> > in its entirety, it open codes the counter manipulation and invokes
> > the AES block cipher directly.
> >
> > Let's fix this, by switching to the sync skcipher API instead.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> > NOTE: build tested only, since I don't have the hardware
> >
> >  drivers/net/wireless/cisco/airo.c | 57 ++++++++++----------
> >  1 file changed, 27 insertions(+), 30 deletions(-)
> >
>
> Need to also select CRYPTO_CTR in drivers/net/wireless/cisco/Kconfig under
> AIRO_CS, and I think also CRYPTO_BLKCIPHER under AIRO.
>

OK

> > diff --git a/drivers/net/wireless/cisco/airo.c b/drivers/net/wireless/cisco/airo.c
> > index 3f5a14112c6b..2d29ad10505b 100644
> > --- a/drivers/net/wireless/cisco/airo.c
> > +++ b/drivers/net/wireless/cisco/airo.c
> > @@ -49,6 +49,9 @@
> >  #include <linux/kthread.h>
> >  #include <linux/freezer.h>
> >
> > +#include <crypto/aes.h>
> > +#include <crypto/skcipher.h>
> > +
> >  #include <net/cfg80211.h>
> >  #include <net/iw_handler.h>
> >
> > @@ -951,7 +954,7 @@ typedef struct {
> >  } mic_statistics;
> >
> >  typedef struct {
> > -     u32 coeff[((EMMH32_MSGLEN_MAX)+3)>>2];
> > +     __be32 coeff[((EMMH32_MSGLEN_MAX)+3)>>2];
> >       u64 accum;      // accumulated mic, reduced to u32 in final()
> >       int position;   // current position (byte offset) in message
> >       union {
> > @@ -1216,7 +1219,7 @@ struct airo_info {
> >       struct iw_spy_data      spy_data;
> >       struct iw_public_data   wireless_data;
> >       /* MIC stuff */
> > -     struct crypto_cipher    *tfm;
> > +     struct crypto_sync_skcipher     *tfm;
> >       mic_module              mod[2];
> >       mic_statistics          micstats;
> >       HostRxDesc rxfids[MPI_MAX_FIDS]; // rx/tx/config MPI350 descriptors
> > @@ -1291,14 +1294,14 @@ static int flashrestart(struct airo_info *ai,struct net_device *dev);
> >  static int RxSeqValid (struct airo_info *ai,miccntx *context,int mcast,u32 micSeq);
> >  static void MoveWindow(miccntx *context, u32 micSeq);
> >  static void emmh32_setseed(emmh32_context *context, u8 *pkey, int keylen,
> > -                        struct crypto_cipher *tfm);
> > +                        struct crypto_sync_skcipher *tfm);
> >  static void emmh32_init(emmh32_context *context);
> >  static void emmh32_update(emmh32_context *context, u8 *pOctets, int len);
> >  static void emmh32_final(emmh32_context *context, u8 digest[4]);
> >  static int flashpchar(struct airo_info *ai,int byte,int dwelltime);
> >
> >  static void age_mic_context(miccntx *cur, miccntx *old, u8 *key, int key_len,
> > -                         struct crypto_cipher *tfm)
> > +                         struct crypto_sync_skcipher *tfm)
> >  {
> >       /* If the current MIC context is valid and its key is the same as
> >        * the MIC register, there's nothing to do.
> > @@ -1359,7 +1362,7 @@ static int micsetup(struct airo_info *ai) {
> >       int i;
> >
> >       if (ai->tfm == NULL)
> > -             ai->tfm = crypto_alloc_cipher("aes", 0, 0);
> > +             ai->tfm = crypto_alloc_sync_skcipher("ctr(aes)", 0, 0);
> >
> >          if (IS_ERR(ai->tfm)) {
> >                  airo_print_err(ai->dev->name, "failed to load transform for AES");
> > @@ -1624,37 +1627,31 @@ static void MoveWindow(miccntx *context, u32 micSeq)
> >
> >  /* mic accumulate */
> >  #define MIC_ACCUM(val)       \
> > -     context->accum += (u64)(val) * context->coeff[coeff_position++];
> > -
> > -static unsigned char aes_counter[16];
> > +     context->accum += (u64)(val) * be32_to_cpu(context->coeff[coeff_position++]);
>
> You could alternatively call be32_to_cpu_array() after the AES encryption.
> But this works too.
>
> >
> >  /* expand the key to fill the MMH coefficient array */
> >  static void emmh32_setseed(emmh32_context *context, u8 *pkey, int keylen,
> > -                        struct crypto_cipher *tfm)
> > +                        struct crypto_sync_skcipher *tfm)
> >  {
> >    /* take the keying material, expand if necessary, truncate at 16-bytes */
> >    /* run through AES counter mode to generate context->coeff[] */
> >
> > -     int i,j;
> > -     u32 counter;
> > -     u8 *cipher, plain[16];
> > -
> > -     crypto_cipher_setkey(tfm, pkey, 16);
> > -     counter = 0;
> > -     for (i = 0; i < ARRAY_SIZE(context->coeff); ) {
> > -             aes_counter[15] = (u8)(counter >> 0);
> > -             aes_counter[14] = (u8)(counter >> 8);
> > -             aes_counter[13] = (u8)(counter >> 16);
> > -             aes_counter[12] = (u8)(counter >> 24);
> > -             counter++;
> > -             memcpy (plain, aes_counter, 16);
> > -             crypto_cipher_encrypt_one(tfm, plain, plain);
> > -             cipher = plain;
> > -             for (j = 0; (j < 16) && (i < ARRAY_SIZE(context->coeff)); ) {
> > -                     context->coeff[i++] = ntohl(*(__be32 *)&cipher[j]);
> > -                     j += 4;
> > -             }
> > -     }
> > +     SYNC_SKCIPHER_REQUEST_ON_STACK(req, tfm);
> > +     struct scatterlist dst, src;
> > +     u8 iv[AES_BLOCK_SIZE] = {};
> > +     int ret;
> > +
> > +     crypto_sync_skcipher_setkey(tfm, pkey, 16);
> > +
> > +     sg_init_one(&dst, context->coeff, sizeof(context->coeff));
> > +     sg_init_one(&src, page_address(ZERO_PAGE(0)), sizeof(context->coeff));
>
> Should add:
>
>         BUILD_BUG_ON(sizeof(context->coeff) > PAGE_SIZE);
>
> Or alternatively, instead of using ZERO_PAGE, just memset() the buffer to zero
> and encrypt it in-place.  That would be less fragile.
>

I agree, I will change that.

> > +
> > +     skcipher_request_set_sync_tfm(req, tfm);
> > +     skcipher_request_set_callback(req, 0, NULL, NULL);
> > +     skcipher_request_set_crypt(req, &src, &dst, sizeof(context->coeff), iv);
> > +
> > +     ret = crypto_skcipher_encrypt(req);
> > +     WARN_ON_ONCE(ret);
> >  }
> >
> >  /* prepare for calculation of a new mic */
> > @@ -2415,7 +2412,7 @@ void stop_airo_card( struct net_device *dev, int freeres )
> >                               ai->shared, ai->shared_dma);
> >               }
> >          }
> > -     crypto_free_cipher(ai->tfm);
> > +     crypto_free_sync_skcipher(ai->tfm);
> >       del_airo_dev(ai);
> >       free_netdev( dev );
> >  }
> > --
> > 2.20.1
> >
>
> Otherwise this patch looks correct to me.
>
> The actual crypto in this driver, on the other hand, looks very outdated and
> broken.  Apparently it's implementing some Cisco proprietary extension to WEP
> that uses a universal hashing based MAC, where the hash key is generated from
> AES-CTR.  But the MAC is only 32 bits, and the universal hash (MMH) is
> implemented incorrectly: there's an off-by-one error in emmh32_final() in the
> code that is supposed to be an optimized version of 'sum % ((1ULL << 32) + 15)'.
>

I stared at that code for a bit, and I don't see the problem.

> Do we know whether anyone is actually using this, or is this just another old
> driver that's sitting around unused?
>

Excellent question. I take it this is pre-802.11b hardware, and so
even the OpenWRT people are unlikely to still be using this.
