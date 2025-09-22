Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8FDC8E6;
	Mon, 22 Sep 2025 19:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569596; cv=none; b=OSowsJXo3idLWjieZmGm+XemvmR3WH8Mi8vTdwtOhxqKtE3ufu/wPezr7jc4A6Mc1AOX/k7gghc3edWKV2RQxWDyUr8y24nrgoSskZRVk9PdKBm4IOG5D74Q5ZF0t/qMMtsKJlSKbzZpL8e337gV1TgjLGjAlRWU9/QkVuGDs10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569596; c=relaxed/simple;
	bh=sfT+IJse1FrSPI1QrtOhgBawGx7fENamNyLEGl6DQCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W/5TjzfWY7tpa+111WVzKw1KYafN7ECGcIreVKRYu66yEpslT5qHWR0QwoQ2tM7YcpNZIfmstaEN331j5Y1hi6VLgNQQZ9yVCyYCJUcvr3fJ4fK1M8UQshHdhD8Ihl9x6h7GCjHxS3Gfpy65HKJNeO1fR1/IZUIG2DivDso4g9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=19wjZ0P3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="19wjZ0P3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4CCC4CEF0;
	Mon, 22 Sep 2025 19:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569596;
	bh=sfT+IJse1FrSPI1QrtOhgBawGx7fENamNyLEGl6DQCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=19wjZ0P3zj2FO9YarwEjb0Q51ScXiGZlJJLakxhYFNt7mrax7hxbZcwbeHjElOiK0
	 XqIg7jqWZi3Mu/cS4Ar2pMEvHa2VTuBXCOS5vNlvkA7du0M2eXnUfHs2Woo5trFvdN
	 rbcKQ7CCeiRQnJLz8ZdCx40ZLigpIPZryHTqr2Kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Matthew Wilcox <willy@infradead.org>,
	linux-crypto@vger.kernel.org,
	netdev@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 43/61] crypto: af_alg: Indent the loop in af_alg_sendmsg()
Date: Mon, 22 Sep 2025 21:29:36 +0200
Message-ID: <20250922192404.764714238@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
References: <20250922192403.524848428@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 73d7409cfdad7fd08a9203eb2912c1c77e527776 ]

Put the loop in af_alg_sendmsg() into an if-statement to indent it to make
the next patch easier to review as that will add another branch to handle
MSG_SPLICE_PAGES to the if-statement.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Herbert Xu <herbert@gondor.apana.org.au>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: linux-crypto@vger.kernel.org
cc: netdev@vger.kernel.org
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 9574b2330dbd ("crypto: af_alg - Set merge to zero early in af_alg_sendmsg")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/af_alg.c | 51 ++++++++++++++++++++++++++-----------------------
 1 file changed, 27 insertions(+), 24 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index fef69d2a6b183..d5a8368a47c5c 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -927,35 +927,38 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		if (sgl->cur)
 			sg_unmark_end(sg + sgl->cur - 1);
 
-		do {
-			struct page *pg;
-			unsigned int i = sgl->cur;
+		if (1 /* TODO check MSG_SPLICE_PAGES */) {
+			do {
+				struct page *pg;
+				unsigned int i = sgl->cur;
 
-			plen = min_t(size_t, len, PAGE_SIZE);
+				plen = min_t(size_t, len, PAGE_SIZE);
 
-			pg = alloc_page(GFP_KERNEL);
-			if (!pg) {
-				err = -ENOMEM;
-				goto unlock;
-			}
+				pg = alloc_page(GFP_KERNEL);
+				if (!pg) {
+					err = -ENOMEM;
+					goto unlock;
+				}
 
-			sg_assign_page(sg + i, pg);
+				sg_assign_page(sg + i, pg);
 
-			err = memcpy_from_msg(page_address(sg_page(sg + i)),
-					      msg, plen);
-			if (err) {
-				__free_page(sg_page(sg + i));
-				sg_assign_page(sg + i, NULL);
-				goto unlock;
-			}
+				err = memcpy_from_msg(
+					page_address(sg_page(sg + i)),
+					msg, plen);
+				if (err) {
+					__free_page(sg_page(sg + i));
+					sg_assign_page(sg + i, NULL);
+					goto unlock;
+				}
 
-			sg[i].length = plen;
-			len -= plen;
-			ctx->used += plen;
-			copied += plen;
-			size -= plen;
-			sgl->cur++;
-		} while (len && sgl->cur < MAX_SGL_ENTS);
+				sg[i].length = plen;
+				len -= plen;
+				ctx->used += plen;
+				copied += plen;
+				size -= plen;
+				sgl->cur++;
+			} while (len && sgl->cur < MAX_SGL_ENTS);
+		}
 
 		if (!size)
 			sg_mark_end(sg + sgl->cur - 1);
-- 
2.51.0



