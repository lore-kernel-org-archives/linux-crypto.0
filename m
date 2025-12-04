Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE12B341047
	for <linux-crypto@vger.kernel.org>; Thu,  4 Dec 2025 14:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764857605; cv=none; b=ZJ0/beAKNwHwm6UOFhsz+U3z45qkpL7G5mkpZc9a/6IG9qNZbe+nKN48N2xG/O33LqlQ2L6kHoZaKpE+zFRKXawDfyJ0oKmYvjHh25LOXAQ02Bn23XRSLFN3/8sFzfxiqqALwZ5IOgXHGQrhBybCf8SEVnMxlTl2TsCHinlIcWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764857605; c=relaxed/simple;
	bh=sX8tJl3ec5ExcYdWiCDgj7+mGqBJlF+/32yuBkRXzdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZm0+EMUh+VFSSl4lHRtpJmXeG2KH6wLi0PRrwyx8msG8gg1vWOoy4RqlkPsozw7TxqMrWKUytWJEaX3Y4dcQomxAm6G6zoyruHfVB+fcANcnpfYOxrSm+xXtjqEjyVAUxJPTQgjicaUKJFxkHUtuSqntYPq5HJdGuhjOELuyVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lesFipEm; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lesFipEm"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-42b3d7c1321so617204f8f.3
        for <linux-crypto@vger.kernel.org>; Thu, 04 Dec 2025 06:13:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764857599; x=1765462399; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sGnt8bTKaac1K6msaRLVltkt9xGbtE5aMKqhuya716s=;
        b=lesFipEmw7/uF6wcyTzvp4gLewTJCQ5yanJpPE0A3I05nMMI3hLGNCkoHJKjgJ3xVV
         cFxZnynvoPO6HIgcjuT4RmHQ8Qyc8VjwTCKX+0ohuOXnGOtskReCVOApEucRIz2hxkPA
         gM6yWlYf2vgvSmH+yw7SObYGKK8QtywjVvAsoIW1J14rc9vmP2g3F8TCgjWsbD1Kq7fF
         9gGni3Gkt0LJuXhCftYBBNFSSnBNChtWf+LlC6Bg9Q29jsWa7iKL0M1orxkmewxz1Evg
         0v0Ze/bbyQI9DD0rXJjuCAbp+Jz/5mxPgJp2AAk/VVuS2k6BDjHBC5yhfYYjWTHsxCZY
         sh2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764857599; x=1765462399;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sGnt8bTKaac1K6msaRLVltkt9xGbtE5aMKqhuya716s=;
        b=NpOGY+ciHWGdVsAigZ7lCzgE/Q/ZbxTdyoLAAcPpn6pJGIJocwIaJzDV07eTTnkwKe
         cwN3abetdL39AeamFKmoFve9k6KpPSoDoFIeaoqEVzrwMsorYS0L1ioKkB5LH3Qh/nfs
         gfjj302fI0BhVDgQDrmAcRL5nj2DH3B+uD3O/S2fMO8dSGnmIKUJZDmRb31D8/O4jl88
         6Tn/Mimjq+7lCfr1O12S9gt/uQHKGU6SlFWujFPHKj0ytRH4B99T81aSDA/Ohez5K3Ax
         dPFoun6LbSTSAC/ftUoyvO8KU1ZbUKQn2Cm9xhLE+TGhA6yx/cwCct0j0KQrnNbDhcCy
         thWw==
X-Forwarded-Encrypted: i=1; AJvYcCWrxJUnxkH+TTO+J29sLyuUeDcT41BZJnlav81Po79U+kA1oFFiRN1UPTIe8usTWnAeI0q16M1bcCp6E8g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/C+SNM19N4KJ5Hb2ov5kf7ouEbe1R8xB1FTU9Rxdq1Q+TstKS
	+NSCnXViZE/Db6SgH8ehmEVB5rVXQFHl1ssPl5HCVq8Ech+DVMmmEZWK
