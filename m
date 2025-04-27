Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3EB3BB48;
	Sun, 27 Apr 2025 11:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745752483; cv=none; b=b9XCrgDF7hux/eOecoSRJjOBitKP2WeJwg123H3MTmwlMu0fJfi7Wo7hXaXCB+MRCR48UGd5DRxJXyRQYY5ihEUlRmyiMnlmqNzDX5ofJ4p1VpznJteS//tzVz64FK7ZjvBqdjJ0S17kmYbh+RxX5rT885gdtJhp8GT7uBvPM8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745752483; c=relaxed/simple;
	bh=OHPq3cQvYAfeMfKNid5wSfhkKzwBaStHV8HzBeC3uzs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WlslH6VhZzH0N5cQQ4RN3WtVb9ACgys126rN9pckTe89iLO6MmoJ8wF59mmPaVRHWKhL61JT4JKCi9KJt4LEPZzurhVGYuCzhQ+aGNCX+NBd8LSVCPv4ikxb6PDR7v71Avudtp6cLRNrdbVHmyJz89Kc2oyEEl5vSYKiYIXeJSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AayA9886; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AayA9886"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43cfa7e7f54so25011925e9.1;
        Sun, 27 Apr 2025 04:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745752480; x=1746357280; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=W3KBITx9RJaJB+v1y23nabF6VYlDwF1hnHk+X2NkE0k=;
        b=AayA9886PFux3PP0lMXAtHj7a5s5sPSWLzmTotHyNx1gq6pFsfks8p1ueNCa9zn5VK
         PuJZiAtNIJGrSmHYjC8cIzxzPznV9UDJPs+keCQJOeqpOoJUb29pfvbSkMc3CkVMS1rw
         gT8bVPw5Iq6rtHwMXkibFacM0qZjxg660YKX6Epf2HWYo83IhQRMgQVhwY0/XhGTVvla
         eaEV/AJXQ6Am/2gAkJF8YTBvJAHAK2N434q09KiQSjPVizwkZjr1MnRb5CJnSLWHMqMt
         XzrOOc0xI4GziWgP4HMws4x306tRoHQZuEogBNbBfJ9PMvkIZvlWHxB1G2eS+fhUbubi
         9ePA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745752480; x=1746357280;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W3KBITx9RJaJB+v1y23nabF6VYlDwF1hnHk+X2NkE0k=;
        b=hoD5OnUETnH+TdMW2jlSVzSaXNubUNgXX1xP3BL17I0Qy9eQGbI/7aL+ClJyh8oyLM
         Ti3sFhBml2FLbeiHYRe6XUP3ba2UWEcQwSQXmhCkFP2JOSH/Ni5OBL43tRVNf8eSwUex
         WsQ6EJ60MQn2e1V6TskavP/Mec/P/XfBNsIv6qyboJPBWVowfPEYgulYfHKXLgqVCjff
         C5FFsalLphzRBIwUmdwOm4Ex2vCg0CCyNYlBRHgLrRPiDUt5hTotOXhZkmK9WMGaiWOb
         iSABHBd2atqzhnZuCyyl2R6H8gn03nUeNYRLyoswD4R/QEAHkcUVxMejWzOJQ0yqbXEu
         LBsg==
X-Forwarded-Encrypted: i=1; AJvYcCVxZZnCL+BeU6lMQY2cuZFbqSu1STuUXqg3+pfnnZL7q7E0cQrqY5wDdDMQ9VuK21bb58h9tQ3zqA/YUYQ=@vger.kernel.org, AJvYcCWL72HQo3md59gxZdHv5kJjulFujJg7xT7GUkTJZx4Lybg0aFwoMqRe5uKJ7hsCzVT198SjDbiVNxEM2MNh@vger.kernel.org
X-Gm-Message-State: AOJu0YwYbeKK0lxrNQi4bjiDlV6BRSHCvLVz5jvuh9vRIMmH/nJVmLH4
	i8N5GFrzfLRvZEUZmIyOMss79/YMxx5j43lxtmqlFczL5N+EZHsB
X-Gm-Gg: ASbGncvs4KhlxRuSuRm3Kz/zQSZMX5mRO1e7ZiM3WpU8Jg/j563cKA0mjdp4R/01lKS
	wvoFv5cvn9XxQKmyzjToEx6PjSurNLR0yNJGTv0pcqIQK7dKpM9iPlU0RpRR+ZpaGPE7U+v3j2F
	EVwLtYTviB1c3nvo5E9hhcOtBgcJU2hAoKra0SRgL8ACPYa1JMEQ9ENAONkriVlDKaIhXHdsU6W
	iHBU+Rl29+aPLmcr7isprFr8Go7VhYP5asdMJwlxcMH6grZjSREkELIV6+E+tUIo9amq0hznIr3
	2ZEIUzvfX9oOKYF6bAxl3H7HiyLtehgUeOw4iY/llTgO4t7WsmiARBkfYzhSKpd9
X-Google-Smtp-Source: AGHT+IEjc9o8H8oECCb05JlQieQM2HuT1pOumzI29bfNceULPIWLWaiAlh6hn8YYL7mavp+K+CgJLg==
X-Received: by 2002:a05:600c:8109:b0:439:873a:1114 with SMTP id 5b1f17b1804b1-440a65d27edmr65047645e9.6.1745752479653;
        Sun, 27 Apr 2025 04:14:39 -0700 (PDT)
Received: from localhost.localdomain ([2a01:cb1d:898:ab00:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4409d2e0241sm122350515e9.37.2025.04.27.04.14.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Apr 2025 04:14:39 -0700 (PDT)
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au,
	jernej.skrabec@gmail.com,
	samuel@sholland.org,
	wens@csie.org
Cc: linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-sunxi@lists.linux.dev,
	Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH RESEND] crypto: sun8i-ss: do not use sg_dma_len before calling DMA functions
Date: Sun, 27 Apr 2025 13:12:36 +0200
Message-ID: <20250427111236.25668-1-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When testing sun8i-ss with multi_v7_defconfig, all CBC algorithm fail crypto
selftests.
This is strange since on sunxi_defconfig, everything was ok.
The problem was in the IV setup loop which never run because sg_dma_len
was 0.

Fixes: 359e893e8af4 ("crypto: sun8i-ss - rework handling of IV")
Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---

If someone know why sunxi_defconfig have sg_dma_len() which always works
even with any DMA call not done.

 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
index 4caf17310e90..ddec1b08d4f6 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
@@ -141,7 +141,7 @@ static int sun8i_ss_setup_ivs(struct skcipher_request *areq)
 
 	/* we need to copy all IVs from source in case DMA is bi-directionnal */
 	while (sg && len) {
-		if (sg_dma_len(sg) == 0) {
+		if (sg->length == 0) {
 			sg = sg_next(sg);
 			continue;
 		}
-- 
2.49.0

