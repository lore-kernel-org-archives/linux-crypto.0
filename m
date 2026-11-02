Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793638905;
	b=rKHLB9x8fBzpIn2MdhUVGqvsPHV4oSNIZmI1kEPbMigehjfJjOAnwj3rQ+1BAODE9J7F
	 59NSemWJFyGCCImy/vfRbk9GsQb7rrl+kH3GEBQKKjuAG9bdSS30uTBDsDEcq4dmacl5l
	 32wH8eARaCyBXlOGN/Sc4tXv2btqFh7/eeADR7J8n79MncIOSpoLZ1LGZxtX9eJbKKd1L
	 J/OPeCrMDGJC555l9NsR2d4eF3fJ0MzAgIapI+Z3O4/s4Kr4Qav1XpPuoyP4ZX3PS8GoO
	 LKIiERTia+7CsFQoRpv8ZVKxRe8ugJ2QbQULj1MLa/1bw3+IOIUQmsNpbAoC+l8Us3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793638905;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=//2dH0tf9WsNJ1T/56d2QvgVSnUsRCYl2PIU9XEdbPI=;
	b=GX1UuQvLr40yfcf40ZQ/IyPbzhA7+Z5uT19pNZEqky3THyoQHdsj91Aa2pBHRJ3HFlqk
	 vnOwP7pgcy4jYCV+/5zfkzvzAvk7UQIQUfnRwWbypc8cyTGyl0JBCUVmEPDQkhi0icznd
	 FIpcjNTqTI00Si66SKr3aVmenBUNsxHCPBqohjZToNtLY9h1Z+iYXu9ykGKIq7xzSyW/S
	 68JFCPsAtn0eBeX2PJu7kd7DAvjx7kBL3MI79hSikeirI4ruY/jIiQvWAp1HkNKSUJVvz
	 VRf/8+TabPj9i3yxAMVkqDZOGxeLxO9MG3sowtzSdbUWxQ0eXTyVsxMiFXdJTFCpQrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=n0M4GQdk;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401A9606F225
	for <linux-crypto@vger.kernel.org>; Mon,  2 Nov 2026 17:01:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 401A9606F225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=n0M4GQdk
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4ac95761c85so21004825e9.2
        for <linux-crypto@vger.kernel.org>; Mon, 02 Nov 2026 09:01:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793638904; x=1794243704; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=//2dH0tf9WsNJ1T/56d2QvgVSnUsRCYl2PIU9XEdbPI=;
        b=n0M4GQdk28w4KtKpcrsogDAta86YM5Wp928CKaOwOkxmtfRhJtNe4E360NEhiHoyEX
         t9fm8FwNtQEjXWDUqvu5aY0R2jxNWL65fDnRJ/95QLOM5Q8Ex+MK1kDVasCVgkKss2rA
         AceNYF2yTnDaTVyQanJ7fvrCnAIp5EGxC8bBgchj54TTXcQ97ErKJHsFfIhwWR7zcYZP
         mpiW28w8zrQjfmsC6OT89zUFDrpt0QfDLL83o1EzOqrQLjvTmNs2XJzLSG/e106a8jqG
         AftueCoUUSyUxnqiGHKNqvOxHwuG3gws4V+2XmOXo44oDOoYeZQwYGYSRfG/0Yzu3tmU
         SHFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793638904; x=1794243704;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=//2dH0tf9WsNJ1T/56d2QvgVSnUsRCYl2PIU9XEdbPI=;
        b=b1LZkBKgK9eZI79NOzsNg+aq8hlEmoODyESQoIgmJ4SdjaB54qJQKqQa+6O8roI4o4
         eXkSc3eb+F0wgzaJ8otxxwWSkeYeEbanFls+b5gu75JpZJ+neTcBkAvoo2897exMnTMO
         wreJItF/HZCOQwM7tWUmnzmZuZTZKfOsuwR7fPLAHKcgOSwQyc7yEgchNfva6xzLaT18
         Z0TKYaWPy62c9f5Zp6vaOz+vB2RY7ChMtHTafEPMwRc6quxZ/eMs5IZN6sj9w+GLAHdY
         SDdvtOMJQIsH3NT+23oRrANI7JGst2fyQyR7a27J/Rm/KvfH3wZb4Yb5twHqHH/6YUcS
         LVNQ==
