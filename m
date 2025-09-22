Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BFC831A072;
	Mon, 22 Sep 2025 18:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758566695; cv=none; b=jXHWa4SBzoqeimVEMts1fo+HI0d+deppSd0THFyKe9VaSaZPT+83EPOZT34z0badRPUrT9z9tclmMFJ1MTy37gv1cvqTDNt9K4ACkEzRGggr0zUReGl6pDz/bux0aOAEzNRKlgfHcbWQOFIp3FpaR14ISEHG7rgzNnMro1R4mQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758566695; c=relaxed/simple;
	bh=nDihmTHN0i+Udss+eRUPYurGFwIdLxD8LvfaHe21yig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KVRF89Ti7hIhIvfhpQFxtXfPbE/hMHGLw3WuAGAbXsfNGnPeuSSfNhl8kNqZY85p55laDT1Exq4EMzbgjlOZ+TWIRXHqzNSgOpQXFT0ztDYwPCxcHf31qLKxdLKTttMz0VGalET6w2r1cWF8Y+5zTlgyFQuZj0qw8DJ+G7S1BdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JWYj8cuw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JWYj8cuw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A29C4CEF0;
	Mon, 22 Sep 2025 18:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758566694;
	bh=nDihmTHN0i+Udss+eRUPYurGFwIdLxD8LvfaHe21yig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JWYj8cuwziAItxd6hvXp1sEsLX9ovM4ff61s/AxjQvDBOKHvx5XU+t07zoihLY2Hm
	 EWMAGSKWQ6Eg0b1gCCNGZMCt1FTiDz3mQEGPXBYo7XX/Fs6I3295l9aU6MuHObzOkA
	 7AyweoMw5kNCNmx27aMUiuQrlLFkJ20bCDl6T3/dm2S/uAu9VnGG3ioqgN4Qw7pDad
	 EJQKtUCJxUZi7gNXeYyv1OXjYBqirLkKyFMz8UH5GwkKtc3i3fJl3P/q+OrtQiQVz6
	 mdAC6A/KctKxaB1m0+/Nurn3rNLg5XPjjyHoDD9AzpvyV5w2dLxKq+Xs+hW1qWtYlO
	 8/3G/U7Bov8eQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
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
Subject: [PATCH 6.1.y 1/2] crypto: af_alg: Convert af_alg_sendpage() to use MSG_SPLICE_PAGES
Date: Mon, 22 Sep 2025 14:44:48 -0400
Message-ID: <20250922184449.3864288-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <2025092107-making-cough-9671@gregkh>
References: <2025092107-making-cough-9671@gregkh>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

[ Upstream commit fb800fa4c1f5aee1238267252e88a7837e645c02 ]

Convert af_alg_sendpage() to use sendmsg() with MSG_SPLICE_PAGES rather
than directly splicing in the pages itself.

This allows ->sendpage() to be replaced by something that can handle
multiple multipage folios in a single transaction.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/af_alg.c | 52 ++++++++-----------------------------------------
 1 file changed, 8 insertions(+), 44 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index fef69d2a6b183..303225c674558 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -988,53 +988,17 @@ EXPORT_SYMBOL_GPL(af_alg_sendmsg);
 ssize_t af_alg_sendpage(struct socket *sock, struct page *page,
 			int offset, size_t size, int flags)
 {
-	struct sock *sk = sock->sk;
-	struct alg_sock *ask = alg_sk(sk);
-	struct af_alg_ctx *ctx = ask->private;
-	struct af_alg_tsgl *sgl;
-	int err = -EINVAL;
+	struct bio_vec bvec;
+	struct msghdr msg = {
+		.msg_flags = flags | MSG_SPLICE_PAGES,
+	};
 
 	if (flags & MSG_SENDPAGE_NOTLAST)
-		flags |= MSG_MORE;
-
-	lock_sock(sk);
-	if (!ctx->more && ctx->used)
-		goto unlock;
-
-	if (!size)
-		goto done;
-
-	if (!af_alg_writable(sk)) {
-		err = af_alg_wait_for_wmem(sk, flags);
-		if (err)
-			goto unlock;
-	}
-
-	err = af_alg_alloc_tsgl(sk);
-	if (err)
-		goto unlock;
-
-	ctx->merge = 0;
-	sgl = list_entry(ctx->tsgl_list.prev, struct af_alg_tsgl, list);
-
-	if (sgl->cur)
-		sg_unmark_end(sgl->sg + sgl->cur - 1);
-
-	sg_mark_end(sgl->sg + sgl->cur);
-
-	get_page(page);
-	sg_set_page(sgl->sg + sgl->cur, page, size, offset);
-	sgl->cur++;
-	ctx->used += size;
-
-done:
-	ctx->more = flags & MSG_MORE;
-
-unlock:
-	af_alg_data_wakeup(sk);
-	release_sock(sk);
+		msg.msg_flags |= MSG_MORE;
 
-	return err ?: size;
+	bvec_set_page(&bvec, page, size, offset);
+	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
+	return sock_sendmsg(sock, &msg);
 }
 EXPORT_SYMBOL_GPL(af_alg_sendpage);
 
-- 
2.51.0

