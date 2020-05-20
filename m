Return-Path: <SRS0=Eyne=7C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB92FC433E2
	for <linux-crypto@archiver.kernel.org>; Wed, 20 May 2020 06:24:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EBAC2084C
	for <linux-crypto@archiver.kernel.org>; Wed, 20 May 2020 06:24:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="kGWFRlz9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726570AbgETGYP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 May 2020 02:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbgETGYO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 May 2020 02:24:14 -0400
Received: from mo6-p02-ob.smtp.rzone.de (mo6-p02-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5302::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF565C061A0E;
        Tue, 19 May 2020 23:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1589955852;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=Z4L+tBCvVk7qL7s3FzIU5Gn5ddNv0VVuMlfTJxRK4xo=;
        b=kGWFRlz9NM8mT6kFmGVT8S1Yq/Vz3WhjmqRIrILy9U6dWCcfapHiF7RPldl9CQtSJT
        DIo6qIesRXu/1uGG/Egdg5DYB7Ti0idWfekb28itbRmpT0AiExi3tSZqpC2g+GxzsjYq
        ArQorMYESDJKXWdrE79/2c76XgDHCv/2RuEaQ7e3ZHyLobE/yQ8kRK9IhHN51ujO0/bT
        ui+Ukqw3Iiy1lP6eP/BQda0Aydbql38tkfdDF6CVqPeMYgIlO3muLtSX6BYtF2Tjta5n
        ZqAt9h9RZN1RD3FonxbZO8Hbm4UWfpAdRlDQRxb62KHH4SniAgggtUYwA02tf7ryE8Kb
        aNUg==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbI/Sc5g=="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.7.0 DYNA|AUTH)
        with ESMTPSA id k09005w4K6Nx34M
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 20 May 2020 08:23:59 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     =?utf-8?B?xYF1a2Fzeg==?= Stelmach <l.stelmach@samsung.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Matthias Brugger <mbrugger@suse.com>,
        Stefan Wahren <wahrenst@gmx.net>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v2 1/2] hwrng: iproc-rng200 - Set the quality value
Date:   Wed, 20 May 2020 08:23:59 +0200
Message-ID: <1748331.j7eDFAdTc1@tauon.chronox.de>
In-Reply-To: <20200519212552.11671-2-l.stelmach@samsung.com>
References: <20200514190734.32746-1-l.stelmach@samsung.com> <CGME20200519212619eucas1p22fa5d3db2521096dc4b79f6e53016d17@eucas1p2.samsung.com> <20200519212552.11671-2-l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Dienstag, 19. Mai 2020, 23:25:51 CEST schrieb =C5=81ukasz Stelmach:

Hi =C5=81ukasz,

> The value was estimaded with ea_iid[1] using on 10485760 bytes read from
> the RNG via /dev/hwrng. The min-entropy value calculated using the most
> common value estimate (NIST SP 800-90P[2], section 6.3.1) was 7.964464.

I am sorry, but I think I did not make myself clear: testing random numbers=
=20
post-processing with the statistical tools does NOT give any idea about the=
=20
entropy rate. Thus, all that was calculated is the proper implementation of=
=20
the post-processing operation and not the actual noise source.

What needs to happen is that we need access to raw, unconditioned data from=
=20
the noise source that is analyzed with the statistical methods.

Ciao
Stephan