X-Forwarded-Encrypted: i=1; AKwUvBy/IobBIK/aK1eLym9dnXsY96vBtGSmLxmAGAyVrhmSZ2k18Ux6IxVgehm+3rYBJR6AWtMex2fYU03djtA=@vger.kernel.org
X-Gm-Message-State: AFq9FYIo8kRUQvE8WVEF/AsE7Dwe+1fugkEoowZJFP6jKph93ZqFsJ8g
	Jpk1dALjL0yoNXb0kAHW4W95bWehjE/UH4tlZogZTmooADaHSxmh70Ai
X-Gm-Gg: AYBFou1HIwWC0iF7StZnQwoeIiSeIROqWnCy1ucp1leGG4kBs144YIC4oNeQn2feKyJ
	jzNrEtjcM+6lXuYA7bsDRdL3AC0v9whplrnzNzXXTbl2nHWi4mggKSIjqZgIgqHYD4VgTdVrOPW
	5QYnwXtfet4fO6lgX9RBO6uJb//5IvAWM3GC1J0jseEelMGGKcnnoYPx0dDfJ3M6sYKI/kEIcpe
	US0sOzTNZ5Y9sr1+RJ3NhXwzENhuwpP4Tk78KPt5fOc+0faqgm2ebjPQsYPO62Q6AZunvo/34GR
	muOEewOpw3/SglFTYJ5CHB8IRlQhunO3IOZtgkV8b/ejqs6RoGi53Lmh2FV0nkR59jToXEpu3y1
	BKobEhStS4pDEoshO9EmSgMfe2zQNt9eLl8wUpq7q0eb/yMEwtBzxWDFLHiboSoE/7J9erWcFM4
	TswOhzh5vE995CIyNKZHk5LsraRjjWkIR3pTFSr+/l2PP4GTEqTT8YbQAasIYZiUoX6hiKskmQG
	wigpSR+hKnCKkXrEkRs8XRzwHxZEtDgg5X7UieXyZO1UqIS8dYem21OsDEq5lQKjFWZVMyPEiT7
	Hbyv+oLOILkv3he8t12CZI9RsCMxkpJK4fFCPbPIBNtSu2ut8UxCyq8VAnR1gjpqvo8yyhEjodg
	g3zjOU8fCSTH65bu85+YcVSn1k6dvfG33HVwg4iLnWevjIqorHD3qYdBZuCsjr2HwExApNF2Ft/
	d8m5n+hYHkzisrK6pZ4EKiIXjC37ns+ba5ptkrCbw/micT3zLEzTLRMJOiABCYL328ZWB4Hxcoz
	w==
X-Received: by 2002:a05:600c:314a:b0:4a2:fd2:985d with SMTP id 5b1f17b1804b1-4ac1775316amr237285955e9.12.1793638903629;
        Mon, 02 Nov 2026 09:01:43 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a00-1028-8388-a84e-0499-f85d-af98-1439.ipv6.o2.cz. [2a00:1028:8388:a84e:499:f85d:af98:1439])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2a5372d8bsm1215295e9.0.2026.11.02.09.01.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 02 Nov 2026 09:01:43 -0800 (PST)
From: Josef Schlehofer <pepe.schlehofer@gmail.com>
To: =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thorsten Blum <blum@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-i2c@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Marius Dinu <m95d@psihoexpert.ro>
Subject: Re: [PATCH] crypto: atmel-i2c - find the bus speed behind an I2C mux
Date: Mon,  2 Nov 2026 18:01:41 +0100
Message-ID: <20261102170141.54660-1-pepe.schlehofer@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <auieEHLkx76881ZL@solitude>
References: <auieEHLkx76881ZL@solitude>
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

Hi Marek,

thanks for the ack and the warning.

The hwrng core starts a fill thread for the current RNG, whatever its
quality. It reads 32 bytes every 60 seconds, even when idle.
atmel_i2c_send_receive() puts the ATSHA204A to sleep after each
command. That means about 1440 seed updates per day, and 100k cycles
in about 70 days.

The ATSHA204A becomes the current RNG when the MCU firmware has no
TRNG. It also stays current when it registers first, because both RNGs
have quality 1024. Today the probe fails on the Omnia, so it is safe.
This patch could wear out its EEPROM within months. It is also marked
for stable.

The patch also lets the ATSHA204 on the Turris 1.x probe, as its I2C
controller has no clock-frequency either. There the talitos hwrng wins,
because the ATSHA204 has quality 1. Without talitos, the ATSHA204 would
wear out the same way.

Should we fix the wear before this patch goes in? Does "proper power
management" mean the idle command instead of sleep? I can look into
it.

Josef
