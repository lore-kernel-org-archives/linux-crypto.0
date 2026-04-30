Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6033783B4;
	Thu, 30 Apr 2026 06:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777531076; cv=none; b=ARad8XhDMwzpZrJLa6SOYADrNEg+AplM6TvE2aDhrWP2WUcK8/RNzlSCz6C3QoY1uV52TB/8Ep5nf5gCs7bPCv13aXrD/LbEAiR81Ub8MEEB2CEmgZr6XlPppNJU8rMU1wLrNKygj4zkgjyDkH8i/9sCq7o/Rqp2caat2rzDkRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777531076; c=relaxed/simple;
	bh=MtdvDNBZf7D25wdl3A2GvDJjG3yRz7P/qNzSC7Cn+3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EtvBNH8NkY+Wk4Ru5Tkh1RseLD2/HH7DYFw3kmtVAVX8QkVZUp3rmyVp8xReF/IceIs4qAo5FZY0yQtPlRSJ2tsP4VQvx4yc7SszeLLTHll8DH8Ef3pE4xQiTRfK+k4hSyWrgDF5iqt+KluBBcD43y2Cv9N9LEgub/30YzisKXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pJK1YTct; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pJK1YTct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C83BC2BCB8;
	Thu, 30 Apr 2026 06:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777531076;
	bh=MtdvDNBZf7D25wdl3A2GvDJjG3yRz7P/qNzSC7Cn+3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pJK1YTcteWskA1mXD4iPYaxJ3YbJbrwXNZi6EZwpyDolNikzotScgCUJ/V2IHd5Io
	 8N7hab8jmhobUeGMgYvfOOOw7MtptyQxM+Pei/iLzf7hc6sWzIwDjD1QwA1vxYdPzi
	 nVc672+zs4ZN9k4M2rFsWDvXv8gfN/KDvMRUediWKdf8+92u9fuxE04FZ3EBtbKPBB
	 jI/CQb1r6RpC8zf/W2+rFhbqNo44MNu1ap91Y5w9FOr2vPrFwnR+LeEFeUIRzwKS1P
	 X4XIl6lTulG1gWnmMDbuTXJfCqeCCMuQhk4FVW3XwHQX76miWb6Cu+NnuttmOFJ58U
	 M6vpimqs1IShQ==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	syzbot+d23888375c2737c17ba5@syzkaller.appspotmail.com,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5.15 8/9] crypto: af_alg - Fix page reassignment overflow in af_alg_pull_tsgl
Date: Wed, 29 Apr 2026 23:36:03 -0700
Message-ID: <20260430063604.173525-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260430063604.173525-1-ebiggers@kernel.org>
References: <20260430063604.173525-1-ebiggers@kernel.org>
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
index 4f667a503277..8f7cf57da8f6 100644
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

