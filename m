Return-Path: <SRS0=6qCq=6B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D79F0C38A2C
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Apr 2020 19:35:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1A7F206D9
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Apr 2020 19:35:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="pzh2TeAg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730413AbgDQTfI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Apr 2020 15:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730524AbgDQTfH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Apr 2020 15:35:07 -0400
Received: from mo6-p01-ob.smtp.rzone.de (mo6-p01-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5301::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D816C061A10
        for <linux-crypto@vger.kernel.org>; Fri, 17 Apr 2020 12:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1587152105;
        s=strato-dkim-0002; d=chronox.de;
        h=Message-ID:Date:Subject:Cc:To:From:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=EHF/kfyL9LlzhTxumK5rG0T7SN+xJ1x8ujKUesmqFmI=;
        b=pzh2TeAg45iTi/AYMXGhOxt+ydI4leCn6MI786ECeXAuZhG6ofFtE/GMLneZBahaCe
        mLNEH7cCsbyvaUzzNIcTPKzUvNCk3pJmDyVVbPrXkDPMgUyp751/Q+uMAQk4TABtzQtU
        vBUulPCc65veDeqlHp8I8v5WY676wSOixr41qKAWUx9BMOT/DAk9g1ag5adMpTCn3O/K
        f67MDCxHEjTP3V/kEb4Quw6ACm5wCibhtmUCZILddVs0h/eJnnei88bAY0xAb9A3p2LX
        mZ/dDj/8WzTVZ2MP/jXGphXFAlH0v8+8nQR3reflRIYVIYHALZN0e8sFiBz0AHVldh1I
        ZwrQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZJfSf//ci"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 46.5.0 DYNA|AUTH)
        with ESMTPSA id c09283w3HJZ53Ay
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 17 Apr 2020 21:35:05 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org
Subject: [PATCH v2 0/2] crypto: Jitter RNG SP800-90B compliance
Date:   Fri, 17 Apr 2020 21:32:53 +0200
Message-ID: <9339058.MEWKF1lRGI@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

This patch set adds SP800-90B compliance to the Jitter RNG. The
SP800-90B patch is tested for more than half a year in user space
with the Jitter RNG version 2.2.0.

The full SP800-90B assessment of the Jitter RNG is provided at [1].

In addition, the DRBG implementation is updated to always be
reseeded from the Jitter RNG. To ensure the DRBG is reseeded within
an appropriate amount of time, the reseed threshold is lowered.

Changes v2:
* Instead of free/alloc of the Jitter RNG instance in case of a health
  test error, re-initialize the RNG instance by performing the
  power-up test and after a success, clear the health test status and
  error.

[1] http://www.chronox.de/jent/doc/CPU-Jitter-NPTRNG.pdf

Stephan Mueller (2):
  crypto: Jitter RNG SP800-90B compliance
  crypto: DRBG always seeded with SP800-90B compliant noise source

 crypto/drbg.c                |  26 ++-
 crypto/jitterentropy-kcapi.c |  27 +++
 crypto/jitterentropy.c       | 417 ++++++++++++++++++++++++++---------
 include/crypto/drbg.h        |   6 +-
 4 files changed, 363 insertions(+), 113 deletions(-)

-- 
2.25.2




