Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795752269;
	b=abM+FUkLnX5ft1exKwNEG9am87DfMnIIDgYAf56X7z4cVZ2Dbnqb3ndkBJs2EiQG5Qkw
	 20nNc7d2Z813reJgZ/3mO+mkQVXY5Gt3XOUNy3wJng3H6qDGyFRaNm3iYG+fglDwTZyfn
	 fAsbWwerolo8bD5tZeDeGpFR3N+OLtHsS0pA4WAi4gzqqIry610iwWTkBCQ07QGbj92Ge
	 NtEHI6q5G+POfb54N4tpsZiejMq+dMecmDGZZ80+wDwfG5X0r1P2GRw5BAD+IeabjR9+L
	 T+LJk1XNzqWZ3TaGIXlCvxliqINB4W6+B0JipR+nU71njHMgRF85BETD8+AwqCJ39Aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795752269;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=49RGOLgGTv3V6igoKyBSy0u5pkCbgUtW5o3Nh4WpNpM=;
	b=oP9qe6GpKtfJJx/5NICXO13Xd4RHkizjjAOZW4GTFjbhuv3DcerXutDNnyVCfLhmCc5Z
	 n37rb4nKQgDgZj6l+2sVM8fNotrIXT7MQswqQoFWDbVUS87ZyUZE2CZaeyYuJ8H83+ahq
	 h3ZCJuofcfLHIQ/G/MW76LYz8l4hE34r6QZIm7z/w4SB9Ibecbcd8ZAofklL2SIyL2SD2
	 GokBNALs7WryWGMPJ27YFYlTbor3fNVfPlF7392ds7r9AdmBZ/Zm8XvK4Sh9RooKi3yM/
	 p53/9DycOLEgPFQhGG9zC/3MJ+RMGbf+MYZbnJDt3T0iGyp0hgdBYWEmuXVY5TK76nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AQay7eKn;
	arc=none smtp.remote-ip=209.85.215.182
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C84E606A31C
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 04:04:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2C84E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AQay7eKn
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cc758830601so5650960a12.2
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 20:04:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795752268; x=1796357068; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=49RGOLgGTv3V6igoKyBSy0u5pkCbgUtW5o3Nh4WpNpM=;
        b=AQay7eKnKcw8AeUT8yBh78HidoyYQXWdsBAkdmjx2NnL868TRROlcsT0bjTSF6lnNO
         9a/v0kyEEeISZG6iRPPt283rfzG/x4OypFsbkUqp5tp2T3x+DKsgdmUg/HhHbot6i3N2
         bzL+fA9Xfd21B3K9w8y1/OsERl5FbB2IZ54ZISvW4uGvbB/cg2EpcyXWVSgA4+6dXFFG
         NsnAFzx8MxqBjQcGvnecB3OSRVHWLT8Y/iHyJmGik3/jAW/bfPvgzAm4S0YBEY3kYu9F
         avhrEcN71w19ZjIrrrwMW731dXnjM5V67VDV+9X20egfj1uGOkOQ+ZayjnIGDBYMvC8F
         dRFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795752268; x=1796357068;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=49RGOLgGTv3V6igoKyBSy0u5pkCbgUtW5o3Nh4WpNpM=;
        b=NZehsCxSEtkV8a5k0VhL0TDFIJ32YiaNYUVdSh/mI8T1Hx+kpshcwMgW/4qmIUkLGR
         tb/nyI3LYe+F1P9udaslNHABFoLGSpNNnNLlfS/Ey4vqDMs+QafQO6j8n5vnNVi2sYDh
         Agd1cE/TsjS3qaIiEU/tJ/iLsfQUHLQAGmnwJwZ197SDI4yelkAtdnZKaCtn6Xm72YSD
         abGEnKEmi3OdRW4i9kUzvMdyZuE+IDMBAPgP7TRfyukGSjyu2WFmrLIdFNDf38d+zdte
         6RoZdzphla7e1732rWjQyTGC08tE4mXqrU6tzDL981R30rrJe9P9ByykMQ6iz52dPG1d
         X1NA==
X-Gm-Message-State: APuU4Z+xTfqicEevUxmIqz9JG8//ShqbStYrVJf5mw0zHYkKYuGuEOt5
	1WXT9l0vct+HStJ/11f3ycNsmtmEyDIpY2vvsOUlcCjAibpJdk1UVyKWqfngDA==
