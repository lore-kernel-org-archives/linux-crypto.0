From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: [PATCH] crypto: sha256_ssse3 - fix stack corruption with SSSE3 and
 AVX implementations
Date: Tue, 21 May 2013 17:09:41 +0300
Message-ID: <20130521140941.15997.83258.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Julian Wollrath <jwollrath@web.de>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:48903 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab3EUOJo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 May 2013 10:09:44 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The _XFER stack element size was set too small, 8 bytes, when it needs to be
16 bytes. As _XFER is the last stack element used by these implementations,
the 16 byte stores with 'movdqa' corrupt the stack where the value of register
%r12 is temporarily stored. As these implementations align the stack pointer
to 16 bytes, this corruption did not happen every time.

Patch corrects this issue.

Reported-by: Julian Wollrath <jwollrath@web.de>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 arch/x86/crypto/sha256-avx-asm.S   |    2 +-
 arch/x86/crypto/sha256-ssse3-asm.S |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/sha256-avx-asm.S b/arch/x86/crypto/sha256-avx-asm.S
index 56610c4..642f156 100644
--- a/arch/x86/crypto/sha256-avx-asm.S
+++ b/arch/x86/crypto/sha256-avx-asm.S
@@ -118,7 +118,7 @@ y2 = %r15d
 
 _INP_END_SIZE = 8
 _INP_SIZE = 8
-_XFER_SIZE = 8
+_XFER_SIZE = 16
 _XMM_SAVE_SIZE = 0
 
 _INP_END = 0
diff --git a/arch/x86/crypto/sha256-ssse3-asm.S b/arch/x86/crypto/sha256-ssse3-asm.S
index 98d3c39..f833b74 100644
--- a/arch/x86/crypto/sha256-ssse3-asm.S
+++ b/arch/x86/crypto/sha256-ssse3-asm.S
@@ -111,7 +111,7 @@ y2 = %r15d
 
 _INP_END_SIZE = 8
 _INP_SIZE = 8
-_XFER_SIZE = 8
+_XFER_SIZE = 16
 _XMM_SAVE_SIZE = 0
 
 _INP_END = 0
