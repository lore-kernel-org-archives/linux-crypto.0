Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA1F156641
	for <linux-crypto@vger.kernel.org>; Sat,  7 Dec 2024 19:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733601513; cv=none; b=DOmNoAmRALbIOzyWCALcQbn53kNib/p/uIUN2fFGwnTJop3ohoZXr0SM8vir3xmC63VYmY3iyZPsKr0V4BcLEv4iEDKy/RCNfDBCIC0bBhAhXzKD2m+LRq5RFMGvKl2dk3Clhr7bqANmQFm6KlBj15T6oiEju1W1Bf4xk7+dmUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733601513; c=relaxed/simple;
	bh=JD5IkYe6ngI5RFQ64i8zOqzDWCYgNzd34M9qimtusNM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HUQDHnYr9X2agR9/QHrDC9b4CRMQwxt+1nq/J//+nsHPhshF80p1jLocVX/4FfjVEiS5hqe2kMwnzZvzqVtZlamxjtWwz7NysX+NjrNHQgdtDKtzu9zQfwHp/HQ4SbEqHajX1ypyzUuUE0qzd26D9CPWpjZUdXfNSDYZyO1/juc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OZnWh3D6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OZnWh3D6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B34C5C4CEE1
	for <linux-crypto@vger.kernel.org>; Sat,  7 Dec 2024 19:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733601513;
	bh=JD5IkYe6ngI5RFQ64i8zOqzDWCYgNzd34M9qimtusNM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=OZnWh3D61r4EjCflnzH4rP5vDeVfEkt6bOGr0ZH09/j/AN9njXDRYBE70v2XpJY+h
	 lk3BvUO8XSZr7ZM1mSLc5Rt2bIJqiQIbGwNaD4qXpE2JfN+U+aWvihw5eyVrVlnPa+
	 CyHKwaunmObEHgMuBD6ZCsgDWs/pcgm6b38DAqDv4JhUjIZrzBl1Di6jkR6e+aZWUm
	 WtQlMDSgFkYZP8JlQTWKG2vDqi3yTH4clB2avtFkmhoeS3LguBR39fwBi1BnD7lCyS
	 +vpEGDrGZGPtv7Qxe9y2s4u9KLG223znw81TiMS7ovrhpZzdRCttKMI+S3+WLyzptX
	 TCO6MNUEtjKXQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH 7/8] crypto: aegis - remove assignments of 0 to cra_alignmask
Date: Sat,  7 Dec 2024 11:57:51 -0800
Message-ID: <20241207195752.87654-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241207195752.87654-1-ebiggers@kernel.org>
References: <20241207195752.87654-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Struct fields are zero by default, so these lines of code have no
effect.  Remove them to reduce the number of matches that are found when
grepping for cra_alignmask.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/aegis128-core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/crypto/aegis128-core.c b/crypto/aegis128-core.c
index 4fdb53435827e..6cbff298722b4 100644
--- a/crypto/aegis128-core.c
+++ b/crypto/aegis128-core.c
@@ -514,11 +514,10 @@ static struct aead_alg crypto_aegis128_alg_generic = {
 	.maxauthsize		= AEGIS128_MAX_AUTH_SIZE,
 	.chunksize		= AEGIS_BLOCK_SIZE,
 
 	.base.cra_blocksize	= 1,
 	.base.cra_ctxsize	= sizeof(struct aegis_ctx),
-	.base.cra_alignmask	= 0,
 	.base.cra_priority	= 100,
 	.base.cra_name		= "aegis128",
 	.base.cra_driver_name	= "aegis128-generic",
 	.base.cra_module	= THIS_MODULE,
 };
@@ -533,11 +532,10 @@ static struct aead_alg crypto_aegis128_alg_simd = {
 	.maxauthsize		= AEGIS128_MAX_AUTH_SIZE,
 	.chunksize		= AEGIS_BLOCK_SIZE,
 
 	.base.cra_blocksize	= 1,
 	.base.cra_ctxsize	= sizeof(struct aegis_ctx),
-	.base.cra_alignmask	= 0,
 	.base.cra_priority	= 200,
 	.base.cra_name		= "aegis128",
 	.base.cra_driver_name	= "aegis128-simd",
 	.base.cra_module	= THIS_MODULE,
 };
-- 
2.47.1

