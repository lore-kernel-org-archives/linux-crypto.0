From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 0/3] crypto: x86/sha1 - regression and other fixes
Date: Mon, 24 Mar 2014 17:10:36 +0100
Message-ID: <1395677439-7478-1-git-send-email-minipli@googlemail.com>
Cc: linux-crypto@vger.kernel.org,
	Mathias Krause <minipli@googlemail.com>,
	Chandramouli Narayanan <mouli@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Marek Vasut <marex@denx.de>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:48382 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412AbaCXQKs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Mar 2014 12:10:48 -0400
Received: by mail-bk0-f41.google.com with SMTP id d7so569958bkh.14
        for <linux-crypto@vger.kernel.org>; Mon, 24 Mar 2014 09:10:47 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The recent addition of the AVX2 variant of the SHA1 hash function wrongly
disabled the AVX variant by introducing a flaw in the feature test. Fixed
in patch 1.

The alignment calculations of the AVX2 assembler implementation are
questionable, too. Especially the page alignment of the stack pointer is
broken in multiple ways. Fixed in patch 2. In patch 3 another issue for
code alignment is fixed.

Please apply!

Mathias Krause (3):
  crypto: x86/sha1 - re-enable the AVX variant
  crypto: x86/sha1 - fix stack alignment of AVX2 variant
  crypto: x86/sha1 - reduce size of the AVX2 asm implementation

 arch/x86/crypto/sha1_avx2_x86_64_asm.S |    8 ++------
 arch/x86/crypto/sha1_ssse3_glue.c      |   26 ++++++++++++++++----------
 2 files changed, 18 insertions(+), 16 deletions(-)

-- 
1.7.10.4
