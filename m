Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCC539183C
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 11:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776337307; cv=none; b=BH9KT2+CqjpkdtAaUasjME7KSbRLK1OrzYOGVeLiOOxMgeW8ftjV/Uzf3hoCBZKsgWXyX0n0TCSiZ8W+t8bF8Ah5OkzfkEKAtVU6ODYMFVjeQlS0nw0Oj+FCe2P+aPiFANkEb8ZlDZAh12KuOk2BSnDaK9xeBUzk96iZwge2vUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776337307; c=relaxed/simple;
	bh=PM6HxBGY/uLlU1yBOXRA/GDCOAXJaEkAZa8B3LSKqVs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jRuDlodRsO+vQmwWw8kJhb+DBHmJIxwfcYUab7HVzIscD8rukYciDiQTMHy5B0+eklBrL+9e0n2XykY0VbRDLK6uxBdLh/NJPDkyUu7QVnwrk9u/+bSM2Qn+Ua0ktP1GtamEvAQNjzQtHkmbxFqv4WV2yBZ5ptZc+PPU09Hcdlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fLyXElgf; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fLyXElgf"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2ad21f437eeso3380635ad.0
        for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 04:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776337306; x=1776942106; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2jfu3qCPkJ7YryG+WcH1SeIojzYRxn2U/dbTCrcamzw=;
        b=fLyXElgftCXR51ZLVEWRptTfBOYkpUo5OwBY7RXmSO3tVrxxgVc59Je37IgmeN0qT/
         vVNavTwRHo6KqG1DX3Mcf7zoIrhExKsttIRbVjVn4Smel/MSVrPnnT8kVscFM/Bn5AK3
         4y4OwjWUUzDW+0sjDJBBOQ+vgruUXP55SsslNnb7+vOstpOgnPg4/nGyR0lzey+Im24w
         JQxRLWsfb2UrHId8KdOv4skLfNv5N+nuMa81mYnIFQsuG7EPbDI85DQrYpij7WnqG7Ej
         P2cGXx0k1BbDBzFVSEztXJn+NER0qmyjKu+HFTDEtQANoTxxK2KGeb02WR9jqILKJUSU
         +8Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776337306; x=1776942106;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2jfu3qCPkJ7YryG+WcH1SeIojzYRxn2U/dbTCrcamzw=;
        b=couS4/zGB+VKdB6MG2z0C09EzpDMwPeZwz0t071YkOtwN10WAXWmLHIJIZxj7+qZfj
         DUuWqJqQwsTTUYl9uxuOtvGPhbZv+TIBKsBBYO/z4iZAS/VPeVhfvq4O7iO2DJ1w2pFv
         Sh8Y6npd/xnQKLCddHmUqwGjGNhes5w9EV9mw8vZp982vygObmD9yBUluCYR9/oj4+pk
         GgH8JzrUlTWg7P71jTFFlnGLhKV0wZwrPIXmjOHw2kYrohxWzKKLnv1+GDLjQNTkcmc9
         oRpsfPjGDN7zS6dlgyd4Tnyzo+2xOVPCIq9uytcXImh7KLdC/nR6zLDiJoVTp6NvYlOK
         r20g==
X-Forwarded-Encrypted: i=1; AFNElJ+iFF9PDXZRS/h5qed1yOddpgYtapWamt+snaS+h9Sv7d7XV7DJLF8OXTaDzFR90ORhLOj75HzIk5tuwUE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/XtEPyb/L46xqtzMC6zQra5VMx7hKrokUj+Dk63fdfdBXW1Br
	VBRk1wVREp8KrYwDuE1H2BCR3xyiA8Git1cZXC2ZzJJFukhSExh5Ctnt
X-Gm-Gg: AeBDievxwNYaUX7Ka2jrFGjhiLOf8JxdSG7B+rL4g3Ga1A9YaQYIKkKKiII2hpbE39H
	DLpz986jeB3WQ1moBDjTyP6xYFMw+/2t7qfxAc3fj1VKlkLTj111HdJMFVN/2BlErsoiHWgRqPx
	k3nY/RK3j2XnGWQkKAvj7RGKVCxqgKgPlMQxuZf5/BYcAlQOmn8Sbsn+W+wfz9a/m0AkAiavQDI
	RFw9R4LezF1L+09d0o153M8WN9QLaEu4tjYe4WCpxuvm9x6mPAvLbnVdYIJRNCsSxLVMW0H0M5A
	FeyGwyhoB7xKJz5YE9rfIyw3ry6d67vWCNqRI/fLHrPEtddrKobT8ZcZT++kfEu+Mqp2y7Xe0Mr
	oDZHWcuQhRLCb/5EjXZytlaJLgtG2WSKaDxI4XUWsy1ICFBrZQ2BFliXv1Ro9F7dls8brII5HI2
	S02nvTMhtt/9j3NGOIHXtY5wggqewQYbF9woP8NNGpETnZpg==
