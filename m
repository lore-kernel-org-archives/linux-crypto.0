From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 04/28] crypto: marvell/cesa: use -EIOCBQUEUED
	for backlog indication
Date: Sun,  2 Jul 2017 17:41:46 +0300
Message-ID: <1499006535-19760-5-git-send-email-gilad@benyossef.com>
References: <1499006535-19760-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ofir Drang <ofir.drang@arm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Jonathan Corbet <corbet@lwn.net>, David Howells <dhowells@redhat.com>,
	Tom Lendacky <thomas.lendacky@amd.com>, Gary Hook <gary.hook@amd.com>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	dm-devel@redhat.com, Shaohua Li <shli@kernel.org>,
	Steve French <sfrench@samba.org>, "Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
	James Morris <james.l.morris@oracle.com>,
	"Serge E. Hallyn" <serge@hallyn.com>, linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	keyrings@vger.kernel.org, linux-arm-kernel@lis
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1499006535-19760-1-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-crypto.vger.kernel.org

Replace -EBUSY with -EIOCBQUEUED for backlog queueing indication
as part of new API.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---

This patch should be squashed with the first patch in the series
when applied.

 drivers/crypto/marvell/cesa.c | 2 +-
 drivers/crypto/marvell/cesa.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
index 6e7a5c7..5a0f7d1 100644
--- a/drivers/crypto/marvell/cesa.c
+++ b/drivers/crypto/marvell/cesa.c
@@ -184,7 +184,7 @@ int mv_cesa_queue_req(struct crypto_async_request *req,
 	ret = crypto_enqueue_request(&engine->queue, req);
 	if ((mv_cesa_req_get_type(creq) == CESA_DMA_REQ) &&
 	    (ret == -EINPROGRESS ||
-	    (ret == -EBUSY && req->flags & CRYPTO_TFM_REQ_MAY_BACKLOG)))
+	     ret == -EIOCBQUEUED))
 		mv_cesa_tdma_chain(engine, creq);
 	spin_unlock_bh(&engine->lock);
 
diff --git a/drivers/crypto/marvell/cesa.h b/drivers/crypto/marvell/cesa.h
index b7872f6..4ca755f 100644
--- a/drivers/crypto/marvell/cesa.h
+++ b/drivers/crypto/marvell/cesa.h
@@ -763,7 +763,7 @@ static inline int mv_cesa_req_needs_cleanup(struct crypto_async_request *req,
 	 * the backlog and will be processed later. There's no need to
 	 * clean it up.
 	 */
-	if (ret == -EBUSY && req->flags & CRYPTO_TFM_REQ_MAY_BACKLOG)
+	if (ret == -EIOCBQUEUED)
 		return false;
 
 	/* Request wasn't queued, we need to clean it up */
-- 
2.1.4
