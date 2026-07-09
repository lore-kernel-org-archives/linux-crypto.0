Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F98435EF1
	for <linux-crypto@vger.kernel.org>; Thu,  9 Jul 2026 17:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783616413; cv=none; b=l8QST9q+EvpulxxsqlfC+hcYsq1a3UeIpVtWyy2eqisSufHqrxfUymNGFVvl9PU4TrcHnsk8sv93na36KxRStZrrE/XEG40aywcmv7BGM19gMtid2//Y5yfVUTGVXzrVSEFd+BitpOR4BeSLT0b6ua8EafNN+dXkm0MYmneziOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783616413; c=relaxed/simple;
	bh=6qbdlzxZyZLMBPwj2Zmz1sZXp72LcZLMsWmZZfgKkIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NnZHJQaz5F7a7VOQhGRKVQcH6kL4hdFjaQyWeucbFsMu62TY5OaCSRUbboVb6HxUQwAWIAIfenvCw+MNXcHs21v3c8MYjz0cQdbky4Dn/zIWOnAIH6BCY5jGJJcPSHMyDCqPhkFQHI75f5qVCHnwPA+o+kWrtKVt8UCqPN1uGZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b=Z+qe3BId; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b="Z+qe3BId"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-47defd0c1c5so73379f8f.3
        for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2026 10:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre.com; s=google; t=1783616411; x=1784221211; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TaCMfmYh26EG6vWNYZX/3pfm5a0Em0kXW/5DfKVSZ90=;
        b=Z+qe3BIdziQ46ePikP/x6qwxhtGqi80I87BvWqVBaFu5wimX6jL14wnymyu9SDn9YC
         /3QeLSikKiVId5J7xAitKktTvRPEVJT+FhU4oQGoArcW8ygR95L2X3O7UZRoGVlgW+65
         NuSemvxPHqMDldoZo7crMthHahIX265hct9X6gT+tQduh0VZGqJxkMTXxJya3PUyEefp
         jw1U4NfrWzCLFhSE/+qnREIjtusm7mo5epwKjQfwE9eKT/p4Rvvz0G/PAbG2GPuX/96C
         4QmCWQB86Uy1lMl+1INr709yH8/SiwmDL65fjHQdyvPM+z2VMmToOz8kJnT9xe5BDw+q
         R5mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783616411; x=1784221211;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TaCMfmYh26EG6vWNYZX/3pfm5a0Em0kXW/5DfKVSZ90=;
        b=aQ8gu2neL4QXl98s6zpjC8qfxxtGWbhxg2yN5rgh9tH2s83cGs+j7SK3PAQrVtSylB
         ZvOBt6glC8GRWc06lJf7DeHhwslyxkoR97zqUFsZpMA3JmY9ZGDRk19GegEBkRaXBTe/
         6Y/juvdhDZUsy94Qfz7V4ant7Ra/ItVuflqGtUFqboGbwe+JVIkaYrZFcFVZUzgb+6uD
         +Kw8Wnz0g1IPpcMParNFILs0blHPQ4VcBbw7vmQ4LXKxWIYM/kKA9kxehlk6IGE4wADb
         s2FYNV/RImaABBYobDAx5wwz8eKj8+ws2oaAsUbZFJpOOQx/6P2EeNqqHsxiOyB5fYzy
         hs2Q==
X-Forwarded-Encrypted: i=1; AHgh+Rqe+aDSqPBGu4A4zS14NCX/Z2kkOGB6PaTdlJDYvvNICVgwlLREMNNXPs2yyunTKFnJZR9xZQJ8amrFENY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy23fM91bAomSH9i1lXwcUjGkSUS2SRMQDH+nh7pA1mNTYUs5gd
	mKNSVARchjS0wsQpdPYO33Ud9X0BJFGUVjTJp/6/q3rwDFr6A+DDgPkP6onLxAz58qo=
