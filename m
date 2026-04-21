Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFB8259CB9;
	Tue, 21 Apr 2026 23:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776813065; cv=none; b=VdIkdTSDn/F1k4KrGNRE3+E+rPYK6gsJB17EA2M+EkAz9+vp6C4ChF9j+/LhKjA6ALblh+5Y9//FPZu9bbdeScko/8dnaczKeDGwQAWn94Lm8Y1+OANgzl7oiLSnbClHJEfL/c5YKNG/TbQtOC2CkNMXjew/SjlJ+wHrgFnTbtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776813065; c=relaxed/simple;
	bh=k1Y89x6vauq6r41+hR0VuphbGfZpf7XIWoDpwB7PiRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nhscntThRCm0ZbcAN+bdXLI1BNw8SSe4Y6dn3ZIl2sbyeurhPuEQihBztaYybWDhqzA8868tOuUKVBzmYSQemia8vj/Y80+5QAnJ7xAupfN1lG5bOM3gjRLKQm/oTK77Js3oNmZVqF30E1rf/8cR9l6Q8GFk0DLBFXNJ5A6+VrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PavNffL8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PavNffL8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA736C2BCB7;
	Tue, 21 Apr 2026 23:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776813065;
	bh=k1Y89x6vauq6r41+hR0VuphbGfZpf7XIWoDpwB7PiRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PavNffL8zOfrSkzfPb2oq+6AJnonUdjxofiaNxgG9kGi67eSk6ON71RED/IE+jolD
	 Vs+SrWzgctevxYMSxjg5/TX9mvJXtJSTj3u4wIoKn6OarJ1mB4YthokCv7LhUCte+B
	 Cp4C8OwzR6DnedBnMjJLhCvgZV2yVgMaZSAxHrM4GT7raNtHyDCwvPB4PVuqDI2aG+
	 LRKtGhh/jq4owKvA5z/mSDIxT6AfsVmZ039sOClAhWKbt3SlUCr3cW93nBimoVQmMT
	 DBkBl7xWR2GzoEBWVPtdp8KQPQlEa0iEdwTnDrdIGr1mGxhMzZpsHwJT2PakvGrUk/
	 eKHPqSga3qoHw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-bluetooth@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 1/2] Bluetooth: Remove unneeded crypto kconfig selections
Date: Tue, 21 Apr 2026 16:09:16 -0700
Message-ID: <20260421230917.7057-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260421230917.7057-1-ebiggers@kernel.org>
References: <20260421230917.7057-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove several kconfig selections that are no longer needed:

  - CRYPTO_SKCIPHER and CRYPTO_ECB have been unneeded since
    commit a4770e1117f1 ("Bluetooth: Switch SMP to
    crypto_cipher_encrypt_one()") in 2016.

  - CRYPTO_SHA256 has been unneeded since
    commit e7b02296fb40 ("Bluetooth: Remove BT_HS") in 2024.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 net/bluetooth/Kconfig | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/bluetooth/Kconfig b/net/bluetooth/Kconfig
index 6b2b65a66700..8bd0f2891161 100644
--- a/net/bluetooth/Kconfig
+++ b/net/bluetooth/Kconfig
@@ -7,16 +7,13 @@ menuconfig BT
 	tristate "Bluetooth subsystem support"
 	depends on !S390
 	depends on RFKILL || !RFKILL
 	select CRC16
 	select CRYPTO
-	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_AES
 	imply CRYPTO_AES
 	select CRYPTO_CMAC
-	select CRYPTO_ECB
-	select CRYPTO_SHA256
 	select CRYPTO_ECDH
 	help
 	  Bluetooth is low-cost, low-power, short-range wireless technology.
 	  It was designed as a replacement for cables and other short-range
 	  technologies like IrDA.  Bluetooth operates in personal area range
-- 
2.53.0

