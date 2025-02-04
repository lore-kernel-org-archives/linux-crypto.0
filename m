Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF77D21770E;
	Tue,  4 Feb 2025 20:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738699886; cv=none; b=lSRS/zxoSUjRhINOn/u2TEw+RTT3l2movgRutKhjQXGks0R7UjaGk4kMF1B1Bmax00MkvbBbMYcE8n5omT+Z/Dl0cjzfcNi/VTQ5ljUzH952ezlRfa6xbd5QkmReGIMOnlB5dRteP7z5M8xachmbK6oFdeuoKeBkas0svPz5Aa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738699886; c=relaxed/simple;
	bh=aDR2UQIeamWAOumKqtfXeClVQNk5y80+KvM+Zs8Nbc0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aJPuNbY+oDJ7AU2InAIpskLwPk+YPzdMIaJg9Rs5+Sv1AWv9jfAWYb4yiVKFePhYjak4K4m0IOqAJ5JX7ip5jceb0YLzFVPQeEyWXGzuGTcfCK73B/btfM6tRD4tCm9oKNAEPww+wFeMvFg8rGcuU0LwAefV8CcJQykmNjVVhts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JuiZt9Cr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JuiZt9Cr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB137C4CEDF;
	Tue,  4 Feb 2025 20:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738699886;
	bh=aDR2UQIeamWAOumKqtfXeClVQNk5y80+KvM+Zs8Nbc0=;
	h=From:To:Cc:Subject:Date:From;
	b=JuiZt9CrGTVvQVNHN2fuW/CtjDY2uTir9UUNfmIPT8yV/4T/+DSnG8njcVcTSD4or
	 dyIDXYdoUmWkOgSRLpkR0huPWxsqz8bqC4e/rh+HbJiF/0ppj7DvbG1ZEDqg9g1pF7
	 M/OtiKUNJSDSo+FouVarZen5mdQGx7ypk8erzQbMPiykXcyYkKg8aNkwDanrATa0G3
	 bc5zz4JrVEC6zDaVfwJvCwIzBMnnXk/AxmOb4NCfjnMNnXJlGDQcspVz5doK17WBgw
	 ipoKD3twyXCYohGnoFxf196AGygr/UrDwwheZyJknVz4ibTD+0e+jgmWiYvOO/TxU4
	 rzjXKoDijCNUg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] lib/crc-t10dif: remove digest and block size constants
Date: Tue,  4 Feb 2025 12:11:08 -0800
Message-ID: <20250204201108.48039-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

These constants are only used in crypto/crct10dif_generic.c, and they
are better off just hardcoded there.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---

I'm planning to take this via the crc tree.

 crypto/crct10dif_generic.c | 8 ++++----
 include/linux/crc-t10dif.h | 3 ---
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/crypto/crct10dif_generic.c b/crypto/crct10dif_generic.c
index 259cb01932cb5..fdfe78aba3ae0 100644
--- a/crypto/crct10dif_generic.c
+++ b/crypto/crct10dif_generic.c
@@ -114,34 +114,34 @@ static int chksum_digest_arch(struct shash_desc *desc, const u8 *data,
 {
 	return __chksum_finup_arch(0, data, length, out);
 }
 
 static struct shash_alg algs[] = {{
-	.digestsize		= CRC_T10DIF_DIGEST_SIZE,
+	.digestsize		= sizeof(u16),
 	.init			= chksum_init,
 	.update			= chksum_update,
 	.final			= chksum_final,
 	.finup			= chksum_finup,
 	.digest			= chksum_digest,
 	.descsize		= sizeof(struct chksum_desc_ctx),
 	.base.cra_name		= "crct10dif",
 	.base.cra_driver_name	= "crct10dif-generic",
 	.base.cra_priority	= 100,
-	.base.cra_blocksize	= CRC_T10DIF_BLOCK_SIZE,
+	.base.cra_blocksize	= 1,
 	.base.cra_module	= THIS_MODULE,
 }, {
-	.digestsize		= CRC_T10DIF_DIGEST_SIZE,
+	.digestsize		= sizeof(u16),
 	.init			= chksum_init,
 	.update			= chksum_update_arch,
 	.final			= chksum_final,
 	.finup			= chksum_finup_arch,
 	.digest			= chksum_digest_arch,
 	.descsize		= sizeof(struct chksum_desc_ctx),
 	.base.cra_name		= "crct10dif",
 	.base.cra_driver_name	= "crct10dif-" __stringify(ARCH),
 	.base.cra_priority	= 150,
-	.base.cra_blocksize	= CRC_T10DIF_BLOCK_SIZE,
+	.base.cra_blocksize	= 1,
 	.base.cra_module	= THIS_MODULE,
 }};
 
 static int num_algs;
 
diff --git a/include/linux/crc-t10dif.h b/include/linux/crc-t10dif.h
index 16787c1cee21c..d0706544fc11f 100644
--- a/include/linux/crc-t10dif.h
+++ b/include/linux/crc-t10dif.h
@@ -2,13 +2,10 @@
 #ifndef _LINUX_CRC_T10DIF_H
 #define _LINUX_CRC_T10DIF_H
 
 #include <linux/types.h>
 
-#define CRC_T10DIF_DIGEST_SIZE 2
-#define CRC_T10DIF_BLOCK_SIZE 1
-
 u16 crc_t10dif_arch(u16 crc, const u8 *p, size_t len);
 u16 crc_t10dif_generic(u16 crc, const u8 *p, size_t len);
 
 static inline u16 crc_t10dif_update(u16 crc, const u8 *p, size_t len)
 {

base-commit: 2014c95afecee3e76ca4a56956a936e23283f05b
-- 
2.48.1

