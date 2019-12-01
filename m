Return-Path: <SRS0=52Dc=ZX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5735C43141
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Dec 2019 21:54:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8118120865
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Dec 2019 21:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575237262;
	bh=Jn7UZEZXAWyF6vGUw5dwrjBzRUXsVxoM4RNFSEtOfpM=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=yDqUSoe8Yn0Q1YT7Ls5I4BKyYHpwhGRpvH+Hmt73lLClL0h7OJ4ehNF4gL9+OmRCl
	 /RjoBYbn86OBc62vwOXeMI0CXb8a2pAyh2r0rmPVkRwQJprD2LKorb4PHmswdy9i4h
	 36/qqT1ioKyOEtD1jnsp0gq0ptOmNOt4WOSOFx84=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbfLAVyU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 1 Dec 2019 16:54:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:33398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727279AbfLAVyU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 1 Dec 2019 16:54:20 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D85D21774
        for <linux-crypto@vger.kernel.org>; Sun,  1 Dec 2019 21:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575237260;
        bh=Jn7UZEZXAWyF6vGUw5dwrjBzRUXsVxoM4RNFSEtOfpM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=o9xZuemp5sV+YKATnBTiWhul3lgFnLGzLn+sXe+wumk+LXrq55tqUz0gEVPrz4Ffa
         Z1cSvNRmCkC1y/n+nJS1JOIzAiRPOQ/eNXDgrdgoima995D+UGSEoRxtZH4ynYBN69
         kfdIscua0MyKkbbCqRhKj9IL4vn0w2jsNnJGgibE=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 2/7] crypto: skcipher - add crypto_skcipher_min_keysize()
Date:   Sun,  1 Dec 2019 13:53:25 -0800
Message-Id: <20191201215330.171990-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191201215330.171990-1-ebiggers@kernel.org>
References: <20191201215330.171990-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add a helper function crypto_skcipher_min_keysize() to mirror
crypto_skcipher_max_keysize().

This will be used by the self-tests.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/crypto/skcipher.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 8ebf4167632b..141e7690f9c3 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -368,6 +368,12 @@ static inline int crypto_sync_skcipher_setkey(struct crypto_sync_skcipher *tfm,
 	return crypto_skcipher_setkey(&tfm->base, key, keylen);
 }
 
+static inline unsigned int crypto_skcipher_min_keysize(
+	struct crypto_skcipher *tfm)
+{
+	return crypto_skcipher_alg(tfm)->min_keysize;
+}
+
 static inline unsigned int crypto_skcipher_max_keysize(
 	struct crypto_skcipher *tfm)
 {
-- 
2.24.0

