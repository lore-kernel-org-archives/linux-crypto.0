Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAD_ENC_HEADER,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83164C432C0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 05:22:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 568ED2240A
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 05:22:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=brennan.io header.i=stephen@brennan.io header.b="fhmyyAt3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbfKTFW2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 00:22:28 -0500
Received: from sender4-of-o54.zoho.com ([136.143.188.54]:21405 "EHLO
        sender4-of-o54.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbfKTFW2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 00:22:28 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1574227312; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=Flx7ce4PxJy7rIVAU38qK/e5P92vhuCE1NvcehAyNR1DZLS1LKmGaWaOA3wjYPVMg85QxB68SfLb+jVjPx8Wa63YC+GFw/SCjMFqIr+WRpMKgHoRKTnZa1pmHQRXl3qNn+K2lv+uIjbC7GUpJ7MZFC8I+dTZY8mUGcH4YMnQNM0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1574227312; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:Message-ID:Subject:To; 
        bh=4LlqgzIjZJfktOZiZsTPIEsa9bG6LeOMEa6w2orvAZU=; 
        b=WUsk8P9bm6MKdZmYL1Ek8pk1QyschbC4gW4g14TW8UOV4t+DbX+ODK/OVznYubRtxZOmHQ9+fp1L0rEJW2vRX8QGkr7YA919boHpCMzWwpnbtle4SStptqd49S7DO3urQTDKDXgszmfC/Lm3XfFisjBg8BE0cvEcrmouNaRHGvA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=brennan.io;
        spf=pass  smtp.mailfrom=stephen@brennan.io;
        dmarc=pass header.from=<stephen@brennan.io> header.from=<stephen@brennan.io>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1574227312;
        s=selector01; d=brennan.io; i=stephen@brennan.io;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Date:Cc:Subject:From:To:Message-Id;
        l=2128; bh=4LlqgzIjZJfktOZiZsTPIEsa9bG6LeOMEa6w2orvAZU=;
        b=fhmyyAt3XgmVDIcH+g30z67FlXW8WFEV+hOiF7EwkkS7d7PA5xHR1dqJhDsSsqop
        yUfVmbOaAze5M7QtLYXQIDVwr4djdn1JQ8sBw3q0Jklh/Azz5f0VLAb+v9vyyd2cNPV
        CERklVw73whKx4do3rpW4mcBrGVrX9zg/KX7DPCY=
Received: from localhost (c-98-207-184-40.hsd1.ca.comcast.net [98.207.184.40]) by mx.zohomail.com
        with SMTPS id 157422731156931.816597010629835; Tue, 19 Nov 2019 21:21:51 -0800 (PST)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Originalfrom: "Baruch Siach" <baruch@tkos.co.il>
Original: =?utf-8?q?Hi_Stephen,_Stefan,
 =0A=0AOn_Wed,_Nov_20_2019,_Stephen_Brennan_w?= =?utf-8?q?rote:
 =0A=0A>_From:_Stefan_Wahren_<wahrenst@gmx.net>=0A>=0A>_The?=
 =?utf-8?q?_BCM2711_has_a_RNG200_block,_so_document_its_compatible_string.?=
 =?utf-8?q?=0A>=0A>_Signed-off-by:_Stefan_Wahren_<wahrenst@gmx.net>=0A>_Si?=
 =?utf-8?q?gned-off-by:_Stephen_Brennan_<stephen@brennan.io>=0A=0AIsn't_th?=
 =?utf-8?q?at_duplicate_of_Florian's_commit_6223949a1531=3F=0A=0A>_---=0A>?=
 =?utf-8?q?__Documentation/devicetree/bindings/rng/brcm,iproc-rng200.txt_|?=
 =?utf-8?q?_1_+=0A>__1_file_changed,_1_insertion(+)=0A>=0A>_diff_--git_a/D?=
 =?utf-8?q?ocumentation/devicetree/bindings/rng/brcm,iproc-rng200.txt_b/Do?=
 =?utf-8?q?cumentation/devicetree/bindings/rng/brcm,iproc-rng200.txt=0A>_i?=
 =?utf-8?q?ndex_c223e54452da..802523196ee5_100644=0A>_---_a/Documentation/?=
 =?utf-8?q?devicetree/bindings/rng/brcm,iproc-rng200.txt=0A>_+++_b/Documen?=
 =?utf-8?q?tation/devicetree/bindings/rng/brcm,iproc-rng200.txt=0A>_@@_-2,?=
 =?utf-8?q?6_+2,7_@@_HWRNG_support_for_the_iproc-rng200_driver=0A>__=0A>__?=
 =?utf-8?q?Required_properties:=0A>__-_compatible_:_Must_be_one_of:=0A>_+?=
 =?utf-8?q?=09_______"brcm,bcm2711-rng200"=0A>__=09_______"brcm,bcm7211-rn?=
 =?utf-8?q?g200"=0A=0AIsn't_this_clear_text_duplication=3F_Am_I_missing_so?=
 =?utf-8?q?mething_obvious=3F=0A=0AI_was_looking_at_versions_of_this_patch?=
 =?utf-8?q?_series_wondering_why_no_one=0Anoticed_that.=0A=0Abaruch=0A=0A>?=
 =?utf-8?q?__=09_______"brcm,bcm7278-rng200"=0A>__=09_______"brcm,iproc-rn?=
 =?utf-8?q?g200"=0A=0A--_=0A_____http://baruch.siach.name/blog/___________?=
 =?utf-8?q?_______~._.~___Tk_Open_Systems=0A=3D}--------------------------?=
 =?utf-8?q?----------------------ooO--U--Ooo------------{=3D=0A___-_baruch?=
 =?utf-8?q?@tkos.co.il_-_tel:_+972.52.368.4656,_http://www.tkos.co.il_-=0A?=
In-Reply-To: <87ftijgnhz.fsf@tarshish>
Originaldate: Wed Nov 20, 2019 at 6:50 AM
Date:   Tue, 19 Nov 2019 21:21:49 -0800
Cc:     <stephen@brennan.io>, "Mark Rutland" <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>,
        <linux-rpi-kernel@lists.infradead.org>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        "Herbert Xu" <herbert@gondor.apana.org.au>,
        "Scott Branden" <sbranden@broadcom.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Ray Jui" <rjui@broadcom.com>, <linux-kernel@vger.kernel.org>,
        "Eric Anholt" <eric@anholt.net>,
        "Rob Herring" <robh+dt@kernel.org>,
        <bcm-kernel-feedback-list@broadcom.com>,
        "Stefan Wahren" <wahrenst@gmx.net>,
        "Matt Mackall" <mpm@selenic.com>, "Arnd Bergmann" <arnd@arndb.de>,
        <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH v3 1/4] dt-bindings: rng: add BCM2711 RNG compatible
