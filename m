Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795898905;
	b=wf8VV9SdHFCW23j2UckWaKIXhTkXWko9pqRJT8KZGT3G5Lq0bNMimE+dCyFhEgGahVTU
	 Md8/Avf0XpGbv5+rpvRKlleBumwkpdhs5Ty+U6885U/xu70tl6ASDzH4XR4DP3ehjk3P0
	 4Hv55893Ieta4mktbrOr0UNSOBj9YpXMMqZf32w8+Ia43OYqoiQ7+azbcAdkM9DBSc68l
	 p08/GmI8aCcH+v9mAkdNCqXUp1d2d+zZMJ0vo7YZaU2SsZ0W2e5QE8qjOeWtRe6iMDJ0o
	 tGYO8oO07NJGD8R9tdeSLqze+1+nB1syqjSaiJ4uWjd4yEd1ImK2jHNf5eJFWHgSNiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795898905;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YEIOmdONe37RhIWuru5PWrPcaCmyPrb3JXUJ+Va48sg=;
	b=yBvPVhplDTyuyZzLBZQ9+Hozrzr//SP/HsQ651NtQkeJy8pXgB6OU5zh7+Nw8MRFVQPM
	 ZZonCfmJUf8BvLgR5yAFHEm7OWACjghPeDkV40paFilHENt8xVti0s6GxBL6TfizorXU/
	 m3D1Ik2xJCmo57coxfJdlQAzlasu5pU4eksNMJlx3ILG6pVuaOeEp6DwN+i8d4LWUTwMe
	 T+EOdRxYMxdfewLD5B8wB3x0nbzr6WEbCzfetlHSFr7quvgdeIvUnUlGPQSfK3s+6ay19
	 0zfqCuYGPN2oaIZkuZSjordphp13Wh6f/2kc3hhcR7ZIpjRSp2e44wMK5cpruWw/Cag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ADYGFosc;
	arc=none smtp.remote-ip=209.85.222.170
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1C2606A326
	for <linux-crypto@vger.kernel.org>; Sat, 28 Nov 2026 20:48:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B1C2606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ADYGFosc
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-949680e6d82so955633485a.2
        for <linux-crypto@vger.kernel.org>; Sat, 28 Nov 2026 12:48:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795898904; x=1796503704; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YEIOmdONe37RhIWuru5PWrPcaCmyPrb3JXUJ+Va48sg=;
        b=ADYGFosc6w7L4CeHQxpjFDPt+GWFEqJa88YkKmwPxeKEkS4tb95ObEUPuBDkthjFg+
         kN+1wLsJfYOOIZUZJftfwIt5QAML+hLc8pW1iAkyDFfG3ULdLPaeZnMMbZP0r8L4Rf/M
         0TUWcHhQgjQMdzqvcAndbt0dqu+sR09/W0GMnTcXA7evLODKYXrlbgQqUAw58dEb/NYc
         ivQwwSuvBG050NvN498NxseblNQLPsBW39a1yABIVTAgu2FADOHXEq7OQfhiOh2F8Ew+
         Dvxy+0t6V3EYdHTHX7czuVJyXXroijv/k0iZ30tvG3SXulXksEC0LuREBcMtH6NUwGKu
         nemA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795898904; x=1796503704;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YEIOmdONe37RhIWuru5PWrPcaCmyPrb3JXUJ+Va48sg=;
        b=L6AGSNi/755FCI/cRmwjKZy8MZ+vz/IeBfi9Umby0GA0pr5yBY+iTQHM2AJo9UJkRk
         Fwm4zk4UuoUIrckln4VaWIz4H6moEh16DxmCeux2Ut7xQoO9tqsUGKmnXstokYNapNcj
         RvA1wrKTRaeS+mdn5ak6YME1QJGw5uwbrlRGrCo5txU3YpY8kh7LEMkN9MX71mKJo8Aq
         /Fe3kmxesHCWPrWi3umwSa8uZ9yDWLt3ZiQVurawTnje8STziMq0mRqsvUaiAd7zhI47
         HMahgMISIg6OLKgzGrT6wEb/U8AUr6fsPmwNXMrprZegizma/xXrO9ho9ky3Uy+FDXWO
         vrIw==
X-Forwarded-Encrypted: i=1; AL+hErGtFSqr08mKnOBdK61fwJB/tzKd+PcriKtHFqHTul2ZnAlGDnW9hPdlB8k5esN0X1/SPFM4eIWrdDI6/bQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z9OCcicfRJ73lX6QEml+sNtu3NYspObfBhYAepRncL9NykWmaa8
	IZVvvJE5WtYcFiwm0nH4Yr9DH1A0v173FJ/jU2qOJN+i+9kPetatVIBJ
