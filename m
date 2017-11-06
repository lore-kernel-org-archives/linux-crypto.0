From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH v2 2/5] crypto: dh - Don't permit 'p' to be 0
Date: Sun,  5 Nov 2017 18:30:45 -0800
Message-ID: <20171106023048.8067-3-ebiggers3@gmail.com>
References: <20171106023048.8067-1-ebiggers3@gmail.com>
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Salvatore Benedetto <salvatore.benedetto@intel.com>,
        Tudor-Dan Ambarus <tudor.ambarus@microchip.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Stephan Mueller <smueller@chronox.de>, qat-linux@intel.com,
        keyrings@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        stable@vger.kernel.org
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:56763 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751134AbdKFCbW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 5 Nov 2017 21:31:22 -0500
In-Reply-To: <20171106023048.8067-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

If 'p' is 0 for the software Diffie-Hellman implementation, then
dh_max_size() returns 0.  In the case of KEYCTL_DH_COMPUTE, this causes
ZERO_SIZE_PTR to be passed to sg_init_one(), which with
CONFIG_DEBUG_SG=y triggers the 'BUG_ON(!virt_addr_valid(buf));' in
sg_set_buf().

Fix this by making crypto_dh_decode_key() reject 0 for 'p'.  p=0 makes
no sense for any DH implementation because 'p' is supposed to be a prime
number.  Moreover, 'mod 0' is not mathematically defined.

Bug report:

    kernel BUG at ./include/linux/scatterlist.h:140!
    invalid opcode: 0000 [#1] SMP KASAN
    CPU: 0 PID: 27112 Comm: syz-executor2 Not tainted 4.14.0-rc7-00010-gf5dbb5d0ce32-dirty #7
    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.3-20171021_125229-anatol 04/01/2014
    task: ffff88006caac0c0 task.stack: ffff88006c7c8000
    RIP: 0010:sg_set_buf include/linux/scatterlist.h:140 [inline]
    RIP: 0010:sg_init_one+0x1b3/0x240 lib/scatterlist.c:156
    RSP: 0018:ffff88006c7cfb08 EFLAGS: 00010216
    RAX: 0000000000010000 RBX: ffff88006c7cfe30 RCX: 00000000000064ee
    RDX: ffffffff81cf64c3 RSI: ffffc90000d72000 RDI: ffffffff92e937e0
    RBP: ffff88006c7cfb30 R08: ffffed000d8f9fab R09: ffff88006c7cfd30
    R10: 0000000000000005 R11: ffffed000d8f9faa R12: ffff88006c7cfd30
    R13: 0000000000000000 R14: 0000000000000010 R15: ffff88006c7cfc50
    FS:  00007fce190fa700(0000) GS:ffff88003ea00000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: 00007fffc6b33db8 CR3: 000000003cf64000 CR4: 00000000000006f0
    Call Trace:
     __keyctl_dh_compute+0xa95/0x19b0 security/keys/dh.c:360
     keyctl_dh_compute+0xac/0x100 security/keys/dh.c:434
     SYSC_keyctl security/keys/keyctl.c:1745 [inline]
     SyS_keyctl+0x72/0x2c0 security/keys/keyctl.c:1641
     entry_SYSCALL_64_fastpath+0x1f/0xbe
    RIP: 0033:0x4585c9
    RSP: 002b:00007fce190f9bd8 EFLAGS: 00000216 ORIG_RAX: 00000000000000fa
    RAX: ffffffffffffffda RBX: 0000000000738020 RCX: 00000000004585c9
    RDX: 000000002000d000 RSI: 0000000020000ff4 RDI: 0000000000000017
    RBP: 0000000000000046 R08: 0000000020008000 R09: 0000000000000000
    R10: 0000000000000000 R11: 0000000000000216 R12: 00007fff6e610cde
    R13: 00007fff6e610cdf R14: 00007fce190fa700 R15: 0000000000000000
    Code: 03 0f b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 04 84 d2 75 33 5b 45 89 6c 24 14 41 5c 41 5d 41 5e 41 5f 5d c3 e8 fd 8f 68 ff <0f> 0b e8 f6 8f 68 ff 0f 0b e8 ef 8f 68 ff 0f 0b e8 e8 8f 68 ff 20
    RIP: sg_set_buf include/linux/scatterlist.h:140 [inline] RSP: ffff88006c7cfb08
    RIP: sg_init_one+0x1b3/0x240 lib/scatterlist.c:156 RSP: ffff88006c7cfb08

Fixes: 802c7f1c84e4 ("crypto: dh - Add DH software implementation")
Cc: <stable@vger.kernel.org> # v4.8+
Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/dh_helper.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/crypto/dh_helper.c b/crypto/dh_helper.c
index 8ba8a3f82620..708ae20d2d3c 100644
--- a/crypto/dh_helper.c
+++ b/crypto/dh_helper.c
@@ -90,6 +90,14 @@ int crypto_dh_decode_key(const char *buf, unsigned int len, struct dh *params)
 	params->p = (void *)(ptr + params->key_size);
 	params->g = (void *)(ptr + params->key_size + params->p_size);
 
+	/*
+	 * Don't permit 'p' to be 0.  It's not a prime number, and it's subject
+	 * to corner cases such as 'mod 0' being undefined or
+	 * crypto_kpp_maxsize() returning 0.
+	 */
+	if (memchr_inv(params->p, 0, params->p_size) == NULL)
+		return -EINVAL;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(crypto_dh_decode_key);
-- 
2.15.0
