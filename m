Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57DD328B66
	for <linux-crypto@vger.kernel.org>; Wed, 29 Oct 2025 08:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761726345; cv=none; b=hFSWMvqaImFuCz5VoBWgyf9Wg+mNNhWeg2WYbo51Qw+EhcMRYQSRuYecLlbMJ6SR/+iaoZafYvvfbsKbuoLMjaI8TxgLSqfZE9S8s0yWWc7/T78IrvcvLUb6QDHLs69XCQI51+7rR4JF+onMF6plnBXPgOwaBTt+TDW3cGBd/CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761726345; c=relaxed/simple;
	bh=QfKV/d3gO6255Bq1Gu06XBIiBSg6d1J1BVCrin6ruxc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BroHqQe3lfB0XWz34545UayQ0DYokQ8X8mPNenHeABVqntaHxS3wacSbm8bAWzbyYBj3wiL43JVjKPK12M6L2P54Gi/7yNVkovtljP9swn0pUwcebUnkASAxjlLpZ6/7M1H0b/5MYG9lWD4Wzc0P4wL55O+8K1q+6qT6gQc2NdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=XWqjNbzG; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=hCD7E0ZL; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="XWqjNbzG";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="hCD7E0ZL"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59T4utBB3692118
	for <linux-crypto@vger.kernel.org>; Wed, 29 Oct 2025 08:25:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	SI7h/T2Ai3eUH9gaMcsEZ021ub3ZOvaSkx7DIHf6TpA=; b=XWqjNbzGgmJ4xvdH
	c5/tMCN3UpRvxy+fidtNzDT6dLfLCjSFnl4d+tOkl4vqRF4ZzexTxy+BPiNfwURS
	sAn7MKbanL6dwN2FSVrjJT6SilU3guIVsmyOkELPUtdBgviGV/9VDAqxu3iTT5d1
	vbaOYhsepaPIH7suMUXUgqwtT/G55tw6BraHqbhJx4UfVxWdhyMH3J5WPHo6jF0b
	Ym4zlH3ozFCmVY7TAUGVqUX/pOtxQxhVxbJRnfBIXK3JKH82r1u0UAq7aiUZbm32
	r+pyuko4qu0EXT8oEoAdXi9xDXjJHPQtJqRcJpxSloOqxv+1/OMG7ZmZ8PS3wCMa
	zvgqvw==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4a34a2hsax-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 29 Oct 2025 08:25:41 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-7a2743995b2so11518047b3a.3
        for <linux-crypto@vger.kernel.org>; Wed, 29 Oct 2025 01:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1761726341; x=1762331141; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SI7h/T2Ai3eUH9gaMcsEZ021ub3ZOvaSkx7DIHf6TpA=;
        b=hCD7E0ZLneFnZRm/uyt3jNoL+q61WCVQhJBszkvgDj145DPpx471qmaXIs2lrTdKEE
         nSKtco2mareYiCgXft7AhjGR/r37U6hgM6yS00gX5TvY2QKl984iYrlSQHhMG8PIlW5B
         EWS602q7EwBSY81uB2IQOtJO/dwD0aKtjDW4GN6oGp8VUJpIc8Wy3jYqR/uE7U8aps6D
         pVSNXJ+AhpZeclMErfi/jW1/6rKDEnOOk1gSNDa8xf1YiLpeAWFOkTH1+kGPdUHO4Pv/
         KeQYzl51exlrFiNsKaX3YhbNUWIXt8igE0SvaJXupJD+3X4XHKDrcFsRfMJ+s50NWAnY
         j4PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761726341; x=1762331141;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SI7h/T2Ai3eUH9gaMcsEZ021ub3ZOvaSkx7DIHf6TpA=;
        b=jmCqKUXTAlcKmQ0AbToDcIRpWqBupJZNDEBQkl2efonJC5VN01TVAddX6cg892zMWr
         T2ajLYNI1q6srr353Bmziou4krF+RtLI4HXPN56KagETT4pa7PXx79fK2nvRX1fusZj6
         t/QsOGRGzQiNURRHpQrzbZvRb3iUtm0qKmAdZz8csLQ+BoWk/9fOqnyazd4P/ebBOCO7
         m4TWcWtzIMqa03dae8I6FUyAP0kjY+DbMvtsMeX7bZkaleDNyX4LzaQjES8wVbQw6C8o
         Df3KeE8/Z3JgfHYxX+RFGw0XbLOVnZoIwhwZOE+wP84D5bnjsXj1fxCTZwC7IZksc+zg
         mv1A==
X-Forwarded-Encrypted: i=1; AJvYcCUTl12xJ5/9bQYLRKJFwYmHvBmCacasf6gkfzjf4kEYapCAEXwGI6Edz+R9bQGCc/Qa8q9YdIeQlBIozEk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxc9yu/V0DO7XBxXnKPIuDJ3HOzk2yr4UoZnmW59So/plAAAome
	TQmpOgUbr6McLLisVc8qnwvKHR8kkJxUdR71LezOc/6V3B9Ar6EkblxHqFNDr5nPg2yqe7IFm2H
	51Fynk4Ls14v9i3b2P2CHaZdazwx+iflSqyc4nQjwuhA04CHCjgmhgfiDuWJpPq4FzHY=
