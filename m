From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH v4] AF_ALG: Initialize sg_num_bytes in error code path
Date: Sat, 07 Jul 2018 20:41:47 +0200
Message-ID: <1612449.5GibSviISC@positron.chronox.de>
References: <00000000000092ad87056950ef9e@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot <syzbot+9c251bdd09f83b92ba95@syzkaller.appspotmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <00000000000092ad87056950ef9e@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Changes v4:
* Add Fixes and CC line

Changes v3:
* Fix syz testing line

Changes v2:
* Addition of syz testing line

---8<---

The RX SGL in processing is already registered with the RX SGL tracking
list to support proper cleanup. The cleanup code path uses the
sg_num_bytes variable which must therefore be always initialized, even
in the error code path.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
Reported-by: syzbot+9c251bdd09f83b92ba95@syzkaller.appspotmail.com
#syz test: https://github.com/google/kmsan.git master
CC: <stable@vger.kernel.org> #4.14
Fixes: e870456d8e7c ("crypto: algif_skcipher - overhaul memory management")
Fixes: d887c52d6ae4 ("crypto: algif_aead - overhaul memory management")
---
 crypto/af_alg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 49fa8582138b..bd6795ff406a 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -1148,8 +1148,10 @@ int af_alg_get_rsgl(struct sock *sk, struct msghdr *msg, int flags,
 
 		/* make one iovec available as scatterlist */
 		err = af_alg_make_sg(&rsgl->sgl, &msg->msg_iter, seglen);
-		if (err < 0)
+		if (err < 0) {
+			rsgl->sg_num_bytes = 0;
 			return err;
+		}
 
 		/* chain the new scatterlist with previous one */
 		if (areq->last_rsgl)
-- 
2.17.1
