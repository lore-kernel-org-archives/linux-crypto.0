Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86A3AC433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Mar 2021 09:22:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F25C64FDC
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Mar 2021 09:22:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235960AbhCPJVy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Mar 2021 05:21:54 -0400
Received: from mail-40134.protonmail.ch ([185.70.40.134]:43451 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236014AbhCPJVx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Mar 2021 05:21:53 -0400
Date:   Tue, 16 Mar 2021 09:21:46 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tmb.nu;
        s=protonmail; t=1615886511;
        bh=DYBFBRt+bYuYdXAGu4685KjG5Sr9XGlWVAnmFisymf8=;
        h=Date:To:From:Reply-To:Subject:From;
        b=mdfNpedpYSmko2yzJM4Jq9ewEbDj6X2cDpAcHWMG2O45rKeRTmpadKC3b6PPx2wqp
         h8CPVjVLrsLwJozprco2N7sT00qpSXilqqVfeu70/CgNzT5BwdrmLSeM0w+/FAcGEF
         1upI2/erjbEBNWL2pFyrySlhGr/GqYIub8/ZY8so=
To:     Ard Biesheuvel <ardb@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
From:   Thomas Backlund <tmb@tmb.nu>
Reply-To: Thomas Backlund <tmb@tmb.nu>
Subject: Re: stable request
Message-ID: <d5c825ba-cdcb-29eb-c434-83ef4db05ee0@tmb.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Den 16.3.2021 kl. 08:37, skrev Ard Biesheuvel:
> Please consider backporting commit
>
> 86ad60a65f29dd862a11c22bb4b5be28d6c5cef1
> crypto: x86/aes-ni-xts - use direct calls to and 4-way stride
>
> to stable. It addresses a rather substantial retpoline-related
> performance regression in the AES-NI XTS code, which is a widely used
> disk encryption algorithm on x86.
>

To get all the nice bits, we added the following in Mageia 5.10 / 5.11
series kerenels (the 2 first is needed to get the third to apply/build
nicely):

applied in this order:

 From 032d049ea0f45b45c21f3f02b542aa18bc6b6428 Mon Sep 17 00:00:00 2001
From: Uros Bizjak <ubizjak@gmail.com>
Date: Fri, 27 Nov 2020 10:44:52 +0100
Subject: [PATCH] crypto: aesni - Use TEST %reg,%reg instead of CMP $0,%reg

 From ddf169a98f01d6fd46295ec0dd4c1d6385be65d4 Mon Sep 17 00:00:00 2001
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 8 Dec 2020 00:34:02 +0100
Subject: [PATCH] crypto: aesni - implement support for cts(cbc(aes))

 From 86ad60a65f29dd862a11c22bb4b5be28d6c5cef1 Mon Sep 17 00:00:00 2001
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 31 Dec 2020 17:41:54 +0100
Subject: [PATCH] crypto: x86/aes-ni-xts - use direct calls to and 4-way
stride

 From 2481104fe98d5b016fdd95d649b1235f21e491ba Mon Sep 17 00:00:00 2001
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 31 Dec 2020 17:41:55 +0100
Subject: [PATCH] crypto: x86/aes-ni-xts - rewrite and drop indirections
via glue helper

--
Thomas

