From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: [PATCH 2/2] x86/crypto/sha1-mb: fix panic due to unaligned access
Date: Mon, 16 Oct 2017 18:51:31 +0300
Message-ID: <20171016155131.10118-2-aryabinin@virtuozzo.com>
References: <20171016155131.10118-1-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jeffrey Walton <noloader@gmail.com>,
        Megha Dey <megha.dey@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        stable@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171016155131.10118-1-aryabinin@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

struct sha1_ctx_mgr allocated in sha1_mb_mod_init() via kzalloc()
and later passed in sha1_mb_flusher_mgr_flush_avx2() function where
instructions vmovdqa used to access the struct. vmovdqa requires
16-bytes aligned argument, but nothing guarantees that struct
sha1_ctx_mgr will have that alignment. Unaligned vmovdqa will
generate GP fault.

Fix this by replacing vmovdqa with vmovdqu which doesn't have alignment
requirements.

Fixes: 2249cbb53ead ("crypto: sha-mb - SHA1 multibuffer submit and flush routines for AVX2")
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: <stable@vger.kernel.org>
---
 arch/x86/crypto/sha1-mb/sha1_mb_mgr_flush_avx2.S | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/crypto/sha1-mb/sha1_mb_mgr_flush_avx2.S b/arch/x86/crypto/sha1-mb/sha1_mb_mgr_flush_avx2.S
index 93b945597ecf..7cfba738f104 100644
--- a/arch/x86/crypto/sha1-mb/sha1_mb_mgr_flush_avx2.S
+++ b/arch/x86/crypto/sha1-mb/sha1_mb_mgr_flush_avx2.S
@@ -157,8 +157,8 @@ LABEL skip_ %I
 .endr
 
 	# Find min length
-	vmovdqa _lens+0*16(state), %xmm0
-	vmovdqa _lens+1*16(state), %xmm1
+	vmovdqu _lens+0*16(state), %xmm0
+	vmovdqu _lens+1*16(state), %xmm1
 
 	vpminud %xmm1, %xmm0, %xmm2     # xmm2 has {D,C,B,A}
 	vpalignr $8, %xmm2, %xmm3, %xmm3   # xmm3 has {x,x,D,C}
@@ -178,8 +178,8 @@ LABEL skip_ %I
 	vpsubd  %xmm2, %xmm0, %xmm0
 	vpsubd  %xmm2, %xmm1, %xmm1
 
-	vmovdqa %xmm0, _lens+0*16(state)
-	vmovdqa %xmm1, _lens+1*16(state)
+	vmovdqu %xmm0, _lens+0*16(state)
+	vmovdqu %xmm1, _lens+1*16(state)
 
 	# "state" and "args" are the same address, arg1
 	# len is arg2
@@ -235,8 +235,8 @@ ENTRY(sha1_mb_mgr_get_comp_job_avx2)
 	jc      .return_null
 
 	# Find min length
-	vmovdqa _lens(state), %xmm0
-	vmovdqa _lens+1*16(state), %xmm1
+	vmovdqu _lens(state), %xmm0
+	vmovdqu _lens+1*16(state), %xmm1
 
 	vpminud %xmm1, %xmm0, %xmm2        # xmm2 has {D,C,B,A}
 	vpalignr $8, %xmm2, %xmm3, %xmm3   # xmm3 has {x,x,D,C}
-- 
2.13.6
