Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F77270EB9
	for <linux-crypto@vger.kernel.org>; Fri, 11 Apr 2025 01:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744334822; cv=none; b=f3taZap0d36FdP8MEvlqr01PliM0HQKxs11dWdLdVZDGqjgikCx4PPfSxFoBNqWpYnP2G139rqHoj7gXuAWotSxCvidzKi5I6PU7tBSnz7hzXTuqi3U+qokH08K5eVocjXoeS1n3omuF73VrGty1k6Dmofrkttk6HQp0vENbY+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744334822; c=relaxed/simple;
	bh=GFXTXV040RsmUJNiQbzt1w1O4fMxeOlMMj195YesQmI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NuvLxjOLG+i9hMY7SnK5n78DvaiHji/TD3rdSxJZvzLFuw2J3G2+H4JqCm3awPKCXMRT4lTuloqfZVSMs6LpV6F7g/GLiRrM5suV4FHnFgYY7gJEttrmvnQIrwu6tA3cNWgofCNuuP8ntnqEZPh3oTlqvUmwjOBagBxETHQuVmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=fT/3VHi7; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="fT/3VHi7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=U8X4Xd5itQi+5QF+MLZgFBWZKegYshEvGJsD3c3eoTQ=; b=fT/3VHi7b/39KJrETaN5nxgXq0
	nIEJZHexyhXC/4lntiXpAQ1KpI0G6ANJj/U2enWy6oR7T+GHQLQtOOEP7rs8WYA2MiqVzvVCAozWD
	NGEiljJcNzxQX33IhgaAB0j4qhSPjfowpJk+BnmLOj+dYhgikReMW+Dq95fwYacTbJGHCq2l4PFao
	qHMMOKwNFXL5ahY47TlaCFTuSP9qGphyxg2UYZ29vOFcYlnV/izRSgqWRsjGmIyvUgiWzls7Hvwqo
	vw45CkoLgsmIw+eiQ+SXlLq035KW1xmN325Fp5bnzP7tmVuKKR8JJnwltpsjac+2OAHB3MWS4J1qY
	D0ew0jhw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u33AN-00Ei4U-2g;
	Fri, 11 Apr 2025 09:26:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Apr 2025 09:26:47 +0800
Date: Fri, 11 Apr 2025 09:26:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Kuniyuki Iwashima <kuni1840@gmail.com>,
	linux-crypto@vger.kernel.org,
	syzkaller <syzkaller@googlegroups.com>
Subject: [v2 PATCH] crypto: scomp - Fix wild memory accesses in
 scomp_free_streams
Message-ID: <Z_hv117exy6sjUI7@gondor.apana.org.au>
References: <20250410183347.87669-1-kuniyu@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250410183347.87669-1-kuniyu@amazon.com>

On Thu, Apr 10, 2025 at 11:33:45AM -0700, Kuniyuki Iwashima wrote:
> syzkaller reported the splat below [0].
> 
> When alg->alloc_ctx() fails, alg is passed to scomp_free_streams(),
> but alg->stream is still NULL there.
> 
> Also, ps->ctx has ERR_PTR(), which would bypass the NULL check and
> could be passed to alg->free_ctx(ps->ctx).

Thanks for the report.  I think we should instead move the assignment
up and test for IS_ERR_OR_NULL in scomp_free_streams.

---8<---
In order to use scomp_free_streams to free the partially allocted
streams in the allocation error path, move the alg->stream assignment
to the beginning.  Also check for error pointers in scomp_free_streams
before freeing the ctx.

Finally set alg->stream to NULL to not break subsequent attempts
to allocate the streams.

Fixes: 3d72ad46a23a ("crypto: acomp - Move stream management into scomp layer")
Reported-by: syzkaller <syzkaller@googlegroups.com>
Co-developed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Co-developed-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/scompress.c b/crypto/scompress.c
index f67ce38d203d..5762fcc63b51 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -111,13 +111,14 @@ static void scomp_free_streams(struct scomp_alg *alg)
 	struct crypto_acomp_stream __percpu *stream = alg->stream;
 	int i;
 
+	alg->stream = NULL;
 	if (!stream)
 		return;
 
 	for_each_possible_cpu(i) {
 		struct crypto_acomp_stream *ps = per_cpu_ptr(stream, i);
 
-		if (!ps->ctx)
+		if (IS_ERR_OR_NULL(ps->ctx))
 			break;
 
 		alg->free_ctx(ps->ctx);
@@ -135,6 +136,8 @@ static int scomp_alloc_streams(struct scomp_alg *alg)
 	if (!stream)
 		return -ENOMEM;
 
+	alg->stream = stream;
+
 	for_each_possible_cpu(i) {
 		struct crypto_acomp_stream *ps = per_cpu_ptr(stream, i);
 
@@ -146,8 +149,6 @@ static int scomp_alloc_streams(struct scomp_alg *alg)
 
 		spin_lock_init(&ps->lock);
 	}
-
-	alg->stream = stream;
 	return 0;
 }
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
