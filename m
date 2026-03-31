Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18C1368962;
	Tue, 31 Mar 2026 02:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774925150; cv=none; b=oqzVKNaw2LVOd+wLwLPPccvQxuJRF+K5vGao8LtZvdn7yMVj0kpbu8wt1h6YO2ZroDWqH/tiCoWfN33vF8ajhhdypRkZWpkSrd0OZKzA/l62lT06FBKkxD/9hVwho3DibLzaGHR+QS0BgqKD2jV2ZCmKGcooWYDNSNhQW3df6tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774925150; c=relaxed/simple;
	bh=Zk4WrQTTIdYLO7MirDNZSMGBvIM2BIBFlpAB+Vr4q9A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=vANDSr9C1ZPvrpyMBYL3qCUZaZrggpbQLrSLL5ewcfP8zyMTV19mea93vmMQzxKveZjWFT+mtye27lUoDLEwLWGZHZwgRUBOr5OW7rvOTvFeGwQ5Zf6komORdVzlCrMPAcS7sg1G2DE9e1dgMz8ILZM4eD9CQvaYl1lqx/pvMb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hfEIztJq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hfEIztJq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1F3C4CEF7;
	Tue, 31 Mar 2026 02:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774925149;
	bh=Zk4WrQTTIdYLO7MirDNZSMGBvIM2BIBFlpAB+Vr4q9A=;
	h=From:To:Cc:Subject:Date:From;
	b=hfEIztJqUtvxEhwIp6AvEQ7L6q8YJOgakR/i01l7WDAlsGd+22yacM7OTfUR5lfA5
	 wxHv5Shhn/0dSR/gQRWKOgc1022AcV7HnzfwNd5P3qwAOSf97IfHE0QIKFrivAQuOw
	 sp5tAe9bXSlYMhIt82WbRpT2NDUBexm1CACnbqNMQhQgVx0f23AgQdPf0jjCHvn6kd
	 qct7u0/cpg12cla5IOgoG8mYEJ8jjT4TCGfdrXL+tfMknt54vjZi7VLDPIspxqkrfE
	 k1dnMDREuM4O2w60zm2tuFCi24KilNDjmWRy6aFPlGUzMxtHHL5EUdRlskQ3S2xrJP
	 EdzRClSQ7MDSw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: Include <crypto/utils.h> instead of <crypto/algapi.h>
Date: Mon, 30 Mar 2026 19:44:38 -0700
Message-ID: <20260331024438.51783-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since the lib/crypto/ files that include <crypto/algapi.h> need it only
for the transitive inclusion of <crypto/utils.h> (and not all the
traditional crypto API stuff that the rest of <crypto/algapi.h> is
filled with), replace these inclusions with direct inclusions of
<crypto/utils.h>.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/aescfb.c | 2 +-
 lib/crypto/chacha.c | 2 +-
 lib/crypto/memneq.c | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/crypto/aescfb.c b/lib/crypto/aescfb.c
index e38848d101e3..82cd55436055 100644
--- a/lib/crypto/aescfb.c
+++ b/lib/crypto/aescfb.c
@@ -4,11 +4,11 @@
  *
  * Copyright 2023 Google LLC
  */
 
 #include <crypto/aes.h>
-#include <crypto/algapi.h>
+#include <crypto/utils.h>
 #include <linux/export.h>
 #include <linux/module.h>
 
 /**
  * aescfb_encrypt - Perform AES-CFB encryption on a block of data
diff --git a/lib/crypto/chacha.c b/lib/crypto/chacha.c
index e0c7cb4af318..86e5d382a4e0 100644
--- a/lib/crypto/chacha.c
+++ b/lib/crypto/chacha.c
@@ -3,12 +3,12 @@
  * The ChaCha stream cipher (RFC7539)
  *
  * Copyright (C) 2015 Martin Willi
  */
 
-#include <crypto/algapi.h> // for crypto_xor_cpy
 #include <crypto/chacha.h>
+#include <crypto/utils.h>
 #include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 
 static void __maybe_unused
diff --git a/lib/crypto/memneq.c b/lib/crypto/memneq.c
index 44daacb8cb51..08924acd44bc 100644
--- a/lib/crypto/memneq.c
+++ b/lib/crypto/memneq.c
@@ -57,11 +57,11 @@
  * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */
 
-#include <crypto/algapi.h>
+#include <crypto/utils.h>
 #include <linux/export.h>
 #include <linux/module.h>
 #include <linux/unaligned.h>
 
 /* Generic path for arbitrary size */
@@ -157,11 +157,11 @@ static inline unsigned long __crypto_memneq_16(const void *a, const void *b)
 }
 
 /* Compare two areas of memory without leaking timing information,
  * and with special optimizations for common sizes.  Users should
  * not call this function directly, but should instead use
- * crypto_memneq defined in crypto/algapi.h.
+ * crypto_memneq defined in crypto/utils.h.
  */
 noinline unsigned long __crypto_memneq(const void *a, const void *b,
 				       size_t size)
 {
 	switch (size) {

base-commit: d2a68aba8505ce88b39c34ecb3b707c776af79d4
prerequisite-patch-id: bb75bceea1086ce63912baf959cd010cdd451208
prerequisite-patch-id: 0bd0bf7e94c78811a3371910650acf3a62b7de2c
-- 
2.53.0

