Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794993023;
	b=oe1IwAGThgJP9eyfo5OiER8XLNlT48H6kOlv2I19hGAmn9GrWgi8uXF4M0ah01fiQNz7
	 dwOGu6Ymsbp+U7K2I3SDULA8z426zvM01fiz02Tq9MMzownLyY9E0xcjMomd4edxgFl/2
	 qbQEbwZHrDMKsiGwtmAAGXlNutE7BX6hx8c6FRcp64kDezyCj2bbj0I4wswqlzhrT2C7S
	 8D4vRixPiY1YljoRqdD9EkeuukWh2Gnxe/ETW6Atpbje0yqcElV1A5liqaXe38eLy3t1I
	 yIA5tIzECpVjEYShD3sNlIH8uLDclSsHQ0B2Nzf2+ItH7gSch3jnYzTqktm0dpgue4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794993023;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:
	 Subject:Date:Message-Id:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=hqJRXOoxftCGEgfPf5VGXFGD5TQ3O48MegfhSwXB6ss=;
	b=2CfceFR7QNn05330OeVFBu+dtfxLwn8t95H5q/iUy/xrm+BEZcolGHr26PWJ/XT2lL4x
	 XXuN7FIv7cLECss6My8eahSgOK4eVHhi4paDJUQkfSsC46N1W4f2rdgPVPJB7VAsqQn5S
	 l1MwdqXo4jnBjeLr5xjtCue63w+L0DpzyY3Z/S2139SaAPIIlJKGe5brfDD7PNaNHwyfG
	 FHySHKziFfGrWCPMxdwzrgK6gV5klQ54dbmsoux0b+xDkSzIs45cOhaGDloxZk5nYbL5m
	 5hQK9QECRzN3yTba1HrmpMEBzDCbvfX4eQrUkzmgw10fKGGX2Fpun4BuuaCBHBLcNWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=RTmHxQi8;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=UZmeOI66;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390D9606A339
	for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 09:10:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 390D9606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=RTmHxQi8;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=UZmeOI66
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AI8cnug472838
	for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 09:10:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=hqJRXOoxftCGEgfPf5VGXF
	GD5TQ3O48MegfhSwXB6ss=; b=RTmHxQi8Kza8pVe54yjmXH9nA6j8MoyI4Udi+5
	LMzXCxnVA+HcCS75/MImmEYnsEm5Bw53srLNPSiBr9nNSuuqqs2/WSFfbBz7LQdH
	vzCpBwtv6e5jyyfNWbtUPyK0SyfL1XkPQFgOC91TV+suDhM8BhJtLVv9Gd/1hdFi
	MkWJ02XpDHd4L81NUOCCN6vRBtN3cIEEYwyifxL5jXxlTPjfGmBtDZ+Ch28AzIzs
	Xz1MxwxiqykzzYhpmRkXTztTjhoay2gjp3KBgaods1/xh2mwHk6oREvwoJ040kGW
	MO+Fq6orkqemA3d6pStiIoY2Thie2umh11OdcNXXdGjVjSMQ==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j0yv8a6aw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 09:10:21 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2e94f72fb9fso7236885ad.1
        for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 01:10:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794993021; x=1795597821; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=hqJRXOoxftCGEgfPf5VGXFGD5TQ3O48MegfhSwXB6ss=;
        b=UZmeOI66gXreArr7IYk4xOUk0TO879DmhjrhC8luGtj1wOtwFPj7ECfPhXsYuAaqsS
         rxD5HVCUNYY0Cr4BpHnPhM+xEGtOOrjYNLGW3NjOzp5qx08bbrBa1C9sX6MVPq4G5jA7
         iHpk0mQhgeHGdH2nv76Ps3ZQE6SaCFK8T/pZ5WHdYoi7v/4osyVOUeHdL70+8uuTUC8H
         08AfzIE69qoEDPfh7kpZHU7K55kVgrvtlhUfYOuLIN4p4rdNlX2B22kILtqdY9vAxocG
         4CUTvm1M6cAc/eQf47JM/OsrdUzBUHPzmFNOMTb+vIS8qW+oiWq1SI9hk3VUGYwvfM20
         B9oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794993021; x=1795597821;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=hqJRXOoxftCGEgfPf5VGXFGD5TQ3O48MegfhSwXB6ss=;
        b=m1YYLo/3VXkkrM20IyA9i38lYPxvbZ3l9JQsuI840fnc3gfR4FuxHwWbOyObzwhm4m
         LIdNS0sYV3NrpvBQ3SeKAvZimnUWvue4UZWfuFEapQ0dYN+u1Tc9g4nS6l6fGhKdqnh7
         1NwxC4fUOlo9RWptsKh5vPY8lGgX/5j01Fs5qC8lktYgVBBQ0jcNC9r/ng4fqU+cHlxH
         8oTFpJer93WDhcI5GVj+FzHVsksO8891bP886pGHgS/FXzR4WJA0lfYbVSACkr5El4l0
         Ofh1adSZQfsOXlmJZsc36JJMQCDP7G2xFegOGDJ8onmhe/3cxsTJ57PNVZDKMpmDefKs
         UNGQ==
