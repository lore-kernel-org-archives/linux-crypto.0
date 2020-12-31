Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F403BC433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 17:24:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7440223E4
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 17:24:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgLaRYc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Dec 2020 12:24:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:54682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726540AbgLaRYc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Dec 2020 12:24:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 610DC20BED;
        Thu, 31 Dec 2020 17:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609435431;
        bh=kCl9XXCgNnRc2wccWhKw/T35vuhaHSn5/OYaUvMqgDE=;
        h=From:To:Cc:Subject:Date:From;
        b=BybSsvOvm1SN4pjX3Iyya0JSfIf3UhZGVUaWINnirMnWLyIZl/eC28a9Crm86ERiO
         BLgaRwykO/O3wRX+g4/VuVO4iNTw7h8h5wmbVvqV8skgmqEuN/aw/yX2OOU9A2o1wN
         rSVKOhSFWtCdBnSB8rPeK3e4r0VsT5W8+wMK9t45xyhJu+zbe+/7HW2fIRwthppRfJ
         EVanmZ44M/IsLc/TaVhygnNSaMQIGaTC9LRXVquFX6tciR5CdEFuDVKTxKz3kPYEt0
         PT71v+lqFNLGrTfRD4TyrUSkbTWtT/gqo/r1AS7JmcEIwUjcpVv1DWSXwSzGh5E5Mp
         Clowf1+ZWQCyQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 00/21] crypto: x86 - remove glue helper module
Date:   Thu, 31 Dec 2020 18:23:16 +0100
Message-Id: <20201231172337.23073-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

NOTE: this is a follow-up to '[RFC PATCH 00/10] crypto: x86 - remove XTS and
CTR glue helper code' [0].

After applying my performance fixes for AES-NI in XTS mode, the only
remaining users of the x86 glue helper module are the niche algorithms
camellia, cast5/6, serpent and twofish.

It is not clear from the history why all these different versions of these
algorithms in XTS and CTR modes were added in the first place: the only
in-kernel references that seem to exist are to cbc(serpent), cbc(camellia)
and cbc(twofish) in the IPsec stack. The XTS spec only mentions AES, and
CTR modes don't seem to be widely used either.

Since the glue helper code relies heavily on indirect calls for small chunks
of in/output, it needs some work to recover from the performance hit caused
by the retpoline changes. However, it makes sense to only expend the effort
for algorithms that are being used in the first place, and this does not
seem to be the case for XTS and CTR.

CTR mode can simply be removed: it is not used in the kernel, and it is
highly unlikely that it is being relied upon via algif_skcipher. And even
if it was, the generic CTR mode driver can still provide the CTR transforms
if necessary. While at it, accelerated implementations of DES and Blowfish
in CTR mode are removed as well, for the same reasons.

XTS mode may actually be in use by dm-crypt users *, so we cannot simply drop
this code entirely. However, as it turns out, the XTS template wrapped
around the ECB mode skciphers perform roughly on par, and so there is no
need to retain all the complicated XTS helper logic. Users of dm-crypt that
are relying on xts(camellia) or xts(serpent) in the field should not be
impacted by these changes at all.

ECB and CBC are retained, but the glue helper indirection is replaced with
a set of preprocessor macros which can be used to instantiate the same logic
flow, but without relying on indirect calls into the glue helper module.
Please refer to patch #14 for more background.

* Milan points out that Serpent, Camellia and Twofish in XTS mode are used
  by TrueCrypt/Veracrypt, which means that dm-crypt should retain support
  for these algorithms as well.

[0] https://lore.kernel.org/linux-crypto/20201223223841.11311-1-ardb@kernel.org/

Changes since RFC:
- add Eric's ack to the initial XTS and CTR patches
- add patches to convert ECB and CBC modes
- add patches to remove DES and Blowfish in CTR mode

Cc: Megha Dey <megha.dey@intel.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Milan Broz <gmazyland@gmail.com>
Cc: Mike Snitzer <snitzer@redhat.com>

