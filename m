Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F7B41D4EA;
	Fri,  7 Aug 2026 11:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786101979; cv=none; b=J2378HYmJYKxlJtgtlhA7ctHtaEtQCRH7c5EUaPU3Gea2z303QMfjyAy5OZ8TsTKeDTtv9C7PvhzMON+TQaVP2F6iaeEYlc/FJQPT6oY4oBB4yAPsR0xunRDGJIwWAx2gSOTCxCx0wR1Q/6FidgegZYnkcVC+WjCc0wqypcmiro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786101979; c=relaxed/simple;
	bh=s5yPAJHJCjoTyZze9sB8p14TVGQ8qTHTjfVTzn1EEYw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nTleUw6JiPURKb7D4FrLbBtfw28RAXBUmTPJhkuvVzOH8lC1qFbCQzzQq0eAJ1OpiX+7hW5Cysj5uzS7t3qlOBY3XeEtLLTqYay0r+O6m7ngbc7z+A+28C8kuqWx31y/NC6gCq9PBBsD1m0KTJmhp5/5nfuPNi4R6XdGzUQcUBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dojbjUTF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dojbjUTF"
Received: by smtp.kernel.org (Postfix) with ESMTPS id F0B0EC2BCFA;
	Fri,  7 Aug 2026 11:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786101979;
	bh=s5yPAJHJCjoTyZze9sB8p14TVGQ8qTHTjfVTzn1EEYw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=dojbjUTFEKuj/cQEkk918sx+Hby/sIcm8cpT/MhoERvERk2O5AhKM3LztiUhYxVKN
	 xep33D7QbUFVcRDdtXvVaxUtRHtnqieueMGhDtQD03C327rDrANsCjL6viRVfkK7q/
	 go3ea5lQZKVpvxDpY5TZ8cvJgUv1L0SjXQ7BKuFUubrfnv8nm8KkhH3SexHLiN1xZ3
	 T2iCkYe5RrkQVxIoLN9E7C3SxZLIxNjdtU35IPw5US9LqeFX6bx72zie7ztsy64644
	 D+/Ok5saUUw77g3dtxlR1D8iiTr8e2Pw/wGhJPBhHfVuQ17flOYBWSyQ50yS1gFnYv
	 BShjBNTbyFsLg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3FDEC5AC80;
	Fri,  7 Aug 2026 11:26:18 +0000 (UTC)
From: Pawel Zalewski via B4 Relay <devnull+pzalewski.thegoodpenguin.co.uk@kernel.org>
Date: Fri, 07 Aug 2026 12:26:09 +0100
Subject: [PATCH 2/4] char: hw_random: use named initializers for
 acpi_device_id
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-acpi-char-v1-2-742c450254dd@thegoodpenguin.co.uk>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786101977; l=1444;
 i=pzalewski@thegoodpenguin.co.uk; s=20260803; h=from:subject:message-id;
 bh=+xP/DyVMe1G4+tAB3K0pNQD1hmkjHQX41ImGXQMTrqo=;
 b=0HUTmx5EbpEP+CnAz7BzmRJIaxcloUiHZXMfz0ArQH/ota00MUtfLnrJJ+ZIOOqQOvhZmYEbW
 0f34qLnp+dkBj5v+DUifGCk+mk1l3vixpU0WqVISP8BfnsFy3ocKq5F
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

Signed-off-by: Pawel Zalewski (The Capable Hub) <pzalewski@thegoodpenguin.co.uk>
---
 drivers/char/hw_random/hisi-trng-v2.c | 2 +-
 drivers/char/hw_random/xgene-rng.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/hisi-trng-v2.c b/drivers/char/hw_random/hisi-trng-v2.c
index 6584ed051e09..9e0ecea56ad6 100644
--- a/drivers/char/hw_random/hisi-trng-v2.c
+++ b/drivers/char/hw_random/hisi-trng-v2.c
@@ -77,7 +77,7 @@ static int hisi_trng_probe(struct platform_device *pdev)
 }
 
 static const struct acpi_device_id hisi_trng_acpi_match[] = {
-	{ "HISI02B3", 0 },
+	{ .id = "HISI02B3" },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, hisi_trng_acpi_match);
diff --git a/drivers/char/hw_random/xgene-rng.c b/drivers/char/hw_random/xgene-rng.c
index 1f4b95341c2e..222db3fb275b 100644
--- a/drivers/char/hw_random/xgene-rng.c
+++ b/drivers/char/hw_random/xgene-rng.c
@@ -296,7 +296,7 @@ static int xgene_rng_init(struct hwrng *rng)
 
 #ifdef CONFIG_ACPI
 static const struct acpi_device_id xgene_rng_acpi_match[] = {
-	{ "APMC0D18", },
+	{ .id = "APMC0D18" },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, xgene_rng_acpi_match);

-- 
2.55.0


