From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 14/28] crypto: introduce crypto wait for async
	op
Date: Sun,  2 Jul 2017 17:41:56 +0300
Message-ID: <1499006535-19760-15-git-send-email-gilad@benyossef.com>
References: <1499006535-19760-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Eric Biggers <ebiggers3@gmail.com>, Ofir Drang <ofir.drang@arm.com>
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

Invoking a possibly async. crypto op and waiting for completion
while correctly handling backlog processing is a common task
in the crypto API implementation and outside users of it.

This patch adds a generic implementation for doing so in
preparation for using it across the board instead of hand
rolled versions.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
CC: Eric Biggers <ebiggers3@gmail.com>
---
 crypto/api.c           | 13 +++++++++++++
 include/linux/crypto.h | 40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/crypto/api.c b/crypto/api.c
index 941cd4c..2a2479d 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -24,6 +24,7 @@
 #include <linux/sched/signal.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/completion.h>
 #include "internal.h"
 
 LIST_HEAD(crypto_alg_list);
@@ -595,5 +596,17 @@ int crypto_has_alg(const char *name, u32 type, u32 mask)
 }
 EXPORT_SYMBOL_GPL(crypto_has_alg);
 
+void crypto_req_done(struct crypto_async_request *req, int err)
+{
+	struct crypto_wait *wait = req->data;
+
+	if (err == -EINPROGRESS)
+		return;
+
+	wait->err = err;
+	complete(&wait->completion);
+}
+EXPORT_SYMBOL_GPL(crypto_req_done);
+
 MODULE_DESCRIPTION("Cryptographic core API");
 MODULE_LICENSE("GPL");
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 84da997..47e884a 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/uaccess.h>
+#include <linux/completion.h>
 
 /*
  * Autoloaded crypto modules should only use a prefixed name to avoid allowing
@@ -468,6 +469,45 @@ struct crypto_alg {
 } CRYPTO_MINALIGN_ATTR;
 
 /*
+ * A helper struct for waiting for completion of async crypto ops
+ */
+struct crypto_wait {
+	struct completion completion;
+	int err;
+};
+
+/*
+ * Macro for declaring a crypto op async wait object on stack
+ */
+#define DECLARE_CRYPTO_WAIT(_wait) \
+	struct crypto_wait _wait = { \
+		COMPLETION_INITIALIZER_ONSTACK((_wait).completion), 0 }
+
+/*
+ * Async ops completion helper functioons
+ */
+void crypto_req_done(struct crypto_async_request *req, int err);
+
+static inline int crypto_wait_req(int err, struct crypto_wait *wait)
+{
+	switch (err) {
+	case -EINPROGRESS:
+	case -EIOCBQUEUED:
+		wait_for_completion(&wait->completion);
+		reinit_completion(&wait->completion);
+		err = wait->err;
+		break;
+	};
+
+	return err;
+}
+
+static inline void crypto_init_wait(struct crypto_wait *wait)
+{
+	init_completion(&wait->completion);
+}
+
+/*
  * Algorithm registration interface.
  */
 int crypto_register_alg(struct crypto_alg *alg);
-- 
2.1.4
