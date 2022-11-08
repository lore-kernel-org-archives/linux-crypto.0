Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0649BC433FE
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Nov 2022 11:00:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233808AbiKHLAw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Nov 2022 06:00:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233479AbiKHLAu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Nov 2022 06:00:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74166450B3
        for <linux-crypto@vger.kernel.org>; Tue,  8 Nov 2022 03:00:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CD73B81A02
        for <linux-crypto@vger.kernel.org>; Tue,  8 Nov 2022 11:00:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C647C433C1;
        Tue,  8 Nov 2022 11:00:46 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="nmdTB7BR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1667905243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WxOm/dhL4xutU/zruQMKmmZqLcH+m6nTHTBLvZpELdk=;
        b=nmdTB7BR3b4Ot5fy5nST3ZHs8aC1QDFXxu+Mo24H/UnwEQrdxwiLSj4nJkm+PVMy8iEG1V
        PhQFyVdwdoM6z1oZ4nHpR6YEWAutZrsvA9Dn06Z0B5dVLCAL4kjnMZRLg5A/0F8iQXTUgW
        DyVpN9onC42n73IkMXFSrG3hYBA8120=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 31a43900 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 8 Nov 2022 11:00:43 +0000 (UTC)
Date:   Tue, 8 Nov 2022 12:00:40 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [PATCH v3] hw_random: use add_hwgenerator_randomness() for early
 entropy
Message-ID: <Y2o22ODqUZNO4NsR@zx2c4.com>
References: <Y2fJy1akGIdQdH95@zx2c4.com>
 <20221106150243.150437-1-Jason@zx2c4.com>
 <1839f462-dccb-b926-1acd-f1bb5f5776ba@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1839f462-dccb-b926-1acd-f1bb5f5776ba@collabora.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 08, 2022 at 11:53:23AM +0100, AngeloGioacchino Del Regno wrote:
> Il 06/11/22 16:02, Jason A. Donenfeld ha scritto:
> > Rather than calling add_device_randomness(), the add_early_randomness()
> > function should use add_hwgenerator_randomness(), so that the early
> > entropy can be potentially credited, which allows for the RNG to
> > initialize earlier without having to wait for the kthread to come up.
> > 
> > This requires some minor API refactoring, by adding a `sleep_after`
> > parameter to add_hwgenerator_randomness(), so that we don't hit a
> > blocking sleep from add_early_randomness().
> > 
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
> > ---
> > Herbert - it might be easiest for me to take this patch if you want? Or
> > if this will interfere with what you have going on, you can take it. Let
> > me know what you feel like. -Jason
> > 
> >   drivers/char/hw_random/core.c |  8 +++++---
> >   drivers/char/random.c         | 12 ++++++------
> >   include/linux/random.h        |  2 +-
> >   3 files changed, 12 insertions(+), 10 deletions(-)
> > 
> 
> Hello,
> 
> I tried booting next-20221108 on Acer Tomato Chromebook (MediaTek MT8195) but
> this commit is producing a kernel panic.


Thanks for the report. I see exactly what the problem is, and I'll send
a v+1 right away.

Jason
