Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5142C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 06:05:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A5AC611CA
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 06:05:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239206AbhI1GGj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Sep 2021 02:06:39 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:45342 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239511AbhI1GFr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Sep 2021 02:05:47 -0400
Received: from relay1.suse.de (relay1.suse.de [149.44.160.133])
        by smtp-out2.suse.de (Postfix) with ESMTP id C3C72201BF;
        Tue, 28 Sep 2021 06:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1632809047; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1VamOQcU1OrVu4tiACiA0zdumWt9PK7vtnP5toK1J7M=;
        b=XneCzjCL0gB2ADQZxAeGU61CYz65Nl2CcFgUPDeHUQjLsTL1gU6RI8auZ7r/d1dQRg7vK3
        dXTGXmDN4dTIg7YJlqUHgJHQFCQnU1NQmxSirngUbZBdriJBxk/bSFeLHXdteT9irC4fi/
        BF+8XRtAk+dePPfL2So/qvRNiNBSzus=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1632809047;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1VamOQcU1OrVu4tiACiA0zdumWt9PK7vtnP5toK1J7M=;
        b=07T7FhqaschQF6qlZG+1Ohd2jzaNFQnPmhUAEbLDcVWe3Hv6OkCfYaFB0d1uaLqATOZGhN
        VJoLI7nwuIked5DQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay1.suse.de (Postfix) with ESMTP id 837AB25E65;
        Tue, 28 Sep 2021 06:04:06 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 42D8E518EE22; Tue, 28 Sep 2021 08:04:06 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>,
        Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH 02/12] crypto: add crypto_has_kpp()
Date:   Tue, 28 Sep 2021 08:03:46 +0200
Message-Id: <20210928060356.27338-3-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210928060356.27338-1-hare@suse.de>
References: <20210928060356.27338-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add helper function to determine if a given key-agreement protocol
primitive is supported.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
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

