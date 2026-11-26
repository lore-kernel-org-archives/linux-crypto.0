Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795721604;
	b=BiiNoiY/Ydbhk1VoL8HPKWumm/WZ7wbBNzzWaCNeoYrPJ8XvZZDcUFPCmDtE2NO6ZjNS
	 ejLYuEJzhw1rdbk6BOF1wx4gTExeRSXfTpssBZc2XwT4CNyWJQ2wLmWmXuSNc2uF5hEX2
	 q+h5aPoBZDwpnDq+LOep2gC647+tRZYRF2490uZVNqQ1MUjQ2ZqlXmORNE2cL6RVlg/6k
	 Shntb1iKcIcvJltaaFPHUFWFqFhq8zf0phxofNL1MdleWUsA2SL6g5Y7bWv/k65gKoXcV
	 sxi0PLYz6yDB+qTHTd+UFQOE+QGykXg/F/crOFsVy669MofvTi376QYB2OVsTIn08dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795721604;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=CkraiMujrKuYrzSwo1OuAMt+g+COsPr5VU70SHz5/kg=;
	b=SrYR7VjjAOCH/i3zbotcldEs3bAOx7R2UysbiKTv9S8sDfzuyjbLHdPUyYmYInUhLbdJ
	 2roWlKR2YCgmKJgw31gBdSm6frlyOEOpTBMBTHeW0mbfBB50PmyyamgIHdP2FdmsRNNjL
	 9NxynRxAaP1CLLPUcvn1Yu+Jo30RlD4f/I9Ze0VzabhfOzWrIZhBsFvqZ3F7F9IAOGQVH
	 dMjZ8I6pWwtjQG0c7g6YG1G5BrSo1fjdUbZ5cwQVbzOIxYCW/jbczBmPJBzSsV/Ey1u7T
	 cJZ1jwyOvirHEoMXwpuWDBuGma4fM753fNqifMKQWJMY/rA4EBAoD45p/61Lu8/Mu2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=McSYMkx9;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB7C606A31C
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 19:33:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2EB7C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=McSYMkx9
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4bb6c7b6dbdso68525945e9.0
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 11:33:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795721603; x=1796326403; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CkraiMujrKuYrzSwo1OuAMt+g+COsPr5VU70SHz5/kg=;
        b=McSYMkx9gF1+jTF2yC5J+zY+QDw//u3itxFhGkKbQHBjnbEww3gTomHV7R0LS3Jd0X
         vBS95MluJ2w8x6iQZ0VEfLly/ALHhmjxM2sjueUTMHgfa6MEe3dpimOrm94RuwaxCBRM
         rKh2zJvFeSJ4d/opiZBAaU4T3ei7yrkUTMs1/CuBQZoDmtVOWD+qBBLy5cXR9FSOXIKD
         aLyv4w0QKgBjW8Qv7MV8Nd87JsEALazcDUyt6bXNw/fNedTChqvpNvaKxV2GRkAlR5ID
         lBRHafpbr2qnMWcMHEeOWaO+wqnjqBcom+EZyurv5yYcNnqsJFYUBoMFbgHmbYhoK3Jp
         y5Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795721603; x=1796326403;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CkraiMujrKuYrzSwo1OuAMt+g+COsPr5VU70SHz5/kg=;
        b=K+UBcyL66AiEhI7edbSrOhZuBCYnzm5KnmMH8JjNEXqmlrS4MTRjkO/DVFi7YkJl72
         6jARN2EKHxeHaHf73TaelnIRWIGALkd2qP6wZWrYu7ZlZBKTYdb88Sjpa0yjdDT5Vi2M
         iOObHeQDJSg5ox1BbYiRlWr/lUJuVvntLhElcp3A6oSdWkhwuabOARETFpKVotQTBUrr
         CrEaSGblGjj5zWsmubxxQ7Ka0Faffm7qVvhHMfzBk3QMwLY43/y9lDoUvZi2/AkdjwQX
         QSNscpw4ZquDcjrs7ZSAIVjhqV9mj2CTt4OX6VhTuCCMjBLKpDsoUu3/QR8a8W8+Y5Xs
         C1QA==
