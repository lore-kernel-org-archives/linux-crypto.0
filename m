Return-Path: <SRS0=zerQ=ZI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACC86C432C3
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Nov 2019 07:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CBA120728
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Nov 2019 07:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573889553;
	bh=zvglgSWJ6QjYIekZR+EO9aF2ale+AA8m4tPCy7g+h3g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=cz9cECXL3B8wmYIxpANaEBDCZpjAMdRi8XfZg3xPIQF+EnyV7ircv4wOf3Jnd52tX
	 9LqhYkufkESxk8vf0o3/jpmwc2WVB023cqhIwbZcgb+pcEEwD8GAaHq3+UaOhZ37Wo
	 ZXpPi+UDi5ISKX4TqBIVGEwuuzgnSUL4Kq1uRLFo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbfKPHcc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 16 Nov 2019 02:32:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:41242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbfKPHcc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 16 Nov 2019 02:32:32 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50C5B206D6;
        Sat, 16 Nov 2019 07:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573889551;
        bh=zvglgSWJ6QjYIekZR+EO9aF2ale+AA8m4tPCy7g+h3g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ur+Usnw3CiHyZNjJgShg8J2UL/SY1m5HSqHhHC7GIOcUSF14nqYEAziVq6ciMunLI
         Y++NsJEqc7p5b3AWLjw5B7lQZRum/YjM8pCE/0uteVGYM2KiVUXCB6xG8afeKPHmFp
         Ls4y5LNtOcaLbiBlddsyOR4aWgp4KSRlHp/OzBbk=
Date:   Fri, 15 Nov 2019 23:32:29 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Vitaly Andrianov <vitalya@ti.com>
Subject: Re: [PATCH] hwrng: ks-sa: Add minimum sleep time before ready-polling
Message-ID: <20191116073229.GA161720@sol.localdomain>
References: <20191106093019.117233-1-alexander.sverdlin@nokia.com>
 <20191115060610.2sjw7stopxr73jhn@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115060610.2sjw7stopxr73jhn@gondor.apana.org.au>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 15, 2019 at 02:06:10PM +0800, Herbert Xu wrote:
> On Wed, Nov 06, 2019 at 09:30:49AM +0000, Sverdlin, Alexander (Nokia - DE/Ulm) wrote:
> > From: Alexander Sverdlin <alexander.sverdlin@nokia.com>
> > 
> > Current polling timeout is 25 us. The hardware is currently configured to
> > harvest the entropy for 81920 us. This leads to timeouts even during
> > blocking read (wait=1).
> > 
> > Log snippet:
> > [    5.727589] [<c040ffcc>] (ks_sa_rng_probe) from [<c04181e8>] (platform_drv_probe+0x58/0xb4)
> > ...
> > [    5.727805] hwrng: no data available
> > ...
> > [   13.157016] random: systemd: uninitialized urandom read (16 bytes read)
> > [   13.157033] systemd[1]: Initializing machine ID from random generator.
> > ...
> > [   15.848770] random: fast init done
> > ...
> > [   15.848807] random: crng init done
> > 
> > After the patch:
> > [    6.223534] random: systemd: uninitialized urandom read (16 bytes read)
> > [    6.223551] systemd[1]: Initializing machine ID from random generator.
> > ...
> > [    6.876075] random: fast init done
> > ...
> > [    6.954200] random: systemd: uninitialized urandom read (16 bytes read)
> > [    6.955244] random: systemd: uninitialized urandom read (16 bytes read)
> > ...
> > [    7.121948] random: crng init done
> > 
> > Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
> > ---
> >  drivers/char/hw_random/ks-sa-rng.c | 38 ++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 38 insertions(+)
> 
> Patch applied.  Thanks.

This is causing a build error.  Seems that a line of the patch in
ks_sa_rng_init() went missing when it was applied...?

drivers/char/hw_random/ks-sa-rng.c: In function 'ks_sa_rng_init':
drivers/char/hw_random/ks-sa-rng.c:146:47: error: 'clk_rate' undeclared (first use in this function)
  146 |  ks_sa_rng->refill_delay_ns = refill_delay_ns(clk_rate);
      |                                               ^~~~~~~~
drivers/char/hw_random/ks-sa-rng.c:146:47: note: each undeclared identifier is reported only once for each function it appears in
