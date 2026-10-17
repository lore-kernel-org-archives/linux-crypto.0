Received: from 6.mo581.mail-out.ovh.net (6.mo581.mail-out.ovh.net [188.165.39.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C765D3C4B91
	for <linux-crypto@vger.kernel.org>; Sat, 17 Oct 2026 08:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.165.39.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792225371; cv=none; b=SIAketqy/N2J+tY70wZs8Cha7SxxD0ddVSS4xFBnlHrBtACk3DGX017ZxU0NA2M+EZrBlODQ30q2rYwfJywoJX6A4r93lcsmAHDvU7lC5A42T2kmnBo/rjlb+ZeBlw0wMn+hb5TYxD7yOy4RSgHadBzsmRg9dlgiP954ADOfF3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792225371; c=relaxed/simple;
	bh=a6c0USjinHB9gathqSBKb8kpDFWWcD9tj1Hs4696W6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nRF4kOenvfreZhGnTnrGmwFX1qJaGBUOSfgypwN4636V3/4PBJccPmuuBB8HT8WTsFyTJQM00ciBSXyx81pRF+YSVclcimynbCouq4ia1nu6CE+y+Lo0iD3msIxT3/4AXiQ0+M1OH/M2ccb4EqAjQOoNidI+iAdIsNp6uDRgPG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cynove.com; spf=pass smtp.mailfrom=cynove.com; dkim=pass (2048-bit key) header.d=cynove.com header.i=@cynove.com header.b=E5bHMSox; arc=none smtp.client-ip=188.165.39.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cynove.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cynove.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cynove.com header.i=@cynove.com header.b="E5bHMSox"
Received: from director1.ghost.mail-out.ovh.net (unknown [10.110.43.44])
	by mo581.mail-out.ovh.net (Postfix) with ESMTP id 4j6F2v66Pwz5xFZ
	for <linux-crypto@vger.kernel.org>; Sat, 17 Oct 2026 08:14:31 +0000 (UTC)
Received: from ghost-submission-7ccd8bbbb6-8mxcr (unknown [10.110.188.109])
	by director1.ghost.mail-out.ovh.net (Postfix) with ESMTPS id DCC9BC0F63;
	Sat, 17 Oct 2026 08:14:29 +0000 (UTC)
Received: from cynove.com ([37.59.142.98])
	by ghost-submission-7ccd8bbbb6-8mxcr with ESMTPSA
	id s5OhLmUu02p31QMAAxIPkA
	(envelope-from <stephane.debusne@cynove.com>); Sat, 17 Oct 2026 08:14:29 +0000
Authentication-Results:garm.ovh; auth=pass (GARM-98R002fd73e086-99a5-4ddc-ad6e-6f59f9efab80,
                    E277A82C44659F51833474C02B8FDD9281845D64) smtp.auth=Stephane.Debusne@cynove.com
X-OVh-ClientIp:176.150.47.247
From: Stephane Debusne <stephane.debusne@cynove.com>
To: changwei.zou@canonical.com
Cc: herbert@gondor.apana.org.au,
	sahil.malhotra@nxp.com,
	sahil.malhotra@oss.nxp.com,
	davem@davemloft.net,
	horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	iuliana.prodan@nxp.com,
	martin.kepplinger-novakovic@ginzinger.com,
	lukas@wunner.de,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Stephane Debusne <stephane.debusne@cynove.com>
Subject: Re: [PATCH v2 2/2] crypto: caam - Use bounce buffer for unaligned RSA destination buffers
Date: Sat, 17 Oct 2026 10:14:17 +0200
Message-ID: <20261017081417.2775186-1-stephane.debusne@cynove.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261004210200.290119-3-changwei.zou@canonical.com>
References: <20261004210200.290119-3-changwei.zou@canonical.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
x-ovh-tracer-id: 3343641252612004827
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: dmFkZTFFWE3bBGPlIBJS3KeuP/5a5zGsiUfnbi/NOsRCn5timlvoAOq9ypHB65ZuJSXxJuiItvlq/xLZ6D/ap2YixEk5F5b4kNEsPQytdBC734i/aO/LcYiQNFsWSrXxb2iX+wKk6Sy7lPsSmpUV94F8jeYOrIib+BY9X94VRQUjlYH8IBaZG4tbYvVPzG4n7NN7jBnH8mf4z5CihVpBmKw82QSJnPrvSqC60vw6WSZ5fWrX5/lXHi1gCDDFmFwctxgaWxI5mRwQuRaDOJkU1JN363DldyPaQtJpIE0DJ6gsS959qWyCvXvbMx8mRzKXchqofVVpC+dOiQvM1D1h/uYs+tinLfonx9UeTwU755U4cF8NeYAIlXqAkmhxPwylaE9N5iNmqkuZ5eWDbNCMVY4B66gWXm3maqxzcjTsOP+Cbv0p5DRcM38Fa4GBtL+9EXbC+Ehcb+87ZIj30vjU4tjiWmbcSsBjI7NIJq1/Dh3QgJBsSyolilMIbax2KZBzDnZMOF6mhAGK3lCqUXZwpwUezA+oU0ruQR1i0wix+R8DVbpfDwkzuXlPUv1+F0P/dDVegAeoD//gtq86HO34hwoduYG9izY0hEMcK2SiF/Q+NuahxnZqbLHnwGBCvLHQ2wnqh3ApFuQHAhPiLtjexxtiQ8uogvpp3vVnEuT6HmcI6oxwlg
DKIM-Signature: a=rsa-sha256; bh=3T5jwtWeKY4gi72mey1zyXo9lO+BeGEiZVaeBu83B1A=;
 c=relaxed/relaxed; d=cynove.com; h=From; s=ovhmo4616632-selector1;
 t=1792224871; v=1;
 b=E5bHMSoxpb+a6g92OX1ITZHoZR6H7+qsSKdtw3LdqYHdv92N7km+Bll0dRuhpe0LtVIJli6t
 S2o2po8VcRqmHPQAaK/uA198zQzf2uIxksS+klms5GbPX/xTTlzpuId7MKgYR8VTOF8JA3JUvFS
 u9XrKm71d/j4IgOADpvo5OODwWJdGabUnYZTGZrKXjSybU7/1pq3XYQG3tLeQA0hq8jWnuzLwKj
 PVjugAKT5MdNCeDdAcbwC2defCnLymb1TDuXIwAC70/3vyEKJ2Bmhlwfflrp4uB/uHIvUsiHyCT
 vNqYqqV1NIf41+rxMYdl464/1E0YP09BiIM+Bo52lllhA==

Hi Changwei,

On i.MX8M Mini (CAAM era 9, non-coherent DMA, no IOMMU in front of the
CAAM), with both patches of this series applied on 6.18.57, rsa-caam
gives correct results again for callers whose destination buffer
shares a cache line with the request context:

- cfg80211 loads regulatory.db, which was rejected before;
- keyctl padd accepts a valid self-signed certificate, and
  keyctl pkey_verify accepts 20 valid signatures (both failed with
  EINVAL before);
- a test module comparing rsa-caam with rsa-generic over 200 public-key
  operations per case (2048-bit key) reports no wrong result in any
  case, including a destination placed right after the request context
  (in place or not), crypto_akcipher_sync_encrypt() and
  pkcs1(rsa-caam,sha256) verification. Without the series, these cases
  failed in 198 to 200 of 200 operations, with bytes 0 to 23 of the
  output holding stale data.

Only the public-key path was exercised. The requests did not use
CRYPTO_TFM_REQ_MAY_BACKLOG, so the crypto-engine path fixed by patch 1
was not reached.

Tested-by: Stephane Debusne <stephane.debusne@cynove.com>

I posted a series that addresses the same corruption on the caller
side, in crypto_akcipher_sync_prep() and rsassa_pkcs1_verify(), which
build these unaligned buffers:
https://lore.kernel.org/linux-crypto/20261016090333.2247764-1-stephane.debusne@cynove.com/
The two approaches are complementary: with my series, the buffers from
these two callers are aligned and need no bounce, while your patch
covers any other caller.

Thanks,
Stephane

