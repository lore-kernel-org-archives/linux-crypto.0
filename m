Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4601A254C;
	Fri, 13 Jun 2025 18:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749840564; cv=none; b=AmgcJGkzBe6hvsobX8LHnoBSQS3FL2I2d3IQdznCMI9Y3TqRIqVUh53UNPXS9lQFN178fiw3GOxkQ7O4lPGecV/k8WZA6y/hE6KhwuKyGPEh322vJA2BsFt7drUNqr8SD9qRpRleslMonuwLJnsBGN+/ej/jiNxeAmgAKm+XtaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749840564; c=relaxed/simple;
	bh=Yul0x1DrECLshgFjLIE51vPUKu4ioT0DdsqOpLIn+DY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=siJr8643E4Kf6ZZBSugizizQeqIx1EgpLpRmZ5wW2YKhC1FB5APL0scgZXG+05mFfiqpa/D9Dy9UOEIQTKm8U1pEyaY+ujEwFCbhroXZN5xRI/v+zVGC8ZIm0GNAj2S/bNVW7Yzf0K+X4z223/mvkvoCBnrvzQcSFmVhLwvHhS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L8fnr1FB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L8fnr1FB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE008C4CEE3;
	Fri, 13 Jun 2025 18:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749840563;
	bh=Yul0x1DrECLshgFjLIE51vPUKu4ioT0DdsqOpLIn+DY=;
	h=From:To:Cc:Subject:Date:From;
	b=L8fnr1FBDmYwiGnQcmO6FAmbVnQ65klkuv3yp66e9DjAYsghmVjEva5c2l+8PvUUE
	 XVvcLgn7fpo2+xe07mUegcN3Cx4+Uz4F6rZ6r8MRI7E6D1NORW7aWSRIPBaOTQ1Drv
	 qA5wPhGW6qMmXCFBZ/L9U0rVALWq/Tmq1ggi4CeVpv4tOzXh1lqa6ha8NDl2NIC4lP
	 NV7gjyWSp31F2zqQiQaVAHrWPDpYS+dRxFFPCrPb+xRvCYceHDZVa9ufRbgUWIe9L/
	 LpK9dlqXrANgGD7cTy+mwvrOtFP2G/lzN74h82yauW89Nz3V3myweDR6hYANPCOxri
	 ITz+ClfVs4SmA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	"Jason A . Donenfeld " <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH v2] lib/crypto: explicitly include <linux/export.h>
