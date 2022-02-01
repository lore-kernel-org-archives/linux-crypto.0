Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C1F3C433FE
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Feb 2022 08:42:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbiBAImL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Feb 2022 03:42:11 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.165]:41631 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234940AbiBAImL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Feb 2022 03:42:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1643704926;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=6JCjciFJ6jd3Md6jXeMSjhZSDTkzmsyBTrCQq/76wSo=;
    b=tUBCgigbOg34TWuqEm8g6utHDTFlAcD3R6gLY4xxZyPSYbir4+uvkQ71fwa/OB7XNq
    2unrp7RWOB8ieV1KHNp6c0azpXxjDXrNWSvebhvXVXSprqebhDyui4kYOZ3MU/i1LIw8
    p6ZQLAYcxK6eDtSVXMkadUrhbZdK6axURiAG4xHwE9BMH57D69PORi+KMCL5hFN8xoXc
    Ai6tRy41JRoj+qKR9e7QgFVyxJSEVRhxxMLaCoLmPBAIwce6D4DoNWACd13J5S46yqxB
    z6joThGh1hPA9e8FFvUPAXAqW2daaEOnLxa43QWEebVid9si8giSdKoU2vBXdmcvU/B9
    p1Lw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9zW8BKRp5UFiyGZZ4jof7Xg=="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.39.0 AUTH)
    with ESMTPSA id z28df7y118g63Jq
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 1 Feb 2022 09:42:06 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, Niolai Stange <nstange@suse.com>,
        Simo Sorce <simo@redhat.com>
Subject: [PATCH v2 1/2] crypto: HMAC - add fips_skip support
Date:   Tue, 01 Feb 2022 09:40:58 +0100
Message-ID: <2682841.vuYhMxLoTh@positron.chronox.de>
In-Reply-To: <4609802.vXUDI8C0e8@positron.chronox.de>
References: <2075651.9o76ZdvQCi@positron.chronox.de> <YfN1HKqL9GT9R25Z@gondor.apana.org.au> <4609802.vXUDI8C0e8@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

By adding the support for the flag fips_skip, hash / HMAC test vectors
may be marked to be not applicable in FIPS mode. Such vectors are
silently skipped in FIPS mode.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/testmgr.c | 3 +++
 crypto/testmgr.h | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 5831d4bbc64f..26674570ea72 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1854,6 +1854,9 @@ static int __alg_test_hash(const struct hash_testvec *vecs,
 	}
 
 	for (i = 0; i < num_vecs; i++) {
+		if (fips_enabled && vecs[i].fips_skip)
+			continue;
+
 		err = test_hash_vec(&vecs[i], i, req, desc, tsgl, hashstate);
 		if (err)
 			goto out;
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index a253d66ba1c1..17b37525f289 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -33,6 +33,7 @@
  * @ksize:	Length of @key in bytes (0 if no key)
  * @setkey_error: Expected error from setkey()
  * @digest_error: Expected error from digest()
+ * @fips_skip:	Skip the test vector in FIPS mode
  */
 struct hash_testvec {
 	const char *key;
@@ -42,6 +43,7 @@ struct hash_testvec {
 	unsigned short ksize;
 	int setkey_error;
 	int digest_error;
+	bool fips_skip;
 };
 
 /*
-- 
2.33.1




