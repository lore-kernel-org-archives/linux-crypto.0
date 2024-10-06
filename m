Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA48E4C74
	for <linux-crypto@vger.kernel.org>; Sun,  6 Oct 2024 01:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728177527; cv=none; b=OAfH9v9zekMVdbCTlafpC575kzEdGp3Ns8vJl/i8w5wEu+kjiDGTDkpnTF+8qWJQiUYFqid1Yj4boN2TmHUlVjPls8ddwGler+BLohvHHDRfh9tb+FUOgGBGE3uVkjj+XdjujAiTfG4e5cKpW7sOCrX1biUX1erX91S4T8gq2Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728177527; c=relaxed/simple;
	bh=sEPXMKBF7qo6W53rVM2DT0g8kuQdMWKY5xPYTYg+1yo=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=bQv4hT2BR7Q1USG+n6BT2nUjDNYJCyk6zMTtBxuWWQ4uJXHuW6Bxt3ZHl4S/FrNf2Qki6s84iHh9pWAH68qumtFT4X5eD5/H89xiaB4DFVsUJ/JDXWKGgBhMe7O3kuxHtD+PiNrgc5BQ6I9LIYy5RNSicFrDRwqtrwrQPtHol/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=gKbyfm+8; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="gKbyfm+8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=SUWRR+yxjF4Ws1gbO/GUR2MuVb7RKpdYx3IrsASqeNk=; b=gKbyfm+8o9YsxD7+DFDLL7WQhV
	aYIaCO/erlSSKLZk0vXXkszFu3O9lhb9vRTNOfd1fs2LHYwtKWGXTvD+9dWTvl85xp0dpGk2nP+RD
	LkDzZI1d4/FTXBZjup8OsmeRz+yQ5ovYhKhxk0xo2z7BRIbHxTfKKe56oCy2GE+HsEzlVGxRJ1NOX
	6GCHwiChWBPPRW5H0znBQoymHzz0AVjWqfE3R4ebGtu49hCb5kgY+dBdsc/Qx25jP9SLJm9UhqtSK
	BDGctDF/fJ+lViTOINezdvEifI+hzVltsfWI5CGgeJs8EB46ke75uminC/Ox2dNQ9b6f1ry5JDUP3
	CzcLH7dQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sxFl1-007AhN-1V;
	Sun, 06 Oct 2024 09:18:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 06 Oct 2024 09:18:37 +0800
Date: Sun, 6 Oct 2024 09:18:37 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: api - Fix liveliness check in crypto_alg_tested
Message-ID: <ZwHlbSyqBP-o0u7L@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

As algorithm testing is carried out without holding the main crypto
lock, it is always possible for the algorithm to go away during the
test.

So before crypto_alg_tested updates the status of the tested alg,
it checks whether it's still on the list of all algorithms.  This
is inaccurate because it may be off the main list but still on the
list of algorithms to be removed.

Updating the algorithm status is safe per se as the larval still
holds a reference to it.  However, killing spawns of other algorithms
that are of lower priority is clearly a deficiency as it adds
unnecessary churn.

Fix the test by checking whether the algorithm is dead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 74e2261c184c..004d27e41315 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -373,7 +373,7 @@ void crypto_alg_tested(const char *name, int err)
 	q->cra_flags |= CRYPTO_ALG_DEAD;
 	alg = test->adult;
 
-	if (list_empty(&alg->cra_list))
+	if (crypto_is_dead(alg))
 		goto complete;
 
 	if (err == -ECANCELED)
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
