Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC67E2FBE08
	for <linux-crypto@vger.kernel.org>; Sat, 22 Nov 2025 10:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763809078; cv=none; b=Q88bXDHc2Q5OxedSp6/MA4ajkxriB51QYJibMIHiYGec5Ajeb+7YuPx+gb8H7uif/T0BdsdCkxacrSpx5jMstGuQgC/1e8bJf2oGutd51etU0UPwZoetAyRO4zfA4XOalh5OXmbBevprV5f/YasJYNkwE3cs90q0vrHjiB4ykSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763809078; c=relaxed/simple;
	bh=GWtesKagEBWs9dG3u0SjtGG2+EFCBXxpCQu255RhGUk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DycJf9cG+6bBc6N1YGolc+r5R2CBc0MTkq6TzJteMKgmQJCHaw5ACnLYVdwgWepTjbsAy90lMOqme4QOIJaTgpQejML6A6F5tUejF4yySLIGhTlO65mE9d3gzMljtomMj+FbdlkLnw8WuF+uaf/z+BKPU/kUFpJrXe6JTWWup5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QbH11JmZ; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QbH11JmZ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763809072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=zm7Jxc5Da48/UV5DNEG9n0VdL1aGMCvgkLE3bTMhnW0=;
	b=QbH11JmZR8x/ohq23v7vuUvEOaCuIm4ehSW6SC+AkFs+O/StLbDaCWLafRBX0a8777QnTK
	UkTTFrFtZZ3ImSBT06kEECD9A0eq2C3M8O44GqR+HEV1scU8V9sAP6mombp1C60QVmEzo8
	5IQ3LarpZ45YObmpY9zPM+7Og29vNWg=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] lib/crypto: blake2b: Limit frame size workaround to GCC < 12.2 on i386
Date: Sat, 22 Nov 2025 11:55:31 +0100
Message-ID: <20251122105530.441350-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The GCC bug only occurred on i386 and has been resolved since GCC 12.2.
Limit the frame size workaround to GCC < 12.2 on i386.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 lib/crypto/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index b5346cebbb55..5ee36a231484 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -33,7 +33,11 @@ obj-$(CONFIG_CRYPTO_LIB_GF128MUL)		+= gf128mul.o
 
 obj-$(CONFIG_CRYPTO_LIB_BLAKE2B) += libblake2b.o
 libblake2b-y := blake2b.o
+ifeq ($(CONFIG_X86_32),y)
+ifeq ($(CONFIG_CC_IS_GCC)_$(call gcc-min-version, 120200),y_)
 CFLAGS_blake2b.o := -Wframe-larger-than=4096 #  https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105930
+endif # CONFIG_CC_IS_GCC
+endif # CONFIG_X86_32
 ifeq ($(CONFIG_CRYPTO_LIB_BLAKE2B_ARCH),y)
 CFLAGS_blake2b.o += -I$(src)/$(SRCARCH)
 libblake2b-$(CONFIG_ARM) += arm/blake2b-neon-core.o
-- 
2.51.1

