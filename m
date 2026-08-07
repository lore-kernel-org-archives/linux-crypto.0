Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DB542882B
	for <linux-crypto@vger.kernel.org>; Fri,  7 Aug 2026 16:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786119726; cv=none; b=ojezsNHe11Uiw99pf3c1fYJYIl4IwfVcztEuHedrYW67515wUFMc+qcGIzkRBomhgVqtGpcO94gjNgCxnb8HuLlob2UGEoHDri5zThUK3xx707r3MuBVSxeJs+Pcq0xHt1hGL1TzkvyoRgrOivmwy0OsdOdfN2lFEuCiezgPrR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786119726; c=relaxed/simple;
	bh=teP7pgs23k88Y65Zu23zwXDC3A6Sy8Lk1+ga+1XpcD8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=qn1zTvcuHUSS5+tWe14gfvxQR63bAisTqF/0uzPsIijiBarJX9TFMbAUCONBDG3JVSWcd2izLeE/wfn76LuDf23hp3UWXXpbzP8Zl14xlbf2n+C3wJKaj1NNlCzJrl7rR4Svt/+ORl2zlHGQGL+X17h7YPfXxgKcFrbvlzu8QII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=COC138kt; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="COC138kt"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c15cb6f5c12so583049466b.0
        for <linux-crypto@vger.kernel.org>; Fri, 07 Aug 2026 09:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1786119723; x=1786724523; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h9HqpnV7RraA5YCdmhwSzTXcN/Huyip9SBv7EhjfAnU=;
        b=COC138ktjupUXTLEOsT0fcB4UNdXkcJRAbOeGemwNNm4kWPIKHMXaVWs2zdeznTDZ0
         Cv2WyPlbmtB8QV0+TAlCLFueR4oo/0AnaRhiYlkgPPgeRAurOjn8bdkji8B81jtusFbC
         8R/yumYEXGjupDxg9IRkZ3I5dLqDQjghIOGjA0G9d6gbLD9QPx4mz+8SHpbTKOJLmq8a
         y/9TUHNZnEdEs4K9M/PYZcuAsdxVSj7h3IqUqCEkYEILmG0+/Pe6JDBc/j0o4Tno9lHb
         tBDH2b3FmqWvCf9BKyaGCP3Lng4rDTlgO0YdVv88YG1p9gpkilJDu0cV+qs2mc3LL4uM
         v0AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786119723; x=1786724523;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=h9HqpnV7RraA5YCdmhwSzTXcN/Huyip9SBv7EhjfAnU=;
        b=kzXIKI57j3QUkkqWiqL8Njppx3QMfR2aoZ6XyW9wJc1Ufu+0G3hozS+Tzapb73N/ua
         2HDGMT+8VawnlKwyk51Sh6ooQ6cAYhTH4PkX5Bou8XrArc8AZJes1H4Gy4YdWfV43cmR
         Cv6xKpUM10jCE3H8Jt7l5HdpIZt7B8qhkmdf+hL6kt/iLr6CgC5WSj7plCtKgu6v81xu
         As9RA5GAGN7FKTVCKYaq8AYNebh07Fj8jCUvi7Qo7cWG490BYSAbCG8pkMJlzCpR1hSH
         N01/Qp4jjomS6tvRzNu8i5UH3HRrzfmjPKvUoEBmCBJUxvcgEpqoyzl6qXiTRJMHrlfZ
         Qd4w==
X-Forwarded-Encrypted: i=1; AHgh+Rq9Cu6/nYQT59J1YMm+7Rb4U4wafUGOwO7JofKOWSLBF5trHN7aCgoAwLmJK7SnDWTlgyeXSuLFxG9M8Pk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzwm77h8UpJ0IFkRqU9QQ+c27juN+NBoKst1IdXt1XS/xfbVeZI
	m6SRf78b1oTAqPAmHUevoI9FNGQnuk5CqZVgcO7SX6dMTNehKiKTnJ+R
X-Gm-Gg: AR+sD11iZ/ZPw9WVFOltt+rQ/XbrSYqExfaCAXcdN3U2HxPxykCstliFMVHjGTm0O5L
	CoYrxCx64mn6JPo232dVvXEnQM03MbRHETfdT0hCsoEsd+ZazLzr5GKs6BEfmspbTaiyh9SJZln
	/f4k2Mw/buJIzf/PbrAR/Zam3ny25xRgBhoyCi7RPRJJdVACXzr4lqV59WZVEdqLGL746Roe1J8
	ARqh0b1NPWXRfWVOVmSyPONo8q3JQNBWSoYUduQ4YI0zOTt/JXAD69EZllxXDldvXrRAt+MesDg
	gB048PWw/7FkutuszrCuhF7LbdpZ/nOBy8vhbF7QhbWCg2TYxVEYTiJ9x3C/5+TYeWCev0Gbq9x
	/4wuVjE5fU7316g1tP6ivzQcf4rtZVYkUSv77uXTJYn2vlvrTVF2Jsf27G3TKLdAt5awagKarYV
	rD/9FL8kOg8o7WP6fHOOOx9mWSq0FHQCwcKGEIrLFmxrZ7orGqMh4PWVkV64DNjmIVg2DH9YHNZ
	Vf6YjuZWMGug5xdelo=
X-Received: by 2002:a17:907:1b16:b0:c16:72ba:d352 with SMTP id a640c23a62f3a-c208761d3f6mr93206066b.31.1786119722466;
        Fri, 07 Aug 2026 09:22:02 -0700 (PDT)
Received: from david.gall (k10193.upc-k.chello.nl. [62.108.10.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2080cc3bdfsm69127066b.48.2026.08.07.09.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 09:22:02 -0700 (PDT)
Date: Fri, 7 Aug 2026 18:22:00 +0200
From: "David C.C.M. Gall" <david.ccm.gall@googlemail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 2/2] crypto: keembay - use crypto_memneq() to compare CCM
 AEAD tags
Message-ID: <anYGKPaCNBgACGqK@david.gall>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Use crypto_memneq() for constant-time comparison.

The CCM path in ocs-aes.c verifes the received authentication tag with
memcmp(), which returns early on the first mismatched byte. This leaks
valid-prefix length and allows for valid tag forgery which violates the
INT-CTXT guarantee of AEAD.

Assisted-by: gregkh_clanker_t1000
Signed-off-by: David C.C.M. Gall <david.ccm.gall@googlemail.com>
---
 drivers/crypto/intel/keembay/ocs-aes.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/keembay/ocs-aes.c b/drivers/crypto/intel/keembay/ocs-aes.c
index bb6f33f6b4d3..13ba7573617f 100644
--- a/drivers/crypto/intel/keembay/ocs-aes.c
+++ b/drivers/crypto/intel/keembay/ocs-aes.c
@@ -17,6 +17,7 @@
 
 #include <crypto/aes.h>
 #include <crypto/gcm.h>
+#include <crypto/utils.h>
 
 #include "ocs-aes.h"
 
@@ -1283,7 +1284,7 @@ static inline int ccm_compare_tag_to_yr(struct ocs_aes_dev *aes_dev,
 				 (i * sizeof(u32)));
 	}
 
-	return memcmp(tag, yr, tag_size_bytes) ? -EBADMSG : 0;
+	return crypto_memneq(tag, yr, tag_size_bytes) ? -EBADMSG : 0;
 }
 
 /**
-- 
2.43.0

