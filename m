Return-Path: <SRS0=qmX+=53=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67485C2BA19
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Apr 2020 19:37:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BF2320787
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Apr 2020 19:37:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="BBqwUIN/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgDKThz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 11 Apr 2020 15:37:55 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.21]:14791 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbgDKThz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Apr 2020 15:37:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1586633871;
        s=strato-dkim-0002; d=chronox.de;
        h=Message-ID:Date:Subject:Cc:To:From:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=FzG0CM9MY4r1SKVF7hxcJIXCO2KFYmHS46Lr/6YTI+0=;
        b=BBqwUIN/mb4ta4WVv0yoEAX6kZBqiv02Dw0lFSP2FrP6GIBVbFwdrQaBKL5V1nlCf3
        4UlfYaZ/VHj2Ei+P+H2nSo4towCyn1Ni8PvY0Y70R0ni4qvUJuafeXAt10PfrQQm5k6m
        OxsSkqVdFw/u1jM8k8q3xLLgFUh+5wvKjWKi1gXmkYQdbIIL8NLr6lIrw0nA1cAF0VwX
        rp/85U0XVxoDUVqCB+RBtBMpe5Rk/JKbKTXdyG7W0/tKEJdcxqxNexJ2M/lxXfke+Q7y
        JowAuWPuYxHSNiFMdMSbXqzayxjLnTOq+f0rNcmcK1DZaJQlPbAbwRhUi7Aza7b8bvqP
        9bMw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZIPSfmHxF"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 46.2.1 DYNA|AUTH)
        with ESMTPSA id q0554fw3BJbeJt1
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sat, 11 Apr 2020 21:37:40 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au
Subject: [PATCH 0/2] crypto: Jitter RNG SP800-90B compliance
Date:   Sat, 11 Apr 2020 21:34:30 +0200
Message-ID: <16276478.9hrKPGv45q@positron.chronox.de>
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

[1] http://www.chronox.de/jent/doc/CPU-Jitter-NPTRNG.pdf

Stephan Mueller (2):
  crypto: Jitter RNG SP800-90B compliance
  crypto: DRBG always seeded with SP800-90B compliant noise source

 crypto/drbg.c                |  26 ++-
 crypto/jitterentropy-kcapi.c |  41 ++++
 crypto/jitterentropy.c       | 389 ++++++++++++++++++++++++++---------
 include/crypto/drbg.h        |   6 +-
 4 files changed, 349 insertions(+), 113 deletions(-)

-- 
2.25.2




