Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A691F94A;
	Wed,  7 Jan 2026 05:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767763332; cv=none; b=TapMD6jl9saRIbACC0jlXk82L/T/1nCTJVF+YuuPqnR9nhACBb/OPjw4sEGl6bP9gL54vP1k+hebthTkPDdBgs4veIS2S9ZQIe2Vi8dJrwA7t4zMSDsN46I+mXWOSV1mTrHdGhzG9EqwHfZWVapC8OgAent8oZu23MEn0NgtSaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767763332; c=relaxed/simple;
	bh=vIYnVUMUYdu4oyLCEJ94b9A9n9eIvaOTcOWPENRlRoU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OBEbnbGn7e9nPRZbodPrjj/SyS7X7umu21KEFQEvbvZrjLkSQQARiSWQTYspbXiO2kcXwldkQKFqd/CVNYJZONL6ewkj/rEEDHSRei7waDHF+XRM2DAI9d5h0ZHdP4LDh0STD0eNe9JdjcYtMSBxk6/HVKsjuQEBLY26Ncy8elQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PX9yaTiE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PX9yaTiE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C02C4CEF7;
	Wed,  7 Jan 2026 05:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767763331;
	bh=vIYnVUMUYdu4oyLCEJ94b9A9n9eIvaOTcOWPENRlRoU=;
	h=From:To:Cc:Subject:Date:From;
	b=PX9yaTiE+kqsedhEPVD3hq5LTBM762y0hiZTWfIgL6unEsJrOP9r9i//eCG3/9B/v
	 nqkA33FwKbSgBB5gUn6dnCoyybH6u8cGTd6bVRu8iSosnWHIKFfdFLefdZ6D/lvPL1
	 t2LjO+T09jmuB1hdjU5WmEgCzRxWP8CqU9Rii8Cz7g7kbZIcvQhdvupaGv9h3tlDBW
	 LzRDnW3dhOvqrENbat+S5OKyKxAgmmKblTNHqCL0n1k5/KInhrDMtEu5UvU6X01tOa
	 O7XyOtE2V3cUnKhtnAUiCsh35IV7XizET8w4zsBRFy5udWN0Bas2AdCKYe9t1+BO5r
	 nxau9qdiMtejw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org,
	Qingfang Deng <dqfext@gmail.com>
Subject: [PATCH] lib/crypto: aes: Fix missing MMU protection for AES S-box
Date: Tue,  6 Jan 2026 21:20:23 -0800
Message-ID: <20260107052023.174620-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__cacheline_aligned puts the data in the ".data..cacheline_aligned"
section, which isn't marked read-only i.e. it doesn't receive MMU
protection.  Replace it with ____cacheline_aligned which does the right
thing and just aligns the data while keeping it in ".rodata".

Fixes: b5e0b032b6c3 ("crypto: aes - add generic time invariant AES cipher")
Cc: stable@vger.kernel.org
Reported-by: Qingfang Deng <dqfext@gmail.com>
Closes: https://lore.kernel.org/r/20260105074712.498-1-dqfext@gmail.com/
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting libcrypto-fixes

 lib/crypto/aes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
index b57fda3460f1..102aaa76bc8d 100644
--- a/lib/crypto/aes.c
+++ b/lib/crypto/aes.c
@@ -11,11 +11,11 @@
 
 /*
  * Emit the sbox as volatile const to prevent the compiler from doing
  * constant folding on sbox references involving fixed indexes.
  */
-static volatile const u8 __cacheline_aligned aes_sbox[] = {
+static volatile const u8 ____cacheline_aligned aes_sbox[] = {
 	0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5,
 	0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76,
 	0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0,
 	0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0,
 	0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc,
@@ -46,11 +46,11 @@ static volatile const u8 __cacheline_aligned aes_sbox[] = {
 	0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf,
 	0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68,
 	0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16,
 };
 
-static volatile const u8 __cacheline_aligned aes_inv_sbox[] = {
+static volatile const u8 ____cacheline_aligned aes_inv_sbox[] = {
 	0x52, 0x09, 0x6a, 0xd5, 0x30, 0x36, 0xa5, 0x38,
 	0xbf, 0x40, 0xa3, 0x9e, 0x81, 0xf3, 0xd7, 0xfb,
 	0x7c, 0xe3, 0x39, 0x82, 0x9b, 0x2f, 0xff, 0x87,
 	0x34, 0x8e, 0x43, 0x44, 0xc4, 0xde, 0xe9, 0xcb,
 	0x54, 0x7b, 0x94, 0x32, 0xa6, 0xc2, 0x23, 0x3d,

base-commit: fdfa4339e805276a458a5df9d6caf0b43ad4c439
-- 
2.52.0

