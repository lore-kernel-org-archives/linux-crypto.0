From: Ondrej Kozina <okozina@redhat.com>
Subject: crypto: algif - avoid excessive use of socket buffer in skcipher
Date: Mon, 10 Nov 2014 11:50:36 +0100
Message-ID: <5460987C.9030007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, gmazyland@gmail.com,
	linux-crypto@vger.kernel.org
To: stable@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797AbaKJKus (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Nov 2014 05:50:48 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

could you please add this patch (already landed in 3.18-rc1) to 
following stable kernels:

3.17.x, 3.14.x, 3.12.x, 3.4.x, 3.2.x?

The bugfix allows usage of crypto API socket on archs with PAGE_SIZE >= 
32 KiB (I have a typo in original changelog).

Some background for the bug (with reproducer and report from users)
- http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg11787.html
- http://bugzilla.redhat.com/show_bug.cgi?id=1160289

Thank you
Ondrej

-------------------

Upstream commit e2cffb5f493a8b431dc87124388ea59b79f0bccb
Author: Ondrej Kozina <okozina@redhat.com>
Date:   Mon Aug 25 11:49:54 2014 +0200

     crypto: algif - avoid excessive use of socket buffer in skcipher

     On archs with PAGE_SIZE >= 64 KiB the function skcipher_alloc_sgl()
     fails with -ENOMEM no matter what user space actually requested.
     This is caused by the fact sock_kmalloc call inside the function tried
     to allocate more memory than allowed by the default kernel socket 
buffer
     size (kernel param net.core.optmem_max).

     Signed-off-by: Ondrej Kozina <okozina@redhat.com>
     Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index a19c027..83187f4 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -49,7 +49,7 @@ struct skcipher_ctx {
  	struct ablkcipher_request req;
  };

-#define MAX_SGL_ENTS ((PAGE_SIZE - sizeof(struct skcipher_sg_list)) / \
+#define MAX_SGL_ENTS ((4096 - sizeof(struct skcipher_sg_list)) / \
  		      sizeof(struct scatterlist) - 1)

  static inline int skcipher_sndbuf(struct sock *sk)
