Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793792487;
	b=IN5WyiqLx3oxZcAEbpSYq8/CRIoxS5r5/1G5w1v0cGcF9XDckDxEVaG9KHGAGBn4BS4l
	 +hZ9xEgokHQ+bANlRSfr8RT+l9TA2c8aCNqDiFVpcSvccplNESZUTdEXKhCvfnSBjMN0e
	 i6JyfvTLkc4DsFT2dDfh+lA1oKlRiQ7RoGWAq9mWlb+Jm/NEdEO1K3vy+W/nAj9ANzHfo
	 J1sdCz54JST4t2lK1tqRJZhXJHbJLyuVyyOt+VHQ9o9m6a5wFHrz++EDEQEHr6HHYrcFi
	 iD0sYgUzjYO0l+6zg4EC3S8fbJ18kfP2A7uEEWxIpyWrgndT5/iAadylWf2kQLxIsUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793792487;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=8kizTq969MMG4ZmGsWzf/eUqjfpKRrKiIja6oeumpC0=;
	b=CBNCcuu0Ukl5xDl5Qs6Drf0msKkKNSV/Mk3shGGz9M+8bxqw6Hn3eYRNUl9E9gjILfQt
	 n0k9bGu05ul8TLo4rd/Csyn/gwuAvEdAjE9FSsgQ06t6Nn+/O+KEil1Spl5aOFJVVEJEB
	 N1SDlxme9YyHvivde2ZHlge9jEHsfbhoUO0kPbJwgC11q2n8rB+xPqSvutb5rooq9PkJq
	 3b4d7dFWApjApxNdn2sUlxB3l6Q85AcMgQZL2iT0HqNxHULkXuC57Men67wdOI9BIguB/
	 GU+gBteAOkByiy26ZBWIP2fApUm8nemOKQiHAIcqZPrYBv8mzz0rH4HZu7fXm5JWpPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=p11Jkqj4;
	arc=none smtp.remote-ip=209.85.214.172
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B56606A329
	for <linux-crypto@vger.kernel.org>; Wed,  4 Nov 2026 11:41:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B5B56606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=p11Jkqj4
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2e987b4a710so9376775ad.1
        for <linux-crypto@vger.kernel.org>; Wed, 04 Nov 2026 03:41:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793792486; x=1794397286; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8kizTq969MMG4ZmGsWzf/eUqjfpKRrKiIja6oeumpC0=;
        b=p11Jkqj4WY8LyHttPdwO37K2LXKgvg6/RHTsJHDKF7/dp4c2eDnOYhQCb0cnfV/L3T
         z1ytXlQopIrHnAW5tc7tCduqoW3Ul5NS9xQAl4+xfDb/DVsj9rTTzPVRQlX/mOFMFWcT
         /p3KxWmz+b0BwdIXW3Z36OKlkail1/p+RXXsqQryQQ1a6pFG5743ZD8YL12xQZ1p+OEj
         IgjS9H82I3ijNVQF7nLRzTRqxh5DJpwllM+emkL3rr1BC4hZdA3DToKsjv/4rJA1iyIp
         B6UsxhgF6S7xEsjW7fnEwLUihFAN2mtouySLsavF3hn9rCMbtRDqMo4vU0K6wtLXIpB0
         Ba5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793792486; x=1794397286;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8kizTq969MMG4ZmGsWzf/eUqjfpKRrKiIja6oeumpC0=;
        b=rwR0WRDSgU4+jGxrLmK2jKDQlkyzQdsDj/wWvwZ4lKx4NhenW1S8mZ3nGiNBUQkJ4h
         Tojqw+tfM4bh+Qn2FIqz6Apqd2eo6sBoT68DTK2s51NMoVXwFuBSmE655+szTRVW3QfA
         w4zY6GsNhpa4EN6Lv/WNyVIMGMLmhwQVQb7gv4S5Pd6SXtntfRN8AjwyESV2hZAyu2CS
         fq22vfVemxd4sKsmNRpZ+Kp6Ed76olRTQagtnNA5Jh4csNP10cMm2yLu6vau9mlqfHux
         L5tDE94SJHq7GxnHS2MJy/S1SFLlWo6WViBgL00S8T/OuufCuS7nqsOMOLP2tUtyun1U
         60Rg==
