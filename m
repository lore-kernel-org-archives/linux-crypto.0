Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795074616;
	b=yhvm5M4u7RaET8hFTwSYaunbn0TkqCMzsfaMa4s8qoR6N+9vJ2FxKCh2b6N/3kM54j+l
	 sBxFJ9K7l7xupDF9zeGdSF1APvRwhxEWOCKrrWaRwWlrfQeyi1i1fIpJchDIDVbQuqusB
	 DbfD0BzXrHD6Dc/PqqdEvyzPOQKDxbXkWgF5lvkmFzEqhjOteOtHjztmucBRXZnEB2icQ
	 gYMv+xNgs7HnOdysZBhOj4i6S4mpkz0AgiedGNa1mFUlipp6vs21e9X1hemzD1Eg1UjAJ
	 5r2J0iNgmjrTmK9s/Cq6RG++OMcmQ97YLD40ZEB2JdN6z3mWi9wnoHafzmVw6xlKHiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795074616;
	h=DMARC-Filter:X-UUID:X-CTIC-Tags:X-CID-P-RULE:X-CID-O-INFO:X-CID-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=YK7Q5AGYD5X7mb5K/vaLkSYnqHBLTOag7oVBX3R6fSI=;
	b=rZ2pwo0S8j8Q3VZ2ztG/UzK6zgTGKgCfjVKnk7qNyeNWIVkYkASARAJvszPSLJwkYcAt
	 yxZuDCoqhWQw3JlcuL6z1vnfw0GOgFm6ncQ/Vgi/7UVX1SlxXbZnpT5dKFj5lA593ZLB3
	 WUwciBxPfnGowspqyluME+/cdmuc9trAy2QMNIFqzSNWhHYNVy0GFkIeURROByE+6YHWr
	 sVt8dRk9VVnZZFIP/ePVcVJQMGjK4zTuQTbayVejPmQVw+IkjJghV3TGslnb4jEj0Sonh
	 xWu/KoRVOdeeZmasTTm/sXn19stUj//SDLXND5ZhL7j1Ba9Ugybd8tzb/2OMx/086ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEBC606A320;
	Thu, 19 Nov 2026 07:50:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5BEBC606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: d65f8368e3ed11f19a56ed5b684f684d-20261119
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT
	HR_TO_DOMAIN_COUNT, HR_TO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR
	SRC_UNFAMILIAR, SA_UNTRUSTED, SA_UNFAMILIAR, SN_UNTRUSTED, SN_UNFAMILIAR
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD_SPF
	CIE_UNKNOWN, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:698003bd-e3c6-4df3-a8cb-788b68fb5408,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:698003bd-e3c6-4df3-a8cb-788b68fb5408,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:d3243e08d7160a42ecc393c04f771288,BulkI
	D:261119155009ZBQBSZKZ,BulkQuantity:0,SF:19|38|64|66|72|78|80|81|82|83|102
	|127|136|153|841|850|865|898|915,TC:nil,Content:0|15|50|99,EDM:-3|-100,IP:
	-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LE
	S:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d65f8368e3ed11f19a56ed5b684f684d-20261119
X-User: maguicai@kylinos.cn
Received: from localhost.localdomain [(36.106.123.207)] by mailgw.kylinos.cn
	(envelope-from <maguicai@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 641219735; Thu, 19 Nov 2026 15:50:06 +0800
From: Guicai Ma <maguicai@kylinos.cn>
To: Florian Bauckholt <florian.bauckholt@cispa.de>,
	David Howells <dhowells@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>
Cc: Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E . Hallyn" <serge@hallyn.com>,
	Hui Peng <benquike@gmail.com>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Rodolfo Giometti <giometti@enneenne.com>,
	keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guicai Ma <maguicai@kylinos.cn>
Subject: Re: [PATCH v2 1/2] KEYS: fix signature length passed to KEYCTL_PKEY_VERIFY
Date: Thu, 19 Nov 2026 02:50:04 -0500
Message-ID: <20261119075004.689388-1-maguicai@kylinos.cn>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261119-keyctl-pkey-fixes-v2-1-9e2d1c7db7ec@cispa.de>
References: <20261119-keyctl-pkey-fixes-v2-1-9e2d1c7db7ec@cispa.de>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, Nov 18, 2026 at 11:19:28PM +0000, Florian Bauckholt wrote:
> As a result keyctl_pkey_verify() ignores the signature length passed by
> the caller and always reads max_sig_size bytes from the signature
> pointer. A shorter signature is extended with whatever follows it in
> the caller's memory, or the call fails with -EFAULT if that memory is
> not readable.

Verified the union usage in struct kernel_pkey_params and reproduced both
failure modes on arm64 with an RSA-2048 PKCS#8 key (enc=pkcs1 hash=sha256):

- A truncated 200-byte signature with the remaining 56 bytes still intact
  in userspace memory was falsely accepted (0) before this patch, and is
  now rejected with -EINVAL.
- A 16-byte signature placed right before a PROT_NONE guard page (as well
  as a 0-byte signature at the page boundary) returned -EFAULT before this
  patch, and now returns -EINVAL without faulting.

Reviewed-by: Guicai Ma <maguicai@kylinos.cn>
Tested-by: Guicai Ma <maguicai@kylinos.cn>
