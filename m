Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B831A39B4A9;
	Thu, 30 Apr 2026 07:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777532613; cv=none; b=Fl1pDdrv7WW3Kg5HQUvj9d6VBQ79qAJ/pxE6+mgp+ZhWflfsfH1DS8EQjBMf3ZkCvTO8qVEmWHqTNLRJoTwhhOjZed/1lh/cWyVUP5xdpmflYqw0HpJF8bVvixfc/c8L0Y9G3xHjYt4SmrVcL7pnwStpLFvLwRXtaBFNltn8iWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777532613; c=relaxed/simple;
	bh=SscrE8l29M6LG4nvWw571I7MTKgwXoS3POvaHh7W6Q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRf3aNKyTi4Xq1uIK2eLw9g9izwETT1/ofu5mKa3Ddwju9pHjjVcqHkWAFWeZeItQK5GgUWrdp/BeZ0CNiBfRucE7rsl3e8PjiLFQlU33qOQJ5dD3hixiOLdPVZlihkVvFpJ8WvXjr7Tj0VUepk8gy5qNUcyOZDIGeQ2ZDJHZiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gbsxfrjr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gbsxfrjr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A275C2BCB4;
	Thu, 30 Apr 2026 07:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777532613;
	bh=SscrE8l29M6LG4nvWw571I7MTKgwXoS3POvaHh7W6Q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GbsxfrjrLoA801dRV0OXzJUVxNIgDx5btbnq/HpAkqpJsw8Bvz9AcJ1kOFtJpPwwg
	 Rl+pfyNHQxy1MYietMvxzm+2WmaLMyR3JcLVjs0l2Tn9COcrBSnyf3vc5+BfTfYMdL
	 8k6SoUggFkVAelUcaNWBgqoDSxAj+Ok4nvkmGBT4BqamEpJtA8mtrTV2viKsbK3uYi
	 0urs65l6ZLzzFeqn3NhMjSYxJ6qtVwHVOMby5RdJkG4cCvo6GTGjQIz7PkZ3I8IYpN
	 dVi1jGKvjk2vCbpdRlDDoqBkBTxYpL0QI4gqziyOsCv8AsRKDb3/SdzW9S1RvlQAAD
	 /L2SZR9G7ObEg==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	syzbot+d23888375c2737c17ba5@syzkaller.appspotmail.com,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5.10 09/10] crypto: af_alg - Fix page reassignment overflow in af_alg_pull_tsgl
Date: Thu, 30 Apr 2026 00:01:27 -0700
Message-ID: <20260430070128.219863-10-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260430070128.219863-1-ebiggers@kernel.org>
References: <20260430070128.219863-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 31d00156e50ecad37f2cb6cbf04aaa9a260505ef upstream.

When page reassignment was added to af_alg_pull_tsgl the original
loop wasn't updated so it may try to reassign one more page than
necessary.

Add the check to the reassignment so that this does not happen.

Also update the comment which still refers to the obsolete offset
argument.

Reported-by: syzbot+d23888375c2737c17ba5@syzkaller.appspotmail.com
Fixes: e870456d8e7c ("crypto: algif_skcipher - overhaul memory management")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/af_alg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index f9bf3bb539c5..a6e8ce25ff10 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -595,12 +595,12 @@ void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst)
 
 			/*
 			 * Assumption: caller created af_alg_count_tsgl(len)
 			 * SG entries in dst.
 			 */
-			if (dst) {
-				/* reassign page to dst after offset */
+			if (dst && plen) {
+				/* reassign page to dst */
 				get_page(page);
 				sg_set_page(dst + j, page, plen, sg[i].offset);
 				j++;
 			}
 
-- 
2.54.0

