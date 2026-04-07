Received: from mailout3.hostsharing.net (mailout3.hostsharing.net [144.76.133.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0384C3AB292;
	Tue,  7 Apr 2026 10:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.133.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775559496; cv=none; b=SImvd0O3qqjiZW3jBL2P5vEcymgtL9sB6GJhu3mg5vWkiGlct3hKmKUZJtY4buf1kYWt2EbGYs25nh4upAYxRAvUg7TSCspRE97TijOT3tNR22svLxUnzxYmR72aJeS+crX2Zj9iwHOBv7p7siU8m7HKUjsXlv6oLErqTYNO4v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775559496; c=relaxed/simple;
	bh=TwcGXH5k9itx8omwaiUTnFcxsSLaWmfYI5kkdDTmZgY=;
	h=Message-Id:From:Date:Subject:To:Cc; b=rq2xV9JcA8hePaRDwk2azPUEglNV6PiRg1xLeCKxI/R2dSgL58LADT7PVjacDrNyaVp+PHEl+jTpqXkEliRJIIH3Y/d85XD63OKYEdwv04Pq97DBQZ/hihHTTZqo0uOeZsKtSZ6wBcfJ/+lNC/3kgX5Oa8tsJyTd6uvt66eigiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=144.76.133.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by mailout3.hostsharing.net (Postfix) with ESMTPS id 63436C16;
	Tue, 07 Apr 2026 12:58:04 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 3180E6029B1F; Tue,  7 Apr 2026 12:58:04 +0200 (CEST)
Message-Id: <db192bcb9467d30068c97a4007822f21aab6766f.1775512248.git.lukas@wunner.de>
From: Lukas Wunner <lukas@wunner.de>
Date: Tue, 7 Apr 2026 12:58:18 +0200
Subject: [PATCH] X.509: Fix out-of-bounds access when parsing extensions
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Jarkko Sakkinen <jarkko@kernel.org>
Cc: linux-crypto@vger.kernel.org, keyrings@vger.kernel.org, Leo Lin <leo@depthfirst.com>, Eric Snowberg <eric.snowberg@oracle.com>, Mimi Zohar <zohar@linux.ibm.com>, Ignat Korchagin <ignat@linux.win>, David Howells <dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Leo reports an out-of-bounds access when parsing a certificate with
empty Basic Constraints or Key Usage extension because the first byte of
the extension is read before checking its length.  Fix it.

The bug can be triggered by an unprivileged user by submitting a
specially crafted certificate to the kernel through the keyrings(7) API.
Leo has demonstrated this with a proof-of-concept program responsibly
disclosed off-list.

Fixes: 30eae2b037af ("KEYS: X.509: Parse Basic Constraints for CA")
Fixes: 567671281a75 ("KEYS: X.509: Parse Key Usage")
Reported-by: Leo Lin <leo@depthfirst.com> # off-list
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Ignat Korchagin <ignat@linux.win>
Cc: stable@vger.kernel.org # v6.4+
---
 crypto/asymmetric_keys/x509_cert_parser.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index b37cae9..aac2d55 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -584,10 +584,10 @@ int x509_process_extension(void *context, size_t hdrlen,
 		 *   0x04 is where keyCertSign lands in this bit string
 		 *   0x80 is where digitalSignature lands in this bit string
 		 */
-		if (v[0] != ASN1_BTS)
-			return -EBADMSG;
 		if (vlen < 4)
 			return -EBADMSG;
+		if (v[0] != ASN1_BTS)
+			return -EBADMSG;
 		if (v[2] >= 8)
 			return -EBADMSG;
 		if (v[3] & 0x80)
@@ -620,10 +620,10 @@ int x509_process_extension(void *context, size_t hdrlen,
 		 *	(Expect 0xFF if the CA is TRUE)
 		 * vlen should match the entire extension size
 		 */
-		if (v[0] != (ASN1_CONS_BIT | ASN1_SEQ))
-			return -EBADMSG;
 		if (vlen < 2)
 			return -EBADMSG;
+		if (v[0] != (ASN1_CONS_BIT | ASN1_SEQ))
+			return -EBADMSG;
 		if (v[1] != vlen - 2)
 			return -EBADMSG;
 		/* Empty SEQUENCE means CA:FALSE (default value omitted per DER) */
-- 
2.51.0

