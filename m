Return-Path: <SRS0=8F2V=WQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ACD1C3A589
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 13:10:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 412872054F
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 13:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1566306613;
	bh=dUooFivN+zzsvPCLaopJHJ/sq6agKEtcW1lHSWw5xpY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=0j+8xzkJ1nBmwzT87bBAybOwgf3NazYr9vVC5h8jPFiPTmAguZUODmnnEHQID7vdd
	 y8A/eSpZAlp/9x5s5MozJog1jJ65lXNdquTgCZYtGPgqUHGZvAuzIzSQK6uDXVJ5TE
	 Pa2281699z4TCdDTiJlG6OS9PU0RnQhsOw5fG54I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729803AbfHTNKM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Aug 2019 09:10:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729458AbfHTNKM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Aug 2019 09:10:12 -0400
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C54C2054F
        for <linux-crypto@vger.kernel.org>; Tue, 20 Aug 2019 13:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566306610;
        bh=dUooFivN+zzsvPCLaopJHJ/sq6agKEtcW1lHSWw5xpY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=v3VMPLl++4/yr9l8xpBJIOJHBZpASL4wdS2Ws59kzZnk4Npb7PBnkiJYAFpWiKb5o
         eExwqxXhdmRZv/68KQ4TNy3eUrcfHFPi3x4tPb8BgIYz0SBXBmnGzjcNUOCdx/ztD1
         w3Cw2cRLfU5V/zCiInsNO/TEf5SeAPcOIX9vUw18=
Received: by mail-qt1-f171.google.com with SMTP id y26so5898307qto.4
        for <linux-crypto@vger.kernel.org>; Tue, 20 Aug 2019 06:10:10 -0700 (PDT)
X-Gm-Message-State: APjAAAWedR0AW25qgNaHPhLgO7gxlIAEUtr6dhk9vxA4PlF8y/sihHHk
        F6WNqmwiHVBOgHHD+X1qqy0CMmTnwNrjzzlYyCs=
X-Google-Smtp-Source: APXvYqwiEpv157Z5UAA3L5O0160tpN+0BaJS2ivNi49wPXlEFAfv0Jk7CeJ9nn6o+3Smv91kKy14TB1FmUCZGIn3ibs=
X-Received: by 2002:ac8:1a86:: with SMTP id x6mr26029900qtj.231.1566306609759;
 Tue, 20 Aug 2019 06:10:09 -0700 (PDT)
MIME-Version: 1.0
References: <CAK9qPMA=-MnkdpkUE_CU5FRmZ6LSk2FzfBJNsB0XRiaYxy9UWA@mail.gmail.com>
 <CA+5PVA5BC7AtcJ4Ud33Ft9h_=kRcqeLoHtjRfvu_XBSvgej74g@mail.gmail.com> <MN2PR20MB297310E2E089219DF583E6E5CAAB0@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB297310E2E089219DF583E6E5CAAB0@MN2PR20MB2973.namprd20.prod.outlook.com>
From:   Josh Boyer <jwboyer@kernel.org>
Date:   Tue, 20 Aug 2019 09:09:58 -0400
X-Gmail-Original-Message-ID: <CA+5PVA49nn=H9PrbzYMu0QR1tswTk0gTNORobOMqRPpFgEsGTw@mail.gmail.com>
Message-ID: <CA+5PVA49nn=H9PrbzYMu0QR1tswTk0gTNORobOMqRPpFgEsGTw@mail.gmail.com>
Subject: Re: [GIT PULL] inside-secure: add new GPLv2 "mini" firmware for the
 EIP197 driver
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Pascal van Leeuwen <pascalvanl@gmail.com>,
        Linux Firmware <linux-firmware@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Aug 20, 2019 at 8:01 AM Pascal Van Leeuwen