X-Gm-Gg: ASbGncuq9MQKbbkCCX+U8aLE2YEw1Dkod8YGJHAKeVEoQiPQddGFV1v55AhiEAmDHnS
	TtiCpoi7tiCOyQZgfzTTnP9rWRSCLAwRIWGbMRemzGGrGU29cxIkYmX8Ta2t1BLnP/ZzuWUNiLb
	OhIcHr7kWd1C+mTPR+gqzVXFxxid8TsRA3Wi1ZTboJ2ZUT7Snbla+wmsxDm0h/imeqlvX7mp30D
	1jMHFzc42AUKHmZl7C+YjqjhlCXfcerO6sZN6+bTU2v+toaCcJ35TGYgU6zlam60WAJtLq1+h40
	yfx6j+Gv3Lz46NUdvtVbn+pvtIN3FlYVdCT6BNJx6qFP7ZU3nYOCtjd3zN07IF7tOE1j8Cw5V9R
	mT+x5jfVvhWhwZFQ7HsUneezRO7VTC8biMhCjZfqRmOWYfLz4tA==
X-Received: by 2002:a05:6a00:17a1:b0:7a2:6b48:535f with SMTP id d2e1a72fcca58-7a4e31d80c4mr3183284b3a.12.1761726340702;
        Wed, 29 Oct 2025 01:25:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEdWUMfoQSftVn+lusAOnm02Ws2xPYh2EYrN1Mtd4aD6Wz0CNiia1asitR9I0WSYSAKCYnvSg==
X-Received: by 2002:a05:6a00:17a1:b0:7a2:6b48:535f with SMTP id d2e1a72fcca58-7a4e31d80c4mr3183249b3a.12.1761726340191;
        Wed, 29 Oct 2025 01:25:40 -0700 (PDT)
Received: from hu-jingyw-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a414049a44sm14158850b3a.35.2025.10.29.01.25.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 01:25:39 -0700 (PDT)
From: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
Date: Wed, 29 Oct 2025 01:25:31 -0700
Subject: [PATCH v2 3/3] crypto: qce: fix version check
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251029-knp-crypto-v2-3-b109a22da4f7@oss.qualcomm.com>
References: <20251029-knp-crypto-v2-0-b109a22da4f7@oss.qualcomm.com>
In-Reply-To: <20251029-knp-crypto-v2-0-b109a22da4f7@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: aiqun.yu@oss.qualcomm.com, tingwei.zhang@oss.qualcomm.com,
        trilok.soni@oss.qualcomm.com, yijie.yang@oss.qualcomm.com,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jingyi Wang <jingyi.wang@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>
X-Mailer: b4 0.15-dev-99b12
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761726334; l=1130;
 i=jingyi.wang@oss.qualcomm.com; s=20250911; h=from:subject:message-id;
 bh=omxST5DmfZwYu9h7SFMilfhE7adNC9B84PnqeP5dI6k=;
 b=0Yz0fbgUYPu256QnGv2gWtF6KiZ29fOV4bqnOkX3ltZi8omk1/WNEEktvwo5X5aVDYjd/sNil
 i6nBblXUZhvCi32cKd38ep3NI2ef4EiQ9fZekY42hyTLtNd5T7UQaea
X-Developer-Key: i=jingyi.wang@oss.qualcomm.com; a=ed25519;
 pk=PSoHZ6KbUss3IW8FPRVMHMK0Jkkr/jV347mBYJO3iLo=
X-Proofpoint-GUID: lvsopcqTzEQT58jARPd111PR0fHe4VPA
X-Proofpoint-ORIG-GUID: lvsopcqTzEQT58jARPd111PR0fHe4VPA
X-Authority-Analysis: v=2.4 cv=PcvyRyhd c=1 sm=1 tr=0 ts=6901cf85 cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=7enFwbqk3NRG6xSZt3cA:9
 a=QEXdDO2ut3YA:10 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI5MDA2MSBTYWx0ZWRfXwhWgf1XTHw6R
 2heCBKH88RagfhA/mwiXQUuhTJE8lArb4Bchn8ylQo8J90o8Y+SkrUpdSRvWtJt2ONxNZ9wUC5m
 ay1Q9osLb+egnI9hlg+U0jLzI5SGLl5UXa81GH6gPDkR6PK8DMiUz3uWV5NGndo77eN913HybBR
 5tL7CaLa5iYdqBhKHUiJPp87Dz7y2X7i/QfEPFuZbI8oNAsO/8M/l/4Nr9o7Wmi3mswl43ozEoB
 plinjDvN+XIlXYgQ7EdnjQwnIh41Evt8uu8a/dYcVsSwcg9OpIFLZ7G8llyoCJKi7APMwdYO26H
 y2lz9ehxTe4TSFwRfgdNNu/hU4JGPzinjFvPCfySMzToDB/CCqCQvYFsmt1R3J0VDdHO8tfHf4V
 b4Dqr0kNaid4/4qBLUr3ieQYQSeK5Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-29_03,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 spamscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 suspectscore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2510290061

From: Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>

The previous version check made it difficult to support newer major
versions (e.g., v6.0) without adding extra checks/macros. Update the
logic to only reject v5.0 and allow future versions without additional
changes.

Signed-off-by: Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>
Signed-off-by: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
---
 drivers/crypto/qce/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index e95e84486d9a..b966f3365b7d 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -21,7 +21,6 @@
 #include "sha.h"
 #include "aead.h"
 
-#define QCE_MAJOR_VERSION5	0x05
 #define QCE_QUEUE_LENGTH	1
 
 #define QCE_DEFAULT_MEM_BANDWIDTH	393600
@@ -161,7 +160,7 @@ static int qce_check_version(struct qce_device *qce)
 	 * the driver does not support v5 with minor 0 because it has special
 	 * alignment requirements.
 	 */
-	if (major != QCE_MAJOR_VERSION5 || minor == 0)
+	if (major == 5 && minor == 0)
 		return -ENODEV;
 
 	qce->burst_size = QCE_BAM_BURST_SIZE;

-- 
2.25.1

