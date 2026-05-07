Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8406837186E
	for <linux-crypto@vger.kernel.org>; Thu,  7 May 2026 11:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778153101; cv=none; b=u8plL0bOKzkUcw9cexd52VS9Id74fTjeOXTgJAITlsy8YPxtRXIIPza/cU87PONTnTr81xfQ67rq5bxAHaElHckK1NTaBGPMyKGF8WrUeR9nUtQcH8DfovDd3inVfqhNqKtymCrNcEudnvNO7g93mwriey8anOxZy0m+mwq3Qho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778153101; c=relaxed/simple;
	bh=osXmgGSxSrKx3zpZtjMg9bkFc0mOhov0B774lUtqcLw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=JcORCY41mgM7WIWocX5XMoFK/RXZCMPAi6bT0lv46P53C4Y62iBko10Sule+Onqw62OOtVFnQ1IDnFoMhTqnNE0GZVgQQUdbbV4q2/hGUj9/LCg2y9NT+uq/LRtMzwsEF0L8ZAQL0L1+XtWVNOYCOG5CUi9DxysqRer2n/z2nJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bVBo+74y; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JAIT18OT; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bVBo+74y";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JAIT18OT"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6475LvAa682839
	for <linux-crypto@vger.kernel.org>; Thu, 7 May 2026 11:25:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=TnhnLrL/izdip9S/qBfDLn
	OxhSE7toF4Nmjgx76c9jA=; b=bVBo+74yzjol/N510ibPK6L9Iu1PqEfY4Vpfum
	WYOAlMs/Y1HPcVMlGKb2o40CYKgDbk75liOoc8HTpng9qTOP+ag3To0vwpordzBQ
	zLkaVErp3conl/M8+ZNDstccOF25q1S9QdMj5T5Y6y4YYBelY3F4/sDNvzaKulPw
	34ebKqt0Rp7D6E1AucdV4AvmTEMfFBBpbPE1SZk0IExdcgwLzJ8UG3lvRwlZSDVr
	tnB7HkXv9rocQRv1R8F1GL2y6Aexikx5Fin+PGSq2COOmR6CB8CMmARzoSMXBdTv
	yefJkvghXLMtdN6hswKmFhx2QEOrS9jO7GQ0g/JHTyvg2BWA==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e0mhasamx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 07 May 2026 11:24:59 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-2ba9a744f7dso878710eec.0
        for <linux-crypto@vger.kernel.org>; Thu, 07 May 2026 04:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778153099; x=1778757899; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TnhnLrL/izdip9S/qBfDLnOxhSE7toF4Nmjgx76c9jA=;
        b=JAIT18OTh0ZN1gzIM0G1n48ua+4Dghhq+l59pg/xh+AY/x/l2iKx5SzZyBLLjr36iF
         52Yr0c5JnP8gLXwnJ7GXKNY0+ncr/AWRe8lEJZQk848GaOLA6s4SMOfP58ksJ8rKTOa6
         bLm7OwJ8SBYwIF4/92FCZl8YUZWtYxMuonNh9ZxI3RKm9PjSHzeajZBz3y4kQ5LFVVwu
         oN3JHQVU1Yt5vfzlYLPR2MysVnFoMw6Jb56K9mvUpCwfT2ALN6LoV3pd8fR9mEFLjH+V
         HcjKEBVD5VbI7VqjjXzJUOi5St+Ont5HSFzVDJvxalKtVTVZC4HBXdenZDtAQfV36x8h
         a0xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778153099; x=1778757899;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TnhnLrL/izdip9S/qBfDLnOxhSE7toF4Nmjgx76c9jA=;
        b=GP9hkuBtHq0vIvtg8ot+SQDRd1E42rCjNaQXkBG3Ty5lvfGw+kCkNZwJ/qPeLNpruo
         +xNOE9Y2e/LPrHbk2CVQWZOoV7w68jXUcMZOp2cFqtR3XyzxtBfFLlXMLmlwlhAa1san
         foRlHYtN2w5tOtfdJjOIglLsOprX/4GzcFPwMWwcah2Ekp9OU1FSUjpKh5yatBaszDsp
         WgN2D1C4y7wbhy/psTp/T2qFC87CChRE+RVY8ddjS81jf7ZcqM1W1ELvzDO5sSdeIYMw
         zP4Xbmp79nnpIMx7HI+NZs8gutInVbb5kUU3NPh91oNjAe1OoiNmNhYfmvIi2gjRUtym
         BTSQ==
