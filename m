Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAA6AC636CA
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Jul 2021 11:04:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DD67611C1
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Jul 2021 11:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbhGPLHi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Jul 2021 07:07:38 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:49472 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbhGPLHh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Jul 2021 07:07:37 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 4603B22BA4;
        Fri, 16 Jul 2021 11:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626433482; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fXSDZW0HceQ0uVUSB6Jl5YO/WIeeZVwZeGWjktfvU9Q=;
        b=bbUYL9sFCAD//P9G3mzYlDTpxP3iEzm5aKVWG8IPWaHq/8adHyL9vNjB6PfWUBoP6O6GKO
        8Bcs25KbGFrh9INYXPSWjZRRpRQZYgTpLaJxExQkWlr9sxIPqWWS8XlTSCgxpGwewgjEGo
        Oc1+r35gyqs695+WMrGM4tCRBj8M0pE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626433482;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fXSDZW0HceQ0uVUSB6Jl5YO/WIeeZVwZeGWjktfvU9Q=;
        b=596onU8M7IXccPykKSwzrpLWFI6s4B+PdcEAEA5GOBcAQ16AUvMd7mAa5D088DpawtFxWV
        1p1oqQ+wD0PmB5Dw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id AF935A3BB0;
        Fri, 16 Jul 2021 11:04:41 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 77CDE5171608; Fri, 16 Jul 2021 13:04:41 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/11] crypto: add crypto_has_kpp()
Date:   Fri, 16 Jul 2021 13:04:19 +0200
Message-Id: <20210716110428.9727-3-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210716110428.9727-1-hare@suse.de>
References: <20210716110428.9727-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add helper function to determine if a given key-agreement protocol primitive is supported.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 crypto/kpp.c         | 6 ++++++
 include/crypto/kpp.h | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/crypto/kpp.c b/crypto/kpp.c
index 313b2c699963..416e8a1a03ee 100644
--- a/crypto/kpp.c
+++ b/crypto/kpp.c
@@ -87,6 +87,12 @@ struct crypto_kpp *crypto_alloc_kpp(const char *alg_name, u32 type, u32 mask)
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_kpp);
 
+int crypto_has_kpp(const char *alg_name, u32 type, u32 mask)
+{
+	return crypto_type_has_alg(alg_name, &crypto_kpp_type, type, mask);
+}
+EXPORT_SYMBOL_GPL(crypto_has_kpp);
+
 static void kpp_prepare_alg(struct kpp_alg *alg)
 {
 	struct crypto_alg *base = &alg->base;
diff --git a/include/crypto/kpp.h b/include/crypto/kpp.h
index cccceadc164b..24d01e9877c1 100644
--- a/include/crypto/kpp.h
+++ b/include/crypto/kpp.h
@@ -104,6 +104,8 @@ struct kpp_alg {
  */
 struct crypto_kpp *crypto_alloc_kpp(const char *alg_name, u32 type, u32 mask);
 
+int crypto_has_kpp(const char *alg_name, u32 type, u32 mask);
+
 static inline struct crypto_tfm *crypto_kpp_tfm(struct crypto_kpp *tfm)
 {
 	return &tfm->base;
-- 
2.29.2

