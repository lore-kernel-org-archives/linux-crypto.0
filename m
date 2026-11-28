Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795887511;
	b=GiOxDjL3oa3FlNMOgglSoTXzspvppzZnVKgeG93dJh1KAtbaWvsqC6GvmehBktZ6biLW
	 OLGc1YwdhwmCxL5YlaeRQxR1Sx6qI72pZDUdJQzoldwHT6hpj66XEdWmAOo0/kbKd+Hxi
	 vFrlqWewBAfaczKkhkgg3CRvpnuqkFk9U7PERiqn6HFbFm7483Hpe3fxVCjWXHHJ4KmAK
	 R1eWbOE+wM+PLXMgMclrQ91TpizY6ku41mV4Kvwf/SmRBpwsjdYhr5jvSEg51++bdBZg8
	 9Crdo6tocitOjgKOK4RCSKQk2LdcZLlv7txjawxHveVwyZDI8OH79j7VbhIZDsHxuvg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795887511;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=2QSYgDfusuB2rdXJL0kHHsJQctEFPxLWlTsaODx6am4=;
	b=LJlib0CA6gyqacLiD/SVCFNjtGHbGaY7xIgBahUD4XnjOBie94pw5llMzb1NuN0iAQ4s
	 GZlrTgLhuWgpKQDxt0yYiW63/1TFMh8vkar6Xuf3TvxkNyLicArfAlJjjVkN450Jx+2wq
	 rNvsx9XJHgg6/lkJp5hmg06/GmZTYfJfZ8KT8+hlBx0xeVGx8VTBNrfqiXZ+5U8DG2roQ
	 0x3F/Xpz2CK+/yEddx51B2ZZifCnlVZt9Ry2UxVBp1vyIByBhOmIJedN6BiDXkYmE8L9o
	 PuGyWm81yrE69A8qrBfxfFEPugukLElA4Ndtg2cj13PuFagyOIY6h4XYaCUEK10yv0A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HApiETv5;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F77606A31C;
	Sat, 28 Nov 2026 17:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HApiETv5
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795887511;
	b=XduGGabG7ftdzlJKYOFMkxp/Qq7C9hsp16gw4qxepjqUSsoE/2TurMe6RYOvxMYVtq5s
	 ZEb8GlLUHsUaLJtknmKdSozD3V0rqRkyaSw8dfv8ThyyF7/PXeyfn/a65WpFoB1lP35DP
	 AGXmXIeVJuZ4SCaS0ng7ELvdEuAaBhqj07hYpeorhsJLBt8e7tVpLPKWb/HbSWqWsELSJ
	 rVWsKCpiwbJrD12e30Yj6/0rqXEGHJl1V9aLiVtVIny1GmxQWPR4DclNT3CUDgJvT64uk
	 g+YvfPPqLBVJ4+iW6ezPLnQXszgxelGuADJAlcVeQlIBowK3StP5M5Hg8li7Vod+GGA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795887511;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=2QSYgDfusuB2rdXJL0kHHsJQctEFPxLWlTsaODx6am4=;
	b=J8mP0I+7m1rT4S8qgtSuHnjrtWsWvw8dhP/XtMlWZyqbKhBl2p9YZOR9Gq3cNMcgpYNA
	 iBWIIiWfL2D7ilpN00BqQ0YmNftYcAJr4nN/9p/CFtxXKRAN6YJRa3z19++TT0KUMddDP
	 8qdiBtX5a3UQym6bu4WtlZnMwgdBmzxzNu9L+fE6vsZ/YAl2+husV2VfdEz1R34k/NX1k
	 7DJR/qHNTp2eudF54wVGuBQAq7Ww7+keuLimE4VzB2rx2N3tgOM3OAYU533PkXuzLLpGY
	 1JJ1qVsITEOcYH2grbbhgkuvszAR9WGiUnK/MCjcg51kfObA/qfDNaOPB2XVoRN3kfw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id DA3ED1F00893;
	Sat, 28 Nov 2026 17:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795887511;
	bh=2QSYgDfusuB2rdXJL0kHHsJQctEFPxLWlTsaODx6am4=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=HApiETv5kaEh9kJZuAALrVYVZJhAaoeLtpkiKdI4fFiXIePtScJPLIknJEVQcu7WA
	 nouGRlL280SSJA/5RRQN8ax12asZAzWQZv9uJHhEkspirAulyhUkmU7S1Am2o5d6Uz
	 d7rE5pwj8wkomXVcIUosFnk6OnuKhAqyv0hJoxmrpsHzgAwzeiC/04oDyWV3yHRyEQ
	 x23ZbIiUkJae5Ttih6mVmGNBzGcaDU6a4yP55+d1MgzzAAwv7kq6E0y5FvoibiqNTj
	 A1YS6uSw3c/Z5/y4RrUxu7bgUpOvJAYPDTLcXCeg+b5jWmaxjnuuQBY0+M4NBl3EAV
	 ZbtjJb4vMkLxA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 6F49F4E1BE;
	Sat, 28 Nov 2026 17:38:28 +0000 (UTC)
