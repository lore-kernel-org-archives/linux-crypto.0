Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC77202F71
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 01:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777253001; cv=none; b=Cn0L0fP+KJKqKln9zmVyjZ0T9Or2sx6d87G0MXUkQMym1INwIKVZgufPbew+kpCxPnhgX3O56LXgi2Y2aF6R62a2sPJvNmFWILP81+i3/iywW4nIo03z/yUnB2F0pOVmhq9FEgGM3FsckgL3lAdkb7fWu61Ckk++STHOYTO2FkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777253001; c=relaxed/simple;
	bh=RwUlsANaBFXtku4Hox77+wBjC6p9hBm/pNBdSarue+E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=f5tvBR56sZwDD0s/LvpPLAOt8y0dx6vfVEEJ+6i08P/1M0cS9W4pIzuJ96q19SYC5Ocfn2RutogN174YrqcIS8625pdhpNeMbgbyYzjPDdyY2RjFcebMmyu6e0gclsO7wn07MJPJl9XLFs1uKacHELyq70eCDtEvVo7UYg8YgeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=XvAezRej; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=UyosXoNi; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="XvAezRej";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="UyosXoNi"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63QJqjDJ2046186
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 01:23:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=M9VKi5gQKjWc8ADbuosgGzXfdXz2HHxk6n6
	LzkIjytA=; b=XvAezRejzCv62VbmCX6IMqEFoxa7F/x+oMdrAHJ4D5wnQaeta8U
	rFnF3eg1+x97kNk7QEggmO+TvWPDw9JEZc1IW5WxaXVFsB1LJ28GHFNu2P6oNM3b
	edWpUtwBtcPGRNwa1u3fyz1ECDT6gveXvfzA1AtK2/5Jc6v5tAcNBr33CprfamTy
	0vhcTOcihNBobYAAIVgwai8w30E/Kz/zeBsKkYuEqAD2flQwANFXZb6U1sGmlf/B
	UJwLx2BLshLZpZ+vv+BMRzZ8gFawFfFCa3lcbIYMFMBi7m7yeOCsmgF/3jf/u+7X
	XmqIUmjo6+2KRkr64aOMjQhu6Waf4wRcfPw==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4drp07kwgj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 01:23:18 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-2ba9a744f7dso12518433eec.0
        for <linux-crypto@vger.kernel.org>; Sun, 26 Apr 2026 18:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777252998; x=1777857798; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=M9VKi5gQKjWc8ADbuosgGzXfdXz2HHxk6n6LzkIjytA=;
        b=UyosXoNiMBMNRipRl+t+ELTrCWeaBSsv6Gdk3NPCTJgc7Xk3hy20bh4fkmXcXBrHEy
         C/0/wZdL5CVRIkrD34UGVkGgcjptNT1tt07Ry4EUCZbCgLm7gVrzQRJFV5CBjK+hhCqN
         31xpvcFBAzC+H8Oe0c1PBp21N4AGby9qRKrDr+q6T1HiF+yWSTyjDZRO0CWk8RJeLcPr
         65r3+5h7PP70aGMrjKv/s1yUtPMERcvT7+629L1lSnAwBNeVkv1tIqwquvT0JdZWm66k
         WWtSQEC059wupJaDqcugVX2yW7mngCRb2ISJ+4k9gcP7LAHAfKa4m6CsMIvsg6rPm0in
         wUKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777252998; x=1777857798;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M9VKi5gQKjWc8ADbuosgGzXfdXz2HHxk6n6LzkIjytA=;
        b=gyV6ow5gdYaHpRa+vqek4aUiVYWRqfAj1BZ4bcmnSGilQm9BPcbXVmihLuuBt0flUs
         wrx1J2dhGF2h3XwxD11/n0eASW/nvmtjysGApXLSWzuGDfWYvlX4fWGkjoGED6+1uKaH
         gncz8MPh6JUGsyWcZ5bknk94Py0rGJgDpyPfJmr7AEDnrtz3PYQpFPfrg2VlHlBVchzS
         w/LPu8MRBgDuTlC/eLxxPWzFsvZ3aKwL0ag8+A5WXHBONg8NvUQx6jay9/Tv2KQUF06Z
         w9tgQvhNUMpvU/VWPE1yE9N13WUqwhr5sdbLQ1y707wN6qPIN3Tflxh0Vt4ronupqv74
         1y1w==
X-Forwarded-Encrypted: i=1; AFNElJ/eGVJlD9pFaJrgF+cFzfxrF7twPcI0K2WNFkdIIv+qcSVksjgb9OhO+W0ttZAlIP9RYr91Mn7y5h9aQmk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIYEeRJ3lnbmMIm7Vp4IPAZfJHRtf3M32GG/orQOFh97/XBLoN
	TkAqm00FGQ9xkX6Zosw+oQtJm1wZpmkyyes87BdPyvsOGWjg6NhjbRQuqP2rtD4iJTVRPtFoO/P
	pyaog9lU/GvqOEMH5JaPIF/Ea1+R7JEnN0zNT5/HKnvcPH6dpemaZkUfd5e0zSC1m890=