X-Forwarded-Encrypted: i=1; AFNElJ/QKnZHI81brMWGOqdyU+cHvfvSbTRBTDIvStCrGvzg2RWGYCoGuUAK0OuCz1RN5SgKW+heGryFjXtzEi4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyaHAUgMvGJrzaAmP9k7E14Bd8g4KE133fiyRxDM4qJSsUkNISZ
	B3QLlYjrB/S/Dp16eJbhpIyThc+VPLprsdNL3ZEXg/kY6QlqHiRd4hCumqfgd9SyjUQH81JcS4Z
	X7t12upGz2xavdwvTiEsiUZEgMci3D5xA3nfD4YF/S3eVeTM6jyeOvgN7g4H9rvCKrHM=
X-Gm-Gg: AeBDiet6KCKz42Xxa3yT1UWesX2fqAEUBjHNUMd6JMuBNKkCm2qXnC1EorWXb3/ns/K
	849aNgdaaV0GQGjrgTow7vSucYb4jZxTGBOElRrF0DAqTI51zinY68DDMnPhtB+Xvsmg/nMzK/C
	sHBfqRbx/+6PI2GyuYEDAkzV8A02R8ORQvX28ZwOJnG0Y/0R5DDkumX5eM+B4ZXuUXmrmXWO0OT
	G91vwO3g83+hdDp5rgtrV/ApLVrdmN3xecQjvL7W2xYUg2RIUWeu5e5O96BpV940LzWincNwxTJ
	cZJl/sfCIxDa7Ad6KK0MzXwt8PWjd8DfYCrsCHcwh/qE2pvGE0C0qun9nMzTn5cldZl32AinmXJ
	sNUx4TM9tP2lPKuODlXZuz0gG2DuAvdemC8dpHJgncX/niUdCzGbu08ooRcIHba3woFl5wt55hf
	twHY38FvRwAAvKEr7/AOC/5clI5w==
X-Received: by 2002:a05:7300:818d:b0:2df:7882:1ce0 with SMTP id 5a478bee46e88-2f54b364cd2mr3581689eec.29.1778153098695;
        Thu, 07 May 2026 04:24:58 -0700 (PDT)
X-Received: by 2002:a05:7300:818d:b0:2df:7882:1ce0 with SMTP id 5a478bee46e88-2f54b364cd2mr3581668eec.29.1778153098149;
        Thu, 07 May 2026 04:24:58 -0700 (PDT)
Received: from u20-san1p10573.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2f56cec592asm8151115eec.5.2026.05.07.04.24.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 04:24:57 -0700 (PDT)
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
To: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Bjorn Andersson <andersson@kernel.org>, devicetree@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] soc: qcom: ice: Enable firmware managed resource
Date: Thu,  7 May 2026 04:24:52 -0700
Message-Id: <20260507112454.2527088-1-linlin.zhang@oss.qualcomm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA3MDExMyBTYWx0ZWRfXyKUa79i/xv94
 pPdTTtE6nAjlzD7o8wApk+beuND6xgmDdlOGcl4awXY+atvSiUBnh4F5iRnHUO45rw5BpnBPmLe
 QtPstrSs/UVkbNqNddp5vzioKD/p6Uf6BNNFfEN/1smS9ymqjlXg4rN4SWt//NJpw8/RddSHu7O
 +dZktAEsBzbWRcT0TfyZy0cHoV3uWVNuAzFYpi5pd4fWbgmtIH/MjngoCQ/BR86H+eVjE3kq8ox
 eG/m5LjCahXQWVlX1e1BheLjqmItJKAdGs6YXM84A1XdSD//5FhF0NluyX/Erwpmov31yvKqIOq
 BdBp/oO1nlckpQaKP7UTaN5fJ5/SRfZMW1KJ+PYqBY3WXUcr3QuFKIlN63yJJjv0trYVTrplaIe
 kZ/psZtu3xHll2d4offrvqxEzg3aWv7oAoZ2vfQkJeEKkThzzF595SjAgDNZKUViKCAP8nBCwg9
 LfeoRtG41p/R2RQr4+w==
