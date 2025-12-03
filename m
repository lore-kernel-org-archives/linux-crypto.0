Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661E62B9BA
	for <linux-crypto@vger.kernel.org>; Wed,  3 Dec 2025 03:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764731485; cv=none; b=seHVOphVbXblJaE1tTLC85ffVWRRW4AIczy8vbXRiAGM0LCW1/wkj2oSWzakqEG5+3Bc/Te3/E26BTJuk5fDd30sYnYMel5k6DaKNGQTsi4mFpaiLkMvFa5EVl+h4wR8KCB+v0OVTxJlnpv55fEzNZyYPfR0tIG1GH4s7A6+n8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764731485; c=relaxed/simple;
	bh=x2vPXVHvawbRmTSpa9nZ10yNkz8WbOY2O1cL4hKi4NY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=RlFPtQ3YISI2CMZKNIBz4JnvSd3eMDzLiiaw78I/TrnKA0weKkG3mEK+x5+T7keJwvLq/k0YJ2ZIHDkoC/dDm3XXvxVvEoRhnlEGAMq31O9zPy9cSyftddUrEq0rLHJSc04CafjQJu4dbK+36A8rFQDreASdl3WetimFgN47d40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EW2wCpul; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EW2wCpul"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7b86e0d9615so7504386b3a.0
        for <linux-crypto@vger.kernel.org>; Tue, 02 Dec 2025 19:11:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764731484; x=1765336284; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=4tkMX4RDJDZIgVTWOWoySUpMyJ+T716kWz62BdzG6AQ=;
        b=EW2wCpulgOoYLeqmbHpM2rDPzoQ+W1CV+I6dKPhDFIb8cw2PlYh2dbnU5oDVrzYHao
         26JD7QKUZVQp8ayCa+PL1JJ7rsj/ula2kHzbYMJvgNPc9gFFtVopFhWRsCreNGDaVhoR
         NvqwkD0TBXX7qC53/Ayi1sajeiOxW1AbB3YIVhKEeB5nkFHf/i+PgviXVNucpHCattu/
         QeXFXR/43EzOd6rniu3epiZiCUyg49vPIfp1zPwWxYpa5tZczc1jM0UfjMT3YBHemY6x
         D20pHso4nXKttCegsj1MP5LVYSwK+h06pyVSb8PAzOQolM+ZL2THB3g0fTy6c2eeFDCR
         9yCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764731484; x=1765336284;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4tkMX4RDJDZIgVTWOWoySUpMyJ+T716kWz62BdzG6AQ=;
        b=Op9j/+PJWVUj5pmv+QGJuvRcNZsgaWtUQ49P5+mxKF+eCXJFMhvWhfX5MycbiFI5hY
         9QunmLbuN7yCgCxhpVkwAIeJdVwEnXbwBTWWlKbha7vxuFhP0RsKRD9lQbhvV3MBHUFY
         9mfPjtybEBKu7aTZR87P96iW70JFeM1mX8DXP1tLxp2LuYrhrHcVM4CSltGXXjbejpys
         3Yhl1CxJLbQFtUi9uymzN6crkUhhO/c7DX0Js8vhpHVAIc8ImPdG4OYlqsq+MjQfBFfA
         pu+lWO9MlXNHfW5Ty12MVzTtnuqwi6LVCaN1acZ1oLLNoeVcSaNocSbcK20mwEYg9xcR
         Bulw==
X-Forwarded-Encrypted: i=1; AJvYcCX3zuWN0MbhNfNcyc8iX6TsDFYC9PTZhCvuO0FZMepaAWQ9WggA//h5nBbP5UvKlFvoFKh7zfO5p/Yprag=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCa1KwsnBzj6BDrggPADvhtcg4k3M+AqluZsMyAdcV4xgXBMEb
	xNKjJCgkvzmie6ye5SkezDGghrKxjejPnd3g3fdiQbR6Rc9CuM2a4Tx4
