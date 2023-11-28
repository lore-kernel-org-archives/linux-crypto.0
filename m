Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F6A189;
	Mon, 27 Nov 2023 22:22:10 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r7rTw-004Hgh-LO; Tue, 28 Nov 2023 14:22:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 28 Nov 2023 14:22:13 +0800
Date: Tue, 28 Nov 2023 14:22:13 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Harald Freudenberger <freude@linux.ibm.com>,
	linux-s390@vger.kernel.org,
	Gerald Schaefer <gerald.schaefer@de.ibm.com>,
	Jan Glauber <jang@linux.vnet.ibm.com>
Subject: crypto: s390/aes - Fix buffer overread in CTR mode
Message-ID: <ZWWHFeOPcW30OYo1@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

When processing the last block, the s390 ctr code will always read
a whole block, even if there isn't a whole block of data left.  Fix
this by using the actual length left and copy it into a buffer first
for processing.

Fixes: 0200f3ecc196 ("crypto: s390 - add System z hardware support for CTR mode")
Cc: <stable@vger.kernel.org>
Reported-by: Guangwu Zhang <guazhang@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index c773820e4af9..c6fe5405de4a 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -597,7 +597,9 @@ static int ctr_aes_crypt(struct skcipher_request *req)
 	 * final block may be < AES_BLOCK_SIZE, copy only nbytes
 	 */
 	if (nbytes) {
-		cpacf_kmctr(sctx->fc, sctx->key, buf, walk.src.virt.addr,
+		memset(buf, 0, AES_BLOCK_SIZE);
+		memcpy(buf, walk.src.virt.addr, nbytes);
+		cpacf_kmctr(sctx->fc, sctx->key, buf, buf,
 			    AES_BLOCK_SIZE, walk.iv);
 		memcpy(walk.dst.virt.addr, buf, nbytes);
 		crypto_inc(walk.iv, AES_BLOCK_SIZE);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
