Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1AA9C48BD6
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 14:54:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79D2620663
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 14:54:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SIWWtQm2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbfF0OyS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 10:54:18 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:33585 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfF0OyS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 10:54:18 -0400
Received: by mail-io1-f66.google.com with SMTP id u13so5432008iop.0
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 07:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A4LCBTaYRXrsX4E9QKFNQdfy6GTJOtOV58Fj+099ZqQ=;
        b=SIWWtQm2kw9dRBls3rus1b4eZm6S8bytfgpZR21KUdsbKiy2Eo3Wsgtks0QfFtxWjP
         KK1+qwlUp0qpLKp/AweUVXQzziaCBLrUNGDwVP5NypiT3CiOsJsbBXZ9EzbPlqeP+0IC
         ZuGRJVz9/NPBqQmahF92m98RA6pKgGFbE6PfnGAT3Th1m65ss2BekHMemiZIBzZ/xZEK
         7UMmEM7DHVeoJL+FsW7XiJT7AoVyMCuZC8e1RgRWsrd1fD4xuVmfJ/k10cOqp600hlxJ
         snl2uNUN+i4sg786106Lrs14rWeGe5JxLW2q+ToWVZm/xmlhQEo1Fu39fldCTQp1u8Sw
         Jfzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A4LCBTaYRXrsX4E9QKFNQdfy6GTJOtOV58Fj+099ZqQ=;
        b=rEIfjb+qlmDtsNLzxZPJJN+5dZvs8LC5l66DHwCbhqGki3Hr+g0R49Kl5G7MXQKJ22
         vZkr7QNRA+niZhVM7Jpq+it+CssnO5Z3K4GOZIXKrWGz25yHps5wCuHYCG/pb4yYbSQH
         IStGeOtZGRrJlatU2mUCeyENbu22J0bo5du/F0TDmjCBvVxjU3fXORKE1Pw+FL6trN7r
         +kY4JJs590hgycQtnQ6jPIZVLUtBL6+BlOsqGktKrG8EYO100nNs78OrU5aLmQRNJ0XN
         29q1KYi8n6MSm4bC0ZBEWxiYUUiId+SRIhvLjNHdcEQnAw5hUD8aqhhahP5QlIoOEdwS
         6XRg==
X-Gm-Message-State: APjAAAWtmtBhGrvZUtbygSitBeguek9jOc5PD1wYrjldVsDO7XY8Es1k
        jSyKllkITAO8c9H5deej4q9dvOqOHSqnaL3N+at6EXHMBMg=
X-Google-Smtp-Source: APXvYqwhCBV/qFvm+1A+te+UJwH9tRm4vrYtbvaimiLu3x4LgZKDdIHa3u40ewQvW4u9+N/79WdxbjrmnJIMW17LBsg=
X-Received: by 2002:a5e:820a:: with SMTP id l10mr4863563iom.283.1561647257630;
 Thu, 27 Jun 2019 07:54:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190627120314.7197-1-ard.biesheuvel@linaro.org>
 <VI1PR0402MB348548C6873044033C94F63998FD0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAKv+Gu-JtxJ9KHRx6f6pAKKd17BojJqy-nrju64oKTT0tM2KrA@mail.gmail.com>
In-Reply-To: <CAKv+Gu-JtxJ9KHRx6f6pAKKd17BojJqy-nrju64oKTT0tM2KrA@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 27 Jun 2019 16:54:05 +0200
Message-ID: <CAKv+Gu_v5e0q=txrTNKvpNi-qr=QF2P7DTHTZ2qXOZi_ot=EVQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/30] crypto: DES/3DES cleanup
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 27 Jun 2019 at 16:50, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> On Thu, 27 Jun 2019 at 16:44, Horia Geanta <horia.geanta@nxp.com> wrote:
> >
> > On 6/27/2019 3:03 PM, Ard Biesheuvel wrote:
> > > n my effort to remove crypto_alloc_cipher() invocations from non-crypto
> > > code, i ran into a DES call in the CIFS driver. This is addressed in
> > > patch #30.
> > >
> > > The other patches are cleanups for the quirky DES interface, and lots
> > > of duplication of the weak key checks etc.
> > >
> > > Changes since vpub/scm/linux/kernel/git/arm64/linux.git/log/?h=for-next/fixes1/RFC:
> > > - fix build errors in various drivers that i failed to catch in my
> > >   initial testing
> > > - put all caam changes into the correct patch
> > > - fix weak key handling error flagged by the self tests, as reported
> > >   by Eric.
> > I am seeing a similar (?) issue:
> > alg: skcipher: ecb-des-caam setkey failed on test vector 4; expected_error=-22, actual_error=-126, flags=0x100101
> >
> > crypto_des_verify_key() in include/crypto/internal/des.h returns -ENOKEY,
> > while testmgr expects -EINVAL (setkey_error = -EINVAL in the test vector).
> >
> > I assume crypto_des_verify_key() should return -EINVAL, not -ENOKEY.
> >
>
> Yes, but I tried to keep handling of the crypto_tfm flags out of the
> library interface.
>
> I will try to find a way to solve this cleanly.

Actually, it should be as simple as

diff --git a/include/crypto/internal/des.h b/include/crypto/internal/des.h
index dfe5e8f92270..522c09c08002 100644
--- a/include/crypto/internal/des.h
+++ b/include/crypto/internal/des.h
@@ -27,10 +27,12 @@ static inline int crypto_des_verify_key(struct
crypto_tfm *tfm, const u8 *key)
        int err;

        err = des_expand_key(&tmp, key, DES_KEY_SIZE);
-       if (err == -ENOKEY &&
-           !(crypto_tfm_get_flags(tfm) & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS))
-               err = 0;
-
+       if (err == -ENOKEY) {
+               if (crypto_tfm_get_flags(tfm) & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)
+                       err = -EINVAL;
+               else
+                       err = 0;
+       }
        if (err)
                crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_WEAK_KEY);
