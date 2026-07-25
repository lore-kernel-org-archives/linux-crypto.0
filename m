Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5950B2E11DC;
	Sat, 25 Jul 2026 01:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784943782; cv=none; b=e+bl8sl/YG7RQ3IWW/ohjkFkJ67/rFDojWq2FbkpmrjbamfyGCor/55XD6v28AKaG32OiGTbeKMgJ4DteMGEwhNAvsj+8Z90s5YI1kAAkSvgv8/6N+9ki1zeXE/PbHN35lP4x26I4hFPwoVXNmDZfXrje9r9QQX0OM6DwHreThk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784943782; c=relaxed/simple;
	bh=eICMGPusmQCeTEGiA04XTMIIwBRIJjJ8oCqtwSxIWLM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=awlO2vDRnxO7ZkoFfaUqUfiwVqMdlAcL30SM3TAYS+cwo8YZ6hoUtSkB0PdHErV6rplnX/yNIVIEqoM90uqIWXKbDoiKtkBnJVFVcv6cbW0l8JCbgSdfesc74qO/alc1HApHxMj/szI9Rg+1vNhFkehk5kVb7NzGKwFOnX4jocs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WMyVPpmP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WMyVPpmP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=1J8zphf696ESeP3BTAVbIoRBMQnaUAAh5MqFqDEoIV4=; b=WMyVPpmPkJOFlAJV8yE0yznNbI
	Uslqucy4CLloLIBP+7w17titYBEcr8mVfdW3iD09Dyg4/suHOzLhwHnzWJZGvFZIUNMpOUQM83rVZ
	FyQnjGTnWhvQWzv6pDEx0BusA5LQD9SpALg3rv44pOKQP9hsLNIT5u/ePz/8xsLPsags80Dggf9Al
	fZti6g72SAoFWuzgzc6rPRvHi9aHzc03K7ADCYd44ynljvlDTFDADXF9a3h7C671Xv4xeiIrVwjPZ
	c5qNdcSic2VDLYOlR8eZp/T4S3fDiP4TZBZsgtIC2Jc5TG7USl2zCHmwcUNLiZYW+2GZ8zQ6Zxz8E
	oo73BUiA==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wnRPk-0000000HSrb-1JhE;
	Sat, 25 Jul 2026 01:42:56 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: af_alg: clean up kernel-doc warnings
Date: Fri, 24 Jul 2026 18:42:53 -0700
Message-ID: <20260725014253.1189593-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

- add missing struct member @wait, drop @completion
- convert function comments to kernel-doc format
- for af_alg_readable(), change comments from "writable" to "readable"

Warning: include/crypto/if_alg.h:161 struct member 'wait' not described
 in 'af_alg_ctx'
Warning: include/crypto/if_alg.h:161 Excess struct member 'completion'
 description in 'af_alg_ctx'
Warning: include/crypto/if_alg.h:187 This comment starts with '/**', but
 isn't a kernel-doc comment.
 * Size of available buffer for sending data from user space to kernel.
Warning: include/crypto/if_alg.h:202 This comment starts with '/**', but
 isn't a kernel-doc comment.
 * Can the send buffer still be written to?
Warning: include/crypto/if_alg.h:213 This comment starts with '/**', but
 isn't a kernel-doc comment.
 * Size of available buffer used by kernel for the RX user space operation.
Warning: include/crypto/if_alg.h:228 This comment starts with '/**', but
 isn't a kernel-doc comment.
 * Can the RX buffer still be written to?

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org

 include/crypto/if_alg.h |   30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

--- linux-next-20260722.orig/include/crypto/if_alg.h
+++ linux-next-20260722/include/crypto/if_alg.h
@@ -121,7 +121,7 @@ struct af_alg_async_req {
  * @iv:			IV for cipher operation
  * @state:		Existing state for continuing operation
  * @aead_assoclen:	Length of AAD for AEAD cipher operations
- * @completion:		Work queue for synchronous operation
+ * @wait:		For waiting for completion of async crypto ops
  * @used:		TX bytes sent to kernel. This variable is used to
  *			ensure that user space cannot cause the kernel
  *			to allocate too much memory in sendmsg operation.
@@ -185,10 +185,11 @@ static inline struct alg_sock *alg_sk(st
 }
 
 /**
- * Size of available buffer for sending data from user space to kernel.
+ * af_alg_sndbuf - Size of available buffer for sending data from user space to kernel.
  *
- * @sk socket of connection to user space
- * @return number of bytes still available
+ * @sk: socket of connection to user space
+ *
+ * Returns: number of bytes still available
  */
 static inline int af_alg_sndbuf(struct sock *sk)
 {
@@ -200,10 +201,11 @@ static inline int af_alg_sndbuf(struct s
 }
 
 /**
- * Can the send buffer still be written to?
+ * af_alg_writable - Can the send buffer still be written to?
+ *
+ * @sk: socket of connection to user space
  *
- * @sk socket of connection to user space
- * @return true => writable, false => not writable
+ * Returns: true => writable, false => not writable
  */
 static inline bool af_alg_writable(struct sock *sk)
 {
@@ -211,10 +213,11 @@ static inline bool af_alg_writable(struc
 }
 
 /**
- * Size of available buffer used by kernel for the RX user space operation.
+ * af_alg_rcvbuf - Size of available buffer used by kernel for the RX user space operation.
  *
- * @sk socket of connection to user space
- * @return number of bytes still available
+ * @sk: socket of connection to user space
+ *
+ * Returns: number of bytes still available
  */
 static inline int af_alg_rcvbuf(struct sock *sk)
 {
@@ -226,10 +229,11 @@ static inline int af_alg_rcvbuf(struct s
 }
 
 /**
- * Can the RX buffer still be written to?
+ * af_alg_readable - Can the RX buffer still be read from?
+ *
+ * @sk: socket of connection to user space
  *
- * @sk socket of connection to user space
- * @return true => writable, false => not writable
+ * Returns: true => readable, false => not readable
  */
 static inline bool af_alg_readable(struct sock *sk)
 {
