Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC0A19CC34;
	Mon, 30 Dec 2024 00:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735517764; cv=none; b=GQrncbUXID7CBrF1ZGVV8sqvYzsEFCRygHNbfhXVhrO7dhfYX03P8naLI4pM3Pn+mFlcY+xdiN0JuAX0bYiQG/EtXqfl2XLUifhFfXkEMYr2Uj/FGqYAQgT8f/Zd71CEB2VqHPGzINaN7fVoMlYHddxlBK4tqJGyXXUcjVuAj1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735517764; c=relaxed/simple;
	bh=g1Sicjo3WPDOTEntvGipxb6vfLBqpP+1OtFMoBb3F/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kf/IR9XyqMMA6PJf9fBrHsU/PLPmHDGxwBal1bkjd9kLOyjbtS9ekecB8eZVLGqPSh0yKAHpNHjuPju8TAp481GvdfBGDJFgK0ytYV/0tZiUrVOIqXFI0uUKBs/BGdQCWDs87OQ0J6WHaEFjbeq7SvGuHsynIROjOIl4WW+3I58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EE7ZUPdE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EE7ZUPdE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07671C4CED7;
	Mon, 30 Dec 2024 00:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735517764;
	bh=g1Sicjo3WPDOTEntvGipxb6vfLBqpP+1OtFMoBb3F/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EE7ZUPdEs6gq4ZJHyxBrpeS0Zbu0Fd/jruAryECxZgzOYDaBtapoVF25BOdhXwAMB
	 TfZ4VjuSnswCJUYhKp1W700mb+gBZAnjn+8OeoTxueTyi8iRuOs/s46tXfKxu5vJq2
	 c9Hlh0Dj9x4lEfpGYie0kV0Y/yNn0zQuCBOstT2Dt9Yw0Lt/SvR0KLc4D5PcGgXWf5
	 9O5QEOS2DtiE5mU2z9UU5m1etRpbrDHhujFxwsymU4KjtSxSZBCTWFcvx9WGy2RTkJ
	 dj7SFRZuZNRxINaIdpOWGNJBuzZesaa/1ru1tnAXj6J9AX7HNzvOi2pQxmEgQCJXyE
	 6FSK0oxlRsaxQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Boris Pismenny <borisp@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH v2 15/29] crypto: scatterwalk - add scatterwalk_get_sglist()
Date: Sun, 29 Dec 2024 16:14:04 -0800
Message-ID: <20241230001418.74739-16-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230001418.74739-1-ebiggers@kernel.org>
References: <20241230001418.74739-1-ebiggers@kernel.org>
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

This patch is part of a long series touching many files, so I have
limited the Cc list on the full series.  If you want the full series and
did not receive it, please retrieve it from lore.kernel.org.

 include/crypto/scatterwalk.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 1689ecd7ddaf..f6262d05a3c7 100644
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
2.47.1

