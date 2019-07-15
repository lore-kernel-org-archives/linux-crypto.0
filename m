Return-Path: <SRS0=7mlD=VM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52EA0C7618F
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jul 2019 14:08:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23AD1217D9
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jul 2019 14:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563199730;
	bh=eX5Dh/FSm7XbycA/GmS0XdIfSyzLkNPai12gSFWdfU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=V26fGwJ1ySoinZ0WDkihTE+7MlWT+mitpBl7b7kWowwC9boiClWhzbB4UGu4rK3Kc
	 i9FCKTK/l4aweubgOrPdo/Vwe/7P33FruqbvZLLnZLcKtV2fvDw3I1lADk3LhUCOtd
	 y5aGrcQgrknvtxknxi412GSApTbdk5H0CmY8eLYI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388588AbfGOOIq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Jul 2019 10:08:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:59446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388584AbfGOOIp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jul 2019 10:08:45 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D4E02081C;
        Mon, 15 Jul 2019 14:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199725;
        bh=eX5Dh/FSm7XbycA/GmS0XdIfSyzLkNPai12gSFWdfU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UhlUnexoDTZZIPn9M1/NQmg3enw86gv/G26GAhUQ634YcjizhZsT21/eZSJY4iRuf
         YxZnd9LoTKmc7D9Yu5oKjnLKPOyPcwQa7bjvF/vzmD3EGZa0gz9P5nLHzN9D2OXoMo
         eGMC2uh6bJ2U+sK5pPrUpQ85wLWyzfRdVBjOYlM4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 086/219] crypto: testmgr - add some more preemption points
Date:   Mon, 15 Jul 2019 10:01:27 -0400
Message-Id: <20190715140341.6443-86-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit e63e1b0dd0003dc31f73d875907432be3a2abe5d ]

Call cond_resched() after each fuzz test iteration.  This avoids stall
warnings if fuzz_iterations is set very high for testing purposes.

While we're at it, also call cond_resched() after finishing testing each
test vector.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/testmgr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 8386038d67c7..51540dbee23b 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1050,6 +1050,7 @@ static int test_hash_vec(const char *driver, const struct hash_testvec *vec,
 						req, tsgl, hashstate);
 			if (err)
 				return err;
+			cond_resched();
 		}
 	}
 #endif
@@ -1105,6 +1106,7 @@ static int __alg_test_hash(const struct hash_testvec *vecs,
 		err = test_hash_vec(driver, &vecs[i], i, req, tsgl, hashstate);
 		if (err)
 			goto out;
+		cond_resched();
 	}
 	err = 0;
 out:
@@ -1346,6 +1348,7 @@ static int test_aead_vec(const char *driver, int enc,
 						&cfg, req, tsgls);
 			if (err)
 				return err;
+			cond_resched();
 		}
 	}
 #endif
@@ -1365,6 +1368,7 @@ static int test_aead(const char *driver, int enc,
 				    tsgls);
 		if (err)
 			return err;
+		cond_resched();
 	}
 	return 0;
 }
@@ -1679,6 +1683,7 @@ static int test_skcipher_vec(const char *driver, int enc,
 						    &cfg, req, tsgls);
 			if (err)
 				return err;
+			cond_resched();
 		}
 	}
 #endif
@@ -1698,6 +1703,7 @@ static int test_skcipher(const char *driver, int enc,
 					tsgls);
 		if (err)
 			return err;
+		cond_resched();
 	}
 	return 0;
 }
-- 
2.20.1

