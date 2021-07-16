Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A117C636CE
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Jul 2021 11:04:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2B2C613D8
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Jul 2021 11:04:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbhGPLHu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Jul 2021 07:07:50 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:49488 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232048AbhGPLHi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Jul 2021 07:07:38 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 4CDF122BAA;
        Fri, 16 Jul 2021 11:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626433482; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zrhwWEeGhqBzwG4fO6ATjJUgff+ThHnR+gJis2gc95M=;
        b=VQmHpAj/NbJ/Ezbp113kYFdj68/uPj6ZMrLRCMoHYdiVQDf04nR7jI/+Fj6zOcPI8mFUqs
        cp32JdQ48X1o6XeHDj3BiXh0AyaXJ1uyqxttzOXBLl/wGXfOGKMkmzzkoivhxe7NpVpl4u
        VBCXULpag/YpaTl4coSM/19wGZQOX3k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626433482;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zrhwWEeGhqBzwG4fO6ATjJUgff+ThHnR+gJis2gc95M=;
        b=vfz0mVwb5/+EeB1ZtVj5Q4DREYyNCKfp+ngAVjQh3EZaaHHJfQx3mqwFcXVVOqs0Mc/E/p
        UqHcsAAGaQZUaDDw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id AF85BA3BAF;
        Fri, 16 Jul 2021 11:04:41 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 749105171606; Fri, 16 Jul 2021 13:04:41 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 01/11] crypto: add crypto_has_shash()
Date:   Fri, 16 Jul 2021 13:04:18 +0200
Message-Id: <20210716110428.9727-2-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210716110428.9727-1-hare@suse.de>
References: <20210716110428.9727-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add helper function to determine if a given synchronous hash is supported.

Signed-off-by: Hannes Reinecke <hare@suse.de>
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

