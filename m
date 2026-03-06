Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2560246782
	for <linux-crypto@vger.kernel.org>; Fri,  6 Mar 2026 04:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772770875; cv=none; b=eQAU8+l5ELdR7XRFtUTdzsrnn8iPXoIUIh6TgcbMhaZgdmWBIBXLMR9HNqVn+DnFCK8+ApvkppbJuLKJBpTjCUAksb6K7oWI9Q3im1/9Pa7ubSVqVTWA4gqm+uYz4IEPbLys9YLXPi00SbaDukYiYGMEFlGCiByA3/hCP27iFMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772770875; c=relaxed/simple;
	bh=9TYwZmiRf8dZ5EAaLBDgpJSmCARfHq8YxVEnnsjN4Vs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p1soxcuXD5w6PC0QjjiAGVGhHrdYvd4WKN13p7dB5qTdvzz4juEsKU13MXQdAKDfTpT2SLR1LDyhIHWRWy8v0Qia1t7GI1Fkg1O44aqpFtRtWLhLMfhn+7P3Zrr/0zHQN0XGE06S2jNOwUMBTs+xb3CBsVGKCJJ1rqhCH9254TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PeTTD7DN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PeTTD7DN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E31C4CEF7;
	Fri,  6 Mar 2026 04:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772770875;
	bh=9TYwZmiRf8dZ5EAaLBDgpJSmCARfHq8YxVEnnsjN4Vs=;
	h=From:To:Cc:Subject:Date:From;
	b=PeTTD7DNbwfhYeMvuguTDtf8+zb1Ur6IN47mDCWMUS6OsgB6rRDz/Ejs/ok0gwNns
	 GUKGpy9It/z0yK6zTVldXkGo8gPaJDDIiE55hUk8G31yWn/GZgZRCRD6oQ4LMfuEsi
	 olROakPBokMw4fOgZsHUHUyhNDubCbZ2YICIol7OeQR9+eey+DDjnxgSgiRr2ZumM1
	 XVhZIpr2vYnbpWd5sb1WsboaMuwUUq5HkxeGnPYYbgw6uieobfluQalQ29eVUIZLbw
	 ZXZHFeKLjzChlYGpS2GbVbU99I98QfSDr5tIr/ZdKaGIFLciQEElQJ/WFwrbezrv6G
	 mfEb+iSQWrIew==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH] MAINTAINERS: remove outdated entry for crypto/rng.c
Date: Thu,  5 Mar 2026 20:19:15 -0800
Message-ID: <20260306041915.286379-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Lore shows no emails from Neil on linux-crypto since 2020.  Without the
listed person being active, this MAINTAINERS entry provides no value,
and actually is a bit confusing because while it is called the
"CRYPTOGRAPHIC RANDOM NUMBER GENERATOR", it is not the CRNG that is
normally used (drivers/char/random.c) which has a separate entry.
Remove this entry, so crypto/rng.c will just be covered by "CRYPTO API".

Cc: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting cryptodev/master

 MAINTAINERS | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 55af015174a5..31bd5bf05ac2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6828,16 +6828,10 @@ CRYPTO SPEED TEST COMPARE
 M:	Wang Jinchao <wangjinchao@xfusion.com>
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
 F:	tools/crypto/tcrypt/tcrypt_speed_compare.py
 
-CRYPTOGRAPHIC RANDOM NUMBER GENERATOR
-M:	Neil Horman <nhorman@tuxdriver.com>
-L:	linux-crypto@vger.kernel.org
-S:	Maintained
-F:	crypto/rng.c
-
 CS3308 MEDIA DRIVER
 M:	Hans Verkuil <hverkuil@kernel.org>
 L:	linux-media@vger.kernel.org
 S:	Odd Fixes
 W:	http://linuxtv.org

base-commit: 1eb6c478f1edc4384d8fea765cd13ac01199e8b5
-- 
2.53.0

