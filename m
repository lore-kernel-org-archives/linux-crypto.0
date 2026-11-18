Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794985237;
	b=TXXDF5lEe06sIKrBmn5N9LtxFz4nIS5PsN1DxBYG4n9awSod6eg0k9cR9VAmHOOAR+MI
	 8FFSleavW4KtsBCyJ1luVuxfN7pIPvqci1Wm//D6o6+tBP5obEEPelJVk1NWs4Fa3YsGZ
	 UPC8MSwzmncrlc/FpaD+/ALQ7fqN0xmQb+9GCLveKNLL487yZ0RNjgnc+JZSqEHzAFlZQ
	 Gaxcdc0qyqE88oasFuNTt9bydgWkTY2jzHJDgm1LsETzru4gnuLeF8K1yexnGwHJCuqZ6
	 YBVm/XnI3hcF6P6f8aCpCM3h56tpVOTLHEt0L/Xo4Tu0Tdj4CIT4F5QeixGn9hZMnaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794985237;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:
	 Subject:Date:Message-Id:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=lmQuX0S5Uv7E6e/YfcFegvaf4/mz5xAzkdHo6Nu6EUM=;
	b=aIh0yFH4BKHQnQ69tpbLOBCO4W6F0N3SHyXFQth7FUZynoVNXjoFJVGHWjLp32ymvonp
	 p7UNXSo/XTZrOiA3Q+8XiDZfAEMBKC5p48jOHPkd+PUcuRU2ZBnLPEn/rtDN+8CYH2vcI
	 3koSQwybXzj8FYARjXsaxxEx6LdTSQPydEdtfYO1iKlg07tD5W5XIGdpFLmOyGCz6tIgc
	 MMZS2zurpKoUZYr/5sDo/nsdMIUzvxgjrJ2YDz/VDqr/K74Mg4PCfUOCr+CgX+pqT7lbr
	 fvORa48khB8eF72IV8Gk+AJ9NtN9UJy34IVEQxkKAMY+xIEyfmLpa7pmpfFMeq5oaVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="e25Sv8/s";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=PSej8zOO;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2FBD606A881
	for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 07:00:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F2FBD606A881
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=e25Sv8/s;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=PSej8zOO
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AI2V1CT1430592
	for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 07:00:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=lmQuX0S5Uv7E6e/YfcFegv
	af4/mz5xAzkdHo6Nu6EUM=; b=e25Sv8/sUS15LHN4PzaVv+Ta3HHyPsfw26WWaU
	U0B1UimwK/jCylHBbX8P5EYaX57MdM3Nh75b69uDsFcGbyBdI6+CeKbIAs5HP5h4
	QEj66tRs/GVnmfvHDIaVoEWyX+biEgsXi3gzELjs9k/310+XjOhUiiT8hNvu27aH
	BJPJW2258UD9AFSGRfNRHzfE+MEdqoi/wwTyQbpJ/SbdYWrdc9odaC1n70hVZrgm
	pHefravj6SRyYb/6YQhID53X4iqzT7Ql6yvnkcx52aQyM/WP5A+FwvdK+c4sqe4l
	hNSDeew2pr6NWXD2YTcUAWwrKZ7Glj9vu50HGIXFZrTNtyow==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j0yv91q15-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 07:00:35 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3ad704d4760so637899a91.3
        for <linux-crypto@vger.kernel.org>; Tue, 17 Nov 2026 23:00:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794985234; x=1795590034; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=lmQuX0S5Uv7E6e/YfcFegvaf4/mz5xAzkdHo6Nu6EUM=;
        b=PSej8zOOdHKXlutB2VHAXHqne2aF3gFDAv4+3wTivP82iKYHFO23q/aAjA9eAPLN/W
         4+p9G9nEvAi2wRD8ffAf8EL8/A6NYVwVzGl9tjVMhzqdw0ruRp6SIklB7AydfvO8RUZW
         0My13XstM6dUt904HjN4kzDU8BP4zZ43TDSFarJ5tMLe1UK/nuNrvS9a5Fn2naQ8pTLx
         lsYaxQ6D4feCpf6pjlTqPc+WHpr07YiAWee7XfPaSBfdPOHffLAU3T3AYc3KTBUWhCup
         DpaxtLFDjX0I4QhTXiPkdPmXdb9KT4FAYh3pujSRzbGMBPnNkiUEpkRSRdfT+FFP9FqG
         D8sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794985234; x=1795590034;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=lmQuX0S5Uv7E6e/YfcFegvaf4/mz5xAzkdHo6Nu6EUM=;
        b=TkjeLyjUs9b1RM1dineE0uml+lf6Au1AfqVvFPI9NMous3DvEVExkI00DX4+xFST8b
         iGXRckezpvk9fIgPgaaoZLDFD2IVNyhMJv+61PAs8EdOc8Zv82JlHsPooeJTARAxS6Zs
         5dT8OK2XY33C9OzJgAmsoYUsxfbalQ+iuZqcgd2O2mOePRoa/HVhIwc92GgkxHDO6XSI
         ruHTiw7UDML3BIO4KJBILADLGk0V8auxqLp5zztabN1NqkilVEfjRl4ujBJKqLwtL8bp
         /VkYl4AJMNvDhqsNs3r8BbE6jwO2FOKtNDIhbaRnlJokDrJFgazdW/u4Q8mnZue/B5nu
         OFDA==