<pvanleeuwen@verimatrix.com> wrote:
>
> > -----Original Message-----
> > From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.org> On Behalf Of
> > Josh Boyer
> > Sent: Thursday, August 15, 2019 1:33 PM
> > To: Pascal van Leeuwen <pascalvanl@gmail.com>
> > Cc: Linux Firmware <linux-firmware@kernel.org>; linux-crypto@vger.kernel.org
> > Subject: Re: [GIT PULL] inside-secure: add new GPLv2 "mini" firmware for the EIP197 driver
> >
> > On Tue, Aug 6, 2019 at 8:54 AM Pascal van Leeuwen <pascalvanl@gmail.com> wrote:
> > >
> > > The following changes since commit dff98c6c57383fe343407bcb7b6e775e0b87274f:
> > >
> > >   Merge branch 'master' of git://github.com/skeggsb/linux-firmware
> > > (2019-07-26 07:32:37 -0400)
> > >
> > > are available in the git repository at:
> > >
> > >
> > >   https://github.com/pvanleeuwen/linux-firmware-clean.git is_driver_fw
> > >
> > > for you to fetch changes up to fbfe41f92f941d19b840ec0e282f422379982ccb:
> > >
> > >   inside-secure: add new GPLv2 "mini" firmware for the EIP197 driver
> > > (2019-08-06 13:19:44 +0200)
> > >
> > > ----------------------------------------------------------------
> > > Pascal van Leeuwen (1):
> > >       inside-secure: add new GPLv2 "mini" firmware for the EIP197 driver
> > >
> > >  WHENCE                               |  10 ++++++++++
> > >  inside-secure/eip197_minifw/ifpp.bin | Bin 0 -> 100 bytes
> > >  inside-secure/eip197_minifw/ipue.bin | Bin 0 -> 108 bytes
> > >  3 files changed, 10 insertions(+)
> > >  create mode 100644 inside-secure/eip197_minifw/ifpp.bin
> > >  create mode 100644 inside-secure/eip197_minifw/ipue.bin
> >
> > If this is GPLv2, where is the source code?
> >
> Ok, I am not a lawyer so I don't know anything about this license stuff.
> I just meant it is free to use and do whatever you want with.
> GPLv2 was agreed with our lawyers for the driver source code, so I just
> stuck that on the firmware as well (not looking forward to another time
> consuming pass through the legal department!).
>
> If GPLv2 implies that you have to provide source code, then what other
> license should I use that means freedom, but no source code?

I understand that can be time consuming, but I am not a lawyer and not
going to give you legal advice, sorry.  I certainly can't tell you how
to license your own code.

> Note that:
>
> a) I actually *lost* the source code (no joke or excuse!)
> b) This is for a proprietary in-house micro engine, so while we don't
>    necessarily mind providing the source code, we don't want to provide
>    any documentation or assembler for that. As we definitely don't want
>    to *support* any other people messing with it. Making the source code
>    effectively useless anyway.

That doesn't sound like you want GPL at all, which is a strong
copyleft license that requires source and allows people to rebuild it.
Support is a different story and not really tied to the license.

josh

> > > diff --git a/WHENCE b/WHENCE
> > > index 31edbd4..fce2ef7 100644
> > > --- a/WHENCE
> > > +++ b/WHENCE
> > > @@ -4514,3 +4514,13 @@ File: meson/vdec/gxl_mpeg4_5.bin
> > >  File: meson/vdec/gxm_h264.bin
> > >
> > >  Licence: Redistributable. See LICENSE.amlogic_vdec for details.
> > > +
> > > +--------------------------------------------------------------------------
> > > +
> > > +Driver: inside-secure -- Inside Secure EIP197 crypto driver
> > > +
> > > +File: inside-secure/eip197_minifw/ipue.bin
> > > +File: inside-secure/eip197_minifw/ifpp.bin
> > > +
> > > +Licence: GPLv2. See GPL-2 for details.
> > > +
> > > diff --git a/inside-secure/eip197_minifw/ifpp.bin
> > > b/inside-secure/eip197_minifw/ifpp.bin
> > > new file mode 100644
> > > index 0000000..b4a8322
> > > Binary files /dev/null and b/inside-secure/eip197_minifw/ifpp.bin differ
> > > diff --git a/inside-secure/eip197_minifw/ipue.bin
> > > b/inside-secure/eip197_minifw/ipue.bin
> > > new file mode 100644
> > > index 0000000..2f54999
> > > Binary files /dev/null and b/inside-secure/eip197_minifw/ipue.bin differ
>
> Regards,
> Pascal van Leeuwen
> Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
> www.insidesecure.com
