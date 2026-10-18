Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA893CF1ED
	for <linux-crypto@vger.kernel.org>; Sun, 18 Oct 2026 20:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792356566; cv=none; b=bhtxw8tIFl6wIav6nhTqB06pyHrj/SPISXI6QufeaChjfd02XEcJCN0uQOs01mT6Lr4jUSeOR9vIT1fhJ8pW+4dynmdhuC5OiDzB5QrrmOrQoBDAMKhvgevJC61a7iefHAe4o/jKOip0mWyg4fQXDStT9lXlec5E0oFsc6n/Inw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792356566; c=relaxed/simple;
	bh=Vw6s98kEDMurg0pU7SS8jYQXIJl+bFsyavCbyP5sbX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q95aPKTcGqfomtAMjSc6ghtWoCQsiSmCWJXhJsMpoW/etgOhVP40kRshau2spnn66NOSZIYfM7TbVs1R84OpcbOPQ2lnzQZkaTN2EvG7LMkx3XX6Ei2rLcQs5y5F492T9/LbSQ167JMDj/6JGK3ybvg20y5iBHhiWZR6jcfdb8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GjjzogwD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GjjzogwD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534821F000C5;
	Sun, 18 Oct 2026 20:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792356565;
	bh=ebylqn/Vv1o5HKoXYXci7duW7qWnpj9Dmhs3uTuInJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GjjzogwDOazKIakPRrz4zb4KiSxa6cymK4yBiAyqGHueC2yJT3/8zDhf0+wW3EhOc
	 RfZSueRqCammQa2zYT1IpmccxYHOsHj9Dp7c9CvNGfEvul3P2vpDRSdZHuIcylhK+O
	 UGSHEMyrpWgYs+T/7Fd4csszDgOgrPDHeWLSnWr6BGteqwOxf3q5KQ3VCZreIpqIg0
	 eZvxKexS7ApRlEWfes7hF3KMQj4M9WjR0OBDVofyUnLtqii0vVNn5Rf66zETF7oz97
	 1gOWeTGk6jeFv+NlerS7fy3TVkJLE+Fb8jy/dyGKRpDo1/4O7YXHW8FyjEdeylBI7e
	 sOE/nywG+24hA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 02/14] crypto: rng - Remove unnecessary inclusions of internal/rng.h
Date: Sun, 18 Oct 2026 13:46:06 -0700
Message-ID: <20261018204618.104876-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261018204618.104876-1-ebiggers@kernel.org>
References: <20261018204618.104876-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for the later removal of <crypto/internal/rng.h>,
eliminate unnecessary inclusions of it.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/geniv.c                         | 2 +-
 drivers/crypto/gemini/sl3516-ce-core.c | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/crypto/geniv.c b/crypto/geniv.c
index 04befe3a7f44c..a5c3efda1ae8e 100644
--- a/crypto/geniv.c
+++ b/crypto/geniv.c
@@ -8,7 +8,7 @@
  */
 
 #include <crypto/internal/geniv.h>
-#include <crypto/internal/rng.h>
+#include <crypto/rng.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
diff --git a/drivers/crypto/gemini/sl3516-ce-core.c b/drivers/crypto/gemini/sl3516-ce-core.c
index c1df5f96ea421..2079fc0f0b651 100644
--- a/drivers/crypto/gemini/sl3516-ce-core.c
+++ b/drivers/crypto/gemini/sl3516-ce-core.c
@@ -8,7 +8,6 @@
  */
 
 #include <crypto/engine.h>
-#include <crypto/internal/rng.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/clk.h>
 #include <linux/debugfs.h>
-- 
2.56.0