From: Arun Iyengar via B4 Relay <devnull+aiyengar1990.gmail.com@kernel.org>
Subject: [PATCH v2 0/3] crypto: ecc - Fix P-521 public key generation
Date: Sat, 28 Nov 2026 17:38:27 +0000
Message-Id: <20261128-ecc-p521-small-scalars-v2-0-0648f492bca4@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/4WNQQ6CMBBFr0Jm7Zi2KBBX3sOwaIcCNYWSDhIN4
 e4WPIDLl7z//gpso7MMt2yFaBfHLowJ1CkD6vXYWXRNYlBCFVLKC1oinK5KIg/ae2TSXkfGQsi
 mqSpBlTGQxlO0rXsf4Uf9Y36Zp6V5r+1G73gO8XM8L3L3/p4sEgWWJhmtKAuT5/du0M6fKQxQb
 9v2Bf76RWHOAAAA
X-Change-ID: 20261114-ecc-p521-small-scalars-601dd880c8bb
To: Lukas Wunner <lukas@wunner.de>, Ignat Korchagin <ignat@linux.win>, 
 Stefan Berger <stefanb@linux.ibm.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 Jarkko Sakkinen <jarkko@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Erwin Pawliczek <pawliczekerwin@gmail.com>, 
 Laveesh Bansal <laveeshb@laveeshbansal.com>, 
 Arun Iyengar <aiyengar1990@gmail.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795887508; l=1493;
 i=aiyengar1990@gmail.com; s=20261110; h=from:subject:message-id;
 bh=4QpzPaJjDpMKCRNZSFtiQ93lkyKG0Q3bS0kfTB4aQN4=;
 b=VFcL6HPjxSwGe5+T1DESuutSYUnD7Ll+XRHx9ZAgIWks2Db2gRzlMEdedkNJ/xnbfu8rH2zWQ
 nsfGmnvgGVIC2QlbeFkAXn88wev2H+YExsqC9e+LwjbVdRg68PtFuYw
X-Developer-Key: i=aiyengar1990@gmail.com; a=ed25519;
 pk=zXpRgUTrhaFe6jLyPqbBy3ccfkj04w0g2690Wv3mg+0=
X-Endpoint-Received: by B4 Relay for aiyengar1990@gmail.com/20261110 with
 auth_id=1480
X-Original-From: Arun Iyengar <aiyengar1990@gmail.com>
Reply-To: aiyengar1990@gmail.com

Two P-521 fixes for crypto/ecc.c and a KUnit test. Patch 1 keeps the
random initial Z from commit cd65eaf17841 below 2^521: with 576 bits,
every P-521 ecc_make_pub_key() call fails with -EAGAIN. Patch 2 fixes
the scalar multiplication for scalars below about 2^259.5. Patch 3,
suggested by Laveesh Bansal, tests P-521 key generation. No in-tree
caller is affected yet.

This series was developed with Claude (Anthropic) as a coding assistant:
it wrote the code and the commit messages. I reviewed it and tested it
as described in each patch.

---
Changes in v2:
- Add Tested-by from Laveesh Bansal to patches 1 and 2.
- Patch 2: note that k = n now runs the ladder on 2n.
- New patch 3: KUnit test for P-521 key generation.
- Link to v1: https://patch.msgid.link/20261114-ecc-p521-small-scalars-v1-0-7b114f076b33@gmail.com

---
Arun Iyengar (3):
      crypto: ecc - Keep the random initial Z below 2^521 on P-521
      crypto: ecc - Fix P-521 scalar multiplication for small scalars
      crypto: ecc - Add KUnit test for P-521 public key generation

 crypto/Kconfig    | 11 +++++++
 crypto/Makefile   |  1 +
 crypto/ecc.c      | 31 +++++++++++-------
 crypto/ecc_test.c | 94 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 125 insertions(+), 12 deletions(-)
---
base-commit: 9fb9278d13dca54ce7ecd3254c7df8839e59f03d
change-id: 20261114-ecc-p521-small-scalars-601dd880c8bb

Best regards,
--  
Arun Iyengar <aiyengar1990@gmail.com>


