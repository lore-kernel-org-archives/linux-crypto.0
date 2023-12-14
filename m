Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6253D0;
	Wed, 13 Dec 2023 19:08:37 -0800 (PST)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VySjsdn_1702523314;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0VySjsdn_1702523314)
          by smtp.aliyun-inc.com;
          Thu, 14 Dec 2023 11:08:35 +0800
From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Mimi Zohar <zohar@linux.ibm.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH] crypto: lib/mpi - Fix unexpected pointer access
Date: Thu, 14 Dec 2023 11:08:34 +0800
Message-Id: <20231214030834.2665-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the mpi_ec_ctx structure is initialized, some fields are not
cleared, causing a crash when referencing the field when the
structure was released. Initially, this issue was ignored because
memory for mpi_ec_ctx is allocated with the __GFP_ZERO flag.
For example, this error will be triggered when calculating the
Za value for SM2 separately.

Fixes: d58bb7e55a8a ("lib/mpi: Introduce ec implementation to MPI library")
Cc: stable@vger.kernel.org # v6.5
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 lib/crypto/mpi/ec.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/crypto/mpi/ec.c b/lib/crypto/mpi/ec.c
index 40f5908e57a4..e16dca1e23d5 100644
--- a/lib/crypto/mpi/ec.c
+++ b/lib/crypto/mpi/ec.c
@@ -584,6 +584,9 @@ void mpi_ec_init(struct mpi_ec_ctx *ctx, enum gcry_mpi_ec_models model,
 	ctx->a = mpi_copy(a);
 	ctx->b = mpi_copy(b);
 
+	ctx->d = NULL;
+	ctx->t.two_inv_p = NULL;
+
 	ctx->t.p_barrett = use_barrett > 0 ? mpi_barrett_init(ctx->p, 0) : NULL;
 
 	mpi_ec_get_reset(ctx);
-- 
2.24.3 (Apple Git-128)

