Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795517677;
	b=zuINSGk1mUW5/FdaxXiQdstMEdHWTSFqZ8ip72apVNSRUL4SbcTSVE7R8oEMPlpQjxuc
	 tsTa+lm9dln8KlQ3nneUAyw181nK20L3v3o10sztrhRVh7ahXxd4cswbL58E0Hm78Iq1H
	 U94Rk66fZQ0q+nsgt7PpHUipnZJ25wBtPJxznzMEe1RIqpqDnoCbX3m3sHiYeqYcS34xg
	 gLbgdvRaeZUKBIdHYKrB/g16cGN4vKnzbS+jyB01KSAcFqoQwXbh6N/Ea2F5aE1cs4Cr4
	 C3tMrZdfCF4ypxnUV0R92/ikHJJHB9YO7/9aPuoOFAunSptxEE6PFuEgjOV0DrJB3yA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795517677;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=oCq9AyrnUPb6wZIC4i+bwmGWAMp/EZK4G4q8U9q6iSM=;
	b=BOaCQVcwpRV6/3k5Zlz0de1mwld/YPyVztkAAwgyimCzHJf8+HrxK5BhsH+THaDrttkg
	 sbD3Yr63zzChXZGgolxLHl0qtS2dja18a5WEXxvfZ3lN5GV3pQLPXQvJ2LUcXWz6GvjIn
	 Lhl6WxIzBA6YZ+aN8dIba0adVddHfW8N5cKmGSn2KhSj5Hfn07uOmEp+HE2sDnKTqjeI+
	 2gqv4YoY9tW2aMmgId8fYMwy326J/UDs+BFnbf/Z+fH5PZQ6tOoreD5Puc52VeY4yWzUj
	 6MMZCX2Y8bqJ4BACEI+7PPH+nEgFkr/jN591R9YsZkW80BNO9VAQVsuUlOWykhoVFhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=bHhleDKg;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=koHXLA40;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367CD606A31E
	for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 10:54:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 367CD606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=bHhleDKg;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=koHXLA40
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AO8JrAP3225364
	for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 10:54:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=oCq9AyrnUPb6wZIC4i+bwmGWAMp/EZK4G4q
	8U9q6iSM=; b=bHhleDKgvopeEk/utmfUQ67VrrpLDtyA+GF/1l9oNQoeleg8g8/
	XPS34JS0Ojf2IN7sX6kCyY2KzMEUG1mbyoPmEsDTYU3ZxK5o7fr7+RnESyNgYSm0
	kdv75y0XuBjRrHl8PuxYcIjjONueEGdWvLzPJGXANZPMpzZlFVJ4XYUw6LnK01OK
	dPPmeTn6dk+4oNrWRrD1iN461Db4CeEX2Ff7n3UjV5A8CWfvV65TbiXYKzlqPQrg
	LzewDcn8nPXw8U4w/oKUF9vJlqbhVnvTv892S/12TkuVno+UFE8cdPK19VmVrYk/
	FepIqgxQZCUFBhBY9Qw066i8rYOsU5STUPQ==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j4x8f2nav-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 10:54:36 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-341eff9e381so7130201eec.1
        for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 02:54:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1795517676; x=1796122476; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=oCq9AyrnUPb6wZIC4i+bwmGWAMp/EZK4G4q8U9q6iSM=;
        b=koHXLA40OG+Gwq0Tw5eu7oPIGhpeBZHBp5XIveBtcMHmtZcBOJEIPFbYN4k6HfT3O6
         qLETKg/eL09R3XGV75Cstw1bd5UfCRcRyo5rXv0XMqZKGPPLYB1sfGjINpWWmzLqVrOm
         1KrxS8pV8W25OmL5Vwn+v2tEu4oj+nflvm30vpXK06I4az/OKlJ5MmRwBDLugPLKUBHQ
         EbKOHHm9pu5Y8nMJENQGioc5NsMZX1WVL4Japb7kPVkqFI/pnKgfXHylK/WJlDayI/Ae
         /q7JHbCllU5jR4nJzohjFaIa7+gxXMiEGRDwe0OmmkAvRsdBJEovLpbk+6uURT8nR9DG
         CO4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795517676; x=1796122476;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oCq9AyrnUPb6wZIC4i+bwmGWAMp/EZK4G4q8U9q6iSM=;
        b=CAnuQY8QqORpFCqDJmUe90Nw96Fb3bwgV7zVNrX2hzO6icC5kiQCTRWmtfuXUYpH7M
         hdcEgXmpeOtBczcjq+WT4ZsunXRUECIPqLUf8tm2DwxZUbIIhy1v/HT2Dby74knjIPGc
         Yfc2RcIj+RE83hKD1nezsPtaRfqN9wHPPkcRdX2WszoDDlvCuzH7xEWkJfW19OJvyb6l
         uMBauCHLXp8ZjjeuoSH8+azlgHJyTANWRJ/NTLOMWiPs9WsZVZP8HWJqOhr7j9ZGx1d6
         5UjniFypnmzNVnTs55N6v0HTEC1hzRCXAa+fJin0krk275JU0dfB3Uhbw384Jde/XRIi
         SctQ==
X-Forwarded-Encrypted: i=1; AL+hErEdGfnbXmezbeZT/NbvaCKBAZutWBu8S3BB8iJ/HGwGeJYHtJQzfixvRnbj+QieQkly7ouIHNjiKMYvwKE=@vger.kernel.org
X-Gm-Message-State: APuU4Z+bO40dhsv53TCxLGj+qwkt3x7Zr9cCmj8Trri70jMlDHVdWFy3
	0asE5TusaxCmx6RZgQRflf8uwrGd4yk7VWstJGfWFEkQc0yHutCqLzlpDQvkh6j1eabiEWHz7lx
	RLKWb1vXQ5+eX8pErI3irYql4hyuIv+JNQyxSYPxf9Jpqd2PLVfng+zbaB3W+Otiqxww=
