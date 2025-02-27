Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152E3228CBA
	for <linux-crypto@vger.kernel.org>; Thu, 27 Feb 2025 11:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740655997; cv=none; b=eAIZbtVcjOwE4pCXZg/MXPBr5V06IokgAHfQVXtZGhe7kjYAPQMsdepF83MvzQP9sRG356vWa3xavekShdOYY5dBwa4ma814nFoIFKtVh8JmGDbZ73OEcThfLL0NVU3qPzDEMMvKuituDiHaOTWlPcoVOlTWRN7U/7Nl5497RUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740655997; c=relaxed/simple;
	bh=LO2N9vciU7HB99mtlW3h5ysZsPTzOm1mscKvDNw90XU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hxLbRSL/Qtsi+L+H0SM7bY2okfDY11DJDkLfVLDcc4Vk4hqjxlrlas6AV6IICZd2rE/3Wm7LBB4gw4MSn7DOqFAQo8JhtBprLE4hSJDZvrbaB+E6RfGfJvSS9vaFbXlGnKHBVWqn8KLTMsMMRb4HnF01Idr7rsP+vRZl9Z26L2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=D5aJlq2F; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="D5aJlq2F"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2211acda7f6so16461975ad.3
        for <linux-crypto@vger.kernel.org>; Thu, 27 Feb 2025 03:33:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1740655995; x=1741260795; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cg8yMwZ72Jlc0r5z1N3IiuaraHv4s6b2xThN5W01Djk=;
        b=D5aJlq2F6R3GUVFt9YVYvhZSbEIyrGG1WMu63jw39i9UyiEW8h3xQDgfWN5Pycnn8P
         beqrTO3UYTF8846iPQOltFhA1dkAD6wN6puK4jcojLYSt2ztSzGi9i2tx3dMkFy8F7Y8
         3P9XUvlZfrALUIckJ3n71tffqsz1+ZFWZbAMasuiVZQ3Gy7K1ceewuk3Z8DOIU6Nricn
         HKI1frdmWR289oCt0FpSOlm4NMj0HnV1FFhyvdPGR1hYfOyyT45CDAmLcC4VQhbRhJIZ
         jJGWvxdM7sF3f+YSy4oeDBoDeCdtPGkLeFXR2pwUJ8mafwT3f8hiUkKPJhpxeUYviKDT
         NCdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740655995; x=1741260795;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cg8yMwZ72Jlc0r5z1N3IiuaraHv4s6b2xThN5W01Djk=;
        b=KOLnHbfi5/lr1UqPeXeC/ASi4gngyBBPWZradnN2DBEaYw8daRPXCZps2wmsxlJu/5
         RAktOFq+66fqDYXqpbMmJS+SM7AHYeukrWBsltQEHJdpztj6hZb+9kFKKxQbmY3FBf6l
         vt1bwk0BhrgnpKF2N9JWGFcGM6ef2yUk8xzOqK1V53oWNzjmV72MTVYZohJWkp9W3txd
         LXJvlcu2ZC37AakqW/3qhhI5nxtG5TL6yIF2uIsr83rrVISDn9CWcv9FCRvW5Q+JPJc0
         cB1zoUG6/R17oF+qMWfjWsn9mRZcnBU1J4kd0k+QjVGD7e5m1Icjk7pQ2P979WEkvw38
         TOLw==
X-Forwarded-Encrypted: i=1; AJvYcCWk43WX4k+E6j4dey2D8vtW1Ue+Qvfva8xYvUq7jKK++3QbGlak2v1q9FED2N5o1dMRANFhaXkKjvXjaqI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzyfvsPytLIJ4HC37PbiA7F5050ajPQ2VuQ80c5jA187Kw1zVn
	iM5vbz3Ppk+e2sd0dZbwkJjycGwlYUL2qvaPAkamzcesLeeOMHo7rblGZBO1O/o=
X-Gm-Gg: ASbGnctqB4zyAJxAlfFZmrx2NWUs7Seyk6vl9eiRwQDfrAXIw6Fpu9VH3JdvSTWL59s
	TNdC/P51ky80UD6RGLtOHZ9UAGBhEs+NoNkRn6yYTo67eEFDgF1kJzknUanYfj1/z+0QXzMwmyt
	7JLBcmZFpA1ozLlC9JTKzfmaJOM+LfQX0FLVomvXQS1d7M/d/BNjdMOplrUWjaj6sYrMKDX6WDy
	W1EhVIJ0SNIWdkdedjGyW0tlTqcNNrqBHdQWOwXQkEQ4GtDbbsVx5QnnFYftQbGhu2V5izIRQV3
	IOCKC5Z/hUnynJdPnff4K/inMhQO
