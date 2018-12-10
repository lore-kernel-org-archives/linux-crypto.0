Return-Path: <SRS0=ZXsK=OT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53116 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727424AbeLJUAF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Dec 2018 15:00:05 -0500
From: Dave Watson <davejwatson@fb.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Junaid Shahid <junaids@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC: Doron Roberts-Kedes <doronrk@fb.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 09/12] x86/crypto: aesni: Move ghash_mul to GCM_COMPLETE
Date: Mon, 10 Dec 2018 19:59:11 +0000
Message-ID: <5869181e33afd1310767c838514a6aa0d255d542.1544471415.git.davejwatson@fb.com>
References: <cover.1544471415.git.davejwatson@fb.com>
In-Reply-To: <cover.1544471415.git.davejwatson@fb.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6C3F153B808E4845BE48C6D99EBD5742@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Prepare to handle partial blocks between scatter/gather calls.
For the last partial block, we only want to calculate the aadhash
in GCM_COMPLETE, and a new partial block macro will handle both
aadhash update and encrypting partial blocks between calls.

Signed-off-by: Dave Watson <davejwatson@fb.com>
---
 arch/x86/crypto/aesni-intel_avx-x86_64.S | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_avx-x86_64.S b/arch/x86/crypto/aes=
ni-intel_avx-x86_64.S
index 0a9cdcfdd987..44a4a8b43ca4 100644
--- a/arch/x86/crypto/aesni-intel_avx-x86_64.S
+++ b/arch/x86/crypto/aesni-intel_avx-x86_64.S
@@ -488,8 +488,7 @@ _final_ghash_mul\@:
         vpand   %xmm1, %xmm2, %xmm2
         vpshufb SHUF_MASK(%rip), %xmm2, %xmm2
         vpxor   %xmm2, %xmm14, %xmm14
-	#GHASH computation for the last <16 Byte block
-        \GHASH_MUL       %xmm14, %xmm13, %xmm0, %xmm10, %xmm11, %xmm5, %xm=
m6
+
         vmovdqu %xmm14, AadHash(arg2)
         sub     %r13, %r11
         add     $16, %r11
@@ -500,8 +499,7 @@ _final_ghash_mul\@:
         vpand   %xmm1, %xmm9, %xmm9                  # mask out top 16-r13=
 bytes of xmm9
         vpshufb SHUF_MASK(%rip), %xmm9, %xmm9
         vpxor   %xmm9, %xmm14, %xmm14
-	#GHASH computation for the last <16 Byte block
-        \GHASH_MUL       %xmm14, %xmm13, %xmm0, %xmm10, %xmm11, %xmm5, %xm=
m6
+
         vmovdqu %xmm14, AadHash(arg2)
         sub     %r13, %r11
         add     $16, %r11
@@ -541,6 +539,14 @@ _multiple_of_16_bytes\@:
         vmovdqu AadHash(arg2), %xmm14
         vmovdqu HashKey(arg2), %xmm13
=20
+        mov PBlockLen(arg2), %r12
+        cmp $0, %r12
+        je _partial_done\@
+
+	#GHASH computation for the last <16 Byte block
+        \GHASH_MUL       %xmm14, %xmm13, %xmm0, %xmm10, %xmm11, %xmm5, %xm=
m6
+
+_partial_done\@:
         mov AadLen(arg2), %r12                          # r12 =3D aadLen (=
number of bytes)
         shl     $3, %r12                             # convert into number=
 of bits
         vmovd   %r12d, %xmm15                        # len(A) in xmm15
--=20
2.17.1
