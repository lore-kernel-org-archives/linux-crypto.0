Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1518347FFE
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 03:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790047248; cv=none; b=RMMR0MXUarzELfEAFwp3InZX/oZ8+1sLUMjoiyH0nibjn1mstZRonVgEptdBV565sjU8t31CZFhvpSGzzGpBpYFbT4EbU3czSnnB9ceWNk9rRUwPq57c0I62F3Ry/wUNSv44wI9+dhRINJgKMrarTgMTsTsxA8NLKpIgtS5d/V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790047248; c=relaxed/simple;
	bh=Zx/9MBpB+EgUJFor4JlLXdd0yHAV7pvEgKtDi0YuxnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VORrZ+gDDPU2DEKdKMw3H0OFbD7jlwe5NF2x5aO9wl9CsQTLsL3kUFGXk60Bq+FUo4dqNNfT6GnVC5J9aXuBdVdFTXcyxjtnxOWwWP09mg9ots4GGkLlKYzb93RBSQ3lDxdJ/ERet6T8yA6O27E23R9Uz8bHeQ/N9bbD+1WGjYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F+ocE7WT; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F+ocE7WT"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2db710396ffso4495225ad.1
        for <linux-crypto@vger.kernel.org>; Mon, 21 Sep 2026 20:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790047247; x=1790652047; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tYeRwN+G3teKav5DbRF0AzCOQ1OUDJvL0VrYOUOutI4=;
        b=F+ocE7WT46dxwamlFixCMDoD4JZAsBdGqm5HLBtXXlrI698tlPpWRuHpCK86crMeUJ
         yB8DUDIy4i8j1qUHFx7TddWVuoFFRitZ4jX3a6NOaD4G9q88dO2VM8ZCIYi7bTA7Dmji
         HRN0Q5WmnxWD4FLwg0TJ6AdGKwyjebwjvaXvY+Eaf3U0sTylePA15uQjziFqPjZO+kSN
         zIkTSjiuXAByQaY+Ccshmqy0p/2d+ntKJ180aW0ntDff5EvadS+D0noQlRV+0NY+om9i
         W892fj0MsjGDPjzsgCwAmcaZ/FHk4Ooy9mORz7SXWGbdzUrPIUUwlPqvlWu5cILDpKSV
         oE3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790047247; x=1790652047;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tYeRwN+G3teKav5DbRF0AzCOQ1OUDJvL0VrYOUOutI4=;
        b=gKCeSeoeJuQuNigFbWX6brtPKKCM8VlDg4lqIvqKYxhdxKWaJUrzyzCquIK8uiVBM0
         FNMHC8BtzWrSH0V/U+GmFgAWVN+39ZIoW4tYOZrQVCVbL17QPNjdaoN0nEJiviAr2qz0
         fGZHVXPzJqidwOaW7Nh2WtDV4afw9Rp9tNWA5Mv1qA+sNrAcOOYym1DlDX9HjMmUx1+J
         18MYd8feb49k7SLURAVJdhcBtTmRhFpXkSmuonAc43o1bgRxyf6dHizTNGC7cWgReShA
         z4f1HfIUM0TELszwyo1HzJ9IH0+mIPCyZlEYPvPXNt56NQeFc7UjI87KagbXX4XZMm1L
         ZqZQ==
X-Forwarded-Encrypted: i=1; AKwUvBwkkYSIK0NC3c8vpi5nzYYv7lLA0D2jBBCJHayX5bd+tDMyHaau04eKtYZvJfGs7CNlhyAU5ApuqoV8k6I=@vger.kernel.org
X-Gm-Message-State: AFuF++lovBGy7D8mCkDOrW1Gu+pNnVTbipefWFDU2jllwTi+/MKQKytP
	V8d60cO1lPSACBVYdc90fgJoruUZybJCUPnTRIVfZzElC9WWg9wOa5+A
X-Gm-Gg: AYBFou1TTrud6ly4MWsrMokiR4Oa9KtDr9NADwAQIJqkFy+5ZYih6MRVht0T+4+mbsH
	yANM90KuJbKgZj86UyDjKtcbXdOCHKJWuqS0XMA0vASvbQM+ALkz9bkpJS7BqPsoVnpTfKeB1lX
	4rtGM+gjTddDjJk/jVyKoNK3KNCh95E13Aeq8YlS+zSl36PuQNdpZ4tQAU3pBxOI439uu60Ud+c
	n5XoAVj6FwQiQL5zdqqZxejKdlVoUYM/d+wIMbBO3CeMg97jEbZoS9HB1ZYmSZ4JbElH5pT0XJP
	n7qtXlf6tL2jpoGo2jS2ql8a+EdLUAdCbhCuaDPtybXEQyoctRvvs5WsY3jqLZ6hIL4tZTsmebv
	8Zi0UVfNhntU4SEIZ+Do4gtF00+AxyjV96qe8SyKHMhT7Lbre4Frjef54CoEk9vV1AqB49ATJB7
	c0o6hq6o6J/JnK/tgHOHMKLps6Zolty7P/t08KXLLswqya6rQdezU8PuUjPhjkvUH9hzkWbtNdx
	srOtMznRuWLj3gt485ePuSkf3GLnU/uzBgMUiD+/mJRCbir8CBqCQBdkvCM2I55B3NEAtMlccVv
	2j4ZhxQ5o5Su7A==
X-Received: by 2002:a17:902:e741:b0:2dd:ad7d:72e8 with SMTP id d9443c01a7336-2df59a9ce29mr14324825ad.31.1790047247091;
        Mon, 21 Sep 2026 20:20:47 -0700 (PDT)
Received: from phuc-desktop.. ([183.91.15.56])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df5cf83512sm1940355ad.5.2026.09.21.20.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 20:20:46 -0700 (PDT)
From: phucduc.bui@gmail.com
To: Corentin Labbe <clabbe.montjoie@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	davem@davemloft.net,
	Chen-Yu Tsai <wens@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>,
	Gilad Ben-Yossef <gilad@benyossef.com>,
	Hans Ulli Kroll <ulli.kroll@googlemail.com>,
	Linus Walleij <linusw@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	bui duc phuc <phucduc.bui@gmail.com>
Subject: [PATCH 2/3] crypto: ccree - Use pm_runtime_resume_and_get()
Date: Tue, 22 Sep 2026 10:19:53 +0700
Message-ID: <20260922031954.320895-3-phucduc.bui@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260922031954.320895-1-phucduc.bui@gmail.com>
References: <20260922031954.320895-1-phucduc.bui@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: bui duc phuc <phucduc.bui@gmail.com>

Replace the open-coded pm_runtime_get_sync() + pm_runtime_put_noidle()
error handling pattern with pm_runtime_resume_and_get(), which already
does this internally.

No functional change.

Found by manual code inspection.

Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
---
 drivers/crypto/ccree/cc_pm.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/crypto/ccree/cc_pm.c b/drivers/crypto/ccree/cc_pm.c
index bbd118f8de0e..666866119588 100644
--- a/drivers/crypto/ccree/cc_pm.c
+++ b/drivers/crypto/ccree/cc_pm.c
@@ -66,13 +66,7 @@ const struct dev_pm_ops ccree_pm = {
 
 int cc_pm_get(struct device *dev)
 {
-	int rc = pm_runtime_get_sync(dev);
-	if (rc < 0) {
-		pm_runtime_put_noidle(dev);
-		return rc;
-	}
-
-	return 0;
+	return pm_runtime_resume_and_get(dev);
 }
 
 void cc_pm_put_suspend(struct device *dev)
-- 
2.43.0

