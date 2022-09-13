Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1108C54EE9
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Sep 2022 18:51:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbiIMSvK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Sep 2022 14:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiIMSuy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Sep 2022 14:50:54 -0400
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.219])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D7E95FC2
        for <linux-crypto@vger.kernel.org>; Tue, 13 Sep 2022 11:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1663093869;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:To:From:Cc:Date:From:
    Subject:Sender;
    bh=Z8rv4s6/7y6OAegqsq6trVbDNYSQFm3g6edM5eOLy9w=;
    b=KoXyxkdHWjNzh4B/r+4jw9ukG0OGKkfgTR0+WiOtwvz/0KRAxmRsLyvmpGzAr1bV4k
    YJFOgc5Ym5D1pw60II/3P7tFgbQtxC1ohlTXjT9vxZEcL84U4jWQQtSiWWiG2ul/4H6h
    B74qj6+nBiyw+P9VdHCFQcRGVRuVlrsp9IQckngFeYuoFV7He5Wb4uGhuVCOxhz7d/38
    9d1GI1W8jm8yEPa0SI2E7hFx1guVdt78RCTNQaqWrk388qD/+mettFOGtmZgCC0N/NYl
    DU7LiEw6dx8uWaaBxVygXhNb6+m1+B1yo/50hn0TLFcAQtzoAy/VzFDR0l1lJvIWtO7+
    BDiA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaJPSf8yac"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 48.1.0 DYNA|AUTH)
    with ESMTPSA id 5a21aay8DIV97v8
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 13 Sep 2022 20:31:09 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        GROSSSCHARTNER Benjamin <benjamin.grossschartner@thalesgroup.com>
Subject: Re: drbg using jitterentropy_rng causes huge latencies
Date:   Tue, 13 Sep 2022 20:31:09 +0200
Message-ID: <2253976.ElGaqSPkdT@positron.chronox.de>
In-Reply-To: <a6aff0c118df4497b5e988c42586f4e4@thalesgroup.com>
References: <a6aff0c118df4497b5e988c42586f4e4@thalesgroup.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Montag, 12. September 2022, 10:16:17 CEST schrieb GROSSSCHARTNER Benjamin:

Hi GROSSSCHARTNER,

> Would there be any chance to get such a patch merged?

If there is an issue it needs to be solved.

But we need to be a bit careful: the Jitter RNG is mandatory when booting in 
FIPS mode. Thus, when you consider a patch to make it selectable, please make 
sure it is definitely selected when the FIPS option is selected.


Ciao
Stephan


