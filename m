Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C621A0BCD;
	Tue, 10 Jun 2025 09:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749547981; cv=none; b=BvwTDvHy/cj/4TM0gysxX2qWyDWydx955CjBD6ymDDKqhaQUzVDXaZff40aOgr6YETwyFeQ6WB9f33RLs/ZiKEepVOmeBDx8v6hH0KuKwMfgTE47NL51LJjxHfajABsXdw6HpVJkVBDYyxo8/5MDepqbnHpssAM6lPiYEIcFJ+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749547981; c=relaxed/simple;
	bh=fQ3YU3S3K3ivEsEdGjJAl8Hbmyr8jXeJ3oVd0bc1t4c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lTPIis11m07SzEPGWQ1JuYF6sejdWKX0JNzZlAybIrx5PiecowyjDdanpLTzrS8+MlroCxnPlqNPHab7mQYhbDgTEXZONmX23WCekiOjCANA06CeIgx6FDikpe2hA/pKRGuxE8ALz62HuQds5L5XkauzGmna7cGjEaL3/CgE5O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OOQ4t51x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OOQ4t51x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0275C4CEF2;
	Tue, 10 Jun 2025 09:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749547980;
	bh=fQ3YU3S3K3ivEsEdGjJAl8Hbmyr8jXeJ3oVd0bc1t4c=;
	h=From:To:Cc:Subject:Date:From;
	b=OOQ4t51xOrl2MR9zgyKltjt8xczIDYR5Nszf6WA7xXdzs4uRcv6qQcpMD3+Hd/6Mq
	 mToGH3k8Pscs8UM74vbCjPK38LWLhlOBYPyvHrKv2ZRsfx0QAD8VH3IitkoKXOUCCW
	 909llaiuo5FQB35n1ZXLYra6ufiBoQfdWTktXSDRheltD4B0M3TeqYi7T4v3C6I1gA
	 F88+rq7jNcEVgaVcfG1oK9rs55ZuN7OCSdxo4YuRRphGINTSojY8H8LaROGxvbtB8x
	 wmK3WdJeHhYEKWl1iKMmvkeIwWuGGNDuzPmXg5kXoAEzRX36Qk9gJXKxbkPtYy+FwO
	 ndLtwxuJf7riQ==
From: Arnd Bergmann <arnd@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Russell King <linux@armlinux.org.uk>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Eric Biggers <ebiggers@google.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: crypto: work around gcc-15 warning
Date: Tue, 10 Jun 2025 11:32:52 +0200
Message-Id: <20250610093256.2645686-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

I get a very rare -Wstringop-overread warning with gcc-15 for one function
in aesbs_ctr_encrypt():

arch/arm/crypto/aes-neonbs-glue.c: In function 'ctr_encrypt':
arch/arm/crypto/aes-neonbs-glue.c:212:1446: error: '__builtin_memcpy' offset [17, 2147483647] is out of the bounds [0, 16] of object 'buf' with type 'u8[16]' {aka 'unsigned char[16]'} [-Werror=array-bounds=]
  212 |                         src = dst = memcpy(buf + sizeof(buf) - bytes,
arch/arm/crypto/aes-neonbs-glue.c: In function 'ctr_encrypt':
arch/arm/crypto/aes-neonbs-glue.c:218:17: error: 'aesbs_ctr_encrypt' reading 1 byte from a region of size 0 [-Werror=stringop-overread]
  218 |                 aesbs_ctr_encrypt(dst, src, ctx->rk, ctx->rounds, bytes, walk.iv);
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
arch/arm/crypto/aes-neonbs-glue.c:218:17: note: referencing argument 2 of type 'const u8[0]' {aka 'const unsigned char[]'}
arch/arm/crypto/aes-neonbs-glue.c:218:17: note: referencing argument 3 of type 'const u8[0]' {aka 'const unsigned char[]'}
arch/arm/crypto/aes-neonbs-glue.c:218:17: note: referencing argument 6 of type 'u8[0]' {aka 'unsigned char[]'}
arch/arm/crypto/aes-neonbs-glue.c:36:17: note: in a call to function 'aesbs_ctr_encrypt'
   36 | asmlinkage void aesbs_ctr_encrypt(u8 out[], u8 const in[], u8 const rk[],

This could happen in theory if walk.nbytes is larger than INT_MAX and gets
converted to a negative local variable.

Keep the type unsigned like the orignal nbytes to be sure there is no
integer overflow.

Fixes: c8bf850e991a ("crypto: arm/aes-neonbs-ctr - deal with non-multiples of AES block size")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/crypto/aes-neonbs-glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/crypto/aes-neonbs-glue.c b/arch/arm/crypto/aes-neonbs-glue.c
index c60104dc1585..df5afe601e4a 100644
--- a/arch/arm/crypto/aes-neonbs-glue.c
+++ b/arch/arm/crypto/aes-neonbs-glue.c
@@ -206,7 +206,7 @@ static int ctr_encrypt(struct skcipher_request *req)
 	while (walk.nbytes > 0) {
 		const u8 *src = walk.src.virt.addr;
 		u8 *dst = walk.dst.virt.addr;
-		int bytes = walk.nbytes;
+		unsigned int bytes = walk.nbytes;
 
 		if (unlikely(bytes < AES_BLOCK_SIZE))
 			src = dst = memcpy(buf + sizeof(buf) - bytes,
-- 
2.39.5

