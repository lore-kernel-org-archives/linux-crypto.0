Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A9E3793DC;
	Thu, 30 Apr 2026 06:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777530585; cv=none; b=ds7KPyi0GndLIOmFJTUjGQ0puO+lldk1V31AB+xPpqVedCwZag94o7aoednXkFmIyF4tB+WVZigrcaiLkmgnfw1UsMiDQ8kLQT4HEo19mVWBw1+bFz04uk36hAuTvY2Y7TIc/kmTFpnQRacPjhdv0M9ceRNQUpuZxN2uY8OfIoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777530585; c=relaxed/simple;
	bh=b/7xSIs0FJWzd01THmxgjpBe+eE2ZNDzDWDqC81jkwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iRAwByYqxJ0HMYz2ByGzzdP6DlAb3ng9byUUWUl/UF4E8bD9ZigSZWFh7whTOXi8DKUGc9EuWN61fc68M5zZR/78oXPJjMvOUHEejLFd/ujXiIV42CZuWveynSqlne9QlsDgJWtdlzHNpzm60f2lpUhBD/zgrW4r28CEgjB5HMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ClEfV7oi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ClEfV7oi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABDB9C2BCB9;
	Thu, 30 Apr 2026 06:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777530584;
	bh=b/7xSIs0FJWzd01THmxgjpBe+eE2ZNDzDWDqC81jkwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ClEfV7oipY7zBjUsuSZ5HSjaEIsnNcKli6aUe2S0ewdFMF9i4QZsBmw5Sgoe+e1PE
	 9g2G0P8g1vDwdkYInjShp2wEB/Y3aR2wrKspWjjmQAE7PDO9e2rVOGr1x6+gwersUs
	 7lNsnkZfjDPa3RFo51zIHtd00ZywcqfUR2xYGnLZeqMbaPqWITukbgPA17l8cMzvt1
	 Eg5+DWuxKCZdU4G87w0TZVewijYchNlGYCSgcefsf/c+P7pxjnVjR2q/95YB85AHG6
	 mBHkkrBU/CELSKtrHOqJmty0a9Msnch4WesWMaxoq5p05WD/kGOb9NhtLBoGpwetRs
	 7lm4GVThcwMKg==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	syzbot+d23888375c2737c17ba5@syzkaller.appspotmail.com,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.1 8/9] crypto: af_alg - Fix page reassignment overflow in af_alg_pull_tsgl
Date: Wed, 29 Apr 2026 23:27:30 -0700
Message-ID: <20260430062731.140497-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260430062731.140497-1-ebiggers@kernel.org>
References: <20260430062731.140497-1-ebiggers@kernel.org>
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
index edf13ab8bf37..54494af50ba1 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -592,12 +592,12 @@ void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst)
 
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