X-Forwarded-Encrypted: i=1; AL+hErF84t6mXgUWNOMc+q2P1M3GSH4CnwaRfOPtaR/HVrkc4dR7Ik++PAfw3RVdbhnRtOx86+qY+N5QlJb1Hu0=@vger.kernel.org
X-Gm-Message-State: APuU4Z96p1DNgbcA8F7UE5NUqPoIdvbb41vfpkLfxPslqHTXDx+y3Uom
	onIx2fTqOJCMMQjGLyQHf/au1/HhRjZYMSpw/4ZpUzDYlcTwl9OABp10+RX1d1sv3SCjJiBsq6o
	Qv9Ae4HLsrMwqfBCq4echvvitNnhrwzA8Y8vbJmvx2ba5UxRgBrNh6/51hKJRv/3CdH8=
X-Gm-Gg: AZFdTZddH6qS0w2jDLyPQpYQpOSnPALXAav5R0d1vbaQRdf5jKdKO44L8zVyJb5Z+Ge
	28Mn9G0Pss7Yh/krfGNqCd1o5MPTkDx80QZP2NvRNGnZ0z+HIjH85hC+ErgccgpfcQz4/rAuwiC
	Fb+CGqTNtLgTagXxyHe4Zk+ytLYioUJ/nAWxXpNp0ZsZMfQ8U5vMBFkstbHiw0An4h5jN5wOY68
	j+iFQEgRwhgIUUQRRSObwb+qbJ/g6i4UxxKj1QZTmG1N8IBemWe5XOpI+8j+OVtlemQDbz2Vns6
	ifvY5rg+81NheDU/f9BmkZ9Fx7JmIO96nr/oCGGXvsOZ+Dkf5uuF5ztvBAUASge352c3mUQ+VgA
	5noChlvf7frKoDB+zXjw95FHc5ZhRvPIXR75y2YOqzxAPd7Hmm2hzEBe2Poys2jf0Qw5fU1J1CG
	f9kvPku9TQJzD2aeZnUwmjU+QHQDTz5Jj9L+v0aEcDuSFwUQ==
X-Received: by 2002:a17:902:f687:b0:2ed:29a5:7828 with SMTP id d9443c01a7336-2eff72f1016mr20317045ad.11.1794993020876;
        Wed, 18 Nov 2026 01:10:20 -0800 (PST)
X-Received: by 2002:a17:902:f687:b0:2ed:29a5:7828 with SMTP id d9443c01a7336-2eff72f1016mr20316835ad.11.1794993020437;
        Wed, 18 Nov 2026 01:10:20 -0800 (PST)
