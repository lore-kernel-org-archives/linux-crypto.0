Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960041B5EB5;
	Wed, 24 Sep 2025 14:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758723247; cv=none; b=okXmOZagPHqm0wOBujCBu9tE2A/2GN5fiRgQiJnKquYSH0HSMZP4Tsg3A8WboyHgBoHOsPOIMzN1Vws81QnxugJS7I2LTIc5p9S6OPuNbYfQINCXUHC7bfqCrKXaqu5UbIxxIy0Ot3T8nD8yA3/ZcqjpDWmGzd1n347zfLZcfA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758723247; c=relaxed/simple;
	bh=htJ7DWJ0zJFSxf0FFn5TKDKOEq8PHrTlD1aBMHP6RVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dGew5dnjmNNP7HiLV865H0gxLGzdoQuXZKHCTEp2qmxg9bpPVdz+PghS7qEQnMva1sAmxe+/EWymxk+D5gYvFdIFNKvUsDx7lr1Mz82zAce659LQ44hidMl6eHaDntP2YMWsj1UhKkO2iN2OAeC9IluF66eDgTVeJJL9kThVJv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kael-k.io; spf=pass smtp.mailfrom=kael-k.io; dkim=pass (2048-bit key) header.d=kael-k.io header.i=@kael-k.io header.b=K+zfUxAM; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kael-k.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kael-k.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kael-k.io header.i=@kael-k.io header.b="K+zfUxAM"
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4cWzNn55qdz9thL;
	Wed, 24 Sep 2025 16:14:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kael-k.io; s=MBO0001;
	t=1758723241;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DakflNS4uPb5/yx9VLNAoL6/JWybuc4VUWkjNUQVoAQ=;
	b=K+zfUxAM5EN7/mLQSVjietJZL0PLx0rkwep2M5nw7Iwwps3XHuzzKXOhkKJfo35RwsnLeL
	cSPQ0PUENVsnhFcy+CrgBki4Zvaym299QK9jSj8GAJqWBGXSTQG7VdTPOjMcwiJw78LaNA
	N06J/ciWcK9EK+jH9VDmXnIdML95WZxXwQffN1InO3V9Fgo84JyIggQDiX98GBExiiJz34
	WxF1iHBC03FxaapUZ/UMp66Ep23LDU1yMybyK9RPf8YaeiZ5JPiwg2SvrXyLkF2Ehidkeu
	E1Puc4Rq671iP9IPeN7e14NbOmx6AXVMtq6JYGg+yXHFh70uvh2TxQneiWvO5g==
From: Kael D'Alcamo <dev@kael-k.io>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] dt-bindings: rng: sparc_sun_oracle_rng: convert to DT
Date: Wed, 24 Sep 2025 16:09:18 +0200
Message-ID: <20250924141247.69323-2-dev@kael-k.io>
In-Reply-To: <uprke6fujhmckymlpy6oskecol4awhqyroqlg25tprmhnkeyy6@ztozdrlmeotp>
References: <uprke6fujhmckymlpy6oskecol4awhqyroqlg25tprmhnkeyy6@ztozdrlmeotp>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changelog v1 -> v2:
* updated vendor-list by loosening the regex for names without prefixs
* removed extra example in DT binding
* updated DT binding filename
* updated DT binding title

Kael D'Alcamo (2):
  dt-bindings: rng: sparc_sun_oracle_rng: convert to DT schema
  dt-bindings: vendor-prefixes: updated regex for properties without a
    prefix

 .../devicetree/bindings/rng/SUNW,n2-rng.yaml  | 50 +++++++++++++++++++
 .../bindings/rng/sparc_sun_oracle_rng.txt     | 30 -----------
 .../devicetree/bindings/vendor-prefixes.yaml  |  2 +-
 3 files changed, 51 insertions(+), 31 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/rng/SUNW,n2-rng.yaml
 delete mode 100644 Documentation/devicetree/bindings/rng/sparc_sun_oracle_rng.txt

-- 
2.51.0

