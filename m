Return-Path: <SRS0=dn2r=SD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	FREEMAIL_REPLYTO_END_DIGIT,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B926C43381
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Apr 2019 10:51:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F419C2086C
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Apr 2019 10:51:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.ch header.i=@protonmail.ch header.b="sPxW0CTo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbfDAKvT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Apr 2019 06:51:19 -0400
Received: from mail-40136.protonmail.ch ([185.70.40.136]:23676 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbfDAKvS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Apr 2019 06:51:18 -0400
Date:   Mon, 01 Apr 2019 10:51:11 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.ch;
        s=default; t=1554115875;
        bh=CCZn8bOyNqrgx3fwNQqpHv1QiduLLDmeLTfHAW7nXws=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:
         Feedback-ID:From;
        b=sPxW0CToNcyuiprk9gzOUy6TXevgSdmvYpP7f3D2bALzkupwq8BkbgqfGJ589YysR
         gsrN/rRoumec+/hObch4aFl3z6C19Ablli2/dJq0a1h6LtWO6E9QmhsqO0ydRBdm/S
         3onTtMuE0SPfzv/LtkXblpXElsGlsWFSx6AReXzo=
To:     Vitaly Chikunov <vt@altlinux.org>
From:   Jordan Glover <Golden_Miller83@protonmail.ch>
Cc:     Eric Biggers <ebiggers@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Reply-To: Jordan Glover <Golden_Miller83@protonmail.ch>
Subject: Re: Should we consider removing Streebog from the Linux Kernel?
Message-ID: <LTLnFwnutvaWrlb3nFL9UEbwFqGlQPrULSlMM7Wli53B65WOofk1Vpp_ycEazJ3ore49c12K7UsDVHIOf8xuN5tepSyH0b-8zmP4gELpaVo=@protonmail.ch>
In-Reply-To: <20190401100437.6tivlvp53zjprda6@altlinux.org>
References: <20190325044550.GI5675@mit.edu>
 <20190325060041.wl23bncqjab7dj5c@altlinux.org>
 <20190331224329.GA681@sol.localdomain>
 <20190401100437.6tivlvp53zjprda6@altlinux.org>
Feedback-ID: QEdvdaLhFJaqnofhWA-dldGwsuoeDdDw7vz0UPs8r8sanA3bIt8zJdf4aDqYKSy4gJuZ0WvFYJtvq21y6ge_uQ==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Monday, April 1, 2019 10:04 AM, Vitaly Chikunov <vt@altlinux.org> wrote:

> >
> > Can you elaborate on why you want to use Streebog? When we added Speck,=
 we
> > explained in great detail why it was useful from a technical perspectiv=
e (before
> > Adiantum was ready). I don't see any such explanation for Streebog.
>
> Our users demand that file integrity is implemented using their national
> standard algorithm.
>
> Thanks,

Does it mean that every state can demand from Linux kernel to carrying cryp=
to
algorithms of their choice?

Jordan