Date: Fri, 13 Jun 2025 11:48:14 -0700
Message-ID: <20250613184814.50173-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Fix build warnings with W=1 that started appearing after
commit a934a57a42f6 ("scripts/misc-check: check missing #include
<linux/export.h> when W=1").

While at it, also sort the include lists alphabetically.  (Keep
asm/irqflags.h last, as otherwise it doesn't build on alpha.)

This handles all of lib/crypto/, but not arch/*/lib/crypto/.  The
exports in arch/*/lib/crypto/ will go away when the code is properly
integrated into lib/crypto/ as planned.

Signed-off-by: Eric Biggers <ebiggers@google.com>

v2: keep asm/irqflags.h last, to avoid build error on alpha
    (https://lore.kernel.org/all/202506140001.CtqYqDPn-lkp@intel.com/)

---
 lib/crypto/aes.c                | 1 +
 lib/crypto/aescfb.c             | 7 +++----
 lib/crypto/aesgcm.c             | 5 ++---
 lib/crypto/arc4.c               | 1 +
 lib/crypto/blake2s-generic.c    | 9 +++++----
 lib/crypto/blake2s.c            | 9 +++++----
 lib/crypto/chacha.c             | 7 ++++---
 lib/crypto/chacha20poly1305.c   | 8 ++++----
 lib/crypto/curve25519-generic.c | 1 +
 lib/crypto/des.c                | 7 +++----
 lib/crypto/gf128mul.c           | 1 +
 lib/crypto/libchacha.c          | 7 +++----
 lib/crypto/memneq.c             | 3 ++-
 lib/crypto/mpi/mpi-add.c        | 2 ++
 lib/crypto/mpi/mpi-bit.c        | 2 ++
 lib/crypto/mpi/mpi-cmp.c        | 2 ++
 lib/crypto/mpi/mpi-mul.c        | 2 ++
 lib/crypto/mpi/mpi-pow.c        | 2 ++
 lib/crypto/mpi/mpi-sub-ui.c     | 2 ++
 lib/crypto/mpi/mpicoder.c       | 3 ++-
 lib/crypto/mpi/mpiutil.c        | 2 ++
 lib/crypto/poly1305-donna32.c   | 3 ++-
 lib/crypto/poly1305-donna64.c   | 3 ++-
 lib/crypto/poly1305-generic.c   | 1 +
 lib/crypto/poly1305.c           | 1 +
 lib/crypto/sha1.c               | 6 +++---
 lib/crypto/sha256-generic.c     | 1 +
 lib/crypto/sha256.c             | 1 +
 lib/crypto/sm3.c                | 1 +
 lib/crypto/utils.c              | 3 ++-
 30 files changed, 65 insertions(+), 38 deletions(-)

diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
index eafe14d021f5a..b57fda3460f1b 100644
--- a/lib/crypto/aes.c
+++ b/lib/crypto/aes.c
@@ -3,10 +3,11 @@
  * Copyright (C) 2017-2019 Linaro Ltd <ard.biesheuvel@linaro.org>
  */
 
 #include <crypto/aes.h>
 #include <linux/crypto.h>
+#include <linux/export.h>
 #include <linux/module.h>
 #include <linux/unaligned.h>
 
 /*
  * Emit the sbox as volatile const to prevent the compiler from doing
diff --git a/lib/crypto/aescfb.c b/lib/crypto/aescfb.c
index 437613265e14f..035140b2e7789 100644
--- a/lib/crypto/aescfb.c
+++ b/lib/crypto/aescfb.c
@@ -3,15 +3,14 @@
  * Minimal library implementation of AES in CFB mode
  *
  * Copyright 2023 Google LLC
  */
 
-#include <linux/module.h>
-
-#include <crypto/algapi.h>
 #include <crypto/aes.h>
-
+#include <crypto/algapi.h>
+#include <linux/export.h>
+#include <linux/module.h>
 #include <asm/irqflags.h>
 
 static void aescfb_encrypt_block(const struct crypto_aes_ctx *ctx, void *dst,
 				 const void *src)
 {
diff --git a/lib/crypto/aesgcm.c b/lib/crypto/aesgcm.c
index 277824d6b4af7..57e631a8ea3f3 100644
--- a/lib/crypto/aesgcm.c
+++ b/lib/crypto/aesgcm.c
@@ -3,16 +3,15 @@
  * Minimal library implementation of GCM
  *
  * Copyright 2022 Google LLC
  */
 
-#include <linux/module.h>
-
 #include <crypto/algapi.h>
 #include <crypto/gcm.h>
 #include <crypto/ghash.h>
-
+#include <linux/export.h>
+#include <linux/module.h>
 #include <asm/irqflags.h>
 
 static void aesgcm_encrypt_block(const struct crypto_aes_ctx *ctx, void *dst,
 				 const void *src)
 {
diff --git a/lib/crypto/arc4.c b/lib/crypto/arc4.c
index 838812d182164..4e950e1e66d08 100644
--- a/lib/crypto/arc4.c
+++ b/lib/crypto/arc4.c
@@ -6,10 +6,11 @@
  *
  * Jon Oberheide <jon@oberheide.org>
  */
 
 #include <crypto/arc4.h>
+#include <linux/export.h>
 #include <linux/module.h>
 
 int arc4_setkey(struct arc4_ctx *ctx, const u8 *in_key, unsigned int key_len)
 {
 	int i, j = 0, k = 0;
diff --git a/lib/crypto/blake2s-generic.c b/lib/crypto/blake2s-generic.c
index 09682136b57c6..9828176a2efec 100644
--- a/lib/crypto/blake2s-generic.c
+++ b/lib/crypto/blake2s-generic.c
@@ -7,15 +7,16 @@
  * Information: https://blake2.net/
  *
  */
 
 #include <crypto/internal/blake2s.h>
-#include <linux/types.h>
-#include <linux/string.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/bug.h>
+#include <linux/export.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/types.h>
 #include <linux/unaligned.h>
 
 static const u8 blake2s_sigma[10][16] = {
 	{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
 	{ 14, 10, 4, 8, 9, 15, 13, 6, 1, 12, 0, 2, 11, 7, 5, 3 },
diff --git a/lib/crypto/blake2s.c b/lib/crypto/blake2s.c
index b0f9a678300b3..f6ec68c3dcdae 100644
--- a/lib/crypto/blake2s.c
+++ b/lib/crypto/blake2s.c
@@ -7,16 +7,17 @@
  * Information: https://blake2.net/
  *
  */
 
 #include <crypto/internal/blake2s.h>
-#include <linux/types.h>
-#include <linux/string.h>
+#include <linux/bug.h>
+#include <linux/export.h>
+#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
-#include <linux/bug.h>
+#include <linux/string.h>
+#include <linux/types.h>
 
 static inline void blake2s_set_lastblock(struct blake2s_state *state)
 {
 	state->f[0] = -1;
 }
diff --git a/lib/crypto/chacha.c b/lib/crypto/chacha.c
index ced87dd31a97f..5962e65c5a9fd 100644
--- a/lib/crypto/chacha.c
+++ b/lib/crypto/chacha.c
@@ -3,17 +3,18 @@
  * The "hash function" used as the core of the ChaCha stream cipher (RFC7539)
  *
  * Copyright (C) 2015 Martin Willi
  */
 
+#include <crypto/chacha.h>
+#include <linux/bitops.h>
 #include <linux/bug.h>
-#include <linux/kernel.h>
 #include <linux/export.h>
-#include <linux/bitops.h>
+#include <linux/export.h>
+#include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/unaligned.h>
-#include <crypto/chacha.h>
 
 static void chacha_permute(struct chacha_state *state, int nrounds)
 {
 	u32 *x = state->x;
 	int i;
diff --git a/lib/crypto/chacha20poly1305.c b/lib/crypto/chacha20poly1305.c
index e29eed49a5a14..0b49d6aedefdd 100644
--- a/lib/crypto/chacha20poly1305.c
+++ b/lib/crypto/chacha20poly1305.c
@@ -5,20 +5,20 @@
  * This is an implementation of the ChaCha20Poly1305 AEAD construction.
  *
  * Information: https://tools.ietf.org/html/rfc8439
  */
 
-#include <crypto/chacha20poly1305.h>
 #include <crypto/chacha.h>
+#include <crypto/chacha20poly1305.h>
 #include <crypto/poly1305.h>
 #include <crypto/utils.h>
-
-#include <linux/unaligned.h>
-#include <linux/kernel.h>
+#include <linux/export.h>
 #include <linux/init.h>
+#include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/unaligned.h>
 
 static void chacha_load_key(u32 *k, const u8 *in)
 {
 	k[0] = get_unaligned_le32(in);
 	k[1] = get_unaligned_le32(in + 4);
diff --git a/lib/crypto/curve25519-generic.c b/lib/crypto/curve25519-generic.c
index de7c99172fa25..f8aa70c9f5598 100644
--- a/lib/crypto/curve25519-generic.c
+++ b/lib/crypto/curve25519-generic.c
@@ -8,10 +8,11 @@
  *
  * Information: https://cr.yp.to/ecdh.html
  */
 
 #include <crypto/curve25519.h>
+#include <linux/export.h>
 #include <linux/module.h>
 
 const u8 curve25519_null_point[CURVE25519_KEY_SIZE] __aligned(32) = { 0 };
 const u8 curve25519_base_point[CURVE25519_KEY_SIZE] __aligned(32) = { 9 };
 
diff --git a/lib/crypto/des.c b/lib/crypto/des.c
index d3423b34a8e9b..a906070136dc3 100644
--- a/lib/crypto/des.c
+++ b/lib/crypto/des.c
@@ -5,25 +5,24 @@
  * DES & Triple DES EDE Cipher Algorithms.
  *
  * Copyright (c) 2005 Dag Arne Osvik <da@osvik.no>
  */
 
+#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <linux/bitops.h>
 #include <linux/compiler.h>
 #include <linux/crypto.h>
 #include <linux/errno.h>
+#include <linux/export.h>
 #include <linux/fips.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/types.h>
-
 #include <linux/unaligned.h>
 
-#include <crypto/des.h>
-#include <crypto/internal/des.h>
-
 #define ROL(x, r) ((x) = rol32((x), (r)))
 #define ROR(x, r) ((x) = ror32((x), (r)))
 
 /* Lookup tables for key expansion */
 
diff --git a/lib/crypto/gf128mul.c b/lib/crypto/gf128mul.c
index fbe72cb3453a5..2a34590fe3f10 100644
--- a/lib/crypto/gf128mul.c
+++ b/lib/crypto/gf128mul.c
@@ -47,10 +47,11 @@
  This file provides fast multiplication in GF(2^128) as required by several
  cryptographic authentication modes
 */
 
 #include <crypto/gf128mul.h>
+#include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 
 #define gf128mul_dat(q) { \
diff --git a/lib/crypto/libchacha.c b/lib/crypto/libchacha.c
index ebcca381e248a..26862ad90a964 100644
--- a/lib/crypto/libchacha.c
+++ b/lib/crypto/libchacha.c
@@ -3,16 +3,15 @@
  * The ChaCha stream cipher (RFC7539)
  *
  * Copyright (C) 2015 Martin Willi
  */
 
-#include <linux/kernel.h>
-#include <linux/export.h>
-#include <linux/module.h>
-
 #include <crypto/algapi.h> // for crypto_xor_cpy
 #include <crypto/chacha.h>
+#include <linux/export.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 
 void chacha_crypt_generic(struct chacha_state *state, u8 *dst, const u8 *src,
 			  unsigned int bytes, int nrounds)
 {
 	/* aligned to potentially speed up crypto_xor() */
diff --git a/lib/crypto/memneq.c b/lib/crypto/memneq.c
index a2afd10349c92..44daacb8cb513 100644
--- a/lib/crypto/memneq.c
+++ b/lib/crypto/memneq.c
@@ -57,13 +57,14 @@
  * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */
 
-#include <linux/unaligned.h>
 #include <crypto/algapi.h>
+#include <linux/export.h>
 #include <linux/module.h>
+#include <linux/unaligned.h>
 
 /* Generic path for arbitrary size */
 static inline unsigned long
 __crypto_memneq_generic(const void *a, const void *b, size_t size)
 {
diff --git a/lib/crypto/mpi/mpi-add.c b/lib/crypto/mpi/mpi-add.c
index 3015140d48602..c0375c1672fa3 100644
--- a/lib/crypto/mpi/mpi-add.c
+++ b/lib/crypto/mpi/mpi-add.c
@@ -9,10 +9,12 @@
  *	 way the data is stored; this is to support the abstraction
  *	 of an optional secure memory allocation which may be used
  *	 to avoid revealing of sensitive data due to paging etc.
  */
 
+#include <linux/export.h>
+
 #include "mpi-internal.h"
 
 int mpi_add(MPI w, MPI u, MPI v)
 {
 	mpi_ptr_t wp, up, vp;
diff --git a/lib/crypto/mpi/mpi-bit.c b/lib/crypto/mpi/mpi-bit.c
index 934d813113606..b3d0e7ddbc03d 100644
--- a/lib/crypto/mpi/mpi-bit.c
+++ b/lib/crypto/mpi/mpi-bit.c
@@ -16,10 +16,12 @@
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
  */
 
+#include <linux/export.h>
+
 #include "mpi-internal.h"
 #include "longlong.h"
 
 #define A_LIMB_1 ((mpi_limb_t) 1)
 
diff --git a/lib/crypto/mpi/mpi-cmp.c b/lib/crypto/mpi/mpi-cmp.c
index ceaebe181cd70..b42929296bcef 100644
--- a/lib/crypto/mpi/mpi-cmp.c
+++ b/lib/crypto/mpi/mpi-cmp.c
@@ -16,10 +16,12 @@
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
  */
 
+#include <linux/export.h>
+
 #include "mpi-internal.h"
 
 int mpi_cmp_ui(MPI u, unsigned long v)
 {
 	mpi_limb_t limb = v;
diff --git a/lib/crypto/mpi/mpi-mul.c b/lib/crypto/mpi/mpi-mul.c
index 7e6ff1ce3e9b6..d79f186ad90bc 100644
--- a/lib/crypto/mpi/mpi-mul.c
+++ b/lib/crypto/mpi/mpi-mul.c
@@ -9,10 +9,12 @@
  *	 way the data is stored; this is to support the abstraction
  *	 of an optional secure memory allocation which may be used
  *	 to avoid revealing of sensitive data due to paging etc.
  */
 
+#include <linux/export.h>
+
 #include "mpi-internal.h"
 
 int mpi_mul(MPI w, MPI u, MPI v)
 {
 	mpi_size_t usize, vsize, wsize;
diff --git a/lib/crypto/mpi/mpi-pow.c b/lib/crypto/mpi/mpi-pow.c
index 67fbd4c2503d0..9e695a3bda3a0 100644
--- a/lib/crypto/mpi/mpi-pow.c
+++ b/lib/crypto/mpi/mpi-pow.c
@@ -11,12 +11,14 @@
  *	 to avoid revealing of sensitive data due to paging etc.
  *	 The GNU MP Library itself is published under the LGPL;
  *	 however I decided to publish this code under the plain GPL.
  */
 
+#include <linux/export.h>
 #include <linux/sched.h>
 #include <linux/string.h>
+
 #include "mpi-internal.h"
 #include "longlong.h"
 
 /****************
  * RES = BASE ^ EXP mod MOD
diff --git a/lib/crypto/mpi/mpi-sub-ui.c b/lib/crypto/mpi/mpi-sub-ui.c
index b41b082b5f3e3..0edcdbd24833a 100644
--- a/lib/crypto/mpi/mpi-sub-ui.c
+++ b/lib/crypto/mpi/mpi-sub-ui.c
@@ -30,10 +30,12 @@
  * You should have received copies of the GNU General Public License and the
  * GNU Lesser General Public License along with the GNU MP Library.  If not,
  * see https://www.gnu.org/licenses/.
  */
 
+#include <linux/export.h>
+
 #include "mpi-internal.h"
 
 int mpi_sub_ui(MPI w, MPI u, unsigned long vval)
 {
 	if (u->nlimbs == 0) {
diff --git a/lib/crypto/mpi/mpicoder.c b/lib/crypto/mpi/mpicoder.c
index dde01030807de..47f6939599b33 100644
--- a/lib/crypto/mpi/mpicoder.c
+++ b/lib/crypto/mpi/mpicoder.c
@@ -17,12 +17,13 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
  */
 
 #include <linux/bitops.h>
-#include <linux/count_zeros.h>
 #include <linux/byteorder/generic.h>
+#include <linux/count_zeros.h>
+#include <linux/export.h>
 #include <linux/scatterlist.h>
 #include <linux/string.h>
 #include "mpi-internal.h"
 
 #define MAX_EXTERN_MPI_BITS 16384
diff --git a/lib/crypto/mpi/mpiutil.c b/lib/crypto/mpi/mpiutil.c
index 979ece5a81d25..7f2db830f4043 100644
--- a/lib/crypto/mpi/mpiutil.c
+++ b/lib/crypto/mpi/mpiutil.c
@@ -16,10 +16,12 @@
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
  */
 
+#include <linux/export.h>
+
 #include "mpi-internal.h"
 
 /****************
  * Note:  It was a bad idea to use the number of limbs to allocate
  *	  because on a alpha the limbs are large but we normally need
diff --git a/lib/crypto/poly1305-donna32.c b/lib/crypto/poly1305-donna32.c
index 0a4a2d99e3654..b66131b3f6d4b 100644
--- a/lib/crypto/poly1305-donna32.c
+++ b/lib/crypto/poly1305-donna32.c
@@ -4,13 +4,14 @@
  *
  * This is based in part on Andrew Moon's poly1305-donna, which is in the
  * public domain.
  */
 
+#include <crypto/internal/poly1305.h>
+#include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/unaligned.h>
-#include <crypto/internal/poly1305.h>
 
 void poly1305_core_setkey(struct poly1305_core_key *key,
 			  const u8 raw_key[POLY1305_BLOCK_SIZE])
 {
 	/* r &= 0xffffffc0ffffffc0ffffffc0fffffff */
diff --git a/lib/crypto/poly1305-donna64.c b/lib/crypto/poly1305-donna64.c
index 530287531b2ee..8a72a5a849446 100644
--- a/lib/crypto/poly1305-donna64.c
+++ b/lib/crypto/poly1305-donna64.c
@@ -4,13 +4,14 @@
  *
  * This is based in part on Andrew Moon's poly1305-donna, which is in the
  * public domain.
  */
 
+#include <crypto/internal/poly1305.h>
+#include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/unaligned.h>
-#include <crypto/internal/poly1305.h>
 
 void poly1305_core_setkey(struct poly1305_core_key *key,
 			  const u8 raw_key[POLY1305_BLOCK_SIZE])
 {
 	u64 t0, t1;
diff --git a/lib/crypto/poly1305-generic.c b/lib/crypto/poly1305-generic.c
index a73f700fa1fb8..71a16c5c538b4 100644
--- a/lib/crypto/poly1305-generic.c
+++ b/lib/crypto/poly1305-generic.c
@@ -6,10 +6,11 @@
  *
  * Based on public domain code by Andrew Moon and Daniel J. Bernstein.
  */
 
 #include <crypto/internal/poly1305.h>
+#include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 
 void poly1305_block_init_generic(struct poly1305_block_state *desc,
 				 const u8 raw_key[POLY1305_BLOCK_SIZE])
diff --git a/lib/crypto/poly1305.c b/lib/crypto/poly1305.c
index 5f2f2af3b59f8..a6dc182b6c22d 100644
--- a/lib/crypto/poly1305.c
+++ b/lib/crypto/poly1305.c
@@ -7,10 +7,11 @@
  * Based on public domain code by Andrew Moon and Daniel J. Bernstein.
  */
 
 #include <crypto/internal/blockhash.h>
 #include <crypto/internal/poly1305.h>
+#include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/unaligned.h>
 
diff --git a/lib/crypto/sha1.c b/lib/crypto/sha1.c
index ebb60519ae939..6d809c3088be3 100644
--- a/lib/crypto/sha1.c
+++ b/lib/crypto/sha1.c
@@ -4,16 +4,16 @@
  * and to avoid unnecessary copies into the context array.
  *
  * This was based on the git SHA1 implementation.
  */
 
-#include <linux/kernel.h>
+#include <crypto/sha1.h>
+#include <linux/bitops.h>
 #include <linux/export.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/bitops.h>
 #include <linux/string.h>
-#include <crypto/sha1.h>
 #include <linux/unaligned.h>
 
 /*
  * If you have 32 registers or more, the compiler can (and should)
  * try to change the array[] accesses into registers. However, on
diff --git a/lib/crypto/sha256-generic.c b/lib/crypto/sha256-generic.c
index a16ad4f25ebb7..2968d95d04038 100644
--- a/lib/crypto/sha256-generic.c
+++ b/lib/crypto/sha256-generic.c
@@ -10,10 +10,11 @@
  * Copyright (c) 2002 James Morris <jmorris@intercode.com.au>
  * Copyright (c) 2014 Red Hat Inc.
  */
 
 #include <crypto/internal/sha2.h>
+#include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/unaligned.h>
 
diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
index 107e5162507a7..6bfa4ae8dfb59 100644
--- a/lib/crypto/sha256.c
+++ b/lib/crypto/sha256.c
@@ -11,10 +11,11 @@
  * Copyright (c) 2014 Red Hat Inc.
  */
 
 #include <crypto/internal/blockhash.h>
 #include <crypto/internal/sha2.h>
+#include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
 
 /*
diff --git a/lib/crypto/sm3.c b/lib/crypto/sm3.c
index efff0e267d84d..c6b9ad8a3ac66 100644
--- a/lib/crypto/sm3.c
+++ b/lib/crypto/sm3.c
@@ -7,10 +7,11 @@
  * Copyright (C) 2017 Gilad Ben-Yossef <gilad@benyossef.com>
  * Copyright (C) 2021 Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
  */
 
 #include <crypto/sm3.h>
+#include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/unaligned.h>
 
diff --git a/lib/crypto/utils.c b/lib/crypto/utils.c
index 87da2a6dd161e..dec381d5e9065 100644
--- a/lib/crypto/utils.c
+++ b/lib/crypto/utils.c
@@ -3,13 +3,14 @@
  * Crypto library utility functions
  *
  * Copyright (c) 2006 Herbert Xu <herbert@gondor.apana.org.au>
  */
 
-#include <linux/unaligned.h>
 #include <crypto/utils.h>
+#include <linux/export.h>
 #include <linux/module.h>
+#include <linux/unaligned.h>
 
 /*
  * XOR @len bytes from @src1 and @src2 together, writing the result to @dst
  * (which may alias one of the sources).  Don't call this directly; call
  * crypto_xor() or crypto_xor_cpy() instead.

base-commit: 19272b37aa4f83ca52bdf9c16d5d81bdd1354494
-- 
2.49.0

