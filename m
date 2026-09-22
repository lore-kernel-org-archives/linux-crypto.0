Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9FC3B7747
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 03:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790047276; cv=none; b=lHdUOa4I5zbsZIfmVlcSQda22BN/ekfoOvPoCLINXqVzUVehz4BnO7ZZPToykrHP6GGqhzvg/rxKBxN2hhJiAsp/ntx+4eWL4gfzlMuQkdB7tcBo7s1JF/CLu/ENPY2xCH+mvj3KDPPhGncSuP2XqX9pLzJr8q7gnhVq5XCNXV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790047276; c=relaxed/simple;
	bh=t9aDlwefuZ2axwxKwmDy5Z1snX8zjB3z3fzSzyXpl74=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h4EObKyGrNFtFGdVk5lv2gEDv+0rTiPHNhLUkJV8RGw4JaDczd9frby1xzOuvU5YZFvbAa5WkO/VQghFObz4uHfmEHryjxMOIkF8tMgLxflj371UPo4ZSK41y7R7tm48y2m/mjcCFTjl/oi6bzuydm2Teln6Y8sHX7omz11cyF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bud63su1; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bud63su1"
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396ccd4f99dso3917575a91.2
        for <linux-crypto@vger.kernel.org>; Mon, 21 Sep 2026 20:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790047274; x=1790652074; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=AqBh/1GklFhxRrcNP7InBsf+Iuoq5ht51oOU88FidFg=;
        b=Bud63su1hd+cQ9CNjJ0O+9MW2g38mx+B42J/0zCzB67JXyyjtXa7vhoMRxRleQZSBW
         TBKMeTFm9d1IzmYxia8VOAe4ZPtU8nA8XIO3VjxwFUtKMJfRR3z3cntUssSIGvF0OEl7
         5hGifEdsSAplJd3dj64rX7/WZDmfZUAdd/kgiVbz/6Xz049Ws4SdNqsLwXZ/yDQ77GDO
         iT0aCWw8u+s0sbbRxYnyTwtNl4idti4YQ7JQqo7syJySvrQTmMG2hRkn6DgpTIxmu8je
         t+qCDRmmVUcVczL7KUlvY5CZb2T5QjxCody60lSHe4D6HvN77O35PPwteAAAGVdWTauU
         TURg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790047274; x=1790652074;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AqBh/1GklFhxRrcNP7InBsf+Iuoq5ht51oOU88FidFg=;
        b=BJ0/xX/dggLWqBlHMdjhbuw3iFbH2mpUDldbPCYzFGfJNsHtSoKjWYPmY458df1urj
         /KJNuqMNsMMveQPcU9bzXjPtYlgXWzDVgdUzpLJDlBjNPSrYHYz5+Y6SE3eQJb8oeVXo
         smdJvJhKfRCwE26TfQwS1mDHH0WEr6zoWtQhOXfrTBEASZ8KvmUVWy6fWK9QLxi3Jcet
         043ApKMmXLBpTFEwCTM8ZakB0mxDCsRbf7EH2RW0nMu6HaG3Z3fQ550uREkYvnzGPaai
         rF4olcdOpYUNRhwU0w9eduzwOlwrZBu3kl/PZJ9IJppqfADf+8Mo3XHgdYEJnCyWP6tH
         BEsw==
X-Gm-Message-State: AFuF++l2fbRN9PHumax4bNzbmnyA9+hIXwpAth/DmWHzo17IE9z6W8PW
	Qn5fFfuYWxUYLoQLh+wXmpwLu0KC1iq/gQMwEO/v6lISLnPP1G/Y9i2110LDWA==
X-Gm-Gg: AYBFou1WA4AmFlR4HTlkoBl7en418RgARpmbuKcKtlMpmdX+68lXAFryqkFgR2HQ7eq
	399CUcNeB4hVe1HaXlW7A21PSTsyfHaG9AyPSgtYNs/qt4PGzmy71UOuzhKJE0k68BC3M4Zd4p0
	ovNCFvwfPZD5nEE729sOM94lu6dBrUkMYkDpbnMVIALMru/Z3Iy7FF8mVKoeVEoNYwlREKWpsYZ
	rKdJzgLZl7oYxmyWKUoWPa+HOZg1aF0JQ3QbdFwtOkTnJLQYI9w9F0htfvOKJgXeVIohgoc6KI2
	thRGBWRpObbIrp9evG/vk9mlHhhF8oMGOqS0PcWaQLWuN26re6bmZaR56O/QOXIQKct0eByWDWX
	hmrHUHHiTdm2cxvV8VKAIVON/psvcoHOc7hRzxTn5NAI1JeovRivwGYCzYA1I374YaThP9C9Q9X
	xodBrDn7CttGu7Ndn7KaKwqtr6AhBPNOdYMrj+5smCKWty994/Xegxox+N6FX4NHVxKAMMgKd+e
	33oPIGGUgtcVuTjPy3542I8pqHMMubMKIWPuMSTl6ewW70sCMwZMeMmg6gAdwDb3f4487SmNFMO
	28nOoT/iZY7LUg==
X-Received: by 2002:a17:90b:2752:b0:39e:6a82:afd8 with SMTP id 98e67ed59e1d1-39e6a82bbd7mr13355745a91.42.1790047274271;
        Mon, 21 Sep 2026 20:21:14 -0700 (PDT)
Received: from phuc-desktop.. ([183.91.15.56])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a06dfd6705sm704365a91.0.2026.09.21.20.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 20:21:13 -0700 (PDT)
From: phucduc.bui@gmail.com
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bui duc phuc <phucduc.bui@gmail.com>
Subject: [PATCH] hwrng: omap3-rom: Use pm_runtime_resume_and_get()
Date: Tue, 22 Sep 2026 10:20:54 +0700
Message-ID: <20260922032054.320969-1-phucduc.bui@gmail.com>
X-Mailer: git-send-email 2.43.0
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
 drivers/char/hw_random/omap3-rom-rng.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/char/hw_random/omap3-rom-rng.c b/drivers/char/hw_random/omap3-rom-rng.c
index aa71f61c3dc9..0797add0d782 100644
--- a/drivers/char/hw_random/omap3-rom-rng.c
+++ b/drivers/char/hw_random/omap3-rom-rng.c
@@ -42,12 +42,9 @@ static int omap3_rom_rng_read(struct hwrng *rng, void *data, size_t max, bool w)
 
 	ddata = (struct omap_rom_rng *)rng->priv;
 
-	r = pm_runtime_get_sync(ddata->dev);
-	if (r < 0) {
-		pm_runtime_put_noidle(ddata->dev);
-
+	r = pm_runtime_resume_and_get(ddata->dev);
+	if (r < 0)
 		return r;
-	}
 
 	ptr = virt_to_phys(data);
 	r = ddata->rom_rng_call(ptr, 4, RNG_GEN_HW);
-- 
2.43.0

