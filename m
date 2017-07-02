From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 07/28] crypto: qce: use -EIOCBQUEUED for
	backlog indication
Date: Sun,  2 Jul 2017 17:41:49 +0300
Message-ID: <1499006535-19760-8-git-send-email-gilad@benyossef.com>
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

 drivers/crypto/qce/sha.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index 47e114a..a21d2a1c 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -421,7 +421,7 @@ static int qce_ahash_hmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 	ahash_request_set_crypt(req, &sg, ctx->authkey, keylen);
 
 	ret = crypto_ahash_digest(req);
-	if (ret == -EINPROGRESS || ret == -EBUSY) {
+	if (ret == -EINPROGRESS || ret == -EIOCBQUEUED) {
 		ret = wait_for_completion_interruptible(&result.completion);
 		if (!ret)
 			ret = result.error;
-- 
2.1.4
