Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AA13E639C
	for <linux-crypto@vger.kernel.org>; Tue,  9 Jun 2026 09:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780996154; cv=none; b=Csi69pwzV+JoNUtEYMdt3CxmMFudQbVcIUt4PUhHNlKKL+B5446Y1ZECTYfBilnbHR1eOZwqt6/6fZZ0mG/R+ciol5YNg5CoqpAesW6puEj4QTk9pDFRrKP/7bNB5lAOimZ1eA1nhF1KkzHs/8Pyy+15i53zTEhQ1wWqMFJz5Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780996154; c=relaxed/simple;
	bh=eKA0uRMeiYBzZ8FrqLiIcawxeUNdHDbGqu3nsVelPBk=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=JtqH5hakRxXWbQCREx+OV++4ZuFI3h5VeH8FiPr/2aMvnIZ1MJ2UuQDHAY1KYtX+sZdziOMKUG1jjSKDwMOYW63qy27iMK5xLBPc2qssNCYd6/MzGuKa5V/h8QoGRU8GqY939q3C/1AYb9j/tvpRigNtC5pXAIKaWhQ/Ev+ZZww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=P8+HoqDA; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=I1djfGp4; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="P8+HoqDA";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="I1djfGp4"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6598Whrd2129869
	for <linux-crypto@vger.kernel.org>; Tue, 9 Jun 2026 09:09:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=9kqHTn3HwlauTP/Mvnc9qY
	JtQpvMhNbtivLTo6vwNmo=; b=P8+HoqDALbmM6lrJAsBlwLuD7PzyBkSN3a7MxH
	4Rb4pUOUEIOJHmlvRsaKlIHz0ZOAX/F4ZV4Ozd5gKQTFAV2q2YI+9MXfZ9DNppD0
	dLpJSH0tvLcP9f5ClT6EPsmMmxyKmRMaXGzgzXkEM036KRX/OvfjhXLn6OPUt7fl
	4CxvK2uvqWirzjDQZ+r/xpepABzRjjX7iS/rEp3ATDXWkcSp49jTF/dbcmgGBPqa
	6YPBNVVk0eymPX2am8dvkxeiuODa7XBPvwcrdXOsdTgv6C1WnC5Uu5fvrPKRs/Lg
	o720RvkGdw4bdeniErqxeFaAJZUrfsFjF9CgdOZvE/NLeggQ==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4epfdt04u9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 09 Jun 2026 09:09:12 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-304f23c55b2so5303686eec.0
        for <linux-crypto@vger.kernel.org>; Tue, 09 Jun 2026 02:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780996151; x=1781600951; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9kqHTn3HwlauTP/Mvnc9qYJtQpvMhNbtivLTo6vwNmo=;
        b=I1djfGp4tY94fnWaDK4EgJ1w6kVfXqFdjPnzvN9oz8P1uA5vGDwISOpbf3wmE2AwM9
         5iM3MvXojYgAsdvASugA5jbqiCc0gFqUeGYxUmAL//Z4goOakCy8z+wp+S/9IUxwmYrw
         qhcNrFJXbSDajuZQKEV9W53qGZlmtn9gCPxOkosj8Hy2bxzrEwWEiHx647LagyNxe7a2
         az4q5IFk8RtObdtrEuAJM69rxi7JPyvoX+/GZe3uwQUBWdXi0hldsz5gamaeTiYWL2L+
         2nPl1VwNGt4DJan5nWDmKBaMysRszTBuliaj8NXQM1m4nCrg2/Tvimie4otpXnyrxDIJ
         nzBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780996151; x=1781600951;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9kqHTn3HwlauTP/Mvnc9qYJtQpvMhNbtivLTo6vwNmo=;
        b=cyr1yWjhQ+X4p+OSbtCFP1fZSz5JPaH1Q1Sk3pgUSPmSGrY+5AYDA/glQEup/31iaQ
         GpaVM6kkiVybJRKGAJ+sGzsAWcQjQ4VkDKy40mimh0KJH1iPvprQUIxtMJCGRHHHSTTh
         7avKd+M8GJwN0D+pXMOqb/BS02BigiprH6XLuDrQKH/icD3I3dvh6Au6pumPJk/Fs9zu
         NJ36y4m8wZhnCoj2AJW5AibWTkmR/vU7MO3PnJZfeVLMcamgQfqbOx27VjtVwG70NThb
         w90CjmfoT7d4fKN23QwzxBW7J0z84yJp141A1+67GF/Ge2rhTesDjBQTYLz/PgrJ5Mt4
         KD+w==
X-Forwarded-Encrypted: i=1; AFNElJ+Dxjt+aBl14kvb6+A94679vCv9TPADKzVx9+fVC18kjijnv1RD6EuDQSFsj2yDJ6LEKSPW5GXHqhcqBUo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzp8XS/sIYpCWp6/rkx4NwqRvJGyjpdl29MC17p1ybsSlKq2ThZ
	0R/31fKfm1lyYrYdzDB0pp9CHjI9tykN4w3FKdUFzKIzFB1DqzHPXwof6Y7+zJnWv0f+9OQscDh
	2YUiwZSEW1FDTrl5/DiGHw0QK9C4Qhpc0QJpn3qDeeWOe1TeqOCmsdI/cQlmiMCM3Iww=
