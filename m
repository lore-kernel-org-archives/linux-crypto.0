Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1E7C8E6;
	Mon, 22 Sep 2025 19:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569629; cv=none; b=EEYgULITLNi02Lx+nhWiKK57m5KooEp49mb1mto0ekPE5DrClsajWLi4O4Lvr1RYDdfH1tShXIG548cND1DqHEsoj0tj92irzNFZ3y3AjULIQcrTH9UhVAEG//rL+jLM6fxs5oOgFJ79QlI7/cfWqHsnvmXjxhWHZteOCXRueTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569629; c=relaxed/simple;
	bh=IrQg6Vv0wi+DRwY6z0yV4/ONKVZi2S5tgaMi8ll5ddw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZPwNIsVa3ggWaeeNiAmrbA/jQp63i4js1YyJMig0t0z8cNaoJzkVBoJXApfK9Bx9BqUPRzsaT3JQK4Ri39u5Cyj68nE2jR3MY1csQQ6K+4UKpyhV5WT6C02okYbz5CSlCAcDV/WEaUCaPt/ATkBzPSaL+h3r25dF1PXwvpVEnZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i8ANt1vJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i8ANt1vJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A630C4CEF0;
	Mon, 22 Sep 2025 19:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569628;
	bh=IrQg6Vv0wi+DRwY6z0yV4/ONKVZi2S5tgaMi8ll5ddw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i8ANt1vJBV7GyI2srxfURf8PYHpdPI5mzWC3MSf9YUTfKZhynxBVJ/UnAyFO1OEKY
	 Fz/ImnssbfxvCDGR8zt0xB/tUSub8ZMelO7smac6KxMPg/Sz9e82XO82cfb7tKtv6+
	 7vAXqfXGm64/EW549RkvjxyLJSBnwt2B34oDlZdY=
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
Subject: [PATCH 6.1 60/61] crypto: af_alg: Convert af_alg_sendpage() to use MSG_SPLICE_PAGES
Date: Mon, 22 Sep 2025 21:29:53 +0200
Message-ID: <20250922192405.296352779@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/af_alg.c |   52 ++++++++--------------------------------------------
 1 file changed, 8 insertions(+), 44 deletions(-)

--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -993,53 +993,17 @@ EXPORT_SYMBOL_GPL(af_alg_sendmsg);
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
+		msg.msg_flags |= MSG_MORE;
 
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
-
-	return err ?: size;
+	bvec_set_page(&bvec, page, size, offset);
+	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
+	return sock_sendmsg(sock, &msg);
 }
 EXPORT_SYMBOL_GPL(af_alg_sendpage);
 


