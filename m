From: Laura Abbott <labbott@redhat.com>
Subject: [PATCHv2] crypto: testmgr: Use heap buffer for acomp test input
Date: Wed, 21 Dec 2016 12:32:54 -0800
Message-ID: <1482352374-22750-1-git-send-email-labbott@redhat.com>
Cc: Laura Abbott <labbott@redhat.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Christopher Covington <cov@codeaurora.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:36822 "EHLO
        mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751316AbcLUUdX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Dec 2016 15:33:23 -0500
Received: by mail-qt0-f172.google.com with SMTP id w33so216799152qtc.3
        for <linux-crypto@vger.kernel.org>; Wed, 21 Dec 2016 12:33:22 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Christopher Covington reported a crash on aarch64 on recent Fedora
kernels:

kernel BUG at ./include/linux/scatterlist.h:140!
Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
Modules linked in:
CPU: 2 PID: 752 Comm: cryptomgr_test Not tainted 4.9.0-11815-ge93b1cc #162
Hardware name: linux,dummy-virt (DT)
task: ffff80007c650080 task.stack: ffff800008910000
PC is at sg_init_one+0xa0/0xb8
LR is at sg_init_one+0x24/0xb8
...
[<ffff000008398db8>] sg_init_one+0xa0/0xb8
[<ffff000008350a44>] test_acomp+0x10c/0x438
[<ffff000008350e20>] alg_test_comp+0xb0/0x118
[<ffff00000834f28c>] alg_test+0x17c/0x2f0
[<ffff00000834c6a4>] cryptomgr_test+0x44/0x50
[<ffff0000080dac70>] kthread+0xf8/0x128
[<ffff000008082ec0>] ret_from_fork+0x10/0x50

The test vectors used for input are part of the kernel image. These
inputs are passed as a buffer to sg_init_one which eventually blows up
with BUG_ON(!virt_addr_valid(buf)). On arm64, virt_addr_valid returns
false for the kernel image since virt_to_page will not return the
correct page. Fix this by copying the input vectors to heap buffer
before setting up the scatterlist.

Reported-by: Christopher Covington <cov@codeaurora.org>
Fixes: d7db7a882deb ("crypto: acomp - update testmgr with support for acomp")
Signed-off-by: Laura Abbott <labbott@redhat.com>
---
 crypto/testmgr.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index f616ad7..44e888b 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1461,16 +1461,25 @@ static int test_acomp(struct crypto_acomp *tfm, struct comp_testvec *ctemplate,
 	for (i = 0; i < ctcount; i++) {
 		unsigned int dlen = COMP_BUF_SIZE;
 		int ilen = ctemplate[i].inlen;
+		void *input_vec;
 
+		input_vec = kmalloc(ilen, GFP_KERNEL);
+		if (!input_vec) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		memcpy(input_vec, ctemplate[i].input, ilen);
 		memset(output, 0, dlen);
 		init_completion(&result.completion);
-		sg_init_one(&src, ctemplate[i].input, ilen);
+		sg_init_one(&src, input_vec, ilen);
 		sg_init_one(&dst, output, dlen);
 
 		req = acomp_request_alloc(tfm);
 		if (!req) {
 			pr_err("alg: acomp: request alloc failed for %s\n",
 			       algo);
+			kfree(input_vec);
 			ret = -ENOMEM;
 			goto out;
 		}
@@ -1483,6 +1492,7 @@ static int test_acomp(struct crypto_acomp *tfm, struct comp_testvec *ctemplate,
 		if (ret) {
 			pr_err("alg: acomp: compression failed on test %d for %s: ret=%d\n",
 			       i + 1, algo, -ret);
+			kfree(input_vec);
 			acomp_request_free(req);
 			goto out;
 		}
@@ -1491,6 +1501,7 @@ static int test_acomp(struct crypto_acomp *tfm, struct comp_testvec *ctemplate,
 			pr_err("alg: acomp: Compression test %d failed for %s: output len = %d\n",
 			       i + 1, algo, req->dlen);
 			ret = -EINVAL;
+			kfree(input_vec);
 			acomp_request_free(req);
 			goto out;
 		}
@@ -1500,26 +1511,37 @@ static int test_acomp(struct crypto_acomp *tfm, struct comp_testvec *ctemplate,
 			       i + 1, algo);
 			hexdump(output, req->dlen);
 			ret = -EINVAL;
+			kfree(input_vec);
 			acomp_request_free(req);
 			goto out;
 		}
 
+		kfree(input_vec);
 		acomp_request_free(req);
 	}
 
 	for (i = 0; i < dtcount; i++) {
 		unsigned int dlen = COMP_BUF_SIZE;
 		int ilen = dtemplate[i].inlen;
+		void *input_vec;
+
+		input_vec = kmalloc(ilen, GFP_KERNEL);
+		if (!input_vec) {
+			ret = -ENOMEM;
+			goto out;
+		}
 
+		memcpy(input_vec, dtemplate[i].input, ilen);
 		memset(output, 0, dlen);
 		init_completion(&result.completion);
-		sg_init_one(&src, dtemplate[i].input, ilen);
+		sg_init_one(&src, input_vec, ilen);
 		sg_init_one(&dst, output, dlen);
 
 		req = acomp_request_alloc(tfm);
 		if (!req) {
 			pr_err("alg: acomp: request alloc failed for %s\n",
 			       algo);
+			kfree(input_vec);
 			ret = -ENOMEM;
 			goto out;
 		}
@@ -1532,6 +1554,7 @@ static int test_acomp(struct crypto_acomp *tfm, struct comp_testvec *ctemplate,
 		if (ret) {
 			pr_err("alg: acomp: decompression failed on test %d for %s: ret=%d\n",
 			       i + 1, algo, -ret);
+			kfree(input_vec);
 			acomp_request_free(req);
 			goto out;
 		}
@@ -1540,6 +1563,7 @@ static int test_acomp(struct crypto_acomp *tfm, struct comp_testvec *ctemplate,
 			pr_err("alg: acomp: Decompression test %d failed for %s: output len = %d\n",
 			       i + 1, algo, req->dlen);
 			ret = -EINVAL;
+			kfree(input_vec);
 			acomp_request_free(req);
 			goto out;
 		}
@@ -1549,10 +1573,12 @@ static int test_acomp(struct crypto_acomp *tfm, struct comp_testvec *ctemplate,
 			       i + 1, algo);
 			hexdump(output, req->dlen);
 			ret = -EINVAL;
+			kfree(input_vec);
 			acomp_request_free(req);
 			goto out;
 		}
 
+		kfree(input_vec);
 		acomp_request_free(req);
 	}
 
-- 
2.7.4
