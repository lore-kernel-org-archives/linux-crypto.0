Return-Path: <SRS0=Veu2=ZL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAD_ENC_HEADER,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C00BDC43215
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 05:58:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8926C2084D
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 05:58:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=brennan.io header.i=stephen@brennan.io header.b="h04vzW4H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729764AbfKSF6R (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 00:58:17 -0500
Received: from sender4-of-o54.zoho.com ([136.143.188.54]:21467 "EHLO
        sender4-of-o54.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730701AbfKSFth (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Nov 2019 00:49:37 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1574142546; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=AoezPkE/AZwVtb/MIvG+t/bP8LK3U3rkzfxnXH5SGBL/2+0pYP8URCpbunqoluEY1yNspYAM8H2TwAvspOMlStjaNmJhMA8+T/2EtwV92o4BV8CrpxL+Xat9HD1Ey5aO6BVPg449l8uePA/WgKQLzI5sJzzAcquqwl3+crrPOuI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1574142546; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:Message-ID:Subject:To; 
        bh=8aG5xAT9J4+OFgRMDpokJYhuqlwLqFHvo4kBXwpx4t0=; 
        b=h+avyOoDInFXduFp6BcxsOkbT3TUiPwQ6G+5ReI+oaVc5CzJBJGxkR0WUj8MlaPEWJkQ5W9zdWM4J018NQTJnLGagy3Dwc3Q29CS4nZhCHAfOO51CvymcDsafLzoKfGt1XjeCW6+l4K7t+80IYHc10smilasR2hbM7yWeRDOOLY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=brennan.io;
        spf=pass  smtp.mailfrom=stephen@brennan.io;
        dmarc=pass header.from=<stephen@brennan.io> header.from=<stephen@brennan.io>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1574142546;
        s=selector01; d=brennan.io; i=stephen@brennan.io;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Date:Cc:Subject:From:To:Message-Id;
        l=2200; bh=8aG5xAT9J4+OFgRMDpokJYhuqlwLqFHvo4kBXwpx4t0=;
        b=h04vzW4Hx25staIqTtT+ebrsVPVEeO9XpueCcIurCNKAePq+Q55ygt6Y1gJeSlEL
        HRORKxgnvhG31px9A5fVrM04oiSyPyK13Q4MilLbWXZFVH1hUlW4EX3IFnfD4+skYkP
        E8K8EvQnufm282P+TWFR5QPXp2tMihVLzg72MvBA=
Received: from localhost (195.173.24.136.in-addr.arpa [136.24.173.195]) by mx.zohomail.com
        with SMTPS id 1574142545915820.4572493784793; Mon, 18 Nov 2019 21:49:05 -0800 (PST)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <5cc711fd-4d47-5369-c424-363677334b9f@gmx.net>
Originaldate: Mon Nov 18, 2019 at 8:44 PM
Originalfrom: "Stefan Wahren" <wahrenst@gmx.net>
Original: =?utf-8?q?Hi,
 =0D=0A=0D=0AAm_18.11.19_um_12:44_schrieb_Nicolas_Saenz_Julie?=
 =?utf-8?q?nne:=0D=0A>_Hi_Stephen,=0D=0A>=0D=0A>_On_Sun,_2019-11-17_at_23:?=
 =?utf-8?q?58_-0800,_Stephen_Brennan_wrote:=0D=0A>>_From:_Stefan_Wahren_<w?=
 =?utf-8?q?ahrenst@gmx.net>=0D=0A>>=0D=0A>>_This_enables_hardware_random_n?=
 =?utf-8?q?umber_generator_support_for_the_BCM2711=0D=0A>>_on_the_Raspberr?=
 =?utf-8?q?y_Pi_4_board.=0D=0A>>=0D=0A>>_Signed-off-by:_Stefan_Wahren_<wah?=
 =?utf-8?q?renst@gmx.net>=0D=0A>>_Signed-off-by:_Stephen_Brennan_<stephen@?=
 =?utf-8?q?brennan.io>=0D=0A>>_---=0D=0A>>__arch/arm/boot/dts/bcm2711.dtsi?=
 =?utf-8?q?_|_5_++---=0D=0A>>__1_file_changed,_2_insertions(+),_3_deletion?=
 =?utf-8?q?s(-)=0D=0A>>=0D=0A>>_diff_--git_a/arch/arm/boot/dts/bcm2711.dts?=
 =?utf-8?q?i_b/arch/arm/boot/dts/bcm2711.dtsi=0D=0A>>_index_ac83dac2e6ba..?=
 =?utf-8?q?2c19e5de284a_100644=0D=0A>>_---_a/arch/arm/boot/dts/bcm2711.dts?=
 =?utf-8?q?i=0D=0A>>_+++_b/arch/arm/boot/dts/bcm2711.dtsi=0D=0A>>_@@_-92,1?=
 =?utf-8?q?0_+92,9_@@_pm:_watchdog@7e100000_{=0D=0A>>__=09=09};=0D=0A>>=0D?=
 =?utf-8?q?=0A>>__=09=09rng@7e104000_{=0D=0A>>_+=09=09=09compatible_=3D_"b?=
 =?utf-8?q?rcm,bcm2711-rng200";=0D=0A>>__=09=09=09interrupts_=3D_<GIC=5FSP?=
 =?utf-8?q?I_125_IRQ=5FTYPE=5FLEVEL=5FHIGH>;=0D=0A>>_-=0D=0A>>_-=09=09=09/?=
 =?utf-8?q?*_RNG_is_incompatible_with_brcm,bcm2835-rng_*/=0D=0A>>_-=09=09?=
 =?utf-8?q?=09status_=3D_"disabled";=0D=0A>>_+=09=09=09status_=3D_"okay";?=
 =?utf-8?q?=0D=0A>>__=09=09};=0D=0A>>=0D=0A>>__=09=09uart2:_serial@7e20140?=
 =?utf-8?q?0_{=0D=0A>_We_inherit_the_reg_property_from_bcm283x.dtsi,_on_wh?=
 =?utf-8?q?ich_we_only_define_a_size=0D=0A>_of_0x10_bytes._I_gather_from_t?=
 =?utf-8?q?he_driver_that_iproc-rng200's_register_space_is=0D=0A>_at_least?=
 =?utf-8?q?_0x28_bytes_big._We_should_also_update_the_'reg'_property_to:?=
 =?utf-8?q?=0D=0A>=0D=0A>_=09reg_=3D_<0x7e104000_0x28>;=0D=0A=0D=0AThanks_?=
 =?utf-8?q?for_sending_and_noticing._A_proper_solution_would_be_to_move_th?=
 =?utf-8?q?e=0D=0Awhole_rng_node_from_bcm283x.dtsi_to_bcm283x-common.dtsi_?=
 =?utf-8?q?and_define_a=0D=0Acompletely_new_rng_node_in_bcm2711.dtsi.=0D?=
 =?utf-8?q?=0A=0D=0ARegards=0D=0AStefan=0D=0A=0D=0A>=0D=0A>_Regards,=0D=0A?=
 =?utf-8?q?>_Nicolas=0D=0A>=0D=0A>=0D=0A>_=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F?=
 =?utf-8?q?=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F?=
 =?utf-8?q?=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=0D=0A>_linux-a?=
 =?utf-8?q?rm-kernel_mailing_list=0D=0A>_linux-arm-kernel@lists.infradead.?=
 =?utf-8?q?org=0D=0A>_http://lists.infradead.org/mailman/listinfo/linux-ar?=
 =?utf-8?q?m-kernel=0D=0A?=
Date:   Mon, 18 Nov 2019 21:49:04 -0800
Cc:     "Mark Rutland" <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        "Herbert Xu" <herbert@gondor.apana.org.au>,
        "Scott Branden" <sbranden@broadcom.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Matt Mackall" <mpm@selenic.com>, <linux-kernel@vger.kernel.org>,
        "Arnd Bergmann" <arnd@arndb.de>, <linux-crypto@vger.kernel.org>,
        "Eric Anholt" <eric@anholt.net>,
        "Rob Herring" <robh+dt@kernel.org>,
        <bcm-kernel-feedback-list@broadcom.com>,
        <linux-rpi-kernel@lists.infradead.org>,
        "Ray Jui" <rjui@broadcom.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/3] ARM: dts: bcm2711: Enable HWRNG support
From:   "Stephen Brennan" <stephen@brennan.io>
To:     "Stefan Wahren" <wahrenst@gmx.net>,
        "Nicolas Saenz Julienne" <nsaenzjulienne@suse.de>
Message-Id: <BYJMYLOFLH80.EDWI9BX3JBY3@pride>
X-ZohoMailClient: External
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello Stefan & Nicolas,

On Mon Nov 18, 2019 at 8:44 PM, Stefan Wahren wrote:
> Hi,
>
>=20
> Am 18.11.19 um 12:44 schrieb Nicolas Saenz Julienne:
> > Hi Stephen,
> >
> > On Sun, 2019-11-17 at 23:58 -0800, Stephen Brennan wrote:
> >> From: Stefan Wahren <wahrenst@gmx.net>
> >>
> >> This enables hardware random number generator support for the BCM2711
> >> on the Raspberry Pi 4 board.
> >>
> >> Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
> >> Signed-off-by: Stephen Brennan <stephen@brennan.io>
> >> ---
> >>  arch/arm/boot/dts/bcm2711.dtsi | 5 ++---
> >>  1 file changed, 2 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/arch/arm/boot/dts/bcm2711.dtsi b/arch/arm/boot/dts/bcm271=
1.dtsi
> >> index ac83dac2e6ba..2c19e5de284a 100644
> >> --- a/arch/arm/boot/dts/bcm2711.dtsi
> >> +++ b/arch/arm/boot/dts/bcm2711.dtsi
> >> @@ -92,10 +92,9 @@ pm: watchdog@7e100000 {
> >>  		};
> >>
> >>  		rng@7e104000 {
> >> +			compatible =3D "brcm,bcm2711-rng200";
> >>  			interrupts =3D <GIC_SPI 125 IRQ_TYPE_LEVEL_HIGH>;
> >> -
> >> -			/* RNG is incompatible with brcm,bcm2835-rng */
> >> -			status =3D "disabled";
> >> +			status =3D "okay";
> >>  		};
> >>
> >>  		uart2: serial@7e201400 {
> > We inherit the reg property from bcm283x.dtsi, on which we only define =
a size
> > of 0x10 bytes. I gather from the driver that iproc-rng200's register sp=
ace is
> > at least 0x28 bytes big. We should also update the 'reg' property to:
> >
> > 	reg =3D <0x7e104000 0x28>;
>
>=20
> Thanks for sending and noticing. A proper solution would be to move the
> whole rng node from bcm283x.dtsi to bcm283x-common.dtsi and define a
> completely new rng node in bcm2711.dtsi.

Thanks both for your time and consideration. I'm not terribly familiar with=
=20
device tree source but I think I understand what you'd like here. I'll send=
=20
a v2 that does this!

Regards,
Stephen

>
>=20
> Regards
> Stefan
>
>=20
> >
> > Regards,
> > Nicolas
> >
> >
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
>=20
>
>=20


