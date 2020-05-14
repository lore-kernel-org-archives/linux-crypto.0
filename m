Return-Path: <SRS0=peSz=64=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 578F3C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 14 May 2020 20:21:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F9D020722
	for <linux-crypto@archiver.kernel.org>; Thu, 14 May 2020 20:21:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="TFWtNwcb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbgENUVD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 May 2020 16:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726035AbgENUVD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 May 2020 16:21:03 -0400
Received: from mo6-p02-ob.smtp.rzone.de (mo6-p02-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5302::5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4C6C061A0C;
        Thu, 14 May 2020 13:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1589487661;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=t8MuLBhVs0CMy4EvOYJ57JJKkaJSMB56O8oh0kRWzwM=;
        b=TFWtNwcbADVlS9IEKb4EkbBvWnHIx9UlctRRawUHne3E56LNzrNNGxWxesIxoh2zma
        v7KUt1Y1+peCAf3W0O2nHClAjdA1vWsdUYmx6QOV0vacneZ/5AHRtN+EUiFrHYGx/S2C
        vuoCl2feDl6TGknBuoSUNs1N2G31iTLTY0aC5GDOFTle64KaZU/8+Ve9TykKIVtrEUME
        Ku+cR22qWMr2qJrbI6T6uPYTHubYlnyMwg7Qk0A8nK/ZR5fpZQuhp6sGq2HKsej02cl/
        1Qa2uYhr18+O51VZa8VwOXSopEQsi0LADYPt8hDUc7OG3iGlhFqmA/YyNxh+ohr4Y1k7
        iMiw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaJfSc9C1S"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.6.2 DYNA|AUTH)
        with ESMTPSA id u08bf3w4EKKsxtN
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Thu, 14 May 2020 22:20:54 +0200 (CEST)
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
Subject: Re: [PATCH 2/2] hwrng: exynos - Set the quality value
Date:   Thu, 14 May 2020 22:20:54 +0200
Message-ID: <8196280.CLNGmrtAO5@tauon.chronox.de>
In-Reply-To: <20200514190734.32746-3-l.stelmach@samsung.com>
References: <20200514190734.32746-1-l.stelmach@samsung.com> <CGME20200514190740eucas1p293129b2ef3ba706652a9327e55db9649@eucas1p2.samsung.com> <20200514190734.32746-3-l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Donnerstag, 14. Mai 2020, 21:07:34 CEST schrieb =C5=81ukasz Stelmach:

Hi =C5=81ukasz,

> The value has been estimaded by obtainig 1024 chunks of data 128 bytes
> (1024 bits) each from the generator and finding chunk with minimal
> entropy using the ent(1) tool. The value was 6.332937 bits of entropy
> in each 8 bits of data.

Dto - see the other comment.

Ciao
Stephan


