Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7100F3C9881
	for <linux-crypto@vger.kernel.org>; Tue,  9 Jun 2026 09:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780996154; cv=none; b=HPGYjN8/aFuY+ArNJTMlt3a/Bcu1a6GI6AgsmLF2ukDSF+1vLmpXuOGcGCkiAADwkR0WuJEzueMQGKgfIrTv77Qy+vnPvmOppwftWxqzXnqWw8uXAu3ek9zDl35HsjQmAyeVLm4DEj27M4Ypp6hoDCxQBpWncjiamv6K0mG2tOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780996154; c=relaxed/simple;
	bh=qkD7hfP5GdrLokwUs4o0VJbAwr0oen558Kmn380Nmbg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FUVZoUAki5i5O5jsZqc1tgARnsqX9groNsRzzhgtm528i9gSWhCP8c/fEiLHDAil2YKTIe7YQlPcIhcimxb8eTTNyOJWOB8LwgDdDinsUcNlHK39bE7iPLxeKZipdlhC6VZPPc7In2uDkHyMXk8xy+BfgwImiduixWvqMSmyJFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=anjuNBD4; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=KlJhd0sN; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="anjuNBD4";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="KlJhd0sN"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65985SLk006855
	for <linux-crypto@vger.kernel.org>; Tue, 9 Jun 2026 09:09:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	uel7Dn8g9zRhKX5QtlCfVvgluNSy+/SDTRB8bCzSu6Q=; b=anjuNBD42C2wlCUQ
	YhAkT6p7GisTv/V2AdHaY5cdJeTLlNchamE0lQFdv3cGPnf416gHzrEv/66kkHoS
	qUBE+eJTN8VOwQm54OdLP6t/WtYmrw1fhLXE2zI9hlYxhWXfh7vs9z9xnlYVsElZ
	L8EHURrymBTpNy5zq3C5n/6nMAlhFl2f2hq8QlE9ANf7P61Oyeq3duoRWNV/b8+l
	LMkxPhJe0zPBD8g8hXjMbnVEXl5reKbbLZslYqpoRNiSd2bgxXVvyDlkLlpQP02a
	FIy66xjPuUFH71EET0vt+wNeYZOiocNFzl4UiLwIsCI42UceMfpiELh/gPrdrbE6
	nOHgyQ==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4epf0sr8kn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 09 Jun 2026 09:09:12 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-304ea42b025so2831801eec.0
        for <linux-crypto@vger.kernel.org>; Tue, 09 Jun 2026 02:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780996152; x=1781600952; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uel7Dn8g9zRhKX5QtlCfVvgluNSy+/SDTRB8bCzSu6Q=;
        b=KlJhd0sNIOndSkV1m2rWMSj5QewprTndMTPoIS7Gybg3EfWA/FaFyHLZTt243D2V8g
         ipE/MO8+r22yrVQuPxrYb5ls8VbyTFRVWehSV+1NovmJlAVpmSO1zwxij4cQ17iVBFfL
         iSaUTJ2CXlAOo+fkiS27r9qOCM102OxHG2X0Ne9dp0kdymx2XzIjDpLr2Mcf/ZaJuIl2
         7Rw13zI2Rc5PDN4zUSNNuTKItq8PFnEB1CNtyvI5kfpusB6GhcSv+oqXwGMQ9K2U0wTN
         q90OjOwMQy44bmROCaGjjUBtmIZeZrJnsrycX84DhpHN+LwGtQdm5OVq3cUwYnztH1RS
         pCeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780996152; x=1781600952;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uel7Dn8g9zRhKX5QtlCfVvgluNSy+/SDTRB8bCzSu6Q=;
        b=rLx0QpTCR6cnN82ESHbNxvvVscEKJQoMHBlOLzNgc667reEahdTnZXDgpEQ9gfml4x
         qhNA/xBSqfV/BZLmEVJ15TetuMa9ObSt3W/YS5A7gvOgTC2ZnszRYWogFT+lDq5xa2Oe
         COndFPcfp7IUzkPalL+1VcWjaaQaRd++KvhR5xlzxd8SAeYtdfZAf+6TatRJM51WiM0+
         fI3191I6z+bMhUdjOgUjH9ZKXK1wpnsrpYFrsOxJtyL3mpngjjRcGeGkvHFFtxb5Aqjt
         RgKzrcc2F54J0dPywy7bSeeEj/8kFjPjqPODlY0ahVmz10nThRd2NVucnjwq8iCNJA9i
         1AVQ==
X-Forwarded-Encrypted: i=1; AFNElJ++l8G565SrWWvvKGW4VKLtNt8sEq0Mhng+13z0jCmEmvny1HBvO5DiCmVnrlqxRvi2fhkcEStiOHTK3uw=@vger.kernel.org
X-Gm-Message-State: AOJu0YykJSEpACBJU7yqP+O8FoBrt7oXo0+hL2pn7RH4k95mXUQFhb6a
	7uC5kFdfPr4/5LNWFfUOgZqTTBtLpmApelAauNsrV5Oo71sNvwdw2bPj8hmy7l+InNd0yb59aFv
	7ilkzMe1b8PnZBfWx5jKLab8c9CSZqTP+Uhu2efe1vbp2q1D8CvEkP+lv7CyZ17APw1A=
