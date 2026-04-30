Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C3D37998B;
	Thu, 30 Apr 2026 06:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777530585; cv=none; b=NgiT3cR16JotWFEiHX2uy+74XTTrIMryJhYrfOFBUNJvW2f6Ye7veVmFhfMz3G48zLSgtVcOO9nHkl7eQ00Kx+eMVndZw0tO5Xoj2bR8q2hlYapwoaI5dnlMgHZG6481wWNTZik7cU0GQJyTYgfoxMyU6xzoiBtK3XcIy7eos1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777530585; c=relaxed/simple;
	bh=cUMrQAIr1rwOn7Nd+3RxgyIqxbRhhrPFoeZpH6q5AoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h5j26Ya7ElmUWL3aJN1yiP5vlZjINiKS4OcvWblVcgQ0fogS3qOe9xsR/ptk0+F82hUbVlNFcsvNmdmAosJ3f+3rwTOjc+7ZA5f0u5MVY4TRx8B0aLfe1qqweSbDZpZUhYVJ3d9+sG4YsZjITZKH+533fHWuqHCxeRT3WIY4Yvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p3Q2Bsff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p3Q2Bsff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005D1C2BCC4;
	Thu, 30 Apr 2026 06:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777530585;
	bh=cUMrQAIr1rwOn7Nd+3RxgyIqxbRhhrPFoeZpH6q5AoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p3Q2Bsffdfesjl2G0000UBf4B/NIkWUi0raHNEKma9QAAe4lHKPbrCoCrwv+54okK
	 vYz8+aIAePAK8AQIyJ/9rk2woqGAixeHI7C3dr3mTaM/GPm/LO/IvQRs9+PSBOhPbw
	 uzHobU0qvn1nxZ3AI4i2g6I1m/tHKfiqR8CISKh3xIVxdHNi58YP78Ob2s5+N5/e8G
	 ZFEcY/ZLS2jphh3eXsVAhcw6Lbn7AT1EuTiEYD0uSDi7ukMfcGD4FJ5YoyV9E0bvVe
	 7jA1DMB8NUv1NhZ/FpRXzGKqbURYlb1fZDyT8CUKyjngE7eSDqNuxDxzJx0Jo67LVB
	 FwvfTLkZA+XWA==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	syzbot+aa11561819dc42ebbc7c@syzkaller.appspotmail.com,
	Daniel Pouzzner <douzzer@mega.nu>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.1 9/9] crypto: algif_aead - Fix minimum RX size check for decryption
Date: Wed, 29 Apr 2026 23:27:31 -0700
Message-ID: <20260430062731.140497-10-ebiggers@kernel.org>
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

