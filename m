Return-Path: <SRS0=Quof=CU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DCA2C43461
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Sep 2020 16:31:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F28822205
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Sep 2020 16:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599841893;
	bh=h89bdVr/bit3pPtuE9cNhHZorvHOPU7+EYEVbVfI9Jo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=g/b1ZD/molL+89a2t0hXViNG3QWBPhRIJ7bo8eF6LSHAq7DH5mczva61aUytMM3bx
	 MtxPgdXEm+q3O2wEHTyI16t9uc2HWu8wGyJQGqjyxzoIgIBW5IUiCaX3YdItxgz7rh
	 tNsqgRWQkR5IArI+L0fLKaB2TxOz/kPC4GwHxwYE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgIKQbb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Sep 2020 12:31:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbgIKQac (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Sep 2020 12:30:32 -0400
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45FB0206DB
        for <linux-crypto@vger.kernel.org>; Fri, 11 Sep 2020 16:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599841832;
        bh=h89bdVr/bit3pPtuE9cNhHZorvHOPU7+EYEVbVfI9Jo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=D5oEDDiL0GJK+ElFzq8mQh5bMGWAoJOMFikKNz3Q4aHxgTkjfA2f10D4u6j1vwCBT
         QqjAPXoK4vBzo4ZrisI9pZFZRpRMxygdvIVuBNU+QY4sQs+SbMG3jR6DnbBkyy3g6k
         vC1RTBY8nSY0a4HNRlUDBSBddnRrOFsaz7zWKHPk=
Received: by mail-ot1-f53.google.com with SMTP id e23so8830767otk.7
        for <linux-crypto@vger.kernel.org>; Fri, 11 Sep 2020 09:30:32 -0700 (PDT)
X-Gm-Message-State: AOAM531LQxh05HGrjUIFkfeF0htjxGWFW8vF557VZRFEjmdz6SfZ5iek
        3N/lL2Wk2cNunvJBZsC6vOoUGpkGQaI4wS3i0fE=
X-Google-Smtp-Source: ABdhPJwVQyk6DiS/IlLOx9LnZeVivdkhbwK1++Fv1w5oNIsTwqVE9VoM+lV6zKdwaEbZueGCBkqgp1dgM4WiQhFSqi0=
X-Received: by 2002:a9d:69c9:: with SMTP id v9mr1597523oto.90.1599841831517;
 Fri, 11 Sep 2020 09:30:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200911141103.14832-1-ardb@kernel.org> <CY4PR0401MB3652AD749C06D0ACD9F085F3C3240@CY4PR0401MB3652.namprd04.prod.outlook.com>
In-Reply-To: <CY4PR0401MB3652AD749C06D0ACD9F085F3C3240@CY4PR0401MB3652.namprd04.prod.outlook.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 11 Sep 2020 19:30:20 +0300
X-Gmail-Original-Message-ID: <CAMj1kXHOrGoGv6Tse9Vju9mTV_+ks8cUMqx_iSQHPfc+2DVkmw@mail.gmail.com>
Message-ID: <CAMj1kXHOrGoGv6Tse9Vju9mTV_+ks8cUMqx_iSQHPfc+2DVkmw@mail.gmail.com>
Subject: Re: [PATCH] crypto: mark unused ciphers as obsolete
To:     "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>,
        dm-devel@redhat.com, Milan Broz <gmazyland@gmail.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

(cc Milan and dm-devel)

On Fri, 11 Sep 2020 at 19:24, Van Leeuwen, Pascal
<pvanleeuwen@rambus.com> wrote:
>
> > -----Original Message-----
> > From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kerne=
l.org> On Behalf Of Ard Biesheuvel
> > Sent: Friday, September 11, 2020 4:11 PM
> > To: linux-crypto@vger.kernel.org
> > Cc: herbert@gondor.apana.org.au; ebiggers@kernel.org; Ard Biesheuvel <a=
rdb@kernel.org>
> > Subject: [PATCH] crypto: mark unused ciphers as obsolete
> >
> > <<< External Email >>>
> > We have a few interesting pieces in our cipher museum, which are never
> > used internally, and were only ever provided as generic C implementatio=
ns.
> >
> > Unfortunately, we cannot simply remove this code, as we cannot be sure
> > that it is not being used via the AF_ALG socket API, however unlikely.
> > So let's mark the Anubis, Khazad, SEED and TEA algorithms as obsolete,
> >
> Wouldn't the IKE deamon be able to utilize these algorithms through the X=
FRM API?
> I'm by no means an expert on the subject, but it looks like the cipher te=
mplate is
> provided there directly via XFRM, so it does not need to live in the kern=
el source.
> And I know for a fact that SEED is being used for IPsec (and TLS) in Kore=
a.
>

I have been staring at net/xfrm/xfrm_algo.c, and as far as I can tell,
algorithms have to be mentioned there in order to be usable. None of
the ciphers that this patch touches are listed there or anywhere else
in the kernel.

> The point being, there are more users to consider beyond "internal" (mean=
ing hard
> coded in the kernel source in this context?) and AF_ALG.
>

That is a good point, actually, since dm-crypt could be affected here
as well, hence the CCs.

Milan (or others): are you aware of any of these ciphers being used
for dm-crypt?


> I'm not aware of any real use cases for Anubis, Khazad and TEA though.
>

OK, thanks for confirming. Removing those would be a good start.

> > which means they can only be enabled in the build if the socket API is
> > enabled in the first place.
> >
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> > Hopefully, I will be able to convince the distro kernel maintainers to
> > disable CRYPTO_USER_API_ENABLE_OBSOLETE in their v5.10+ builds once the
> > iwd changes for arc4 make it downstream (Debian already has an updated
> > version in its unstable distro). With the joint coverage of their QA,
> > we should be able to confirm that these algos are never used, and
> > actually remove them altogether.
> >
> >  crypto/Kconfig | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/crypto/Kconfig b/crypto/Kconfig
> > index e85d8a059489..fac10143d23f 100644
> > --- a/crypto/Kconfig
> > +++ b/crypto/Kconfig
> > @@ -1185,6 +1185,7 @@ config CRYPTO_AES_PPC_SPE
> >
> >  config CRYPTO_ANUBIS
> >  tristate "Anubis cipher algorithm"
> > +depends on CRYPTO_USER_API_ENABLE_OBSOLETE
> >  select CRYPTO_ALGAPI
> >  help
> >    Anubis cipher algorithm.
> > @@ -1424,6 +1425,7 @@ config CRYPTO_FCRYPT
> >
> >  config CRYPTO_KHAZAD
> >  tristate "Khazad cipher algorithm"
> > +depends on CRYPTO_USER_API_ENABLE_OBSOLETE
> >  select CRYPTO_ALGAPI
> >  help
> >    Khazad cipher algorithm.
> > @@ -1487,6 +1489,7 @@ config CRYPTO_CHACHA_MIPS
> >
> >  config CRYPTO_SEED
> >  tristate "SEED cipher algorithm"
> > +depends on CRYPTO_USER_API_ENABLE_OBSOLETE
> >  select CRYPTO_ALGAPI
> >  help
> >    SEED cipher algorithm (RFC4269).
> > @@ -1613,6 +1616,7 @@ config CRYPTO_SM4
> >
> >  config CRYPTO_TEA
> >  tristate "TEA, XTEA and XETA cipher algorithms"
> > +depends on CRYPTO_USER_API_ENABLE_OBSOLETE
> >  select CRYPTO_ALGAPI
> >  help
> >    TEA cipher algorithm.
> > --
> > 2.17.1
>
> Regards,
> Pascal van Leeuwen
> Silicon IP Architect Multi-Protocol Engines, Rambus Security
> Rambus ROTW Holding BV
> +31-73 6581953
>
> Note: The Inside Secure/Verimatrix Silicon IP team was recently acquired =
by Rambus.
> Please be so kind to update your e-mail address book with my new e-mail a=
ddress.
>
>
> ** This message and any attachments are for the sole use of the intended =
recipient(s). It may contain information that is confidential and privilege=
d. If you are not the intended recipient of this message, you are prohibite=
d from printing, copying, forwarding or saving it. Please delete the messag=
e and attachments and notify the sender immediately. **
>
> Rambus Inc.<http://www.rambus.com>
