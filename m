Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1105FC433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 22:39:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6B7522571
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 22:39:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbgLWWjm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Dec 2020 17:39:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:59208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725811AbgLWWjm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Dec 2020 17:39:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB3A322273;
        Wed, 23 Dec 2020 22:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608763140;
        bh=0MbCcCmyG2J0vKLMvj0T420mPbqg0OGMmaFqvD2qC+M=;
        h=From:To:Cc:Subject:Date:From;
        b=iCN/cs8nX9i/zsgLfpunfNkjsC+lJFZfoAIc0+ZkMHplaUyS1X665+6hXZEdQYNYV
         t3ZjHfatim88YY3TOFvXr63ZPob5rjz5NDSSX8X+yhQVC+Y+iD6IlG89GVFoB77fV1
         2AwQkff7/HempggHD9b3u0MAwif4421qsm6cJbj2pnMUBDM6jqZpXnVfoDxRg6qoSD
         kq7deVSGkVuBQeb8l/iM6U1JyAF6P4SKvrf9hooA+urGR9fpzIeL76WFuSqEncjxm4
         Rz+eZ3e+S79pn1oRwZxVZu5GeqVCjS3Nbv5eeT8fSuYH3kx9mxnxoPAjl8aL8mU2By
         fkbZbv0Bry4xw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     dm-devel@redhat.com, Ard Biesheuvel <ardb@kernel.org>,
        Megha Dey <megha.dey@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [RFC PATCH 00/10] crypto: x86 - remove XTS and CTR glue helper code
Date:   Wed, 23 Dec 2020 23:38:31 +0100
Message-Id: <20201223223841.11311-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

After applying my performance fixes for AES-NI in XTS mode, the only
remaining users of the x86 glue helper module are the niche algorithms
camellia, cast6, serpent and twofish.

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
if necessary.

XTS mode may actually be in use by dm-crypt users, so we cannot simply drop
this code entirely. However, as it turns out, the XTS template wrapped
around the ECB mode skciphers perform roughly on par *, and so there is no
need to retain all the complicated XTS helper logic. In the unlikely case
that dm-crypt users are relying on xts(camellia) or xts(serpent) in the
field, they should not be impacted by these changes at all.

As a follow-up, it makes sense to rework the ECB and CBC mode implementations
to get rid of the indirect calls. Or perhaps we could drop [some of] these
algorithms entirely ...

* tcrypt results for various XTS implementations below, captured on a
  Intel(R) Core(TM) i7-8650U CPU @ 1.90GHz

Cc: Megha Dey <megha.dey@intel.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Milan Broz <gmazyland@gmail.com>
Cc: Mike Snitzer <snitzer@redhat.com>

Ard Biesheuvel (10):
  crypto: x86/camellia - switch to XTS template
  crypto: x86/cast6 - switch to XTS template
  crypto: x86/serpent- switch to XTS template
  crypto: x86/twofish - switch to XTS template
  crypto: x86/glue-helper - drop XTS helper routines
  crypto: x86/camellia - drop CTR mode implementation
  crypto: x86/cast6 - drop CTR mode implementation
  crypto: x86/serpent - drop CTR mode implementation
  crypto: x86/twofish - drop CTR mode implementation
  crypto: x86/glue-helper - drop CTR helper routines

 arch/x86/crypto/camellia-aesni-avx-asm_64.S  | 297 ----------------
 arch/x86/crypto/camellia-aesni-avx2-asm_64.S | 350 -------------------
 arch/x86/crypto/camellia_aesni_avx2_glue.c   | 111 ------
 arch/x86/crypto/camellia_aesni_avx_glue.c    | 141 +-------
 arch/x86/crypto/camellia_glue.c              |  68 ----
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S    |  84 -----
 arch/x86/crypto/cast6_avx_glue.c             | 146 --------
 arch/x86/crypto/glue_helper-asm-avx.S        | 104 ------
 arch/x86/crypto/glue_helper-asm-avx2.S       | 136 -------
 arch/x86/crypto/glue_helper.c                | 226 ------------
 arch/x86/crypto/serpent-avx-x86_64-asm_64.S  |  68 ----
 arch/x86/crypto/serpent-avx2-asm_64.S        |  87 -----
 arch/x86/crypto/serpent_avx2_glue.c          | 110 ------
 arch/x86/crypto/serpent_avx_glue.c           | 152 --------
 arch/x86/crypto/serpent_sse2_glue.c          |  67 ----
 arch/x86/crypto/twofish-avx-x86_64-asm_64.S  |  80 -----
 arch/x86/crypto/twofish_avx_glue.c           | 136 -------
 arch/x86/crypto/twofish_glue_3way.c          |  72 ----
 arch/x86/include/asm/crypto/camellia.h       |  24 --
 arch/x86/include/asm/crypto/glue_helper.h    |  44 ---
 arch/x86/include/asm/crypto/serpent-avx.h    |  21 --
 arch/x86/include/asm/crypto/twofish.h        |   4 -
 22 files changed, 1 insertion(+), 2527 deletions(-)

