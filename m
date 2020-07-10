Return-Path: <SRS0=tT4M=AV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6101FC433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jul 2020 15:10:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B862020720
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jul 2020 15:10:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="svnXObgB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgGJPKs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jul 2020 11:10:48 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.216]:32864 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgGJPKq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jul 2020 11:10:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1594393844;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=qyhKDaRFDJabGY4zMcfXyWgOvQgQ2vWqZw0NQOyZqYA=;
        b=svnXObgBMm8Xh7Z70J3g2vKn2vkK3+hIbdzuJoruQiboDrb69uTXL09n5D+EDB4eR9
        p5VfU/qLj7uN0IE59Ihs30xbOU4phoFLmjzSF8d/TTXM9Tsb8zcKyxAtFuJQf1IS/uFK
        qApzsCaBo4OTjwd2f+RN5f7S4bkQciZruZ8djhNKleOali9p1rx1mn7uEYlrbotdDrKw
        Xy21pT6oDaxGoG0KbO/m7n0F9cUTfiha9P5vU2HCFiuH/82AB/Yc0eMRSOwiqJeObBgC
        onpJJyy7Acvgi7bTeA6n7jFy/LVlQM80PkPVaG7CUVUpPrXWg5ur7yFzN4Bpa5z3G4TG
        +/sQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaIvSfHReW"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.10.5 DYNA|AUTH)
        with ESMTPSA id y0546bw6AFADbM0
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 10 Jul 2020 17:10:13 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Marcelo Cerri <marcelo.cerri@canonical.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: Re: [PATCH 2/3] lib/mpi: Add mpi_sub_ui()
Date:   Fri, 10 Jul 2020 17:10:13 +0200
Message-ID: <3722167.kQq0lBPeGt@tauon.chronox.de>
In-Reply-To: <CAMj1kXFjzHphXUt7Hesj_EAOJmar9Du1U6YM9X+davMOB6tcng@mail.gmail.com>
References: <2543601.mvXUDI8C0e@positron.chronox.de> <4577235.31r3eYUQgx@positron.chronox.de> <CAMj1kXFjzHphXUt7Hesj_EAOJmar9Du1U6YM9X+davMOB6tcng@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, 10. Juli 2020, 16:42:39 CEST schrieb Ard Biesheuvel:

Hi Ard,

> On Fri, 10 Jul 2020 at 13:16, Stephan M=FCller <smueller@chronox.de> wrot=
e:
> > Add mpi_sub_ui() based on Gnu PG mpz_sub_ui() from mpz/aors_ui.h
> > adapting the code to the kernel's structures and coding style and also
> > removing the defines used to produce mpz_sub_ui() and mpz_add_ui()
> > from the same code.
>=20
> Isn't GnuPG GPLv3 ?

Thanks for pointing that out. It is actually a mix-up - the function is fro=
m=20
Gnu MP and not GnuPG.

Gnu MP is GPLv2 and GPLv3.

I will have that corrected with a 2nd patch.

Thanks

Ciao
Stephan