X-Gm-Gg: Acq92OE1k/xy9B7eJScizvhEnA195PRD2xLvHcz9tUGtGosjwUaztWRTg2SR2fKEQ+J
	QVsmA/mhCAe+8dcwzL6cGDj21bCz0WUQO1uTxghIwzMHmXuc9Ji0oRW1caTsuVELpU8b09uDHBD
	i8U2OGX1RMSbyS26IzXriLzxXS4oSxbW1qgReX5DXrrMbDqx+ZV6CqyJOIWu+qBh2oEa6N/xhnS
	ZSqYWm3wsQo38mGVKghesacr562ifHOC7HKy3jUJ0OQiF3pI5yJ2RP7Ml3FxkSYz/Jw67AmuxR5
	te0psFPUJwgdo9SWYL7F4EloGGUUtwo+Aho2XJVh2Jyv/MaYvc4d3YFHsXheajfsE+wwQ9f7dmz
	YpjxZaw0VnYdAY/OiHn87RTzSFY5DCc7fqyoLXU41T63ONmFfE2GeLzu46frl0uXA29I/bE/b74
	haXEpr/R0=
X-Received: by 2002:a05:7300:a887:b0:304:ddc3:2c35 with SMTP id 5a478bee46e88-3077ffb4d52mr8691055eec.10.1780996152187;
        Tue, 09 Jun 2026 02:09:12 -0700 (PDT)
X-Received: by 2002:a05:7300:a887:b0:304:ddc3:2c35 with SMTP id 5a478bee46e88-3077ffb4d52mr8691036eec.10.1780996151726;
        Tue, 09 Jun 2026 02:09:11 -0700 (PDT)
Received: from hu-jingyw-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3074df102a1sm19356606eec.20.2026.06.09.02.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 02:09:11 -0700 (PDT)
From: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
Date: Tue, 09 Jun 2026 02:08:56 -0700
Subject: [PATCH 1/2] dt-bindings: crypto: qcom,prng: Document Maili TRNG
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-maili-crypto-v1-1-0f577df56a61@oss.qualcomm.com>
References: <20260609-maili-crypto-v1-0-0f577df56a61@oss.qualcomm.com>
In-Reply-To: <20260609-maili-crypto-v1-0-0f577df56a61@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1780996150; l=902;
 i=jingyi.wang@oss.qualcomm.com; s=20250911; h=from:subject:message-id;
 bh=qkD7hfP5GdrLokwUs4o0VJbAwr0oen558Kmn380Nmbg=;
 b=eEpItHIskxCiKI3mzi/3Qp/HdOJ5m+DT6L5nVBwhwChSI4HQ7f4spRIMI+hYp+ghURcv9j7Ej
 dd0hdKJFRswAEo8+mbY9ZtwB/zij2OXM4xjZJoe75qF06xED1z33DCk
X-Developer-Key: i=jingyi.wang@oss.qualcomm.com; a=ed25519;
 pk=PSoHZ6KbUss3IW8FPRVMHMK0Jkkr/jV347mBYJO3iLo=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA5MDA4NCBTYWx0ZWRfX754nFEpdiKXK
 FSw/KEnLRKdgcqNQ1CGS/cB49Ka5w1mnEdBdXdeMm81bg7xVkv5tx+7rYtN+6+HVeONgIVGbOP0
 DiYcGhsZEcZV+tyjibzbky4JIBMOZyNBAeBtcjm5HzakiWDBpbzXcsLw2dPF1tRAmVpNmuSmtyJ
 e5Hps+JA/mtl0fSN71RoKY6oCNtrT/7cJbOya9jQrBWthwe7gnrhef551TL5tqwUbpy35qVtQjR
 TE1j4Ww/38xPFsbyqCnky0bkBG5M0Ndle6gdsvZXSiK3R0NQzYk1+1ArsXBoIPTjLrOjDYGwsGX
 6E0vfd+QIGoNj7jQzuPQKXTeTlVc9pWXUjtptUeTSILJbYqn+vMn01lcvOX/EAYyXuoaaNUJwg7
 N3seHY8/NA6bnV15Lox4xTQXGPhkiNEnvy0ZGTwBCq6Pc+X/C76SHePaGxzxd92gmwVYBi/4l1H
 I64PzB0yPfxnwdAkwnA==
X-Proofpoint-ORIG-GUID: r5hQvVx80FSWwnrzrkqA49yD0KOa--Kq
X-Proofpoint-GUID: r5hQvVx80FSWwnrzrkqA49yD0KOa--Kq
X-Authority-Analysis: v=2.4 cv=GeonWwXL c=1 sm=1 tr=0 ts=6a27d838 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=FNAlisUgfRrBHgIoG2YA:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-09_02,2026-06-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 malwarescore=0 clxscore=1011 spamscore=0
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 suspectscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605210000
 definitions=main-2606090084

Maili SoC has the True Random Number Generator (TRNG) which is compatible
with the baseline IP "qcom,trng". Hence, document the compatible as such.

Signed-off-by: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/crypto/qcom,prng.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
index dc270c8aedf3..6116289ec413 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
@@ -23,6 +23,7 @@ properties:
               - qcom,ipq5424-trng
               - qcom,ipq9574-trng
               - qcom,kaanapali-trng
+              - qcom,maili-trng
               - qcom,milos-trng
               - qcom,nord-trng
               - qcom,qcs615-trng

-- 
2.34.1

