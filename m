Return-Path: <SRS0=YB2u=UC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 086CDC04AB6
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 05:42:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3CF12084A
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 05:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559540560;
	bh=QBiP6smiS2HBpEvZg2lQL6uKS2lP5Kv+5QejXP/E7Ik=;
	h=From:To:Subject:Date:List-ID:From;
	b=bfMzNjewzCrKEX0BVmH2JgJp7H536nyC/eT3RL8VH3xDs2AgPYO60yhWaHn5sHWdZ
	 Ps/dk3Vvi9AKO/W66ciCxSiDSgYObVDQYASAGx4zqgPcGTar2JGe6Ga3GHYwTlfHX1
	 CVzC7bCrVrso7TbHKiEnpDdBfcSIlliXg4W5reg0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfFCFmk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Jun 2019 01:42:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726383AbfFCFmk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jun 2019 01:42:40 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B80E2772E
        for <linux-crypto@vger.kernel.org>; Mon,  3 Jun 2019 05:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559540559;
        bh=QBiP6smiS2HBpEvZg2lQL6uKS2lP5Kv+5QejXP/E7Ik=;
        h=From:To:Subject:Date:From;
        b=J81GODQJwmqIR3vzUXUEdMdfW4jATOrLPustrAI3ToC+shzMfTiDj06Z+lFXyIzlg
         syd9L3p1V68zBlMbuSTmzo/OcaoC23NIxEnJ/YKVU949WfPzaJBoL0fYwzEsG3NPmA
         ZIqV8i0psYdz10F6bAlmGi+maP8x3bmQtaOPB/Qg=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: testmgr - add some more preemption points
Date:   Sun,  2 Jun 2019 22:42:33 -0700
Message-Id: <20190603054233.5576-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Call cond_resched() after each fuzz test iteration.  This avoids stall
warnings if fuzz_iterations is set very high for testing purposes.

While we're at it, also call cond_resched() after finishing testing each
test vector.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 2ba0c487ea281..f7fdd7fe89a9e 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1496,6 +1496,7 @@ static int test_hash_vec(const char *driver, const struct hash_testvec *vec,
 						req, desc, tsgl, hashstate);
 			if (err)
 				return err;
+			cond_resched();
 		}
 	}
 #endif
@@ -1764,6 +1765,7 @@ static int __alg_test_hash(const struct hash_testvec *vecs,
 				    hashstate);
 		if (err)
 			goto out;
+		cond_resched();
 	}
 	err = test_hash_vs_generic_impl(driver, generic_driver, maxkeysize, req,
 					desc, tsgl, hashstate);
@@ -2028,6 +2030,7 @@ static int test_aead_vec(const char *driver, int enc,
 						&cfg, req, tsgls);
 			if (err)
 				return err;
+			cond_resched();
 		}
 	}
 #endif
@@ -2267,6 +2270,7 @@ static int test_aead(const char *driver, int enc,
 				    tsgls);
 		if (err)
 			return err;
+		cond_resched();
 	}
 	return 0;
 }
@@ -2609,6 +2613,7 @@ static int test_skcipher_vec(const char *driver, int enc,
 						    &cfg, req, tsgls);
 			if (err)
 				return err;
+			cond_resched();
 		}
 	}
 #endif
@@ -2808,6 +2813,7 @@ static int test_skcipher(const char *driver, int enc,
 					tsgls);
 		if (err)
 			return err;
+		cond_resched();
 	}
 	return 0;
 }
-- 
2.21.0

