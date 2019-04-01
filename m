Return-Path: <SRS0=dn2r=SD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	FREEMAIL_REPLYTO_END_DIGIT,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B299C43381
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Apr 2019 12:43:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63C7C20883
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Apr 2019 12:43:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.ch header.i=@protonmail.ch header.b="B8kHUbHl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbfDAMnv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Apr 2019 08:43:51 -0400
Received: from mail-40136.protonmail.ch ([185.70.40.136]:22545 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfDAMnv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Apr 2019 08:43:51 -0400
Date:   Mon, 01 Apr 2019 12:43:43 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.ch;
        s=default; t=1554122628;
        bh=4NWbnXo7XxP9JL9DZ3XnvE8TxMbWswVTWUBTMTy30BQ=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:
         Feedback-ID:From;
        b=B8kHUbHlJr3C9lArS+V/VUSCPZ9d5Ukz8EJDkUlvreiY/U8prjSTa1RmB9BTaRwiM
         xH65ySyX8D/Y4psDygaP4VAV4lDmOa0KyBgPKH0Ga3d0n5l265ec2Yw9o/ZY/xUJJy
         0HtRKzCuOcjk93HuvYg0BIPssQFhzrHGuNSI8xEE=
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
From:   Jordan Glover <Golden_Miller83@protonmail.ch>
Cc:     Vitaly Chikunov <vt@altlinux.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Reply-To: Jordan Glover <Golden_Miller83@protonmail.ch>
Subject: RE: Should we consider removing Streebog from the Linux Kernel?
Message-ID: <OJkrC5IricS5LhN9uJ9JiwWokxLRVb4H4vsNhDFd9Hu-GCOamv7V_QAwvyt8LP-wH43TIuPljaDqhAX2xMcksfya7e_HCbh095uq9azRRYY=@protonmail.ch>
In-Reply-To: <AM5PR0901MB115597BC2754E1B388AF15F2D2550@AM5PR0901MB1155.eurprd09.prod.outlook.com>
References: <20190325044550.GI5675@mit.edu>
 <20190325060041.wl23bncqjab7dj5c@altlinux.org>
 <20190331224329.GA681@sol.localdomain>
 <20190401100437.6tivlvp53zjprda6@altlinux.org>
 <LTLnFwnutvaWrlb3nFL9UEbwFqGlQPrULSlMM7Wli53B65WOofk1Vpp_ycEazJ3ore49c12K7UsDVHIOf8xuN5tepSyH0b-8zmP4gELpaVo=@protonmail.ch>
 <AM5PR0901MB115597BC2754E1B388AF15F2D2550@AM5PR0901MB1155.eurprd09.prod.outlook.com>
Feedback-ID: QEdvdaLhFJaqnofhWA-dldGwsuoeDdDw7vz0UPs8r8sanA3bIt8zJdf4aDqYKSy4gJuZ0WvFYJtvq21y6ge_uQ==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Monday, April 1, 2019 11:44 AM, Pascal Van Leeuwen <pvanleeuwen@insidese=
cure.com> wrote:

> > On Monday, April 1, 2019 10:04 AM, Vitaly Chikunov vt@altlinux.org wrot=
e:
> >
> > > > Can you elaborate on why you want to use Streebog? When we added
> > > > Speck, we explained in great detail why it was useful from a
> > > > technical perspective (before Adiantum was ready). I don't see any =
such
> > > > explanation for Streebog.
> > >
> > > Our users demand that file integrity is implemented using their
> > > national standard algorithm.
> > > Thanks,
> >
> > Does it mean that every state can demand from Linux kernel to carrying =
crypto
> > algorithms of their choice?
>
> I doubt that states can have that kind of leverage over the main linux ke=
rnel,
> but they DO have that kind of leverage over local companies and individua=
ls.
> And it is not uncommon for states not to trust any "western" crypto and
> mandate(!) the use of specific home-grown algorithms instead.
> So if you need to facilitate such requirements from your device incorpora=
ting
> Linux, it's terribly convenient for those algorithms to be part of the ma=
inline kernel.
> As the alternative would be to either maintain those outside of the kerne=
l tree
> or to fork the kernel in its entirety, considering you must support them.
>

So if they have leverage over companies and individuals they have leverage =
over
the linux kernel too :)

I wonder what will be the limits of this leverage. Imagine some state (east=
ern or
western, north or south) starts to require using backdoored crypto because =
they
don't trust something they can't break. Will linux kernel comply?

> i.e. you can't blame them for trying ... and what WOULD be a good reason =
for
> including a certain algorithm anyway?
>

Technical soundness and problems it solves. Speck was already given as exam=
ple.
It was needed due to performance constraints on lower-end devices and when =
it
wasn't needed anymore it was thrown to the bin.

> Regards,
> Pascal, HW Security Architect

Jordan

