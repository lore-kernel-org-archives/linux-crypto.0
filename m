Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390FC42B725;
	Fri,  7 Aug 2026 11:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786101979; cv=none; b=IlET/QmyjjjSPuqzs70dcjGcN3wsC4JficTKItPwZduPqyXZcHT6qaqi99oy3jd9b2Jx8srO0r2R52Wt2O3+5IJkFuLLWE1k6bw9MIe/MtmG4Vyvwd8n0lKdWEFw6kzYuzZAhsombEVEIbnTx3eUKmqQhNu7f9mAv00RJudMQH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786101979; c=relaxed/simple;
	bh=oJO5h+nosdRoYIT0B8NHstUH+k1xdQUHRF77SsiPdNc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=uuG9DXc+810f+D7aztb7fsTfkYqY3vh4WAkHndB9LfO+GApSzpNhOiFgI19lfciCis3qSmwcNKXrgRvp6QCeBTGQjhw/BbKyESiOgZb6IjdC3nJWffY6nv7LDVeBU+nAGPGf7WY3OoU93PotLrbX8X7xag2of3MvcRLlx9Zbsxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iPjF0yHF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iPjF0yHF"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0B2F9C2BCF7;
	Fri,  7 Aug 2026 11:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786101979;
	bh=oJO5h+nosdRoYIT0B8NHstUH+k1xdQUHRF77SsiPdNc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=iPjF0yHFTBYUHaLCnB/hFeEILsro+Iptxm5TIdCAa6pdVfML50CgXjySa291n7+QZ
	 uyUFttA7++Zyhkx92n8a4m4CkXsdH+fU5RY98qtF/L4BEPngLAtnP+MEtK1z0ZfVDB
	 4iLUBcZKuAvRQHTGYnz183+MkCiODq3L9ViB64QlisuDTS6IQhYXJ+UI4dWq+rqowZ
	 r89TBOwFBxc3Dt0PNj1T0sjqgVINP9oeg9DC3tyJOFXL9w2G9fpvERxPj63SfDeIxd
	 FjqZtWQwmEe8BWOpHv25JqxGPf5s2tj+dI/P3WU7PuWeqZIVai0Fj/smsRaMfSit52
	 zZ6djvsmLZDwQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4AA0C5AC7A;
	Fri,  7 Aug 2026 11:26:18 +0000 (UTC)
From: Pawel Zalewski via B4 Relay <devnull+pzalewski.thegoodpenguin.co.uk@kernel.org>
Date: Fri, 07 Aug 2026 12:26:10 +0100
Subject: [PATCH 3/4] char: ipmi: use named initializers for acpi_device_id
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-acpi-char-v1-3-742c450254dd@thegoodpenguin.co.uk>
References: <20260807-acpi-char-v1-0-742c450254dd@thegoodpenguin.co.uk>
In-Reply-To: <20260807-acpi-char-v1-0-742c450254dd@thegoodpenguin.co.uk>
To: Clemens Ladisch <clemens@ladisch.de>, Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Mattia Dongili <malattia@linux.it>, Weili Qian <qianweili@huawei.com>, 
 Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, Corey Minyard <corey@minyard.net>, 
 Peter Huewe <peterhuewe@gmx.de>, Jarkko Sakkinen <jarkko@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org, 
 linux-crypto@vger.kernel.org, openipmi-developer@lists.sourceforge.net, 
 linux-integrity@vger.kernel.org, 
 "Pawel Zalewski (The Capable Hub)" <pzalewski@thegoodpenguin.co.uk>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786101977; l=2063;
 i=pzalewski@thegoodpenguin.co.uk; s=20260803; h=from:subject:message-id;
 bh=KSRiDBr/KlyRDt2jepviaq+isDgvIHWz0zDwNFdjAOU=;
 b=bCJjHt/hyxm30i2BmzMj5Gp85SGiXlRWj3FSLgnvW2M2kAKEaM/kJIXMgIHKiz9Yg6JcxhmDj
 GMofNtEZ1cuBR5rNsqrIDtpnm5s7KCQGSJMAUcw6cnNwkzQ0hTvgOVy
X-Developer-Key: i=pzalewski@thegoodpenguin.co.uk; a=ed25519;
 pk=W3zk1cb/wRnj6pNGbl3/2Zf3GmPA6IBpNHpDPyJ05k8=
X-Endpoint-Received: by B4 Relay for
 pzalewski@thegoodpenguin.co.uk/20260803 with auth_id=913
X-Original-From: "Pawel Zalewski (The Capable Hub)" <pzalewski@thegoodpenguin.co.uk>
Reply-To: pzalewski@thegoodpenguin.co.uk

From: "Pawel Zalewski (The Capable Hub)" <pzalewski@thegoodpenguin.co.uk>

Use a named initializer for the acpi_device_id fields which
makes the code more readable and consistent with how lists
are initialized in the rest of the kernel code base. Also
drop explicitly setting fields to 0 where it is redundant.

While we are at it - unify the list terminator to have
a single space between the brackets and no trailing
comma.

Signed-off-by: Pawel Zalewski (The Capable Hub) <pzalewski@thegoodpenguin.co.uk>
---
 drivers/char/ipmi/ipmb_dev_int.c     | 4 ++--
 drivers/char/ipmi/ipmi_si_platform.c | 4 ++--
 drivers/char/ipmi/ipmi_ssif.c        | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/char/ipmi/ipmb_dev_int.c b/drivers/char/ipmi/ipmb_dev_int.c
index 680ff15c30ab..d576a77df927 100644
--- a/drivers/char/ipmi/ipmb_dev_int.c
+++ b/drivers/char/ipmi/ipmb_dev_int.c
@@ -360,8 +360,8 @@ MODULE_DEVICE_TABLE(i2c, ipmb_id);
 
 #ifdef CONFIG_ACPI
 static const struct acpi_device_id acpi_ipmb_id[] = {
-	{ "IPMB0001", 0 },
-	{},
+	{ .id = "IPMB0001" },
+	{ }
 };
 MODULE_DEVICE_TABLE(acpi, acpi_ipmb_id);
 #endif
diff --git a/drivers/char/ipmi/ipmi_si_platform.c b/drivers/char/ipmi/ipmi_si_platform.c
index bdc481ce1302..fa221cbb4b3b 100644
--- a/drivers/char/ipmi/ipmi_si_platform.c
+++ b/drivers/char/ipmi/ipmi_si_platform.c
@@ -387,8 +387,8 @@ static int acpi_ipmi_probe(struct platform_device *pdev)
 }
 
 static const struct acpi_device_id acpi_ipmi_match[] = {
-	{ "IPI0001", 0 },
-	{ },
+	{ .id = "IPI0001" },
+	{ }
 };
 MODULE_DEVICE_TABLE(acpi, acpi_ipmi_match);
 #else
diff --git a/drivers/char/ipmi/ipmi_ssif.c b/drivers/char/ipmi/ipmi_ssif.c
index 07f1d2327bb7..2361103c5edc 100644
--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -2057,8 +2057,8 @@ static unsigned short *ssif_address_list(void)
 
 #ifdef CONFIG_ACPI
 static const struct acpi_device_id ssif_acpi_match[] = {
-	{ "IPI0001", 0 },
-	{ },
+	{ .id = "IPI0001" },
+	{ }
 };
 MODULE_DEVICE_TABLE(acpi, ssif_acpi_match);
 #endif

-- 
2.55.0