From:   "Stephen Brennan" <stephen@brennan.io>
To:     "Baruch Siach" <baruch@tkos.co.il>,
        <linux-arm-kernel@lists.infradead.org>
Message-Id: <BYKH0ACN38Y1.2TRTJUY5267L4@pride>
X-ZohoMailClient: External
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Baruch,

On Wed Nov 20, 2019 at 6:50 AM, Baruch Siach wrote:
> Hi Stephen, Stefan,
>
>=20
> On Wed, Nov 20 2019, Stephen Brennan wrote:
>
>=20
> > From: Stefan Wahren <wahrenst@gmx.net>
> >
> > The BCM2711 has a RNG200 block, so document its compatible string.
> >
> > Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
> > Signed-off-by: Stephen Brennan <stephen@brennan.io>
>
>=20
> Isn't that duplicate of Florian's commit 6223949a1531?
>
>=20
> > ---
> >  Documentation/devicetree/bindings/rng/brcm,iproc-rng200.txt | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/Documentation/devicetree/bindings/rng/brcm,iproc-rng200.tx=
t b/Documentation/devicetree/bindings/rng/brcm,iproc-rng200.txt
> > index c223e54452da..802523196ee5 100644
> > --- a/Documentation/devicetree/bindings/rng/brcm,iproc-rng200.txt
> > +++ b/Documentation/devicetree/bindings/rng/brcm,iproc-rng200.txt
> > @@ -2,6 +2,7 @@ HWRNG support for the iproc-rng200 driver
> > =20
> >  Required properties:
> >  - compatible : Must be one of:
> > +	       "brcm,bcm2711-rng200"
> >  	       "brcm,bcm7211-rng200"
>
>=20
> Isn't this clear text duplication? Am I missing something obvious?
>

I understand the confusion, but they're different, we're looking at the=20
difference between:

   bcm2711
   bcm7211
      ^^

These are apparently separate but related chips, leading to confusion in=20
other places [1] as well. I double checked the commit 6223949a1531 you=20
pointed out, as well as 1fa6d053b2a5 from your other email, to verify that=
=20
this is the case. No duplication (as far as I can tell) is in the series.

[1]: https://github.com/raspberrypi/linux/issues/3163

Regards,
Stephen

>=20
> I was looking at versions of this patch series wondering why no one
> noticed that.
>
>=20
> baruch
>
>=20
> >  	       "brcm,bcm7278-rng200"
> >  	       "brcm,iproc-rng200"
>
>=20
> --
> http://baruch.siach.name/blog/ ~. .~ Tk Open Systems
> =3D}------------------------------------------------ooO--U--Ooo----------=
--{=3D
> - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
>
>=20
>
>=20


