From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] crypto-jitterentropy: Delete unnecessary checks before the
 function call "kzfree"
Date: Tue, 23 Jun 2015 23:20:21 +0200
Message-ID: <5589CD95.9080508@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.so
 urceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
To: "David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 23 Jun 2015 22:30:21 +0200

The kzfree() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 crypto/jitterentropy.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
index d3c3045..22ded3e 100644
--- a/crypto/jitterentropy.c
+++ b/crypto/jitterentropy.c
@@ -698,11 +698,9 @@ static struct rand_data *jent_entropy_collector_alloc(unsigned int osr,
 
 static void jent_entropy_collector_free(struct rand_data *entropy_collector)
 {
-	if (entropy_collector->mem)
-		kzfree(entropy_collector->mem);
+	kzfree(entropy_collector->mem);
 	entropy_collector->mem = NULL;
-	if (entropy_collector)
-		kzfree(entropy_collector);
+	kzfree(entropy_collector);
 	entropy_collector = NULL;
 }
 
-- 
2.4.4

