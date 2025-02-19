Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2210E215047;
	Wed, 19 Feb 2025 18:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739989468; cv=none; b=PIggyfCJQlGrP19npt6dARJCFybWaMqr248fOOxGAg/rbHHH2yvzyBzQXcztEWsdzigzmhgg99PBcCiFY3PEIoNKJXJiMyy3P5aR3mmyyNMIEdVy89ai0S0lvm2zdrJAtietaeKXtSoLhBDzf468PWtGVTaFIDopp3jcLh4Cebk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739989468; c=relaxed/simple;
	bh=4ROhMmEsNLF2YYzrY0DHsJpJVGk+E2lah7WqkxnGUvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2qHYbU9yy9rQzMINp9r87bCd5ZN4J8uvi9OEmbxslKcQuga84S8MOcIRp/QLUo0QMR326408bkizKluhcHfyH4h9iNeuNWC1Pfmv/ptatoMp8zDgsHHPX1XGqj66oA5ohDpzYfw8mSN6jJrdA9TWEBE/xd50ZlnvXXFAg5zjig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bmexRrs5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bmexRrs5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB42C4CEE6;
	Wed, 19 Feb 2025 18:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739989467;
	bh=4ROhMmEsNLF2YYzrY0DHsJpJVGk+E2lah7WqkxnGUvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bmexRrs5fkL2+9EDPVU/2KZCdQihNyFviHSlDsrWbVz6x5YLZN67AyTHtqWhO2gkj
	 HrpnS5SAlRZtFhMnkUIlU+7xnXwzosgvTqS3+pzgz4jhGuQh6JX8CiGDwf1BpNMAg3
	 /Jo05NhOv17CuQA9Y175TerzY2o+QRVVyc+6kc4Q7WCam9hzGRySKCvfA9LtETSBmM
	 7nSZMVj3X0QWS3e1ijL6r/g/M05uN7lWTRsEimvIkRWU7EI2Dh9wsXF0lSlK0gMe0E
	 GQ+ntcWwYLcdwVx4neMUQQuB8VeXmQJ88GaLpdTgNYcoCWBRFNkVYN9WEmbH7p0c+f
	 isoxEh7TtJatg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH v3 02/19] crypto: scatterwalk - add new functions for skipping data
Date: Wed, 19 Feb 2025 10:23:24 -0800
Message-ID: <20250219182341.43961-3-ebiggers@kernel.org>
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

Add scatterwalk_skip() to skip the given number of bytes in a
scatter_walk.  Previously support for skipping was provided through
scatterwalk_copychunks(..., 2) followed by scatterwalk_done(), which was
confusing and less efficient.

Also add scatterwalk_start_at_pos() which starts a scatter_walk at the
given position, equivalent to scatterwalk_start() + scatterwalk_skip().
This addresses another common need in a more streamlined way.

Later patches will convert various users to use these functions.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/scatterwalk.c         | 15 +++++++++++++++
 include/crypto/scatterwalk.h | 18 ++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 16f6ba896fb63..af436ad02e3ff 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -13,10 +13,25 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/scatterlist.h>
 
+void scatterwalk_skip(struct scatter_walk *walk, unsigned int nbytes)
+{
+	struct scatterlist *sg = walk->sg;
+
+	nbytes += walk->offset - sg->offset;
+
+	while (nbytes > sg->length) {
+		nbytes -= sg->length;
+		sg = sg_next(sg);
+	}
+	walk->sg = sg;
+	walk->offset = sg->offset + nbytes;
+}
+EXPORT_SYMBOL_GPL(scatterwalk_skip);
+
 static inline void memcpy_dir(void *buf, void *sgdata, size_t nbytes, int out)
 {
 	void *src = out ? buf : sgdata;
 	void *dst = out ? sgdata : buf;
 
diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 924efbaefe67a..5c7765f601e0c 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -31,10 +31,26 @@ static inline void scatterwalk_start(struct scatter_walk *walk,
 {
 	walk->sg = sg;
 	walk->offset = sg->offset;
 }
 
+/*
+ * This is equivalent to scatterwalk_start(walk, sg) followed by
+ * scatterwalk_skip(walk, pos).
+ */
+static inline void scatterwalk_start_at_pos(struct scatter_walk *walk,
+					    struct scatterlist *sg,
+					    unsigned int pos)
+{
+	while (pos > sg->length) {
+		pos -= sg->length;
+		sg = sg_next(sg);
+	}
+	walk->sg = sg;
+	walk->offset = sg->offset + pos;
+}
+
 static inline unsigned int scatterwalk_pagelen(struct scatter_walk *walk)
 {
 	unsigned int len = walk->sg->offset + walk->sg->length - walk->offset;
 	unsigned int len_this_page = offset_in_page(~walk->offset) + 1;
 	return len_this_page > len ? len : len_this_page;
@@ -90,10 +106,12 @@ static inline void scatterwalk_done(struct scatter_walk *walk, int out,
 	if (!more || walk->offset >= walk->sg->offset + walk->sg->length ||
 	    !(walk->offset & (PAGE_SIZE - 1)))
 		scatterwalk_pagedone(walk, out, more);
 }
 
+void scatterwalk_skip(struct scatter_walk *walk, unsigned int nbytes);
+
 void scatterwalk_copychunks(void *buf, struct scatter_walk *walk,
 			    size_t nbytes, int out);
 
 void scatterwalk_map_and_copy(void *buf, struct scatterlist *sg,
 			      unsigned int start, unsigned int nbytes, int out);
-- 
2.48.1