X-Gm-Gg: AZFdTZcLN7/M5OOAs8cfZNhzBDS7xC/ESbs/bGsxH7MCOGuaQpqiI1xdVHLbL3a5ZkS
	DdxDfoEyHIuZ8DZIOC8hmYPyzg7uiF9oaBgF4J24adp0am89/+ekYzkJqcvFSDvZmyA36IhwJ19
	/CL3rCXz5RRlez+hRzFEmHwlHbNEsru4kmbM+nGYAUX0p4NqwlFSrncZBWkx6CYNrZv6bO+URJH
	E47C/s+QjZrAkOTIDLxRDER9srGFJ7Zk9IBG1S1oFv6fsWf51jY8pipxWur+Ynbw/Ix2orSRhwl
	Bz7nIBE9XQaHttFnDES/jCP+glWCbjo63UDBMhSO+Q1Fg2aWSurVVgXLKO1/D1Ag0JTQEMwXNeH
	xtfw3ZO8OMFTbHpP7wyiSs1cbA/p2DFFxIaiX2njBJg2P0Nzl0MCkCQ4kEK1trRJA8jMdyUvF2p
	47fuDzLKn/OVwW6jW+Txr6LlUG7LZT1hs9yKdO9rn4Iq4ECMJo3DRhCms4BcCZOLEqYZRc7fD7D
	FjVVE+WnxVA+BTxTD9XIbYSsTl9XCrtkNFRCNJi5sL0LHD8xN1z57ROHevG5IrWzKwMO+yEZU8d
	vvyVLlpzP0Ma4iCDw9wskMxAIp6QklZIvpJDb1p47EwYiPAm4wi4WFXGBYf++6NorFA0hPDAnXP
	gkThjG/N6GIj8CNQKqVCYk8J5hERF2Yl5MvcL6qH5SCstoBhxkVfRtjXocuN6f/yVh+/Ng9UDot
	N2YQ==
X-Received: by 2002:a17:90b:2f8c:b0:3b4:10c3:c1b6 with SMTP id 98e67ed59e1d1-3b41c9286acmr23144333a91.25.1795752268454;
        Thu, 26 Nov 2026 20:04:28 -0800 (PST)
Received: from ryzen.lan ([2601:644:8000:37f::e34])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b457a58d04sm15090652a91.0.2026.11.26.20.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 20:04:27 -0800 (PST)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	James Hsiao <jhsiao@amcc.com>,
	Rosen Penev <rosenp@gmail.com>,
	Christian Lamparter <chunkeey@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/8] crypto: amcc - fix scatter ring full check
Date: Thu, 26 Nov 2026 20:04:16 -0800
Message-ID: <20261127040423.1023233-2-rosenp@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261127040423.1023233-1-rosenp@gmail.com>
References: <20261127040423.1023233-1-rosenp@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

crypto4xx_get_n_sd() compares the scatter ring head with the gather
ring tail (gdr_tail) instead of the scatter ring tail. When
sdr_head > sdr_tail but sdr_head <= gdr_tail, neither branch of the
full check runs, and the allocation is granted even if it wraps over
scatter descriptors that are still in use.

On an APM82181 (Meraki MX60), a stress test that keeps many
out-of-place requests in flight stalls the engine with this: the
engine stops at a packet descriptor that has HOST_READY set, no further
interrupts arrive, and every later request hangs. With the check fixed,
the same test runs to completion.

Compare with sdr_tail.

Fixes: 049359d65527 ("crypto: amcc - Add crypt4xx driver")
Cc: stable@vger.kernel.org
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index acf18b71e54d..7a1ababd9198 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -402,7 +402,7 @@ static u32 crypto4xx_get_n_sd(struct crypto4xx_device *dev, int n)
 
 	retval = dev->sdr_head;
 	tmp = (dev->sdr_head + n) % PPC4XX_NUM_SD;
-	if (dev->sdr_head > dev->gdr_tail) {
+	if (dev->sdr_head > dev->sdr_tail) {
 		if (tmp < dev->sdr_head && tmp >= dev->sdr_tail)
 			return ERING_WAS_FULL;
 	} else if (dev->sdr_head < dev->sdr_tail) {
-- 
2.56.1