X-Gm-Gg: AeBDietFMpPmCwjNXbla9zsI/bibTD6GPPrWOs0x56DK10LXDWdPTOKFJ4JuRLHBMm6
	DTAFb8ijsQZ7hyO4rieTz3OQK7kvb9eP2DsZUNXZkgzQnYt0aOoNikWhqEPA0fexQfqvoN8uo2D
	Vryjw2N63Z+T1QI1OCnBNxNhDXgzLeQQBXR/18G3I1HkP9hmrtj5pn+eIgtNnjTsLpKfnAK13e3
	K9vOaMdcpnqYtl6LW8dC/c4QI3nau3+Ph7o41nTlbsxSw2lXQ8Kb5lWqKBREBOVBBAMdxg/FZfO
	+vmFOMpCUgLn76dYykCAmLllsQLwVCgg3VdiNf9Sw6QE+zkF7d5zK6b5T3HIgsRq+JJQ5TtO0/6
	rlNIprH/CqunaYhep+X3ccfqHqRXqh/A7ujil0sTEp0S+dwlRodDJRGIdnOYh9De2I/PXnlxs5W
	NTN2EpQly/t3GdYEN6
X-Received: by 2002:a05:7300:fb91:b0:2dd:2d70:8aba with SMTP id 5a478bee46e88-2e464ea4fa6mr19533483eec.4.1777252997848;
        Sun, 26 Apr 2026 18:23:17 -0700 (PDT)
X-Received: by 2002:a05:7300:fb91:b0:2dd:2d70:8aba with SMTP id 5a478bee46e88-2e464ea4fa6mr19533471eec.4.1777252997342;
        Sun, 26 Apr 2026 18:23:17 -0700 (PDT)
Received: from QCOM-aGQu4IUr3Y.qualcomm.com (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2e53d2ce98csm40117714eec.20.2026.04.26.18.23.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 18:23:17 -0700 (PDT)
From: Shawn Guo <shengchao.guo@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <lumag@kernel.org>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shengchao.guo@oss.qualcomm.com>
Subject: [PATCH v2] dt-bindings: crypto: qcom,prng: Document TRNG on Nord SoC
Date: Mon, 27 Apr 2026 09:23:08 +0800
Message-ID: <20260427012308.231350-1-shengchao.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=K8QS2SWI c=1 sm=1 tr=0 ts=69eeba86 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=XbqZqKjfuBx2QgKHZ0cA:9 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-ORIG-GUID: Z9FEFvNAXsUrIjA1GSFUR48mMDi-XvRi
X-Proofpoint-GUID: Z9FEFvNAXsUrIjA1GSFUR48mMDi-XvRi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI3MDAxMiBTYWx0ZWRfX9e5+B77IH87C
 RgqjVbOX6hGR+k7ORTZjIoUVUz134gKnUamFRnrKRsnM+GTvmCE/lw65zUvufHCmLk2uQd/bOSp
 Vv4XOT+HqJLdYf0VlCASIn8Tf1dDyhBIDxuPAC+rFwEUnPoJNUf9/kGSs+HGmldfz7oupIy1Iyo
 az9WWsyigercIFHVjrmx9leQYNN/jgxqMlD1FZn9xh95bO/UwbTl/EZbEN3SBDlzmbI4KdJw/GX
 URM/Lnaw2R2J2YBrnrWOSWvg/gIxmTO9nKNqQBtPbPSmxstARW5v9+EnA2mgoI/ZMq0wZHmLsag
 0wZ3f7nlWqJoB+tuT/2FaLmGtPxk/AmhZn3oud6TdHRJGXXVg9N2LjUrh26wkCky7xo7QxvvQ0l
 VqhH4AhMmYGN8o9uhmYM6rId7kFVwUju1gFRnlWUMDLza9dhK13/d21jB18Wru1iqqrRE2c2eY9
 CTEBxv+hzkLAbOnHF0g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-26_07,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 spamscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604270012

From: Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>

Document True Random Number Generator on Qualcomm  Nord SoC which is
compatible with 'qcom,trng'.

Signed-off-by: Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>
Signed-off-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
---
Changes in v2:
 - Improve commit log to make the compatibility explicit
 - Add missing SoB
 - Link to v1: https://lore.kernel.org/all/20260420025732.1240525-1-shengchao.guo@oss.qualcomm.com/

 Documentation/devicetree/bindings/crypto/qcom,prng.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
index 41402599e9ab..1362a8b748a7 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
@@ -22,6 +22,7 @@ properties:
               - qcom,ipq9574-trng
               - qcom,kaanapali-trng
               - qcom,milos-trng
+              - qcom,nord-trng
               - qcom,qcs615-trng
               - qcom,qcs8300-trng
               - qcom,sa8255p-trng
-- 
2.43.0

