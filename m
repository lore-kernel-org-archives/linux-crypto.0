Return-Path: <SRS0=ZXsK=OT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47522 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728036AbeLJT6q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Dec 2018 14:58:46 -0500
From: Dave Watson <davejwatson@fb.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Junaid Shahid <junaids@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC: Doron Roberts-Kedes <doronrk@fb.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 05/12] x86/crypto: aesni: Add GCM_COMPLETE macro
Date: Mon, 10 Dec 2018 19:57:49 +0000
Message-ID: <85c7157eb2c38a3bd0d39e17a8156e451fcd13e2.1544471415.git.davejwatson@fb.com>
References: <cover.1544471415.git.davejwatson@fb.com>
In-Reply-To: <cover.1544471415.git.davejwatson@fb.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BE0B978C3C5C3943A0A68A63FC9D3AAA@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Merge encode and decode tag calculations in GCM_COMPLETE macro.
Scatter/gather routines will call this once at the end of encryption
or decryption.

Signed-off-by: Dave Watson <davejwatson@fb.com>
---
 arch/x86/crypto/aesni-intel_avx-x86_64.S | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/crypto/aesni-intel_avx-x86_64.S b/arch/x86/crypto/aes=
ni-intel_avx-x86_64.S
index 2aa11c503bb9..8e9ae4b26118 100644
--- a/arch/x86/crypto/aesni-intel_avx-x86_64.S
+++ b/arch/x86/crypto/aesni-intel_avx-x86_64.S
@@ -510,6 +510,14 @@ _less_than_8_bytes_left\@:
         #############################
=20
 _multiple_of_16_bytes\@:
+        GCM_COMPLETE \GHASH_MUL \REP
+.endm
+
+
+# GCM_COMPLETE Finishes update of tag of last partial block
+# Output: Authorization Tag (AUTH_TAG)
+# Clobbers rax, r10-r12, and xmm0, xmm1, xmm5-xmm15
+.macro GCM_COMPLETE GHASH_MUL REP
         mov     arg8, %r12                           # r12 =3D aadLen (num=
ber of bytes)
         shl     $3, %r12                             # convert into number=
 of bits
         vmovd   %r12d, %xmm15                        # len(A) in xmm15
--=20
2.17.1
