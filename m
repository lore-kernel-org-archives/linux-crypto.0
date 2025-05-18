Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0723D4C8F;
	Sun, 18 May 2025 22:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747608074; cv=none; b=ZsTCG047K+wkbgeQyapyT2ea30lZjRZXGgKKiN3Wpg++rCSq2lrQU++fC9ARnl9lGdx7vCgBvuxChUdF5BUuVU86oBFtue08TDIxfQgc9hfgYmvqRtUhdtkpfqKQXS173E0B0opJG3n3+kRZ0uwt447YNtjhtb1F38qLvZQ2RQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747608074; c=relaxed/simple;
	bh=rtk4u5Uitm1PcEYqKDexRiQXl1JMyKMBkOdmk8Ckz3E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h9rkHZxDTadrODLEIuPw2XyQBtVKrWbKcCs0VuBEvQMRieBO3d/KyFLmTdax4aM76ahbY2R1cW+yGw1PgQ9vPRBCPVB5lkl6dZaqBpACsH9nV4vfDMoOxnRznbEbBMDuQ2GsHPZNkzP2A5lbnM2XdrovN34AOityKzptybevLTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b7dEFwPt; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b7dEFwPt"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-742c96af71dso837287b3a.0;
        Sun, 18 May 2025 15:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747608072; x=1748212872; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KjBHH1i6XFYI5AWDEmAoW7kKAL7JYXfI8FoWaMkZhLo=;
        b=b7dEFwPtKez6sqa2sOlKEff8wzfz1yAywxEVFYOgfSkKukMprhUuX7tdgf+igf/xxv
         TMCIh2zVAsEZ2v+t8E5Exkb9FKT2YqS4260MURpcpvtNgDrEGT4M68pAz/HnEj7Qed46
         3mzdWGYVVyathr8cg6HOGqgK4PLCKjljet1YSVSwrAuPYbkEo0czeoMtLt+lJLlzSLLo
         7sAoF99DDl2NeT5Tsc6lmpDy4H8cJpH2+KN4PNIchi6x96cgN0+r6EIDmBzqOh++uMvB
         yIYS1lNzNyWGFyjHGwdHqcuurOxEE+5PenpRvRT3TLDKDFhIJJQj0Vl1zo1lcqigTNLB
         Ecxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747608072; x=1748212872;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KjBHH1i6XFYI5AWDEmAoW7kKAL7JYXfI8FoWaMkZhLo=;
        b=YW+HtmJVqEkOBABNa7kzZRlAg0zXYS1/0S9fmUruhQ2+YZE+ouZH2uXfTliqdGLYxX
         +20VaHDrvX6t8g03VrHchvgKb3tvzJ+urMzNMN3LB6giUiznmsH7HJUEKgNVkS8MtovU
         6Llcx/pcfzRgxPQSnELoRMTiZpnPM/hsJIhJJM6CDnAXzpY+X6vDwrMadmLPIDuKmmRX
         SeItyLLRPAoF1XKz0xEmeGBhJ14FGGIrRhpQm+TA76uIf6zYbMDYUh1i4SKbPLl/HHZB
         dZLyoyVDgUZLuhGHscKwZZr0GKPGG245qjWAEcVkIlm7Q4V3bzNKKCUrqM4SpLLvQm5l
         D9Ww==
X-Forwarded-Encrypted: i=1; AJvYcCXGQ4iwNLo94mKbsWn7FzMKLRm2LIAcXCqVrOJCqAb+IDYERs9QBQvTJL4bqfbTLLi0/sZau5HOQmgB/Wo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOE2lM6Le1kpvdM1YJlE1i0XCOA11LOvCr9B+OEqkRTXzfxwJ+
	3gorm9O8YFzTgsNtLTAd+0P9blcvUOn9+fG+uHn4I0lDtVarFwb+DJ5I
X-Gm-Gg: ASbGncsHV+tem3m1wc5Pw2TStUc7oj61MkX+xQcYf9sncGorIxiyx580liV/x17zdxo
	yiNML7Ha78hzz1Y9G2jVogPP6e1xMqUgIjLze+GUtbsCctBIWqOMxCcwMMkpy6GEUcRaub/lWLA
	lGyoyJ2tpWL9w5odZg1o/ys+Vp9SEDL90x1cXB6J4nXppKgbWeVS/zgwpdGksFR5Pw2VbQZgMTr
	TSkX1xSNYiAWF3JdsbbleNWgdsTBqZLIOBOAYMFQi/BByAKHE94VraR9DJotIdw7Y8QammGejNB
	J7ao1pfFQiNQqQQvhlVhpRsAxzfDZ1Pmm7P/xQG/DbhxMKi+DZrPQtf0gTYzzafr8MWsj0iHOsW
	88DT+6GtbXla8nu9BVJieb3eLoPTD
X-Google-Smtp-Source: AGHT+IHMN/e+I3KzNiOjgsoqZMhZNb0ZVV2fp/nzuyWQgPN2tmpX8v0t44jt5GyNaV67rouoHk5koQ==
X-Received: by 2002:a05:6a21:33a5:b0:216:20de:52d9 with SMTP id adf61e73a8af0-2162189f109mr16467728637.14.1747608072095;
        Sun, 18 May 2025 15:41:12 -0700 (PDT)
Received: from ipravd-Nitro-AN515-55.hsd1.ca.comcast.net ([2601:646:a000:5fc0:c2c3:6f03:ebce:70d5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-742a96dfa19sm4948436b3a.22.2025.05.18.15.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 May 2025 15:41:11 -0700 (PDT)
From: Ivan Pravdin <ipravdin.official@gmail.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ivan Pravdin <ipravdin.official@gmail.com>
Subject: [PATCH] crypto: algif_hash - fix double free in hash_accept
Date: Sun, 18 May 2025 18:41:02 -0400
Message-ID: <20250518224102.478904-1-ipravdin.official@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If accept(2) is called on socket type algif_hash with
MSG_MORE flag set and crypto_ahash_import fails,
sk2 is freed. However, it is also freed in af_alg_release,
leading to slab-use-after-free error.

Fixes: fe869cdb89c9 ("crypto: algif_hash - User-space interface for hash operations")
Signed-off-by: Ivan Pravdin <ipravdin.official@gmail.com>
---
 crypto/algif_hash.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index 5498a87249d3..e3f1a4852737 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -265,10 +265,6 @@ static int hash_accept(struct socket *sock, struct socket *newsock,
 		goto out_free_state;
 
 	err = crypto_ahash_import(&ctx2->req, state);
-	if (err) {
-		sock_orphan(sk2);
-		sock_put(sk2);
-	}
 
 out_free_state:
 	kfree_sensitive(state);
-- 
2.45.2

