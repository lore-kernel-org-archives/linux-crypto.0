From: Colin King <colin.king@canonical.com>
Subject: [PATCH][next] crypto: chtls: don't leak information from the stack to userspace
Date: Thu,  5 Apr 2018 17:44:03 +0100
Message-ID: <20180405164403.4412-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Harsh Jain <harsh@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Michael Werner <werner@chelsio.com>,
        Atul Gupta <atul.gupta@chelsio.com>,
        Casey Leedom <leedom@chelsio.com>, linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The structure crypto_info contains fields that are not initialized and
only .version is set.  The copy_to_user call is hence leaking information
from the stack to userspace which must be avoided. Fix this by zero'ing
all the unused fields.

Detected by CoverityScan, CID#1467421 ("Uninitialized scalar variable")

Fixes: a08943947873 ("crypto: chtls - Register chtls with net tls")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/crypto/chelsio/chtls/chtls_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_main.c b/drivers/crypto/chelsio/chtls/chtls_main.c
index 007c45c38fc7..69f3756eb980 100644
--- a/drivers/crypto/chelsio/chtls/chtls_main.c
+++ b/drivers/crypto/chelsio/chtls/chtls_main.c
@@ -441,7 +441,7 @@ static int chtls_uld_rx_handler(void *handle, const __be64 *rsp,
 static int do_chtls_getsockopt(struct sock *sk, char __user *optval,
 			       int __user *optlen)
 {
-	struct tls_crypto_info crypto_info;
+	struct tls_crypto_info crypto_info = { 0 };
 
 	crypto_info.version = TLS_1_2_VERSION;
 	if (copy_to_user(optval, &crypto_info, sizeof(struct tls_crypto_info)))
-- 
2.15.1