X-Gm-Message-State: APuU4Z88glErVmrSpb4t75BqLPNYTgSo9HOgVIYj+71ijgDyjwq8u2lt
	STdHnDyGS4gVqAD8uvSDd8oi4ARqdrt9ey/wCQV6oU57MTawlwg+kBoNxFPGxL7/EYU=
X-Gm-Gg: AZFdTZdN+UHo8vykjpgdns4wgFSgW1HmXjEyG19K52sFA69+c9f+R4H+Q/0wLPOFmWu
	sOOZpKv2BfQkTMRFIEoNn5BkWP8HO5b5xdFivg117Aduw0wZ8kgbnbNxBfKi9M9BglsaSJ/xuFP
	6bFbP4OnLqsb19qs0DufQaDy6RafKMOsbBo384KFt3IrCIZFHUs2BNUzBqado8u3nwY8fq1gwdb
	IPHLNghYUKwXB50SbbDvmX57dMAX4lPNe+3fNE/dNus1q1VZx6CTuXlmmNlOIVtkET65fvUQ5WW
	9XREBPLv+loVY9GQEQbhCnsjaByMw1FVWVFFGjcJk5W0vdGfZY3llJiZZd0vFqxx0m1BlQK9IVE
	jRTSBv0dz2qCvmfsBKp9HG8cwiPZSdSuaJyzu/ErLmB4ZKg8mBGrH2uv2brsLopbymGKwi+AWTP
	wJp06NJVZMv4+teSahx+2RzgH9GYuWrbPuU8CIgjtrpJTY+BKpnVBbvHIw0nPY+OQPuRr8G9+qi
	4oiElgZi2Muu1nsIRpNMXq41oZAxjOz8s2ZoBdMJ4ds0FjEFIc0JsX2n1It/6YpFI2NEVEhQSJB
	6irr291qxZ64wI4JUJSNFunagneNQDVV8UuZflTMTTLpzw==
X-Received: by 2002:a05:600c:37c9:b0:4a6:eca1:7d5c with SMTP id 5b1f17b1804b1-4bb888251b4mr392936815e9.32.1795721602653;
        Thu, 26 Nov 2026 11:33:22 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906cdcc1sm368287675e9.2.2026.11.26.11.33.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 11:33:22 -0800 (PST)
From: Jose Nieto <jnieto.alaber@gmail.com>
To: Corentin Labbe <clabbe@baylibre.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	devicetree@vger.kernel.org,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Alexey Romanov <romanov.alexey2000@gmail.com>
Subject: [PATCH v13 15/25] crypto: amlogic - Add support for G12-series
Date: Thu, 26 Nov 2026 20:32:31 +0100
Message-ID: <20261126193241.1471372-16-jnieto.alaber@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
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

From: Alexey Romanov <romanov.alexey2000@gmail.com>

Tested via tcrypt module and with custom tests.

Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
---
 drivers/crypto/amlogic/amlogic-gxl-core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index f530e238812e..0fb0da20e06b 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -282,11 +282,23 @@ static const struct meson_pdata meson_gxl_pdata = {
 	.support_192bit_key = true,
 };
 
+static const struct meson_pdata meson_g12a_pdata = {
+	.descs_reg = 0x0,
+	.status_reg = 0x8,
+	.setup_desc_cnt = 1,
+	.hasher_supported = true,
+	.support_192bit_key = false,
+};
+
 static const struct of_device_id meson_crypto_of_match_table[] = {
 	{
 		.compatible = "amlogic,gxl-crypto",
 		.data = &meson_gxl_pdata,
 	},
+	{
+		.compatible = "amlogic,g12a-crypto",
+		.data = &meson_g12a_pdata,
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(of, meson_crypto_of_match_table);
-- 
2.47.3

