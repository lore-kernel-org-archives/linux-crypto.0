From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/2] crypto: caam - Reintroduce DESC_MAX_USED_BYTES
Date: Thu, 18 Jun 2015 14:25:55 +0800
Message-ID: <E1Z5TGt-0007Qo-2u@gondolin.me.apana.org.au>
References: <20150618061734.GA28418@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	ruchika.gupta@freescale.com, cristian.stoica@freescale.com,
	NiteshNarayanLal@freescale.com, jinyanjiang@gmail.com,
	Tudor Ambarus <tudor.ambarus@freescale.com>,
	horia.geanta@freescale.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39934 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbbFRG2l (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Jun 2015 02:28:41 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1Z5TJW-0005ce-BW
	for <linux-crypto@vger.kernel.org>; Thu, 18 Jun 2015 16:28:38 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 4.80)
	(envelope-from <herbert@gondor.apana.org.au>)
	id 1Z5TJW-0007Sn-2T
	for linux-crypto@vger.kernel.org; Thu, 18 Jun 2015 14:28:38 +0800
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I incorrectly removed DESC_MAX_USED_BYTES when enlarging the size
of the shared descriptor buffers, thus making it four times larger
than what is necessary.  This patch restores the division by four
calculation.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/caam/caamalg.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index f206521..789c385 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -100,7 +100,8 @@
 #define DESC_ABLKCIPHER_DEC_LEN		(DESC_ABLKCIPHER_BASE + \
 					 15 * CAAM_CMD_SZ)
 
-#define DESC_MAX_USED_LEN		(CAAM_DESC_BYTES_MAX - DESC_JOB_IO_LEN)
+#define DESC_MAX_USED_BYTES		(CAAM_DESC_BYTES_MAX - DESC_JOB_IO_LEN)
+#define DESC_MAX_USED_LEN		(DESC_MAX_USED_BYTES / CAAM_CMD_SZ)
 
 #ifdef DEBUG
 /* for print_hex_dumps with line references */
