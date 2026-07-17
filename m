Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F6828A72F
	for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 22:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784329115; cv=none; b=JQY1iHbqVMH5Ai+xbGybvCqe6fYCRxOgZI1emLjJ23MfbIko0DRBMegOwuk7u3YYPwv4ZFStl+zMa43rqbljTe7qhYg1/LZszBCAYfMK8J9KQy05jKqBJ1LiKQnda00998GrZouB92yyCLLQVltGwCpNyPKIAG4WL/E+CEn7ZiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784329115; c=relaxed/simple;
	bh=i5rzGLbaHmcpYCp4yWAJmCYHbxhKEVphmq5HETmEYQU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NiWziUBx7Qg7CsL4QmqI6JWU4sNou/gXBbGUuJ+MywVZI17nHfR/HB6LoddQ1bCeEDp2hLduhB39R6hN+djMXoaBU1C0n34TLv2GwLcEKmxFAVDloV6rTJ5KeogTvnX6fNNnmS1jsBS60Em5/kKEsBTrP7oRBM0qrWbqu90y5SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=n2nMU2pV; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n2nMU2pV"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2cf41bab353so8502715ad.0
        for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 15:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784329113; x=1784933913; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/XrDsJ0SzvBMeDkq9z30iaPl9hIHDzpkzv1JYRjxa1s=;
        b=n2nMU2pVMQ22ZFod6MwvnSfaYwtJ8SVV8EviA5qa+nCCZb0G0BzGgYuy2U8d8x4lAL
         tHplF+LvDJlL91wzL8ZTh0M0gxuTlwqBDbuNydgL7w7nlnElK3WluX8LaM7CtOMnR1Jy
         rTglGtyLu8uz0lu4MZ9NroyTKunWLmLhhQ12w3hZcewKHo2erUoLoI+9bz6d+f4/AHiV
         W+QA17mC6yMNjkPvmf6rVEAAHUU4csUtaeqynn6ipLeNYJjOWqixoEJaePqMts8rBuAs
         JwekaggJPActtSj+SEajiBRgwR/nl0A2/70Z61loE6HnMVxRqTdkmlVfs8iL9MWryMVg
         zeDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784329113; x=1784933913;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/XrDsJ0SzvBMeDkq9z30iaPl9hIHDzpkzv1JYRjxa1s=;
        b=NhOEv/apRVGSpD3BOLTV98ySXkr5h2IAUucvUji72kCQL3EeiffUgZZU4UZu/B3mV8
         42y2+zU2dot4YP7uflt9h/Xr5/tYOVtvp2hDg9uxhqWasT3zFnAqvPKo0sEvAzCAAqII
         HUB673vWXU838H++gqUUM3fACd83KCwpDQQOSRfaw4muTdYVl0rGaJc/jAj5VrykgtEs
         6KI8bbXvsyjiP0VnEsp4Fgn7c6R1QLNWRCq3KgHFqdKz5xb23wMcc4GqKlqVNks/B40U
         5O0qQdlYwAjKQweOawZSmOkEOd2GShjPr1rMEvL16zDy2HNPFBiA1VglI9+Ces9HqIls
         a+HA==
X-Gm-Message-State: AOJu0YwQEDDRDL4xzdhxProjiv5nP/V1WZAlSoICMmZmZxWeKN7SaGee
	kUPR0/IhhI+54MWgWVNaVhw4pzWqzpLMMim5Z97bg06frpMuHHJWvgi3cv7n9w==
X-Gm-Gg: AfdE7cn8/vPweGh98ltmMX3R4cujK715X9NbJRQ2NhEWbmhroukqIYwinvM4nsWq3f4
	bvzur1GrM/JvmUyQWF6FdeLTZMH8wY2Rwe3RBBY7oJr7CdONNHXdL8okqCKXMRHUYfKSWORwigk
	fHeoV1zuM5KUFYV47xbEelAhQHzCNouE5Sl8SwYaCxjdH6AudKqkM2UbZdTZ/8HECEwlHK4fyTA
	FYidn+NponiAtqCcVO+wPVy32xLRIDlJfLauZFVbjMp3Y5bw6AkcnsG3so41mGcbh6YTIfFg7xz
	LfOrTHsO3jTkC2LO2fXDJH2nDWSPbpsUjnost+dydBi7Zt6LwiJLTGM8EW6y4Lc0oSqP7YEKiWL
	0TAhDt3QvK3qkO0KSZi/UGggSwp3nBIWrtTWRqA6m53kRsycdC8a2I+Q/Xyu/ZthxZZH/DoVfEn
	zYL1FqXYbt9IDxsHWpcJtAeq+kE7TJ03G1De4JHhHkrQz+2INgGBstjYo9F5FCTkwHvEcquLCeX
	UBC50HtBFa135vuhwZ9/j5VgkqSmLKeq2sfYK5C4O/czgHaSsOTjoEXBt74fN8kdg==
X-Received: by 2002:a17:902:d48f:b0:2cc:d807:369c with SMTP id d9443c01a7336-2cf34a3000cmr53616075ad.45.1784329113166;
        Fri, 17 Jul 2026 15:58:33 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e35])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf3471f42csm17929265ad.61.2026.07.17.15.58.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 15:58:32 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Boris Brezillon <bbrezillon@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCHv2] crypto: cesa: check for sram_dma error
Date: Fri, 17 Jul 2026 15:58:31 -0700
Message-ID: <20260717225831.1085313-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dma_map_resource() might fail. In such a case, don't call
dma_unmap_resource()

Fixes: 37d728f76c41 ("crypto: marvell/cesa - Fix DMA API misuse")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 v2: use dma_mapping_error(). Fix Fixes tag.
 drivers/crypto/marvell/cesa/cesa.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/cesa/cesa.c b/drivers/crypto/marvell/cesa/cesa.c
index 75d8ba23d9a2..92e977027c8a 100644
--- a/drivers/crypto/marvell/cesa/cesa.c
+++ b/drivers/crypto/marvell/cesa/cesa.c
@@ -406,7 +406,8 @@ static void mv_cesa_put_sram(struct platform_device *pdev, int idx)
 	if (engine->pool)
 		gen_pool_free(engine->pool, (unsigned long)engine->sram_pool,
 			      cesa->sram_size);
-	else
+	else if (engine->sram &&
+		 !dma_mapping_error(cesa->dev, engine->sram_dma))
 		dma_unmap_resource(cesa->dev, engine->sram_dma,
 				   cesa->sram_size, DMA_BIDIRECTIONAL, 0);
 }
-- 
2.55.0

