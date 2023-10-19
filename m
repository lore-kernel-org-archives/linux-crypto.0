Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73528CDB483
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Oct 2023 05:54:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbjJSFy0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Oct 2023 01:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbjJSFyR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Oct 2023 01:54:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E97A11B
        for <linux-crypto@vger.kernel.org>; Wed, 18 Oct 2023 22:54:15 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C1EC433CB
        for <linux-crypto@vger.kernel.org>; Thu, 19 Oct 2023 05:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697694854;
        bh=WZ1hRhoDd4lCMgZ0YancZdiBlLpsjneFbre+ZmH4G/E=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=vKNjDSUqoOZWhVRnRj3JK3CAdtOS5Gf6iV7Q7ROCEkQjis7RCZdyMrbcqn89/h9A8
         bT174ZX6KLxPwh7olqAiv/J3eN/w2aGUIZH1BuqF96dpH2TXx8pM+twzH5D7bXjIrR
         HsB0ujykcUfMCqaSlAwhKtByS2u2ffwjFKrUZEMArMUZ8Rqm7IEnbGinPsrtXVOSHH
         AiA1ohW//vX1YL929f7345oNb++UQYTmpSwIw8h1fna5wxvNqfKA5qDRxcC11u7dzT
         mx4pEUusOVNPFjffLf2LEgoAN4lN+eTprkPb+cRpS31vDi3/X9tvYEf+nUGXP64HGU
         uEpdHPuYGSrVg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 12/17] libceph: stop checking crypto_shash_alignmask
Date:   Wed, 18 Oct 2023 22:53:38 -0700
Message-ID: <20231019055343.588846-13-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231019055343.588846-1-ebiggers@kernel.org>
References: <20231019055343.588846-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Now that the shash algorithm type does not support nonzero alignmasks,
crypto_shash_alignmask() always returns 0 and will be removed.  In
preparation for this, stop checking crypto_shash_alignmask() in
net/ceph/messenger_v2.c.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 net/ceph/messenger_v2.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
index d09a39ff2cf04..f8ec60e1aba3a 100644
--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -726,22 +726,20 @@ static int setup_crypto(struct ceph_connection *con,
 	noio_flag = memalloc_noio_save();
 	con->v2.hmac_tfm = crypto_alloc_shash("hmac(sha256)", 0, 0);
 	memalloc_noio_restore(noio_flag);
 	if (IS_ERR(con->v2.hmac_tfm)) {
 		ret = PTR_ERR(con->v2.hmac_tfm);
 		con->v2.hmac_tfm = NULL;
 		pr_err("failed to allocate hmac tfm context: %d\n", ret);
 		return ret;
 	}
 
-	WARN_ON((unsigned long)session_key &
-		crypto_shash_alignmask(con->v2.hmac_tfm));
 	ret = crypto_shash_setkey(con->v2.hmac_tfm, session_key,
 				  session_key_len);
 	if (ret) {
 		pr_err("failed to set hmac key: %d\n", ret);
 		return ret;
 	}
 
 	if (con->v2.con_mode == CEPH_CON_MODE_CRC) {
 		WARN_ON(con_secret_len);
 		return 0;  /* auth_x, plain mode */
@@ -809,22 +807,20 @@ static int hmac_sha256(struct ceph_connection *con, const struct kvec *kvecs,
 		memset(hmac, 0, SHA256_DIGEST_SIZE);
 		return 0;  /* auth_none */
 	}
 
 	desc->tfm = con->v2.hmac_tfm;
 	ret = crypto_shash_init(desc);
 	if (ret)
 		goto out;
 
 	for (i = 0; i < kvec_cnt; i++) {
-		WARN_ON((unsigned long)kvecs[i].iov_base &
-			crypto_shash_alignmask(con->v2.hmac_tfm));
 		ret = crypto_shash_update(desc, kvecs[i].iov_base,
 					  kvecs[i].iov_len);
 		if (ret)
 			goto out;
 	}
 
 	ret = crypto_shash_final(desc, hmac);
 
 out:
 	shash_desc_zero(desc);
-- 
2.42.0

