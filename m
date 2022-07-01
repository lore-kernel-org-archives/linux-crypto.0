Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1725C43334
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Jul 2022 14:55:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbiGAOzb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Jul 2022 10:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbiGAOza (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Jul 2022 10:55:30 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A3727FF4
        for <linux-crypto@vger.kernel.org>; Fri,  1 Jul 2022 07:55:28 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id i1so3565951wrb.11
        for <linux-crypto@vger.kernel.org>; Fri, 01 Jul 2022 07:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=aKmhqWsvz2VXt/NxPWZTmSfapGdUQJOe7XuueEGMywA=;
        b=q7+4mVv9tGFQDYiHUjyiZhWOet/va8+qMXYFOdyNBU6x5hh0p/oE2lRkR7wEInuyyX
         njarglTDvX8/WBvF5xCWpQ90YXMrij4tXs99p5lLzfEk9B0iGhvJTTw4yI3drnDlt5XS
         lnhx8sGxE1b2ouu4aIo5+HzV3huTYEkpTvVHhvuQmuhVkNEpAzAcejTB4oO/QQk4g4jq
         HpC+BRflTl7YknywuQmrycZRm2eJWEo9XUorIGW1B4vcty520Jc+Q5lYvsGqO1yNfwTW
         wqjRhywZOUy3R7HsxEMdDhEUQ8P/9dODWLeKaRFkb6QmBmBMjm3h90Qp4PEUyVHi3YCs
         ruRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=aKmhqWsvz2VXt/NxPWZTmSfapGdUQJOe7XuueEGMywA=;
        b=Bjj5/l9G4XElFCxibl7Qs4UgOzR6X6UQP/p8gf8O++nIyGl5UxadR4bTpajP//5x5X
         XjcM2ibrsvRW+lldgURdT95IrphqDH3VyQwLccn/+fP5SmyiC+6wKqPGlHinmluQUciB
         9yvwNU6im33pB8WRxSFj6xuN7ZHHcYCblmufIlCmBHbCWj6n2R/I/3+SzG93l3ZN5BVZ
         a4unAHleIQBth1U7a6T3cIMPGztOd/+kg4kFYKO/r4B4Wuf9WTPoQDHq1U1EjRQu7CZm
         zeEggGBhCjm+nrfA/g3hJVGVVl2eF6jnf8GTRcgJ2pZiCoDm9a+tkU8E9qS7gnocfrk6
         8dNA==
X-Gm-Message-State: AJIora/xb6SEGJIBStaCZUXv1nekR4Hl08ehIbfIpgGSRbVTWsGaMX/e
        JUf70auqHFvoACvPW4JhxTOKAbaMJP434g==
X-Google-Smtp-Source: AGRyM1tCIA07jyVpPAgoHKY5VvDK82sz/FIuyrKzmAOblKWvPhdFd7fSDEiruHGXEYgIAT5QawR1jA==
X-Received: by 2002:a5d:4b08:0:b0:21d:2ea6:2fe0 with SMTP id v8-20020a5d4b08000000b0021d2ea62fe0mr12365732wrq.144.1656687327276;
        Fri, 01 Jul 2022 07:55:27 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id b8-20020a05600c4e0800b003974cb37a94sm7081073wmq.22.2022.07.01.07.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 07:55:26 -0700 (PDT)
Date:   Fri, 1 Jul 2022 16:55:24 +0200
From:   LABBE Corentin <clabbe@baylibre.com>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     herbert@gondor.apana.org.au, hch@lst.de, heiko@sntech.de,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-sunxi@lists.linux.dev,
        Ben Dooks <ben.dooks@codethink.co.uk>
Subject: Re: [RFC PATCH] crypto: flush poison data
Message-ID: <Yr8K3Kxm6QzGY/g4@Red>
References: <20220701132735.1594822-1-clabbe@baylibre.com>
 <20220701153614.0a576f9c@donnerap.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220701153614.0a576f9c@donnerap.cambridge.arm.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Fri, Jul 01, 2022 at 03:36:14PM +0100, Andre Przywara a écrit :
> On Fri,  1 Jul 2022 13:27:35 +0000
> Corentin Labbe <clabbe@baylibre.com> wrote:
> 
> Hi,
> 
> > On my Allwinner D1 nezha, the sun8i-ce fail self-tests due to:
> > alg: skcipher: cbc-des3-sun8i-ce encryption overran dst buffer on test vector 0
> > 
> > In fact the buffer is not overran by device but by the dma_map_single() operation.
> > 
> > To prevent any corruption of the poisoned data, simply flush them before
> > giving the buffer to the tested driver.
> > 
> > Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> > ---
> > 
> > Hello
> > 
> > I put this patch as RFC, since this behavour happen only on non yet merged RISCV code.
> > (Mostly riscv: implement Zicbom-based CMO instructions + the t-head variant)
> > 
> > Regards
> > 
> >  crypto/testmgr.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> > index c59bd9e07978..187163e2e593 100644
> > --- a/crypto/testmgr.c
> > +++ b/crypto/testmgr.c
> > @@ -19,6 +19,7 @@
> >  #include <crypto/aead.h>
> >  #include <crypto/hash.h>
> >  #include <crypto/skcipher.h>
> > +#include <linux/cacheflush.h>
> >  #include <linux/err.h>
> >  #include <linux/fips.h>
> >  #include <linux/module.h>
> > @@ -205,6 +206,8 @@ static void testmgr_free_buf(char *buf[XBUFSIZE])
> >  static inline void testmgr_poison(void *addr, size_t len)
> >  {
> >  	memset(addr, TESTMGR_POISON_BYTE, len);
> > +	/* Be sure data is written to prevent corruption from some DMA sync */
> > +	flush_icache_range((unsigned long)addr, (unsigned long)addr + len);
> 
> As Ben already mentioned, this looks like having nothing to do with the I
> cache. I guess you picked that because it does the required cache cleaning
> and doesn't require a vma parameter?

The reality is simpler, I just copied what did drivers/crypto/xilinx/zynqmp-sha.c

> 
> But more importantly: I think drivers shouldn't do explicit cache
> maintenance, this is what the DMA API is for.
> So if you get DMA corruption, then this points to some flaw in the DMA API
> usage: either the buffer belongs to the CPU, then the device must not write
> to it. Or the buffer belongs to the device, then the CPU cannot expect to
> write to that without that data potentially getting corrupted.

The device does nothing wrong, I removed all sun8i-ce device action (and kept DMA API actions) and the the whole buffer is still corrupted.
Anyway if the driver was doing something wrong, it should have fail on arm or arm64.

See my previous report https://lore.kernel.org/lkml/YllWTN+15CoskNBt@Red/ which show the problem (The invalidated size is bigger than the dma_sync length parameter)

