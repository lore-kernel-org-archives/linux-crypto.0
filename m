Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB0522B5BE;
	Tue, 10 Dec 2024 06:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733811778; cv=none; b=XYUTmGQY0ZITNb5mKXuWKiZ+T9bNtVtvV+wEeDePQVXOB5u150M1YHl/RJUryvJ11V993/vz2zzUBzOCqVYE7PVl2PWE2da/Xq167cLtMwp/NRRx4FY/Y9hNVugJAdLNlmaCpt/qOWcoBdt+vWFummhOdVWF4ovlUfpTp7eKyb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733811778; c=relaxed/simple;
	bh=A2JGInYK6VoTSod8bXikhS00VQVpg9qqwRSBD0DrY8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FSpAFo8IlATRuurX9OM9J1jWXTitA/EYYTAthhcdDX/ACxL6kGWaTJPCUl3uam229WfNI2KMj/gyXV7H4ZPW7RS5d+Q5rXmmI7SjfynMh9kBYb3Kb8zhsuuDWHq0mJABP3UEi7CcfzJnA2BmdNrdE/kTAqfgL79FA99x22Ze0J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b5zfzZka; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b5zfzZka"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2163bd70069so21041795ad.0;
        Mon, 09 Dec 2024 22:22:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733811776; x=1734416576; darn=vger.kernel.org;
        h=content-transfer-encoding:signed-off-by:mime-version:message-id
         :date:subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ktpI8nQhkljY3um5OXLz3jmJOJS/HUeI5zH/9t+BjHA=;
        b=b5zfzZka5+j0kL82Rq1HkvtGWOPi2otA5jy5xBsf5xnZUsEVyXsjX04e3IgE56sKR6
         pyyg5Fp0pAYhKLWlPCbpW/pM70shBK+Ieso1uI37taGgJSlV0VBa4alniYdegmzGpdDp
         WMF1x+ZLsvZBIbNFpnV2ZbtlOmnN6UT1Yi8F1IyFL6M6ggDSQ2GhFXUQWq8uunGFNFCo
         VLQxsK3fj+KjqFKjc6dev7/t8x0LC3DvmpllBOJpb3MHEdrTtYA0rft6aXoVW5kOumvw
         mDe2Ca8DgVIwwuRQKMUcJuErg3hQfiXXo5DN1cE56ufXI+BVz+HrvPAEExRjmuy8Dko2
         J1tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733811776; x=1734416576;
        h=content-transfer-encoding:signed-off-by:mime-version:message-id
         :date:subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ktpI8nQhkljY3um5OXLz3jmJOJS/HUeI5zH/9t+BjHA=;
        b=pcwPFEBz2unfgS9Xf7ZAhXt+diYDAtJSGmMNGma1KsR84qbxSuWsO2VWH0XCQXjgdd
         DIapHVqe7SZqjalzZljZBCx09rx85VihgLDXVaLNDaRdxrA5Wk7/3/SIQ6FCp87zmUmY
         8/8TExjxyzfTOQZoCNi0BErk9MY85KBqb+ehAM36nvXMDyU2wSPqOZwFtzyBK4LPir32
         fAOtbZLD+oK2GJ2Q74PZiPwM7VGUNRqHL9DqYekWi+0/3940XidEKfJpddOwFvI4gek4
         nmuBBpbV9Rkccy38L7MGLofSMsBnFxUXYXRgAMqgfEc8GFtHwEB0DFXVEYLOwkEfL6UE
         e9OA==
X-Forwarded-Encrypted: i=1; AJvYcCVJj/4kThPvX4cCRSOrCJ3pzywAuWf9UAiK6WJ/uvelrGuPa0yaRQ+jMi9nmAmBm4U20x+ry1OFil4k47bb@vger.kernel.org, AJvYcCWYZutgQNoKhYAM8GqmiMEDh/7cEOfOY3gIvPBBN6IyO8QB9ny1HLPyMZuHqXa1rEF3e6JIqwkHz+yN/10=@vger.kernel.org
X-Gm-Message-State: AOJu0YynC1X50EeECIuenWOMgFHympzjfmeJqcGCnoDJrY2Q761yJ9L0
	r8nVeLXRp7y7QW5RTD9BCQpW9tCHzbrRfL+3uS2Z27PuxVCa2H2zTSeqhA==
X-Gm-Gg: ASbGncvYtUAPrC8k/KRnPqX0EZxAJbIbP95xqtxBf+LC0oxiOk4LwnjguMyuSCHgESW
	iP6CizRGiqbnN04JVYbvS0QrqyPvFdtu/WozH08seNBH+MahUxMu6YtnnTX/x3Ovap1hpmHoGXJ
	t8IB64fdqYskqBQuQAOWL2uxKpMbvCdIegGAqqLNoEdDDaVTwyuXY0JOtRk0ihKodpkx7cKi8Jf
	XJp15ghgprJm3igBNSAVkk1E3/T+BUkG51Ry0KAePrGBcaJHnZa7fT7D50WaaMW4cHexQ==
X-Google-Smtp-Source: AGHT+IGBzXN4c5J6Rxn5zfv9OU5nTYNomwk+ZGkvm6OKz8lD9trxo4nF5I41ffpNVlMQs+jxqCx3Ng==
X-Received: by 2002:a17:903:2445:b0:216:4e9f:4ed4 with SMTP id d9443c01a7336-2166a0777dfmr56056425ad.36.1733811776240;
        Mon, 09 Dec 2024 22:22:56 -0800 (PST)
Received: from kernel-VirtualBox.. ([2401:4900:8899:46e4:646:c8ea:ef7d:d291])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2163d9f8fdasm36506595ad.186.2024.12.09.22.22.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2024 22:22:55 -0800 (PST)
From: Atharva Tiwari <evepolonium@gmail.com>
To: 
Cc: evepolonium@gmail.com,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] FIPS kernels should default to fips mode
Date: Tue, 10 Dec 2024 11:52:40 +0530
Message-ID: <20241210062244.2357-1-evepolonium@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Signed-off-by: Atharva Tiwari <evepolonium@gmail.com>
Content-Transfer-Encoding: 8bit

diff --git a/crypto/fips.c b/crypto/fips.c
index 8a784018ebfc..d7bd7e0ac2cb 100644
--- a/crypto/fips.c
+++ b/crypto/fips.c
@@ -14,7 +14,8 @@
 #include <linux/notifier.h>
 #include <generated/utsrelease.h>
 
-int fips_enabled;
+int fips_enabled = 1;
+/* LP: #2049082 UBUNTU: SAUCE: FIPS kernels default to FIPS mode */
 EXPORT_SYMBOL_GPL(fips_enabled);
 
 ATOMIC_NOTIFIER_HEAD(fips_fail_notif_chain);
-- 
2.43.0