X-Forwarded-Encrypted: i=1; AL+hErEC8XUB9mFLHD2zkebQOO+tJZbnLNnQUxDYEG6483uUQU0fXOUIJqI/Dz0GeVmqQArYyn4Y9HjqaLv1NNQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z+4A7LfSSPW0Pgv6B5eMSXp40F8NopaAGpHPZTQnOqNmesNlx9A
	no/PmO/lERibt5W2oj4WkOJQiD9stF4Vr2sNrxvWqgp3ZNwGGxQQnvHJC2+h7B7w2ZyJGFZP32C
	nV/7yRnAY+LyZvdcY+pimCMGQ+SN0Z/vLU5VQt5aKGp2hkgWUOY/KH+CFnjdPvEU1Ir0=
X-Gm-Gg: AZFdTZcs6pk+b2dC+dcgN6aVOf72bdO+LK5hGSUG2D3a4If5eQXCORgOYjpqiCPIoTa
	gsxd9Qq1DBpCVVRBeSI+9QeFWEEjEe+9UpyCBVjG2Ki+aZLgxG4AEwPStgyakQmsZsT7CsewaqZ
	zgihl1hhwQgkUYubvjMTh+CWOixQrKxXO4Helmj7FxIa2eZjtEijpcR2wZZBqPe6bh47rdVHuP9
	2x+zBwlONZWl5xOxkQGBoYINbPaWKgCDE8LLhOT/z0/9s35A4Aae1fPh4ucKvFfoLSfcRgLnvGD
	CeS7iYgfaqXVe79FObWadouRm7QtQYJ147Lhmb+8ei3gMgwXhl71UXYkV2ZhGezS63leQ9Wy4jt
	kGCYZpmvBIezXEDk4TXqbHXCuUZ4tjaGy4SV7GVuowPbK+dwOznqduUZ8ctwfQJ7FExcA64yCA0
	YJ1NsEcs6z909VXJ42I7J4pWR3RMN7jJiX4HtFkwfSj/oJUg==
X-Received: by 2002:a17:90a:d445:b0:3ac:8897:7bab with SMTP id 98e67ed59e1d1-3b3d0686792mr1597887a91.6.1794985234311;
        Tue, 17 Nov 2026 23:00:34 -0800 (PST)
X-Received: by 2002:a17:90a:d445:b0:3ac:8897:7bab with SMTP id 98e67ed59e1d1-3b3d0686792mr1597843a91.6.1794985233657;
        Tue, 17 Nov 2026 23:00:33 -0800 (PST)
