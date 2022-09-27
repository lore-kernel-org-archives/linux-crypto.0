Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5AE4C54EE9
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Sep 2022 19:46:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbiI0TqX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 27 Sep 2022 15:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiI0TqW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Sep 2022 15:46:22 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75EE81B3490
        for <linux-crypto@vger.kernel.org>; Tue, 27 Sep 2022 12:46:20 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id ay36so7257609wmb.0
        for <linux-crypto@vger.kernel.org>; Tue, 27 Sep 2022 12:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:to:from:date:from:to:cc
         :subject:date;
        bh=DeB7QMH3bIq5iaWc+HNtDZ/EEbhGqYVc00tj6aMlmZM=;
        b=6d19iBbLjJfjcI3h5ypTQXXNp8K1NZfNM8svzDzOme2DYusajPqmg7VXzWgUo7HcTr
         W2lWdZWDO6uGFWijF+Ldubxs9S+syHIV+Hz1syz9fU8RLrk4QWAFvJDRhi+9HJpiNQdf
         Xrk2HP5CXO4HQUT0LnFVC6Fs4Tu/L3QEOk7jYUrcxQs51sO7NrolM5YE2CFoF1iI4tkB
         m12nIJsOnRThu6N7vSxBMDCvO4mqYVtlMGH8pjTubyooLN+iCGKLhwoFUjsCMG+Bv6CT
         LZLblnWW96/5b/tBiUjaEtXmlx7aoeQf+cFSf54sjwvixqarV6w4Fx+0tjTDl1x8vCqJ
         PKng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=DeB7QMH3bIq5iaWc+HNtDZ/EEbhGqYVc00tj6aMlmZM=;
        b=XelcuFIJIajvoQ7Lc+orgp3MqM041TOfiobnIEXieC6uY/oTEaEGf1rmLdKmizYwOz
         l4+X+nGTmsUgcCq7R0uNgRchVMyOU6q8M3RB4myFFrg3TLdjhYfubbU/nKl/sATKILgW
         gNDwwDkJBQJ+PjQI4gTSLi9qaAyqmtAa2ngBFXlAf3s8mgicM0MCzc593LoGe71N7xPa
         YCjSLJi/xbxE1fY9Nyp3t5yvtNscTDsAzSBaABSDyWDTYzP2JNRTv5H8rUoGznjKewvo
         +1VQy7xY7xfWrHuUSaAq/L2QoEW4DJgRKVAtQq9uqf0ZFCP1+PCNmM9r//QSSrHJfE0n
         4fbQ==
X-Gm-Message-State: ACrzQf3GnkM00lqeL+FafUEgScNUuNHn5yyyn4s0R3c/OZ1rrgl/SEPS
        3zquV2EGIWPkredDJ1OlyIo0sJpoN4g1rA==
X-Google-Smtp-Source: AMsMyM6A9nO9S0tgG3oTWD9BFg3cuE4+ACkC9O+BJbF8uOGSQDV2r48m9qfcYk2ORWaJ6ZvG/NUJ8A==
X-Received: by 2002:a05:600c:a46:b0:3a6:9c49:b751 with SMTP id c6-20020a05600c0a4600b003a69c49b751mr4024777wmq.169.1664307979007;
        Tue, 27 Sep 2022 12:46:19 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id ay11-20020a05600c1e0b00b003b47a99d928sm2857278wmb.18.2022.09.27.12.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 12:46:18 -0700 (PDT)
Date:   Tue, 27 Sep 2022 21:46:15 +0200
From:   LABBE Corentin <clabbe@baylibre.com>
To:     Robin Murphy <robin.murphy@arm.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Lin Jinhan <troy.lin@rock-chips.com>, wevsty <ty@wevs.org>,
        Mikhail Rudenko <mike.rudenko@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Lin Huang <hl@rock-chips.com>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        linux-rockchip@lists.infradead.org
Subject: Re: [PATCH] hw_random: rockchip: import driver from vendor tree
Message-ID: <YzNTB+RQK6yITi7/@Red>
References: <20220919210025.2376254-1-Jason@zx2c4.com>
 <32f8797a-4b65-69df-ee8e-7891a6b4f1af@arm.com>
 <YzMm4d3sZBHpitm9@aurel32.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YzMm4d3sZBHpitm9@aurel32.net>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Tue, Sep 27, 2022 at 06:37:53PM +0200, Aurelien Jarno a écrit :
> On 2022-09-20 10:35, Robin Murphy wrote:
> > On 2022-09-19 22:00, Jason A. Donenfeld wrote:
> > > The Rockchip driver has long existed out of tree, but not upstream.
> > > There is support for it upstream in u-boot, but not in Linux proper.
> > > This commit imports the GPLv2 driver written by Lin Jinhan, together
> > > with the DTS and config blobs from Wevsty.
> > 
> > Note that Corentin has a series enabling the full crypto driver for 
> > RK3328 and RK3399[1], so it would seem more sensible to add TRNG support 
> > to that. Having confliciting compatibles for the same hardware that 
> > force the user to change their DT to choose one functionality or the 
> > other isn't good (plus there's also no binding for this one).
> 
> It might make sense for the cryptov1-rng driver (I haven't checked). For
> the cryptov2-rng driver, I looked at the RK3568 TRM (I can't find the
> RK3588 one), and from what I understand crypto and TRNG are two
> different devices, using different address spaces, clock, reset and
> interrupts. The vendor kernel uses two different drivers.
> 

I confirm that TRNG is not on the same IP on rk3568, something I didnt remark when doing my V2 driver. (I need to remove rng clock from rk3568 dt).
But the rk3588 crypto IP and the TRNG are in the same device.

