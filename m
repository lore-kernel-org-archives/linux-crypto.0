Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB127303C88;
	Wed, 24 Sep 2025 14:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758723322; cv=none; b=mOxTDX3mWLQk+ipLuh/N8887n1SzxaQ2GOWQCRgvYb8zCUv+BG8v8pU2Wkw2wTmYtTnYkOiHs9Lck9Roaj61/Jbp0eoKNO6IWCJKeKTOEBn8B3B6rbO/u2l+AHQ5hG9eJ+OdYsMBz+zEa33sR+rNIEb3yUqN4DhGDPJxlU/Fl8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758723322; c=relaxed/simple;
	bh=OKSqrO3LZFuwARINEBqW4y/xQ22Me4w2B7wXbthwvJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K6/FGQ6Qd9KR5SD/tZ2FLL+rP/DOwZtN0FDiq+oGLGwtZ1X0umoo0idGzGBPBDqqEKqK9XLaxdyLXjYq5VpvIaa9U/aa5atrP1KnF3ZUC66JcatOz2P668nYRd+TloD6jt1QPIsCdPBY8x6bl263MkjkvtU93Qz3TXhjlL4iU2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kael-k.io; spf=pass smtp.mailfrom=kael-k.io; dkim=pass (2048-bit key) header.d=kael-k.io header.i=@kael-k.io header.b=ijCGY64H; arc=none smtp.client-ip=80.241.56.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kael-k.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kael-k.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kael-k.io header.i=@kael-k.io header.b="ijCGY64H"
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4cWzQ63W9tz9tCh;
	Wed, 24 Sep 2025 16:15:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kael-k.io; s=MBO0001;
	t=1758723310;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uDF0NveysQPfSfovDc8hfR/tmWatFKCZKG9GGaknk4M=;
	b=ijCGY64HEk8wzb//m56CvU+lNNfMHAVTzdMms0OFgUpKqDLz32DFGpqGF2VPokMWIeh0lX
	c/f097BQWh/WSXJ0lav2UPHwtR90fc4+70gcOYfnf3GsphxGU6dw3CtQsmoaB0+sGx7UHQ
	pItlqxYVqN6PnxJV8yt/1KMaRqdfaZ1q0R/4PXNpVwienur1gO+8ixvvjrYhYCcUaiNbqC
	m042OY1PzH5MAIPAzVw2dofPc8cFrv0GvfxnJOOKyDhqLVu13bLR/3er6LF1Nj+FEHy1AU
	x4pro0kmgVp3j3GhHFQT7S0ljq3uUduX/u8ovhnwbhVpobGlWXm4+M4QAW13hA==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of dev@kael-k.io designates 2001:67c:2050:b231:465::2 as permitted sender) smtp.mailfrom=dev@kael-k.io
From: Kael D'Alcamo <dev@kael-k.io>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] dt-bindings: vendor-prefixes: update regex for properties without a prefix
Date: Wed, 24 Sep 2025 16:09:22 +0200
Message-ID: <20250924141247.69323-6-dev@kael-k.io>
In-Reply-To: <20250924141247.69323-2-dev@kael-k.io>
References: <uprke6fujhmckymlpy6oskecol4awhqyroqlg25tprmhnkeyy6@ztozdrlmeotp>
 <20250924141247.69323-2-dev@kael-k.io>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4cWzQ63W9tz9tCh

Update vendor-prefixes.yaml to allow property names without a prefix
to contain '#' character in all positions

Signed-off-by: Kael D'Alcamo <dev@kael-k.io>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 9ec8947dfcad..e12c6ca399ec 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1811,7 +1811,7 @@ patternProperties:
 
   # Normal property name match without a comma
   # These should catch all node/property names without a prefix
-  "^[a-zA-Z0-9#_][a-zA-Z0-9+\\-._@]{0,63}$": true
+  "^[a-zA-Z0-9#_][a-zA-Z0-9#+\\-._@]{0,63}$": true
   "^[a-zA-Z0-9+\\-._]*@[0-9a-zA-Z,]*$": true
   "^#.*": true
 
-- 
2.51.0

