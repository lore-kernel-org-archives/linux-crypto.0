Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C66A3290BA
	for <linux-crypto@vger.kernel.org>; Mon,  4 May 2026 08:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777883365; cv=none; b=HvQchBwuvQq8Oew2D9N/pwet3cWPDR5X07LxaGldFJMVwxDgRk5bIfEiRBXVIzTkngboVR4XEhYGsTYNFUh5UzH6YezpZ7IzupMkdEcCk2iHWVVT/Y+QTV1q/4DyXQHoGKgYKWZhyIJiUxhM5Qy0pA+dy7P7kfASXYuqA7ER/rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777883365; c=relaxed/simple;
	bh=+JorqP2Lq/9aXPbupTcYSWyOwB1aJPCl1fjDcv45u/o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q3w4EiV1b87PYTfvufzo52ovAD3kq+RlnzMVx5XPW4dgpTTDlHm3jDPDPEowwhFqb62fsR+vqvF9KuP6DBnnzOosOeFZJjIubS5imgU4nTaVdMfM0E9HewhQxuUDUVxML3K1tHNw8TGuhkz4bjxPX2xKUygreHHq458utpaxSEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lhWjPGh9; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lhWjPGh9"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777883362;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+3b5RnSW+SjCZL46j/qT6swLjiJZ7dosDu8SrdksmoI=;
	b=lhWjPGh98mlxlLpnWOin1LWIfRbmORUvPncj+bb+A7/y33WUQM/gxNyRf6rIIbDcReixN/
	bLPgqi4mfot+SVbLbOm1ugmNKJ8Bhe7ssZWGK79I+DJUQMAKfYkq6P403zeVGpRahxvMdC
	xPK4+7SqeC0zmrIWpldslQXsg3u6VX4=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] crypto: jitterentropy - drop redundant delta check in jent_entropy_init
Date: Mon,  4 May 2026 10:28:50 +0200
Message-ID: <20260504082848.7194-4-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=794; i=thorsten.blum@linux.dev; h=from:subject; bh=+JorqP2Lq/9aXPbupTcYSWyOwB1aJPCl1fjDcv45u/o=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJk/Ig6wcvM8OPRz4aG2L958qbar+QXEuxK3Nn7fpTRTR rvlksLhjlIWBjEuBlkxRZYHs37M8C2tqdxkErETZg4rE8gQBi5OAZiIoh8jw6kHr5druXkF9h5c sSH6w3zpB0VMK1/ea+Z0cMmasC7KxJ7hvwtP+OqilUxvPXwVj8S4bPyya+17wyLh6vYNNnGFa1y ncAAA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Since start_time = end_time - delta, start_time can only equal end_time
when delta is 0, making the explicit end_time == start_time check
redundant. Remove it.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/jitterentropy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
index d5832caa8ab3..6ac0257e8e0a 100644
--- a/crypto/jitterentropy.c
+++ b/crypto/jitterentropy.c
@@ -775,7 +775,7 @@ int jent_entropy_init(unsigned int osr, unsigned int flags,
 		 * delta even when called shortly after each other -- this
 		 * implies that we also have a high resolution timer
 		 */
-		if (!delta || (end_time == start_time)) {
+		if (!delta) {
 			ret = JENT_ECOARSETIME;
 			goto out;
 		}
