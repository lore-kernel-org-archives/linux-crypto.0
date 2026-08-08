Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1E729BD87
	for <linux-crypto@vger.kernel.org>; Sat,  8 Aug 2026 11:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786189812; cv=none; b=Qf7ngCqN8YTJvcFvnsJUb+8wL7dbiAqwYsSHH9Z4VCOy6++5rEL3aSMJUhF0HU+LwisTJRiBa28J68YlHRCQw7in++a8X+Vm09TgnaMHHEoaAeEGBmf+o8vrSH1daQoo5qILEAlj5XTi11OVSDZs/cewHPABnN5ytMGXBTO/IHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786189812; c=relaxed/simple;
	bh=tA28uoe9/JaeFzrkRmsJq0oKqgIaYOAI9C6nJZU2+3Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=a1QlxAae9II/Xq64Dq/ZQVOjpnVr6pMJ0bXIgjpV4JBP038/NsoDy/xf0bSicdn1K/Q7fNyf1cfXUSt3A7NLls/Js3SFwS7Gcp+FYe1MbsywDdFlxBdN4DaVx37NP34o8/BioKhPqLW5PVcqTCu6zTI20lSl4XNujx3tFHD0N/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mfz6jVGE; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mfz6jVGE"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4980dc26022so3592355e9.1
        for <linux-crypto@vger.kernel.org>; Sat, 08 Aug 2026 04:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786189809; x=1786794609; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DW2tDdMOslx4M3knW21+tMviVsy6n6Zzbi+lL0TdSvQ=;
        b=mfz6jVGEFC2BwHSA/SvpoZrO3KZnuNJSUDuLJrl2+mSOyDDqqx/pIcbPit7V1NVD1i
         qYwvwNKIL9/cHTIjTN1hzDE5eVvB2V/IBD5NHXPhbitevvUTAkoO+tXGaDDNQi/OEO3m
         dN5hJDoJxpVnlLojpdkzAdkaEK79kGaXs/Op0AUf6yBe7RsTETV1+vWuSnFtGtLHXbOJ
         NuaCuMTvfYHq4AJiDoRrDoAbAAO6pbri4llZx5VWoOJzzRGfatbq4tb3IHFjivkTV7sz
         EaXqQ8EFAkbTHBNsUfDJDTng7Gk7m52wrHtvWpPAghmz/jC/Vns3KD65e+AFgUyoVV+f
         Zh6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786189809; x=1786794609;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DW2tDdMOslx4M3knW21+tMviVsy6n6Zzbi+lL0TdSvQ=;
        b=KdAnQcisNvn1aGmP55IkD+0AvcDufyr/hmXaXy0S0BadoYUiS5WVGXtjgtn00bCefc
         E2tX308Bf1nrowXumbS838Ca5ithAs6zGAy2i8jy+FDqnRcIL+xjie2CrOLJWI2S34wi
         2CXavSe6SO3ujuIqkhzc6XRbN2EGRkXo4HewQNdWqgyW0YZ18swwZEaSzFaizO8no327
         Rs4LXpC3/P06g/iWg8pZxxDCRbSzWnnWA0oh8CO3HZVhyJzMmjq2VIzYRFJA0BCi5jXJ
         C1WESs2PC3dp2mGke1XO5OLOsFBmbeWWq23Mt65GMlIiEzQRNM3aCIZEjO6Z09JobRaV
         VwiQ==
X-Forwarded-Encrypted: i=1; AHgh+RpGYEEAGxJA/k+wYK7mp2MrXVxvtTysBcg8AE7ZLBe/zTNieSx6ybwIhbDpUcUnt0JqLUMrLhoqWwzpHVo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+ib57XO+Iw5Hw/E9kAZHbmdUWKNiEMau4RbiYbBWAlAHyPEsZ
	2odQHkaaBtbWZfagi4QGVO70/tadD7JWRwy5FFVN3MrP4ZHvwFrJ7vMe
X-Gm-Gg: AR+sD12n6skf4SBd669xjHQBTr5Tvvc+f2PnUvijnh/mB+J+zQ5HSuTIvCHwmsOC1hx
	wElls2m4H9AsQwSwTW4n3+JEpDoRIdSiukgVs5/6HGHh1rWZdJr06wH7KXjFLeWeDqvrMYCmkqS
	1gMuUUiu/FDjkjQdwoDNz7+s/pfYR2jm1O3+BvVMBStW4Yi8MtJsfYoTKA81BiO8XFzLzn55xG/
	DQse1g+sgqajGmmp5+0vtRcJuoTp4eavXnY+HAxjZlEGy4m+pLFuDmcA4EikxyH2wogvwQ53XTa
	ohU6NsDbINfypP8h0XuF8tvrSGbCuBGMJrrz65GYmbjsv0e+4l50zTe3bI3qly7m6l6npD1R9iT
	DwRJXVT9y5U7cdM+rfzMkOe3A/9HOaK9k0bhcTgdFTYD6RAatJau0a22J+GmtDXYjmPwZ2iKLCE
	6GsKSL2XwBAg5X6PDJ4TtfJw0at5NP1IeSq7rX/0vv3gOvrusaUnB2dvEPaLsDQJc/3jnpdzj0p
	t07CvkAn6tG4jhh7NFKIV6iU5r6HoUD5zwfXJbxOQ1wTAi0vruKeYbR7pFfbf/an7AcISj6We/c
	dfeAxWGNECVOUQGb/PW5
X-Received: by 2002:a05:600c:5251:b0:499:5b04:6920 with SMTP id 5b1f17b1804b1-4995b04695bmr156555135e9.16.1786189808989;
        Sat, 08 Aug 2026 04:50:08 -0700 (PDT)
Received: from localhost.localdomain (dynamic-077-007-004-134.77.7.pool.telefonica.de. [77.7.4.134])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499542183b2sm241866935e9.4.2026.08.08.04.50.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 08 Aug 2026 04:50:08 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: lskcipher - propagate errors from unaligned crypt
Date: Sat,  8 Aug 2026 13:48:48 +0200
Message-Id: <20260808114848.71342-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The while loop declares a second err variable that shadows the outer
one. When the crypt callback fails, the goto out path returns the outer
err, which still holds the -ENOMEM value assigned before the successful
allocation check. The real error from the cipher is discarded and the
caller sees -ENOMEM instead.

Drop the inner declaration so the callback error reaches the caller.

Verified with a test module that registers an lskcipher whose encrypt
callback fails with -EIO and calls it through a misaligned buffer.
An unpatched kernel returns -ENOMEM, a patched kernel returns -EIO.

Found with Clang's -Wshadow.

Fixes: 31865c4c4db2b ("crypto: skcipher - Add lskcipher")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 crypto/lskcipher.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/crypto/lskcipher.c b/crypto/lskcipher.c
index e4328df6e26c0..a79c9a246e5d7 100644
--- a/crypto/lskcipher.c
+++ b/crypto/lskcipher.c
@@ -95,7 +95,6 @@ static int crypto_lskcipher_crypt_unaligned(
 
 	while (len >= bs) {
 		unsigned chunk = min((unsigned)PAGE_SIZE, len);
-		int err;
 
 		if (chunk > cs)
 			chunk &= ~(cs - 1);
-- 
2.53.0

