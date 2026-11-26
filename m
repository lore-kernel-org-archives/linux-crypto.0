Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795721623;
	b=DG2Ck6PfjC73qPwJLIm2VOJtW+Xql2Gz1G3fOKBDsnAHMvZ2hPeLbQgamWHBok2sSoYZ
	 8ghy4xZ+X07kzqRN+OOKc/Ze+FH/kSOJC7tW75489W1Drxeeo9ifwk+erKwOcY5LJQbm0
	 brJ6BiCleX2QlUSae5JZ+bFta2ogTlUmyJkeCrfP8GxCiMtKJr3CauOr6ohsQ75bsjVGY
	 cMbqV6q3z7Pyj5XUshOMgZwk0z/FlrhvMzj+9jP2NJzIt7c+2HyvObLfIa4U3OKxMvlEp
	 atyf3lkvQ4hPX5W3RvW3A38qyBveGZyT47sXGDuBWh9Hm/Sre7Pfub9GEsaMd8E8w2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795721623;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=l0FqxSdSkWVcKj6JvNw9SG+fnKtmoC4+i5Y2izvcenk=;
	b=OdFRzXBNOAWcweVI1/F+xhbKywh/X5vYKWVwDVMW/q7pCXzyTnuvvk6KKoZmtKI/xlB8
	 92E3A2niseHWfVhbBd23924QdKVNV0tWJ3VqDvn8BVPr7ybPZfd8AGcMEmXXi0VpTnb95
	 pdHjasVn4M3JJ6XxxzFxpoQEjgCYpF9j5gb3e6UzCByIE6UAdHbEwHhNc2WoS9Bc9D1PP
	 mMS/l/nS5P5SAeh54OgTijRu36pOtMtyORIclmmuIP3bBvo/04uQsYU3/cuU6Es7I2NSM
	 DkfbgDUS9EDXkOxGSOde8MDDDzmf/y4OQFuB+iktWLOEJBuPFTuwptd7wSuMjrTnylg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=acvmjd2p;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60C4606A32A
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 19:33:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D60C4606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=acvmjd2p
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so95245445e9.1
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 11:33:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795721621; x=1796326421; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l0FqxSdSkWVcKj6JvNw9SG+fnKtmoC4+i5Y2izvcenk=;
        b=acvmjd2peWYeLhtuO2XQIlBR76TzBn9iONnK/GG4N50fLUHZZc409BWcVvz1asIvOb
         eNMWBmBfLw2llSoh9xeXSIzcDWuh2hKI8TY03kOmumbj+qufnooNeLkYximBimxw6+wT
         66SAPDQwiooia/dI/YYv90u7e+Xa+F2GHeWdcp9Y2kW9zCFGXuqOosLkVmKLDKh4X/ev
         61nk12qBQ2Bn6z5/JQef2JNWDfiQfghzajwoiyj3Hw4Ha1VtPVqOF/rxOUkZKYVXT1l+
         2kfyxT5vNpAoHSFNBu1smOwxgemLl0p845nfTd9SYGW27yYoyMhPMQgr0iTpT5fTib9x
         IdwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795721621; x=1796326421;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=l0FqxSdSkWVcKj6JvNw9SG+fnKtmoC4+i5Y2izvcenk=;
        b=J75ujLJpETodtIBPN4irZENusn0noRsdN6HmdHpIbGJcexatQa5H3eBonQeD1TT2RN
         D0+CfrsjsirCpMByO0zSR2xj6dIZRVPA1jymaU7ETxlbFyNoXAtFrwFnznsBtzWK25eF
         Ps1YorOat0TqF30dd+vlUKU4kMGnMGsHE6XqQPSb1PeoZuVHf6aGY2tzxk9/lOOB5XNW
         Wc3jVSd5fxVsq/WxaCkVDRADwdCmR0gJb25wxZMMACF8egYf+lrAxrqWXpU2wTI0oNii
         +cMpxIaer84aobon4hZ3Z7Qx4xwI4sgPacSWu2f3XwoO+iyqAGKiHoJ/DQ/9zpyYWN3x
         fldQ==
X-Gm-Message-State: APuU4Z+x24ncTUBf809fLKu9gOavP4uCjH2uKZBlu9izYiyBxHly5aMV
	S+EPeRYfqy7XJZmbgPXIBlLb51nEGRsgypXCc0HyK95CcT6LA/Tuvabt
X-Gm-Gg: AZFdTZeWNMU2GPh8GzOZy2i/zAN81zwziSqeeu+xIbiN+jVZgz09NGbrQejTRUBJICO
	n5ah1NLxRbI93dJYt52KPN6iRxtAVYGD3i29DBeypL5AEpSsQViAfDUcbnlDoT3rgegfrkhPQyH
	xJ6esAESa0SAtNeVPiQojO7Uo8qrVoVd8CdOaLYX9oAiGuR1W1VDkit5KIVrUBtIm4sW+ONLI6t
	UDYUXDKtjdSA5rFhWitkLJeYOg/y4zNPCZvKm8rAX9M3Z5dQPoOyIzNGXVXpu/xB4n37IkC5884
	2Qhc/X8LHN8eCwNB0wwn33LsGRMYwl5DCzcfUTB93mWKBraslOBn3Nzga2incQ+/m8aoXtXWTqI
	qj5xGcnQT1HIvGxUVf9EHjQCCezW+40s8XKyC0suC6vQYCmvDQVcQlLz0yv6VIa+TY9jFQIF+9S
	+CCafbdPK5OHb4K+BLMz17mMGcqxtrWzSet4eEUczpmsv/XzUEyDQINecpky4LqQ/S5ZYKsoudV
	k7gTYFCwjlOgGsnF9hPPEFOt8IWNzRSNRaImA9hYvCGuSQP9leRDzbhG/ncjFWxqUOb8RksQj7a
	bhfYXrLyDbzP8gORqYXsLRQ4ywRteO1ouB4vZnUEPJGb1Q==
X-Received: by 2002:a05:600c:4f81:b0:4bb:5e8c:13bc with SMTP id 5b1f17b1804b1-4bb88805902mr425835985e9.7.1795721621193;
        Thu, 26 Nov 2026 11:33:41 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906cdcc1sm368287675e9.2.2026.11.26.11.33.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 11:33:40 -0800 (PST)
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
Subject: [PATCH v13 25/25] arm64: dts: amlogic: axg: add crypto node
Date: Thu, 26 Nov 2026 20:32:41 +0100
Message-ID: <20261126193241.1471372-26-jnieto.alaber@gmail.com>
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

This patch adds a crypto node declaration. With the
Amlogic crypto driver we can use HW implementation
of SHA1/224/256 and AES algo.

Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
---
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
index 5b8ef98f6d03..e755a019b384 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
@@ -321,6 +321,13 @@ ethmac: ethernet@ff3f0000 {
 			status = "disabled";
 		};
 
+		crypto: crypto@ff63e000 {
+			compatible = "amlogic,axg-crypto";
+			reg = <0x0 0xff63e000 0x0 0x48>;
+			interrupts = <GIC_SPI 180 IRQ_TYPE_EDGE_RISING>;
+			clocks = <&clkc CLKID_CLK81>;
+		};
+
 		pcie_phy: phy@ff644000 {
 			compatible = "amlogic,axg-pcie-phy";
 			reg = <0x0 0xff644000 0x0 0x1c>;
-- 
2.47.3

