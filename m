Return-Path: <SRS0=ZXsK=OT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43554 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728567AbeLJT5E (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Dec 2018 14:57:04 -0500
From: Dave Watson <davejwatson@fb.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Junaid Shahid <junaids@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC: Doron Roberts-Kedes <doronrk@fb.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 00/12] x86/crypto: gcmaes AVX scatter/gather support
Date: Mon, 10 Dec 2018 19:56:28 +0000
Message-ID: <cover.1544471415.git.davejwatson@fb.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <914379E01B9F9E4695BA62F75999E850@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch set refactors the x86 aes/gcm AVX crypto routines to
support true scatter/gather by adding gcm_enc/dec_update methods.

It is similar to the previous SSE patchset starting at e1fd316f. =20
Unlike the SSE routines, the AVX routines did not support
keysize 192 & 256, this patchset also adds support for those
keysizes.

The final patch updates the C glue code, passing everything through
the crypt_by_sg() function instead of the previous memcpy based
routines.

Dave Watson (12):
  x86/crypto: aesni: Merge GCM_ENC_DEC
  x86/crypto: aesni: Introduce gcm_context_data
  x86/crypto: aesni: Macro-ify func save/restore
  x86/crypto: aesni: support 256 byte keys in avx asm
  x86/crypto: aesni: Add GCM_COMPLETE macro
  x86/crypto: aesni: Split AAD hash calculation to separate macro
  x86/crypto: aesni: Merge avx precompute functions
  x86/crypto: aesni: Fill in new context data structures
  x86/crypto: aesni: Move ghash_mul to GCM_COMPLETE
  x86/crypto: aesni: Introduce READ_PARTIAL_BLOCK macro
  x86/crypto: aesni: Introduce partial block macro
  x86/crypto: aesni: Add scatter/gather avx stubs, and use them in C

 arch/x86/crypto/aesni-intel_avx-x86_64.S | 2125 ++++++++++------------
 arch/x86/crypto/aesni-intel_glue.c       |  353 ++--
 2 files changed, 1117 insertions(+), 1361 deletions(-)

--=20
2.17.1
