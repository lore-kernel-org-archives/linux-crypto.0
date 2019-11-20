Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3EE9C432C0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 16:20:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B6DE2071F
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 16:20:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="Qn5sDZkr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729306AbfKTQUo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 11:20:44 -0500
Received: from mout.gmx.net ([212.227.15.18]:53321 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727885AbfKTQUo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 11:20:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1574266825;
        bh=bxZXK4jBYOL5HZciNl+I4AQKYqmjhu0pYOZ1i9Z/OoM=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=Qn5sDZkrEU+j1jcx+kYmtk0WukmyVj9yeK5sBRxSqWQY8wwuSmM0c6UBXqkxip2oG
         FI9YvdS4O2dAkn/BSORui0RLFirwfDBPl8i/pYb03/g2Fu8GNEVij/BtLmjnm/8CoW
         /MG1cvs49rxyIe/XyeAYNFeuM/8JWfnTak/0yAeQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.1.176] ([37.4.249.139]) by mail.gmx.com (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MiacH-1htBcc20uN-00fnOV; Wed, 20
 Nov 2019 17:20:25 +0100
Subject: Re: [PATCH v3 3/4] ARM: dts: bcm2835: Move rng definition to common
 location
To:     Stephen Brennan <stephen@brennan.io>
Cc:     Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Scott Branden <sbranden@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, Ray Jui <rjui@broadcom.com>,
        linux-kernel@vger.kernel.org, Eric Anholt <eric@anholt.net>,
        Rob Herring <robh+dt@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com,
        Matt Mackall <mpm@selenic.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-crypto@vger.kernel.org
References: <20191120031622.88949-1-stephen@brennan.io>
 <20191120031622.88949-4-stephen@brennan.io>
From:   Stefan Wahren <wahrenst@gmx.net>
Message-ID: <307960ba-0c01-1590-551b-2190a54ea350@gmx.net>
Date:   Wed, 20 Nov 2019 17:20:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191120031622.88949-4-stephen@brennan.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Provags-ID: V03:K1:x3VLRf8GmImn+EPZjvIVhfId/7IfKu1RrJ9BQzHaYGGKSw0bb09
 d6oSlm3vQNJT3WAIyZSlUBY9hD0zaZduPoXWLqWpZXQWvST1PYzXg/aUy6yCmPoCKA9VgXG
 NqDmrZcbwY3KMnkvLeS2+3sstYZy1wQFzLKc9zuF1/7/UCvoxx86aY3pR8QtQscgpty+UTl
 topjqXqUmwp8/M+h70sKA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:6fbkE9d3JpA=:/2o0C5CqgIV8IPoFApQNss
 +eRU0v2zdC1o4JjackG/gOZQu+89WNB+/LrNarG1RKNqSYRDn477tVpP9sn5jLa3v/u3/owHQ
 Aaid1dlCvEJs44TIo3rVPukrkVfqHReVfjhuIXDe/vG3H6a6Y5WWCMxMRYMRVe5BWqdS60LGl
 GHPd2+OXfQ8wEDQDLRyQD1XywhNTlprizyRA7ZyVSl5A0Gdk5kqzJsjfZWCPHwHYd3j0yDZYe
 +hFxHphf31HAtbvxRcQm7r7WxHGUoCvm4syBtC3vjWDZSfjmK3mqn7ngQxlyxyw6ncUUi02Sg
 LRptIgViLiuEaOOj91aoVA2wnaR4XT1L0aCsaiYIvWzKe0PuU2+GhEzVAgp796yH92aOEmUUf
 MnvmoWXDB+5XyUg9y69k3HehBOgXsAkcLFO5Lhk0apUv273xI95xufVXhJzhHCXbhLsYT2pWO
 fBniw+o36eN1Eknph3GO3SkxoDgicaSgSF7PGRzedpN7LjzwbPPsJQLbb3tkmdotVMGzcC3Qr
 MSu/0KCzoiw14gFvI5CorhR08yEQTk1qPG9yJLIkzHHyz7wGF3Ru18LBljidiLWYnLd5iNwju
 J/+Q9YR1r3njNlIvyvLAspmRsA2Wll99kVkH6XhdrZxxdwMIDSP7eLTdZHIfoss1V+uOePeJl
 SYcPPwlNm7YQqjK5WuztQdJYkcv1sOWOTPPt9lgxbj4KUVeXSi3z6dT6pW1mvzFXtceNrTDGr
 MlQeosWhXFb0jdpxvgnPq0kAxGuTotcZlb8pTE5LnsA9ha1iL+vuNmSMDhCMoVBoMfVgpwvJE
 74VAxdXFi3iNflUKdnvMYItMR+na8exnfjsxKTn5sPpSL6G7cIXtACZeCxTIwl8BjptmwDVUA
 GMdRVIVkHjDlLwvS2GDKMT/36l/L4SzmlG4XhaIHhwltXdfnXqheHJ1B6XgvFRlv/WnG4Xqes
 BV6SbjGeDw3oyOEle4DR3eIM4nno3Zf/M5JFZ7RoNbV9cECd+HvFN4xB1mLWpIrfTwUcXBv9z
 r9A7XvwDoIJkVEU6q1RxRAQ56/dah+itmG8FjEIp7yVmvsbb3RS9CxwUDEh+WnPSJfohp3Kw8
 Bls5AGlHLIF3OFS6vSzD1cUx8rGjnl1aoyyLAoe7M3Th7rtTVBFDsfkHTwPpK0faLtmMU8rvD
 YL9+5yNmppQDOpt2jga6v6+xEx/mj3BfVtVwnzynu8otKEjDVYYtNIHc3Pj5C7HiGNuss7Gaq
 4JGPpBsDaCrmRXiwIcu1j3VrdyNvKonVP3t7Ez4FVCA6vs/xtXq/0U8mUusQ=
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am 20.11.19 um 04:16 schrieb Stephen Brennan:
> BCM2711 inherits from BCM283X, but has an incompatible HWRNG. Move this
> node to bcm2835-common.dtsi, so that BCM2711 can define its own.
>
> Signed-off-by: Stephen Brennan <stephen@brennan.io>
Acked-by: Stefan Wahren <wahrenst@gmx.net>
