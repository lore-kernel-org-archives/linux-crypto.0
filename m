From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH v2 00/12] x86/crypto: Fix RBP usage in several crypto .S files
Date: Mon, 18 Sep 2017 14:41:59 -0500
Message-ID: <cover.1505763153.git.jpoimboe@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Mathias Krause <minipli@googlemail.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>, Jiri Slaby <jslaby@suse.cz>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

v2:
- fix performance issues in sha256-avx2-asm.S and sha512-avx2-asm.S
  (Eric)

Many of the x86 crypto functions use RBP as a temporary register.  This
breaks frame pointer convention, and breaks stack traces when unwinding
from an interrupt in the crypto code.

Convert most* of them to leave RBP alone.

These pass the crypto boot tests for me.  Any further testing would be
appreciated!

[*] There are still a few crypto files left that need fixing, but the
    fixes weren't trivial and nobody reported unwinder warnings about
    them yet, so I'm skipping them for now.

Josh Poimboeuf (12):
  x86/crypto: Fix RBP usage in blowfish-x86_64-asm_64.S
  x86/crypto: Fix RBP usage in camellia-x86_64-asm_64.S
  x86/crypto: Fix RBP usage in cast5-avx-x86_64-asm_64.S
  x86/crypto: Fix RBP usage in cast6-avx-x86_64-asm_64.S
  x86/crypto: Fix RBP usage in des3_ede-asm_64.S
  x86/crypto: Fix RBP usage in sha1_avx2_x86_64_asm.S
  x86/crypto: Fix RBP usage in sha1_ssse3_asm.S
  x86/crypto: Fix RBP usage in sha256-avx-asm.S
  x86/crypto: Fix RBP usage in sha256-avx2-asm.S
  x86/crypto: Fix RBP usage in sha256-ssse3-asm.S
  x86/crypto: Fix RBP usage in sha512-avx2-asm.S
  x86/crypto: Fix RBP usage in twofish-avx-x86_64-asm_64.S

 arch/x86/crypto/blowfish-x86_64-asm_64.S    | 48 +++++++++---------
 arch/x86/crypto/camellia-x86_64-asm_64.S    | 26 +++++-----
 arch/x86/crypto/cast5-avx-x86_64-asm_64.S   | 47 +++++++++++-------
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S   | 50 +++++++++++++------
 arch/x86/crypto/des3_ede-asm_64.S           | 15 +++---
 arch/x86/crypto/sha1_avx2_x86_64_asm.S      |  4 +-
 arch/x86/crypto/sha1_ssse3_asm.S            | 11 ++---
 arch/x86/crypto/sha256-avx-asm.S            | 15 +++---
 arch/x86/crypto/sha256-avx2-asm.S           | 22 +++------
 arch/x86/crypto/sha256-ssse3-asm.S          | 15 +++---
 arch/x86/crypto/sha512-avx2-asm.S           | 75 +++++++++++++++--------------
 arch/x86/crypto/twofish-avx-x86_64-asm_64.S | 12 ++---
 12 files changed, 184 insertions(+), 156 deletions(-)

-- 
2.13.5
