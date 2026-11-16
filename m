Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794819639;
	b=NrpU2qJr/DyrCQLrK/pXtrkeZAkMasG1D7YhLIfn/7kR/nkONCarUP4/hTuENQEmiqhr
	 lc+LGtb86qaLDpuuHnEmUXVzAkZ1sbZn+Ts54hKkXrUulp3/qQ0B3t9BjW0RlFYy8rMcK
	 WL5yNpbZY78Jg5esgh94OApK74OqvRUV4tAGZQakbaFJTpzioKPzrwyZhzb/vXbGMBHJl
	 I0b6SBbsFVCxrRCV+f8HWckiNdKZS2Aem3GET+2Gq6PBLs8NRUzobXWzkvIpcUHSDxJ9l
	 rYK8PlbRjqojEDvcytIZvQ1N+tZFdWdPpupEYmSEBZ0L6vpU+T1eOW+8YqoSY8fM3og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794819639;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:
	 Subject:Date:Message-Id:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=RWdJlEcKsPAMkOmrDVhbnZVy8AXIiOlUFc4fBujke7s=;
	b=hR8GyWtqJGse93ZrhLdZy8P0sx5faihFMtCFbdMX3cnyoZG2HcPaMfzPZ3ia4hVA6wRO
	 FFLb4/pBNZJySko8gtG4WK65+zjCajYSN02zFwhLv43ynDNrxWV5ZfyrEvW4AMjujmp1h
	 iubvFxvO8rGjb+WFmHDSdR3vYD6xiI64VZREowzBZG5LL10gWYuxOKPqBtjcQ3shwQFrm
	 Jxyhk3jWSDjA0tVmlwt6PcW5zNPbUj4WdbrS0NxQbvost8Te2yQdRyd2Qf2TYsKK3TgDK
	 uHuQ0rZTGv9PP4m1MhoAtAB5OWIsX221Q5bZF2r+0K3c9YfK16Mqn3AfV2Z1KdfzrmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Soeroo2d;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=M7X7vPm+;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C95606A331
	for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 09:00:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29C95606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Soeroo2d;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=M7X7vPm+
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AG7etsQ633367
	for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 09:00:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=RWdJlEcKsPAMkOmrDVhbnZ
	Vy8AXIiOlUFc4fBujke7s=; b=Soeroo2dJUYCRKb5np7xU0OqrbtO7ZvUYx9JcR
	DTshPJDHhnMep3TyimQ95pGmJDacsbdhuB1tN5MIt2lX10cuBL/QfsrdhLe1bn7l
	JDddLq8+FvozGqXikwFuFzOnqVSdy1iAocdRMmLSJ4B/TS2fJ1ylVuJf47BGqs72
	94Ov+YUW/jm4kdoCYIZKpw85rkms4gtkiho/5gxnmig59e4NbN/BOA0sNAlTtZS1
	ASFTCIiPurvK2kI+R5h9IjyYdv+IxaVtpwPp28hZn/EX6F9nU8hBqyXQaJaIBkTZ
	aGCObvCMHMODxoXt4PXrz1YfGgKdpBzyAzFGKRCZYMXH3VIA==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hxhnx5s5s-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 09:00:36 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3b10afdf947so4095155a91.0
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 01:00:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794819635; x=1795424435; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=RWdJlEcKsPAMkOmrDVhbnZVy8AXIiOlUFc4fBujke7s=;
        b=M7X7vPm+IIocLi2AtMlTPtSe+F3j2YQRCxbe3GQ9xpA9nLpISp/7G1CXjNQ6cSp1BP
         8hCYc/PJV4UpKA+J18xw8zqUMpnEQmTyfMdfyVXQgSW3GeLnapWIqwm1Fc3SIeJILDwW
         uRJP4gS5ryTY+HfnM3oCZaVSQkAgikEsYjyfW12xiNjplAezG4S+k87QkTOOBmNqHtPH
         Yzqd24BANfj1fWciGGXZoG2XoljPmRoMXX0FHNn/iFNyX48ogsy4YWxiXqzCnFocTC6q
         XzuSoPub7jcVruTdRah/4KZ+MaaJNA2u40O1RElae5V941iN40s0PXhiEKvcX4Diga6k
         2eTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794819635; x=1795424435;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=RWdJlEcKsPAMkOmrDVhbnZVy8AXIiOlUFc4fBujke7s=;
        b=LaG9524yCbb8dNDzPDkKszTpDq2Vpb1KUNOa+meXhQT4p99FSQwIouxlex0IrL6mqd
         bUDc4N45Dlr8xPxp5hEgunHNNbBAvKEwbs/dtH64ng6/+/wxfD9DJPD6perBXijGJGBJ
         IbR8ohA1dfqFeeqpzCSMvdvcMmQSZUXSJPe08/7wDywaxlFPc4jLf2XIVSjs01L3RCHB
         3cZ/wuHU8/aVOT/O5oIhIQbDos4OB4nFOjuoYjU4vpJO3K3a0rAnN+/9L+AV6OLM2xBE
         1QyfNuQKx06/0L9EZ1+UAHJkLjL9E4p8cGnWLFCOiqAUy4UK/1tU0HISkAhRcb+a/f7/
         qTEA==
