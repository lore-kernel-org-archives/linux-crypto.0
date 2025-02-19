Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32032215053;
	Wed, 19 Feb 2025 18:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739989468; cv=none; b=HmkuipXnLaX3z8Op84Wcltt2Ke7cdh27mmz47DD/7BDl00IiW0ou9ENzK2Wq00RIKG+MDIONymAcLz1tIqrNIUI+SUgmsL8K93zfogk1mNVvzs/LKrJFXHyjMfXjkiXur8KtWpbQ6Qh6prfF8RMxRfSyaEV2MGV+XjJSuQ7j4gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739989468; c=relaxed/simple;
	bh=B94Zf/9ecwbLJRGlZygRaCWWQNJw7qERS46dXk1bops=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rqauSynOSXdD/13wLnk+WbLeON+WLjtbJ8uIAF3vrUn46qVgArn8MZrssQ2IqRjxm5vxdGG838saVPk1wzjuPwBxjfXF85OgxmaY0itOxmOTxEB2rXaMNL22eii7cOFmeMmVtzqIHVyQdy4PQmVeHkIYHjYLYnajKSWwP/kZBUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MYpOTwsq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MYpOTwsq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1652C4CEE7;
	Wed, 19 Feb 2025 18:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739989468;
	bh=B94Zf/9ecwbLJRGlZygRaCWWQNJw7qERS46dXk1bops=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MYpOTwsqtsFphHk3bYX2KYLcOnNJJZ6U0psJuditGIz33kygDLh0RLKw98kzhVkn4
	 cfN2EloO3IAFYH+e6jOSyIBEv30uulkZztbVXB6+DxjBuqdPbeZYS9LWIEdRKvTsEK
	 m7YZiLK4gSPl7zUNxY/dxuTtgT9UnVJH2Tb4v7omixyqp0nK8f2SKPodjNZZT995fq
	 qEClzohCyOdnlJBnaUsqidBhiNApX+MzPBuhAruYC5/+zOqqj6l+CqE7ZN2w3B6Qgk
	 k0Y0rkb5aedYGLJf45djsy0kjnoQ4Fu/Y3Op+qOCNB7L4KakkTl03680ylytIJ8CFm
	 1jv22HnW7AGDg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH v3 04/19] crypto: scatterwalk - add new functions for copying data
Date: Wed, 19 Feb 2025 10:23:26 -0800
Message-ID: <20250219182341.43961-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219182341.43961-1-ebiggers@kernel.org>
References: <20250219182341.43961-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Add memcpy_from_sglist() and memcpy_to_sglist() which are more readable
versions of scatterwalk_map_and_copy() with the 'out' argument 0 and 1
respectively.  They follow the same argument order as memcpy_from_page()
and memcpy_to_page() from <linux/highmem.h>.  Note that in the case of
memcpy_from_sglist(), this also happens to be the same argument order
that scatterwalk_map_and_copy() uses.

The new code is also faster, mainly because it builds the scatter_walk
directly without creating a temporary scatterlist.  E.g., a 20%
performance improvement is seen for copying the AES-GCM auth tag.

Make scatterwalk_map_and_copy() be a wrapper around memcpy_from_sglist()
and memcpy_to_sglist().  Callers of scatterwalk_map_and_copy() should be
updated to call memcpy_from_sglist() or memcpy_to_sglist() directly, but
there are a lot of them so they aren't all being updated right away.

Also add functions memcpy_from_scatterwalk() and memcpy_to_scatterwalk()
which are similar but operate on a scatter_walk instead of a
scatterlist.  These will replace scatterwalk_copychunks() with the 'out'
argument 0 and 1 respectively.  Their behavior differs slightly from
scatterwalk_copychunks() in that they automatically take care of
flushing the dcache when needed, making them easier to use.

scatterwalk_copychunks() itself is left unchanged for now.  It will be
removed after its callers are updated to use other functions instead.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/scatterwalk.c         | 59 ++++++++++++++++++++++++++++++------
 include/crypto/scatterwalk.h | 24 +++++++++++++--
 2 files changed, 72 insertions(+), 11 deletions(-)

diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index af436ad02e3ff..2e7a532152d61 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -65,26 +65,67 @@ void scatterwalk_copychunks(void *buf, struct scatter_walk *walk,
 		scatterwalk_pagedone(walk, out & 1, 1);
 	}
 }
 EXPORT_SYMBOL_GPL(scatterwalk_copychunks);
 
