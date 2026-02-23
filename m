Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976E834D4F3
	for <linux-crypto@vger.kernel.org>; Mon, 23 Feb 2026 08:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771836249; cv=none; b=RCOW9jIumzo5QhpIW5RfCn4RGpb+1dxsWSUrL+kuHztm87Kznp6+gf2JwG4+tb6D9kniN5MVUmYcQYLn41bKe0dWjnW0ElUMW6q+ZeUm/eRvNNFgR3edfgixoBDMy943SlaaB/5obSL0IedTI2De3i3Vx5ngHDv47M2cplUEUsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771836249; c=relaxed/simple;
	bh=l0NUEqUabNPdVM+rlL5agqJ9dzPkcfqJ9SIWSZl452s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=EOBSUkou4kvlhFkvjQKp6sJLK/uwnXzxrTJtS3IbcRHTdFzIi6Lq0PdnUoYv9JeCae7TS+htyVycv5ducN5dNbCrGhA38B+xfzxfsTkrJ0Gi5RNgIjxuHYYgC0zqqlBaQKrHR1hjIoZMGw2E+j//MmrrmWrBnAFR0y+8B8VtmTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=So3VXALr; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YzZbDnE5; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="So3VXALr";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YzZbDnE5"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61MKamFM3337870
	for <linux-crypto@vger.kernel.org>; Mon, 23 Feb 2026 08:44:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=oQIOwrcGQ8qBhtXhbGooTx
	l6RJ9Obgaxb9T1JxiZBoA=; b=So3VXALroVKBTSYL54w7waFCZZSoT9Sj+DOeZZ
	SFrhN+i2RnLkJR5WsslkqMg+6UkhenfmdkHYfpgvJybCjSDkOQdgXJJY/fhgUToc
	bMiFpMv3lWOxe8yBRp4XQb7vehrVoWvLcPWeS+tpiWJ6m3Mpj4eGI3i+/t2KYszW
	Bde6nTv+yW+GDl8HlCiZkFb+hM6DLAhTGZtEqxANqdWyOJHGS8rkzmmRRYowGEw1
	Iv9KePa0kOFCGIJwhKys/gb61+sog9kqS04Tb6cqBgojAo0yDPDKOLL4I9GxYy7c
	tcHqkFvsxsMf1B614pjoP4fZJdCGS4Nq92Xm+e8wmkkztztQ==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cf5u8m03w-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 23 Feb 2026 08:44:07 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8cb3b6b37d8so3765514285a.3
        for <linux-crypto@vger.kernel.org>; Mon, 23 Feb 2026 00:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1771836247; x=1772441047; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oQIOwrcGQ8qBhtXhbGooTxl6RJ9Obgaxb9T1JxiZBoA=;
        b=YzZbDnE5+pWcPYfNUCdJ6ZJrftvm+QrfrIlHaIcqzqzqn6sapc4sJflsNrNGiGAm9e
         jjmJ/6UXRBMkwgI07EV+riMHlJYdEvI7XRywXLHmMJ4BRnWl1P5Q+WPFamctcJex4dHN
         JEIJ1QVgVDZBuJePorZZWEi7IsXlZHp8uiU62h93M/K7bSY5weMKgnpYp8JMqrBBef8i
         3GVLtDGEbQTARJNQ0JKvOk8HgMUopTnY1PkW7feYDjLQfIZPdtZQ14JRIgFomQZ0YbsS
         kQhNF5GPaIoyXmxTZKIuQfQ7R/4gDy0gBezAaZLPX41H6thxdvzivcM00egpVTVyJQOJ
         6UUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771836247; x=1772441047;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oQIOwrcGQ8qBhtXhbGooTxl6RJ9Obgaxb9T1JxiZBoA=;
        b=QIOr2l0kv75VoXaplaOu8b291ZiP+CfVZ2iWN//j8cis4Vl/DLZi65ocVLHuM8rNIW
         jllvQ5y89guQxXId4abHNl5+Rn9mGFkiZ/CfAY6pSo6dTvR+wgbDlIxBwW7RFmAC52Je
         iE/1/r4PNrm3NfTOWLy18Ltm6op8PQMc9hK9RK2PYsl30Lx32cfeRhWToFu9SkYwQDkR
         id5Mm3RW5VGl/8twBxvWvZhtGlfFgOtNG1eb9CNAUxJFChpPoUxQR+ejr7h86nQevEWn
         oeNm4rpkPcvGR5yKSajl7LI9jBEmWnKYUQt91d3JcM2W9+J1rRblGVtFTX6AqlNRl/wH
         r06w==
