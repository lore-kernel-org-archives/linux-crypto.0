Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD2131B830
	for <linux-crypto@vger.kernel.org>; Wed, 27 May 2026 14:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779891164; cv=none; b=VImTUnCQPxdVJghumdZhBzDlVCynofUSurBLsMCj3faOb+rGUGNiKF+yJepWtjY7WAvHC5frnHJPxY5PN5V1mNmvu3nuB6qjoWkwHmbbG+9iOxh3HU/kJn1l6H1P2qVrMv3/fG1A6eeRjJkcHJ7ACxtEwiJ30oTWgobK+L66HXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779891164; c=relaxed/simple;
	bh=+n5NkJ5N4jZbkelJ0z6A3VaVtqvZIIQ+UU2iQaKm7qA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZC0gq49MnWsxATV2hHLv1a1WdD5DahWYWGmV2cRVKQifX+JeI9Zmuf2Qm1gv0oo5o03NchlPxFhZ1anAB1KN5ofuGuj+uMy8A+szhpcbwKGGBfXCMhPQGMcWvBw5zFZrIF520t5eRCA9+IgZSm5vt31mtjjI9Of/172NsIfOHho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SuRyDeFQ; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SuRyDeFQ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779891159;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hthxLoJgR89tBl7jthjU5X9svK67rTNi6Rp5QXjLXpM=;
	b=SuRyDeFQt6o3ov5uSgOJXQQe2HZfBw+4dwC6x7KoMPLaA6Hn21QA44+L8/hjp79utKZiIv
	tNv9b+8HjNfEhN+WNourRRnNmiJBiWYiZ4OvXVK6kTjt0W6tBqDEfT1iOoWhxZg8cISgCJ
	iOwceYUeUEw8P3l58aIVBiLXYMf8Wks=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: powerpc/aes - use min in ppc_{ecb,cbc,ctr,xts}_crypt
Date: Wed, 27 May 2026 16:11:47 +0200
Message-ID: <20260527141146.1230672-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1957; i=thorsten.blum@linux.dev; h=from:subject; bh=+n5NkJ5N4jZbkelJ0z6A3VaVtqvZIIQ+UU2iQaKm7qA=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFlivxf5LN+uZShzc7ut4JOWl+eWWal9+rBnV+ei61Zyx e9bF5vadJSyMIhxMciKKbI8mPVjhm9pTeUmk4idMHNYmUCGMHBxCsBEPLcwMqwIXBh9i/n/6qao ZB3nP0pb1x+/vyDno4SDdzvLPhmB8FuMDItvn6hid9Kuk178/lPuujUTD+UEhqg5H5XaUWp6wtr sIC8A
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace min_t() with the simpler min() macro since the values are
unsigned and compatible.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 arch/powerpc/crypto/aes-spe-glue.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/crypto/aes-spe-glue.c b/arch/powerpc/crypto/aes-spe-glue.c
index 7d2827e65240..e038488087e6 100644
--- a/arch/powerpc/crypto/aes-spe-glue.c
+++ b/arch/powerpc/crypto/aes-spe-glue.c
@@ -9,6 +9,7 @@
  */
 
 #include <crypto/aes.h>
+#include <linux/minmax.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/types.h>
@@ -140,7 +141,7 @@ static int ppc_ecb_crypt(struct skcipher_request *req, bool enc)
 	err = skcipher_walk_virt(&walk, req, false);
 
 	while ((nbytes = walk.nbytes) != 0) {
-		nbytes = min_t(unsigned int, nbytes, MAX_BYTES);
+		nbytes = min(nbytes, MAX_BYTES);
 		nbytes = round_down(nbytes, AES_BLOCK_SIZE);
 
 		spe_begin();
@@ -179,7 +180,7 @@ static int ppc_cbc_crypt(struct skcipher_request *req, bool enc)
 	err = skcipher_walk_virt(&walk, req, false);
 
 	while ((nbytes = walk.nbytes) != 0) {
-		nbytes = min_t(unsigned int, nbytes, MAX_BYTES);
+		nbytes = min(nbytes, MAX_BYTES);
 		nbytes = round_down(nbytes, AES_BLOCK_SIZE);
 
 		spe_begin();
@@ -220,7 +221,7 @@ static int ppc_ctr_crypt(struct skcipher_request *req)
 	err = skcipher_walk_virt(&walk, req, false);
 
 	while ((nbytes = walk.nbytes) != 0) {
-		nbytes = min_t(unsigned int, nbytes, MAX_BYTES);
+		nbytes = min(nbytes, MAX_BYTES);
 		if (nbytes < walk.total)
 			nbytes = round_down(nbytes, AES_BLOCK_SIZE);
 
@@ -248,7 +249,7 @@ static int ppc_xts_crypt(struct skcipher_request *req, bool enc)
 	twk = ctx->key_twk;
 
 	while ((nbytes = walk.nbytes) != 0) {
-		nbytes = min_t(unsigned int, nbytes, MAX_BYTES);
+		nbytes = min(nbytes, MAX_BYTES);
 		nbytes = round_down(nbytes, AES_BLOCK_SIZE);
 
 		spe_begin();
