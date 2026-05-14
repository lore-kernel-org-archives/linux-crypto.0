Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51D13A7198
	for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 19:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778786641; cv=none; b=lX84/UTPXQ1QqrynfYMRWX3WeDz0pJdWZYvF8q81aiT2TmzKIFyrumWar9hbJ+M8VkgCgy7MH0D9YnpkpDaNUP6JfzG91GSa23h9TKXlNEG05mtrG+jydCqGHSndjoHlpXRQClF1vVJZadoJNfib1RAQTqNqUJGuWR0HzvU073Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778786641; c=relaxed/simple;
	bh=9LHKkuPjIGbAag0Gr5ZhBlMR4hP04+zuByF059wsxsQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Nx3Z3W14AIM1dfHuLpibLE53bugYyXPAPKTlzVzBbgw3AtwAgFAAoegA5AUsKW2v4/ShRTMYWlqSttV5JHJLZ2i3SLlkArwcWB1M7oAzegDxzjmHdb3J6DuHFBALJp8vCa5FP/hvx4nq6c8IAk45hJhpM/LtS7iFnHIW7wkZ5PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ANQTRXlN; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=KVEUprMA; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ANQTRXlN";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="KVEUprMA"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64EIpSKp655515
	for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 19:24:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	CiWOrn7rZILw07irq93/F/Sq8L4fIVklfmaSat301H8=; b=ANQTRXlNQPKI06co
	3TQ6L9DvfJdCIOgUBTILk02Dg7xCJPB/Z7MVWMNSW/POZZN+lX3X+/JnEzMX6mzE
	nNxRISl8zk6CPM3RkT6bM8vHgcfGkKCbUG6yh42gCufZLj7wljU44iaCVZZDZ10d
	OvH+xsnINc6gbzzMf3vuVRnZD4NnA8eV7FaONG6CtGaqmLnnCYWaHx0s3JNR1gyR
	kF0Q1iohqbcDBa9qMt2IpfeZoUpQCvD8ZOXr4ppbd6sN5jZmzAnMYuBS42JmxKZc
	UgVmdO4LBAE/P6c9jLaiNqF7ldozNz9+UBEFqCzJ/AiKJm3QpDLr9lSZ3v08Shnn
	Xcm07g==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e5m1pr3u5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 19:24:00 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2b9fe2d6793so153371205ad.0
        for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 12:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778786639; x=1779391439; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CiWOrn7rZILw07irq93/F/Sq8L4fIVklfmaSat301H8=;
        b=KVEUprMA//syhepRuidKQGOEZcUaA9m0EUl5VZwT0wucBqBIAd4QfqYhnet6Fcvv+p
         waAXbNdpcJ2hl2494XFFbKnnMQgi1MkRuZ7ZsnYIjcvdIa8CVgFpRLOn0bgN1+s8nXo2
         5XXISwR29qPUxWoqS3BCQKiooi8YKhbU2wgciY7suoFCgRgPzRNbWFxdj1l2vnYzMfoz
         Vq7oY+6c27VuSYKrbVqNaA0wkyOlumWrP2C8XH9HxBqVSlqdAxtRJvZcOexW83yRkwcu
         zgUk5gOwS+ZwanS1/i7lgHyGQHCF8tlffELQAwTVwfk8pBL6DGWntF99dJ4Fpcf0a5Yz
         sRVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778786639; x=1779391439;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CiWOrn7rZILw07irq93/F/Sq8L4fIVklfmaSat301H8=;
        b=C2onPThL57t/XTpkaM/pB1SOKidMNUHv65KQz8Bs15n6jBxHLGzHfOY5paPBVLNYtV
         fGMw/a3vgEGnavi7GZDSZPA79bI3eMXfy+lvy/kr3UVbSwb0rYNGJERDoNjnVpXVp5LE
         t1fNWUdI5L14PH3AY4WXOMH2LNLbhzvdADBLKC/s17LJVJBIRS2AfBFWHa9G8ByPAhKF
         mVgFeubiSbf5yxJfNeBwzJpo9JiKCIw4RQl1tTOFxO+/5l8yHZwyIiQFn2kWwvTCBhmm
         cpbkTBV0bUDekROvo5gbJsyD+eK4Z+oqQFCT09zKDn4CsadgnDsK6h65jNh8UEjE5l+V
         9zcw==
X-Forwarded-Encrypted: i=1; AFNElJ/H+tqJgERShzRMzqs2HYC3aPCdoMHFKhyLjMsFWNVpRfmDsQcUns0RU3AzdyoYo8veiF7tz3diM+q4hMg=@vger.kernel.org
X-Gm-Message-State: AOJu0YydpmJmyKiGOKTsxEVgmR1Wcc3rhi4e91mwFmTPlMatBVwX4hGX
	JvvbvdCB7V0SC5Mw0QmyJRUKMSeuGj32gLdcc/4gHROVy6fZelEA60eakwuimIcze1jzOuWdNlQ
	mP7j0DyhhRdqv2CkCn1/BzQ1OxYX+l91ezm/M6wadqlhGTh3yWmeh9AWQhTGrRaRyIOk=