X-Gm-Gg: AZFdTZcJYjUGXDswccP6erSfFDZVaVz+QhGNsCm6JHwJF8UE4X0Ubtr9dgiViloZSBg
	tb3MNV0aYgIBJ/m6v/9CB2iTWDf//HVXP8S5hNe/Y0jGt9tKjPI+dkC4zzaGwNAI8KOXUlSnj7n
	kKYqBAM9XhMR7nbbVeJOtC6F/6A951JPefAtNZwihR2Fs7/bp/hEtKUzKTlo+oIaeUE/aYxb0Vh
	zbz1RLbS0Si/I/NRDP9dQiiYhPeZYWzZkpIPpnBXWNyIAYkeY5q5tH78PuN91Xi6UtT95dm7+cG
	hS5ndlkMQvavVZmlWp+7jl6WxjQiwyncaPD2pd/kSIxpSbwYoL4adHRO9P83dM0IiwsLDsFO002
	IYUOFh/dxxYxLbe9VUHZqoHNxsYZz1+V/vVRSGosW/haRbORqB/Ill1q3KerdMedBMtgJup6c+5
	HhumQs4GFpI3jhzK1XtL4FOiEVdpeg4hGW1H+KXF7ek+mBQ3SZprROhXHqaZzGDJGexaj1KosgS
	8InwG3ueStwfUlmeKQpbw1KYcOz/5h4VbH5DuDmhL7zn8q5XGv7/pNR5Rxdlih8S8ptPNiatcTp
	dEqGsMzh3SqChKNvsbHQzdFvfJwYrO7jg6pBrIymEsIPRph017kG9Cemxgr/P0KNV+oPRPG8Ksi
	qrOeOsO5e6jncZyl4VNw9egfh+b6qlYEKtlcc
X-Received: by 2002:a05:620a:1724:b0:949:71fa:5b0f with SMTP id af79cd13be357-949baa053dbmr5182999485a.61.1795898904079;
        Sat, 28 Nov 2026 12:48:24 -0800 (PST)
Received: from BOOST-MACHINE.localdomain ([163.252.152.153])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb349db3sm2129739885a.7.2026.11.28.12.48.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2026 12:48:23 -0800 (PST)
From: Timur Kussainov <kusainov.timur@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Corentin Labbe <clabbe@baylibre.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Heiko Stuebner <heiko@sntech.de>,
	linux-crypto@vger.kernel.org,
	linux-rockchip@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Timur Kussainov <kusainov.timur@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] crypto: rockchip - fix inverted hash completion poll
Date: Sat, 28 Nov 2026 15:47:44 -0500
Message-ID: <20261128204745.1044083-2-kusainov.timur@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261128204745.1044083-1-kusainov.timur@gmail.com>
References: <20261128204745.1044083-1-kusainov.timur@gmail.com>
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

Before commit 37bc22159c45 ("crypto: rockchip - use read_poll_timeout"),
rk_hash_run() waited for the hash engine with

	while (!CRYPTO_READ(tctx->dev, RK_CRYPTO_HASH_STS))
		udelay(10);

i.e. it spun until RK_CRYPTO_HASH_STS became non-zero (HASH_DONE set).
The conversion to readl_poll_timeout() inverted the condition to
"v == 0", so the poll now waits for the opposite state. The return value
was ignored at the time, so the bug went unnoticed: the digest was read
after the 1 ms timeout and happened to be correct.

Now that the timeout is reported as an error, every hash request fails
with "HASH idle timeout" and the rk-sha1/rk-sha256/rk-md5 self-tests
fail.

Poll for the HASH_DONE bit, as the original code did.

Tested on an ASUS Tinker Board (RK3288): the md5/sha1/sha256 self-tests
pass, and 300 digests of random buffers (4 bytes to 1 MiB) computed via
AF_ALG match the generic implementation.

Fixes: 37bc22159c45 ("crypto: rockchip - use read_poll_timeout")
Cc: stable@vger.kernel.org
Signed-off-by: Timur Kussainov <kusainov.timur@gmail.com>
---
 drivers/crypto/rockchip/rk3288_crypto_ahash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto_ahash.c b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
index d3482619a..922980b66 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_ahash.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
@@ -325,7 +325,7 @@ static int rk_hash_run(struct crypto_engine *engine, void *breq)
 	 * complete.
 	 */
 	err = readl_poll_timeout(rkc->reg + RK_CRYPTO_HASH_STS, v,
-				 v == 0, 10, 1000);
+				 v & RK_CRYPTO_HASH_DONE, 10, 1000);
 	if (err) {
 		dev_err(rkc->dev, "HASH idle timeout\n");
 		goto theend;
-- 
2.47.3

