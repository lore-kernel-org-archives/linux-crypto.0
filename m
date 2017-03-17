From: Michael Davidson <md@google.com>
Subject: [PATCH 0/7] LLVM: make x86_64 kernel build with clang.
Date: Thu, 16 Mar 2017 17:15:13 -0700
Message-ID: <20170317001520.85223-1-md@google.com>
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
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch set is sufficient to get the x86_64 kernel to build
and boot correctly with clang-3.8 or greater.

The resulting build still has about 300 warnings, very few of
which appear to be significant. Most of them should be fixable
with some minor code refactoring although a few of them, such
as the complaints about implict conversions between enumerated
types may be candidates for just being disabled.

Michael Davidson (7):
  Makefile, LLVM: add -no-integrated-as to KBUILD_[AC]FLAGS
  Makefile, x86, LLVM: disable unsupported optimization flags
  x86, LLVM: suppress clang warnings about unaligned accesses
  x86, boot, LLVM: #undef memcpy etc in string.c
  x86, boot, LLVM: Use regparm=0 for memcpy and memset
  md/raid10, LLVM: get rid of variable length array
  crypto, x86, LLVM: aesni - fix token pasting

 Makefile                                |  4 ++++
 arch/x86/Makefile                       |  7 +++++++
 arch/x86/boot/copy.S                    | 15 +++++++++++++--
 arch/x86/boot/string.c                  |  9 +++++++++
 arch/x86/boot/string.h                  | 13 +++++++++++++
 arch/x86/crypto/aes_ctrby8_avx-x86_64.S |  7 ++-----
 drivers/md/raid10.c                     |  9 ++++-----
 7 files changed, 52 insertions(+), 12 deletions(-)

-- 
2.12.0.367.g23dc2f6d3c-goog

