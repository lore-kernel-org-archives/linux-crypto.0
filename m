Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B453B3D5645;
	Thu, 30 Jul 2026 09:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785404028; cv=none; b=dnT0E9nv5hJpA9T3Qfec+N73J2mM26Wy0RR5ngdFaeUFmcwKG+WZ+Cc/YyAtnXlIMOP7h3g2P9Sx2kp9NvxecFgefWzKPXZzW4GHuhWdd2T51uZUXfPo9e0i18zfDndzLk3EycLMJgenP5oc1X23HB2EoWD0uSgj25wBBLwKw4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785404028; c=relaxed/simple;
	bh=jiClCBMXuRDUCJhU8Sw2OgaHfipmtUP9SKW3wlgyCso=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BfkObKu5lOND0idCQXWFDcFK2zau45T0h9G0OhJA0emiCA0u1VnPZw3xz37ow72EuyXghG1qThfSZCfJ0plfCFMH4bHnGALbikZSdkLIHR7b1Is61uid9Q4E1ikNxTbrih/f9vnPDw9I09h4cNNQaHwr7ZTMIIfC0WSjf3A+AgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: bd408eaa8bf911f1aa26b74ffac11d73-20260730
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:3768946b-c9ed-463a-a7f0-9d0ea9ce697a,IP:15,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:40
X-CID-INFO: VERSION:1.3.12,REQID:3768946b-c9ed-463a-a7f0-9d0ea9ce697a,IP:15,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:40
X-CID-META: VersionHash:e7bac3a,CLOUDID:b543d294aa0835470d514bb5922cd1db,BulkI
	D:260730173340EOWZ2KO5,BulkQuantity:0,Recheck:0,SF:10|66|78|81|82|83|102|1
	27|850|865|898,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bu
	lk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:
	0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: bd408eaa8bf911f1aa26b74ffac11d73-20260730
X-User: yijiangshan@kylinos.cn
Received: from localhost.localdomain [(116.128.244.171)] by mailgw.kylinos.cn
	(envelope-from <yijiangshan@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1541964972; Thu, 30 Jul 2026 17:33:36 +0800
From: Jiangshan Yi <yijiangshan@kylinos.cn>
To: herbert@gondor.apana.org.au
Cc: 13667453960@163.com,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yijiangshan@kylinos.cn
Subject: Re: Re: [PATCH] crypto: krb5 - Use constant-time checksum comparison
Date: Thu, 30 Jul 2026 17:33:05 +0800
Message-Id: <20260730093305.491689-1-yijiangshan@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <amr3cTpCcPd7PYna@gondor.apana.org.au>
References: <amr3cTpCcPd7PYna@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Jul 30, 2026 at 05:04:17PM +1000, Herbert Xu wrote:
> Please explain exactly what secret information might be leaked by
> the timing attack.

Hi Herbert,

Thanks for the review and the question.

The leaked secret is the correct MIC checksum value, not the key Kc
itself.

In rfc3961_verify_mic(), memcmp() compares:

  - cksum:  the correct MIC = MIC_{Kc}(metadata || data), computed
            with the session checksum key Kc
  - cksum2: the claimed MIC from the incoming packet (attacker-controlled)

memcmp() returns at the first mismatching byte, so its timing reveals
how many leading bytes of the attacker's guess match the real cksum.

Because Kc is fixed for the session and the attacker chooses the
message M, the target cksum is a constant across repeated attempts.
The attacker can then recover it byte by byte: try all 256 values for
cksum2[0], observe which takes longest (meaning it matched and
memcmp proceeded to the next byte), fix it, repeat for cksum2[1],
etc. Once cksum is fully recovered, submitting (M, cksum) passes
verification -- a forged MIC.

Kc itself is not exposed, since cksum is a one-way function of Kc.
But recovering cksum is enough to defeat integrity for that message,
which is the secret worth protecting with constant-time comparison.

This matches what krb5enc.c:255 already does with crypto_memneq() for
the equivalent comparison.

If you agree this justifies the change, I will resend with this explanation folded into the commit message.

Thanks,
Jiangshan
