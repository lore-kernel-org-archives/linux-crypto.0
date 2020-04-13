Return-Path: <SRS0=MzAP=55=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8EA5C2BA19
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Apr 2020 13:47:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 836492075E
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Apr 2020 13:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586785678;
	bh=ykz+oUdvZuqEeDitw3NKWogAtpy7iDFRDIavWOYwXsI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=toBaKcK8u5oSBMk7tJ7Nkx5YLRIv3vs3rPpyNY1RIccwRgtW0aaR0+4BdMg7AH/Yz
	 Q3e1aqWjUjJYEAyKPCAmiB72egXSaB8Mz5CpY2AReY2bMGxyJcViaTJCKhcsZsSyf6
	 Pn4t5Mbs+qlNHKF6JXxLVnrywdDpivcd3hlHHeCQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730079AbgDMNr5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Apr 2020 09:47:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730085AbgDMNr5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Apr 2020 09:47:57 -0400
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BBA42078A
        for <linux-crypto@vger.kernel.org>; Mon, 13 Apr 2020 13:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586785676;
        bh=ykz+oUdvZuqEeDitw3NKWogAtpy7iDFRDIavWOYwXsI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qIb/BKe1WGVnyRqen+EPf0MJ6Jpw2bJ57cM9BPkLsTC7lJGw44gfhUIOYND6shFsL
         kZfWb9msZ20sVNUnI7nRI7m6I+isWJ7hf00dg3AdAi3lulFjTETgdz6EZs3ufU+JzD
         HE8PMTUEVCobpNs+Ag5yg5t9/My1MEtC5R6NIpus=
Received: by mail-wr1-f51.google.com with SMTP id u13so9719763wrp.3
        for <linux-crypto@vger.kernel.org>; Mon, 13 Apr 2020 06:47:56 -0700 (PDT)
X-Gm-Message-State: AGi0PuZanKPa7aGEZBHi/VPqT8uEiyqGpL3w2yJz8yNOgp0bi0H/VGYS
        akCuikKUuyDgF5rhPxciqCUkRhm2ZCbqryJP6cHHsQ==
X-Google-Smtp-Source: APiQypIoARLMY5RnvaMFfuJaNJaMrPHezTtGXQYBwTc0kjNGFnP90d4JWD8hICfSQ6xcZhj9UYbFp85BePswakIZOdA=
X-Received: by 2002:a5d:4fcf:: with SMTP id h15mr18483790wrw.262.1586785674798;
 Mon, 13 Apr 2020 06:47:54 -0700 (PDT)
MIME-Version: 1.0
References: <1584100028-21279-1-git-send-email-schalla@marvell.com>
 <20200320053149.GC1315@sol.localdomain> <DM5PR18MB231111CEBDCDF734FA8C670BA0F50@DM5PR18MB2311.namprd18.prod.outlook.com>
 <CAKv+Gu_G4=Dn+6chjk1dQFMXm1aGU8QQZMmy94L5LicmR3itKQ@mail.gmail.com>
 <DM5PR18MB23111DB74B74BED1E08E0DD3A0F00@DM5PR18MB2311.namprd18.prod.outlook.com>
 <DM5PR18MB2311BB76C6A1F5C90B5D6A86A0DD0@DM5PR18MB2311.namprd18.prod.outlook.com>
In-Reply-To: <DM5PR18MB2311BB76C6A1F5C90B5D6A86A0DD0@DM5PR18MB2311.namprd18.prod.outlook.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 13 Apr 2020 15:47:43 +0200
X-Gmail-Original-Message-ID: <CAKv+Gu9=bzFkDkFrkkmB-xM_Ff4ECR9Q5rPqmby6fijZsQmG0Q@mail.gmail.com>
Message-ID: <CAKv+Gu9=bzFkDkFrkkmB-xM_Ff4ECR9Q5rPqmby6fijZsQmG0Q@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH v2 0/4] Add Support for Marvell OcteonTX Cryptographic
To:     Srujana Challa <schalla@marvell.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Narayana Prasad Raju Athreya <pathreya@marvell.com>,
        Suheil Chandran <schandran@marvell.com>,
        "arno@natisbad.org" <arno@natisbad.org>,
        "bbrezillon@kernel.org" <bbrezillon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 13 Apr 2020 at 15:21, Srujana Challa <schalla@marvell.com> wrote:
>
> > Subject: RE: [EXT] Re: [PATCH v2 0/4] Add Support for Marvell OcteonTX
> > Cryptographic
> >
> > > On Fri, 20 Mar 2020 at 06:47, Srujana Challa <schalla@marvell.com> wr=
ote:
> > > >
> > > > > On Fri, Mar 13, 2020 at 05:17:04PM +0530, Srujana Challa wrote:
> > > > > > The following series adds support for Marvell Cryptographic Acc=
elerarion
> > > > > > Unit (CPT) on OcteonTX CN83XX SoC.
> > > > > >
> > > > > > Changes since v1:
> > > > > > * Replaced CRYPTO_BLKCIPHER with CRYPTO_SKCIPHER in Kconfig.
> > > > > >
> > > > > > Srujana Challa (4):
> > > > > >   drivers: crypto: create common Kconfig and Makefile for Marve=
ll
> > > > > >   drivers: crypto: add support for OCTEON TX CPT engine
> > > > > >   drivers: crypto: add the Virtual Function driver for CPT
> > > > > >   crypto: marvell: enable OcteonTX cpt options for build
> > > > >
> > > > > There's no mention of testing.  Did you try
> > > > > CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=3Dy?
> > > > >
> > > > Yes, the crypto self-tests are passed.
> > >
> > > *which* selftests are passed? Please confirm that they all passed wit=
h
> > > that kconfig option set
> > Apologies. I have overlooked the config option, I thought it was
> > CONFIG_CRYPTO_MANAGER_DISABLE_TESTS, all crypto self-tests are passed
> > with this option disabled. I have started verifying with
> > CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=3Dy, I am getting few errors for
> > unsupported input lengths, will submit the patch with fixes.
>
> We confirmed that the failures are with unsupported lengths on our hardwa=
re, for some lengths we can resolve the issue by having validation checks i=
n the driver but for some unsupported cases "testmgr.c" is excepting always=
 success, I am still unsure how to fix/prevent these kind of failures. Can =
anyone please kindly help me out how to proceed on this issue.
> Thanks for your help.

You need to allocate fallbacks for the modes that your driver cannot
support. There are plenty of examples of that in the kernel tree.
