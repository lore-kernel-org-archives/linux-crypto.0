From: David Miller <davem@davemloft.net>
Subject: inconsistent handling of unaligned hash inputs
Date: Wed, 01 Oct 2014 01:10:34 -0400 (EDT)
Message-ID: <20141001.011034.1533102319982018632.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: bpicco@meloft.net, bob.picco@oracle.com, sparclinux@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:54420 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaJAFKi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 1 Oct 2014 01:10:38 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Bob Picco sent me a bootup trace showing that we've started to get
unaligned accesses when the generic sha256 is tested on sparc64.  I
believe this is introduced by:

commit 950e4e1c1b334c4975b91106f23fd343be3eb7a0
Author: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Date:   Sat Apr 12 15:35:29 2014 +0300

    crypto: testmgr - add empty and large test vectors for SHA-1, SHA-224, SHA-256, SHA-384 and SHA-512

That change looks perfectly correct, it's just adding new legitimate
tests to run, but when I went to look to see how unaligned inputs are
handled I see:

1) SHA1 uses get_unaligned_be32()
2) SHA256/SHA224 uses direct u32 derefencing
3) SHA384/SHA512 likewise
4) MD5 always operates on the md5 context's mctx->block which is
   u32 aligned.

The sparc64 assembler that uses the chip's crypto instructions doesn't
have this problem because we have two code paths, one for aligned
data and one for unaligned data, in each routine.

Anyways, I suspect that we need to use get_unaligned_be{32,64}() in
generic SHA256 and SHA512.

The following seems to fix things for me:

====================
crypto: Handle unaligned input data in generic sha256 and sha512.

Like SHA1, use get_unaligned_be*() on the raw input data.

Reported-by: Bob Picco <bob.picco@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/crypto/sha256_generic.c b/crypto/sha256_generic.c
index 5433667..0bb5583 100644
--- a/crypto/sha256_generic.c
+++ b/crypto/sha256_generic.c
@@ -24,6 +24,7 @@
 #include <linux/types.h>
 #include <crypto/sha.h>
 #include <asm/byteorder.h>
+#include <asm/unaligned.h>
 
 static inline u32 Ch(u32 x, u32 y, u32 z)
 {
@@ -42,7 +43,7 @@ static inline u32 Maj(u32 x, u32 y, u32 z)
 
 static inline void LOAD_OP(int I, u32 *W, const u8 *input)
 {
-	W[I] = __be32_to_cpu( ((__be32*)(input))[I] );
+	W[I] = get_unaligned_be32((__u32 *)input + I);
 }
 
 static inline void BLEND_OP(int I, u32 *W)
diff --git a/crypto/sha512_generic.c b/crypto/sha512_generic.c
index 6ed124f..6dde57d 100644
--- a/crypto/sha512_generic.c
+++ b/crypto/sha512_generic.c
@@ -20,6 +20,7 @@
 #include <crypto/sha.h>
 #include <linux/percpu.h>
 #include <asm/byteorder.h>
+#include <asm/unaligned.h>
 
 static inline u64 Ch(u64 x, u64 y, u64 z)
 {
@@ -68,7 +69,7 @@ static const u64 sha512_K[80] = {
 
 static inline void LOAD_OP(int I, u64 *W, const u8 *input)
 {
-	W[I] = __be64_to_cpu( ((__be64*)(input))[I] );
+	W[I] = get_unaligned_be64((__u64 *)input + I);
 }
 
 static inline void BLEND_OP(int I, u64 *W)
