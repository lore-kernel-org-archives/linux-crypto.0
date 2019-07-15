Return-Path: <SRS0=7mlD=VM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7923CC7618F
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jul 2019 14:33:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5331D21530
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jul 2019 14:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563201237;
	bh=lkCTKh7ZxrUCm8Sg5urEHMxEK4sQo1A2rQt+ok6fEYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=igSo33yXd/ftTYnLweP27XdvWHDqjNfnHm8MdmzvBaYMIJ8OTZ+d9KzflRZxtOF83
	 V6gUC+5HiHAt5hCs6jnbFAsolz/1D9goK5k/vM6JDcuw9lW4YztGv9yZ9PRVfV7Mzn
	 Cam4prmL5M4Fb1TxLiijDwlAZZ1hlrROV+OJEQbw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391977AbfGOOdz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Jul 2019 10:33:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391968AbfGOOdv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jul 2019 10:33:51 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F033721530;
        Mon, 15 Jul 2019 14:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563201231;
        bh=lkCTKh7ZxrUCm8Sg5urEHMxEK4sQo1A2rQt+ok6fEYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U9CJUwUp0FfZp2Q229A/auHj5oijRMCtwadrAf8w35s2ofQux02eJfKE8zNsJbu3B
         Fnkfd1/MWLPsSaZrezkOPHqdQOhGMeYsLV52PfPokB43ROupRC0N0vs+QicT0hKzEg
         EdESrN2HnZzuUiAjrDG6hV6o6T9lPYlfWbBAHsOY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.14 084/105] crypto: serpent - mark __serpent_setkey_sbox noinline
Date:   Mon, 15 Jul 2019 10:28:18 -0400
Message-Id: <20190715142839.9896-84-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715142839.9896-1-sashal@kernel.org>
References: <20190715142839.9896-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 473971187d6727609951858c63bf12b0307ef015 ]

The same bug that gcc hit in the past is apparently now showing
up with clang, which decides to inline __serpent_setkey_sbox:

crypto/serpent_generic.c:268:5: error: stack frame size of 2112 bytes in function '__serpent_setkey' [-Werror,-Wframe-larger-than=]

Marking it 'noinline' reduces the stack usage from 2112 bytes to
192 and 96 bytes, respectively, and seems to generate more
useful object code.

Fixes: c871c10e4ea7 ("crypto: serpent - improve __serpent_setkey with UBSAN")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/serpent_generic.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/crypto/serpent_generic.c b/crypto/serpent_generic.c
index 7c3382facc82..600bd288881d 100644
--- a/crypto/serpent_generic.c
+++ b/crypto/serpent_generic.c
@@ -229,7 +229,13 @@
 	x4 ^= x2;					\
 	})
 
-static void __serpent_setkey_sbox(u32 r0, u32 r1, u32 r2, u32 r3, u32 r4, u32 *k)
+/*
+ * both gcc and clang have misoptimized this function in the past,
+ * producing horrible object code from spilling temporary variables
+ * on the stack. Forcing this part out of line avoids that.
+ */
+static noinline void __serpent_setkey_sbox(u32 r0, u32 r1, u32 r2,
+					   u32 r3, u32 r4, u32 *k)
 {
 	k += 100;
 	S3(r3, r4, r0, r1, r2); store_and_load_keys(r1, r2, r4, r3, 28, 24);
-- 
2.20.1