X-Google-Smtp-Source: AGHT+IG4VU2x6YDtNodsc0R4UfSHlwxikIm91sBEmZvthobIJS1xQjZsA9eqGdyUlDUdvBKd735Xuw==
X-Received: by 2002:a05:6a00:4614:b0:732:13fd:3f1f with SMTP id d2e1a72fcca58-7348be7eeb2mr12060717b3a.24.1740655995332;
        Thu, 27 Feb 2025 03:33:15 -0800 (PST)
Received: from sumit-X1.. ([223.178.212.145])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7349fe48858sm1343733b3a.51.2025.02.27.03.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2025 03:33:14 -0800 (PST)
From: Sumit Garg <sumit.garg@linaro.org>
To: akpm@linux-foundation.org,
	herbert@gondor.apana.org.au,
	jarkko@kernel.org,
	jens.wiklander@linaro.org
Cc: sumit.garg@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	keyrings@vger.kernel.org,
	op-tee@lists.trustedfirmware.org,
	linux-crypto@vger.kernel.org,
	Sumit Garg <sumit.garg@linaro.org>
Subject: [PATCH] MAINTAINERS: .mailmap: Update Sumit Garg's email address
Date: Thu, 27 Feb 2025 17:02:28 +0530
Message-ID: <20250227113228.1809449-1-sumit.garg@linaro.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update Sumit Garg's email address to @kernel.org.

Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
---
 .mailmap    | 1 +
 MAINTAINERS | 6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/.mailmap b/.mailmap
index a897c16d3bae..4a93909286d8 100644
--- a/.mailmap
+++ b/.mailmap
@@ -689,6 +689,7 @@ Subbaraman Narayanamurthy <quic_subbaram@quicinc.com> <subbaram@codeaurora.org>
 Subhash Jadavani <subhashj@codeaurora.org>
 Sudarshan Rajagopalan <quic_sudaraja@quicinc.com> <sudaraja@codeaurora.org>
 Sudeep Holla <sudeep.holla@arm.com> Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
+Sumit Garg <sumit.garg@kernel.org> <sumit.garg@linaro.org>
 Sumit Semwal <sumit.semwal@ti.com>
 Surabhi Vishnoi <quic_svishnoi@quicinc.com> <svishnoi@codeaurora.org>
 Sven Eckelmann <sven@narfation.org> <seckelmann@datto.com>
diff --git a/MAINTAINERS b/MAINTAINERS
index 1b0cc181db74..616f859c5f92 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12861,7 +12861,7 @@ F:	include/keys/trusted_dcp.h
 F:	security/keys/trusted-keys/trusted_dcp.c
 
 KEYS-TRUSTED-TEE
-M:	Sumit Garg <sumit.garg@linaro.org>
+M:	Sumit Garg <sumit.garg@kernel.org>
 L:	linux-integrity@vger.kernel.org
 L:	keyrings@vger.kernel.org
 S:	Supported
@@ -17661,7 +17661,7 @@ F:	Documentation/ABI/testing/sysfs-bus-optee-devices
 F:	drivers/tee/optee/
 
 OP-TEE RANDOM NUMBER GENERATOR (RNG) DRIVER
-M:	Sumit Garg <sumit.garg@linaro.org>
+M:	Sumit Garg <sumit.garg@kernel.org>
 L:	op-tee@lists.trustedfirmware.org
 S:	Maintained
 F:	drivers/char/hw_random/optee-rng.c
@@ -23272,7 +23272,7 @@ F:	include/media/i2c/tw9910.h
 
 TEE SUBSYSTEM
 M:	Jens Wiklander <jens.wiklander@linaro.org>
-R:	Sumit Garg <sumit.garg@linaro.org>
+R:	Sumit Garg <sumit.garg@kernel.org>
 L:	op-tee@lists.trustedfirmware.org
 S:	Maintained
 F:	Documentation/ABI/testing/sysfs-class-tee
-- 
2.43.0

