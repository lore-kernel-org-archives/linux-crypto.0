Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52EA94086A;
	Sun, 30 Aug 2026 10:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788085493; cv=none; b=tLAE+MHy/XE0zJolE5IsDXDztosF9bIbkPa7vnnkx23zxR8TRsJ48aI96ryhWjiLCy7lHcfa+cgUEgXVhqaJSC5rZ3RbNgs9pOPIXRa5AZ1+cOB7Cz22+EBJSkfDqtQRM+VupFLIJSp14HpfR4nl7GP5kzA9YxnmfkH8RqCneVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788085493; c=relaxed/simple;
	bh=/xQqq2F78uimG+g8/cBVSpRGnUqLT/RocKUf4xON28M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZBsXOIJ+lGADwzUgNaE0HqOdQzXrRDryF4Ei1fKlZgLKLBZ+qFQ0viaOP783+E0kiBq2uaD2W7K5OYDzgQbUQi9MPahAt/WoZ0JWASyiUo2GT1DLxq3EzMtR5WZSy0V016cs6VfD/TOXedyJPWi9fwF+hIXXEO50WTYFRZMVisI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=xJWjiFX3; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=xJNuYAFX; arc=none smtp.client-ip=80.241.56.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="xJWjiFX3";
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="xJNuYAFX"
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4hXpCG6pNlz8v1Y;
	Sun, 30 Aug 2026 12:24:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1788085482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hUg3LnMKjV9MVE0n08fRIjqBr7ECB//Eerd8cLFE4fg=;
	b=xJWjiFX3MDMvqVROFKNrk7mkZgZsK6kOo1AgkAeTvkjLV1uBgfEwbLIhbUGM3CG8FKKoWH
	2IM/VGqJ0jm4xvGnl7UDA8NgEPKkvf7zrRjO5YXE6tT255ixz4rXSrFEt6XBgyFUrMvTVV
	bZQG05k0jt7GExNpZt76yGLGxCzjzcyUGTqiyVNqcXjCtPmIZTusIjR+i4AMKr23Zs1HBd
	CtcgUXprBzLQ3xPEeSIWdhhKah0gs897b8nCBuegIsC/VTvAiDYn0VE0pA3uzeHN7KWqGZ
	tlwga5nri3/5vqFHFTe2JjmNo4SxD1D2xFOraybRdexIHUvrYiXbGSXvg/s7og==
Authentication-Results: outgoing_mbo_mout;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=xJNuYAFX;
	spf=pass (outgoing_mbo_mout: domain of manuelebnerli@mailbox.org designates 2001:67c:2050:b231:465::1 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org
From: Manuel Ebner <manuelebnerli@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1788085481;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hUg3LnMKjV9MVE0n08fRIjqBr7ECB//Eerd8cLFE4fg=;
	b=xJNuYAFXEVdbkpwFYuvr22tl1ozi5iicKwEomIUH6TPHkkArizub3FiJZl0KIAxxFC7qta
	2zY2yIH6u8+X5nShRPFQ1fDvgqcU8vmGpUaGpvMsNYJCZIQCcofd2e/JvvgqaLhv2CMKrV
	8mtnfqoHUDh3KbGG0+/C6CliIACOaIG91HLNBATxWobkxmZ5Q+6NAvvrv9udx6iEHWY//Y
	2PLGrJk9tERSsq28shulSVaoMxAfbZ5DQnZxugIluN+53o5meM0SmtOO0UR0Oy24eXLhRE
	taP0U0ZUFTf7Eo92gzkctj4rvmmcVOnqNHwf6/nnSK8tDy+QDGQZnqLbP5d23A==
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Cheng-Yang Chou <yphbchou0911@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>
Cc: Manuel Ebner <manuelebnerli@mailbox.org>,
	Kees Cook <kees@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: arm64/aes-neonbs: transition to kmalloc_obj()
Date: Sun, 30 Aug 2026 12:17:14 +0200
Message-ID: <20260830101714.625728-3-manuelebnerli@mailbox.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-META: ipfna54i738khrgexqrc7bq9u1f7nd7i
X-MBO-RS-ID: 592fd02ed3e8ea0018b
X-Rspamd-Queue-Id: 4hXpCG6pNlz8v1Y

Convert to type aware allocation as suggested in commit 2932ba8d9c99
("slab: Introduce kmalloc_obj() and family")

CC: Kees Cook <kees@kernel.org>
Fixes: 652a3017c485 ("crypto: arm64/aes-neonbs - Move key expansion off the stack")
Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
---
I have a couple similar patches lined up but they could be automated or maybe
the script is already made by Kees.
Kees can you make a script assisted commit (again)?
---
 arch/arm64/crypto/aes-neonbs-glue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/crypto/aes-neonbs-glue.c b/arch/arm64/crypto/aes-neonbs-glue.c
index 5bcbac979..7cb1aede9 100644
--- a/arch/arm64/crypto/aes-neonbs-glue.c
+++ b/arch/arm64/crypto/aes-neonbs-glue.c
@@ -66,7 +66,7 @@ static int aesbs_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 	struct crypto_aes_ctx *rk;
 	int err;
 
-	rk = kmalloc(sizeof(*rk), GFP_KERNEL);
+	rk = kmalloc_obj(*rk);
 	if (!rk)
 		return -ENOMEM;
 
@@ -128,7 +128,7 @@ static int aesbs_cbc_ctr_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 	struct crypto_aes_ctx *rk;
 	int err;
 
-	rk = kmalloc(sizeof(*rk), GFP_KERNEL);
+	rk = kmalloc_obj(*rk);
 	if (!rk)
 		return -ENOMEM;
 
-- 
2.54.0

