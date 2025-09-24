Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C470B255F24;
	Wed, 24 Sep 2025 20:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758745155; cv=none; b=hZYompBr/X0qegvAm6DplfrOa3k+fTsPUTqXtWW4OJr+ElTLXofcTowi5Hx2DdOevBTmo4BrK7NWaMQRgMtZjgYlbv83x5hlXDcUFi/khgJr8zto0RyKgp4fNYpQjXosDdydo1bkbeOP+HHerZUKgTDZ4MIzGaQd8fTAphkdB4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758745155; c=relaxed/simple;
	bh=jZiHAeS9wfJ8LDvIn+UDSFRTPDaQwzheaa0cN8KeOAg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t/lG1/zkr2daY0Zpr71U1h8YxMP1dqTaOnjJIAwVkZIP/jG9P4z6yXRtIPVg2BTQT/8gtrgRdfUC4S35d20owiQiBk6uxMyAhPRi/xrtTljQskSvjnt4ZuT3+2NtmR/QzCxiUAHZJoj9SgkikpIoPInYp3sEakdXnEu0KligoE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k6VldB6q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k6VldB6q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99E2C4CEE7;
	Wed, 24 Sep 2025 20:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758745153;
	bh=jZiHAeS9wfJ8LDvIn+UDSFRTPDaQwzheaa0cN8KeOAg=;
	h=From:To:Cc:Subject:Date:From;
	b=k6VldB6qG8PkecMuamZhlxpe84Ll79/+Cbs3ubtzWVCS8U+8FQHDUZRFNveAGjbQ0
	 m4YsLwBOE7lsVqyqxx6wXo9BApIUuxjaV4V2yskuJBPEfOTvDDo1bacHdwKNXl/q6/
	 3SCTaGl1YLH3CSTw1Uu4fPw4NlN3RxJfsdf3b2l8SYBGgKkfK4Bs8au3G17LNuceHQ
	 tQZFDm/KdBxLjkQX/auMsVKfIs32fOa8bA9ILUDvfy8Le8QDdF669tDC/0He/Dvad+
	 pyHj/MiCoIGMKjx96wDUmSgv0e0bkeqGrm3h6Blrhvt+O/u111ew+lGxlAahMViEUU
	 OVWygTUo8KhWw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v2] crypto: af_alg - Fix incorrect boolean values in af_alg_ctx
Date: Wed, 24 Sep 2025 13:18:22 -0700
Message-ID: <20250924201822.9138-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 1b34cbbf4f01 ("crypto: af_alg - Disallow concurrent writes in
af_alg_sendmsg") changed some fields from bool to 1-bit bitfields of
type u32.  However, some assignments to these fields, specifically
'more' and 'merge', assign values greater than 1.  These relied on C's
implicit conversion to bool, such that zero becomes false and nonzero
becomes true.  With a 1-bit bitfields of type u32 instead, mod 2 of the
value is taken instead, resulting in 0 being assigned in some cases when
1 was intended.  Fix this by restoring the bool type.

Fixes: 1b34cbbf4f01 ("crypto: af_alg - Disallow concurrent writes in af_alg_sendmsg")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

v2: keep the bitfields and just change the type, as suggested by Linus

 include/crypto/if_alg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 0c70f3a555750..107b797c33ecf 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -150,11 +150,11 @@ struct af_alg_ctx {
 	struct crypto_wait wait;
 
 	size_t used;
 	atomic_t rcvused;
 
-	u32		more:1,
+	bool		more:1,
 			merge:1,
 			enc:1,
 			write:1,
 			init:1;
 

base-commit: cec1e6e5d1ab33403b809f79cd20d6aff124ccfe
-- 
2.51.0