Ard Biesheuvel (21):
  crypto: x86/camellia - switch to XTS template
  crypto: x86/cast6 - switch to XTS template
  crypto: x86/serpent- switch to XTS template
  crypto: x86/twofish - switch to XTS template
  crypto: x86/glue-helper - drop XTS helper routines
  crypto: x86/camellia - drop CTR mode implementation
  crypto: x86/serpent - drop CTR mode implementation
  crypto: x86/cast5 - drop CTR mode implementation
  crypto: x86/cast6 - drop CTR mode implementation
  crypto: x86/twofish - drop CTR mode implementation
  crypto: x86/glue-helper - drop CTR helper routines
  crypto: x86/des - drop CTR mode implementation
  crypto: x86/blowfish - drop CTR mode implementation
  crypto: x86 - add some helper macros for ECB and CBC modes
  crypto: x86/camellia - drop dependency on glue helper
  crypto: x86/serpent - drop dependency on glue helper
  crypto: x86/cast5 - drop dependency on glue helper
  crypto: x86/cast6 - drop dependency on glue helper
  crypto: x86/twofish - drop dependency on glue helper
  crypto: x86 - remove glue helper module
  crypto: x86 - use local headers for x86 specific shared declarations

 arch/x86/crypto/Makefile                      |   2 -
 arch/x86/crypto/blowfish_glue.c               | 107 -----
 arch/x86/crypto/camellia-aesni-avx-asm_64.S   | 298 --------------
 arch/x86/crypto/camellia-aesni-avx2-asm_64.S  | 351 ----------------
 arch/x86/{include/asm => }/crypto/camellia.h  |  24 --
 arch/x86/crypto/camellia_aesni_avx2_glue.c    | 198 ++-------
 arch/x86/crypto/camellia_aesni_avx_glue.c     | 216 +---------
 arch/x86/crypto/camellia_glue.c               | 131 +-----
 arch/x86/crypto/cast5_avx_glue.c              | 287 +------------
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S     |  84 ----
 arch/x86/crypto/cast6_avx_glue.c              | 207 +---------
 arch/x86/crypto/des3_ede_glue.c               | 104 -----
 arch/x86/crypto/ecb_cbc_helpers.h             |  71 ++++
 arch/x86/crypto/glue_helper-asm-avx.S         | 104 -----
 arch/x86/crypto/glue_helper-asm-avx2.S        | 136 -------
 arch/x86/crypto/glue_helper.c                 | 381 ------------------
 arch/x86/crypto/serpent-avx-x86_64-asm_64.S   |  68 ----
 arch/x86/crypto/serpent-avx.h                 |  21 +
 arch/x86/crypto/serpent-avx2-asm_64.S         |  87 ----
 .../{include/asm => }/crypto/serpent-sse2.h   |   0
 arch/x86/crypto/serpent_avx2_glue.c           | 185 +--------
 arch/x86/crypto/serpent_avx_glue.c            | 215 +---------
 arch/x86/crypto/serpent_sse2_glue.c           | 150 ++-----
 arch/x86/crypto/twofish-avx-x86_64-asm_64.S   |  80 ----
 arch/x86/{include/asm => }/crypto/twofish.h   |   4 -
 arch/x86/crypto/twofish_avx_glue.c            | 211 +---------
 arch/x86/crypto/twofish_glue_3way.c           | 160 ++------
 arch/x86/include/asm/crypto/glue_helper.h     | 118 ------
 arch/x86/include/asm/crypto/serpent-avx.h     |  42 --
 crypto/Kconfig                                |  30 +-
 crypto/skcipher.c                             |   6 -
 include/crypto/internal/skcipher.h            |   1 -
 32 files changed, 314 insertions(+), 3765 deletions(-)
 rename arch/x86/{include/asm => }/crypto/camellia.h (69%)
 create mode 100644 arch/x86/crypto/ecb_cbc_helpers.h
 delete mode 100644 arch/x86/crypto/glue_helper.c
 create mode 100644 arch/x86/crypto/serpent-avx.h
 rename arch/x86/{include/asm => }/crypto/serpent-sse2.h (100%)
 rename arch/x86/{include/asm => }/crypto/twofish.h (80%)
 delete mode 100644 arch/x86/include/asm/crypto/glue_helper.h
 delete mode 100644 arch/x86/include/asm/crypto/serpent-avx.h

-- 
2.17.1

