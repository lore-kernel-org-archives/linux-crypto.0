Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C49235BE2
	for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 20:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778790627; cv=none; b=PzER3KOn+s16GB9TJvXrlBP/HFXUHq2NYWJHNHzCvSHSDOYxZZ7XqHD4wmvKxI0QP2Ose/6V7ZVl6l/339RnR1CM+HCa7LozhevoH2Ge2RrTy1asjyEDTch3e04XTH34PcIt0zRvFJNbCr993EwMF2xKvI+W0RrI/RXLh+Qw+9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778790627; c=relaxed/simple;
	bh=hBUEdU4gtKk6cuED59MJsN9YQuh0ekZNAnrR3Vh+OK4=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Q2TjV1uGroOPsnmAIT2NXye7Mabh4wTiOsCtul0Tw+6VINK0GNPAvge+Fj0oDjouYLg9CAa5qcumey/E2tpYcCuE8z2hIIFkPCC3YySKiTvTc1hBEBK8bK9+9w+of6n4uGOGtj2zv+nnKq4SX+Dsn7WIPdJNSY7lxEVpqjSsFeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=VOSGp+Sb; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QW8b9F5V; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="VOSGp+Sb";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QW8b9F5V"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64EIpFXp3197593
	for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 20:30:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=Vy4HqHBCl3ieq4x5BJeO/r
	Gc0+4lnXTUCuMn6y7ah8M=; b=VOSGp+SbOMvsBs+w9+tYr4c5v0kN3YZkG/J1nx
	LSxwWVNuoRP9trDM2Rdq+Q8WfyogGYHnAYsvFmr1lQTsKMgSTMR7nznXj0L6wije
	Giau2uoI7ZL9Oerd+FJah4y1Qr6VMv3f6lu5luf1Bc8qnnj7Tf52To4kLvj/B5Ls
	mis9M8J9Tbx+X7SUQdg3YdGZB7amAfGk7UPDnEXLJMP+vb0YL91b23Q9pQW8vskc
	SmLCuYSkijL1GgaWk+c+4NpQRJ7rSh+6sEB4JhAGKZDu+LsE4LAsH8jm3irfliMx
	Id8K4W21xkFknukfSpL4Z68JJJzm8q5bhYvkh+uPqpy+TuRg==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e5m1q8a8q-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 20:30:23 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-8353fbc7ad5so4961305b3a.3
        for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 13:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778790623; x=1779395423; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Vy4HqHBCl3ieq4x5BJeO/rGc0+4lnXTUCuMn6y7ah8M=;
        b=QW8b9F5V7Xdwe23X3rFoDXtLzJPqCGz8NQ8mivsdZiepK/NAdj2YkuVmxncUNyYFOv
         ej2rvvetbUprh90vzPErlDi/GRxnO6+I5x7iQsYDrzFYIO8ffEYuTmhuTcRJGRNFsc8C
         yYKWsGvnbvyyT19WyzflsjNKOkWb3hmxumP7fsQADMi2iKELih4XNPROPQHL8FqVDb+S
         RdxiphLOVHNC1/plu6nZCK9yB7tB8nrKatCVR27KW/dnlcFKxq5pFhnNf7XZrLMDTkfH
         F6XXLpd2SlyjjgD1Gm3G8+3fWjYoMt0nWgcco4UsaKKqBQuaFLHEsgQjLrsx1hcS1Afp
         TJww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778790623; x=1779395423;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vy4HqHBCl3ieq4x5BJeO/rGc0+4lnXTUCuMn6y7ah8M=;
        b=FyaVDhYkkcwVOV6KnB6ReU3Q0gn1h0uCtLmkzr38SI3NEbVakYh7LTfiFVR3M3Cv8S
         zCkd7pCN4cH3RM4wtEbof8zNAYx1Co1oH7/s5OcpmPxNcWLfVin74ZfxHX8dprsmULYh
         949HpG8jE/TdmTm1AILvp4/qePhHQupwniwCSRi1LfgM9aJDNx1c7PPX61MEgRVMNHvK
         KBs+a5C12vlx20o6yF+5j7Mw98lEGI+guC/9AIdZPPmrb/t4bZZB057swyxfnuV9fHVp
         FCk/dovadGisJrTKJLictrJ/7GZHwpBHBRDiMkrZk2ya178qo5SB9J0Lxjv38PhZwzDz
         g2fw==
X-Forwarded-Encrypted: i=1; AFNElJ+ExBaVs8K41a87iLTFNXtCiOobp0/rcu5OyLSicOafiFrSKm9DaSNwJBJLdwnqZDR5E7cHDmCjV49J1c0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxhcUs77xRztrN4Ij0uWNaGFECEOy9gpqcMG0wbrBEmJQ+CszB
	ClOpOpt0zZaSqIa1ZoHdmqMF10zP64hpqHYZRrRxlEqodH5TvBqu5pr1Kzp1SKUSgNWPQXpcM/L
	yeF4taoqeBn8p3fjbDqH36qo2sa646jQ9RHUqPpqEYpjNB4FKYYo+ou2S9oNXTj3mFY8=
