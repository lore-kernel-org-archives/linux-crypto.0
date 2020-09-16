Return-Path: <SRS0=gkSk=CZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B73EAC43461
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Sep 2020 08:02:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67A0A21D90
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Sep 2020 08:02:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="QC/a9gxI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgIPIBu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Sep 2020 04:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbgIPIBp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Sep 2020 04:01:45 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C3BAC06178A
        for <linux-crypto@vger.kernel.org>; Wed, 16 Sep 2020 01:01:45 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id k15so3475815pfc.12
        for <linux-crypto@vger.kernel.org>; Wed, 16 Sep 2020 01:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Jzms5XAy0HxBD6ul+TJwAtKpEdXIIQEvIQXmembsOLs=;
        b=QC/a9gxIFQcQOJO+uA+vjVshZqDN8e+LFRdyf/aIAVoxC6nt6GyZMHOWcZvoME0w87
         aSe0E7xu0+ZGXIE7WrAXn//6ydaMyNBCBc+QjStY7SIQBm1YCSo7xYtzW0RFzRgNXf1f
         1yLhZ0g0VuKfw3IfLpoz0voPYrp9ZPxHjaAovtMHgeQVMKX9bVGNvpS/rRgm/9pv0ToS
         0V6gf+vOX7w9japVUv1/b/bs6Ze4C4xX7YFaUhdfalPVuIoiVi88/RAMDRrSVn4FyHSJ
         rwDYrlp4PuzT/W5NxJEjng8q7U6zQwC8KQFZCIj1QyHKdfzL3/798HNVYEbVM8c7I2Wc
         ZG3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Jzms5XAy0HxBD6ul+TJwAtKpEdXIIQEvIQXmembsOLs=;
        b=KZMDseISA9GKoCHCA3GXbrM5Hg0o2TRv/beSqsE3qqyY6mdxUUN9vt0ngjn0uV3Djh
         V5b4Iaf6Sf/GFV6X4upjH74QNR2pJbMGeZFXY9ReQnwWA8KKbOQaEVNPfoIztXOqkK5b
         mNLYur3uXzyhFz3JACNNKC+tz8MpLt/5DaDNKEDaK+RyMWHIv4DEdhsfKXK65X+lnSXQ
         EOHI2u6/um2KVBwf1RDf7BVAm0y6acaFl4HB8MqBVg830nLemEHj28cH6xAmJc/xTYJI
         saRCQRVkJI4P7FvVwglHooAW7z+UeH8wlXNm8OAf4oPjaOnbvC4Sao8D4NZBwUQMABn1
         NFrw==
X-Gm-Message-State: AOAM530Wq2cO0xdOKmAfz3whT+A8otqRYVmZo2CmYtmLF2OR3eC9fam9
        DglBCe8u3suDbKRa7/ncIC21bUGkM7n5rz82fRJN+w==
X-Google-Smtp-Source: ABdhPJwN2QFGXNPzAZFIilK1Py2rGwqQ0bbheksG8Mxx6NCNiQuM7ZG8NklYYP87LUBNlsvMF6HpPVEL1Zj6OHCa7iw=
X-Received: by 2002:aa7:941a:0:b029:142:2501:35d1 with SMTP id
 x26-20020aa7941a0000b0290142250135d1mr5277487pfo.49.1600243304416; Wed, 16
 Sep 2020 01:01:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200903131242.128665-1-tianjia.zhang@linux.alibaba.com>
 <20200903131242.128665-8-tianjia.zhang@linux.alibaba.com> <CAOtvUMfT5zgv=e9nCgz8-1r7LuYSRZ8Zdx2xc0JwckUJZufcvg@mail.gmail.com>
 <6f251e1e-42a0-7e6c-e0cd-51fba3150d17@linux.alibaba.com>
