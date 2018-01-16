From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH v2] crypto: inside-secure - make function safexcel_try_push_requests static
Date: Tue, 16 Jan 2018 08:41:58 +0100
Message-ID: <20180116074158.21571-1-antoine.tenart@free-electrons.com>
Cc: thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com,
        miquel.raynal@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com,
        linux-crypto@vger.kernel.org,
        Antoine Tenart <antoine.tenart@free-electrons.com>
To: colin.king@canonical.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:39253 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750990AbeAPHpD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Jan 2018 02:45:03 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The function safexcel_try_push_requests  is local to the source and does
not need to be in global scope, so make it static.

Cleans up sparse warning:
symbol 'safexcel_try_push_requests' was not declared. Should it be static?

Signed-off-by: Colin Ian King <colin.king@canonical.com>
[Antoine: fixed alignment]
Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---

Hi Colin, Herbert,

I took care of making the v2 of this patch since the fix was trivial and
v1 was sent 2 weeks ago.

Thanks!
Antoine

Since v1:
  - Fixed the alignment to match open parenthesis.

 drivers/crypto/inside-secure/safexcel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 0d685be75241..225e74a7f724 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -432,8 +432,8 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 }
 
 /* Called with ring's lock taken */
-int safexcel_try_push_requests(struct safexcel_crypto_priv *priv, int ring,
-			       int reqs)
+static int safexcel_try_push_requests(struct safexcel_crypto_priv *priv,
+				      int ring, int reqs)
 {
 	int coal = min_t(int, reqs, EIP197_MAX_BATCH_SZ);
 
-- 
2.14.3
