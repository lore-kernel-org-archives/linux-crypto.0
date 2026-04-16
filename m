Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED443B47E9
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 13:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776344853; cv=none; b=XgnPEVof4JPUxvXRQH4X8hcyN1bLiuIErIljXmyGpbGBo3E8R8D1BKnZfP5q5aWtUmKNrATyDnJJTfdgM3AkKlK25t4w3Xp91GQ0PrQVpkasopbrH/exgrMdOapsAGwIVl22zezj8gd22ecA9BmvulbQCNHAmYPBTUl42XBN2BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776344853; c=relaxed/simple;
	bh=6LYYvW3a2jfG+sYqtjrDrNOPas3lIJ0V4OXqFVb6FOg=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=ln80dLzuwON28MMqKQT5CbeCSIaYmjpUT2Ub9dpREAmqvQ2pBpHGF/uyZaiQ+ELkEqI32BUuoqmO9fMZRCEb5kzB0m7RAiJcG5yGSU5NqOJMvdkxaEvXrZntJ8wO/67lpkjLfLbc/DxaJOPuGOZsNiOx4z/o8vVXzLU0RDVV8OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=H5ZNyVIq; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RiHZpKIS; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="H5ZNyVIq";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RiHZpKIS"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63G8Mhv93733617
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 13:07:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=POW8Tff6Ny9kwlW1q/aH/t
	9A59tUh3oFYWOLgRQtEtQ=; b=H5ZNyVIqNSQLYV8RV78BymyisKxFongozKndo0
	ANbwbXqyH0trjOjErfuf/e5WqSbJEwGQPC/p+CNEG1DPnBkg1dpuosVai/hhBz8f
	AUUyNleE2OHZU1et5eIuaw9e3eo65OVrYEeLPH/hVJzV3/4O5jCa+NWnKiS2/79O
	K89kVjBxFDsN5FQSqaP5JERZzPyJ3rHfxWoCjgRC/QZPRLH3NB6X5Ac29DgbP/QH
	R5qsL8t0ZWybc6owicpfbdI00ZDnPicgt6t3nDkPlkk/9YDoe4JkghmzlGixGB7/
	9rVA0YQyxZMLlyWfEOoOIucwAwht6CAg/MW+D81vRyPXfWQw==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4djcqwm3t9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 13:07:31 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c7939ac69edso6080270a12.3
        for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 06:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776344851; x=1776949651; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=POW8Tff6Ny9kwlW1q/aH/t9A59tUh3oFYWOLgRQtEtQ=;
        b=RiHZpKISgkd5VymehyZK3NEeZFg63kSyjiZkbRb9UenUOZQiToWhbe8Gwi0HpcIH9e
         KzLCut/l2HUyd9xyXl5uDQPa+pm0BpF+4u67PBi6OqMOe4LlbTckMUcnfuRev5dt/ODV
         tHqBfAzPnGMqMNApbVlx2UvRLItE5wVi3zZTfrLfUaFsWNXhMhowWD9YuAQzhR0+q+Zh
         URcsjKZ7wDgYZ0M5fs3mXb0KzVcqs7m24DTqs04PfdMMTtLh5kT587beIUuM0Sn51eKX
         Tw2t/JeR7VNxFOgz3OB0bwQBeFekCX7+ZKjQxi2eK1RcNmATpah/Li/hoxp/JusM67Pi
         nSWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776344851; x=1776949651;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=POW8Tff6Ny9kwlW1q/aH/t9A59tUh3oFYWOLgRQtEtQ=;
        b=OpZFMt8RPFiaLM/7FXqi0rB+E3clWy8++Lcwl1HuvQhjGpFiuowO3DB31p0Je05AeK
         En4ERlv4j2vv8VwWeFZjvgui76211UVQCVKIABPvqrFWqk6+OzxKj6vPZfS7/53Qm2h7
         m6sfpoYN+4lWuD2RLH5bqHv2GDDNpyfMVvqki3D9N93Oq89Eo3xRbcX82o/DAkRhdG7K
         oSHD+nfgKbH1cSPYsQ4St0LvMqYUeg/6mVd7E8bd9syd4KeI9om/1vj8XtPe/JkpKlyV
         yvMba82r0BE3teSuIWp6NkKgPe+4shv5t7UHxfLDhVs2Fpy5VMQgh8Wpf8xmtbM7aCYt
         MV2A==
X-Forwarded-Encrypted: i=1; AFNElJ9hU9RLar4PHDK9gvUUPp0wsS0vnXXMxuK6Izuvs6ui30sXpcLLn/6cSiPMtdyXEXloeZaDviprLyigyp0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRu2e9OpNEzENC5dotft+fILi1klpdQnBv4ppbxKGWB1Efm+8B
	g7h/8bXknyjQKsIpcSvabhr3/VEf8TG0EtoNjeKujeXXCHxYNnjuFFxXu+wQ5hUS7PM7ISqqSYB
	GdwZXNDfmpAHt/fM7wsOT+WCbcU/TR9Qhl3qs+QuiVIQogWmKlDiFKZAX2eFT8iBtGdM=