X-Gm-Message-State: APuU4Z8cpbWoa/VHuS2TRZeK400ovt8UCrF/GA2Mv09pvONuBqEvuS0x
	fsFTsuiumN7MD754Gdr9JumcRXrBXNdwjn4hvUWyEaCFx24RawuKKgMdYCTLFw==
X-Gm-Gg: AYBFou2oPF2k9sldMurQyLaVp1E5QszU++Uvi+dObCTHYDhMa8MzG9TUDapxm/EU6MI
	NfM17ku1CNWc+iD7czLDaFh/wZs3iKFKSpB7ORt1zXDgoHsqmeBq2ZvyJGYhlT6WbpWq7+0ZW8u
	p3JFmPIR3EQi3mY3cyyPV3kcXSG1+xDr2I9LVdnRgT3rtmVijv4J2lF1cJiFH0g06amCuQnFUa7
	WfNC/45sqDJOJM2nbOTTIb8bw2f9qmQCtggBtpSy3CAiuyVDcwd+dJUovrBxkZeHWOQxiscepCJ
	TUsNeLjMXdtrzANpPSXmlxvrtmZQlzvpiuYeeyKR2cYN1wAjykmfdxyWVtGznGRUJEH8Yq2j1Ss
	V06YCRaQ1dkLs6hVlwHR7WEJdLRqTWcyTHYAAM4UwRc7svjy0P8r2MwOsutGIjXdTAVCrxjwIXW
	2vKIqyD42FgMGQ/fEH4Q1gtj6oHMYVlS/YcZZbP87MSi3v8P7eURM+TTWcFekZ3JaY5pogXxBeD
	zt5lpRUHdzWQITZ4AluzDH1NdSZe6sWQXNkRq/0soOJN8cM/ZLltDeZbTHXR6ilsueLBNqpsY1r
	723Z3k7IUeKn0JZkaulami0eraSv1yQOoRz3EoHz66eSfBq6jOGw
X-Received: by 2002:a17:90a:d610:b0:3a0:cca0:4a8c with SMTP id 98e67ed59e1d1-3ae896d7b4fmr8102111a91.7.1793792485919;
        Wed, 04 Nov 2026 03:41:25 -0800 (PST)
Received: from d.home.yangfl.dn42 ([2a09:bac1:7680:28::4:396])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b093d481a3sm3770036a91.1.2026.11.04.03.41.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 03:41:25 -0800 (PST)
From: David Yang <mmyangfl@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: David Yang <mmyangfl@gmail.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] hwrng: histb - use device messages
Date: Wed,  4 Nov 2026 19:41:05 +0800
Message-ID: <20261104114108.2378751-3-mmyangfl@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261104114108.2378751-1-mmyangfl@gmail.com>
References: <20261104114108.2378751-1-mmyangfl@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pr_*() prints without saying which device the message came from. Print
with dev_*() instead and adjust error messages.

Signed-off-by: David Yang <mmyangfl@gmail.com>
---
 drivers/char/hw_random/histb-rng.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/histb-rng.c b/drivers/char/hw_random/histb-rng.c
index d435d4ab9aa7..d28cc84e8367 100644
--- a/drivers/char/hw_random/histb-rng.c
+++ b/drivers/char/hw_random/histb-rng.c
@@ -22,6 +22,7 @@
 
 struct histb_rng_priv {
 	struct hwrng rng;
+	struct device *dev;
 	void __iomem *base;
 };
 
@@ -71,8 +72,9 @@ static int histb_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 			if (!wait)
 				return i;
 			if (histb_rng_wait(base)) {
-				pr_err("failed to generate random number, generated %d\n",
-				       i);
+				dev_err(priv->dev,
+					"RNG timeout, generated %d of %zu bytes\n",
+					i, max);
 				return i ? i : -ETIMEDOUT;
 			}
 		}
@@ -142,6 +144,7 @@ static int histb_rng_probe(struct platform_device *pdev)
 	}
 
 	priv->base = base;
+	priv->dev = dev;
 	priv->rng.name = pdev->name;
 	priv->rng.read = histb_rng_read;
 	ret = devm_hwrng_register(dev, &priv->rng);
-- 
2.53.0