X-Forwarded-Encrypted: i=1; AJvYcCXMg14txppOSdEVcPXcgR+tMWMMEwt6Tb22N3zioKhFCWWyZKL1NA56AsYGwUMKGnCayZdR0C1xcTQ023o=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdsxUKUI9CYwnmH2S3JrdS0f26HMaNUM17zLD3cgzVp0UNnwPc
	eZPtV9b7VtQFU44GmlATx71vIGS8lmBkkWxP7x8U32d77Cd6TBxSZYXpdzGMCRht7dvYwAmW5MI
	OIPxY4c8NDcWAGX7Tbo0KysA5jKBR8oxzRlxKCmTromisbDipNZPc4uARuuAbWXfbQxofQl0vh/
	g=
X-Gm-Gg: AZuq6aINfvI276uAqroldmnL8w6x3FJ1sY01xzLPDt5uEr1/+ibbmmxYx9/JHHdt3zV
	qfiSe1mVy1fcZw6ain5420nabSidUcCbxf8aJe3LdEVmI9ZepOmorAFuwYpENuJ0GiBkLpc0mnC
	sHzy4yHaGd6FNPR2YLXDeFFumnJxrD0yaOWJisJzD6ttRixUYWWxA4y+Vg7cplIRokgo/qk3qkV
	PQZhH3uJ9Z9S1ly307USnc21IFimJ8+NGfdzwIrVRe+tNr3ncQsCtFGi+eQEw9KPvU8xt1WjZH2
	KqNsMDITegBs8i3jW0eZmYPpUdLPO99tvHuwHvnfFyxMIl6frqPLjsjtvbTWS/N1j3RI2TPdgrI
	noaKJze3sEQWnq4kNmOnyswTz3aoT6A==
X-Received: by 2002:a05:620a:414e:b0:8b2:dcde:b668 with SMTP id af79cd13be357-8cb8ca8376emr1050114785a.62.1771836246752;
        Mon, 23 Feb 2026 00:44:06 -0800 (PST)
X-Received: by 2002:a05:620a:414e:b0:8b2:dcde:b668 with SMTP id af79cd13be357-8cb8ca8376emr1050111985a.62.1771836246143;
        Mon, 23 Feb 2026 00:44:06 -0800 (PST)
