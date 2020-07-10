Return-Path: <SRS0=tT4M=AV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45A66C433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jul 2020 10:18:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17F4F2077D
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jul 2020 10:18:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="ROWZGay0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbgGJKSu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jul 2020 06:18:50 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.51]:29402 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727871AbgGJKSs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jul 2020 06:18:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1594376327;
        s=strato-dkim-0002; d=chronox.de;
        h=Message-ID:Date:Subject:Cc:To:From:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=fnJrgncP7SIdtJq/7xEi9RklqwzrndPWbsyQ73FueIA=;
        b=ROWZGay0KbnTbGxYC/hqD/zUykVQp2vuGQtoFo6uzyCcAPNKWthvtAg99uUvggqGGT
        E67d7wckpJu++HvVnbFWMcUTRHNt9TId9HwGAId2HU2A1/mgXiIDcwbAQ0QfsH/Z06fs
        GfpByJ3prJw6ma5uwsfxyKFzOx1LKKhZHb0wMNOIJ1hIVv8wV/InHzfJ26n1vt7HHV8g
        bS2cc5EvaSs9el/50ACZqM8XSjnJNBgWe5loDUH23dz8JPSXcKPftcZm9ZmYk8P1JeB9
        beeLcS8bwVbJeSUEbT2ZTWlGC6nGzeMEZ46fA2ivcpBdbar/0670QCewS4P57Tr1K0uR
        p9Ng==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaIvSfHReW"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 46.10.5 DYNA|AUTH)
        with ESMTPSA id y0546bw6AAGFZsj
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 10 Jul 2020 12:16:15 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org,
        Marcelo Cerri <marcelo.cerri@canonical.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH 0/3] DH: SP800-56A rev 3 compliant shared secret
Date:   Fri, 10 Jul 2020 12:09:18 +0200
Message-ID: <2543601.mvXUDI8C0e@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

The patch set adds the shared secret validation as defined by
SP800-56A rev 3. For ECDH this only implies that the validation
of the shared secret is moved before the shared secret is
returned to the caller.

For DH, the validation is required to be performed against the prime
of the domain parameter set.

This patch adds the MPI library file mpi_sub_ui that is required
to calculate P - 1 for the DH check. It would be possible, though
to simply set the LSB of the prime to 0 to obtain P - 1 (since
P is odd per definition) which implies that mpi_sub_ui would not
be needed. However, this would require a copy operation from
the existing prime MPI value into a temporary MPI where the
modification can be performed. Such copy operation is not available.
Therefore, the solution with the addition of mpi_sub_ui was chose.

NOTE: The function mpi_sub_ui is also added with the patch set
"[PATCH v5 2/8] lib/mpi: Extend the MPI library" currently sent
to the linux-crypto mailing list.

Marcelo Henrique Cerri (1):
  lib/mpi: Add mpi_sub_ui()

Stephan Mueller (2):
  crypto: ECDH - check validity of Z before export
  crypto: DH - check validity of Z before export

 crypto/dh.c          | 29 +++++++++++++++++++++
 crypto/ecc.c         | 11 +++++---
 include/linux/mpi.h  |  3 +++
 lib/mpi/Makefile     |  1 +
 lib/mpi/mpi-sub-ui.c | 60 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 101 insertions(+), 3 deletions(-)
 create mode 100644 lib/mpi/mpi-sub-ui.c

-- 
2.26.2