X-Gm-Gg: AfdE7ckyPT4GhGwoRx1CuD4Xdnyadw1P/svynuKbTVF0J8yYkOCxhJOPygSOfRthMDg
	RsQkjBNYvckx+18WRpPdV88G/5UjsjuKFeoJw07NTCxWuTPZXRE+cHeHleNcthj/BqeKz8GaqTy
	cDYFcuec8d5Wk4vBzVsZuqdhQMHbkh0C1UF/DyQlMonAtwJBScHx1ZKjuoWW+YYxUNvISdCjuox
	OPgXokJ30RH3Vg9R0WhN8t0aFOm8Vw97C+Lb8paM3mcJrt0kkoBqWAWFQB+QP4ZlBMozNnJmMZ/
	hFWY3MC8muR6TPYOyw+DEiF3t5Ekm69Tc2Z6YzdwtiU35qDLKISqI2Yy4FvKsX34kkzTgzwFhbC
	Pj8GaN7ecrImOSxKCu2PyCb7Iz/EfIiyZWdwJU4uOE87a8jkcuQY28wL0T00XIjrNKJK9sTi+7N
	QW4OVaL7PbzpoyEZ97Rg7DEPcrTSwRRU4C9a5vNcqWer19oIW7sBWWf7e7IMkk0331ndQCKo45v
	jb0
X-Received: by 2002:a5d:64cc:0:b0:473:d65d:49c1 with SMTP id ffacd0b85a97d-47df07ec87amr8676502f8f.32.1783616410760;
        Thu, 09 Jul 2026 10:00:10 -0700 (PDT)
Received: from localhost (p200300f65f47db043de98c19b374aa68.dip0.t-ipconnect.de. [2003:f6:5f47:db04:3de9:8c19:b374:aa68])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-47aa0960816sm50766585f8f.29.2026.07.09.10.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 10:00:09 -0700 (PDT)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>
To: Lee Jones <lee@kernel.org>
Cc: Qunqin Zhao <zhaoqunqin@loongson.cn>,
	linux-crypto@vger.kernel.org,
	mfd@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 07/23] mfd: loongson-se: Drop unused assignment of acpi_device_id driver data
Date: Thu,  9 Jul 2026 18:58:26 +0200
Message-ID:  <8eedf9c9d52ac6a6924655218cd65b4021ce90da.1783615311.git.u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.55.0.11.g153666a7d9bb
In-Reply-To: <cover.1783615311.git.u.kleine-koenig@baylibre.com>
References: <cover.1783615311.git.u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=884; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=6qbdlzxZyZLMBPwj2Zmz1sZXp72LcZLMsWmZZfgKkIw=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBqT9NCqbo1sjMKTHDdATw2XxwlRegBmMB56r07F YiV9ecB2ryJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCak/TQgAKCRCPgPtYfRL+ TrylB/0YihHTDoWV53qiQX8QgrMZUV7ShYrYeFCTLpS5MVZHwa0Eolj9V0tqDgHwaVItR2eICj1 8965JJT4akpJFKb3j4W1qsvWrnnd4K1hlcF3khlekv9sxshEYDxuL1UsTUVfa3QERdMUATtTA4P cEoTO3rhBC770zXpY2pMbZCd2Tg4AinlsfvbTDR8k4x0KZbTD/U7ThJ5IBu8tZzOGoH4uxbB3YC BWL02vf7d2eLnrqa7WgBWHXuaJa1DU/KIpbV/MZyoSVZIXIXwYgLq/TMDeNSdeLuIruOASwfsIc Iqls5A/oLorr35m6UYJSS3ttjDvWhgqUecJSlt3lbl8guQLP
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

The driver explicitly set the .driver_data member of struct
acpi_device_id to zero without relying on that value. Drop this unused
assignment.

This patch doesn't modify the compiled array, only its representation in
source form benefits.

Signed-off-by: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
---
 drivers/mfd/loongson-se.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
index 3902ba377d69..4c668e2d2241 100644
--- a/drivers/mfd/loongson-se.c
+++ b/drivers/mfd/loongson-se.c
@@ -233,7 +233,7 @@ static int loongson_se_probe(struct platform_device *pdev)
 }
 
 static const struct acpi_device_id loongson_se_acpi_match[] = {
-	{ "LOON0011", 0 },
+	{ "LOON0011" },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, loongson_se_acpi_match);
-- 
2.55.0.11.g153666a7d9bb

