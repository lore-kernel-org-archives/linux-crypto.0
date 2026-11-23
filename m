Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795459324;
	b=y27iNDM0DwnC3CGoqnuo/acTZA1R/1Ndd822m2sj8FKz6hyfFNvYk+MU/FPYH+y2ndua
	 0lsZJs5qDAPP1kcgnkgm/GvtzXzWLS2uWEjXFp1/S2NruayIeyqyV5F5dhA84iuljLu4w
	 hquQWuxukMBi8kRfFKN8Tr6FXsJxi0KaFZjoTDyjEJuLRnJzh7G6njilvgh1NlaWz+lIh
	 bAa8RfFonYRanObZY9W9IO4E+aCyemkxTxNq3Fjpehc/VvfNZoGysdNc2nB0on2z4xrcN
	 6Qhi32GIee6jorTnIEq+mV34ZxwMu0Hmy0wOpoOu0FwZ3NlObQXCKNFoyKT3yLxHW/A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795459324;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=65XV3n5OmazkoQahF/FD/QxeH7h22sCza9h0+2Ucpy8=;
	b=OMq+WzUVJlvbyIYrI4zTFmiSVeaUYyNKioQSQ+6Aw1CNObqg0yxO5FPf3x0C8674z8SI
	 wb+1Mi+8DwQYgAMDWrmwm5YBU4ADF6Xj5PWwGn+QoDf2VsPzXGnHpY2FRy5hW5OAx7/wq
	 Bpg1ncE1JD38NN5YiEOWipyVfiUEOq3ygF7o9lcYgAMChHJ3Mg2H4qTsWWRknzyuH4+8n
	 5FaK0QFXPbWoOPokR58X1pIfVFK5dye9ScV3U6LNzYmLKUtGrkNIu6B4tSZ87AAmSEm+3
	 8CzomyTCAq7OJCxdpVaARkDEGpRN12kBlOlC3SvKlPoBmZV6HD2iyAFE9NWy/HVSY0g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AtblAx1a;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205B1606A68C;
	Mon, 23 Nov 2026 18:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AtblAx1a
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795459324;
	b=ofFVj/WVlyjKtYnxEFviH1I+0fm4iwrDzPy2Tjj6dHQD5wg4eWVnJbHIjYwBivgWP+o1
	 NnwoxByUT6o4sUbwZ8W2duNjH/9BynnhN1qs0oPlLkgD3tYpt+DIZ97wLSesgb4r5NjRY
	 CFkhE17iCzOXp/PfkAy6kJdfeCTGBj5IOBr7/YYqGHe7lzpuTAab1EG6gRzCFcXwQxg+b
	 rSDiCw9qphevDYtjJ1xCa/cX7cnxXiODiPV/0xELObniQuKH0s+Cz6ickvDwe026eEKC2
	 Is18ZnhtRHUZwwohUAqEfCBJlZMpEYyO9Cx91NB8JApLZW1Z2Pw9wkeNrjjZvYB4veg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795459324;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=65XV3n5OmazkoQahF/FD/QxeH7h22sCza9h0+2Ucpy8=;
	b=VXwgA7gExPzxtPfs5YKhugcuoTWkFUoWEAJICJShPiGnrsqdiCGONwpZJ5lKE+N5Rl/N
	 sjxYUwTRG0ji2dASlVYZuY9DOuirzCRNLrkyHwna0hlCKZddbPhnJdVjB/tmxhWPirps/
	 5B/rtMLdkHIilSqYzSoh4Y4GqsJI7J2jJCfeCAHNteCMvpuGZHQGj5vIdnAOZ3WBhGcbs
	 4isWnAFId81FTjINRy6UwbyY0ggrdATPhnrxPSMu6SxraAEYowkGJDDYBmGYCCpOx29gv
	 yLdSKtcKebYZMMWVrin+fsinUEGUcMEyEd2Z+L7BV7E4ItidhplnYqwhOkbID1CBjhg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id BF3921F00A03;
	Mon, 23 Nov 2026 18:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795459323;
	bh=65XV3n5OmazkoQahF/FD/QxeH7h22sCza9h0+2Ucpy8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=AtblAx1aqGRKk6ImEPMzRvTpcTwX3dvcN5wTG4A7h2GW32V7aaeJT31iEwFnZQScf
	 klIuLsN8DNMgs3ubbMx8v2uyue/ykezawANHNjznWEp3mlGE3Pit4/piOJJgGA0ZzO
	 rAHaX2OGOpzMF//ZrAf2Wa8hx65yEvxOO1myKxZE+lNbYW5+zeuCwDlrXv332oRw3D
	 +SBwN1GfYB2XF5OE73xjQJA4gFU1MzP2iQB8brxLlfAcyOVcnoQaBVxJkO3to4K5as
	 JgNxDcGUQjE+rwkcoRfV4GPjiGlKldkhfVZWcc95NmUJr7tv7LZ0tivlI4E8KNJA0b
	 qH84AAbH4L90Q==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 6E7CC4C5D9;
	Mon, 23 Nov 2026 18:41:35 +0000 (UTC)