X-Received: by 2002:a17:903:200e:b0:2b0:ac1e:9730 with SMTP id d9443c01a7336-2b5eaae081dmr22286065ad.14.1776337305794;
        Thu, 16 Apr 2026 04:01:45 -0700 (PDT)
Received: from LAPTOP-TU1AT3C0 ([2402:f000:4:1008:809:ffff:fff8:74d5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b4782b113esm66949675ad.71.2026.04.16.04.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 04:01:45 -0700 (PDT)
From: Zhang Xiaolei <zxl434815272@gmail.com>
To: corbet@lwn.net,
	ebiggers@kernel.org,
	andersson@kernel.org,
	mathieu.poirier@linaro.org
Cc: ardb@kernel.org,
	skhan@linuxfoundation.org,
	linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-remoteproc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhang Xiaolei <zxl434815272@gmail.com>
Subject: [PATCH] docs: staging: fix various typos and grammar issues
Date: Thu, 16 Apr 2026 18:58:53 +0800
Message-ID: <20260416105854.788-1-zxl434815272@gmail.com>
X-Mailer: git-send-email 2.53.0.windows.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix a few typographical and grammatical issues across several
staging documentation files to improve readability:
- crc32.rst: replace "decide in" with "decide on"
- lzo.rst: replace "independent on" with "independent of"
- remoteproc.rst: fix word order in dependent clause
- static-keys.rst: add hyphen to "low-level"

Signed-off-by: Zhang Xiaolei <zxl434815272@gmail.com>
---
 Documentation/staging/crc32.rst       | 2 +-
 Documentation/staging/lzo.rst         | 2 +-
 Documentation/staging/remoteproc.rst  | 2 +-
 Documentation/staging/static-keys.rst | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/staging/crc32.rst b/Documentation/staging/crc32.rst
index 64f3dd430a6c..fc0d9564b99c 100644
--- a/Documentation/staging/crc32.rst
+++ b/Documentation/staging/crc32.rst
@@ -119,7 +119,7 @@ the byte-at-a-time table method, popularized by Dilip V. Sarwate,
 v.31 no.8 (August 1988) p. 1008-1013.
 
 Here, rather than just shifting one bit of the remainder to decide
-in the correct multiple to subtract, we can shift a byte at a time.
+on the correct multiple to subtract, we can shift a byte at a time.
 This produces a 40-bit (rather than a 33-bit) intermediate remainder,
 and the correct multiple of the polynomial to subtract is found using
 a 256-entry lookup table indexed by the high 8 bits.
diff --git a/Documentation/staging/lzo.rst b/Documentation/staging/lzo.rst
index f65b51523014..2d48b2667dd2 100644
--- a/Documentation/staging/lzo.rst
+++ b/Documentation/staging/lzo.rst
@@ -75,7 +75,7 @@ Description
      are called under the assumption that a certain number of bytes follow
      because it has already been guaranteed before parsing the instructions.
      They just have to "refill" this credit if they consume extra bytes. This
-     is an implementation design choice independent on the algorithm or
+     is an implementation design choice independent of the algorithm or
      encoding.
 
 Versions
diff --git a/Documentation/staging/remoteproc.rst b/Documentation/staging/remoteproc.rst
index 5c226fa076d6..c117b060e76c 100644
--- a/Documentation/staging/remoteproc.rst
+++ b/Documentation/staging/remoteproc.rst
@@ -24,7 +24,7 @@ handlers, and then all rpmsg drivers will then just work
 (for more information about the virtio-based rpmsg bus and its drivers,
 please read Documentation/staging/rpmsg.rst).
 Registration of other types of virtio devices is now also possible. Firmwares
-just need to publish what kind of virtio devices do they support, and then
+just need to publish what kind of virtio devices they support, and then
 remoteproc will add those devices. This makes it possible to reuse the
 existing virtio drivers with remote processor backends at a minimal development
 cost.
diff --git a/Documentation/staging/static-keys.rst b/Documentation/staging/static-keys.rst
index b0a519f456cf..e8dc3a87c381 100644
--- a/Documentation/staging/static-keys.rst
+++ b/Documentation/staging/static-keys.rst
@@ -90,7 +90,7 @@ out-of-line true branch. Thus, changing branch direction is expensive but
 branch selection is basically 'free'. That is the basic tradeoff of this
 optimization.
 
-This lowlevel patching mechanism is called 'jump label patching', and it gives
+This low-level patching mechanism is called 'jump label patching', and it gives
 the basis for the static keys facility.
 
 Static key label API, usage and examples
-- 
2.53.0.windows.2

