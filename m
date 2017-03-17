From: Michael Davidson <md@google.com>
Subject: [PATCH 3/7] x86, LLVM: suppress clang warnings about unaligned accesses
Date: Thu, 16 Mar 2017 17:15:16 -0700
Message-ID: <20170317001520.85223-4-md@google.com>
References: <20170317001520.85223-1-md@google.com>
Cc: Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Matthias Kaehlcke <mka@chromium.org>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org,
        Michael Davidson <md@google.com>
To: Michal Marek <mmarek@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Shaohua Li <shli@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170317001520.85223-1-md@google.com>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Suppress clang warnings about potential unaliged accesses
to members in packed structs. This gets rid of almost 10,000
warnings about accesses to the ring 0 stack pointer in the TSS.

Signed-off-by: Michael Davidson <md@google.com>
---
 arch/x86/Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 894a8d18bf97..7f21703c475d 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -128,6 +128,11 @@ endif
         KBUILD_CFLAGS += $(call cc-option,-maccumulate-outgoing-args)
 endif
 
+ifeq ($(cc-name),clang)
+# Suppress clang warnings about potential unaligned accesses.
+KBUILD_CFLAGS += $(call cc-disable-warning, address-of-packed-member)
+endif
+
 ifdef CONFIG_X86_X32
 	x32_ld_ok := $(call try-run,\
 			/bin/echo -e '1: .quad 1b' | \
-- 
2.12.0.367.g23dc2f6d3c-goog

