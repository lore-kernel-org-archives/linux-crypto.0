Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E767C433FF
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 20:07:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DD182087F
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 20:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564517244;
	bh=f+Eu4tb5w3GVrB5631a9gp39VYC92cikasjorCsdeC4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=ooC2ll3MER8uJmc99VtBKwpijnmPQooHaSJcpL1YX/EbBfMNDVD/EclkB2NO+wfoP
	 MA2oyvyi23tFpu6hNPrZSeq3EW7zKcgX+B6NF2Z5tlpQzNxKnlPNNigOt67EFPwI7Y
	 NdZ22uI0JNXMT80uaTAS/GgkUNHoGdB1KgrSPHpg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbfG3UHX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 16:07:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:59404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbfG3UHX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 16:07:23 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 494ED20693;
        Tue, 30 Jul 2019 20:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564517242;
        bh=f+Eu4tb5w3GVrB5631a9gp39VYC92cikasjorCsdeC4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WrCYn36EKyg1VtwvxOoJ9n1a/1wvy7UGA/zco2sqr9SYgiYWuyao/QbLYA+rA61vy
         /saIKnI4qn8V/ma3Gy4WWtcngJOS+QEuG5clmu9iUj9BZOQtfPgJGdMivhOHcbQmYD
         ahrXjcvoDxudjJb6olUrSdmjzMmXhg3RieQwZOrc=
Date:   Tue, 30 Jul 2019 13:07:20 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Stephan Mueller <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@kernel.org>,
        linux-crypto@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [RFC 3/3] crypto/sha256: Build the SHA256 core separately from
 the crypto module
Message-ID: <20190730200719.GB27287@gmail.com>
Mail-Followup-To: Hans de Goede <hdegoede@redhat.com>,
        Stephan Mueller <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@kernel.org>, linux-crypto@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
References: <20190730123835.10283-1-hdegoede@redhat.com>
 <20190730123835.10283-4-hdegoede@redhat.com>
 <4384403.bebDo606LH@tauon.chronox.de>
 <20190730160335.GA27287@gmail.com>
 <cb888bfa-dd46-de7a-3b90-b54fa79fa3d4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb888bfa-dd46-de7a-3b90-b54fa79fa3d4@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 30, 2019 at 06:07:54PM +0200, Hans de Goede wrote:
> Hi,
> 
> On 30-07-19 18:03, Eric Biggers wrote:
> > On Tue, Jul 30, 2019 at 03:15:35PM +0200, Stephan Mueller wrote:
> > > Am Dienstag, 30. Juli 2019, 14:38:35 CEST schrieb Hans de Goede:
> > > 
> > > Hi Hans,
> > > 
> > > > From: Andy Lutomirski <luto@kernel.org>
> > > > 
> > > > This just moves code around -- no code changes in this patch.  This
> > > > wil let BPF-based tracing link against the SHA256 core code without
> > > > depending on the crypto core.
> > > > 
> > > > Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > > > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > > > Signed-off-by: Andy Lutomirski <luto@kernel.org>
> > > > ---
> > > >   crypto/Kconfig                               |   8 +
> > > >   crypto/Makefile                              |   1 +
> > > >   crypto/{sha256_generic.c => sha256_direct.c} | 103 +--------
> > > 
> > > There is a similar standalone code present for SHA-1 or ChaCha20. However,
> > > this code lives in lib/.
> > > 
> > > Thus, shouldn't the SHA-256 core code be moved to lib/ as well?
> > > 
> > > Ciao
> > > Stephan
> > > 
> > > 
> > 
> > What's wrong with lib/sha256.c?  It's already there.
> 
> That is currently not build under lib/ it is only build as part of
> the helper executable which deals with transitioning from one kernel to
> the next on kexec, specifically it is used by arch/x86/purgatory/purgatory.c
> and also be the s390 purgatory code.
> 
> Since the purgatory use is in a separate binary / name space AFAICT, we
> could add sha256.o to lib/Makefile and then I could use that, but then the
> normal kernel image would have 2 SHA256 implementations.
> 

Well, seems like the solution needs to involve unifying the implementations.

Note that Ard Biesheuvel recently added the arc4 and aes algorithms to
lib/crypto/, with options CONFIG_CRYPTO_LIB_ARC4 and CONFIG_CRYPTO_LIB_AES.  How
about following the same convention, rather than doing everything slightly
differently w.r.t. code organization, function naming, Kconfig option, etc.?

- Eric