Received: from cse-cd04-lnx.ap.qualcomm.com (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eff62e1295sm10147735ad.71.2026.11.18.01.10.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 01:10:19 -0800 (PST)
From: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
Subject: [PATCH v2 0/2] Enable ICE for UFS on Qualcomm Glymur
Date: Wed, 18 Nov 2026 17:08:52 +0800
Message-Id: <20261118-glymur_ufs_ice-v2-0-7ef4556eea15@oss.qualcomm.com>
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
X-B4-Tracking: v=1; b=H4sIACRr/WoC/12OQQrCMBBFryJZG2mSOm1deQ8pJZnO2IBtNbFFk
 d7dKIrgZuAN/Md7iEjBUxS71UMEmn3045BAr1cCOzscSfo2sdCZBqVUIY+nez+FZuLYeCTJOVT
 cMrIpUaTRORD721t4qBM7G0m6YAfsXpoC2XFRIQCCoTIryOZbbR1n2xwIGFoojbHwUQW6TCnp+
 vN1Pl7HcH/3zur1/aaV/2mzkpnUzJQ7VxllYT/GuLlM9oRj32/SEfWyLE+wNEALAwEAAA==
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794993016; l=1435;
 i=wenjia.zhang@oss.qualcomm.com; s=20250717; h=from:subject:message-id;
 bh=HD5BWujXmzSaC5arEux6XMyih3/IQEomEjheza/5lOI=;
 b=Bybijm/RVYoSy41N9ZP1x8T9/D/ZxiZ44CI5ahXO3ZFbgDELjR5XpIZxoAgPCicSTpe7XnE5F
 Whzg90+soPnCP6TQCIcrswbHD30Q/AcqO5dFG2EVAZPI8ASAIDb3vrM
X-Developer-Key: i=wenjia.zhang@oss.qualcomm.com; a=ed25519;
 pk=Of53/+6KgVgPh1R/xUMTbXVCnBiHTmHby8ySh2ShLtw=
X-Proofpoint-ORIG-GUID: FTGM8xwIHA8SDogd91dvX39VeZyVefR6
X-Authority-Analysis: v=2.4 cv=N9u8hG9B c=1 sm=1 tr=0 ts=6afd6b7e cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=r359bwwMCglhQnJRRFIA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE4MDAzNiBTYWx0ZWRfX6097YM9kkuLP
 wjTg7auKpnLXIwAVWp8mG6XuNhK2zr77E/I6U5UIri1rxz673hjpOChralfKhF6aDiej7YK2GYR
 7Et22ssPPcyEfXaytoUfeuF5AW0H1vLjR/jtwicqVYQ3D1LXP8CNCh6SBgRG4gzmgSWqIHejDnm
 erD/bD/c1ZZURg2IYIvEj0huY3ehCTNAth65Jy1bnppXT1Kmiv0xLNEsJpYE9zhjAvCKMRJwK9u
 rby7J6YuoZiOxYuyHMlDh48rnSfnGQMl1lysHkZv1/sHz/0zppS1JWPik5bd3LF/QzIgeFYGNcN
 2PFqg44tyy50/RJjyXgu3dOdkakjAZTjEyk6knai/B8yvWIkCMga7oqcChF7xX+LpDziprgZmY+
 0f9qip+JtWXYtenqoxoATi9103deGFpIuZdkKecPvLgdt/cgA5si7oJ8YEGawHQ4vpoEo48mozi
 KuY4fNupHLVNJppSHEA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE4MDAzNiBTYWx0ZWRfX4SEcmE0FexHG
 N/Gtf4GTAjyOEchTBVm2a4/eN+vJ0DiqlF6fEpRzOi/sob8M5+q7hCtjE9ElUEudfPY78HIfS7O
 IiWsqaO4V3bPd1rJvTKsXfYqzTPdm9A=
X-Proofpoint-GUID: FTGM8xwIHA8SDogd91dvX39VeZyVefR6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-18_01,2026-11-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 phishscore=0 suspectscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 bulkscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611180036

This series enables the Inline Crypto Engine (ICE) for UFS storage
on the Qualcomm Glymur platform, including the Glymur QCB board.

The hardware reports ICE v4.0.3 with Hardware Key Manager (HWKM) v2.

Patch 1 documents the Glymur ICE compatible string.
Patch 2 adds the ICE node with its registers, clocks and power domain,
and connects the UFS host controller to ICE through the qcom,ice phandle.

Validation:
- Observed ICE v4.0.3 and HWKM v2 during probe.
- Standard-key and wrapped-key tests passed
- checkpatch --strict --no-signoff: no errors, warnings or checks.
- Targeted ICE DT binding validation passed.
- Glymur QCB DTB compilation passed.

---
Changes in v2:
- Rebased on next-20261117 (7cfbf79c66c6).
- Removed the prerequisite metadata and dependency sections.
- Link to v1: https://lore.kernel.org/r/20261118-glymur_ufs_ice-v1-0-2ffe4bb931a6@oss.qualcomm.com

---
Wenjia Zhang (2):
      dt-bindings: crypto: qcom,inline-crypto-engine: Add Glymur support
      arm64: dts: qcom: glymur: Add ICE node for UFS inline encryption

 .../bindings/crypto/qcom,inline-crypto-engine.yaml          |  1 +
 arch/arm64/boot/dts/qcom/glymur.dtsi                        | 13 +++++++++++++
 2 files changed, 14 insertions(+)
---
base-commit: 7cfbf79c66c63e807ea452abf0546e6f6d6833a6
change-id: 20261117-glymur_ufs_ice-f469fdfcf38c

Best regards,
-- 
Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>