-void scatterwalk_map_and_copy(void *buf, struct scatterlist *sg,
-			      unsigned int start, unsigned int nbytes, int out)
+inline void memcpy_from_scatterwalk(void *buf, struct scatter_walk *walk,
+				    unsigned int nbytes)
+{
+	do {
+		const void *src_addr;
+		unsigned int to_copy;
+
+		src_addr = scatterwalk_next(walk, nbytes, &to_copy);
+		memcpy(buf, src_addr, to_copy);
+		scatterwalk_done_src(walk, src_addr, to_copy);
+		buf += to_copy;
+		nbytes -= to_copy;
+	} while (nbytes);
+}
+EXPORT_SYMBOL_GPL(memcpy_from_scatterwalk);
+
+inline void memcpy_to_scatterwalk(struct scatter_walk *walk, const void *buf,
+				  unsigned int nbytes)
+{
+	do {
+		void *dst_addr;
+		unsigned int to_copy;
+
+		dst_addr = scatterwalk_next(walk, nbytes, &to_copy);
+		memcpy(dst_addr, buf, to_copy);
+		scatterwalk_done_dst(walk, dst_addr, to_copy);
+		buf += to_copy;
+		nbytes -= to_copy;
+	} while (nbytes);
+}
+EXPORT_SYMBOL_GPL(memcpy_to_scatterwalk);
+
+void memcpy_from_sglist(void *buf, struct scatterlist *sg,
+			unsigned int start, unsigned int nbytes)
 {
 	struct scatter_walk walk;
-	struct scatterlist tmp[2];
 
-	if (!nbytes)
+	if (unlikely(nbytes == 0)) /* in case sg == NULL */
 		return;
 
-	sg = scatterwalk_ffwd(tmp, sg, start);
+	scatterwalk_start_at_pos(&walk, sg, start);
+	memcpy_from_scatterwalk(buf, &walk, nbytes);
+}
+EXPORT_SYMBOL_GPL(memcpy_from_sglist);
+
+void memcpy_to_sglist(struct scatterlist *sg, unsigned int start,
+		      const void *buf, unsigned int nbytes)
+{
+	struct scatter_walk walk;
+
+	if (unlikely(nbytes == 0)) /* in case sg == NULL */
+		return;
 
-	scatterwalk_start(&walk, sg);
-	scatterwalk_copychunks(buf, &walk, nbytes, out);
-	scatterwalk_done(&walk, out, 0);
+	scatterwalk_start_at_pos(&walk, sg, start);
+	memcpy_to_scatterwalk(&walk, buf, nbytes);
 }
-EXPORT_SYMBOL_GPL(scatterwalk_map_and_copy);
+EXPORT_SYMBOL_GPL(memcpy_to_sglist);
 
 struct scatterlist *scatterwalk_ffwd(struct scatterlist dst[2],
 				     struct scatterlist *src,
 				     unsigned int len)
 {
diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 8e83c43016c9d..1689ecd7ddafa 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -168,12 +168,32 @@ static inline void scatterwalk_done_dst(struct scatter_walk *walk,
 void scatterwalk_skip(struct scatter_walk *walk, unsigned int nbytes);
 
 void scatterwalk_copychunks(void *buf, struct scatter_walk *walk,
 			    size_t nbytes, int out);
 
-void scatterwalk_map_and_copy(void *buf, struct scatterlist *sg,
-			      unsigned int start, unsigned int nbytes, int out);
+void memcpy_from_scatterwalk(void *buf, struct scatter_walk *walk,
+			     unsigned int nbytes);
+
+void memcpy_to_scatterwalk(struct scatter_walk *walk, const void *buf,
+			   unsigned int nbytes);
+
+void memcpy_from_sglist(void *buf, struct scatterlist *sg,
+			unsigned int start, unsigned int nbytes);
+
+void memcpy_to_sglist(struct scatterlist *sg, unsigned int start,
+		      const void *buf, unsigned int nbytes);
+
+/* In new code, please use memcpy_{from,to}_sglist() directly instead. */
+static inline void scatterwalk_map_and_copy(void *buf, struct scatterlist *sg,
+					    unsigned int start,
+					    unsigned int nbytes, int out)
+{
+	if (out)
+		memcpy_to_sglist(sg, start, buf, nbytes);
+	else
+		memcpy_from_sglist(buf, sg, start, nbytes);
+}
 
 struct scatterlist *scatterwalk_ffwd(struct scatterlist dst[2],
 				     struct scatterlist *src,
 				     unsigned int len);
 
-- 
2.48.1

