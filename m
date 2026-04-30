Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9EFC377560;
	Thu, 30 Apr 2026 06:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777531076; cv=none; b=qA3nWChP/n48CNeHPwVzU0RcVqqqnlL/L3fCPn5/nDrf/ZtGUmJVS8TFseMSzx6XSsvGhCybY1MGybJH7lE/ObnTDWmcJ1kXlu6jJ9F0q7ZOm/rAwle7H0ihFqzZTTHnA2+jPECOnbUIp61fDBLxFkR8kz3//mIFu6ixobsc6X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777531076; c=relaxed/simple;
	bh=cUMrQAIr1rwOn7Nd+3RxgyIqxbRhhrPFoeZpH6q5AoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KRq49LANFPFoKV+xoQu4NCUZ9EIrcA0Na6pXedGAPNnOCb8awujTzOWTYjQ/CH/DlQLM1IpeKgsX870VY6+tKbfej/0saJigUq/VGE6LT/F+QOMIU41ZNth9hXvHaFaEM/A75OuibSukrbuC3VufpLCREUBeD9o7E7mn1SSUuYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C1pPITPe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C1pPITPe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E25C2BCC6;
	Thu, 30 Apr 2026 06:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777531076;
	bh=cUMrQAIr1rwOn7Nd+3RxgyIqxbRhhrPFoeZpH6q5AoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C1pPITPec0al7Y+N1xpBGh2BL0BmxodDXlYZ4KF3GCNIZzfswgmtZ89e2y9lBHkwZ
	 6duwLhUzkL/17QoJFVit/nKMHsRVkvA08tAmD4VcFhlppwWTU5M7tHdeZHkxYIpZSG
	 y02lX50pKpqRvbdD7o6U0Ecb6Go8qQMbU2+z8TGi3p/NFYgLzv6tckyDxiQ0sR/PCM
	 sjpL99en+kEXTQNzjMU7U3t7ItGjagVavhc1rMHAP0KUHC2R/+y+EiieBCBXE319uH
	 d3n9xDDtW+A9QEoo9u2+p5Uj295xe2L9a8CezPIBWFyF8HlO6tdRI8jgUsl82F1Ugy
	 L0rUSO3icVGGw==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	syzbot+aa11561819dc42ebbc7c@syzkaller.appspotmail.com,
	Daniel Pouzzner <douzzer@mega.nu>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5.15 9/9] crypto: algif_aead - Fix minimum RX size check for decryption
Date: Wed, 29 Apr 2026 23:36:04 -0700
Message-ID: <20260430063604.173525-10-ebiggers@kernel.org>
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

commit 3d14bd48e3a77091cbce637a12c2ae31b4a1687c upstream.

The check for the minimum receive buffer size did not take the
tag size into account during decryption.  Fix this by adding the
required extra length.

Reported-by: syzbot+aa11561819dc42ebbc7c@syzkaller.appspotmail.com
Reported-by: Daniel Pouzzner <douzzer@mega.nu>
Fixes: d887c52d6ae4 ("crypto: algif_aead - overhaul memory management")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/algif_aead.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 24e77f4968a6..4a285994d106 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -148,11 +148,11 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	 * of the input data.
 	 */
 	if (usedpages < outlen) {
 		size_t less = outlen - usedpages;
 
-		if (used < less) {
+		if (used < less + (ctx->enc ? 0 : as)) {
 			err = -EINVAL;
 			goto free;
 		}
 		used -= less;
 		outlen -= less;
-- 
2.54.0

