Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1A01C38145
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Sep 2022 13:02:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiIGNCt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Sep 2022 09:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiIGNCs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Sep 2022 09:02:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13FC66A6D;
        Wed,  7 Sep 2022 06:02:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2434AB81CB9;
        Wed,  7 Sep 2022 13:02:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B20FC433C1;
        Wed,  7 Sep 2022 13:02:44 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="JiTLGNM9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1662555762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6JnDWPB8zPyYC1o9rOiub0T0z17IVTGKFuNGktlGb6E=;
        b=JiTLGNM9yFxC+uSqY9TSUolPey46SAPlKdXUh1Jlw4KXJx10ckJLg/RgnEeaeOFXdFmU/8
        QXSDvt3HBY/GNCtvuA2Gp+CINuuH90zfiqlhMDWrVRS9KPAEqhlQSRr0dhvz4JxadMTnGN
        BLX8JDcPy7imp+VNqa0D33ELJIYyfZs=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 937252bf (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 7 Sep 2022 13:02:41 +0000 (UTC)
Date:   Wed, 7 Sep 2022 15:02:34 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Dominik Brodowski <linux@dominikbrodowski.net>
Cc:     linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] random: use hwgenerator randomness more frequently at
 early boot
Message-ID: <YxiWajR2FEW6YRud@zx2c4.com>
References: <20220904101753.3050-1-linux@dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220904101753.3050-1-linux@dominikbrodowski.net>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Dominik,

On Sun, Sep 04, 2022 at 12:17:53PM +0200, Dominik Brodowski wrote:
> Mix in randomness from hw-rng sources more frequently during early
> boot, approximately once for every rng reseed.

Nice idea.

> Jason, if you prefer that this patch can be applied first (as it
> makes sense also independently of the other patch), this ordering
> should be trivial to change.

I'll apply this patch first, yea, since it's independent.

> -static bool crng_has_old_seed(void)
> +static unsigned int crng_interval(void)

crng_reseed_interval() instead?

Jason
