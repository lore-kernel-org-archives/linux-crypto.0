From: Laura Abbott <labbott@redhat.com>
Subject: [PATCH] crypto: Pad aes_ccm_enc_tv_template vector
Date: Tue, 28 Feb 2017 14:07:25 -0800
Message-ID: <1488319645-29129-1-git-send-email-labbott@redhat.com>
Cc: Laura Abbott <labbott@redhat.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:36861 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751767AbdB1WQH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Feb 2017 17:16:07 -0500
Received: by mail-qk0-f172.google.com with SMTP id n186so40540573qkb.3
        for <linux-crypto@vger.kernel.org>; Tue, 28 Feb 2017 14:15:56 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Running with KASAN and crypto tests currently gives

 BUG: KASAN: global-out-of-bounds in __test_aead+0x9d9/0x2200 at addr ffffffff8212fca0
 Read of size 16 by task cryptomgr_test/1107
 Address belongs to variable 0xffffffff8212fca0
 CPU: 0 PID: 1107 Comm: cryptomgr_test Not tainted 4.10.0+ #45
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.1-1.fc24 04/01/2014
 Call Trace:
  dump_stack+0x63/0x8a
  kasan_report.part.1+0x4a7/0x4e0
  ? __test_aead+0x9d9/0x2200
  ? crypto_ccm_init_crypt+0x218/0x3c0 [ccm]
  kasan_report+0x20/0x30
  check_memory_region+0x13c/0x1a0
  memcpy+0x23/0x50
  __test_aead+0x9d9/0x2200
  ? kasan_unpoison_shadow+0x35/0x50
  ? alg_test_akcipher+0xf0/0xf0
  ? crypto_skcipher_init_tfm+0x2e3/0x310
  ? crypto_spawn_tfm2+0x37/0x60
  ? crypto_ccm_init_tfm+0xa9/0xd0 [ccm]
  ? crypto_aead_init_tfm+0x7b/0x90
  ? crypto_alloc_tfm+0xc4/0x190
  test_aead+0x28/0xc0
  alg_test_aead+0x54/0xd0
  alg_test+0x1eb/0x3d0
  ? alg_find_test+0x90/0x90
  ? __sched_text_start+0x8/0x8
  ? __wake_up_common+0x70/0xb0
  cryptomgr_test+0x4d/0x60
  kthread+0x173/0x1c0
  ? crypto_acomp_scomp_free_ctx+0x60/0x60
  ? kthread_create_on_node+0xa0/0xa0
  ret_from_fork+0x2c/0x40
 Memory state around the buggy address:
  ffffffff8212fb80: 00 00 00 00 01 fa fa fa fa fa fa fa 00 00 00 00
  ffffffff8212fc00: 00 01 fa fa fa fa fa fa 00 00 00 00 01 fa fa fa
 >ffffffff8212fc80: fa fa fa fa 00 05 fa fa fa fa fa fa 00 00 00 00
                                   ^
  ffffffff8212fd00: 01 fa fa fa fa fa fa fa 00 00 00 00 01 fa fa fa
  ffffffff8212fd80: fa fa fa fa 00 00 00 00 00 05 fa fa fa fa fa fa

This always happens on the same IV which is less than 16 bytes.

Per Ard,

"CCM IVs are 16 bytes, but due to the way they are constructed
internally, the final couple of bytes of input IV are dont-cares.

Apparently, we do read all 16 bytes, which triggers the KASAN errors."

Fix this by padding the IV with null bytes to be at least 16 bytes.

Fixes: 0bc5a6c5c79a ("crypto: testmgr - Disable rfc4309 test and convert
test vectors")
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Laura Abbott <labbott@redhat.com>
---
 crypto/testmgr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 006ecc4..03f4731 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -22691,7 +22691,7 @@ static struct aead_testvec aes_ccm_enc_tv_template[] = {
 			  "\x09\x75\x9a\x9b\x3c\x9b\x27\x39",
 		.klen	= 32,
 		.iv	= "\x03\xf9\xd9\x4e\x63\xb5\x3d\x9d"
-			  "\x43\xf6\x1e\x50",
+			  "\x43\xf6\x1e\x50\0\0\0\0",
 		.assoc	= "\x57\xf5\x6b\x8b\x57\x5c\x3d\x3b"
 			  "\x13\x02\x01\x0c\x83\x4c\x96\x35"
 			  "\x8e\xd6\x39\xcf\x7d\x14\x9b\x94"
-- 
2.7.4
