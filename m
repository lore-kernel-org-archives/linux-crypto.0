Return-Path: <SRS0=XJfk=6W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF756C38A2A
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 11:58:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E479621582
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 11:58:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="IcwoMrj0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgEHL6T (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 May 2020 07:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726636AbgEHL6T (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 May 2020 07:58:19 -0400
Received: from mo6-p00-ob.smtp.rzone.de (mo6-p00-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7208C05BD43
        for <linux-crypto@vger.kernel.org>; Fri,  8 May 2020 04:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1588939094;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=1WvgYZUW5x/0YOd5gnSZKgQfiNACcYxxlqxwNW+uRf8=;
        b=IcwoMrj0DA4sAABiBuZruzETgE1OWTbSof+KZTahu8Px8vE1wdzzz9aXgliQAq9HS9
        C3PEdTnKdFcjmd6+mOdbTRkj0+Gc8UrF87S806P/ZZzX9htVNG7goWxba9LutxBydclb
        9xHD1aNrMjmkFLpuy/20BscJR4Ruw3DvjOaipZbpKT1874IUO0WEL8CzACYh/dedup3A
        wczHdIMNAiX1lOHyS9YA4WFnX8COR35tZhEMnBvmMMC0pxPcubVioZCcpcPYR8xD+2iP
        OkBa7yyEXt4vlBSSiFcUFajma1XkUWQ7fjDVHmuTzZjNpIa00HFLNMK9XDRNc1w0cw7w
        b3dg==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaJfSfJdtJ"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.6.2 DYNA|AUTH)
        with ESMTPSA id u08bf3w48BwEQWm
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 8 May 2020 13:58:14 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Alexander Dahl <ada@thorsis.com>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: jitterentropy_rng on armv5 embedded target
Date:   Fri, 08 May 2020 13:58:14 +0200
Message-ID: <6309135.Bj5FvMsAKG@tauon.chronox.de>
In-Reply-To: <2567555.LKkejuagh6@ada>
References: <2567555.LKkejuagh6@ada>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, 8. Mai 2020, 13:40:08 CEST schrieb Alexander Dahl:

Hi Alexander,

> Hello,
>=20
> after upgrading OpenSSL to 1.1.1g on an armv5 based embedded target I had=
 a
> deeper look into entropy generation for that device and stumbled over the=
 in
> kernel 'jitterentropy_rng' module.
>=20
> As far as I understood it's supposed to do the same as the well known
> 'haveged' or the userspace daemon 'jitterentropy-rngd' by Stephan M=FCller
> [1], right?

Yes, precisely. In fact, it is the identical code base of the core=20
functionality that both the kernel and the jitterentropy-rngd uses. See the=
=20
comment at the top of the kernel source code.

> (Although those daemons would solve my problem, I currently try
> to avoid them, because memory on my platform is very restricted and every
> additional running userspace process costs at least around 1 MB.)

If you compile it and you also have AF_ALG for RNGs compiled, you can use i=
t=20
through the AF_ALG interface (see [1] for a library). But IMHO if you are=20
space-constrained, you do not want that code.

Rather use the jitterentropy-library from [2] and link it straight from you=
r=20
application.
>=20
> If so, then how is it supposed to be set up?=20

It is intended for in-kernel purposes (namely to seed its DRBG).

> I built it for 4.9.x LTS, but
> after loading it with 'modprobe' I see nothing in the kernel log and ther=
e's
> no significant change in /proc/sys/kernel/random/entropy_avail (stays well
> below 100 most of the time). Isn't that module supposed to gather entropy
> from cpu timing jitter?
>=20
> Puzzled
> Alex
>=20
> [1] https://www.chronox.de/jent.html

[1] https://www.chronox.de/libkcapi.html

[2] https://github.com/smuellerDD/jitterentropy-library


Ciao
Stephan