From: Fil Dunsky via B4 Relay <devnull+filipp.dunsky.gmail.com@kernel.org>
Date: Mon, 23 Nov 2026 21:41:36 +0300
Subject: [PATCH 3/3] MAINTAINERS: Add Cortina Systems CS7542 TRNG support
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
Message-Id: <20261123-b4-cs7542-trng-v1-3-92d9ffcee531@gmail.com>
References: <20261123-b4-cs7542-trng-v1-0-92d9ffcee531@gmail.com>
In-Reply-To: <20261123-b4-cs7542-trng-v1-0-92d9ffcee531@gmail.com>
To: Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795459294; l=909;
 i=filipp.dunsky@gmail.com; s=20260930; h=from:subject:message-id;
 bh=MzB08CctM8fwsUgGK3bypoUBj9M40TVd0CcGnpP75WA=;
 b=N6RVj59IEkHti0WR8j1M1CP9Z2QUvmfNUVUF87ibspUEEE5Jd2HiA+5NoVHeEWCnCanbQWjjI
 SrRM+HiVySfDUA/ISJgQ3L4xWIWWVGlsXWVh2Qb5IP+pzrCTOif2Y3A
X-Developer-Key: i=filipp.dunsky@gmail.com; a=ed25519;
 pk=JAYP8e2rJ54DHOmhNtXud8rl1igAaAXoOHxtJmVXI1g=
X-Endpoint-Received: by B4 Relay for filipp.dunsky@gmail.com/20260930 with
 auth_id=1085
X-Original-From: Fil Dunsky <filipp.dunsky@gmail.com>
Reply-To: filipp.dunsky@gmail.com
Content-Transfer-Encoding: 7bit

From: Fil Dunsky <filipp.dunsky@gmail.com>

Route changes to the CS7542 random number generator driver and binding
to their subsystem mailing list and the platform maintainer.

Signed-off-by: Fil Dunsky <filipp.dunsky@gmail.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 44540a1eb..46d0a5778 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2949,6 +2949,13 @@ F:	tools/perf/tests/shell/coresight/*
 F:	tools/perf/util/cs-etm-decoder/*
 F:	tools/perf/util/cs-etm.*
 
+ARM/CORTINA SYSTEMS CS7542 RANDOM NUMBER GENERATOR
+M:	Fil Dunsky <filipp.dunsky@gmail.com>
+L:	linux-crypto@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/rng/cortina,cs7542-trng.yaml
+F:	drivers/char/hw_random/cs75xx-trng.c
+
 ARM/CORTINA SYSTEMS GEMINI ARM ARCHITECTURE
 M:	Hans Ulli Kroll <ulli.kroll@googlemail.com>
 M:	Linus Walleij <linusw@kernel.org>

-- 
2.53.0


