Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51B11CA80
	for <linux-crypto@vger.kernel.org>; Tue, 18 Jun 2024 00:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718671071; cv=none; b=MWdW8ASlSqYN20W4CzAk5p10gRtZSOsQLJ+RoBgYhaTwVFotzaZYokACgRa+fBIAMvp2HMI0lWy560qFSks5ZsZ+DtyfUik4zG0/bG2Ml+AcUPpR3Fbdu8FYCgHgUUxFmHJqXMy8CnQC50vqj8h7O6QLzXNbLHlFVAy/lMOow4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718671071; c=relaxed/simple;
	bh=Hvedb86I9a8BBqTvsputX1R5bqo1eQlMeauBsu3wu2E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZEroa2Yeoebo0oyxmBjFz7lAT0LE0vl0DKANUPNfoH9qgsola2g2G33qqey3/M8yjqWXILtujCtqFYSEcGTkj+0VMk5mBLf5XVMnciC4bUX0VKi+r6fesQUKM1LY4iFeZYR6H3UXML7zSGho7N8Ue/OF9c534wmXB1TwAEvX2j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LmFsQD2I; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LmFsQD2I"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-6f9923df5dbso2827802a34.2
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2024 17:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718671068; x=1719275868; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cJM+FjwIt8Vsqi9DQbiY4E0tjpC6f+V3n620JM6N4W4=;
        b=LmFsQD2Invf78Dc5T6F0FvvEXN7h/hoebIyiDd0WL59W0TiXbLQRXF3cOs5OwYKbGI
         XrpeUxQYJU13IsSJujiRYQd9bhKCdXk1TA72yCSpyGU/t8jxkMlvHfRWhEuD3PXi+KnQ
         BjOHtqe5zpc7dFwqgRqHGfUKwmJZ6daxw5nJ2A5PmvdaV4mJskUMkMuenfBIQxBFqbZN
         tY20xeqQZQAKaKHqgTavTPRthhOSm3OoTaKjv8jCb6sxdhBUObajg1ImquwmIkLeyLbW
         PUddStxaoeDk6VuC1b3AOxoFhNYRz3TM7MbjLjqzoZuKIjtYoVawTruHp1GQTnnfg9TP
         7PlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718671068; x=1719275868;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cJM+FjwIt8Vsqi9DQbiY4E0tjpC6f+V3n620JM6N4W4=;
        b=MrQOdcvqTk85TBktlmqPB2iPlUOl1F/8sPHrB2Vynk0Ee2IY6dkNMWx53CbuSDGipQ
         HgoSGqBOjbPP2/wvRzNTxGfzrb/E8JvnY78Zu266w4tL2JxelIlbLqCFd2+tME8kqTgb
         FBYFYQoaEjZgrDx0gcusoktoGVi97jPC+2HapBmbRmZpq5j0YTIOPmXZ+F20YR7hP7zi
         RfkTLpMXn7yl+xAm0/25SuU1z/ApEEz9dCaPvheDIlnxKxWVdabLGJvw9GT8TgtmAJW1
         s85zS4ueBEu3xIIDOuLN5zOBJKO5Dpbuye1/u3hrChPVfERcGsD6kQHj0XMXuzLle6Df
         m1bg==
X-Forwarded-Encrypted: i=1; AJvYcCXjT7huatFAqmFbKR33Juek4JsjhGvrCZrpp223l7QgBM5aBGQBFn2OHP5EieLihnV4QxLmquJwOqAapANAGMU1SoeWqurPVyae44lL
X-Gm-Message-State: AOJu0YwcM8nxlV6SniY73fesL9yCnbpgPb1G1eSjZ0vgySzGNZUGoSU8
	hoOLiXOl2kFce/1X3AcnwedVWxvhjVUPgQFhJ1+3qP15vbx/iAnR91X+zvCU2rU=
X-Google-Smtp-Source: AGHT+IHmWqNe1qFCpia0kcsa+KwsVizvSzvqatZv/DcZrfeCuQFKkxSB7UvgdM255Z2koLHPoO/haQ==
X-Received: by 2002:a9d:758c:0:b0:6f9:6786:485d with SMTP id 46e09a7af769-6fb93b1ef3cmr12795074a34.37.1718671067847;
        Mon, 17 Jun 2024 17:37:47 -0700 (PDT)
Received: from localhost ([136.62.192.75])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5bd5e0874b7sm1324092eaf.14.2024.06.17.17.37.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jun 2024 17:37:47 -0700 (PDT)
From: Sam Protsenko <semen.protsenko@linaro.org>
To: =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] hwrng: exynos: Enable Exynos850 support
Date: Mon, 17 Jun 2024 19:37:42 -0500
Message-Id: <20240618003743.2975-7-semen.protsenko@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240618003743.2975-1-semen.protsenko@linaro.org>
References: <20240618003743.2975-1-semen.protsenko@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add Exynos850 compatible and its driver data. It's only possible to
access TRNG block via SMC calls in Exynos850, so specify that fact using
QUIRK_SMC in the driver data.

Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
---
 drivers/char/hw_random/exynos-trng.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_random/exynos-trng.c
index 98b7a8ebb909..3368a08df9ce 100644
--- a/drivers/char/hw_random/exynos-trng.c
+++ b/drivers/char/hw_random/exynos-trng.c
@@ -333,6 +333,9 @@ static DEFINE_SIMPLE_DEV_PM_OPS(exynos_trng_pm_ops, exynos_trng_suspend,
 static const struct of_device_id exynos_trng_dt_match[] = {
 	{
 		.compatible = "samsung,exynos5250-trng",
+	}, {
+		.compatible = "samsung,exynos850-trng",
+		.data = (void *)QUIRK_SMC,
 	},
 	{ },
 };
-- 
2.39.2