-- 
2.17.1



testing speed of async xts(camellia) (xts-camellia-aesni-avx2) encryption
tcrypt: test 0 (256 bit key, 16 byte blocks): 4295101 operations in 1 seconds (68721616 bytes)
tcrypt: test 1 (256 bit key, 64 byte blocks): 2029490 operations in 1 seconds (129887360 bytes)
tcrypt: test 2 (256 bit key, 256 byte blocks): 1626076 operations in 1 seconds (416275456 bytes)
tcrypt: test 3 (256 bit key, 1024 byte blocks): 732878 operations in 1 seconds (750467072 bytes)
tcrypt: test 4 (256 bit key, 1424 byte blocks): 366313 operations in 1 seconds (521629712 bytes)
tcrypt: test 5 (256 bit key, 4096 byte blocks): 161737 operations in 1 seconds (662474752 bytes)
tcrypt: test 6 (512 bit key, 16 byte blocks): 3876371 operations in 1 seconds (62021936 bytes)
tcrypt: test 7 (512 bit key, 64 byte blocks): 1787813 operations in 1 seconds (114420032 bytes)
tcrypt: test 8 (512 bit key, 256 byte blocks): 1578834 operations in 1 seconds (404181504 bytes)
tcrypt: test 9 (512 bit key, 1024 byte blocks): 766805 operations in 1 seconds (785208320 bytes)
tcrypt: test 10 (512 bit key, 1424 byte blocks): 366645 operations in 1 seconds (522102480 bytes)
tcrypt: test 11 (512 bit key, 4096 byte blocks): 151122 operations in 1 seconds (618995712 bytes)
tcrypt: 


testing speed of async xts(camellia) (xts(ecb-camellia-aesni-avx2)) encryption
tcrypt: test 0 (256 bit key, 16 byte blocks): 3981536 operations in 1 seconds (63704576 bytes)
tcrypt: test 1 (256 bit key, 64 byte blocks): 2696005 operations in 1 seconds (172544320 bytes)
tcrypt: test 2 (256 bit key, 256 byte blocks): 1048119 operations in 1 seconds (268318464 bytes)
tcrypt: test 3 (256 bit key, 1024 byte blocks): 716732 operations in 1 seconds (733933568 bytes)
tcrypt: test 4 (256 bit key, 1424 byte blocks): 440474 operations in 1 seconds (627234976 bytes)
tcrypt: test 5 (256 bit key, 4096 byte blocks): 178906 operations in 1 seconds (732798976 bytes)
tcrypt: test 6 (512 bit key, 16 byte blocks): 3119162 operations in 1 seconds (49906592 bytes)
tcrypt: test 7 (512 bit key, 64 byte blocks): 2286596 operations in 1 seconds (146342144 bytes)
tcrypt: test 8 (512 bit key, 256 byte blocks): 1408661 operations in 1 seconds (360617216 bytes)
tcrypt: test 9 (512 bit key, 1024 byte blocks): 669226 operations in 1 seconds (685287424 bytes)
tcrypt: test 10 (512 bit key, 1424 byte blocks): 380543 operations in 1 seconds (541893232 bytes)
tcrypt: test 11 (512 bit key, 4096 byte blocks): 144126 operations in 1 seconds (590340096 bytes)


