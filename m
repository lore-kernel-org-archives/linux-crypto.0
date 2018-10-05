From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 1/9] kernel: add support for patchable function pointers
Date: Fri,  5 Oct 2018 10:13:25 +0200
Message-ID: <20181005081333.15018-2-ard.biesheuvel@linaro.org>
References: <20181005081333.15018-1-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andy Lutomirski <luto@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181005081333.15018-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add a function pointer abstraction that can be implemented by the arch
in a manner that avoids the downsides of function pointers, i.e., the
fact that they are typically located in a writable data section, and
their vulnerability to Spectre like defects.

The FFP (or fast function pointer) is callable as a function, since
the generic incarnation is simply that. However, due to the fact that
C does not distinguish between functions and function pointers at the
call site, the architecture can instead emit it as a patchable sequence
of instructions consisting of ordinary branches.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/Kconfig        |  3 ++
 include/linux/ffp.h | 43 ++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/arch/Kconfig b/arch/Kconfig
index 6801123932a5..2af3442a61d3 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -862,6 +862,9 @@ config HAVE_ARCH_PREL32_RELOCATIONS
 	  architectures, and don't require runtime relocation on relocatable
 	  kernels.
 
+config HAVE_ARCH_FFP
+	bool
+
 source "kernel/gcov/Kconfig"
 
 source "scripts/gcc-plugins/Kconfig"
diff --git a/include/linux/ffp.h b/include/linux/ffp.h
new file mode 100644
index 000000000000..8fc3b4c9b38f
--- /dev/null
+++ b/include/linux/ffp.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __LINUX_FFP_H
+#define __LINUX_FFP_H
+
+#include <linux/types.h>
+#include <linux/compiler.h>
+
+#ifdef CONFIG_HAVE_ARCH_FFP
+#include <asm/ffp.h>
+#else
+
+struct ffp {
+	void	(**fn)(void);
+	void	(*default_fn)(void);
+};
+
+#define DECLARE_FFP(_fn, _def)						\
+	extern typeof(_def) *_fn;					\
+	extern struct ffp const __ffp_ ## _fn
+
+#define DEFINE_FFP(_fn, _def)						\
+	typeof(_def) *_fn = &_def;					\
+	struct ffp const __ffp_ ## _fn					\
+		= { (void(**)(void))&_fn, (void(*)(void))&_def };	\
+	EXPORT_SYMBOL(__ffp_ ## _fn)
+
+static inline void ffp_set_target(const struct ffp *m, void *new_fn)
+{
+	WRITE_ONCE(*m->fn, new_fn);
+}
+
+static inline void ffp_reset_target(const struct ffp *m)
+{
+	WRITE_ONCE(*m->fn, m->default_fn);
+}
+
+#endif
+
+#define SET_FFP(_fn, _new)	ffp_set_target(&__ffp_ ## _fn, _new)
+#define RESET_FFP(_fn)		ffp_reset_target(&__ffp_ ## _fn)
+
+#endif
-- 
2.11.0