X-Gm-Gg: ASbGncsmAWBBNq0d5hHlDXQDTttnaxoKvKEtQhS1OWSl1XTZRzhzPqbSFcx2EBeOV6t
	CEib6GLrqJr6s1UlNr5PFrgmT/hAcoLedcRodYYOSoapVhbR0lTBgjGzWSei971AvYTTdGqW9ks
	uUm/lJLtAgTiv0ovMuFELZDawXROChnFsviUxB8KEPXl/8d5bq8W8ZbGdqtFViPOQNorbpTz6sm
	68v6IQr0pPiWaZ/BugNhLzqtXMEE3w8BSYVrjDEhkJQSCKGNEWQdyVCM0D0JmBCz3BQnxKvtrjG
	JMuJ8+Ps9CGkNw2QYy/qMzILqocfbuTnE8imajJeMTE3xJhnlAVTE7d1AWT7k2K2p56dwW2ynPi
	z5prHdjRG9dG47aFkzMd/J+wj870MeWB6vzV8FRhw8MRJkihxmpYXP1RqzHjsiEGumcPKCJS6JL
	YH+CNVQEN3jskE6bXJRr1IMpf+oT98lcwFxUSF4nAU80HRL+/Qi5Ct6l6+avbXrNeSEg==
X-Google-Smtp-Source: AGHT+IHxDahYGwa5aI52HyW8cxdFR6RMIDSPOdl390+QQfG8ySHaxkFn6koa/YtHAqSa67lSItxZ9w==
X-Received: by 2002:a05:6000:2510:b0:42b:3a1b:f71a with SMTP id ffacd0b85a97d-42f79800f02mr3172811f8f.23.1764857598697;
        Thu, 04 Dec 2025 06:13:18 -0800 (PST)
Received: from ethan-tp.d.ethz.ch (2001-67c-10ec-5744-8000--626.net6.ethz.ch. [2001:67c:10ec:5744:8000::626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbfeae9sm3605808f8f.13.2025.12.04.06.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 06:13:18 -0800 (PST)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethan.w.s.graham@gmail.com,
	glider@google.com
Cc: andreyknvl@gmail.com,
	andy@kernel.org,
	andy.shevchenko@gmail.com,
	brauner@kernel.org,
	brendan.higgins@linux.dev,
	davem@davemloft.net,
	davidgow@google.com,
	dhowells@redhat.com,
	dvyukov@google.com,
	elver@google.com,
	herbert@gondor.apana.org.au,
	ignat@cloudflare.com,
	jack@suse.cz,
	jannh@google.com,
	johannes@sipsolutions.net,
	kasan-dev@googlegroups.com,
	kees@kernel.org,
	kunit-dev@googlegroups.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lukas@wunner.de,
	rmoar@google.com,
	shuah@kernel.org,
	sj@kernel.org,
	tarasmadan@google.com,
	Ethan Graham <ethangraham@google.com>
Subject: [PATCH 10/10] MAINTAINERS: add maintainer information for KFuzzTest
Date: Thu,  4 Dec 2025 15:12:49 +0100
Message-ID: <20251204141250.21114-11-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ethan Graham <ethangraham@google.com>

Add myself as maintainer and Alexander Potapenko as reviewer for
KFuzzTest.

Signed-off-by: Ethan Graham <ethangraham@google.com>
Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>
Acked-by: Alexander Potapenko <glider@google.com>

---
PR v3:
- Update MAINTAINERS to reflect the correct location of kfuzztest-bridge
  under tools/testing as pointed out by SeongJae Park.
---
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6dcfbd11efef..3ad357477f92 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13641,6 +13641,14 @@ F:	include/linux/kfifo.h
 F:	lib/kfifo.c
 F:	samples/kfifo/
 
+KFUZZTEST
+M:  Ethan Graham <ethan.w.s.graham@gmail.com>
+R:  Alexander Potapenko <glider@google.com>
+F:  include/linux/kfuzztest.h
+F:  lib/kfuzztest/
+F:  Documentation/dev-tools/kfuzztest.rst
+F:  tools/testing/kfuzztest-bridge/
+
 KGDB / KDB /debug_core
 M:	Jason Wessel <jason.wessel@windriver.com>
 M:	Daniel Thompson <danielt@kernel.org>
-- 
2.51.0