X-Gm-Gg: Acq92OGHX+ZiAhMbOf0y3BXhJqi0TytMoo0xDodAHaYa1N8AAPXBiWMRTPEkGUcHYk3
	WaY4hWw17gXOtB/kRmRATX84UbAX1TUWALyPJWMzns31hs2ACchdMT/JpcY+A3HXRdo0h5kdX2m
	w6Xx6uVcutA7kOpdmqSPmrM9n5XShstTDw6V6GUOK0avTYPbP8bbfHnROdbBeoa4Yz4WUkYJskg
	5auHdWrUGA1P/GuSHib2gYcckjZGiEd3XED/6KWOdqnlvn2PWv6vei963HgTeVfD2spXd9bo0FD
	psoTQfA4s2kjdgEFIR/ZPIAi25rlON8HNxd8hH36plh2kTCPV/UwiLScAB18TaQgRXHlBqFXGTV
	BSca247ZMxjNyyRDhOg45tvv8VSg0arXVB+G4Ed7WpMpNOA4rItum9dY=
X-Received: by 2002:a05:6a00:a214:b0:82f:7ba2:e120 with SMTP id d2e1a72fcca58-83f33cf0be8mr1091874b3a.28.1778790622715;
        Thu, 14 May 2026 13:30:22 -0700 (PDT)
X-Received: by 2002:a05:6a00:a214:b0:82f:7ba2:e120 with SMTP id d2e1a72fcca58-83f33cf0be8mr1091839b3a.28.1778790622172;
        Thu, 14 May 2026 13:30:22 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83f19664a59sm3666952b3a.1.2026.05.14.13.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 13:30:21 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Subject: [PATCH 0/2] Add support for ice ufs on shikra
Date: Fri, 15 May 2026 02:00:07 +0530
Message-Id: <20260515-shikra_ice_ufs-v1-0-b1b6ced70559@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAM8wBmoC/yXMTQ5AMBBA4avIrDWp+gmuIiJVgyFBOioScXfF8
 lu8dwGjJWQogwssHsS0Lh5RGIAZ9TKgoM4blFSZTKNY8Eiz1Q0ZbFzPIi06qROFcZIr8NFmsaf
 zG1b1b3bthGZ/L3DfDy+FWL1yAAAA
X-Change-ID: 20260513-shikra_ice_ufs-59d0a42e3482
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
X-Mailer: b4 0.15.1
X-Proofpoint-GUID: NwkQ0AmjPaM-oyZ7_HvnUWVXNOm2icRx
X-Authority-Analysis: v=2.4 cv=GulyPE1C c=1 sm=1 tr=0 ts=6a0630df cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=OYeRMZJyD6lClM-JVRUA:9 a=QEXdDO2ut3YA:10
 a=ZXulRonScM0A:10 a=zZCYzV9kfG8A:10 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE0MDIwMiBTYWx0ZWRfX8egc78NaEmy+
 wA9gkivq3QDlBW+Wio5hIWCxilXOLrcJFzOaSKxOthqsvF1rIOxzsH9n0v6zl7I7BODyzEpH45p
 mZLZwx2g+xT8O/J76KNStwv+BXzZ2q3MMLqvO/9M9j4b/JyV6I4JH5KGLrPGzNbsioJKLOCBqiR
 dMCHAw9KSLCUzjjUaMXZdr+p2FHKBGoo2psNwFqvASUEZYuoq5DWV+Y2z6iJ1vHoE8lzsov/CA6
 eah+xZpIfTaOwxHe/p12CR5KkZtr16W0lEYHe26jdn3LkpYf6Zg9dQN8cnxH2BY5A2DAzjTRJyX
 K/EHKc0d8pZpXKtxo+W07cVSGX2mSDSjXugifRgduS/wDxfFiMU5//ca6iL4HHPjKRa4sDIAk3y
 36CXE8Ih/vS7yyrFWijz4T7XHtoIYdA5r69NU9pd+KheGsX/RmkVB8/AzSxYaiKheFazAwPs6p2
 qHG5ClbMMJ3jmS2ejfg==
X-Proofpoint-ORIG-GUID: NwkQ0AmjPaM-oyZ7_HvnUWVXNOm2icRx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-14_05,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 malwarescore=0 clxscore=1015 impostorscore=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 suspectscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605140202

This patchseries attempt to enable ice ufs on shikra similar to other
platforms.

Validations: 
- Driver probe on bootup.

Dependency on:
- https://lore.kernel.org/all/20260512-shikra-dt-v1-0-716438330dd0@oss.qualcomm.com/
- https://lore.kernel.org/linux-arm-msm/20260416-qcom_ice_power_and_clk_vote-v5-0-5ccf5d7e2846@oss.qualcomm.com/

Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
Kuldeep Singh (2):
      dt-bindings: crypto: qcom,inline-crypto-engine: Document Shikra ICE
      arm64: dts: qcom: shikra: Enable ice support

 .../bindings/crypto/qcom,inline-crypto-engine.yaml           |  1 +
 arch/arm64/boot/dts/qcom/shikra.dtsi                         | 12 ++++++++++++
 2 files changed, 13 insertions(+)
---
base-commit: 7e247866bbe72314f68036d5171c1af354ccdbe8
change-id: 20260513-shikra_ice_ufs-59d0a42e3482

Best regards,
--  
Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

