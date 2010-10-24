From: Nicolas Kaiser <nikai@nikai.net>
Subject: [PATCH] drivers/crypto: dubious error check
Date: Sun, 24 Oct 2010 15:05:56 +0200
Message-ID: <20101024150556.22f49c6a@absol.kitzblitz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Looks like a copy-and-paste problem to me.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/crypto/n2_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 88ee015..7614126 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -1832,7 +1832,7 @@ static int __devinit get_irq_props(struct mdesc_handle *mdesc, u64 node,
 		return -ENODEV;
 
 	ino = mdesc_get_property(mdesc, node, "ino", &ino_len);
-	if (!intr)
+	if (!ino)
 		return -ENODEV;
 
 	if (intr_len != ino_len)
-- 
1.7.2.2
