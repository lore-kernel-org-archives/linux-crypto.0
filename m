From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: [PATCH 1/2] crypto: x86 - change email address for Jussi Kivilinna
Date: Thu, 07 Mar 2013 22:48:23 +0200
Message-ID: <20130307204823.16522.95287.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:57771 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab3CGUyc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 7 Mar 2013 15:54:32 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Change my email address from @mbnet.fi to @iki.fi in arch/x86/crypto/*.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 arch/x86/crypto/ablk_helper.c                |    2 +-
 arch/x86/crypto/blowfish-x86_64-asm_64.S     |    2 +-
 arch/x86/crypto/blowfish_glue.c              |    2 +-
 arch/x86/crypto/camellia-aesni-avx-asm_64.S  |    2 +-
 arch/x86/crypto/camellia-x86_64-asm_64.S     |    2 +-
 arch/x86/crypto/camellia_aesni_avx_glue.c    |    2 +-
 arch/x86/crypto/camellia_glue.c              |    2 +-
 arch/x86/crypto/cast5-avx-x86_64-asm_64.S    |    2 +-
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S    |    2 +-
 arch/x86/crypto/glue_helper-asm-avx.S        |    2 +-
 arch/x86/crypto/glue_helper.c                |    2 +-
 arch/x86/crypto/serpent-avx-x86_64-asm_64.S  |    2 +-
 arch/x86/crypto/serpent-sse2-i586-asm_32.S   |    2 +-
 arch/x86/crypto/serpent-sse2-x86_64-asm_64.S |    2 +-
 arch/x86/crypto/serpent_avx_glue.c           |    2 +-
 arch/x86/crypto/serpent_sse2_glue.c          |    2 +-
 arch/x86/crypto/twofish-avx-x86_64-asm_64.S  |    2 +-
 arch/x86/crypto/twofish-x86_64-asm_64-3way.S |    2 +-
 arch/x86/crypto/twofish_glue_3way.c          |    2 +-
 19 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/arch/x86/crypto/ablk_helper.c b/arch/x86/crypto/ablk_helpe=
r.c
index 43282fe..08d4186 100644
--- a/arch/x86/crypto/ablk_helper.c
+++ b/arch/x86/crypto/ablk_helper.c
@@ -1,7 +1,7 @@
 /*
  * Shared async block cipher helpers
  *
- * Copyright (c) 2012 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ * Copyright (c) 2012 Jussi Kivilinna <jussi.kivilinna@iki.fi>
  *
  * Based on aesni-intel_glue.c by:
  *  Copyright (C) 2008, Intel Corp.
diff --git a/arch/x86/crypto/blowfish-x86_64-asm_64.S b/arch/x86/crypto=
/blowfish-x86_64-asm_64.S
index 246c670..4e97088 100644
--- a/arch/x86/crypto/blowfish-x86_64-asm_64.S
+++ b/arch/x86/crypto/blowfish-x86_64-asm_64.S
@@ -1,7 +1,7 @@
 /*
  * Blowfish Cipher Algorithm (x86_64)
  *
- * Copyright (C) 2011 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ * Copyright (C) 2011 Jussi Kivilinna <jussi.kivilinna@iki.fi>
  *
  * This program is free software; you can redistribute it and/or modif=
y
  * it under the terms of the GNU General Public License as published b=
y
diff --git a/arch/x86/crypto/blowfish_glue.c b/arch/x86/crypto/blowfish=
_glue.c
index 50ec333..eb1e2b5 100644
--- a/arch/x86/crypto/blowfish_glue.c
+++ b/arch/x86/crypto/blowfish_glue.c
@@ -1,7 +1,7 @@
 /*
  * Glue Code for assembler optimized version of Blowfish
  *
- * Copyright (c) 2011 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ * Copyright (c) 2011 Jussi Kivilinna <jussi.kivilinna@iki.fi>
  *
  * CBC & ECB parts based on code (crypto/cbc.c,ecb.c) by:
  *   Copyright (c) 2006 Herbert Xu <herbert@gondor.apana.org.au>
diff --git a/arch/x86/crypto/camellia-aesni-avx-asm_64.S b/arch/x86/cry=
pto/camellia-aesni-avx-asm_64.S
index cfc1634..879a736 100644
--- a/arch/x86/crypto/camellia-aesni-avx-asm_64.S
+++ b/arch/x86/crypto/camellia-aesni-avx-asm_64.S
@@ -1,7 +1,7 @@
 /*
  * x86_64/AVX/AES-NI assembler implementation of Camellia
  *
- * Copyright =C2=A9 2012 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ * Copyright =C2=A9 2012 Jussi Kivilinna <jussi.kivilinna@iki.fi>
  *
  * This program is free software; you can redistribute it and/or modif=
y
  * it under the terms of the GNU General Public License as published b=
y
diff --git a/arch/x86/crypto/camellia-x86_64-asm_64.S b/arch/x86/crypto=
/camellia-x86_64-asm_64.S
index 310319c..f2b52f9 100644
--- a/arch/x86/crypto/camellia-x86_64-asm_64.S
+++ b/arch/x86/crypto/camellia-x86_64-asm_64.S
@@ -1,7 +1,7 @@
 /*
  * Camellia Cipher Algorithm (x86_64)
  *
- * Copyright (C) 2012 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ * Copyright (C) 2012 Jussi Kivilinna <jussi.kivilinna@iki.fi>
  *
  * This program is free software; you can redistribute it and/or modif=
y
  * it under the terms of the GNU General Public License as published b=
y
diff --git a/arch/x86/crypto/camellia_aesni_avx_glue.c b/arch/x86/crypt=
o/camellia_aesni_avx_glue.c
index 96cbb60..321e9f4 100644
--- a/arch/x86/crypto/camellia_aesni_avx_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx_glue.c
@@ -1,7 +1,7 @@
 /*
  * Glue Code for x86_64/AVX/AES-NI assembler optimized version of Came=
llia
  *
- * Copyright =C2=A9 2012 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ * Copyright =C2=A9 2012 Jussi Kivilinna <jussi.kivilinna@iki.fi>
  *
  * This program is free software; you can redistribute it and/or modif=
y
  * it under the terms of the GNU General Public License as published b=
y
diff --git a/arch/x86/crypto/camellia_glue.c b/arch/x86/crypto/camellia=
_glue.c
index 5cb86cc..3de9391 100644
--- a/arch/x86/crypto/camellia_glue.c
+++ b/arch/x86/crypto/camellia_glue.c
@@ -1,7 +1,7 @@
 /*
  * Glue Code for assembler optimized version of Camellia
  *
- * Copyright (c) 2012 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ * Copyright (c) 2012 Jussi Kivilinna <jussi.kivilinna@iki.fi>
  *
  * Camellia parts based on code by:
  *  Copyright (C) 2006 NTT (Nippon Telegraph and Telephone Corporation=
)
diff --git a/arch/x86/crypto/cast5-avx-x86_64-asm_64.S b/arch/x86/crypt=
o/cast5-avx-x86_64-asm_64.S
index c35fd5d..412855a 100644
--- a/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
@@ -4,7 +4,7 @@
  * Copyright (C) 2012 Johannes Goetzfried
  *     <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
  *
- * Copyright =C2=A9 2012 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ * Copyright =C2=A9 2012 Jussi Kivilinna <jussi.kivilinna@iki.fi>
  *
  * This program is free software; you can redistribute it and/or modif=
y
  * it under the terms of the GNU General Public License as published b=
y
diff --git a/arch/x86/crypto/cast6-avx-x86_64-asm_64.S b/arch/x86/crypt=
o/cast6-avx-x86_64-asm_64.S
index f93b610..7f36bcc 100644
--- a/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
@@ -4,7 +4,7 @@
  * Copyright (C) 2012 Johannes Goetzfried
  *     <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
  *
- * Copyright =C2=A9 2012 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ * Copyright =C2=A9 2012 Jussi Kivilinna <jussi.kivilinna@iki.fi>
  *
  * This program is free software; you can redistribute it and/or modif=
y
  * it under the terms of the GNU General Public License as published b=
y
diff --git a/arch/x86/crypto/glue_helper-asm-avx.S b/arch/x86/crypto/gl=
ue_helper-asm-avx.S
index f7b6ea2..78800e4 100644
--- a/arch/x86/crypto/glue_helper-asm-avx.S
+++ b/arch/x86/crypto/glue_helper-asm-avx.S
@@ -1,7 +1,7 @@
 /*
  * Shared glue code for 128bit block ciphers, AVX assembler macros
  *
- * Copyright (c) 2012 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ * Copyright (c) 2012 Jussi Kivilinna <jussi.kivilinna@iki.fi>
  *
  * This program is free software; you can redistribute it and/or modif=
y
  * it under the terms of the GNU General Public License as published b=
y
diff --git a/arch/x86/crypto/glue_helper.c b/arch/x86/crypto/glue_helpe=
r.c
index 22ce4f6..1562ebd 100644
--- a/arch/x86/crypto/glue_helper.c
+++ b/arch/x86/crypto/glue_helper.c
@@ -1,7 +1,7 @@
 /*
  * Shared glue code for 128bit block ciphers
  *
- * Copyright (c) 2012 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ * Copyright (c) 2012 Jussi Kivilinna <jussi.kivilinna@iki.fi>
  *
  * CBC & ECB parts based on code (crypto/cbc.c,ecb.c) by:
  *   Copyright (c) 2006 Herbert Xu <herbert@gondor.apana.org.au>
diff --git a/arch/x86/crypto/serpent-avx-x86_64-asm_64.S b/arch/x86/cry=
pto/serpent-avx-x86_64-asm_64.S
index 43c9386..64b9439 100644
--- a/arch/x86/crypto/serpent-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/serpent-avx-x86_64-asm_64.S
@@ -5,7 +5,7 @@
  *     <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
  *
  * Based on arch/x86/crypto/serpent-sse2-x86_64-asm_64.S by
- *  Copyright (C) 2011 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ *  Copyright (C) 2011 Jussi Kivilinna <jussi.kivilinna@iki.fi>
  *
  * This program is free software; you can redistribute it and/or modif=
y
  * it under the terms of the GNU General Public License as published b=
y
diff --git a/arch/x86/crypto/serpent-sse2-i586-asm_32.S b/arch/x86/cryp=
to/serpent-sse2-i586-asm_32.S
index d348f15..13497f6 100644
--- a/arch/x86/crypto/serpent-sse2-i586-asm_32.S
+++ b/arch/x86/crypto/serpent-sse2-i586-asm_32.S
@@ -1,7 +1,7 @@
 /*
  * Serpent Cipher 4-way parallel algorithm (i586/SSE2)
  *
- * Copyright (C) 2011 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ * Copyright (C) 2011 Jussi Kivilinna <jussi.kivilinna@iki.fi>
  *
  * Based on crypto/serpent.c by
  *  Copyright (C) 2002 Dag Arne Osvik <osvik@ii.uib.no>
diff --git a/arch/x86/crypto/serpent-sse2-x86_64-asm_64.S b/arch/x86/cr=
ypto/serpent-sse2-x86_64-asm_64.S
index acc066c..5551d16 100644
--- a/arch/x86/crypto/serpent-sse2-x86_64-asm_64.S
+++ b/arch/x86/crypto/serpent-sse2-x86_64-asm_64.S
@@ -1,7 +1,7 @@
 /*
  * Serpent Cipher 8-way parallel algorithm (x86_64/SSE2)
  *
- * Copyright (C) 2011 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ * Copyright (C) 2011 Jussi Kivilinna <jussi.kivilinna@iki.fi>
  *
  * Based on crypto/serpent.c by
  *  Copyright (C) 2002 Dag Arne Osvik <osvik@ii.uib.no>
diff --git a/arch/x86/crypto/serpent_avx_glue.c b/arch/x86/crypto/serpe=
nt_avx_glue.c
index 52abaaf..0e525c2 100644
--- a/arch/x86/crypto/serpent_avx_glue.c
+++ b/arch/x86/crypto/serpent_avx_glue.c
@@ -5,7 +5,7 @@
  *     <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
  *
  * Glue code based on serpent_sse2_glue.c by:
- *  Copyright (C) 2011 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ *  Copyright (C) 2011 Jussi Kivilinna <jussi.kivilinna@iki.fi>
  *
  * This program is free software; you can redistribute it and/or modif=
y
  * it under the terms of the GNU General Public License as published b=
y
diff --git a/arch/x86/crypto/serpent_sse2_glue.c b/arch/x86/crypto/serp=
ent_sse2_glue.c
index 97a356e..ebb59fc 100644
--- a/arch/x86/crypto/serpent_sse2_glue.c
+++ b/arch/x86/crypto/serpent_sse2_glue.c
@@ -1,7 +1,7 @@
 /*
  * Glue Code for SSE2 assembler versions of Serpent Cipher
  *
- * Copyright (c) 2011 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ * Copyright (c) 2011 Jussi Kivilinna <jussi.kivilinna@iki.fi>
  *
  * Glue code based on aesni-intel_glue.c by:
  *  Copyright (C) 2008, Intel Corp.
diff --git a/arch/x86/crypto/twofish-avx-x86_64-asm_64.S b/arch/x86/cry=
pto/twofish-avx-x86_64-asm_64.S
index 8d3e113..02007fe 100644
--- a/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
@@ -4,7 +4,7 @@
  * Copyright (C) 2012 Johannes Goetzfried
  *     <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
  *
- * Copyright =C2=A9 2012 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ * Copyright =C2=A9 2012 Jussi Kivilinna <jussi.kivilinna@iki.fi>
  *
  * This program is free software; you can redistribute it and/or modif=
y
  * it under the terms of the GNU General Public License as published b=
y
diff --git a/arch/x86/crypto/twofish-x86_64-asm_64-3way.S b/arch/x86/cr=
ypto/twofish-x86_64-asm_64-3way.S
index 1c3b7ce..206a5a3 100644
--- a/arch/x86/crypto/twofish-x86_64-asm_64-3way.S
+++ b/arch/x86/crypto/twofish-x86_64-asm_64-3way.S
@@ -1,7 +1,7 @@
 /*
  * Twofish Cipher 3-way parallel algorithm (x86_64)
  *
- * Copyright (C) 2011 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ * Copyright (C) 2011 Jussi Kivilinna <jussi.kivilinna@iki.fi>
  *
  * This program is free software; you can redistribute it and/or modif=
y
  * it under the terms of the GNU General Public License as published b=
y
diff --git a/arch/x86/crypto/twofish_glue_3way.c b/arch/x86/crypto/twof=
ish_glue_3way.c
index 13e63b3..7c127a0 100644
--- a/arch/x86/crypto/twofish_glue_3way.c
+++ b/arch/x86/crypto/twofish_glue_3way.c
@@ -1,7 +1,7 @@
 /*
  * Glue Code for 3-way parallel assembler optimized version of Twofish
  *
- * Copyright (c) 2011 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ * Copyright (c) 2011 Jussi Kivilinna <jussi.kivilinna@iki.fi>
  *
  * This program is free software; you can redistribute it and/or modif=
y
  * it under the terms of the GNU General Public License as published b=
y
