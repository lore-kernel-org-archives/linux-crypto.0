From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6/24] crypto: nx - Include internal/aead.h
Date: Mon, 11 May 2015 17:47:45 +0800
Message-ID: <E1YrkJN-00019I-Nh@gondolin.me.apana.org.au>
References: <20150511094444.GA4260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45536 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbbEKJrs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 05:47:48 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YrkJO-0000E5-1Y
	for <linux-crypto@vger.kernel.org>; Mon, 11 May 2015 19:47:46 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

All AEAD implementations must include internal/aead.h in order
to access required helpers.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/picoxcell_crypto.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 5da5b98..135817f 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -15,7 +15,7 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
-#include <crypto/aead.h>
+#include <crypto/internal/aead.h>
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
 #include <crypto/authenc.h>