X-Gm-Gg: ASbGnctzkjWdbGAw22NnaWPBaYMdY3lyWTUE7MBqn2KFfD34VAQP4recvd/urNu33eK
	M7Er95bUEv30VN6OS8wGE0X6eAESgzxz2BXbxH/K5cRDe/TvQGsfTTGY72l4EYzGe0wUEec5MVZ
	oeD1r+o10olvyvL/vH13eAXVv/2dh7FBB09K/LX0+HH1HeKXxbLt1JGz2LGTkeOC62Jy4vkcUp3
	8AjHHnLsbp6eY0B5zuRyY6J6NN7Llk62spQeeolsmfXJ8CiEYTzfHB/ruqI8jy3pXNpLL2aOBH8
	Iz2iGHddJ2Bal3pljOkBb1jVvKbIoJ4PNcAH7gcOgZYZuztwvG+3rEi/vdc2uSAuZDqMpeoew5n
	mlarM9C4SdKDWRKV53iB+F3nqaEfvAwoj5FTGr/2J3BMfKZ0vi86f2qSySrWGCBwh
X-Google-Smtp-Source: AGHT+IGRgr4xbKY54/iIc5o4xSlER4wuJj6q8wopL4MWcTYp7loGtaJLfbyQRr5XU0wcHz6Hn//Ckw==
X-Received: by 2002:a05:7022:60a:b0:119:e56b:9582 with SMTP id a92af1059eb24-11df0c53421mr780545c88.7.1764731483540;
        Tue, 02 Dec 2025 19:11:23 -0800 (PST)
Received: from gmail.com ([2a09:bac1:19a0:20::4cf:1d])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcb057cb0sm95783853c88.9.2025.12.02.19.11.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 19:11:22 -0800 (PST)
From: Qingfang Deng <dqfext@gmail.com>
To: Christian Marangi <ansuelsmth@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Richard van Schagen <vschagen@icloud.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: eip93: fix sleep inside spinlock
Date: Wed,  3 Dec 2025 11:11:17 +0800
Message-ID: <20251203031118.32421-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When busy waiting, usleep_range() is called in ring->write_lock's
critical section. Remove the sleep.

Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
Signed-off-by: Qingfang Deng <dqfext@gmail.com>
---
 drivers/crypto/inside-secure/eip93/eip93-common.c | 5 +----
 drivers/crypto/inside-secure/eip93/eip93-hash.c   | 5 +----
 drivers/crypto/inside-secure/eip93/eip93-main.h   | 2 --
 3 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-common.c b/drivers/crypto/inside-secure/eip93/eip93-common.c
index 66153aa2493f..00772c7be189 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-common.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-common.c
@@ -496,11 +496,8 @@ static int eip93_scatter_combine(struct eip93_device *eip93,
 again:
 		scoped_guard(spinlock_irqsave, &eip93->ring->write_lock)
 			err = eip93_put_descriptor(eip93, cdesc);
-		if (err) {
-			usleep_range(EIP93_RING_BUSY_DELAY,
-				     EIP93_RING_BUSY_DELAY * 2);
+		if (err)
 			goto again;
-		}
 		/* Writing new descriptor count starts DMA action */
 		writel(1, eip93->base + EIP93_REG_PE_CD_COUNT);
 	} while (n);
diff --git a/drivers/crypto/inside-secure/eip93/eip93-hash.c b/drivers/crypto/inside-secure/eip93/eip93-hash.c
index ac13d90a2b7c..13b723bb9830 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-hash.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-hash.c
@@ -270,11 +270,8 @@ static int eip93_send_hash_req(struct crypto_async_request *async, u8 *data,
 again:
 	scoped_guard(spinlock_irqsave, &eip93->ring->write_lock)
 		ret = eip93_put_descriptor(eip93, &cdesc);
-	if (ret) {
-		usleep_range(EIP93_RING_BUSY_DELAY,
-			     EIP93_RING_BUSY_DELAY * 2);
+	if (ret)
 		goto again;
-	}
 
 	/* Writing new descriptor count starts DMA action */
 	writel(1, eip93->base + EIP93_REG_PE_CD_COUNT);
diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.h b/drivers/crypto/inside-secure/eip93/eip93-main.h
index 79b078f0e5da..45afeaa51d00 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-main.h
+++ b/drivers/crypto/inside-secure/eip93/eip93-main.h
@@ -14,8 +14,6 @@
 #include <linux/bitfield.h>
 #include <linux/interrupt.h>
 
-#define EIP93_RING_BUSY_DELAY		500
-
 #define EIP93_RING_NUM			512
 #define EIP93_RING_BUSY			32
 #define EIP93_CRA_PRIORITY		1500
-- 
2.43.0

