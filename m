Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6688213259
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 12:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744977745; cv=none; b=t82YzCkC5rU/5Aq9Bfa0xtchb0Y/X8KxG4XkLHHvhTO/YUNhTXC7CwRnKoRCq2OqBr44Cy8spCag93m8Nza/QegR7Hw7kM5WfWw6NBTksG1Um6Gl8KbUV+0oOsU2kOhvuArticnXIKX4Lzp+Uyv0dHBBg5GUvGGmkN7P4Nsldoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744977745; c=relaxed/simple;
	bh=okIH6WbPZVZPbyGI/bgYthp0N4LC7Kg0Jr4TKc+EL+I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fA9HSlP28340tlYpKu3hbyIp7y1k1JdkujA0ePUgHbMAOICSAOB0LvSfVRYjXyh/WSE8QJCxtGcoWlck5By+4fu0VVQ8AA9WsuxGIVuFtXXb5fHNvLosic2o5pV4wZ0Kd4TaB4xdN0JTsKDQQ1a5XPDRGHwIUDzZA5QAqpe67LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0x0f.com; spf=pass smtp.mailfrom=0x0f.com; dkim=pass (1024-bit key) header.d=0x0f.com header.i=@0x0f.com header.b=A1nb2Mcd; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0x0f.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0x0f.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=0x0f.com header.i=@0x0f.com header.b="A1nb2Mcd"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-73bb647eb23so1534744b3a.0
        for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 05:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=0x0f.com; s=google; t=1744977742; x=1745582542; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=w3kDTMjlwG5mlvODlNU3Vuna7nwkZQjPuFA/SSJxKpw=;
        b=A1nb2McdJMQv3fkm7dUNhUfglrWS5OwIJkLCEf6GkE5rFPQvgzBiIJ3JtQJTem1eMb
         61Bxw8UIYLYXvLBX2RN/+A/fUhL3lo1erBsDLaYfB7mLWNwcumvxraKiLImVvzEzD9fy
         ylQgMMG8DPcDudgfd2Km8pDwgbaMh5HXPhaqU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744977742; x=1745582542;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w3kDTMjlwG5mlvODlNU3Vuna7nwkZQjPuFA/SSJxKpw=;
        b=DCjIncYMePSNJVgHad9DvIMGncRhMmXRBHzt5bw2brvMuI73Z9NfSpF261aeghU2yl
         N1sqTKauRytswnaf15sWpEfWw7gJHMZq5j6l3j1aVyjv7wtcNcyjRgY5GBrcfSxwbYkE
         1V4ikyRuepAeE2nriIgKprxFMq/6a1HBds5akdjvAYbzcQjeF0FeDBRiZsHFk5T8oNiT
         AH5GzupjN9N0DgTfbtjB+AjpRpsew4nsdP4xTOXVNdXiZwpdQGoGGACYFVQsQb7pT7RC
         82xMr+aKtMZMoiDAn6Iki71KvR3wcDUZKykmmwb1K6wyWNLQzmCgI2juNHUyVW0hW44v
         7i1A==
X-Forwarded-Encrypted: i=1; AJvYcCUxBr6iCH1klTnEEqpbwkaIcLgcIkd7vXfMfx5CvNbog6KYMdnw6MCCkYYDYw7GX+5KpkdTHuTpdYjkyNY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtD3WQ1ptFMgz6eXA6YAc5zpzSP7AtNbT/Qmka7dGa+doH3eoz
	A4z6Vqtf+jXiAqRRniseMjWls0k+uS9DUgN5eQ9TwDzyJkS49xLNaNSui9YoKTE=
X-Gm-Gg: ASbGncub/xfpTIxWpoXi4urJK3f+gEvQqgQzyrJTaNIJaMvw8REH16Gz1atLp5Ca/1J
	2VwLC/hpgtkFgn9IF9Nh8txVixr3Qz0IZol0j+ZmU3eKVAWWLXbglrII9vZPlz8Rv9iEYPY1hy0
	cl5FzR80FpHs8CVQZepY9TdiL1o06qpMvcDfBMHJ8CyQVGGXX3xkM74kMQ3F/1BQezx++h/fG3r
	vKWm8HUBAvnFwGdRLuGUMAhKZvB4M+GAtagGS+OnugQyKQkOJIgK2o34TPlXP+1ZDfXcHLfZT0P
	E2SwfuVSp3cgcJw3C2mPuNHi/9XWb3cSbbt0mz3EnXOosUXsK1DhWQ==
X-Google-Smtp-Source: AGHT+IHMVfvcx7X/GlwdgGieimVGcGQRA/rOeqM8mfDwONUl8FjNrAWRK7izWxkk+tE3wNtHelkKcw==
X-Received: by 2002:a05:6a00:279f:b0:736:5438:ccc with SMTP id d2e1a72fcca58-73dc149d9ddmr2988086b3a.9.1744977741984;
        Fri, 18 Apr 2025 05:02:21 -0700 (PDT)
Received: from shiro.work.home.arpa. ([2400:4162:2428:2ffe:8f9a:ceb1:54c8:1717])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-73dbfa595e4sm1432887b3a.88.2025.04.18.05.02.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Apr 2025 05:02:21 -0700 (PDT)
From: Daniel Palmer <daniel@0x0f.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	Jason@zx2c4.com,
	linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Daniel Palmer <daniel@thingy.jp>
Subject: [PATCH] lib/crypto: blake2s: Disable self test if CONFIG_CRYPTO isn't enabled
Date: Fri, 18 Apr 2025 21:02:16 +0900
Message-ID: <20250418120216.2968994-1-daniel@0x0f.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Daniel Palmer <daniel@thingy.jp>

Currently CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is used to remove
the self test code. CONFIG_CRYPTO_MANAGER_DISABLE_TESTS depends on
CONFIG_CRYPTO so its impossible to disable the self test without
enabling CONFIG_CRYPTO.

If you don't want CONFIG_CRYPTO you probably don't want self tests
so remove the self tests in that case too.

Fixes: 66d7fb94e4ff ("crypto: blake2s - generic C library implementation and selftest")

Signed-off-by: Daniel Palmer <daniel@thingy.jp>
---
 lib/crypto/blake2s.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/crypto/blake2s.c b/lib/crypto/blake2s.c
index 71a316552cc5..89d54e462fb5 100644
--- a/lib/crypto/blake2s.c
+++ b/lib/crypto/blake2s.c
@@ -60,7 +60,8 @@ EXPORT_SYMBOL(blake2s_final);
 
 static int __init blake2s_mod_init(void)
 {
-	if (!IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS) &&
+	if (IS_ENABLED(CONFIG_CRYPTO) &&
+	    !IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS) &&
 	    WARN_ON(!blake2s_selftest()))
 		return -ENODEV;
 	return 0;
-- 
2.47.2

