From: Colin King <colin.king@canonical.com>
Subject: [PATCH][V2] crypto/nx: fix spelling mistake: "availavle" -> "available"
Date: Tue, 14 Nov 2017 14:32:17 +0000
Message-ID: <20171114143217.21456-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Haren Myneni <haren@us.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in pr_err error message text. Also
fix spelling mistake in proceeding comment.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/crypto/nx/nx-842-powernv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
index f2246a5abcf6..1e87637c412d 100644
--- a/drivers/crypto/nx/nx-842-powernv.c
+++ b/drivers/crypto/nx/nx-842-powernv.c
@@ -743,8 +743,8 @@ static int nx842_open_percpu_txwins(void)
 		}
 
 		if (!per_cpu(cpu_txwin, i)) {
-			/* shoudn't happen, Each chip will have NX engine */
-			pr_err("NX engine is not availavle for CPU %d\n", i);
+			/* shouldn't happen, Each chip will have NX engine */
+			pr_err("NX engine is not available for CPU %d\n", i);
 			return -EINVAL;
 		}
 	}
-- 
2.14.1

