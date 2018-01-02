From: Colin King <colin.king@canonical.com>
Subject: [PATCH][crypto-next] crypto: inside-secure - make function safexcel_try_push_requests static
Date: Tue,  2 Jan 2018 14:34:10 +0000
Message-ID: <20180102143410.13261-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Antoine Tenart <antoine.tenart@free-electrons.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The function safexcel_try_push_requests  is local to the source and does
not need to be in global scope, so make it static.

Cleans up sparse warning:
symbol 'safexcel_try_push_requests' was not declared. Should it be static?

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/crypto/inside-secure/safexcel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 0d685be75241..e3745139644b 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -432,8 +432,8 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 }
 
 /* Called with ring's lock taken */
-int safexcel_try_push_requests(struct safexcel_crypto_priv *priv, int ring,
-			       int reqs)
+static int safexcel_try_push_requests(struct safexcel_crypto_priv *priv,
+				     int ring, int reqs)
 {
 	int coal = min_t(int, reqs, EIP197_MAX_BATCH_SZ);
 
-- 
2.14.1
