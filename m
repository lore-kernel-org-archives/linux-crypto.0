Return-Path: <SRS0=SmAa=EF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EFBFC4363A
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Oct 2020 11:20:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAF9D2075E
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Oct 2020 11:20:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="HqGvZhBV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgJ3LUr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Oct 2020 07:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgJ3LUq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Oct 2020 07:20:46 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D20C0613D4
        for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2020 04:20:46 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id o70so4831443ybc.1
        for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2020 04:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=G9dXGMHL3LoWEWUdy1Ms+BhIgQ35oL2d5aGD3k8A1UE=;
        b=HqGvZhBVNP/Aty6lRkxtyeTfSpOJnW/80pgI0PLU4TQJYmLSG0M1XSw7w7i6FFlrvi
         3pIRW5VMXotOtXIRIt2rApfUcO7vyIdMH7GAgiBiIZyLRdQDG5i1TM74aYQLMcYA/ezh
         HcMWRVV5gcjRQru+OlFfIB3l8TkYUQAED7gMm3sfgHMhgfYEC0clXYhl/tUMerpH6voB
         6XimbfQZF5pGpP/VwXS9vpeLl1J2MT2KPnp144nKnafF/UF9GwiWkLPyH4XXCBEbv8f5
         Zeex7cHz/sIUzsLi2EeiP3deNt8t9KwddYNfMuhThMdmDiHR0AYdlHV+SHkPwPJYgpKr
         R9dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=G9dXGMHL3LoWEWUdy1Ms+BhIgQ35oL2d5aGD3k8A1UE=;
        b=kcOZAhFQmw+ThXplsf9pmdfXjIHyDFe1Ef/+S0KqWt3xtSogHYwoT5+ikxIItVUpsM
         U+YawaIsmY1TfWrktRU+EvmomSRrNIzF43dhS/O723xHJW7XNPWm0X1a2fWsCF5AON+W
         vFT9wPZR2auZs6ry7eIR1VSZwiu432FmjnfFh5wP8Yh/GnlMNnruGyhzKrXqCuThZXeR
         k1fkYq+YSSEM2liPt5Wb3fw7BpHsxzgDi++m9+tXRb0HpTQ4dV0pw6VWKWIzcssM71JP
         FsSnqvY0Vfiom1sKyCKmf+Q+5FwtBVL4O/sC++ibtk0ykOU1KcGmUs7aXITiEXp0lock
         VjNw==
X-Gm-Message-State: AOAM533RQeYGnRcMsS5aWLtpJSueKgLeegOv4EG4w6e4+dUYzHLL8+9u
        fFHWBMpLWMkqc2K26MT3i5kAvM8w8BSH9Wp/u1jRSA==
X-Google-Smtp-Source: ABdhPJzra1pMG5DWzyNsqxZMtv8L71QZ9N4kNvy1uCXEHLUKRwFRdAqW8KJMoQPn5ok9GmGGT6GuLe6CgauTI6lkDu8=
X-Received: by 2002:a5b:389:: with SMTP id k9mr2590084ybp.75.1604056845834;
 Fri, 30 Oct 2020 04:20:45 -0700 (PDT)
MIME-Version: 1.0
References: <20201029100546.28686-1-gilad@benyossef.com> <20201029100546.28686-2-gilad@benyossef.com>
 <3a4804a5-5d5c-1216-1503-c241cc24f3c2@gmail.com>
In-Reply-To: <3a4804a5-5d5c-1216-1503-c241cc24f3c2@gmail.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Fri, 30 Oct 2020 13:20:41 +0200
Message-ID: <CAOtvUMdJxVSFhN4QMNL+eiF6OB2LevThcgDK34M-=JDXCoDXMA@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] crypto: add eboiv as a crypto API template
To:     Milan Broz <gmazyland@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        Ofir Drang <ofir.drang@arm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On Fri, Oct 30, 2020 at 12:33 PM Milan Broz <gmazyland@gmail.com> wrote:
>
> On 29/10/2020 11:05, Gilad Ben-Yossef wrote:
> >
> > +config CRYPTO_EBOIV
> > +     tristate "EBOIV support for block encryption"
> > +     default DM_CRYPT
> > +     select CRYPTO_CBC
> > +     help
> > +       Encrypted byte-offset initialization vector (EBOIV) is an IV
> > +       generation method that is used in some cases by dm-crypt for
> > +       supporting the BitLocker volume encryption used by Windows 8
> > +       and onwards as a backwards compatible version in lieu of XTS
> > +       support.
> > +
> > +       It uses the block encryption key as the symmetric key for a
> > +       block encryption pass applied to the sector offset of the block=
.
> > +       Additional details can be found at
> > +       https://www.jedec.org/sites/default/files/docs/JESD223C.pdf
>
> This page is not available. Are you sure this is the proper documentation=
?

You need to register at the JEDEC web site to get the PDF. The
registration is free though.

It's the only standard I am aware of that describe this mode, as
opposed to a paper.

>
> I think the only description we used (for dm-crypt) was original Ferguson=
's Bitlocker doc:
> https://download.microsoft.com/download/0/2/3/0238acaf-d3bf-4a6d-b3d6-0a0=
be4bbb36e/bitlockercipher200608.pdf


Yes, the JEDEC has a reference to that as well, but the white paper
doesn't actually describe the option without the diffuser.

>
> IIRC EBOIV was a shortcut I added to dm-crypt because we found no officia=
l terminology for this IV.
> And after lunchtime, nobody invented anything better, so it stayed as it =
is now :-)

Well, I still don't have any better name to offer, LOL :-)

Gilad



--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
