From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 3/12] crypto: Correct size given to memset
Date: Wed, 9 Dec 2009 20:23:09 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0912092022500.1870@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757351AbZLITXL@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Memset should be given the size of the structure, not the size of the pointer.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
type T;
T *x;
expression E;
@@

memset(x, E, sizeof(
+ *
 x))
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 crypto/gf128mul.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -u -p a/crypto/gf128mul.c b/crypto/gf128mul.c
--- a/crypto/gf128mul.c
+++ b/crypto/gf128mul.c
@@ -182,7 +182,7 @@ void gf128mul_lle(be128 *r, const be128 
 	for (i = 0; i < 7; ++i)
 		gf128mul_x_lle(&p[i + 1], &p[i]);
 
-	memset(r, 0, sizeof(r));
+	memset(r, 0, sizeof(*r));
 	for (i = 0;;) {
 		u8 ch = ((u8 *)b)[15 - i];
 
@@ -220,7 +220,7 @@ void gf128mul_bbe(be128 *r, const be128 
 	for (i = 0; i < 7; ++i)
 		gf128mul_x_bbe(&p[i + 1], &p[i]);
 
-	memset(r, 0, sizeof(r));
+	memset(r, 0, sizeof(*r));
 	for (i = 0;;) {
 		u8 ch = ((u8 *)b)[i];
 