X-Gm-Gg: Acq92OHIYy+k9QQ0wMKZu0QiLbbnLDdyv6cVI6aEqN4RKfhUvnDI2mI8XF0PlD4D8lq
	7UzqqgjwaYJycNbx7NmRob6ldeH3YPH5JE/28/zQoHZIYFhzu2OxJ9cJriPHIlNQjpOMlqJgcRv
	bbYVHYDB/8gaObvcfEsotWRfylxb+Z+TFoBN//iaWhTEgUYHlINcP9vuDdJj3IdMdlTrrdQPOZ0
	spHBAImi6tDHl9zJRAXXN0jlaUvYhsNPKoF7X2HBFqKknUKnHXAfr9jZlIBdebCgPAUi4SUAu+p
	+I7/nL6iCM8S2rnsZKWUn4kdbEC9fKJDnKCleLmB/QuaIpssPUiLtb0CLwxXKNjCjpaLzTFZJao
	p1P+zn6Wt4tjkbctt+3gUMbx7d1Fwjr2Jt07YnY3sP77y9Uxci/oEFPg=
X-Received: by 2002:a17:902:f38e:b0:2b2:4d36:7aa with SMTP id d9443c01a7336-2bd7e8cbc80mr7251555ad.35.1778786639398;
        Thu, 14 May 2026 12:23:59 -0700 (PDT)
X-Received: by 2002:a17:902:f38e:b0:2b2:4d36:7aa with SMTP id d9443c01a7336-2bd7e8cbc80mr7251275ad.35.1778786638895;
        Thu, 14 May 2026 12:23:58 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5bd5f291sm35506535ad.15.2026.05.14.12.23.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 12:23:58 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Fri, 15 May 2026 00:53:36 +0530
Subject: [PATCH 1/3] dt-bindings: crypto: qcom-qce: Document the Shikra
 crypto engine
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260515-shikra_qcrypto-v1-1-80f07b345c29@oss.qualcomm.com>
References: <20260515-shikra_qcrypto-v1-0-80f07b345c29@oss.qualcomm.com>
In-Reply-To: <20260515-shikra_qcrypto-v1-0-80f07b345c29@oss.qualcomm.com>
To: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Frank Li <Frank.Li@kernel.org>, Andy Gross <agross@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
X-Mailer: b4 0.15.1
X-Proofpoint-GUID: oVyFh7JYBYnsFLJ3TJeCWuD9-smkhIno
X-Proofpoint-ORIG-GUID: oVyFh7JYBYnsFLJ3TJeCWuD9-smkhIno
X-Authority-Analysis: v=2.4 cv=GrhyPE1C c=1 sm=1 tr=0 ts=6a062150 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=pQ6rRVY8thx0fpBeU8cA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE0MDE5MyBTYWx0ZWRfX0OZpzVmPHA2n
 9tFdnO2uFcSNV4bZSstg3pAbChtWGV9WKfhcGPP6XxtaW7WTR9edXq3RlwyGRfSyHUJi/QdX7Sz
 pbtndVlYMFYTISfeVYke9rtgKqnvxE0H0e7pCOou2949VMhVG36a/9gJyuo5dOdlF33HxJIRsSx
 fn/ClfPCDLM7B4Xikm0iKDL937HGasONvAsCoHK45c/rdSWv6lIez51yXBHo3kqU7Smcsng67O9
 VGpzkyDnkZLXhqQSNNDxfvHQzrjqUaPyzFMsH2lSGxMKOMeaiSEaYecxSRnhGK1LcCxpkoZFXC3
 Mac/xltyqafNFyxjqLWW8EfoHWS6rUQokFnRjLQPtJHq3Xl2UgS9o+onCc0m2usO3g0BdRCb4gS
 U9FpxEyfFcnQN8A1/1TX7vhr9hc6J5zQyaBD06qSZpl51tN7sbfWrG7wU8v6jh8h6vIF9AFUXDn
 Yd9MTv5yQP8+0cG6tGA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-14_05,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 lowpriorityscore=0 adultscore=0 bulkscore=0
 spamscore=0 suspectscore=0 impostorscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605140193

Document the crypto engine on the Shikra platform.

Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
index 69101cead3bc..ad0e1cd3a76a 100644
--- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
@@ -53,6 +53,7 @@ properties:
               - qcom,qcs8300-qce
               - qcom,sa8775p-qce
               - qcom,sc7280-qce
+              - qcom,shikra-qce
               - qcom,sm6350-qce
               - qcom,sm8250-qce
               - qcom,sm8350-qce

-- 
2.34.1

