Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6952C001DF
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Aug 2023 17:10:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbjHBRKL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Aug 2023 13:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232622AbjHBRJs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Aug 2023 13:09:48 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA2F30F4
        for <linux-crypto@vger.kernel.org>; Wed,  2 Aug 2023 10:09:37 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-314417861b9so50487f8f.0
        for <linux-crypto@vger.kernel.org>; Wed, 02 Aug 2023 10:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1690996175; x=1691600975;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9JXyrEikc3QRlWp5ZDjTpySdvtRjTtey3fpa/M0v9NY=;
        b=geuk+efyXZZ7bJlsEuhZfXB544jaiq13WtOYQ6V5CYcHjBb8P/eXLF5AwO0V+qSh8A
         lq7n9a+FxHXrJy9SaszDJzeDo2R6OQ8roA4Bus4J9eYKE8jEiNL13YWPWr65cmNvMlp4
         NbsBhU91qq33U40eqEa8UeOs3GBNeoSXSo4ME=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690996175; x=1691600975;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9JXyrEikc3QRlWp5ZDjTpySdvtRjTtey3fpa/M0v9NY=;
        b=KuPp8ryg0p6VnFPUy/DN3Ev9BxBAQiw8kq3IXyJw18TzSZ/wuuXsyAuhjbXArLBn8T
         27XGt0qm3FsmiYYJNmvR4zUl8byPzJ0AG1j3M3V8+zXxRaS5Eb80uUanv1iJF9vUe4pY
         iV1R4NRkWVX4gcAFSr+wkSVIb4Iaaq6XszembWK663Z45Ump9+D1R1+k/CQNrspRih/3
         fPwoRLqxAS5eDixzxHJiaeGQ43yZ8UWe4gcsJDjpu4+CgisdbyZ7hKV/xoz9KYEdKRD9
         ZTwif/wFBh2sGmT1kIb0+32Mzpo4TohNXkEP+gkira98fmnSUEEEB6DOu3GOtnT29Tos
         9sRg==
X-Gm-Message-State: ABy/qLbLztFAXo9JBuOk2yZNljnjsoRe3FGgD89yfpRRYmAfTzMr5gWZ
        ew2eC2qn74MY/wLDW9tG0ye9dKXHzMiMCOpK6Co=
X-Google-Smtp-Source: APBJJlEHrrXECtPdvO8iK3tMF69agBXEGUdVPex6vTfKSLGX0OejbkIg0UJ3blbMa5bYKZ6k1f1rvA==
X-Received: by 2002:adf:fc90:0:b0:317:6cca:a68a with SMTP id g16-20020adffc90000000b003176ccaa68amr5572520wrr.41.1690996174731;
        Wed, 02 Aug 2023 10:09:34 -0700 (PDT)
Received: from revest.zrh.corp.google.com ([2a00:79e0:9d:6:4fa6:1e54:d09:5ba3])
        by smtp.gmail.com with ESMTPSA id s1-20020a5d4ec1000000b003063db8f45bsm19508396wrv.23.2023.08.02.10.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Aug 2023 10:09:33 -0700 (PDT)
From:   Florent Revest <revest@chromium.org>
To:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        hillf.zj@alibaba-inc.com, marcelo.leitner@gmail.com,
        lucien.xin@gmail.com, Florent Revest <revest@chromium.org>,
        syzbot+d769eed29cc42d75e2a3@syzkaller.appspotmail.com,
        syzbot+610ec0671f51e838436e@syzkaller.appspotmail.com
Subject: [RFC 1/1] crypto: Defer transforms destruction to a worker function
Date:   Wed,  2 Aug 2023 19:09:23 +0200
Message-ID: <20230802170923.1151605-2-revest@chromium.org>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
In-Reply-To: <20230802170923.1151605-1-revest@chromium.org>
References: <20230802170923.1151605-1-revest@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently, crypto spawns can be freed in a softirq context (eg: from
sctp socket destruction's rcu callbacks). In that context, grabbing the
crypto_alg_sem is dangerous and makes CONFIG_DEBUG_ATOMIC_SLEEP scream.

Defer transform destruction to a worker function so they don't use that
semaphore in a softirq.

Reported-by: syzbot+d769eed29cc42d75e2a3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d769eed29cc42d75e2a3
Reported-by: syzbot+610ec0671f51e838436e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=610ec0671f51e838436e
Signed-off-by: Florent Revest <revest@chromium.org>
---
 crypto/api.c           | 26 ++++++++++++++++++--------
 include/linux/crypto.h |  3 +++
 2 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index b9cc0c906efe..f877251954d5 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -640,6 +640,21 @@ void *crypto_alloc_tfm_node(const char *alg_name,
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_tfm_node);
 
+void crypto_destroy_tfm_workfn(struct work_struct *w)
+{
+	struct crypto_alg *alg;
+	struct crypto_tfm *tfm;
+
+	tfm = container_of(w, struct crypto_tfm, free_work);
+	alg = tfm->__crt_alg;
+
+	if (!tfm->exit && alg->cra_exit)
+		alg->cra_exit(tfm);
+	crypto_exit_ops(tfm);
+	crypto_mod_put(alg);
+	kfree_sensitive(tfm->to_free);
+}
+
 /*
  *	crypto_destroy_tfm - Free crypto transform
  *	@mem: Start of tfm slab
@@ -650,20 +665,15 @@ EXPORT_SYMBOL_GPL(crypto_alloc_tfm_node);
  */
 void crypto_destroy_tfm(void *mem, struct crypto_tfm *tfm)
 {
-	struct crypto_alg *alg;
-
 	if (IS_ERR_OR_NULL(mem))
 		return;
 
 	if (!refcount_dec_and_test(&tfm->refcnt))
 		return;
-	alg = tfm->__crt_alg;
 
-	if (!tfm->exit && alg->cra_exit)
-		alg->cra_exit(tfm);
-	crypto_exit_ops(tfm);
-	crypto_mod_put(alg);
-	kfree_sensitive(mem);
+	tfm->to_free = mem;
+	INIT_WORK(&tfm->free_work, crypto_destroy_tfm_workfn);
+	queue_work(system_unbound_wq, &tfm->free_work);
 }
 EXPORT_SYMBOL_GPL(crypto_destroy_tfm);
 
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 31f6fee0c36c..34ff2e1dca2b 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -430,6 +430,9 @@ struct crypto_tfm {
 	
 	struct crypto_alg *__crt_alg;
 
+	struct work_struct free_work;
+	void *to_free;
+
 	void *__crt_ctx[] CRYPTO_MINALIGN_ATTR;
 };
 
-- 
2.41.0.585.gd2178a4bd4-goog