X-Gm-Gg: AeBDievruH5yDrEmxCTO65TC2Ffbm8sG8WaiyFHWcfza7lH3BiFaHdeiPUquQGH+XJl
	ILyITxU3IIeXz/QJ0uxyHC/eLbawx/PzcNHsrUReutG/6R5pARcXW5Bp1XP0vxF6Vh/slDVG43G
	tpfi8DgBbwQBn+lrgPSmp+Ab+R8AyIK/LCZPN9r1sKKEoDsNHdRWK+yRn7zsVoVYvQ/ZJy2RsJB
	v5tkaS1uYUmq1UGZCtILEcDGPlO8xiH/5TNtqvaad+f6ovPU2lnIRGYYs4FTwraxNgpL7z4+/Em
	RE/FKpM4V0vKWSJ4i74T+kPsCEII5hFOK4/LGs37Krbzz+fbYRDdgO/Nm/ZlEV7BQ47OaDccnca
	OFA03DagTgT/yRvePO7xXGxfdjid3EJW4p5TrGpiCitgRF2AaA8BRYaie0Q==
X-Received: by 2002:a05:6a00:244d:b0:82d:603f:f3a with SMTP id d2e1a72fcca58-82f0c2493e0mr26814438b3a.24.1776344850718;
        Thu, 16 Apr 2026 06:07:30 -0700 (PDT)
X-Received: by 2002:a05:6a00:244d:b0:82d:603f:f3a with SMTP id d2e1a72fcca58-82f0c2493e0mr26814365b3a.24.1776344850094;
        Thu, 16 Apr 2026 06:07:30 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f67449c3asm5383605b3a.53.2026.04.16.06.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 06:07:29 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Subject: [PATCH 0/2] Add Crypto Engine support for the Glymur SoC
Date: Thu, 16 Apr 2026 18:37:19 +0530
Message-Id: <20260416-glymur_crypto_enablement-v1-0-75e768c1417c@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAff4GkC/x3MQQqDMBBG4avIrBuIgwjtVUqRJP6xAxplYosi3
 t3g8lu8d1CGCjK9qoMUf8kyp4L6UVH4ujTASF9MbLm1Td2aYdynn3ZB92WdOyTnR0xIq/HgGC2
 zb/hJJV8UUbZ7/f6c5wVsV8uAagAAAA==
X-Change-ID: 20260416-glymur_crypto_enablement-be2ff022b429
To: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Harshal Dev <harshal.dev@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776344844; l=664;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=6LYYvW3a2jfG+sYqtjrDrNOPas3lIJ0V4OXqFVb6FOg=;
 b=1bf97Oq2NNlGFeEkOKUdw/XcDAJQcDlHp7qBHHcRZBOcHXeYZ70pMoY4VpSDkqiw/wguh5C9u
 iKt0KpOkfDrBHoCG2v7ibA7EkrIGm8CidhgrsmcQxG0ANkS9FE6y/qC
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-ORIG-GUID: XR1tb6Xr-8507o_4_iaztsqsk2lH9cel
X-Proofpoint-GUID: XR1tb6Xr-8507o_4_iaztsqsk2lH9cel
X-Authority-Analysis: v=2.4 cv=XOIAjwhE c=1 sm=1 tr=0 ts=69e0df13 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=RuLhemBIKpjh240wRt4A:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE2MDEyNSBTYWx0ZWRfX2R9bDsXNCWZV
 aiy363GTcRuAaL5c9ztYBSX83sXhbpgipwfr8ASEeErefwORKt53POY459Bbr5PCTC6ru4O8cjv
 AG97MiRPP5Fq5s8IIXs5kVZPSf0kpT9zEDy9r94/4O36JYnL8IrDufszgj7/GVgnBT9GtUMuniT
 NgBbCUMZ/INDni7aqKNmBjCRrF/p1MJ/PwSFWoWBy/fFIQm88YyQIfsu2soUV/IY15xPo45FdGX
 PWQfAKyz1OOmpVjqh9DNv9Xpb8cb70+DJEpYKZiJfWOVqYg3tGJllpfl4LId1rmqkFWaY8o7q5x
 YrnVi2k/7nblHcXVpziDRdX6yTLS2UdCfL/ZZHuIgUwQuYN/NBFKKH0HmquWKmmqHIGDQYP64dL
 NuwCO1f8gmtUUlT/ZwpCgBysqTqvwZhMjfA5mztESAwmzM+pu3DW2RJ1A5Ace8LxikwcBTaqOVp
 owQmU2TUhXblE5caWXA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_03,2026-04-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 suspectscore=0 spamscore=0 malwarescore=0
 bulkscore=0 impostorscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604160125

Document and add the device-tree nodes to enable the Crypto Engine
and its BAM for Glymur.

Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
Harshal Dev (2):
      dt-bindings: crypto: qcom-qce: Document the Glymur crypto engine
      arm64: dts: qcom: glymur: Add crypto engine

 .../devicetree/bindings/crypto/qcom-qce.yaml       |  1 +
 arch/arm64/boot/dts/qcom/glymur.dtsi               | 26 ++++++++++++++++++++++
 2 files changed, 27 insertions(+)
---
base-commit: 936c21068d7ade00325e40d82bfd2f3f29d9f659
change-id: 20260416-glymur_crypto_enablement-be2ff022b429

Best regards,
-- 
Harshal Dev <harshal.dev@oss.qualcomm.com>

