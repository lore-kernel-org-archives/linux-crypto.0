Received: from mistyrose.cherry.relay.mailchannels.net (mistyrose.cherry.relay.mailchannels.net [23.83.223.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8B3207A0B;
	Wed, 31 Dec 2025 09:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.223.121
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767173121; cv=pass; b=B1qrIIzoJnTxcH+Kc+53rNaUaayJ4oWqwXz+RNy20Wz9REGiJ9wuRRC7fV1dya2W19a0KbpY7p6lTlXeW3mniRb3O8SdwGmmB8efrqDxRYRFfd+yYi9ShsSVbWZk12UTXB3zr8VwbrZg0W0AgLj/h9Ma472dpdZGmWnMSRFHJCM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767173121; c=relaxed/simple;
	bh=ha63QGK1t2NQO543QIdflDKBcwyF+L6stQ6PVrY+dFI=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=K2iL6bmtStLt7BQWSOygtjfj6FCkSVKrcv9tt9tf4CVbILZ92N0JTp/faHr8MMsu+za/lM2jOJotA5fsJdhWL4hVDDELjuzFaeuBcjAVkqRWW6/kyraKYr2lKgzh8FOvlFaMRe0i83xDjiiFC4guBXT0o3YEpTgCJ7hR6XZU53w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kriptograf.id; spf=pass smtp.mailfrom=kriptograf.id; dkim=pass (2048-bit key) header.d=kriptograf.id header.i=@kriptograf.id header.b=uMfOUfZ0; arc=pass smtp.client-ip=23.83.223.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kriptograf.id
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kriptograf.id
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kriptograf.id header.i=@kriptograf.id header.b="uMfOUfZ0"
X-Sender-Id: nlkw2k8yjw|x-authuser|rusydi.makarim@kriptograf.id
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 4787C4C1FAD;
	Wed, 31 Dec 2025 09:25:18 +0000 (UTC)
Received: from vittoria.id.domainesia.com (100-106-233-210.trex-nlb.outbound.svc.cluster.local [100.106.233.210])
	(Authenticated sender: nlkw2k8yjw)
	by relay.mailchannels.net (Postfix) with ESMTPA id 0E7444C0D47;
	Wed, 31 Dec 2025 09:25:15 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=mailchannels.net; s=arc-2022; cv=none;
	t=1767173117;
	b=6ZGZx9HKmF0S2nT8Gi1e13oeDqDfDsf3lm0OqeYmdxFki8JBFqLDvpfyiiWK2ndEPi9eR6
	0LwmXDazge39ohGzxdMCO7z7Hz8pMezScBy74ZK5xoaRIr+4G+Rgtw9EjKiRUDunasV+rE
	sA9Pw5HpiP4fb7UlmCbZ4XoDzcFgDFS2yJaG+rHvtraA4bdFH6z9WWIujbKWKJF/BNTi7a
	Q8qSnBXwZbtI289I8MYz3oPUe5n/wdBSuEG57Bieujd5C8iYNmdBr6g+Vubqg/jyNej5Y+
	EYtPyRKTLSqGno1WqjWMkUFqhLX1vEZgVBjZY0opJnm1F4DkA+S1QAWomv6UXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1767173117;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:dkim-signature;
	bh=gMT+oMjDsy6PkLi4GsfsYBTescaYJkmTSc7ErMe6uik=;
	b=KqCoBc3K+J4RxR889uOc3E7vsIXboDtR9c2/+b/rKjvyHAFB3el4pdlJTupj9j+NMZCcU6
	GmTgQN1PcSJU10Ax0WU49y42fVFqMzbnFihgnWqTa+FDWw2OVspUY4mOev01Oxn66PYq/1
	UQ0WjyvwXbNF9WfwVOHeeYl2FaczR1FrnGuSlzxuOt3AfTHSYNijVno81KTZ/IG2eXMMRu
	wlbrfI8KH22ZDZ6ZevQjdXBZklQq0cTE6DuBbg2YYkxMg8an9k0np+Gg8ZfeH8uBOn+VPS
	MMZ8ySnuuAp8U4O28pZKflXdsqysMtUJxD3/gaVIgu+yGBJmA/V8hEAc5pXnbw==
ARC-Authentication-Results: i=1;
	rspamd-69599c6f48-klbvj;
	auth=pass smtp.auth=nlkw2k8yjw smtp.mailfrom=rusydi.makarim@kriptograf.id
X-Sender-Id: nlkw2k8yjw|x-authuser|rusydi.makarim@kriptograf.id
X-MC-Relay: Junk
X-MailChannels-SenderId: nlkw2k8yjw|x-authuser|rusydi.makarim@kriptograf.id
X-MailChannels-Auth-Id: nlkw2k8yjw
X-Relation-Irritate: 611161e54f58b8e0_1767173118140_3103065109
X-MC-Loop-Signature: 1767173118140:2257739895
X-MC-Ingress-Time: 1767173118140
Received: from vittoria.id.domainesia.com (vittoria.id.domainesia.com
 [36.50.77.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.106.233.210 (trex/7.1.3);
	Wed, 31 Dec 2025 09:25:18 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=kriptograf.id; s=default; h=Cc:To:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-Id:Date:Subject:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=gMT+oMjDsy6PkLi4GsfsYBTescaYJkmTSc7ErMe6uik=; b=uMfOUfZ0h1sYGFe8pemmhh+uFO
	jLBbLwFXJEHwhD7CSTOXXPk4mjM6A3/Y2M4c1pL6wH8th/qST/2vlp9of/wzmSLfPMnh0u5gOI8xh
	2O8F6C9FlLrq0A8Z4nYzcZavc/XxYsa+jOFGhaNYVlf5+0O990AMK8j9uW99266KRpcrrEpkwvfqo
	mI47H2Fdn8HImPOStq8VOMVy02LZ6kBfZR9CLNJJb1O3CXbqTQl/xGqYM4CC4a8STp+DM2ZM3n8oY
	ho/60fjhcW4YkXybUAao7Eu9yki5pZaHzyctJpHdVcunLXeUq6ABNaGLwpXkdvgwWEv6CSaXoLDV5
	EEOxYVGg==;
Received: from [182.253.89.89] (port=29807 helo=Rusydis-MacBook-Air.local)
	by vittoria.id.domainesia.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99)
	(envelope-from <rusydi.makarim@kriptograf.id>)
	id 1vasS9-0000000B53Y-3T4q;
	Wed, 31 Dec 2025 16:25:12 +0700
From: "Rusydi H. Makarim" <rusydi.makarim@kriptograf.id>
Subject: [PATCH v2 0/3] Implementation of Ascon-Hash256
Date: Wed, 31 Dec 2025 16:25:34 +0700
Message-Id: <20251231-ascon_hash256-v2-0-ffc88a0bab4d@kriptograf.id>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/13OQQrCMBCF4auUrI1kpolFV72HFIl10gxCU5ISl
 JK7GwtuXP4P5mM2kSgyJXFpNhEpc+Iw18BDI0Zv54kkP2oLVGgAQUubxjDfvE0ezUl2SkOrnIY
 7nkW9WSI5fu3edajtOa0hvnc+w3f9SeZPyiCVRG2paw2ZDqh/Rl7WMEXrjvWHoZTyAU2XSIyuA
 AAA
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
Changes in v2:
- lib/crypto: fix compilation error of hash_info.c
- lib/crypto: fix build warning of tests/ascon_hash_kunit.c
- Link to v1: https://lore.kernel.org/r/20251215-ascon_hash256-v1-0-24ae735e571e@kriptograf.id

---
Rusydi H. Makarim (3):
      lib/crypto: Add KUnit test vectors for Ascon-Hash256
      lib/crypto: Initial implementation of Ascon-Hash256
      crypto: Crypto API implementation of Ascon-Hash256

 crypto/Kconfig                         |   7 +
 crypto/Makefile                        |   1 +
 crypto/ascon_hash.c                    |  86 ++++++++++++
 include/crypto/ascon_hash.h            |  83 ++++++++++++
 include/crypto/hash_info.h             |   1 +
 include/uapi/linux/hash_info.h         |   1 +
 lib/crypto/Kconfig                     |   8 ++
 lib/crypto/Makefile                    |   5 +
 lib/crypto/ascon_hash.c                | 169 ++++++++++++++++++++++++
 lib/crypto/hash_info.c                 |   2 +
 lib/crypto/tests/Kconfig               |   9 ++
 lib/crypto/tests/Makefile              |   1 +
 lib/crypto/tests/ascon_hash-testvecs.h | 235 +++++++++++++++++++++++++++++++++
 lib/crypto/tests/ascon_hash_kunit.c    |  33 +++++
 14 files changed, 641 insertions(+)
---
base-commit: 92de2d349e02c2dd96d8d1b7016cc78cf80fc085
change-id: 20251214-ascon_hash256-704130f41b29

Best regards,
-- 
Rusydi H. Makarim <rusydi.makarim@kriptograf.id>

