From: Michael Davidson <md@google.com>
Subject: [PATCH 2/7] Makefile, x86, LLVM: disable unsupported optimization flags
Date: Thu, 16 Mar 2017 17:15:15 -0700
Message-ID: <20170317001520.85223-3-md@google.com>
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
Return-path: <linux-kbuild-owner@vger.kernel.org>
In-Reply-To: <20170317001520.85223-1-md@google.com>
Sender: linux-kbuild-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Unfortunately, while clang generates a warning about these flags
being unsupported it still exits with a status of 0 so we have
to explicitly disable them instead of just using a cc-option check.

Signed-off-by: Michael Davidson <md@google.com>
---
 Makefile          | 2 ++
 arch/x86/Makefile | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/Makefile b/Makefile
index b21fd0ca2946..5e97e5fc1eea 100644
--- a/Makefile
+++ b/Makefile
@@ -629,7 +629,9 @@ ARCH_AFLAGS :=
 ARCH_CFLAGS :=
 include arch/$(SRCARCH)/Makefile
 
+ifneq ($(cc-name),clang)
 KBUILD_CFLAGS	+= $(call cc-option,-fno-delete-null-pointer-checks,)
+endif
 KBUILD_CFLAGS	+= $(call cc-disable-warning,frame-address,)
 
 ifdef CONFIG_LD_DEAD_CODE_DATA_ELIMINATION
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 2d449337a360..894a8d18bf97 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -87,11 +87,13 @@ else
         KBUILD_AFLAGS += -m64
         KBUILD_CFLAGS += -m64
 
+ifneq ($(cc-name),clang)
         # Align jump targets to 1 byte, not the default 16 bytes:
         KBUILD_CFLAGS += -falign-jumps=1
 
         # Pack loops tightly as well:
         KBUILD_CFLAGS += -falign-loops=1
+endif
 
         # Don't autogenerate traditional x87 instructions
         KBUILD_CFLAGS += $(call cc-option,-mno-80387)
-- 
2.12.0.367.g23dc2f6d3c-goog

