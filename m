Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFEB2D8763
	for <linux-crypto@vger.kernel.org>; Sun, 23 Nov 2025 18:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763922378; cv=none; b=dvAxZvth2VmQx5XESg9mVEC1/ugZbE1mOKHPa1SOejgMn+Ij5KyAR0JKHk22tLyX5r9cD5abmnZYUIa2aVvSX/+m3dIHD3RqSKmbgXk4m21VIhN7fBBaaadmFliXBV7R3vvMGCQw5L+B8VZIvcz1GEG1/3OZ+DRC4CIzUkbjuys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763922378; c=relaxed/simple;
	bh=W1WInrZdod/pGOfdHqhFH+p4im7ZgANDIO0VEZjJ+ww=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Tp5JjIibGrC1OWejXiwB3DcTkkSzTJu/l2DtEReU+gQ90kp/9u4XkrFB8gVB3wu7lN3Tb+y6gbuklFWkovg4jx6Iw3OkgnkgrmwtVvJM6etpnFHa70GG9n0AdwFCZVbbqSBRqqMPiH9at11Xcln2AxALmdxIVLK8vV8P6JO74MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ifTeg2kQ; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ifTeg2kQ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763922364;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=p88zTGcneeVkeEymviXLaW2rR8NcRq8Hspl2QfLX5ZM=;
	b=ifTeg2kQmUuivZPPwqhRJXU9HSwXKSJrOlb0CpIBX1O4dgym+JhIEJTJSXLdeYj4IMGOK+
	5julahzav9eZVoaipdKgmuf2fROHSF3/62cHPcOEjgWoByxnSgf7q6jB6kpUgQIXWMfLH2
	+VEx4Lef8ITJ2uEQBYZr6Ncb66RBtL4=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH v2] lib/crypto: blake2b: Limit frame size workaround to GCC
Date: Sun, 23 Nov 2025 19:25:17 +0100
Message-ID: <20251123182515.548471-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The GCC regression only affected i386 and has been fixed since GCC 12.2.
However, modern GCC versions still generate large stack frames on other
architectures (e.g., 3440 bytes for blake2b_compress_generic() on m68k
with GCC 15.1.0). Clang handles these functions efficiently and should
work fine with the default warning threshold.

Limit the frame size workaround to GCC only.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
Changes in v2:
- Restrict frame size workaround to GCC independent of its version or
  the architecture
- Update patch title and description
- Link to v1: https://lore.kernel.org/lkml/20251122105530.441350-2-thorsten.blum@linux.dev/
---
 lib/crypto/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index b5346cebbb55..95a48393ffb4 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -33,7 +33,9 @@ obj-$(CONFIG_CRYPTO_LIB_GF128MUL)		+= gf128mul.o
 
 obj-$(CONFIG_CRYPTO_LIB_BLAKE2B) += libblake2b.o
 libblake2b-y := blake2b.o
+ifeq ($(CONFIG_CC_IS_GCC),y)
 CFLAGS_blake2b.o := -Wframe-larger-than=4096 #  https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105930
+endif # CONFIG_CC_IS_GCC
 ifeq ($(CONFIG_CRYPTO_LIB_BLAKE2B_ARCH),y)
 CFLAGS_blake2b.o += -I$(src)/$(SRCARCH)
 libblake2b-$(CONFIG_ARM) += arm/blake2b-neon-core.o
-- 
2.51.1