testing speed of async xts(camellia) (xts-camellia-aesni) encryption
tcrypt: test 0 (256 bit key, 16 byte blocks): 3901755 operations in 1 seconds (62428080 bytes)
tcrypt: test 1 (256 bit key, 64 byte blocks): 1719855 operations in 1 seconds (110070720 bytes)
tcrypt: test 2 (256 bit key, 256 byte blocks): 1416991 operations in 1 seconds (362749696 bytes)
tcrypt: test 3 (256 bit key, 1024 byte blocks): 481186 operations in 1 seconds (492734464 bytes)
tcrypt: test 4 (256 bit key, 1424 byte blocks): 298401 operations in 1 seconds (424923024 bytes)
tcrypt: test 5 (256 bit key, 4096 byte blocks): 120284 operations in 1 seconds (492683264 bytes)
tcrypt: test 6 (512 bit key, 16 byte blocks): 3326174 operations in 1 seconds (53218784 bytes)
tcrypt: test 7 (512 bit key, 64 byte blocks): 1428259 operations in 1 seconds (91408576 bytes)
tcrypt: test 8 (512 bit key, 256 byte blocks): 1175894 operations in 1 seconds (301028864 bytes)
tcrypt: test 9 (512 bit key, 1024 byte blocks): 407066 operations in 1 seconds (416835584 bytes)
tcrypt: test 10 (512 bit key, 1424 byte blocks): 242931 operations in 1 seconds (345933744 bytes)
tcrypt: test 11 (512 bit key, 4096 byte blocks): 95871 operations in 1 seconds (392687616 bytes)


testing speed of async xts(camellia) (xts(ecb-camellia-aesni)) encryption
tcrypt: test 0 (256 bit key, 16 byte blocks): 4004035 operations in 1 seconds (64064560 bytes)
tcrypt: test 1 (256 bit key, 64 byte blocks): 2757081 operations in 1 seconds (176453184 bytes)
tcrypt: test 2 (256 bit key, 256 byte blocks): 1626720 operations in 1 seconds (416440320 bytes)
tcrypt: test 3 (256 bit key, 1024 byte blocks): 577725 operations in 1 seconds (591590400 bytes)
tcrypt: test 4 (256 bit key, 1424 byte blocks): 393937 operations in 1 seconds (560966288 bytes)
tcrypt: test 5 (256 bit key, 4096 byte blocks): 150055 operations in 1 seconds (614625280 bytes)
tcrypt: test 6 (512 bit key, 16 byte blocks): 3427619 operations in 1 seconds (54841904 bytes)
tcrypt: test 7 (512 bit key, 64 byte blocks): 2335827 operations in 1 seconds (149492928 bytes)
tcrypt: test 8 (512 bit key, 256 byte blocks): 1412725 operations in 1 seconds (361657600 bytes)
tcrypt: test 9 (512 bit key, 1024 byte blocks): 466635 operations in 1 seconds (477834240 bytes)
tcrypt: test 10 (512 bit key, 1424 byte blocks): 314378 operations in 1 seconds (447674272 bytes)
tcrypt: test 11 (512 bit key, 4096 byte blocks): 119159 operations in 1 seconds (488075264 bytes)


testing speed of async xts(serpent) (xts-serpent-avx2) encryption
tcrypt: test 0 (256 bit key, 16 byte blocks): 2665863 operations in 1 seconds (42653808 bytes)
tcrypt: test 1 (256 bit key, 64 byte blocks): 1151015 operations in 1 seconds (73664960 bytes)
tcrypt: test 2 (256 bit key, 256 byte blocks): 1824753 operations in 1 seconds (467136768 bytes)
tcrypt: test 3 (256 bit key, 1024 byte blocks): 674375 operations in 1 seconds (690560000 bytes)
tcrypt: test 4 (256 bit key, 1424 byte blocks): 434324 operations in 1 seconds (618477376 bytes)
tcrypt: test 5 (256 bit key, 4096 byte blocks): 143875 operations in 1 seconds (589312000 bytes)
tcrypt: test 6 (512 bit key, 16 byte blocks): 2676467 operations in 1 seconds (42823472 bytes)
tcrypt: test 7 (512 bit key, 64 byte blocks): 1161001 operations in 1 seconds (74304064 bytes)
tcrypt: test 8 (512 bit key, 256 byte blocks): 1830401 operations in 1 seconds (468582656 bytes)
tcrypt: test 9 (512 bit key, 1024 byte blocks): 675560 operations in 1 seconds (691773440 bytes)
tcrypt: test 10 (512 bit key, 1424 byte blocks): 431292 operations in 1 seconds (614159808 bytes)
tcrypt: test 11 (512 bit key, 4096 byte blocks): 135674 operations in 1 seconds (555720704 bytes)