X-Gm-Gg: Acq92OGwIllfxXvBAv6LmiX6mxxxkMCG8fNcQac42I0VaJr3Y+7bw6qEfkzrim5CIde
	M1o7hVtI0Xu9FYkuiBrlWB8liKU6DlPLAOERNolAT6Quh4pjDsHQl9Sbh8h93C7rXqq8LCSd5me
	AmbHhX5XduoxxRhM0EYeG7wburunQ32fbT7sgHXU+hWv2LhYA1diqc/SKIKw+YrdBsy0tLWSh05
	WHhqaMCVYkdn0X1/qVbxal6hmKJT76oCP3/dQ2Q3gv6YV0iL5Eb8t44kJKEe331q5QLIPU59DDK
	SzVfHeprgT0E3N5Wlz63EpsPvb0EPuiys1YMpjgPVPwUsMdnzMba9bEoqMkHtySkWJlPV6/tERD
	MhB5KTJdc1alQdiQsgiE7+aJtHHO+PWFVY/zjhmkeVXPwGss6IS+GuVdZ9nXbxkJLafX5i+0Q9q
	4veOjljfU=
X-Received: by 2002:a05:7301:1010:b0:2ef:83d4:647f with SMTP id 5a478bee46e88-3077b78cf1bmr10329044eec.25.1780996151378;
        Tue, 09 Jun 2026 02:09:11 -0700 (PDT)
X-Received: by 2002:a05:7301:1010:b0:2ef:83d4:647f with SMTP id 5a478bee46e88-3077b78cf1bmr10329009eec.25.1780996150851;
        Tue, 09 Jun 2026 02:09:10 -0700 (PDT)
Received: from hu-jingyw-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3074df102a1sm19356606eec.20.2026.06.09.02.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 02:09:10 -0700 (PDT)
From: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
Subject: [PATCH 0/2] dt-bindings: crypto: Add Qualcomm Maili crypto support
Date: Tue, 09 Jun 2026 02:08:55 -0700
Message-Id: <20260609-maili-crypto-v1-0-0f577df56a61@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIACfYJ2oC/x3MwQqDMAyA4VeRnA3Uwsr0VcYOsaYzMKukIg7x3
 Y07fof/P6CwChfoqgOUNykyZ0NTVxBHyh9GGczgnQ8uuBYnkq9g1N+yzvgYQuNT8C3FBJYsykn
 2/+71NvdUGHulHMd7YoMnnOcF4lTVqXUAAAA=
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>
Cc: aiqun.yu@oss.qualcomm.com, tingwei.zhang@oss.qualcomm.com,
        trilok.soni@oss.qualcomm.com, yijie.yang@oss.qualcomm.com,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jingyi Wang <jingyi.wang@oss.qualcomm.com>
X-Mailer: b4 0.15-dev-3d134
X-Developer-Signature: v=1; a=ed25519-sha256; t=1780996150; l=666;
 i=jingyi.wang@oss.qualcomm.com; s=20250911; h=from:subject:message-id;
 bh=eKA0uRMeiYBzZ8FrqLiIcawxeUNdHDbGqu3nsVelPBk=;
 b=2HviacF2Bp945mv5ccBbzVgys2yKYLPu7Kcig1USbJ05mOHa+uNnyxs9bfNAw6tCxj6fy11gf
 3x4CM02VNsFA+WbCAGzdtMjtbxCIzCknCmkwuijFsRPEIHJrJuC06yv
X-Developer-Key: i=jingyi.wang@oss.qualcomm.com; a=ed25519;
 pk=PSoHZ6KbUss3IW8FPRVMHMK0Jkkr/jV347mBYJO3iLo=
X-Proofpoint-ORIG-GUID: wmWU0shngJPDAiSCuX1Kl8PR0veJTCjY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA5MDA4NCBTYWx0ZWRfXyigubguVHsJF
 CON0EqPc7sahnpb4vN1J+vj1WCcp2D5vMFFCbQdCKtcYFRnNGLdLgQYZJcGy3ZdmIoedjd/c796
 SxAyuATRdLzc2DMauFo269tq8KgcHxXUOLU5bDT7Cl9YYjX7wfcPxvtxMZts5aBZnBCy3wiynk4
 BxGQ9UkYKBTAWg7QcKtqTyxJEtWjTQIuljspJwXHuYLjlxt9VMuzc3jca2/xCCfgqNbc+wbdExc
 r7uxdrEh+0iZmLl+qvE4pkQ24BD5mon0fIvDzv29UnldwKo18dEAfNqJ06K+T+5K4ulp45BX5Ya
 tpGa9WA0NP4UH+KusVS0dyfvYxh7GWP9zuz+r5UzMIRMAtARnqf3FEDQazCpRoB8crO6ToHJKuY
 vIKObGW4DkVKOHiBdYfWn0yz8mVVB+kS9lqz3mu7lnasK7aFEEE9hh43bngLUhaFJrMu56VXKxU
 VU2PmHy5FJ8z+JkYEgg==
X-Proofpoint-GUID: wmWU0shngJPDAiSCuX1Kl8PR0veJTCjY
X-Authority-Analysis: v=2.4 cv=doTrzVg4 c=1 sm=1 tr=0 ts=6a27d838 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=R6wdMziQwWSI7NrRmIEA:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-09_02,2026-06-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 phishscore=0 clxscore=1011 malwarescore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606090084

Add crypto(ICE and TRNG) dt-binding support for Qualcomm upcoming Maili
SoC.

Signed-off-by: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
---
Jingyi Wang (2):
      dt-bindings: crypto: qcom,prng: Document Maili TRNG
      dt-bindings: crypto: qcom,inline-crypto-engine: Document Maili ICE

 Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
 Documentation/devicetree/bindings/crypto/qcom,prng.yaml                 | 1 +
 2 files changed, 2 insertions(+)
---
base-commit: a87737435cfa134f9cdcc696ba3080759d04cf72
change-id: 20260609-maili-crypto-5d612f629acf

Best regards,
-- 
Jingyi Wang <jingyi.wang@oss.qualcomm.com>