X-Gm-Gg: AZFdTZd6Q+DrN1n/E10fb+mHWkRILAZqf7kc3kBQAwVyVbfIt9ncpCCkAQXUPvXOeWH
	H32y/Ka1NMjGoWphMOLLwIxl+h9QA15+Eb6Wv4D1DHUXn5vw8moGv+M+34nodzkOzSIhjFeB1uf
	RTIW6rcCsknMaYS5idVzLbjQ652MHtJIXO2NWqjF383v4RUtngl36JohVq7r1qm+h7uAyveRJj3
	zcNyVsv35lfi95ORgD0FHq2pwc8JJXzbZjVmaGjOVjYp5/F8XuWtddMfhxoAajN3O4/1QHfnmEL
	gFSLoYxfzTy+Y1gBiqCw87cgsC73SOjWi0kL8/5K5Dnr8S4dhqsL6JdfxRT76fs/mh5o+VhGCkC
	JJ4YWm3CwMPwZEP+Bry7+NwIqJuyWHkwshhztTrwptC2kRsqe4cZpyChpCZ/UdlM/eZp50x8BkM
	5Ex4Ew1UmJMvVHS4BhLIOSZZ8UDctt32zjO6eNaNHxX35D8W1cgmNsQdQ=
X-Received: by 2002:a05:7300:d205:b0:36a:1f8:a56e with SMTP id 5a478bee46e88-3856fe564a1mr14547464eec.23.1795517675924;
        Tue, 24 Nov 2026 02:54:35 -0800 (PST)
X-Received: by 2002:a05:7300:d205:b0:36a:1f8:a56e with SMTP id 5a478bee46e88-3856fe564a1mr14547443eec.23.1795517675449;
        Tue, 24 Nov 2026 02:54:35 -0800 (PST)
Received: from hu-ymg-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385666e99fdsm55231578eec.5.2026.11.24.02.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 02:54:35 -0800 (PST)
From: Yadu M G <yadu.mg@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH] dt-bindings: crypto: qcom,prng: Document Seca TRNG
Date: Tue, 24 Nov 2026 16:24:26 +0530
Message-ID: <b13bc8fa6aac6e9164ce9ad0ab202d0df491331f.1795517666.git.yadu.mg@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDA0MiBTYWx0ZWRfX/uI7qeW16ryy
 G06jfaby4EOGeSxdSK3waVdRW4QAgIxXG3goHwjdHLXHA+iVEFNEpf7qg/f3zQZO8QpKVAWRgvV
 q3L0jlqTuIa1laBZprCK0g8XDJkP0jw=
X-Authority-Analysis: v=2.4 cv=JbgpPkKV c=1 sm=1 tr=0 ts=6b056cec cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=EUspDBNiAAAA:8
 a=lHObh2IfMKzVuqTG74EA:9 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-GUID: y7Ze6gboc_J6muPHE-DbfPT85hUlJprm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDA0MiBTYWx0ZWRfX8jjbp851Ns5h
 dpg9X/5GnycqPL0ios7BwIpwhuk6IrJ7H6eVWMu19TmB0YwwXp3Pg/sWNJ0fvuADj3K83fA4Y6T
 ruCBRHQj8ed/pDA9WPRCjGaeLSR6q35qffcZvVg7DdR0eoXjXgedkq6Nj7MmkmefKXNsXx5Z64x
 yBIYQ2SNvV+zoKlmVUL40OgztfefqAl0ROpetZ8O7dHzWyfg+YYEIT2UWw+/89D9PSKZe8wjgIw
 U6c3UYk7lsiYmMzFjAr35Xg8oFnRpqJB7tPNbiCGyrKNvA+MzT95qBeR/51NDtBw6MKYGqjCKrb
 TgcfGWJgxe2GFKhvK91sPaVe7ddIDufaeZXc/RYeKeFiE/TjgtiqEcYMdIyNbEXvvmLAHWQrLc2
 ge20miggO9QOtqe3Bkgxx7fCSF9wR4Ddx2xzS9IZ5sl75QQ/BgSjQV1aEaMGhIzbOac/XtxCEbn
 fde9vx+OVraduusYGdA==
X-Proofpoint-ORIG-GUID: y7Ze6gboc_J6muPHE-DbfPT85hUlJprm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-24_01,2026-11-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 clxscore=1011 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611240042

Add qcom,seca-trng compatible string for the True Random Number
Generator on the Qualcomm Seca SoC.

Signed-off-by: Yadu M G <yadu.mg@oss.qualcomm.com>
---
The Seca SoC device tree using this compatible will be posted as a
separate series.

This series was prepared with help from an AI coding assistant
(Claude). It assisted with review on the device tree, bindings and
driver (formatting and alignment fixes), rewording commit messages,
and running the validation steps (checkpatch, dt_binding_check,
dtbs_check and W=1 builds). All changes were reviewed and tested on the
Seca Ride board.
---
 Documentation/devicetree/bindings/crypto/qcom,prng.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
index de323969fe64..cec847c52f8e 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
@@ -31,6 +31,7 @@ properties:
               - qcom,sa8255p-trng
               - qcom,sa8775p-trng
               - qcom,sc7280-trng
+              - qcom,seca-trng
               - qcom,shikra-trng
               - qcom,sm8450-trng
               - qcom,sm8550-trng

base-commit: 3191063649dbf7c0d0b768e1f3655e4c5fc6edb5
-- 
2.43.0