testing speed of async xts(serpent) (xts(ecb-serpent-avx2)) encryption
tcrypt: test 0 (256 bit key, 16 byte blocks): 2327282 operations in 1 seconds (37236512 bytes)
tcrypt: test 1 (256 bit key, 64 byte blocks): 1121913 operations in 1 seconds (71802432 bytes)
tcrypt: test 2 (256 bit key, 256 byte blocks): 1549949 operations in 1 seconds (396786944 bytes)
tcrypt: test 3 (256 bit key, 1024 byte blocks): 597772 operations in 1 seconds (612118528 bytes)
tcrypt: test 4 (256 bit key, 1424 byte blocks): 397386 operations in 1 seconds (565877664 bytes)
tcrypt: test 5 (256 bit key, 4096 byte blocks): 140785 operations in 1 seconds (576655360 bytes)
tcrypt: test 6 (512 bit key, 16 byte blocks): 2335122 operations in 1 seconds (37361952 bytes)
tcrypt: test 7 (512 bit key, 64 byte blocks): 1123595 operations in 1 seconds (71910080 bytes)
tcrypt: test 8 (512 bit key, 256 byte blocks): 1557279 operations in 1 seconds (398663424 bytes)
tcrypt: test 9 (512 bit key, 1024 byte blocks): 595629 operations in 1 seconds (609924096 bytes)
tcrypt: test 10 (512 bit key, 1424 byte blocks): 396338 operations in 1 seconds (564385312 bytes)
tcrypt: test 11 (512 bit key, 4096 byte blocks): 139501 operations in 1 seconds (571396096 bytes)


testing speed of async xts(serpent) (xts-serpent-avx) encryption
tcrypt: test 0 (256 bit key, 16 byte blocks): 2718471 operations in 1 seconds (43495536 bytes)
tcrypt: test 1 (256 bit key, 64 byte blocks): 1164397 operations in 1 seconds (74521408 bytes)
tcrypt: test 2 (256 bit key, 256 byte blocks): 1189326 operations in 1 seconds (304467456 bytes)
tcrypt: test 3 (256 bit key, 1024 byte blocks): 375279 operations in 1 seconds (384285696 bytes)
tcrypt: test 4 (256 bit key, 1424 byte blocks): 260853 operations in 1 seconds (371454672 bytes)
tcrypt: test 5 (256 bit key, 4096 byte blocks): 91367 operations in 1 seconds (374239232 bytes)
tcrypt: test 6 (512 bit key, 16 byte blocks): 2679109 operations in 1 seconds (42865744 bytes)
tcrypt: test 7 (512 bit key, 64 byte blocks): 1149832 operations in 1 seconds (73589248 bytes)
tcrypt: test 8 (512 bit key, 256 byte blocks): 1180177 operations in 1 seconds (302125312 bytes)
tcrypt: test 9 (512 bit key, 1024 byte blocks): 363975 operations in 1 seconds (372710400 bytes)
tcrypt: test 10 (512 bit key, 1424 byte blocks): 267386 operations in 1 seconds (380757664 bytes)
tcrypt: test 11 (512 bit key, 4096 byte blocks): 86933 operations in 1 seconds (356077568 bytes)


testing speed of async xts(serpent) (xts(ecb-serpent-avx)) encryption
tcrypt: test 0 (256 bit key, 16 byte blocks): 2408371 operations in 1 seconds (38533936 bytes)
tcrypt: test 1 (256 bit key, 64 byte blocks): 1141626 operations in 1 seconds (73064064 bytes)
tcrypt: test 2 (256 bit key, 256 byte blocks): 1072850 operations in 1 seconds (274649600 bytes)
tcrypt: test 3 (256 bit key, 1024 byte blocks): 348694 operations in 1 seconds (357062656 bytes)
tcrypt: test 4 (256 bit key, 1424 byte blocks): 250621 operations in 1 seconds (356884304 bytes)
tcrypt: test 5 (256 bit key, 4096 byte blocks): 86043 operations in 1 seconds (352432128 bytes)
tcrypt: test 6 (512 bit key, 16 byte blocks): 2406501 operations in 1 seconds (38504016 bytes)
tcrypt: test 7 (512 bit key, 64 byte blocks): 1146211 operations in 1 seconds (73357504 bytes)
tcrypt: test 8 (512 bit key, 256 byte blocks): 1075147 operations in 1 seconds (275237632 bytes)
tcrypt: test 9 (512 bit key, 1024 byte blocks): 348007 operations in 1 seconds (356359168 bytes)
tcrypt: test 10 (512 bit key, 1424 byte blocks): 250311 operations in 1 seconds (356442864 bytes)
tcrypt: test 11 (512 bit key, 4096 byte blocks): 86062 operations in 1 seconds (352509952 bytes
