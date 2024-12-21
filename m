Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC631EE7DD
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734772293; cv=none; b=gR7vHEnPU3N5NSNIZqapw7U4j0BiQTsAHxXeQY0Oweo0yaAw/P+Mn2utxIOPnXeMxsDY03aqxi/Yea0sMaG9TdUV546tkkbnCz8t+5B4PzpinE4Zsn+HTbO8LQrvSGei28pEFSVYVB6wEtimSxqZJSuNDYYG9m5h24fZ9tK1bqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734772293; c=relaxed/simple;
	bh=IpLvn2XtgphqyEr3C9o4IvzLjuZxaBrxGrUoOcvifmA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qeDFfAQy5vN7Pdat3nw+/z52rIiK+kLlijyTOU2dNWcXgqvqTvnKFaJek1JBY8RrQ/kmK3f+P/nIuYC/Swo6fD9+IvLQL2N+o/CChPnWo8x/PE4cZvtdiIz2nbiv2wrXYQh9rcNsRP9JA32jRpibUT72CIlcc0iciKtQt8xHM4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M0u3+23w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M0u3+23w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14C74C4CED4
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734772293;
	bh=IpLvn2XtgphqyEr3C9o4IvzLjuZxaBrxGrUoOcvifmA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=M0u3+23wxoV7Qb2vc2vXkX9uoYGRF52/z4p07iUeZU3SUy/FjO1byrEge4lzsmwXL
	 5MWOVgv0oLx9ZEUuSDx56GpcbYjlBnVbZPeXhvgxUw+GF47D3Ynugjs9ngiNbtLeOH
	 iE0Qlgd5YDH1rr1FSDas7r9MAbebNdQtw+n/CRlq1ezJ9FyyHRJezDXS6bRk19BBVi
	 Cogs/cjX/Wo3P3LnxTD/ANIDwafcHOWsRQAkYRn8jCXHqD2IwJWeiBun7x1jxyKlzs
	 Wf7vM4p0QYgo0FGqUEWC0bz9Koxfy5OhJ1172DYDqkeDHJz2vKRYFaF20rzL1W/0yL
	 r+KyCGvJ29QSQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH 11/29] crypto: scatterwalk - move to next sg entry just in time
Date: Sat, 21 Dec 2024 01:10:38 -0800
Message-ID: <20241221091056.282098-12-ebiggers@kernel.org>
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

The scatterwalk_* functions are designed to advance to the next sg entry
only when there is more data from the request to process.  Compared to
the alternative of advancing after each step if !sg_is_last(sg), this
has the advantage that it doesn't cause problems if users accidentally
don't terminate their scatterlist with the end marker (which is an easy
mistake to make, and there are examples of this).

Currently, the advance to the next sg entry happens in
scatterwalk_done(), which is called after each "step" of the walk.  It
requires the caller to pass in a boolean 'more' that indicates whether
there is more data.  This works when the caller immediately knows
whether there is more data, though it adds some complexity.  However in
the case of scatterwalk_copychunks() it's not immediately known whether
there is more data, so the call to scatterwalk_done() has to happen
higher up the stack.  This is error-prone, and indeed the needed call to
scatterwalk_done() is not always made, e.g. scatterwalk_copychunks() is
sometimes called multiple times in a row.  This causes a zero-length
step to get added in some cases, which is unexpected and seems to work
only by accident.

This patch begins the switch to a less error-prone approach where the
advance to the next sg entry happens just in time instead.  For now,
that means just doing the advance in scatterwalk_clamp() if it's needed
there.  Initially this is redundant, but it's needed to keep the tree in
a working state as later patches change things to the final state.

Later patches will similarly move the dcache flushing logic out of
scatterwalk_done() and then remove scatterwalk_done() entirely.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/crypto/scatterwalk.h | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 32fc4473175b..924efbaefe67 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -24,22 +24,30 @@ static inline void scatterwalk_crypto_chain(struct scatterlist *head,
 		sg_chain(head, num, sg);
 	else
 		sg_mark_end(head);
 }
 
+static inline void scatterwalk_start(struct scatter_walk *walk,
+				     struct scatterlist *sg)
+{
+	walk->sg = sg;
+	walk->offset = sg->offset;
+}
+
 static inline unsigned int scatterwalk_pagelen(struct scatter_walk *walk)
 {
 	unsigned int len = walk->sg->offset + walk->sg->length - walk->offset;
 	unsigned int len_this_page = offset_in_page(~walk->offset) + 1;
 	return len_this_page > len ? len : len_this_page;
 }
 
 static inline unsigned int scatterwalk_clamp(struct scatter_walk *walk,
 					     unsigned int nbytes)
 {
-	unsigned int len_this_page = scatterwalk_pagelen(walk);
-	return nbytes > len_this_page ? len_this_page : nbytes;
+	if (walk->offset >= walk->sg->offset + walk->sg->length)
+		scatterwalk_start(walk, sg_next(walk->sg));
+	return min(nbytes, scatterwalk_pagelen(walk));
 }
 
 static inline void scatterwalk_advance(struct scatter_walk *walk,
 				       unsigned int nbytes)
 {
@@ -54,17 +62,10 @@ static inline struct page *scatterwalk_page(struct scatter_walk *walk)
 static inline void scatterwalk_unmap(void *vaddr)
 {
 	kunmap_local(vaddr);
 }
 
-static inline void scatterwalk_start(struct scatter_walk *walk,
-				     struct scatterlist *sg)
-{
-	walk->sg = sg;
-	walk->offset = sg->offset;
-}
-
 static inline void *scatterwalk_map(struct scatter_walk *walk)
 {
 	return kmap_local_page(scatterwalk_page(walk)) +
 	       offset_in_page(walk->offset);
 }
-- 
2.47.1