Received: from cse-cd04-lnx.ap.qualcomm.com (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3d1acd118sm2743262a91.12.2026.11.17.23.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 23:00:32 -0800 (PST)
From: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
Subject: [PATCH 0/2] Enable ICE for UFS on Qualcomm Glymur
Date: Wed, 18 Nov 2026 15:00:05 +0800
Message-Id: <20261118-glymur_ufs_ice-v1-0-2ffe4bb931a6@oss.qualcomm.com>
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
X-B4-Tracking: v=1; b=H4sIAPZM/WoC/y3Py2rDMBCF4VcxWtegkUa3vEoJQZeZWFA7qWyXh
 pB3j5p0+S/Ox8xdrNQqreIw3EWjn7rWy9IDPgaRp7icaaylt1BSWQBw4/nrNu/ttPN6qplGRhu
 4cGbts+ijayOuvy/w89g7xZXG1OKSpz8mMieTODmvIdmgNGjJwJ4SZgOupKhsieD/qUbfez9pe
 3tvLF/muW6HwWGIWEg7iTKgxczeSKBskkIDhdFkj919UXHLU/+kr5JUJVjjdNRQVHDWFJYstXM
 cg8aYyAWSRhwfjyefc5s8HQEAAA==
X-Change-ID: 20261117-glymur_ufs_ice-f469fdfcf38c
To: Abel Vesa <abelvesa@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org,
        Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794985229; l=1690;
 i=wenjia.zhang@oss.qualcomm.com; s=20250717; h=from:subject:message-id;
 bh=JkrUQ7vs/+xT3FOApCQ0TNe2+J3ILw4dg4vIRYpSV3Y=;
 b=eFoVvKqUdP/Y4AZC0DhvXeRgJ+VNuik8ESqOgl99WBzdw6EkBOgHwcppGevFIqb0B7xN8oJaM
 IbNexbum2SgBvbWRAbPNtBGnphKnIdghrEQjnGhZ8hKPcPra49FVEEa
X-Developer-Key: i=wenjia.zhang@oss.qualcomm.com; a=ed25519;
 pk=Of53/+6KgVgPh1R/xUMTbXVCnBiHTmHby8ySh2ShLtw=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE4MDAyNyBTYWx0ZWRfX82C0A9eGfIRU
 N+rm9lHamN32oJfdH9hBiPphsqBh+0r0rgu6iYPntjYSpo2F+4+/Yd6KnXt2HeZOVLPSAUcmfdQ
 sRriJF/AgdWQ/neoPfLd6gEfwa2kjWOrK1juaMpjHM7AOJphH5RD2jaV7M+jaQt5IFL2uRkFnkv
 WK5r8YbTA1Vwp8P5Rw+3J+4UtHa80frjU3dD1fI5f4Kp7046znI8llcCktVPL6vxwJWx131J7wM
 N5f8Ul8WJ1/MzsX3YwNiNQrCmkHl1+yrs7yNctjTONOWG4Cpor1CQ/n6YNtN3iJwZ3faSx1pQvK
 jVCRLTm1rcR/GONrMpzaXuj4rE2n7U1rxT7yYJoqP/5Ix30Og38v2zitvcR8DDyUBbFtcJGbc+P
 FuHY57FSrHyKczj6ol1+FUPWKGwyTPp2FUrUaDOrWUqZVaNM56x3O2zAs8wCentKebQoXqc/A4F
 uwURhwVO80U6p4+1FGw==
X-Proofpoint-GUID: IQtZfr73wHfaczMe3V0F_JTwxnoLeMzM
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE4MDAyNyBTYWx0ZWRfX6b/LiBURGYZX
 NG+CilRBrhbgTaKtpruiTCaX+iHUeHnHUVBtx5/Mf6hw40PZ6B2cWMGbUdsBnzDyzH1Hrv+A58E
 EBkeaKni/4R6K+fkTf8cng9AfTGiWhU=
X-Authority-Analysis: v=2.4 cv=LuQHWXdc c=1 sm=1 tr=0 ts=6afd4d13 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=knTtAJwehH_nPzmuHUMA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: IQtZfr73wHfaczMe3V0F_JTwxnoLeMzM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-18_01,2026-11-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 malwarescore=0 suspectscore=0 clxscore=1011
 adultscore=0 lowpriorityscore=0 spamscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611180027

This series enables the Inline Crypto Engine (ICE) for UFS storage
on the Qualcomm Glymur platform, including the Glymur QCB board.

The hardware reports ICE v4.0.3 with Hardware Key Manager (HWKM) v2.

Patch 1 documents the Glymur ICE compatible string. 
Patch 2 adds the ICE node with its registers, clocks and power domain,
and connects the UFS host controller to ICE through the qcom,ice phandle.

Dependencies:
Patch 2 requires the UFS nodes added by patch 1/3 ("arm64: dts: qcom: glymur: Add UFS nodes")
from the Glymur UFS support series [1]. Its patch ID is recorded as a prerequisite below.
Board-level UFS operation also requires the QCB enablement and PHY support from that series.

Validation:
- Observed ICE v4.0.3 and HWKM v2 during probe.
- Standard-key and wrapped-key tests passed
- checkpatch --strict --no-signoff: no errors, warnings or checks.
- Targeted ICE DT binding validation passed.
- Glymur QCB DTB compilation passed.

Prerequisite:
[1] https://lore.kernel.org/all/20261028-glymur_ufs_qcb_enablement-v5-0-09cda5e3bab3@oss.qualcomm.com/

---
Wenjia Zhang (2):
      dt-bindings: crypto: qcom,inline-crypto-engine: Add Glymur support
      arm64: dts: qcom: glymur: Add ICE node for UFS inline encryption

 .../bindings/crypto/qcom,inline-crypto-engine.yaml          |  1 +
 arch/arm64/boot/dts/qcom/glymur.dtsi                        | 13 +++++++++++++
 2 files changed, 14 insertions(+)
---
base-commit: 749a4de370409464cf8501ec5b2451df45c84eb4
change-id: 20261117-glymur_ufs_ice-f469fdfcf38c
prerequisite-patch-id: 7b02d96573a31d29765df0f0377fa934abe79e05

Best regards,
-- 
Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>

