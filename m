Received: from bumble.maple.relay.mailchannels.net (bumble.maple.relay.mailchannels.net [23.83.214.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBD6242D70;
	Mon, 15 Dec 2025 09:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.214.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765792123; cv=pass; b=bvdzh1yFoXmxxeoG7YCYwh29yV37fzDEZzvA8bo7EqKL2ngn5Yg9cnQcLUlj4gScGBzCK4Zh7cT/jTk04+BAE4fLbhGsZ96DYuBA4bEXfQpQwTIxiaTMRLfH5LlqzgnsRCAQ3sRNBArayMb/yEkJjJDy6RbIqtyfI6k7ebzg4p8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765792123; c=relaxed/simple;
	bh=pL37RT0Nu/UP12N4iTxb1vMQJ6iZJ0QyBBXPUUM6x3U=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=VO1u60h9n2S0ERpB8JwToHWxBQNY9kVFrHsBsht2Y3jbsEkbRHmzYkeGd64EJ/E6XxBEl3DRxSAk64QXBNdkT5qaowfHRSUTgKPKrDLPZbVHdwFyOCpql4R2cwlt5hfHn2qrzBWJO8dJiqm3GPWZBaz8L4mg5GG/0WTHcQ/qn+8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kriptograf.id; spf=pass smtp.mailfrom=kriptograf.id; dkim=pass (2048-bit key) header.d=kriptograf.id header.i=@kriptograf.id header.b=OOkIzjkp; arc=pass smtp.client-ip=23.83.214.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kriptograf.id
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kriptograf.id
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kriptograf.id header.i=@kriptograf.id header.b="OOkIzjkp"
X-Sender-Id: nlkw2k8yjw|x-authuser|rusydi.makarim@kriptograf.id
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 1366B560E6E;
	Mon, 15 Dec 2025 07:54:13 +0000 (UTC)
Received: from vittoria.id.domainesia.com (trex-green-3.trex.outbound.svc.cluster.local [100.103.169.235])
	(Authenticated sender: nlkw2k8yjw)
	by relay.mailchannels.net (Postfix) with ESMTPA id D73D2560E4E;
	Mon, 15 Dec 2025 07:54:10 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=mailchannels.net; s=arc-2022; cv=none;
	t=1765785252;
	b=vZk+mlnjh1n/V0+O5UL99GHMsum0V8BOLjFQh50LzVcrgwSP+NaVc5yvQf2ofgYt5TFyid
	dKtT8G2ElPdUNrhrUlOmALccCTufWRlZyj71jp2p1gaulscv2ZxNG9wnQcGXMg/Kx0zVZ5
	zgNhNZyEsWQmDSLWDuPFAh9p+yrDfcWC2LK2FpwdKo6w9Wt2TyBC4Q/e/d3OLl0WFTBs2p
	oymT6TkbwWHdD9QByszcjpOEIQW1IC5elWCRZLGvTrMixpXPDP7OWPNOj/9mhQxkYAdptQ
	eFq+2nAoWpsJ6rq76UhD/HOlgD2X/eTNpytEDSisExLJPsI5l1EAPnkDzdsjXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1765785252;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:dkim-signature;
	bh=GRheD0q0c/ab+q0p0muzeRufKeVVdaml7eu6FnXPid0=;
	b=WZkSUmqefrqyml3Ev7JRF05NB4p31RcoZmy74AmBlmxMjDMWfYq13AavYc2kM4YF4WCY8V
	Q5NVVtktkzCKX1Bz5NTIgwSobWNi/4SkLqHT1QYlzIgW1arEm1Qj/pakNaQkDLZ0dNKWBq
	j3pzFi08jCkVR3e3a8SlZ81TEiNhK+wbsHS8GxoGKZ9pX4QNRsUwzGeLjf7wuoiu8SJ6DP
	yWqsqiiurfH5RNnV6rC4d4Nn44KFgOFWfYtGJR1htiIAPlYE6gd6fUNRSDhW5K7xTy4O6P
	V5fpv/3F0faGVWl9ByDUTLzBmMboRQ86xoH0pil+5qFaWyHn5J6Qizr4qWvpmg==
ARC-Authentication-Results: i=1;
	rspamd-659888d77d-j78qb;
	auth=pass smtp.auth=nlkw2k8yjw smtp.mailfrom=rusydi.makarim@kriptograf.id
X-Sender-Id: nlkw2k8yjw|x-authuser|rusydi.makarim@kriptograf.id
X-MC-Relay: Neutral
X-MailChannels-SenderId: nlkw2k8yjw|x-authuser|rusydi.makarim@kriptograf.id
X-MailChannels-Auth-Id: nlkw2k8yjw
X-Shade-Juvenile: 1d68f5b9634493ea_1765785252985_1273595822
X-MC-Loop-Signature: 1765785252985:2314616666
X-MC-Ingress-Time: 1765785252984
Received: from vittoria.id.domainesia.com (vittoria.id.domainesia.com
 [36.50.77.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.103.169.235 (trex/7.1.3);
	Mon, 15 Dec 2025 07:54:12 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=kriptograf.id; s=default; h=Cc:To:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-Id:Date:Subject:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=GRheD0q0c/ab+q0p0muzeRufKeVVdaml7eu6FnXPid0=; b=OOkIzjkp0n62XncAS+ZkF7vpS3
	GiHNkbCFamPriTafsz0AOtdbTQ5rcNkiE//kh8zClp8PMilxPR9Ijivym66avKews/+HNQNK3ZWDL
	5gpCfVe4nKIuiQ/jeIgk5XZlI5+ieDNJ+RGSp/sHM8cbNbNJ/22S5LwkAEzOLLz0WF1hZEkqtHq7O
	AdahkQY6G2D50dbYxqIhTULa2Na2pdHhAkuECYLASvnj51MdRaKF6efiMEykEYVbK7XNSbOjgrBAg
	5TZq4C+XoGpgkR1MqnxHpRL48M87KdPN8PVjLTn3XbGxeFh2GIY2ZrE9Rv1MTuOT04rv/dMsxJP2Z
	XDkf5DhA==;
Received: from [182.253.89.89] (port=19977 helo=Rusydis-MacBook-Air.local)
	by vittoria.id.domainesia.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99)
	(envelope-from <rusydi.makarim@kriptograf.id>)
	id 1vV3PE-0000000FQZW-3UFs;
	Mon, 15 Dec 2025 14:54:08 +0700
From: "Rusydi H. Makarim" <rusydi.makarim@kriptograf.id>
Subject: [PATCH 0/3] Implementation of Ascon-Hash256
Date: Mon, 15 Dec 2025 14:54:33 +0700
Message-Id: <20251215-ascon_hash256-v1-0-24ae735e571e@kriptograf.id>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MMQqAMAxA0atIZgtNrIpeRUSqRpulSgMiiHe3O
 L7h/weUk7BCXzyQ+BKVI2ZgWcASfNzZyJoNZKlGQme8LkecgtdAdWNa67Cym8OZOsjNmXiT+/8
 N4/t+gjhYkF8AAAA=
X-Change-ID: 20251214-ascon_hash256-704130f41b29
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Eric Biggers <ebiggers@kernel.org>, 
 "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
 "Rusydi H. Makarim" <rusydi.makarim@kriptograf.id>
X-Mailer: b4 0.14.3
X-AuthUser: rusydi.makarim@kriptograf.id

This patch implements Ascon-Hash256. Ascon-Hash256 is a hash function as a part
	of the Ascon-Based Lightweight Cryptography Standards for Constrained Devices,
	published as NIST SP 800-232 (https://csrc.nist.gov/pubs/sp/800/232/final).

Signed-off-by: Rusydi H. Makarim <rusydi.makarim@kriptograf.id>
---
Rusydi H. Makarim (3):
      lib/crypto: Add KUnit test vectors for Ascon-Hash256
      lib/crypto: Initial implementation of Ascon-Hash256
      crypto: Crypto API implementation of Ascon-Hash256

 crypto/Kconfig                         |   7 +
 crypto/Makefile                        |   1 +
 crypto/ascon_hash.c                    |  86 ++++++++++++
 include/crypto/ascon_hash.h            |  97 ++++++++++++++
 lib/crypto/Kconfig                     |   8 ++
 lib/crypto/Makefile                    |   5 +
 lib/crypto/ascon_hash.c                | 154 +++++++++++++++++++++
 lib/crypto/hash_info.c                 |   2 +
 lib/crypto/tests/Kconfig               |   9 ++
 lib/crypto/tests/Makefile              |   1 +
 lib/crypto/tests/ascon_hash-testvecs.h | 235 +++++++++++++++++++++++++++++++++
 lib/crypto/tests/ascon_hash_kunit.c    |  33 +++++
 12 files changed, 638 insertions(+)
---
base-commit: 92de2d349e02c2dd96d8d1b7016cc78cf80fc085
change-id: 20251214-ascon_hash256-704130f41b29

Best regards,
-- 
Rusydi H. Makarim <rusydi.makarim@kriptograf.id>

