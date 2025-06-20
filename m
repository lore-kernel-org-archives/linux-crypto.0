Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B36223185D;
	Fri, 20 Jun 2025 20:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750452719; cv=none; b=GO1+tO6tCVmHPFVfd/Sq0MTAKDlr30x+tBUuUBeAMoltlK3wVbuGcpx2iuKdxHqEaDFqF70ZapPFgxX3lka0YPepuCZzF9FoQ7LBzd3R9HL3rAW5Qjz56wIcwGyVcwJonX8eQ1fvlQur2dljizAivp++45vHokvFOhyMM2BWlDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750452719; c=relaxed/simple;
	bh=0NdZ4CRoINYOWhBpUl2mwfaStrZeKVVIQuamgT21rT4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c/0gBR+VXuPbLKI6YhfglFn1l6Kz8jedPsij99xYPv2pw2Z5tUBaT6dPtU8hzOlG+b076WqUs4+2kCpwzzLNaw8N+GjJ+hBZLhk/Pv1O0qtoUmTFAFic+bp+TFGUnwVh5xQr4arOaU7lAJQhfvVnedNXZjS40xs/kkXuZD7JkOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=udySxNgu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="udySxNgu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24DBC4CEE3;
	Fri, 20 Jun 2025 20:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750452718;
	bh=0NdZ4CRoINYOWhBpUl2mwfaStrZeKVVIQuamgT21rT4=;
	h=From:To:Cc:Subject:Date:From;
	b=udySxNguXn0+xQw3y+qMf/khi2PUVIUWo/5JK8PrpyzDyj9BJKg65RFYVQdNwYZjy
	 5N4hYWfBH0uWgpHvZrGtbVB2UFPp6DCi8RnRbv8dXnTjVk4a5greJgp+/OWFvKsmOY
	 la/rxPSWJg2dsp5zTBfGUoHOm/AD5LOw5UXSmUDIf3qv9AUgr4DIAlZlvnvmbIalSO
	 MHZh9FnN6VYcYhuLFhcex1/SVhCYLzPs7QHzkkYzRJU0NAfisma7iegrN+a4ShXJil
	 GJm7gYMkT8/tD4Ye/fwibnoumCLc/IjvjqLUIcliM5kIAcrNuwHtUXGbiq20D9ZtQN
	 ozSHhePv3RKDQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Srinivas Kandagatla <srini@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] nvmem: layouts: Switch from crc32() to crc32_le()
Date: Fri, 20 Jun 2025 13:50:27 -0700
Message-ID: <20250620205027.23403-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

u_boot_env_parse() calls crc32() from within a scope that has a uint32_t
variable named crc32.  This works only because crc32() is actually a
macro that expands to crc32_le().  I'm planning to make it an inline
function instead, which will make the usual C scoping rules apply to it.
Therefore, update u_boot_env_parse() to be compatible with that.  To do
so, just call crc32_le() directly instead of using the crc32() alias.
(An alternative would be to rename the local variable.)

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

I'm planning to apply this patch to crc-next, since my patch
https://lore.kernel.org/r/20250619183414.100082-3-ebiggers@kernel.org/
depends on this.

 drivers/nvmem/layouts/u-boot-env.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvmem/layouts/u-boot-env.c b/drivers/nvmem/layouts/u-boot-env.c
index 436426d4e8f91..274e8a456e8c1 100644
--- a/drivers/nvmem/layouts/u-boot-env.c
+++ b/drivers/nvmem/layouts/u-boot-env.c
@@ -146,11 +146,11 @@ int u_boot_env_parse(struct device *dev, struct nvmem_device *nvmem,
 	crc32_addr = (__le32 *)(buf + crc32_offset);
 	crc32 = le32_to_cpu(*crc32_addr);
 	crc32_data_len = dev_size - crc32_data_offset;
 	data_len = dev_size - data_offset;
 
-	calc = crc32(~0, buf + crc32_data_offset, crc32_data_len) ^ ~0L;
+	calc = crc32_le(~0, buf + crc32_data_offset, crc32_data_len) ^ ~0L;
 	if (calc != crc32) {
 		dev_err(dev, "Invalid calculated CRC32: 0x%08x (expected: 0x%08x)\n", calc, crc32);
 		err = -EINVAL;
 		goto err_kfree;
 	}

base-commit: e04c78d86a9699d136910cfc0bdcf01087e3267e
-- 
2.50.0