X-Forwarded-Encrypted: i=1; AL+hErEPlS1IS7UepXbXy/vL2AdyAX8QzeUaa0sYCdZsPFLOmmgb+Tm1IQ8slRgOGYzvPLAJm+oCtli9YjvfHKs=@vger.kernel.org
X-Gm-Message-State: APuU4Z9PfccSL5XE3WvrrToHOOD1s3unkl4jAA95GEAwlw6YjGPE8oKa
	Q5rZ3WGlBJMm4ALVup8pBNnCLhYGQaxolAumJkkNyqvnUHqLuXL9e5M6yq0UGGZaa0WZizSEMtT
	FVr3cdC6ZKcEP8zZJm0ITAjrgHSU8i/yvG+zvsPr5b0hgs3Jx/hZ6ZWITiGw3IcNhCeo=
X-Gm-Gg: AZFdTZfZ9vzhBXiQS7sLPBDlI7uebiMWYjoc3wH4ULpZGLgBCqJSv1kTX4yjVf183DX
	5UAN3yj/7E/YsimqyrNFifS6MUmyxuVNlDBbpoQ5iaKTHp+jIwRVpJOp/jTrgqmg+r9pJLFaPHz
	wKOjHi/JbmflKiUY9CvEECNNO8geRtMY008/ARjaSmgnAviZhIzvs7vfcQQtMIEqr5USs9KMPZD
	cuI5T0f4+NmqmKidof8Vbl6H8wwVuyNxFIYchyedGlDpNTlTH9BhCvhkHqr7pblAnRjLHt5zhKg
	RyB6JOHLUE+gFZQhdxM3dVfb+QiYG+FMhCJK/TUFPqDDUbfDXtkC41h9QkvwiZ2HZy1aJGU2zUD
	LyFMLuXwwBN0ALF7Bz+8lkAuXPVG+9r4PSnE8nTtoYnBKXPfxXKQ2SSxAjdvahPHe1JBtaZ3R96
	TLcZOsI/k=
X-Received: by 2002:a17:90a:fc4f:b0:3ae:8983:4ef8 with SMTP id 98e67ed59e1d1-3b1b0b5c008mr6055402a91.9.1794819634876;
        Mon, 16 Nov 2026 01:00:34 -0800 (PST)
X-Received: by 2002:a17:90a:fc4f:b0:3ae:8983:4ef8 with SMTP id 98e67ed59e1d1-3b1b0b5c008mr6055368a91.9.1794819634318;
        Mon, 16 Nov 2026 01:00:34 -0800 (PST)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1aeb3d2d4sm15916632a91.7.2026.11.16.01.00.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 01:00:33 -0800 (PST)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Subject: [PATCH v3 0/2] Shikra: Fix qce configuration
Date: Mon, 16 Nov 2026 14:29:44 +0530
Message-Id: <20261116-shikra_qce_fix-v3-0-9ae31470ef48@oss.qualcomm.com>
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
X-B4-Tracking: v=1; b=H4sIAADG+moC/3WNzQ6CMBCEX8X0bElbfvXkexhDyrJIVai00GgI7
 26LBw9qstlkZme/mYlFo9CS/WYmBp2ySvdexNsNgVb2Z6Sq9poIJjLOWEZtq65GlgNg2agHFTm
 r8jhN8p2siX+6G/T2Cjye3tpO1QVhDJSQaJUdtXmujY6H3F+445TRQkKa1AXHukoO2tpomOQNd
 NdFfpHQ4cSHwrn4oghPEYD+BOCn+UFZluUFcYxjmQsBAAA=
