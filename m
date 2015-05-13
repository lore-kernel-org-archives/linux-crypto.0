From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] lib: fix 842 build on 32-bit architectures
Date: Wed, 13 May 2015 22:56:39 +0200
Message-ID: <2802721.Q9KnE9eNH4@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Dan Streetman <ddstreet@ieee.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Building the 842 code on 32-bit ARM currently results in this link
error:

ERROR: "__aeabi_uldivmod" [lib/842/842_decompress.ko] undefined!

The reason is that the __do_index function performs a 64-bit
division by a power-of-two number, but it has no insight into
the function arguments.

By marking that function inline, the fsize argument is always
known at the time that do_index is called, and the compiler is
able to replace the extremely expensive 64-bit division with
a cheap constant shift operation.

Aside from fixing that link error, this approach should also improve
both code size and performance on 32-bit architectures significantly.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Found while building arm32 allmodconfig with gcc-5.0

diff --git a/lib/842/842_decompress.c b/lib/842/842_decompress.c
index 6b2b45aecde3..285bf6b6959c 100644
--- a/lib/842/842_decompress.c
+++ b/lib/842/842_decompress.c
@@ -169,7 +169,7 @@ static int do_data(struct sw842_param *p, u8 n)
 	return 0;
 }
 
-static int __do_index(struct sw842_param *p, u8 size, u8 bits, u64 fsize)
+static inline int __do_index(struct sw842_param *p, u8 size, u8 bits, u64 fsize)
 {
 	u64 index, offset, total = round_down(p->out - p->ostart, 8);
 	int ret;