In-Reply-To: <6f251e1e-42a0-7e6c-e0cd-51fba3150d17@linux.alibaba.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Wed, 16 Sep 2020 11:01:34 +0300
Message-ID: <CAOtvUMdxeYxztajMG=XDzV-G8cB2GLaVnNBSAxLkwuZwqPxr2A@mail.gmail.com>
Subject: Re: [PATCH v6 7/8] X.509: support OSCCA sm2-with-sm3 certificate verification
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        David Howells <dhowells@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Stephan Mueller <smueller@chronox.de>,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Waiman Long <longman@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
        Colin Ian King <colin.king@canonical.com>,
        Tushar Sugandhi <tusharsu@linux.microsoft.com>,
        Vitaly Chikunov <vt@altlinux.org>,
        Pascal van Leeuwen <pvanleeuwen@rambus.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        keyrings@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-security-module@vger.kernel.org,
        Xufeng Zhang <yunbo.xufeng@linux.alibaba.com>,
        Jia Zhang <zhang.jia@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 14, 2020 at 9:34 AM Tianjia Zhang
<tianjia.zhang@linux.alibaba.com> wrote:
>
> Hi Gilad,
>
> On 9/13/20 3:12 PM, Gilad Ben-Yossef wrote:
> > Hi,
> >
> >
> > On Thu, Sep 3, 2020 at 4:13 PM Tianjia Zhang
> > <tianjia.zhang@linux.alibaba.com> wrote:
> >>
> >> The digital certificate format based on SM2 crypto algorithm as
> >> specified in GM/T 0015-2012. It was published by State Encryption
> >> Management Bureau, China.
> >>
> >> The method of generating Other User Information is defined as
> >> ZA=3DH256(ENTLA || IDA || a || b || xG || yG || xA || yA), it also
> >> specified in https://tools.ietf.org/html/draft-shen-sm2-ecdsa-02.
> >>
> >> The x509 certificate supports sm2-with-sm3 type certificate
> >> verification.  Because certificate verification requires ZA
> >> in addition to tbs data, ZA also depends on elliptic curve
> >> parameters and public key data, so you need to access tbs in sig
> >> and calculate ZA. Finally calculate the digest of the
> >> signature and complete the verification work. The calculation
> >> process of ZA is declared in specifications GM/T 0009-2012
> >> and GM/T 0003.2-2012.
> >>
> >> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> >> Tested-by: Xufeng Zhang <yunbo.xufeng@linux.alibaba.com>
> >> ---
> >>   crypto/asymmetric_keys/Makefile          |  1 +
> >>   crypto/asymmetric_keys/public_key.c      |  6 +++
> >>   crypto/asymmetric_keys/public_key_sm2.c  | 61 ++++++++++++++++++++++=
++
> >>   crypto/asymmetric_keys/x509_public_key.c |  3 ++
> >>   include/crypto/public_key.h              | 15 ++++++
> >>   5 files changed, 86 insertions(+)
> >>   create mode 100644 crypto/asymmetric_keys/public_key_sm2.c
> >>
> >> diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/=
Makefile
> >> index 28b91adba2ae..1a99ea5acb6b 100644
> >> --- a/crypto/asymmetric_keys/Makefile
> >> +++ b/crypto/asymmetric_keys/Makefile
> >> @@ -11,6 +11,7 @@ asymmetric_keys-y :=3D \
> >>          signature.o
> >>
> >>   obj-$(CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE) +=3D public_key.o
> >> +obj-$(CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE) +=3D public_key_sm2.o
> >>   obj-$(CONFIG_ASYMMETRIC_TPM_KEY_SUBTYPE) +=3D asym_tpm.o
> >>
> >>   #
> >> diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_k=
eys/public_key.c
> >> index d8410ffd7f12..1d0492098bbd 100644
> >> --- a/crypto/asymmetric_keys/public_key.c
> >> +++ b/crypto/asymmetric_keys/public_key.c
> >> @@ -299,6 +299,12 @@ int public_key_verify_signature(const struct publ=
ic_key *pkey,
> >>          if (ret)
> >>                  goto error_free_key;
> >>
> >> +       if (strcmp(sig->pkey_algo, "sm2") =3D=3D 0 && sig->data_size) =
{
> >> +               ret =3D cert_sig_digest_update(sig, tfm);
> >> +               if (ret)
> >> +                       goto error_free_key;
> >> +       }
> >> +
> >>          sg_init_table(src_sg, 2);
> >>          sg_set_buf(&src_sg[0], sig->s, sig->s_size);
> >>          sg_set_buf(&src_sg[1], sig->digest, sig->digest_size);
> >> diff --git a/crypto/asymmetric_keys/public_key_sm2.c b/crypto/asymmetr=
ic_keys/public_key_sm2.c
> >> new file mode 100644
> >> index 000000000000..7325cf21dbb4
> >> --- /dev/null
> >> +++ b/crypto/asymmetric_keys/public_key_sm2.c
> >> @@ -0,0 +1,61 @@
> >> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> >> +/*
> >> + * asymmetric public-key algorithm for SM2-with-SM3 certificate
> >> + * as specified by OSCCA GM/T 0003.1-2012 -- 0003.5-2012 SM2 and
> >> + * described at https://tools.ietf.org/html/draft-shen-sm2-ecdsa-02
> >> + *
> >> + * Copyright (c) 2020, Alibaba Group.
> >> + * Authors: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> >> + */
> >> +
> >> +#include <crypto/sm3_base.h>
> >> +#include <crypto/sm2.h>
> >> +#include <crypto/public_key.h>
> >> +
> >> +#if IS_REACHABLE(CONFIG_CRYPTO_SM2)
> >> +
> >> +int cert_sig_digest_update(const struct public_key_signature *sig,
> >> +                               struct crypto_akcipher *tfm_pkey)
> >> +{
> >> +       struct crypto_shash *tfm;
> >> +       struct shash_desc *desc;
> >> +       size_t desc_size;
> >> +       unsigned char dgst[SM3_DIGEST_SIZE];
> >> +       int ret;
> >> +
> >> +       BUG_ON(!sig->data);
> >> +
> >> +       ret =3D sm2_compute_z_digest(tfm_pkey, SM2_DEFAULT_USERID,
> >> +                                       SM2_DEFAULT_USERID_LEN, dgst);
> >> +       if (ret)
> >> +               return ret;
> >> +
> >> +       tfm =3D crypto_alloc_shash(sig->hash_algo, 0, 0);
> >> +       if (IS_ERR(tfm))
> >> +               return PTR_ERR(tfm);
> >> +
> >> +       desc_size =3D crypto_shash_descsize(tfm) + sizeof(*desc);
> >> +       desc =3D kzalloc(desc_size, GFP_KERNEL);
> >> +       if (!desc)
> >> +               goto error_free_tfm;
> >> +
> >> +       desc->tfm =3D tfm;
> >> +
> >> +       ret =3D crypto_shash_init(desc);
> >> +       if (ret < 0)
> >> +               goto error_free_desc;
> >> +
> >> +       ret =3D crypto_shash_update(desc, dgst, SM3_DIGEST_SIZE);
> >> +       if (ret < 0)
> >> +               goto error_free_desc;
> >> +
> >> +       ret =3D crypto_shash_finup(desc, sig->data, sig->data_size, si=
g->digest);
> >
> > It looks like you are doing a separate init, update, finup every time
> > - I would consider using crypto_shash_digest() in one go.
> >
> > In fact, considering the fact that you are allocating a tfm just for
> > this use and then releasing it, I would consider switching to
> > crypto_shash_tfm_digest() and dropping the kzalloc all together.
> >
> > This should simplify the code a bit.
> >
> > Other than that I don't have anything smart to say :-)
> >
> > Gilad
> >
>
> The hash calculation here includes two parts of data, 'dgst' and
> 'sig->data'. The last call is 'finup()' not 'final()'. I understand that
> it should not be possible to use 'crypto_shash_tfm_digest()' This kind
> of function is simplified.
>
> If a new scope is added, the assignment of desc can be optimized, as
> follows:
> ```
> do {
>      SHASH_DESC_ON_STACK(desc, tfm);
>      desc->tfm =3D tfm;
>
>      /* ... */
> } while (0);
> ```
> However, the kernel code may not accept this style. What is your opinion?

No, you are right. I've indeed missed that it's a finup() and not a
final(). If the size of data was big enough it might have been worth
going to the async. hash interface and creating a scatter list for
this but I suspect it is not justified with the data sizes we are
dealing with there.

So:

Reviewed-by: Gilad Ben-Yossef <gilad@benyossef.com>

Thanks,
Gilad

--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
