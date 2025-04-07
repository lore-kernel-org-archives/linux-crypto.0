Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77F7253F1E;
	Mon,  7 Apr 2025 17:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744047208; cv=none; b=aeMLKUPkAXafCeGoSmWNPyZwpkRek3bap3k/l6+TYDMqlqi8810BqlVWkcUnnBDYRo9Jqxfl3jrl8R9dtnTZbhso13FW8GUgVROcLv1qcQjYEYhkhfBe4uQUd0jRwDDUxl997UzFnmzqyEgRHL6OrC2yNUxhDkikZh4TgzESIV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744047208; c=relaxed/simple;
	bh=p7ULcV2AJ6K0xt6KrSTkD5wqiY6jxKYXXVjn1ezf0Ok=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=sNA1I1ciUjtT1t1eafcWX/MywK021HfG3cRcTc/wu6vwQEwgNdHZxfJ2u1kE8kEMPeDY9z2OD5b3ayDvEM4bb/4jLIQTM1Xy0pogOpTngyWoOrjnaCq62oRICZEDaRJTavh5B6I3iHsjTsaDY6was0opHj9wgtd/rcAF4zt7JbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=OIv+EPpm; arc=none smtp.client-ip=217.70.183.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="OIv+EPpm"
Received: by mail.gandi.net (Postfix) with ESMTPSA id 8D66943160;
	Mon,  7 Apr 2025 17:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1744047204;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6i4LGPZpyDsqY46pnOirmnKr4AE5PweFoQ3kS4LwbxU=;
	b=OIv+EPpmJWKuQpbmSn0tc/OAF20k45ZgKPSzyUs9uJXQATRGX8yUqJfLdtt+LqeWbYjzzw
	FT+93Orrs6H4JRZNT6U5Z1xL2hG+Mp1Nt4WfxwzYvUKkg8QsVdMmmhnm+tH9egNJ7YeywM
	pOYDVd1UwUpku2hKMDDJcK2SLmkD/sRnHlquIHRfAe8DdIqDztVU2Zj8V87eFWcpkXA9o0
	emUv4t+2Fl8GRR5vRrnHmbjPoHzxkEr4rOp6C2P/qBFzA227nVfVM/HzudnzdUu2zlOxMX
	Hn9fRq32zY0e6HLqphibNfWdRaoKh66xny5RqS7K/Awl7Gbqkz394S6RR4teJw==
From: Thomas Richard <thomas.richard@bootlin.com>
Date: Mon, 07 Apr 2025 19:33:14 +0200
Subject: [PATCH] crypto: caam: Add support for i.MX8QM
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250407-imx8qm-caam-support-v1-1-181cf01a14ec@bootlin.com>
X-B4-Tracking: v=1; b=H4sIAFkM9GcC/x3MOQqAMBBA0avI1A7EDZeriEVIRp0ii4lKQLy7w
 fIV/z8QKTBFmIoHAt0c2dmMqixA7dJuhKyzoRZ1J1rRI5s0HAaVlAbj5b0LJ3ZrU/WkhlFrglz
 6QCun/zov7/sBomXtB2UAAAA=
To: =?utf-8?q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>, 
 Pankaj Gupta <pankaj.gupta@nxp.com>, Gaurav Jain <gaurav.jain@nxp.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Thomas Richard <thomas.richard@bootlin.com>
X-Mailer: b4 0.14.1
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddvtddtkedtucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhfffugggtgffkvfevofesthejredtredtjeenucfhrhhomhepvfhhohhmrghsucftihgthhgrrhguuceothhhohhmrghsrdhrihgthhgrrhgusegsohhothhlihhnrdgtohhmqeenucggtffrrghtthgvrhhnpeehtdelgfetjedvvefgfeeiteetgeekfeekleetleejvdehlefhgfetiedvhfdvtdenucffohhmrghinhepmhigjedruggrthgrpdhmgiekmhdruggrthgrpdhmgiekuhhlphdruggrthgrpdhmgiekqhhmrdgurghtrgenucfkphepvdgrtddumegtsgdugeemfhegtdemsghftddtmehftdehgeemtgeltgdvmedvudgtfeemudehieeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepvdgrtddumegtsgdugeemfhegtdemsghftddtmehftdehgeemtgeltgdvmedvudgtfeemudehieeipdhhvghloheplgduvdejrddtrddurddungdpmhgrihhlfhhrohhmpehthhhomhgrshdrrhhitghhrghrugessghoohhtlhhinhdrtghomhdpnhgspghrtghpthhtohepledprhgtphhtthhopehhohhrihgrrdhgvggrnhhtrgesnhigphdrtghomhdprhgtphhtthhopehlihhnuhigqdgtrhihphhto
 hesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehthhhomhgrshdrphgvthgriiiiohhnihessghoohhtlhhinhdrtghomhdprhgtphhtthhopehthhhomhgrshdrrhhitghhrghrugessghoohhtlhhinhdrtghomhdprhgtphhtthhopegurghvvghmsegurghvvghmlhhofhhtrdhnvghtpdhrtghpthhtohepphgrnhhkrghjrdhguhhpthgrsehngihprdgtohhmpdhrtghpthhtohepghgruhhrrghvrdhjrghinhesnhigphdrtghomhdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-GND-Sasl: thomas.richard@bootlin.com

On i.MX8QM, caam clocks are turned on automatically and Linux does not have
access to the caam controller's register page, so skip clocks
initialization.

Signed-off-by: Thomas Richard <thomas.richard@bootlin.com>
---
 drivers/crypto/caam/ctrl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index d4b39184dbdb..38ff931059b4 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -573,6 +573,7 @@ static const struct soc_device_attribute caam_imx_soc_table[] = {
 	{ .soc_id = "i.MX7*",  .data = &caam_imx7_data },
 	{ .soc_id = "i.MX8M*", .data = &caam_imx7_data },
 	{ .soc_id = "i.MX8ULP", .data = &caam_imx8ulp_data },
+	{ .soc_id = "i.MX8QM", .data = &caam_imx8ulp_data },
 	{ .soc_id = "VF*",     .data = &caam_vf610_data },
 	{ .family = "Freescale i.MX" },
 	{ /* sentinel */ }

---
base-commit: 0af2f6be1b4281385b618cb86ad946eded089ac8
change-id: 20250407-imx8qm-caam-support-5f317ec89dde

Best regards,
-- 
Thomas Richard <thomas.richard@bootlin.com>

