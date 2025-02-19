Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1D4215190;
	Wed, 19 Feb 2025 18:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739989469; cv=none; b=gH3wk7iIMkRe0Zbz3VOuVvCnA0isC5pvCXTcJg9X9xm6LVAy84Z86ncGMZMG/hMg8gWro4khUN3q6xZ/CzF75ALNygBIkBfdU1WvvB5NmJV6i7R0pKOlffOEF5XtgKg9tOT9iy8VyXzfKo/WE9rLMYIYsa1PPtDIau0pOHuoqvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739989469; c=relaxed/simple;
	bh=EysGDlA5oq+5j65CW6jee6qyfljbpHPT03HmtDvEdaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YuK/0uUxe5HNoHPIgSqkY2FlDuMwDQoCEgCEekewRivRWTtjN56ndvvmLZPiHvELe5xvwv7TVZUbQR4hD3/jhVsAJ5aQohfK2tttyzeYoqeX6Degy/Rs3j9g3gwAC7D0XZ+HTPcTdgAorLsTZ3OlYKeCIrvEfWBgae7hcQ52HKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TSIX94DU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TSIX94DU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390A4C4CEF0;
	Wed, 19 Feb 2025 18:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739989468;
	bh=EysGDlA5oq+5j65CW6jee6qyfljbpHPT03HmtDvEdaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TSIX94DUVd7IDrUg3YeyYUii15FYTIUgo72G/3I4+nNvGA34b0rB8tjgPNuJkbn4K
	 ea6xBl4YiGEMSTQeJ5YZBxe3KoWJUihhuxTds9lNbvf5DURmQIZFsO+w5MEJRuhV/+
	 U2iWf1UYf75AFbl+64eOL1Sb7ck2rLoRNXypJJfybiLi2xqGme8Os3KN9GCkcxrQ/s
	 mfOmH2NpmTSOlQeVtqjoo1fcMPeEDX3ODRP+LeMZLxgL/gHzHEdM+FFImgLHryL3/q
	 u/W/VIZDbJlOXn20/blQhQVFWdN61MrHbXq8DAVevb1PhyWzY/H4SyUPQhNvJR42oK
	 gHanPW+MKUNJQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	Boris Pismenny <borisp@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH v3 05/19] crypto: scatterwalk - add scatterwalk_get_sglist()
Date: Wed, 19 Feb 2025 10:23:27 -0800
Message-ID: <20250219182341.43961-6-ebiggers@kernel.org>
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

Add a function that creates a scatterlist that represents the remaining
data in a walk.  This will be used to replace chain_to_walk() in
net/tls/tls_device_fallback.c so that it will no longer need to reach
into the internals of struct scatter_walk.

Cc: Boris Pismenny <borisp@nvidia.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/crypto/scatterwalk.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 1689ecd7ddafa..f6262d05a3c75 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -67,10 +67,27 @@ static inline unsigned int scatterwalk_clamp(struct scatter_walk *walk,
 static inline struct page *scatterwalk_page(struct scatter_walk *walk)
 {
 	return sg_page(walk->sg) + (walk->offset >> PAGE_SHIFT);
 }
 
+/*
+ * Create a scatterlist that represents the remaining data in a walk.  Uses
+ * chaining to reference the original scatterlist, so this uses at most two
+ * entries in @sg_out regardless of the number of entries in the original list.
+ * Assumes that sg_init_table() was already done.
+ */
+static inline void scatterwalk_get_sglist(struct scatter_walk *walk,
+					  struct scatterlist sg_out[2])
+{
+	if (walk->offset >= walk->sg->offset + walk->sg->length)
+		scatterwalk_start(walk, sg_next(walk->sg));
+	sg_set_page(sg_out, sg_page(walk->sg),
+		    walk->sg->offset + walk->sg->length - walk->offset,
+		    walk->offset);
+	scatterwalk_crypto_chain(sg_out, sg_next(walk->sg), 2);
+}
+
 static inline void scatterwalk_unmap(void *vaddr)
 {
 	kunmap_local(vaddr);
 }
 
-- 
2.48.1

