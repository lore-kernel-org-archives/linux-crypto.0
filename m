Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0631F1934
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734772293; cv=none; b=jNqhYhnqifxkGTwo13onOatdUo5pJgz5jfGmlnzlgx1y6NUJgRt3T80MW0aTtcq+QeTkzmNKXn4amDbowOT4CbeLs9u93gJO0fOXjNwPnWmQN2n1NcybkaOth9HeKmt7LpuifUJgYWVk2sM+wQVgKfldiuftOQftkb6UhtD6xLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734772293; c=relaxed/simple;
	bh=Aca6uPsUCVLdX4GRY5oc+9eRqWCqEIgCJje21Fl6qos=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=skA5e8F57JWrjbdnPqbhrUpGr4ftJSOfWz9LtCtDY2olURzlAQzl22V1qefeEfjHuA85uiZb76OL793hCCbw8LxSyCpaESvDfjThl8ecyR87FGBBHCwTfx1kgVzjUrWzZm8/mhEryv0ZbYrP6Z3ybjHg9Llxf89d3nsaIf6iQIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mPGBks13; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mPGBks13"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DA2C4CEDE
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734772293;
	bh=Aca6uPsUCVLdX4GRY5oc+9eRqWCqEIgCJje21Fl6qos=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=mPGBks13ksjm0ws9HFGcj6woU1HYnFdK3XNldQVphhUrKV57svAfoQVA/Wvde9uZm
	 coQwk+QcqCEK8fZrInsg7kLTdy7ifd6JaxSzEQ69JdkQvV1uozrS+X+zHAqVa+QxVi
	 FC14jJvkOUGQNtNgs/9vJ1bAAxKhgyitAGDMHUtgAfOobV3cRGfi8onft21REOQ+Rb
	 ncf6qHIg2FyqeGNg2ELEdb02YIYQ3siQDtNcOHIa/T9UMUc8hmju5uE49479fdtmqD
	 3R4Xoq/XcAKk9Mqd2i4lRDvRFvQlmWFZ6JaEghDKffFUY4VclceAClzVvA6bv2tm6r
	 YxM9wKmmrHk6w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH 12/29] crypto: scatterwalk - add new functions for skipping data
Date: Sat, 21 Dec 2024 01:10:39 -0800
Message-ID: <20241221091056.282098-13-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241221091056.282098-1-ebiggers@kernel.org>
References: <20241221091056.282098-1-ebiggers@kernel.org>
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
index 16f6ba896fb6..af436ad02e3f 100644
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
index 924efbaefe67..5c7765f601e0 100644
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
2.47.1

