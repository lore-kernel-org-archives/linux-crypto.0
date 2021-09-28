Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9D5FC433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 06:05:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB38E61159
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 06:05:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239290AbhI1GGm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Sep 2021 02:06:42 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:51504 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239522AbhI1GFr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Sep 2021 02:05:47 -0400
Received: from relay1.suse.de (relay1.suse.de [149.44.160.133])
        by smtp-out1.suse.de (Postfix) with ESMTP id C32F322240;
        Tue, 28 Sep 2021 06:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1632809047; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yQAKV/G2LGNuS/sfJa5NmKXWu/SnHCyYvEbPF+KVioA=;
        b=fSmvwDix5Ucf/4pDDfwfD4u5sPeXEYw2cInvHT7xFarKOrCGpMvgiuNqZPlato+rk3mN9k
        3Q75DEK592PQoW0VV9gYgAhQf3GtwRAQpJMglJ+/SLv3XybJdTm+nksnBKpFGvROvB8jPT
        QsUg+d/zhcktAEA/k5pCIb9u6hdWZCM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1632809047;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yQAKV/G2LGNuS/sfJa5NmKXWu/SnHCyYvEbPF+KVioA=;
        b=xQh1fI5sI2OwkHZs12rA87/JdKZGdU2WkLhVntZr/EQIwl/tTALcfVErp2xQBIsE4MQ+mC
        5KVQWleY0qBumvBw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay1.suse.de (Postfix) with ESMTP id 7A6E325E61;
        Tue, 28 Sep 2021 06:04:06 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 3F938518EE20; Tue, 28 Sep 2021 08:04:06 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>,
        Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH 01/12] crypto: add crypto_has_shash()
Date:   Tue, 28 Sep 2021 08:03:45 +0200
Message-Id: <20210928060356.27338-2-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210928060356.27338-1-hare@suse.de>
References: <20210928060356.27338-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add helper function to determine if a given synchronous hash is supported.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 crypto/shash.c        | 6 ++++++
 include/crypto/hash.h | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/crypto/shash.c b/crypto/shash.c
index 0a0a50cb694f..4c88e63b3350 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -521,6 +521,12 @@ struct crypto_shash *crypto_alloc_shash(const char *alg_name, u32 type,
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_shash);
 
+int crypto_has_shash(const char *alg_name, u32 type, u32 mask)
+{
+	return crypto_type_has_alg(alg_name, &crypto_shash_type, type, mask);
+}
+EXPORT_SYMBOL_GPL(crypto_has_shash);
+
 static int shash_prepare_alg(struct shash_alg *alg)
 {
 	struct crypto_alg *base = &alg->base;
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index f140e4643949..f5841992dc9b 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -718,6 +718,8 @@ static inline void ahash_request_set_crypt(struct ahash_request *req,
 struct crypto_shash *crypto_alloc_shash(const char *alg_name, u32 type,
 					u32 mask);
 
+int crypto_has_shash(const char *alg_name, u32 type, u32 mask);
+
 static inline struct crypto_tfm *crypto_shash_tfm(struct crypto_shash *tfm)
 {
 	return &tfm->base;
-- 
2.29.2

