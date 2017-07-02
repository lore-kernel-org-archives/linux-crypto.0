From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 25/28] crypto: talitos: move to generic async
	completion
Date: Sun,  2 Jul 2017 17:42:07 +0300
Message-ID: <1499006535-19760-26-git-send-email-gilad@benyossef.com>
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

The talitos driver starts several async crypto ops and  waits for their
completions. Move it over to generic code doing the same.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/talitos.c | 39 +++++----------------------------------
 1 file changed, 5 insertions(+), 34 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 0ab3c4d..bf80d3b 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2037,22 +2037,6 @@ static int ahash_import(struct ahash_request *areq, const void *in)
 	return 0;
 }
 
-struct keyhash_result {
-	struct completion completion;
-	int err;
-};
-
-static void keyhash_complete(struct crypto_async_request *req, int err)
-{
-	struct keyhash_result *res = req->data;
-
-	if (err == -EINPROGRESS)
-		return;
-
-	res->err = err;
-	complete(&res->completion);
-}
-
 static int keyhash(struct crypto_ahash *tfm, const u8 *key, unsigned int keylen,
 		   u8 *hash)
 {
@@ -2060,10 +2044,10 @@ static int keyhash(struct crypto_ahash *tfm, const u8 *key, unsigned int keylen,
 
 	struct scatterlist sg[1];
 	struct ahash_request *req;
-	struct keyhash_result hresult;
+	struct crypto_wait wait;
 	int ret;
 
-	init_completion(&hresult.completion);
+	crypto_init_wait(&wait);
 
 	req = ahash_request_alloc(tfm, GFP_KERNEL);
 	if (!req)
@@ -2072,25 +2056,12 @@ static int keyhash(struct crypto_ahash *tfm, const u8 *key, unsigned int keylen,
 	/* Keep tfm keylen == 0 during hash of the long key */
 	ctx->keylen = 0;
 	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				   keyhash_complete, &hresult);
+				   crypto_req_done, &wait);
 
 	sg_init_one(&sg[0], key, keylen);
 
-	ahash_request_set_crypt(req, sg, hash, keylen);
-	ret = crypto_ahash_digest(req);
-	switch (ret) {
-	case 0:
-		break;
-	case -EINPROGRESS:
-	case -EIOCBQUEUED:
-		ret = wait_for_completion_interruptible(
-			&hresult.completion);
-		if (!ret)
-			ret = hresult.err;
-		break;
-	default:
-		break;
-	}
+	ret = crypto_wait_req(crypto_ahash_digest(req), &wait);
+
 	ahash_request_free(req);
 
 	return ret;
-- 
2.1.4