X-Proofpoint-ORIG-GUID: MApFhFYfnzjqVPlhrmtB8vKlbIM6p29m
X-Proofpoint-GUID: MApFhFYfnzjqVPlhrmtB8vKlbIM6p29m
X-Authority-Analysis: v=2.4 cv=ReWgzVtv c=1 sm=1 tr=0 ts=69fc768b cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=COk6AnOGAAAA:8 a=Jyhv0Gfyiw9a8mKZ3MwA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=s5zKW874KtQA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-06_02,2026-05-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 spamscore=0 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2605070113

From: linlzhan <linlzhan@qti.qualcomm.com>

The Qualcomm automotive SA8255p SoC relies on firmware to configure
platform resources, including clocks, interconnects and TLMM (GPIOs).
These resources are controlled by the driver via SCMI power and
performance protocols.

The SCMI power protocol is used to enable and disable platform
resources, including clocks, interconnect paths, and TLMM, by mapping
resource state transitions to the runtime PM framework’s
resume/suspend callbacks.

In this design, the ICE driver acts as an SCMI client, with clocks and
power domains abstracted and controlled by the SCMI server in firmware.
This implementation depends on pm_runtime_resume_and_get() and
pm_runtime_put_sync(), which are available in the OPP tree’s
linux-next branch.

v2:
-- rebase the patchset
-- update to/cc lists
-- Link to v1: https://lore.kernel.org/all/20260430032136.3058773-1-linlin.zhang@oss.qualcomm.com/

-- To Linux Community

v6:
- Protect calling clock API with fw_managed flag in ICE runtime OPS callbacks.
- Link to v5: http://shc-kerarch-hyd:8080/kernel_archive/20260324095703.1306437-1-linlin.zhang@oss.qualcomm.com/T/#t

v5:
- Align the continued argument line under the first argument after left parenthesis.
- Modify the return value in probe function.
- Link to v4: http://shc-kerarch-hyd:8080/kernel_archive/20260318170626.3654744-1-linlin.zhang@oss.qualcomm.com/T/

v4:
- Commit and signed-off by OSS mail id
- Enable runtime PM for ICE dirver
- Add driver data to diffrenciate the clock managed by the firmware or not
- Link to v3: http://shc-kerarch-hyd:8080/kernel_archive/20251107091315.476074-1-quic_linlzhan@quicinc.com/

v3:
- Update the subject of patch 2.
- Update returned type of remvoe function and firmware flag in ICE diver.
- Link to v2: http://shc-kerarch-hyd:8080/kernel_archive/20251104104935.2752144-1-quic_linlzhan@quicinc.com/T/#t

v2:
- Addresssed comments from Badgey
- Make Document binding of ice pass for binding checking.
- Link to v1: http://shc-kerarch-hyd:8080/kernel_archive/20251024050921.3573402-1-quic_linlzhan@quicinc.com/T/#t

Initial version:
- Add fw managed resource abstraction support in ICE driver.
- Add respective compatible and document it's bindings.

Linlin Zhang (3):
  dt-bindings: crypto: qcom,ice: Add sa8255p support
  soc: qcom: ice: Enable PM runtime for ICE driver
  soc: qcom: ice: Add SCMI support for sa8255p based targets

 .../crypto/qcom,inline-crypto-engine.yaml     |  27 ++++-
 drivers/soc/qcom/ice.c                        | 108 +++++++++++++++---
 2 files changed, 115 insertions(+), 20 deletions(-)

-- 
2.34.1

