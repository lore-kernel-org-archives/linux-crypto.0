Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40BC276028
	for <linux-crypto@vger.kernel.org>; Thu, 30 Apr 2026 03:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777519306; cv=none; b=tLKxKkM684ggDr1+hPZJG5lhg+kAnqLRANwdbY8u8B+1LUAbG1T+qwC6qEIA/UMRFx6yR+H7kFCrgi7nDAPEzv1kghPjfd8BnBdpb//9GDR6OWvS+dDdbISY1hekkkaLLjESCitvWdXHxXRbmTfyJwERkt8jvfRWuWQYDaY0/LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777519306; c=relaxed/simple;
	bh=3RsQB9XniqidnNkSuioJpxgQw0jvK8RCoNbotV6wuSM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=ipqQU+myr20Id2afyfxfqDhvUoMxHEvWoP+dna0G6nSkfVQzizEt8alqYt/46CvSVF6aS0GFValX/TeyF9TqcPG5zsFPZ/ZXW81VIM82vPYoBg4Y+6DCrIxZpBe8hEDvOpsb+J7VgyvO4Y26FCpb3FZ9wVNwajiKcrD3aY1v4YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Re/sqlKv; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IgfHE7z4; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Re/sqlKv";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IgfHE7z4"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63U3HBfZ3729448
	for <linux-crypto@vger.kernel.org>; Thu, 30 Apr 2026 03:21:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=OPnVzQxAZuWytMDrD5gTR/
	fXDYXZpYZFs/9EUtDuKbo=; b=Re/sqlKvxUFre49xIXxxRvWoTZflHw6bCFT4Bd
	SSvL2fMHAwDQeQ15vDqlUFSKneW0xRrejK2DwdPu6agh2X4hXBe4JPulVFxQZuE2
	eSmCZdYfd5G1TS1eNDic4jd5Fc1cMkxNUuFUfAkWPX6jYXu02KsQIKMfT5wgoGWG
	Cjhgt5eDSGtHatjt9YOdBOXp4oCdDP3CDt9VXk3xDKf0toJ0PKiovThx5Lv135qk
	cBQ2k3IfCjxYX5lSH2TTx3Lww5i7NgZbQjBG2bPKN2Mx3Qzoqrtt041JlF68Lm7M
	uwMwvriTcaDs2TK1QfYJd/rQTMACmUIR9R7glj+/EXOBBfSg==
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com [74.125.82.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4duy1w80dj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 30 Apr 2026 03:21:42 +0000 (GMT)
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-12c66fdd4aeso882025c88.0
        for <linux-crypto@vger.kernel.org>; Wed, 29 Apr 2026 20:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777519302; x=1778124102; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OPnVzQxAZuWytMDrD5gTR/fXDYXZpYZFs/9EUtDuKbo=;
        b=IgfHE7z4uNrXQKyZNsaWs4uYzb5F36nbDHiRFmkoxk5FMf3SkdpIl+uESNdoDLWqrc
         D+3beEE2rd0Oon7WKpsm6WkRbCazXtuQOap9mh2k3eLLUgoIzqOV+3jrqmxMR8O5OdJ+
         oGTqTSuG4KFqhhK4rbfJStbWUK8uDXFWvEqTNNYNLMps8KiBDJAIOFuhht8yitVREphe
         qbIkSQm92Yl+K5EJKh2e7Wcv4NbDjUe8LAsRjObVfZIWbDA8fHXNPYIuJdKFDWQUQHbf
         KPqO+HLe+LPVW6bBabqgFVWVFuGeYfz/LNwOiCrg+jPm8E52KvYI6b+saq8kZUsfADs8
         6JYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777519302; x=1778124102;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OPnVzQxAZuWytMDrD5gTR/fXDYXZpYZFs/9EUtDuKbo=;
        b=DIQ7sws0U4PAkCTblv2A5vApQnNEve4pWCNXDpSqW6MZHjllH/Q23DzcqT4aZzymvX
         0ZAcpg+Ry3nvpKuruHydo3DBpaQ4vW5W7QWPWBIYt6XNk/2Nzq9iTeOrVPBlM1n8L1TG
         DSzek+NZnoY6A4c86JuLaFInFzMaQvB6cZjFukzYUMcnuEkBpFiuEsbczQ5sHOjq0GwC
         UJbWBqqOUG6umWXAUe1uC6HgJlk4jC0a5Qkak4AahqtVL5BiGnoXtHMyVowjTjeOebQ8
         9mJCYaRPwAF6rUzCLM8ku0GG8S0IiwrFYJ3sNeqkEq7zRWJilMlnTDhC+BrZo9FGcCzt
         ZiEA==
X-Forwarded-Encrypted: i=1; AFNElJ8Prk52D1NzfFQ23UE346t/Eq30bNn4TvHH+8gIDKdhzhT/pRsmiwq+YuUJZjuqWJ6vUStuXRX2jUCBC4Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIQmFHBzbnT+UJ/wljfvzKTL/IZbVglik2zpfqlQ5w3IHPZLDK
	Cxm9N5a0s10nNp9ES6AQoym6dqRPwt4+j+6t6ndJ5bxf2FbkYaSnvijUWsnZcjLE3HoL0Kto+xo
	IIgRWLYkI9AGRJK3LbvbAsoLLhZLPvI/SzJJ6GLZ1ehkV2dNiWYfey74XtlV/ddQSbaM=
X-Gm-Gg: AeBDiettiO3rZP0TwvfLOS52eznmSXM8mIxuP9zRXf0KMiulsFhv3ENab+OkgxvyOnu
	004GmhuE0Z14D2oK5dsYKFrLHmSJu1T8d03lkdJ7iWQSLmb6qWaFFuNSd04G0//MjwG5W1Iz9Bx
	9hWSRpcKZl9Sv0gMzcQ+IZ0BUf4+F9QOZ/pI0A5tD5BXD0QqzIpktmsqhfIzCXdbzRM+cplWhDq
	pJ68GaGvG3Z+Yv/pX0Pzs6tr78Hf+WiwY3NB19mPFe5T7hqaQN88HT/pqEQcn3nE8KgGupBLLDT
	c+qFw+R8bEYHTvuN7tcMtLj/1tI7hQ4s9dGOCaeaSkHbdbP1h9FaSxf/Cwbu5xf9JQtajMacFVX
	F+BVfVIv5gT9ptzqxKAR2ICn8AChbmU1At+3T1gJ0lmXQldAarxg4gfAuVSZ0xzgq4op12Gqm7B
	u1Vq/ZW7D0QbUtwgQ=
X-Received: by 2002:a05:7022:698d:b0:127:33e0:ea40 with SMTP id a92af1059eb24-12deac72eebmr551265c88.15.1777519301658;
        Wed, 29 Apr 2026 20:21:41 -0700 (PDT)
X-Received: by 2002:a05:7022:698d:b0:127:33e0:ea40 with SMTP id a92af1059eb24-12deac72eebmr551249c88.15.1777519301119;
        Wed, 29 Apr 2026 20:21:41 -0700 (PDT)
Received: from u20-san1p10573.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12de321df36sm7572644c88.7.2026.04.29.20.21.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 20:21:40 -0700 (PDT)
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
To: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, ebiggers@google.com
Cc: neeraj.soni@oss.qualcomm.com, gaurav.kashyap@oss.qualcomm.com,
        deepti.jaggi@oss.qualcomm.com, bjorn.andersson@oss.qualcomm.com,
        quic_shazhuss@quicinc.com, trilok.soni@oss.qualcomm.com,
        konrad.dybcio@oss.qualcomm.com
Subject: [PATCH v6 0/3] soc: qcom: ice: Enable firmware managed resource
Date: Wed, 29 Apr 2026 20:21:32 -0700
Message-Id: <20260430032136.3058773-1-linlin.zhang@oss.qualcomm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 1chgKb8BSFR8389q0tK1Yzc9Y3j9nzb0
X-Proofpoint-ORIG-GUID: 1chgKb8BSFR8389q0tK1Yzc9Y3j9nzb0
X-Authority-Analysis: v=2.4 cv=DPy/JSNb c=1 sm=1 tr=0 ts=69f2cac6 cx=c_pps
 a=kVLUcbK0zfr7ocalXnG1qA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=COk6AnOGAAAA:8 a=Jyhv0Gfyiw9a8mKZ3MwA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=s5zKW874KtQA:10 a=vr4QvYf-bLy2KjpDp97w:22
 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDMwMDAzMCBTYWx0ZWRfX0vAgMs64ohUI
 YSoamyfFRsvoK7w6d2WN3EdMIS0wmPBDo6QEaugjuxDeeVS4gAQn1CjvQb/LAecn7Vn2mOHga/C
 tc2N0bXE8NTu3bN6JhkZRSaXSYU3KXkT121jQ0q/V2u1ct0K5wvQ1tvSe4o7Io8eHyT67bpOpGJ
 wBXXDqKL1h6h3xCjWuaXSLGUxkmOcFpq9zUQIv6oKOg46kveMkgbGqF5prwQQLx8mvc0mgq/rN5
 heBKJINVY4QHuDE8vhPd7ebi7BY3LEuzgXJJ9Eq0fBnvh0HjH1QfuTQbSqdHAdlBMAzrBAPFMWL
 9acZC4OL6QiUDXF26qPc1bZUvuaeWi6MyNAHl1hHDPrQtkqIfhmCykrs7tzEV1zTiijArBdBcTs
 rHrZ8YJeuHcDU3x7tsWR9H1wjq39CQFKOyGaJbUUd3XN/eCu/Lbs7P452D18GVT/M8MAgU8HHgL
 5oS2zCn25rTSVqT8HKQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-30_01,2026-04-28_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 priorityscore=1501 malwarescore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604300030

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

