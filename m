Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06F5FC06511
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 00:58:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3A9B20828
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 00:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1562115495;
	bh=ZncPmqJjQ5p8Nzi6KA3tSryklHFPA1+D6VokdeGHa28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=1G/m4Qy7i5w5mggri45F7E8KDRf1AVb/2fUH1LBaaEZ8w0plYuwnyqGzxt4yZw2iy
	 JTb2UnCWUn+ZWYPT1eJRWSbLDQZ8Waa/lebTcJnqVL5PkzAAazOP/uEUnQ0RwJI89i
	 amq5UBR6nmT8OpNEj8rbejnd2kP0bXu4PtTNenFc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbfGCA6G (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 20:58:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727089AbfGCA6F (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 20:58:05 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC2DD20449;
        Tue,  2 Jul 2019 21:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562102286;
        bh=ZncPmqJjQ5p8Nzi6KA3tSryklHFPA1+D6VokdeGHa28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SB5zOgdMv5+0+Y00OB/l2Jsui1egnX0iDRToH0chu73SQDnspeXPnukhhoEmUrnLn
         1J+BRo9A3r/sqHCxARyy5JjA32jtlBzB0ijOU2DU7SGrhcMqqdeMDKnGYa4XxgYNle
         NM7aJFyBE6dbHGDyiqMab5d1sEPNEWHorvFmP4uM=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     chetjain@in.ibm.com, "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Michal Suchanek <msuchanek@suse.de>,
        stable@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH] crypto: user - prevent operating on larval algorithms
Date:   Tue,  2 Jul 2019 14:17:00 -0700
Message-Id: <20190702211700.16526-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190701153154.1569c2dc@kitsune.suse.cz>
References: <20190701153154.1569c2dc@kitsune.suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Michal Suchanek reported [1] that running the pcrypt_aead01 test from
LTP [2] in a loop and holding Ctrl-C causes a NULL dereference of
alg->cra_users.next in crypto_remove_spawns(), via crypto_del_alg().
The test repeatedly uses CRYPTO_MSG_NEWALG and CRYPTO_MSG_DELALG.

The crash occurs when the instance that CRYPTO_MSG_DELALG is trying to
unregister isn't a real registered algorithm, but rather is a "test
larval", which is a special "algorithm" added to the algorithms list
while the real algorithm is still being tested.  Larvals don't have
initialized cra_users, so that causes the crash.  Normally pcrypt_aead01
doesn't trigger this because CRYPTO_MSG_NEWALG waits for the algorithm
to be tested; however, CRYPTO_MSG_NEWALG returns early when interrupted.

Everything else in the "crypto user configuration" API has this same bug
too, i.e. it inappropriately allows operating on larval algorithms
(though it doesn't look like the other cases can cause a crash).

Fix this by making crypto_alg_match() exclude larval algorithms.

[1] https://lkml.kernel.org/r/20190625071624.27039-1-msuchanek@suse.de
[2] https://github.com/linux-test-project/ltp/blob/20190517/testcases/kernel/crypto/pcrypt_aead01.c

Reported-by: Michal Suchanek <msuchanek@suse.de>
Fixes: a38f7907b926 ("crypto: Add userspace configuration API")
Cc: <stable@vger.kernel.org> # v3.2+
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/crypto_user_base.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/crypto/crypto_user_base.c b/crypto/crypto_user_base.c
index e48da3b75c71d4..a89fcc530092a8 100644
--- a/crypto/crypto_user_base.c
+++ b/crypto/crypto_user_base.c
@@ -56,6 +56,9 @@ struct crypto_alg *crypto_alg_match(struct crypto_user_alg *p, int exact)
 	list_for_each_entry(q, &crypto_alg_list, cra_list) {
 		int match = 0;
 
+		if (crypto_is_larval(q))
+			continue;
+
 		if ((q->cra_flags ^ p->cru_type) & p->cru_mask)
 			continue;
 
-- 
2.22.0.410.gd8fdbe21b5-goog

