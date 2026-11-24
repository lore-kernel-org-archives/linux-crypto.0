Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795508433;
	b=K9R9cnzo6JFmFm0QC7x58/b0mX2H9zDe81ZN3/iz8SpVuUjFzS06LO0PRGAM/PxrURek
	 UqLENL/LJLVLjnNHXdHOjiXuN5M7Z+xaQ5WFUBO8jkho91vmAif+IVncujEK5M2V4z9pG
	 6U6fQCZt/GmQaNMucHbynmN8zUHk55k4tbHLrLdUwgVcR0aepc3GMYS45b1H/4nD6/Wyx
	 9VIG+FXleiVuGB6yhf6iq3tDzddhBZGp7JfC4TEwp/p2hQ2sfl662ZCWqSP+wyft7rzbH
	 qSKxTLZPJKcNo3jzgjrVAEUOY2bOnFzEE7hZXmaGeW8TsSMw68+LHV5kLKWIVkfsNPQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795508433;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=65XV3n5OmazkoQahF/FD/QxeH7h22sCza9h0+2Ucpy8=;
	b=ZwwIDokP991nvwFcS7pcM8O5yEfP6t/zFhuWXlK8AawkOauwWX/iJCWWGE7vgSOTrF0i
	 S5JnmHIrjVMaH5QthDoG+Trl44N/JS/NeWuOUqnzdE2SDoqraNaDBxgr5LK5wtgrMRxJX
	 ng2dIU4r7xoa3RpMdSFsjPMajOIbDL0xdFR19c/8grWcmkcfGG+iZcEz+lkE4e02crF3B
	 dDXQ/MyZnZPv8ldPEukoNI7CaFXzt3t4OO42vtGcYa4MkA5CGkRxmXPjTDVthw6ahArpB
	 FbEXz6FDeYkwpWhmiWW2UUMQqIJt5dnjGO/XZklm6L2veQAtKdVzkFx2Fm9BajoHPEw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="NH/FZTCX";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E66606A322;
	Tue, 24 Nov 2026 08:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NH/FZTCX
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795508432;
	b=c0MZwJIvANXqRga9t0E/44d8ua3pqP00TnzuLGw3HLNHrbuOOVu5bkVNJ0x3bQq3dJuP
	 N9rf+pRormZvPyfCUPWFahv0Y3z/ysVSk1y1pZle9Kd8JGNickpFEBJWALqiaWQhudTmx
	 bzsVVfqEFLpiBNNZwH09heuwhOQo/NWhVuPIwwCEeVBNvLSWSFEOKEL04tqYbjGSkGqXr
	 VP4uAdGvU5kYcctwDUeCjvFOxrsts9RWMEYZ8WKKaltnjzwZB5YvyayF2ij/MWS9d8KHk
	 jCOe8OsxoVssPXHiqlMwKQd0ewR4APLMcHo9OcerGE8b/jInDpf9Bu/opGx9XCiR1QQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795508432;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=65XV3n5OmazkoQahF/FD/QxeH7h22sCza9h0+2Ucpy8=;
	b=1j3ueOCLXfuQ0Ae5XV3zUf67Hg9orA1M53DDvBBByNKSZRZP1Geu2Kt6h0CaBUF0IVOp
	 CYWG2isF57HFNGA4Nb21xVNJDiqkNlW+UINy/Bnv2G8fHllkNvPrV4Hboc4pf31z58wVz
	 arhZwvXWaG+mOKwc6Fe5uJ7W0jtugFMcOoIBpe608zT9HH61qx+a1bIdqGjjUiYPFE6Aq
	 kp7NaSylink+xRZKeSeYmld9EWIYdgSmaLM817kADEVIKFYffDcjRzUJv2bVU4TQUyOPm
	 QNhoES9WLTKqin6fassDKxkj3HiO0E9DuYimT7JkRpgeywlGQnvQZFAK+oM80ui/DPQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 975121F000D1;
	Tue, 24 Nov 2026 08:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795508432;
	bh=65XV3n5OmazkoQahF/FD/QxeH7h22sCza9h0+2Ucpy8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=NH/FZTCXvWBZ87Ve4yQ+n8+eYTAZYvtyAUa6AGEynRIQyTkcm+DtlSaIWRcHpDu6V
	 szwDXapKz3ta8GDEVoHkCRPfEqoAJb9s2voJ9zyxFAFJhokz/UAp7I4AANn4K7D9D8
	 9KPJCZnV7LzzouNrsWvyW+XuE2cNJzbCKo5KCtmFT3PpstWI+/hEVxywzxt3qQP6Q4
	 N1vMTpyCOWp69UPchbjRLvnwet2qYTaXUuV6OIZKBau6g7pchuZur27KTIuam/IFcK
	 PFZOchk8cyCPvInqIb+m/DXSbTk2Wu5ULBihg3r438I+jiXoZJlJltmuJt2ncNjCjc
	 HvdBCfw9nve9w==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 295394C941;
	Tue, 24 Nov 2026 08:20:21 +0000 (UTC)
From: Fil Dunsky via B4 Relay <devnull+filipp.dunsky.gmail.com@kernel.org>
Date: Tue, 24 Nov 2026 11:20:21 +0300
Subject: [PATCH v2 3/3] MAINTAINERS: Add Cortina Systems CS7542 TRNG
 support
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
Message-Id: <20261124-b4-cs7542-trng-v2-3-0192937b44be@gmail.com>
References: <20261124-b4-cs7542-trng-v2-0-0192937b44be@gmail.com>
In-Reply-To: <20261124-b4-cs7542-trng-v2-0-0192937b44be@gmail.com>
To: Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>
Cc: =?utf-8?q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>, 
 linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795508418; l=909;
 i=filipp.dunsky@gmail.com; s=20260930; h=from:subject:message-id;
 bh=MzB08CctM8fwsUgGK3bypoUBj9M40TVd0CcGnpP75WA=;
 b=tHE1Fi5oHku4Cl+7MQSTeOe4Ua2Rr2u6spKFraXTw2guvbiji8EzAZuQjfcgw1fYitR5mokd9
 KJQwEwF2iBPCVs2obe6IxL1AC5N38aWUyFioU3hPzKvfyYLAG9ZMquX
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


