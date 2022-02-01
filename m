Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C73BC433EF
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Feb 2022 08:42:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235056AbiBAImL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Feb 2022 03:42:11 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.164]:40533 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbiBAImK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Feb 2022 03:42:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1643704927;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=Hoq+1GvjyDP+LnUuXsbVZdQkiPxTQoykQ/5FRvYeElw=;
    b=C39kp7xVmGOdV2Un4zN91oNG4CPdczt0PY/Y8eI/rfLzVX7Fq/eBJQXEX/3MLrHSAb
    e2AgWqpgk1KFtOXJ3d76+hxC4ZDhmIp8rs5z/mPplfY6DJqHNd0uLDWj4MfBlJd9TOSu
    LBJVRBCvdENF/BWXn6J1ptepeKfxjDUbewEFbXJx0H3Yee2kywMe2YEyWRHMklbov4U6
    8at2odNj6lt7/ki1IDU6lQbzqqzvntPD66oz2n7tz0wd6mzwVwK4eoNCB9OflrpP9vMd
    qTbWLO1YyFeSCDtoRLsnu2vntp+lMZF02cXC/IXWCi4icNvvFSC31EyllZ2FPzYIGo3i
    XKpg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9zW8BKRp5UFiyGZZ4jof7Xg=="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.39.0 AUTH)
    with ESMTPSA id z28df7y118g63Jt
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 1 Feb 2022 09:42:06 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, Niolai Stange <nstange@suse.com>,
        Simo Sorce <simo@redhat.com>
Subject: [PATCH v2 0/2] crypto: HMAC - disallow keys < 112 bits in FIPS mode
Date:   Tue, 01 Feb 2022 09:40:24 +0100
Message-ID: <4609802.vXUDI8C0e8@positron.chronox.de>
In-Reply-To: <YfN1HKqL9GT9R25Z@gondor.apana.org.au>
References: <2075651.9o76ZdvQCi@positron.chronox.de> <YfN1HKqL9GT9R25Z@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

this is patch set version 2 for adding the HMAC limitation to disallow
keys < 112 bits in FIPS mode.

Version 2 changes:

As requested, instead of ifdef'ing test vectors out that violate the
constraint added with this patch set, they are compiled but disabled in
FIPS mode based on the .fips_skip flag.

The first patch adds the generic support for the fips_skip flag to
hashes / HMAC test vectors similarly to the support found for symmetric
algorithms.

The second patch uses the fips_skip flag to mark offending test vectors.

Stephan Mueller (2):
  crypto: HMAC - add fips_skip support
  crypto: HMAC - disallow keys < 112 bits in FIPS mode

 crypto/hmac.c    |  4 ++++
 crypto/testmgr.c |  3 +++
 crypto/testmgr.h | 11 +++++++++++
 3 files changed, 18 insertions(+)

-- 
2.33.1




