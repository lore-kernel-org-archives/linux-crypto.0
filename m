Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795672361;
	b=RhHlyZ465eKUyFUwlhM2e8VcsuUbop3Ywo5G3GjpJaaaDxx6Y7wIuMFgDpB5wY+7SShW
	 TesKNspEZHVS9p4iRHJXi9KroTWrpDrRv6QmA0z6TL67y1gI/aCO8BaU85/l+LD3W5tVj
	 huBaSOBEdEWqjmDRW6DFtVXuTdfWAGp8lps5869DNQ2bWlqtRrN9MoJDARBgYG2PHyHla
	 pkx6v2PTDOnj6Iwpzd4Eov3j8cuFywGhN/bnTJ2gYoTFQc6NY2J4Ilt9OrFpXe/Kec1Bq
	 tBTHR8Q1F0kB1hyiOZRsOHsBkldF5hY0HdTdjb9s69Si7FPFsbZLA2+j1wuwwzg02FQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795672361;
	h=DMARC-Filter:X-UUID:X-CID-P-RULE:X-CID-O-INFO:X-CID-INFO:X-CID-META:
	 X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=CFaZma3mmwOAj/ONk5ovm1SzEDO2bKB9PlgCIBdiEXw=;
	b=2bibH4Re1cPzXrTCxWxOdtzsCQW0BV6m4rUNy8N1HhUsf/nAywyrJfslk8kouwya6NY+
	 VeqYO90sCtHzzmr5wI3z6B4VLsFn1sDxWz7ybm49aO535zDG5YxQErQll1UiuCuBdi5jg
	 whgZ3fYBh/85L10/oNqMA1r/c7rVWkRHLtxcdeeCyUz4BVlMB7Kw/2GPI6tUOzhiH0e9Y
	 dp2srU8t8RB/pSb5VnMVtiLA792DBVi1vCPNyvD1LbhrolM8u8Z16+1jb/HVN/++A50X5
	 1FJmCtQdEhBQ4x30GlyvHY8EYtH3maNWexI5qPLGzw7p4xXFGDiEsuwEhzhvd3pATgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8505606A333;
	Thu, 26 Nov 2026 05:52:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E8505606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 8e4b8a2ae95d11f19a56ed5b684f684d-20261126
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:6566d9bd-2e1b-4b0b-b36d-2f4361e02936,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:4,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:9
X-CID-INFO: VERSION:1.3.19,REQID:6566d9bd-2e1b-4b0b-b36d-2f4361e02936,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:4,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:9
X-CID-META: VersionHash:7db8b62,CLOUDID:951e568b2bd4836ee53eaa652bff1852,BulkI
	D:261126135229MOXB8ZWL,BulkQuantity:0,SF:17|19|66|78|81|82|83|102|127|153|
	850|865|898,TC:nil,Content:0|15|50|99,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 8e4b8a2ae95d11f19a56ed5b684f684d-20261126
X-User: maguicai@kylinos.cn
Received: from localhost.localdomain [(36.106.123.207)] by mailgw.kylinos.cn
	(envelope-from <maguicai@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 53493332; Thu, 26 Nov 2026 13:52:25 +0800
From: Guicai Ma <maguicai@kylinos.cn>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: af_alg - Fix data-race in af_alg_wait_for_data() and af_alg_wait_for_wmem()
Date: Thu, 26 Nov 2026 00:52:22 -0500
Message-ID: <20261126055222.2070179-1-maguicai@kylinos.cn>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118154815.607879-1-maguicai@kylinos.cn>
References: <20261118154815.607879-1-maguicai@kylinos.cn>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Hi Herbert,

Ping on this patch.  It still applies cleanly to cryptodev master
(04cd6899aaae) and mainline (40212b29a6f7).

If you would like anything changed, let me know.

Thanks,
Guicai Ma
