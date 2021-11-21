Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34EB2C433F5
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Nov 2021 14:14:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237083AbhKUORc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Nov 2021 09:17:32 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.21]:31253 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236405AbhKUORb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Nov 2021 09:17:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1637504062;
    s=strato-dkim-0002; d=chronox.de;
    h=Message-ID:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=15sWvFb3q2s6oiV3qHU6PvIicdlkGPTCIfTp/IQwKTM=;
    b=lQjFvST2+/6GdA4YG/pxBwoYK/L+mcgXLzs1kyX8Q+EbjTxyCFg1izBQPUUECYsJ+z
    YvDPoqhO4EFucLhuD/kkPunEA0XCXi/hYO/G8OlmSbyN4+64WEldGy9wV5FiGl1BwfNp
    WMqX+QHeeyA9Ct4UpSJbnwerAZzlt8phKQ5L+8AA946MYA+rRJH6pnwzIY95SQkyrFlW
    JLNPLdJ9w65xAuY9q+5o2Hq8+mKhweUlI9ccP7auudsTZ76/v/x0TEKR+PcKdthH/g5D
    QUDVHRkXowANnkLxoio/JtezVDaCtYJJ3ejtxMnU4zYf9RUX8fyGhpxWNIFfV72PeM7i
    oigA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbJvSfE+K2"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.34.5 DYNA|AUTH)
    with ESMTPSA id U02dfbxALEEK3FD
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sun, 21 Nov 2021 15:14:20 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: Jitter RNG - consider 32 LSB for APT
Date:   Sun, 21 Nov 2021 15:14:20 +0100
Message-ID: <2572116.vuYhMxLoTh@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The APT compares the current time stamp with a pre-set value. The
current code only considered the 4 LSB only. Yet, after reviews by
mathematicians of the user space Jitter RNG version >= 3.1.0, it was
concluded that the APT can be calculated on the 32 LSB of the time
delta. Thi change is applied to the kernel.

This fixes a bug where an AMD EPYC fails this test as its RDTSC value
contains zeros in the LSB. The most appropriate fix would have been to
apply a GCD calculation and divide the time stamp by the GCD. Yet, this
is a significant code change that will be considered for a future
update. Note, tests showed that constantly the GCD always was 32 on
these systems, i.e. the 5 LSB were always zero (thus failing the APT
since it only considered the 4 LSB for its calculation).

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/jitterentropy.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
index a11b3208760f..f6d3a84e3c21 100644
--- a/crypto/jitterentropy.c
+++ b/crypto/jitterentropy.c
@@ -265,7 +265,6 @@ static int jent_stuck(struct rand_data *ec, __u64 current_delta)
 {
 	__u64 delta2 = jent_delta(ec->last_delta, current_delta);
 	__u64 delta3 = jent_delta(ec->last_delta2, delta2);
-	unsigned int delta_masked = current_delta & JENT_APT_WORD_MASK;
 
 	ec->last_delta = current_delta;
 	ec->last_delta2 = delta2;
@@ -274,7 +273,7 @@ static int jent_stuck(struct rand_data *ec, __u64 current_delta)
 	 * Insert the result of the comparison of two back-to-back time
 	 * deltas.
 	 */
-	jent_apt_insert(ec, delta_masked);
+	jent_apt_insert(ec, current_delta);
 
 	if (!current_delta || !delta2 || !delta3) {
 		/* RCT with a stuck bit */
-- 
2.33.1




