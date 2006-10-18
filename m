From: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>
Subject: [PATCH 5/6] [IPSEC] added the entry of Camellia cipher algorithm
 to ealg_list[].
Date: Wed, 18 Oct 2006 16:17:49 +0900 (JST)
Message-ID: <20061018.161749.782295638.takamiya@po.ntts.co.jp>
References: <20061018.161510.796986352.takamiya@po.ntts.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, takamiya@po.ntts.co.jp
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail2.ics.ntts.co.jp ([202.32.24.42]:55195 "EHLO
	mail2.ics.ntts.co.jp") by vger.kernel.org with ESMTP
	id S1751053AbWJRHUt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Oct 2006 03:20:49 -0400
To: linux-crypto@vger.kernel.org
In-Reply-To: <20061018.161510.796986352.takamiya@po.ntts.co.jp>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


This patch adds the entry of Camellia cipher algorithm to ealg_list[].

Signed-off-by: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>

---

 net/xfrm/xfrm_algo.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

2253254f5a802c1cc8a5fc367fae911172f28846
diff --git a/net/xfrm/xfrm_algo.c b/net/xfrm/xfrm_algo.c
index 5a0dbeb..583292d 100644
--- a/net/xfrm/xfrm_algo.c
+++ b/net/xfrm/xfrm_algo.c
@@ -249,6 +249,23 @@ static struct xfrm_algo_desc ealg_list[]
         }
 },
 {
+	.name = "cbc(camellia)",
+        .compat = "camellia",
+
+	.uinfo = {
+		.encr = {
+			.blockbits = 128,
+			.defkeybits = 128,
+		}
+	},
+	.desc = {
+		.sadb_alg_id = SADB_X_EALG_CAMELLIACBC,
+		.sadb_alg_ivlen = 8,
+		.sadb_alg_minbits = 128,
+		.sadb_alg_maxbits = 256
+	}
+},
+{
         .name = "cbc(twofish)",
         .compat = "twofish",
                  
-- 
Noriaki TAKAMIYA
