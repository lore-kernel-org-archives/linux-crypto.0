Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DF5214A94;
	Mon, 21 Jul 2025 23:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753139963; cv=none; b=lfMDIwNT5mt+2o9qMTppVtgzHNQQiqlsSdIxNOl8BHt9s8jR5Et8MvGgCIzEtz5Zi6diEdFWx+2xiol2XAudFLGKkp/1K2cgKeAtiitomHgO9Ih+K8Fr4RVkMnMM3NTpwAMHriBmrb8V6I0O1pQPvi2x1aXlhP2A3SdHXsAV3yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753139963; c=relaxed/simple;
	bh=lezQi1k+1mpTOGrJ43c4N3gnRslx6NldCBA6TmJOAXc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CSBNfKMM8ccKSMu5n1UZHaHy3OhEYWIbfOgKXvDXBMHMtbEIRNKbYJ+UpS3EFH5D4cuXRY8lw8lXr+IDygf8mm3HqYwZpS7rAfWq9GxZy2/W8SqmyAsyo6IR3ZiDo6NS6qiDn1Sx6j7Xybh3Roco9fwFek+Gq0WIydGd8IYgRno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IpVc9SUs; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IpVc9SUs"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3135f3511bcso4015754a91.0;
        Mon, 21 Jul 2025 16:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753139961; x=1753744761; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=DYvIShMZulFsLiSTHIbcOXBpb1uFyozfa8TG0NjdF58=;
        b=IpVc9SUsx9eE5JdES5PP3efoL0qPTVdb1i28DjXSgYLc0FT+MYSI47H7lVDE7TgI4a
         bMwSQhflGal0B99TvdK1Xttu73gMnPzu/8McIDEPeiuSJ29exXZJK6qds/gTB3KdoOfn
         QuhobpXylPsbXf8nV2pFTCroO6h8z9ySTMf024rkuJ5WCh+x3EOMVsYh5ETQudoTteVJ
         imdtAaAjrUfR9djgGIW3YCCJijPaBbd8HDxBpuMH+TZqsSjaOiSCyC2N9wEe6MidNCgT
         GnFmP8h+l67EivCpotRzO2Y6NDv5A+9kBgi9+rdsOym1MK8XXPHg51nUxuao0IqqobLs
         idBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753139961; x=1753744761;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DYvIShMZulFsLiSTHIbcOXBpb1uFyozfa8TG0NjdF58=;
        b=N/D1Bg5xP00TGMNYH7FtbLrraSmTnz/OxTIuQR6Ceo8XCUbMFWP2BHwPCle34KTVIb
         4GQKZ2Ks4D2pXLOiJ+y5oM/Ci/YJdO2tJdJr1/IEELyTIAZlaonlmMW4KudQoamSXqFu
         OQjlrGCVIq5a/rvQGRnRvdScKXB1SqalusbeNSdtX+wDnQlXPdZmr4zUGaG5Ai+2NB/X
         r5G56/9hoHLXok0z7zfLo6GM1BBrY21jzeDM3FIXSZaeMW2NjtddYMxAusaS8aoclb1e
         BRGaKE9h08i+UxEISJHByV5hVxmIKyVWM6gN4Dm64YBac2ENUJYKOHKUTWmfExyk6VUY
         PHMQ==
X-Forwarded-Encrypted: i=1; AJvYcCUw+bTJD28Wm/u9xCEwTzJJsVHnNDpe7OPN1AoBanVoAaDgw5jYfMlTniJ58RQ7dA56A9CNPgN/JdcsIZ4=@vger.kernel.org, AJvYcCVdfy480L1U457LEbUZxLXX6fkD1n8jgMu5HR2dVTX+YWIaTsBLjok0NpKR1fkGjgASZ8jbTK3bi1UxQCtP@vger.kernel.org
X-Gm-Message-State: AOJu0YzjuWns4qP004UFWjN/HbQjp8gNmJAhty4uvfvXkdpPutJyS8Gh
	FFr+pNbpdkJSm7/5OOugiNylHMKkYs8SKW6a4wOQRSkp/j8YwT5OJn5+ThIFeg==
X-Gm-Gg: ASbGncsfUaVboLpbQGGH5vU8FSknRqfw7u5y8OOKiiYqf9EPB0q4VXNVjFErLheiUOT
	jSqjwIID7fa7kHK7wbNxTHrU2wH7Y0HPAvVTHJYZ+1TaawonRdpNCFq30WhGbXeAnGzoKl0njS4
	D9rVsaUr6JQeoeo+ihqXNdhyhZw0WV3APc9MUvOVVt0PdBArnsEyULUqjTZWCp17882o2XfOf+E
	gB1GSJeKhXrhaFDY2pBts6pwtp5e/sHr4yezoIxM01bhHE6kWOHyk8JlsciF1RKd08HpEBkc7UP
	s6qIeWqhlpOpuiSetypT6vEXTkm1wPl1wYrrswpuerFogRrgiRwhnGxMNcPCKQD4Zr0PEeeZMK7
	wBzUzyTKLR0qF0nfWMbgaWrWI+TkAgRApj2E=
X-Google-Smtp-Source: AGHT+IF4oBJjXwBetRC9DIULCTaiizUGlqBTXFwaVHEklLzIO8ar+HqanxfnbzL+0UdIURo2BjzSfQ==
X-Received: by 2002:a17:90b:4985:b0:312:25dd:1c99 with SMTP id 98e67ed59e1d1-31c9f45e1d0mr30807142a91.19.1753139961132;
        Mon, 21 Jul 2025 16:19:21 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31cc3f474a0sm6604914a91.44.2025.07.21.16.19.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 16:19:20 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
From: Guenter Roeck <linux@roeck-us.net>
To: Eric Biggers <ebiggers@kernel.org>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] lib/crypto: tests: Annotate worker to be on stack
Date: Mon, 21 Jul 2025 16:19:17 -0700
Message-ID: <20250721231917.3182029-1-linux@roeck-us.net>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The following warning traceback is seen if object debugging is enabled
with the new crypto test code.

ODEBUG: object 9000000106237c50 is on stack 9000000106234000, but NOT annotated.
------------[ cut here ]------------
WARNING: lib/debugobjects.c:655 at lookup_object_or_alloc.part.0+0x19c/0x1f4, CPU#0: kunit_try_catch/468
...

This also results in a boot stall when running the code in qemu:loongarch.

Initializing the worker with INIT_WORK_ONSTACK() fixes the problem.

Cc: Eric Biggers <ebiggers@kernel.org>
Fixes: 950a81224e8b ("lib/crypto: tests: Add hash-test-template.h and gen-hash-testvecs.py")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 lib/crypto/tests/hash-test-template.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/crypto/tests/hash-test-template.h b/lib/crypto/tests/hash-test-template.h
index ffee1741a1b3..f437a0a9ac6c 100644
--- a/lib/crypto/tests/hash-test-template.h
+++ b/lib/crypto/tests/hash-test-template.h
@@ -398,7 +398,7 @@ static void run_irq_test(struct kunit *test, bool (*func)(void *),
 	 */
 	hrtimer_setup_on_stack(&state.timer, hash_irq_test_timer_func,
 			       CLOCK_MONOTONIC, HRTIMER_MODE_REL_HARD);
-	INIT_WORK(&state.bh_work, hash_irq_test_bh_work_func);
+	INIT_WORK_ONSTACK(&state.bh_work, hash_irq_test_bh_work_func);
 
 	/* Run for up to max_iterations or 1 second, whichever comes first. */
 	end_jiffies = jiffies + HZ;
-- 
2.45.2

