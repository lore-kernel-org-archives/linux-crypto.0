Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1461027FB34
	for <linux-crypto@vger.kernel.org>; Tue, 25 Nov 2025 21:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764105750; cv=none; b=hdl0jwt64Bq2SIzjYVwJMsONrVi5AtDuNQhpC4O44S4T0Bd8zR4w6gPq0jEvmMUIIlJY7KaK6p4Jm8HxwI5Gs+VSiZ+NUvtHzpYjHG/4ok15CLvIXDFxiuxLSizMNJPgbXP+gsSEzxwIajihzWcbDX7eG0cIptuw4l7rupu77q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764105750; c=relaxed/simple;
	bh=IDw4YajmtepqggE88Zrt7rMaSzws+BX9vMTuwLAZgog=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XHY6QZw4ckRn9q3/+QBKesl88AuYn4dLqb7tOXBETOe1cUd9qRbeW0M7sLWAAYKmeXGkZ2Jb77Be2DZcEcIKkGW8kGKYuasIPUUNzjQzI87loCw0bm3d+FBWfy7S9o2wl1das3FHfNTgCP+24q3ozDqDzJg7W7NEcMuztxvQMsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cbjFjvzf; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cbjFjvzf"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764105736;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xhUg5nVY4Nfo8QoiwbxmhJLK8s13nH/11xUV0X2e+T4=;
	b=cbjFjvzfheJKj46SeQ0Hy9TwBEVNJulhwhybfnnAMv55ycDaHFUbg27SMUWRBelu4tLUZL
	abKzrp8fqspyGfHPpY6MuWGmoSVY1A9MXKcAbJqReVLYeSfA7jchcEgADXvw4Gf1iR8zxp
	/Q2EuCNkhyEUExT0X6skP/6h3CoWbhw=
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
Subject: [PATCH v3] lib/crypto: blake2b: Limit frame size workaround to GCC
Date: Tue, 25 Nov 2025 22:21:51 +0100
Message-ID: <20251125212150.3486-2-thorsten.blum@linux.dev>
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

Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
Changes in v3:
- Add a comment and remove the end marker (Nathan)
- Link to v2: https://lore.kernel.org/lkml/20251123182515.548471-3-thorsten.blum@linux.dev/

Changes in v2:
- Restrict frame size workaround to GCC independent of its version or
  the architecture
- Update patch title and description
- Link to v1: https://lore.kernel.org/lkml/20251122105530.441350-2-thorsten.blum@linux.dev/
---
 lib/crypto/Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index b5346cebbb55..79315717fb43 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -33,7 +33,12 @@ obj-$(CONFIG_CRYPTO_LIB_GF128MUL)		+= gf128mul.o
 
 obj-$(CONFIG_CRYPTO_LIB_BLAKE2B) += libblake2b.o
 libblake2b-y := blake2b.o
+ifeq ($(CONFIG_CC_IS_GCC),y)
+# Please note that the bug affected only i386 and has been fixed since GCC 12.2.
+# However, modern GCC versions still generate very large stack frames on other
+# architectures.
 CFLAGS_blake2b.o := -Wframe-larger-than=4096 #  https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105930
+endif
 ifeq ($(CONFIG_CRYPTO_LIB_BLAKE2B_ARCH),y)
 CFLAGS_blake2b.o += -I$(src)/$(SRCARCH)
 libblake2b-$(CONFIG_ARM) += arm/blake2b-neon-core.o
-- 
Thorsten Blum
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