X-Change-ID: 20261006-shikra_qce_fix-270b735479ad
To: Bartosz Golaszewski <brgl@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>
Cc: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDAzNSBTYWx0ZWRfX7ZnoLrCDTdL6
 bGhAWXu0K82ofnWCnPxlyYOsnCa3enBR4iP3wuwsJS5kuxBnEHWcgDjD7UODLff7JiEl4rH1BYn
 GD53PKfrAxlcwGCyuvokDJWHnQ3LoGSxjKv1OaneKGjLLsPmhNeYeKjn3pERj3XO+VJ19ztrjCX
 xiKSbxYRdOECtkXo6eb6ZFqAOab7wPhfX8B3AFUEjnLYgOWcvcfBE7HtUOW5Iv0XaR9MLOIPk6a
 nz4er9ZgQePZ/2jOAlRxA4lNlkOH2A0o3yr9kcY5J3WDQRUBw6pZRUWsaLlwIwPw8lXfvOnWoGV
 d02kKQ4zdgvnQ5ky08byeUlNgmMavykZFCs2Xs6aWZxL/q5r0IcvVTOUG5OpjZ52XBGGFoHdJHI
 YN/azXDCBgKNbZJu1pHNJmx/HDs/Z+vSvF13lvVJU8dTfBgTVH5eeTP4fyPWRbOx7ehAyXskr01
 aKeORyrtN3T0DblOpwg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDAzNSBTYWx0ZWRfX9Jc5Qfwit0D3
 l+2Gyguw1c1NnhaJ4EKDeCjBOSfTP9nYxPE07asknvTOsP8icXtyktX1XXfNPYPQksUBDiayyrr
 cYX5FwKugGgvPb8HcbMAOaL4ezcSZQE=
X-Proofpoint-ORIG-GUID: m1kLWFT1AbqTTaxOpyTchhKrchmBKelT
X-Proofpoint-GUID: m1kLWFT1AbqTTaxOpyTchhKrchmBKelT
X-Authority-Analysis: v=2.4 cv=Jr5kP84C c=1 sm=1 tr=0 ts=6afac634 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=bC-a23v3AAAA:8 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=FNyBlpCuAAAA:8
 a=J1Y8HTJGAAAA:8 a=2l3kZstW3bczaa83jWEA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22 a=FO4_E8m0qiDe52t0p3_H:22 a=RlW-AWeGUCXs_Nkyno-6:22
 a=y1Q9-5lHfBjTkpIzbSAN:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-16_03,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611160035

Herbert/Bjorn,
This patch series fixes QCE on Shikra and targetted for v7.4.
Shikra crypto qce binding was consumed in v7.3 but DTS node got merged
in v7.4-rc1. It's important to merge this fix in v7.4 to avoid breaking
backward compatibility.
This series updates shikra fallback compatible and hence, both patches
should go from same tree to pass make dtbs_check otherwise patches from
individual tree will break dtbs_check checker. If dtbs_checker is not
blocker, then patches can go from individual tree.

Bjorn, will you be able to pick both?

The patch series fix description as follows:
Shikra require explicit clock which is omitted with current binding
description.
Also, one more reason to update shikra-QCE is, clk-smd-rpm was doing proxy
voting and crypto was consuming it. With proxy vote removal, qce need to
vote for it's own clocks explicitly which is already being done for
agatti target. Adapt same mechanism to Shikra QCE too.

Validations:
- Qce probe and kcapi_convenience.sh tests.
- Correct clk_summary output as prepare_count and enable_count are 0.

Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
Changes in v3:
- Collect Krzysztof R-b on patch 1/2.
- Update patch 2/2 commit message.
- Specify merge dependency in cover letter.
- Link to v2: https://patch.msgid.link/20261112-shikra_qce_fix-v2-0-2ce112cc2ccf@oss.qualcomm.com

Changes in v2:
- Update commit message on Konrad and Krzysztof comments.
- Link to v1: https://patch.msgid.link/20261006-shikra_qce_fix-v1-0-8ac54d81edb4@oss.qualcomm.com

To: Bartosz Golaszewski <brgl@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
To: "David S. Miller" <davem@davemloft.net>
To: Rob Herring <robh@kernel.org>
To: Krzysztof Kozlowski <krzk+dt@kernel.org>
To: Conor Dooley <conor+dt@kernel.org>
To: Bjorn Andersson <andersson@kernel.org>
To: Konrad Dybcio <konradybcio@kernel.org>
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
To: Abel Vesa <abelvesa@kernel.org>
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

---
Kuldeep Singh (2):
      dt-bindings: crypto: Correct Shikra QCE compatible hierarchy
      arm64: dts: qcom: shikra: Correct QCE node configuration

 Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 3 ++-
 arch/arm64/boot/dts/qcom/shikra.dtsi                   | 7 +++----
 2 files changed, 5 insertions(+), 5 deletions(-)
---
base-commit: 84abb955b1015477aa11a96e2f3ac1b938b77f48
change-id: 20261006-shikra_qce_fix-270b735479ad

Best regards,
--  
Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

