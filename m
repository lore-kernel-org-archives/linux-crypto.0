Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.180.15
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795822618;
	b=OxeHAzEMxgvCJ9POOMBCx7Kul4aXi6/qU+bKROk2glGZ4Rrz8wNF0rUcu/kLre48AO4m
	 cKxIQcd8CDdeE/hSqsCvXAPKzmt940CoaR/ioFs1EgMr/jpmg2FVGxDLmUpQonqvnlIGX
	 I9SmX9mtLTTvSIiF4y954GFzuwn+mKS0+4ZvJy0BbywbYPtqrX3M9qH/XZBWsK1Z5OQrY
	 7wO5kPluYcqFB6jAEiNhEF9HmUlOQwzO/j3caHLGFX3nrTg5uVq2DPwgZF4BqVjmoSVi5
	 zgvh5DIu+wFCNyF6TQCjxwGzh2l0Undx8OnCZu4bpGcLQ8EWKL/OjkHItf9BQDHuJtw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795822618;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-ZohoMailClient;
	bh=GX5eb5SulHzovz0ZFjvg8eNIHM+Hg+/kelqXnXq231Q=;
	b=YU8A6fGkb3O0Ly1aJ88ZOUwuD1laxUPhjDbt+LyBlWhAAtXeZU78nxHUXGtd+BrTbPs1
	 XdRR7YTckupXhhrTZcCC13QhbT0sPnmLURi98qPlvWNGzrN+HQ4whybBB1qhh47NugIZf
	 WPiLAAGMYda/agNswZGB/k2HPsF6Mo6J/M5j32pToWdJL/Bi+Z5t3k5VNuO3Uf4mZSMtu
	 YT/6q5mC7aD3ISJitMbia/zf6U6hj5PkSYVJr9FazCaeJA0JEIpexY75H0fGE9E9JvHCx
	 nE4fZKwCbAWERACQlNbSElYpbIV8Z3p6xz+Ob6GymC/ozmtLKS385CBjERXIPWQZaWQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=laveeshbansal.com;
	spf=pass smtp.mailfrom=laveeshbansal.com;
	dkim=pass header.d=laveeshbansal.com header.i=@laveeshbansal.com header.a=rsa-sha256 header.s=zoho header.b="Fpwyi/2P";
	arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.180.15
Received: from sender6-op-o15.zoho.com (sender6-op-o15.zoho.com [165.173.180.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D779606A31C
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 23:36:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7D779606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=laveeshbansal.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=laveeshbansal.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=laveeshbansal.com header.i=@laveeshbansal.com header.a=rsa-sha256 header.s=zoho header.b=Fpwyi/2P
ARC-Seal: i=1; a=rsa-sha256; t=1795822606; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=JhStCMtAfmNQKTuYH/bkRIrbgRlnRcbAWEk8p2fD9SNTVBlnOG2dKucZjjZiDmLyZJ3yhXncuvoMHYreRLxrpHcIOqJkh85+gLkZ7rqoPYgEm85c+GqJQ2ztPDkLRq8moPXD9YzOLpZRAQTJ6eDmyW6K3OliybnZxDy2FpyC1GM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1795822606; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=GX5eb5SulHzovz0ZFjvg8eNIHM+Hg+/kelqXnXq231Q=; 
	b=TE17WL8TcinAwM9U/D3YFBW2fLaQnvo7+5tKiSEIi+IcSkQovp3rSL4gBvosUGghHpVVWGl3/pPBWfda/GHy7hMIvLsbNZIo6k86YtTg6bDl9tdoLdhLPazFcqtA6CW7j6maA6Pl+PQhfTRt2ZLfQkrNHOorLGOo7BCsKItXU30=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=laveeshbansal.com;
	spf=pass  smtp.mailfrom=laveeshb@laveeshbansal.com;
	dmarc=pass header.from=<laveeshb@laveeshbansal.com>
DKIM-Signature: a=rsa-sha256; b=Fpwyi/2PhutEgT7I11M2OKAwKZDE79BBRFqk96EcHJ8/J1zZVSMFz258k7p43H9Zx64dEldg0IQYHkLsjptyEfxPcmoL0w3LLn9QF2z+9dcl8RaqraIro3eUnzKkTqccpBcX/t0OvJV4DhIrvNQuAWEX8qXmsGsFna9geu1ofLc=; c=relaxed/relaxed; s=zoho; d=laveeshbansal.com; v=1; bh=GX5eb5SulHzovz0ZFjvg8eNIHM+Hg+/kelqXnXq231Q=; h=Content-Description:Content-ID:Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:List-Subscribe:List-Post:List-Owner:List-Id:List-Archive:List-Help:List-Unsubscribe:MIME-Version:Message-ID:Resent-Sender:Resent-Cc:Resent-Date:Resent-To:Reply-To:Resent-Message-ID:Resent-From:Sender:Subject:To:Date:From:Message-Id:Reply-To:Subject:To:Cc;
Received: by smtp.zohomail.com with SMTPS id 1795822603318460.01457229929383;
	Fri, 27 Nov 2026 15:36:43 -0800 (PST)
From: Laveesh Bansal <laveeshb@laveeshbansal.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Subject: [RFC] crypto: adiantum - Switch to the ChaCha library
Date: Fri, 27 Nov 2026 15:36:36 -0800
Message-ID: <20261127233636.7172-1-laveeshb@laveeshbansal.com>
X-Mailer: git-send-email 2.54.0
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Hi Eric

In the thread for your setkey patch
(https://lore.kernel.org/all/20261127184407.GB1974@quark/) you wrote:

> Later we should shrink the required stack space by switching
> from crypto_skcipher to the ChaCha library.

If you have not started on this, I would like to do it as a follow-up
once your setkey and AES library patches are applied. I have a
prototype and would like to check the approach with you first.

It is two patches on top of yours. The first makes adiantum_setkey()
derive the subkeys with chacha_init(), hchacha_block() and
chacha_crypt(), so the skcipher request on the stack goes away. The
second makes adiantum_crypt() call the library directly. It walks src
and dst with two scatter_walks, rounds each step down to a multiple of
64 bytes unless it is the last, and uses a 64-byte bounce buffer for
shorter pieces. It removes the child tfm and the spawn. The
algorithm names stay the same.

I tested on arm64 with gcc 13.3.0 and KASAN, lockdep and
CRYPTO_SELFTESTS enabled (and _FULL with both patches applied). Random
cases through AF_ALG give the same ciphertext as the code with and
without your patches. A test module with odd scatterlist splits, in
and out of place, also passes. I saw no KASAN or lockdep reports
and no selftest failures. The adiantum_setkey() stack frame is much
smaller than with your patch. The adiantum_crypt() frame is larger than
before, and the data path as a whole stays about the same depth. I have
not tried x86_64 or s390x yet.

There is no second adiantum driver for testmgr to compare against, so
its vectors are the only in-tree check. None of them has full ChaCha
blocks followed by a partial one. Before the cleanup I can add a few
that do.

Do the overall design and direction look fine to you? If so, I can
start with the vectors and then send the cleanup patch series.

Thanks
Laveesh
