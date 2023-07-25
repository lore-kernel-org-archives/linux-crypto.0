Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11C90C001DE
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jul 2023 09:15:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbjGYJPV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Jul 2023 05:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjGYJPU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jul 2023 05:15:20 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.167])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09AEE8E
        for <linux-crypto@vger.kernel.org>; Tue, 25 Jul 2023 02:15:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1690276504; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=R4rIuvP7QwugOCU1XGx4gXzv1wfAJwpLm9jazWPws19B1VCZ84d2Kc0zwoAcuO8amu
    PI/elMetMUPjkKKONYxxc7hhlFL4s9hlvssF4HxhrbzmngC+0kZ3/cNDPQ/vXdO5ODGj
    zRRkoWil61go1kSnXMKwnKGyFoVGhy8+kFwZPgtc3PnUC9NpQyZwiE2DuBKZKfqaQK6F
    OlI2m6BR2qXm8rXxlaibcvP/Odm3lnA9w2qgt8q44Og0luVQawAKjdyhPHy7Q0bmztZS
    VbCb6FVH8xRKI7jQ/6ceu5FqE9QBoYtbr0HrcoMAVrD/Yvj3iFOgIcmJ7M/B/goxj5VL
    wMhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1690276504;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=5Ty3actpIKOzXOT3h43HeDnVLX2pUdaRur3TOP3VrlQ=;
    b=RX/xRj6mXG6HwHvybubpfPASn24r51soS0U07L4AmfFiyK2jrK7gT2pjhDvnVnCG6N
    TI6WuN+1AXRTNkCgrKIiG/UEwMGzGBSD31GcnIUtnxGK+AmWian7Ark2BNX2WENUVHCx
    MVMlh+bO0al52eKL9He+3dNHDm4MkiT6Q3W345BBkJENknrz2NOn4d0o2nK9e9jHy2qN
    9rEbPMxrxLqavqARX4zST5kjmqkTL1gFKFEGPlBCOlGm9q4pky3y9vzk5Yxd7qr823kO
    gcMTPEs88lZXIsXr+mxkqDRu0RxxoqXWdV8/ZuRPe1qVMZdV6kBhs5Xn7Q4B4hWw3Hds
    5WUQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1690276504;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=5Ty3actpIKOzXOT3h43HeDnVLX2pUdaRur3TOP3VrlQ=;
    b=kdjlezXOkWo+yuN1YTbMxvvw7FuDQ1mLJHU5Vy7CMdLCTcAQ+mkm5C1NIjpbIcyPWf
    kgNhEw9j1Hade5Os5KUSE3W8MOSRRGlOdo9y0zcorocQC0hDbZl87vBPgkSyN4Z8rd1Q
    xFA02G0Tc8DVPYfbSAqvYJHa/lfzVcP3Yo8pieTcRewh6XPgSJgxFK7mXrxAwgO1LVRG
    46gkMr8NgkXmpViY4GYXLEn9CEpApkmarnvpWhOdxOr28GobV2rMtkLeMps+mZmngM6R
    NUnYJ5oHN8Tm7xb3PJJa50B1t5l353llMC67TIrhpGE5Kbby/oqGVLzGI0EYYqyY+Sv0
    cIRw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1690276504;
    s=strato-dkim-0003; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=5Ty3actpIKOzXOT3h43HeDnVLX2pUdaRur3TOP3VrlQ=;
    b=1RTfSd7Jqs8a3sm0kUnDPdeHURdyLjrXg4fwpSCXQA89HwVXLrYqqkKSyOOID99Q5t
    R0ht2lUovtCcxtfhtrCA==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9zW8BKRp5UFiyGZZ4jof7Xg=="
Received: from tauon.chronox.de
    by smtp.strato.de (RZmta 49.6.6 AUTH)
    with ESMTPSA id N24d58z6P9F250Q
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 25 Jul 2023 11:15:02 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Stefan Wahren <stefan.wahren@i2se.com>
Cc:     linux-crypto@vger.kernel.org, Vladis Dronov <vdronov@redhat.com>,
        Marcelo Cerri <marcelo.cerri@canonical.com>,
        Joachim Vandersmissen <git@jvdsn.com>,
        John Cabaj <john.cabaj@canonical.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Bug: jitter entropy health test unreliable on Rpi 4 (arm64)
Date:   Tue, 25 Jul 2023 11:15:02 +0200
Message-ID: <1951595.QhWbZbYsJX@tauon.chronox.de>
In-Reply-To: <68c6b70a-8d6c-08b5-46ce-243607479d5c@i2se.com>
References: <68c6b70a-8d6c-08b5-46ce-243607479d5c@i2se.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, 21. Juli 2023, 14:28:29 CEST schrieb Stefan Wahren:

Hi Stefan,

sorry for the delay.

> Hi,
> 
> i recently tested Linux 6.5-rc2 on the Raspberry Pi 4 (arm64/defconfig)
> and noticed the following message:
> 
> [    0.136349] jitterentropy: Initialization failed with host not
> compliant with requirements: 9
> 
> Since Linux 6.5-rc2 this message occurs in around about 1 of 2 cases
> during boot. In Linux 6.4 this message i never saw this message.

This system has not that much entropy. A short-term fix would be to set the 
oversampling rate to a higher value than 1, the current value.

See jent_entropy_collector_alloc:

        /* verify and set the oversampling rate */
        if (osr == 0)
                osr = 1; /* minimum sampling rate is 1 */

The osr could be set to 3, for example. This makes the Jitter RNG slower, but 
it can now handle lower-entropy environments.

Let me see how this can be fixed.

Thanks for the report.

Ciao
Stephan


