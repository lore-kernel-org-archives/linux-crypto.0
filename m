From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v4 10/14] kbuild: Introduce FRAME_WARN_BUMP_FLAG
Date: Wed, 11 Jul 2018 13:36:15 -0700
Message-ID: <20180711203619.1020-11-keescook@chromium.org>
References: <20180711203619.1020-1-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
	Eric Biggers <ebiggers@google.com>, Mike Snitzer <snitzer@redhat.com>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>,
	qat-linux@intel.com, linux-kernel@vger.kernel.org,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	dm-devel@redhat.com, linux-crypto@vger.kernel.org,
	Lars Persson <larper@axis.com>, Tim Chen <tim.c.chen@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>, Alasdair Kergon <agk@redhat.com>,
	Rabin Vincent <rabinv@axis.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180711203619.1020-1-keescook@chromium.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-crypto.vger.kernel.org

When building with CONFIG_FRAME_WARN, it is sometimes useful to
give certain compilation units small additional headroom. This is
normally useful when VLA removal exposes a large stack allocation,
especially with FRAME_WARN at 1024 or smaller. This adds 20%.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 Makefile | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Makefile b/Makefile
index c9132594860b..06fe93edd052 100644
--- a/Makefile
+++ b/Makefile
@@ -684,7 +684,13 @@ endif
 
 ifneq ($(CONFIG_FRAME_WARN),0)
 KBUILD_CFLAGS += $(call cc-option,-Wframe-larger-than=${CONFIG_FRAME_WARN})
+# Small code (mostly exposed by VLA removal) needs some additional
+# headroom, especially for a FRAME_WARN of 1024. This adds 20% which
+# can be used by the CFLAG_FRAME_WARN_BUMP option.
+FRAME_WARN_BUMP_SIZE := $(shell expr $(CONFIG_FRAME_WARN) / 5 + $(CONFIG_FRAME_WARN))
+FRAME_WARN_BUMP_FLAG := $(call cc-option,-Wframe-larger-than=$(FRAME_WARN_BUMP_SIZE))
 endif
+export FRAME_WARN_BUMP_FLAG
 
 stackp-flags-$(CONFIG_CC_HAS_STACKPROTECTOR_NONE) := -fno-stack-protector
 stackp-flags-$(CONFIG_STACKPROTECTOR)             := -fstack-protector
-- 
2.17.1
