Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDEC376BC5;
	Thu, 30 Apr 2026 06:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777529356; cv=none; b=D+URSYKoGScItje5yNEsafHwL5CcmhRWjT7QYN4zOAR57bGbVbf31aIwEalPeZGTL3UqAYqwRQamIdvpNBJyP3FSCSQ8uH+Hxdc+3JEFBxi+FWxKs0Mr+aTm0J9VkeU5F9xGmDqqMjC3/S28RR0Mpvf/B+90bAJ9nlrZMFzj7Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777529356; c=relaxed/simple;
	bh=sr/f9Lr5wW1xpPMJcZMlwcXcPqHJHTuJ+wYIz/vrseM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PbfYKrn8BVKNg8k09JC+gm5KYRSXy5I+9rd1WBg+VuEDu5njT/ttqo6Ma2VpN2GKS6sqNui7kUfC9PsJIDWlvNdQDVAs/zH7/d1PV4eGGhYtEcErtXwMo34jGRB2PeKqTZ5LQcZRXoLwkU9cD7TAzMzV+vOR5TnvapHX0wubsdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cnyZDYMv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cnyZDYMv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A28C2BCC7;
	Thu, 30 Apr 2026 06:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777529356;
	bh=sr/f9Lr5wW1xpPMJcZMlwcXcPqHJHTuJ+wYIz/vrseM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cnyZDYMvcrym9jvg14eULfgKfv9rPRPLSrFiiJHbRHBlVLKbOb/PlrTSknO8ZYQBj
	 flSZlmq6+LsOxujF9mE5bXf/UA/wYJIztWG3E8rBzAEhTZhFNCctzbEVbMwZO7zQ8G
	 nGWZxjLa9kApRjxyxwR1noZfoue7NfZb8bfaipkIk5lELxLU9JCo5dnq3kOLWi/vRR
	 62i3hkEehdppMHJfxVrEML+u3AfeQCwyBJRyv0wTc+lEdMkE1JZxognQkSTnRRWYWQ
	 vV2IRqEtxEqJRWE5ljXOKrMNGY/tNSpqk7RLHl6euYQAUlVn1krD3mthgxHp1uAoGO
	 5twQKL83TylDw==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	syzbot+d23888375c2737c17ba5@syzkaller.appspotmail.com,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.12 8/8] crypto: af_alg - Fix page reassignment overflow in af_alg_pull_tsgl
Date: Wed, 29 Apr 2026 23:07:02 -0700
Message-ID: <20260430060702.110091-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260430060702.110091-1-ebiggers@kernel.org>
References: <20260430060702.110091-1-ebiggers@kernel.org>
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
index 6867d177f2a2..b61c3ba126ed 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -703,12 +703,12 @@ void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst)
 
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

