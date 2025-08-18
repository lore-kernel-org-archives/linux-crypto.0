Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77CE225A29;
	Mon, 18 Aug 2025 20:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755548927; cv=none; b=adKpB+UHR3kMCacnyWP/RGPUsXj5b8UFykAlQQdE6GYs94mCvz/kE0kGMQNjeIJr9eeVrVpoerrMHuUBPCVI1MEouIidusDPjDTqrWXpF+iQ6slY03yWLGBFiorXZkI5zyOWApy/ozcuqb5S7gpZyNZBcZAW/HDdU2IL13kSBbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755548927; c=relaxed/simple;
	bh=KiWZ/EiIDY+ilEC4IXfdyN/LdSTVyd3z4Jo9QiKYDtA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Fuum3r7iGZviRZtkrCJ+JFIlvBVLYPVjj7d3Zrfl5TK9t1s6Kl4fTwF3/KtqLJDijalPfXGKApfVTDmKbbNvOJXMaBFcb7JQrFpWGFua0QDF5p0HboBFe19c2X3fU2Jc8XrYJtQV0Gl3qin2kjD86TNIfHdLUc1iU2EPjw+Thn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ha6rnbEc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ha6rnbEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21579C4CEF1;
	Mon, 18 Aug 2025 20:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755548927;
	bh=KiWZ/EiIDY+ilEC4IXfdyN/LdSTVyd3z4Jo9QiKYDtA=;
	h=From:To:Cc:Subject:Date:From;
	b=Ha6rnbEcOVvvtzAFK09Tdm0Qn6g6Yz45E3AsPi1F+28h3vY6yT1+pxzyqUjD7n8iG
	 O2QEcjqOxXJHbTl2gtLRT+/6Y0OXygyXNzm45ixBoUkj4wU1rH2lf0EKQrUXc3+nb8
	 uyqpQlD2cWQLUk2mGP1yZjciTuk9NOFN8RS1YB32+yyV6YFuAkTOY0qjerVsBZSoMN
	 82HdRq8NPlFw1sQtVUH1R6QFipQmIHnPs3yu26dhSW/SzYTOucHTcPpnFfrlZ/XAY8
	 5SDYeq1Fea6+9JO/gTJH5pF+IWXdZQM7I0P7YdLT0ceUq9rVqaw5ZMmy+y3s7I9oOt
	 KUWMgvtasce5A==
From: Eric Biggers <ebiggers@kernel.org>
To: netdev@vger.kernel.org,
	Andrea Mayer <andrea.mayer@uniroma2.it>
Cc: linux-crypto@vger.kernel.org,
	David Lebrun <dlebrun@google.com>,
	Minhong He <heminhong@kylinos.cn>,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH net v2] ipv6: sr: Fix MAC comparison to be constant-time
Date: Mon, 18 Aug 2025 13:27:24 -0700
Message-ID: <20250818202724.15713-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To prevent timing attacks, MACs need to be compared in constant time.
Use the appropriate helper function for this.

Fixes: bf355b8d2c30 ("ipv6: sr: add core files for SR HMAC support")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

v2: sent as standalone patch targeting net instead of net-next.

 net/ipv6/seg6_hmac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/seg6_hmac.c b/net/ipv6/seg6_hmac.c
index f78ecb6ad8383..5dae892bbc73b 100644
--- a/net/ipv6/seg6_hmac.c
+++ b/net/ipv6/seg6_hmac.c
@@ -33,10 +33,11 @@
 #include <net/ip6_route.h>
 #include <net/addrconf.h>
 #include <net/xfrm.h>
 
 #include <crypto/hash.h>
+#include <crypto/utils.h>
 #include <net/seg6.h>
 #include <net/genetlink.h>
 #include <net/seg6_hmac.h>
 #include <linux/random.h>
 
@@ -278,11 +279,11 @@ bool seg6_hmac_validate_skb(struct sk_buff *skb)
 		return false;
 
 	if (seg6_hmac_compute(hinfo, srh, &ipv6_hdr(skb)->saddr, hmac_output))
 		return false;
 
-	if (memcmp(hmac_output, tlv->hmac, SEG6_HMAC_FIELD_LEN) != 0)
+	if (crypto_memneq(hmac_output, tlv->hmac, SEG6_HMAC_FIELD_LEN))
 		return false;
 
 	return true;
 }
 EXPORT_SYMBOL(seg6_hmac_validate_skb);

base-commit: 715c7a36d59f54162a26fac1d1ed8dc087a24cf1
-- 
2.50.1