Received: from hackbox.lan ([86.121.162.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483a42eb88fsm78903515e9.13.2026.02.23.00.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 00:44:05 -0800 (PST)
From: Abel Vesa <abel.vesa@oss.qualcomm.com>
Date: Mon, 23 Feb 2026 10:44:02 +0200
Subject: [PATCH] dt-bindings: crypto: qcom,inline-crypto-engine: Document
 the Eliza ICE
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260223-eliza-bindings-crypto-ice-v1-1-fc76c1a5adce@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAFETnGkC/yXMSwrCQBBF0a2EGlvQKTCgWxEH/XmJJdIJXTGoI
 XtPq8MzuHclQ1EYnZuVChY1HXNFe2go3nwewJqqSZx0TkQYD/14DpqT5sE4lvc0j6wRjBR8G47
 uhNBT7aeCXl+/9+X6tz3DHXH+DmnbdrgXaNt9AAAA
X-Change-ID: 20260222-eliza-bindings-crypto-ice-edba1b509ebf
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Abel Vesa <abel.vesa@oss.qualcomm.com>
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=1051;
 i=abel.vesa@oss.qualcomm.com; h=from:subject:message-id;
 bh=l0NUEqUabNPdVM+rlL5agqJ9dzPkcfqJ9SIWSZl452s=;
 b=owEBbQKS/ZANAwAKARtfRMkAlRVWAcsmYgBpnBNTv+ijFnT4Ba1wnAyCCSWuK6TseluhbYTA/
 tBRdZYTv52JAjMEAAEKAB0WIQRO8+4RTnqPKsqn0bgbX0TJAJUVVgUCaZwTUwAKCRAbX0TJAJUV
 VkRHD/9iqJaL9H1tDX413m6xlUP48QU7WxFvlI2gsyVREZDGkAVbFL/FsySHvg2VcRV/OzIUnl4
 HRXHQBQSOU/xq1wMGUbxmhMkQCWV18VAB+fLNUcGFUk941Y/aBWzAeJo//7jfyHamRcXxxU7Fr+
 Y2++EnpqFi6lCI6bTwC2ZhOudXgNgdjjk10ESOLWxilNc5rNa4Mzfa3zQQnauRqJB0loE4OFC6O
 A/Cygd1b0jy3EFC4IzPodV9QEsuAJesWgvYqzKsayOhvvJfK632o2RdyArZ1oi0SvbkJo9zfMBV
 Ya175HV0+7fwOQhFJzpAz5xmgt4Sok27hy59Of0Gn/HbPlv3ilrJfDdriW6AKcpwoYmpRy4+Mzs
 hPEirAFIDFzwSbTLok2Igj1VDL9eNX/yGF81TN+NdcjZ6puKZnmI6gnNAwxsp+ucQG5swBHaGVN
 BZz8pwBeEZbmKM8adFZ/wFVjrs5sVeC9vpDeGs8AeaHG+6dKiDCkCITJ2ztCBU7+V8NxRN1FiMP
 O4fYcNp6K+xwWKf6DGVOYNHnDRexrpGAYLIydaCgv4iydqjl/aDD9KQTdIXRBrinLh6/nM9yyps
 Cy2sLyPb/N4lVLcPWSSblIRRXhw4IHP/7ekhwkTuzPOkxA/08f1pgsB5qAxfxnJf9sKju8/K+dQ
 iwz3HDg4CucO1MQ==
X-Developer-Key: i=abel.vesa@oss.qualcomm.com; a=openpgp;
 fpr=6AFF162D57F4223A8770EF5AF7BF214136F41FAE
X-Proofpoint-GUID: iYxepfLvqHyKffIsP6IJQMGij8PBeMNc
X-Authority-Analysis: v=2.4 cv=cJftc1eN c=1 sm=1 tr=0 ts=699c1357 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=oauzzCmhM186DRC0Y2yWPg==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=XZyRfS9EP96v5w_HMt4A:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-ORIG-GUID: iYxepfLvqHyKffIsP6IJQMGij8PBeMNc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjIzMDA3NiBTYWx0ZWRfX30F5f2dIgPUV
 Vh+SsfQxppCDPFvKO5sU+ftv28UbH/kDd/rlIvGdYAO5IKM9FnU//8ivrTGdcGoeXmgf3kTd/bf
 jIfMI0BKsgeI4Qw020AnH4SqjtW9OOi/LTxCnI5i5argnqASzhyDFvxrcXe4sI/fbWQeqQHZHba
 dTFuXwBRnmjEZj0rjTjEi57tiuX3UHwkBJSdQMKqrvJhnk/Q67Q21he+HKdszpK3HD4Fkby3SUh
 WTm5Aytdp2vbu9i1R3gvAeLYzfrQGovKN0DD43Ch8j8vWX6vMQvZRtrccF6CZ/73wjuBnHtzf4C
 1nxtzZ/xzPRUEu4FTL98QQiN3n4UWhpb5Q2hTqFFxe7IMIBohMxZmJa9loBTY7zjvulpi1JY1DX
 w7M21U/1OrgulKKYV97yLK9NLIKR2YurQhLCUU0G6Cedv8RTO+vlt3mRQAn3EoT7Q59GeLVVWq0
 YJfb3nWmMJBscyWsgYA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-23_01,2026-02-20_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 clxscore=1015 malwarescore=0 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 phishscore=0 impostorscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2602230076

Document the Inline Crypto Engine (ICE) on the Eliza platform.

Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index 061ff718b23d..d88db7e1cbf4 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -13,6 +13,7 @@ properties:
   compatible:
     items:
       - enum:
+          - qcom,eliza-inline-crypto-engine
           - qcom,kaanapali-inline-crypto-engine
           - qcom,milos-inline-crypto-engine
           - qcom,qcs8300-inline-crypto-engine

---
base-commit: 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
change-id: 20260222-eliza-bindings-crypto-ice-edba1b509ebf

Best regards,
--  
Abel Vesa <abel.vesa@oss.qualcomm.com>

