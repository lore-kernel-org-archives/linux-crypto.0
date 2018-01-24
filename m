From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] crypto: sha512-mb - initialize pending lengths correctly
Date: Wed, 24 Jan 2018 00:31:27 -0800
Message-ID: <20180124083127.11239-1-ebiggers3@gmail.com>
References: <001a113fae28e4fe39055f757ab5@google.com>
Cc: "David S . Miller" <davem@davemloft.net>,
        Megha Dey <megha.dey@linux.intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:42814 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932103AbeAXIgC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Jan 2018 03:36:02 -0500
In-Reply-To: <001a113fae28e4fe39055f757ab5@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

The SHA-512 multibuffer code keeps track of the number of blocks pending
in each lane.  The minimum of these values is used to identify the next
lane that will be completed.  Unused lanes are set to a large number
(0xFFFFFFFF) so that they don't affect this calculation.

However, it was forgotten to set the lengths to this value in the
initial state, where all lanes are unused.  As a result it was possible
for sha512_mb_mgr_get_comp_job_avx2() to select an unused lane, causing
a NULL pointer dereference.  Specifically this could happen in the case
where ->update() was passed fewer than SHA512_BLOCK_SIZE bytes of data,
so it then called sha_complete_job() without having actually submitted
any blocks to the multi-buffer code.  This hit a NULL pointer
dereference if another task happened to have submitted blocks
concurrently to the same CPU and the flush timer had not yet expired.

Fix this by initializing sha512_mb_mgr->lens correctly.

As usual, this bug was found by syzkaller.

Fixes: 45691e2d9b18 ("crypto: sha512-mb - submit/flush routines for AVX2")
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: <stable@vger.kernel.org> # v4.8+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/sha512-mb/sha512_mb_mgr_init_avx2.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/crypto/sha512-mb/sha512_mb_mgr_init_avx2.c b/arch/x86/crypto/sha512-mb/sha512_mb_mgr_init_avx2.c
index 36870b26067a..d08805032f01 100644
--- a/arch/x86/crypto/sha512-mb/sha512_mb_mgr_init_avx2.c
+++ b/arch/x86/crypto/sha512-mb/sha512_mb_mgr_init_avx2.c
@@ -57,10 +57,12 @@ void sha512_mb_mgr_init_avx2(struct sha512_mb_mgr *state)
 {
 	unsigned int j;
 
-	state->lens[0] = 0;
-	state->lens[1] = 1;
-	state->lens[2] = 2;
-	state->lens[3] = 3;
+	/* initially all lanes are unused */
+	state->lens[0] = 0xFFFFFFFF00000000;
+	state->lens[1] = 0xFFFFFFFF00000001;
+	state->lens[2] = 0xFFFFFFFF00000002;
+	state->lens[3] = 0xFFFFFFFF00000003;
+
 	state->unused_lanes = 0xFF03020100;
 	for (j = 0; j < 4; j++)
 		state->ldata[j].job_in_lane = NULL;
-- 
2.16.0
