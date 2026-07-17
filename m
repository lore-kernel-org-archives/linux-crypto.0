Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887E33E7BB7
	for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 08:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784277433; cv=none; b=Fyd327EzeMCT16JLFMo62CQwli8KzXev6V7wtDcmaz5+KDKKjyrwOiOjrhp/09T2Yl0YGkcG1339LmHylTBV3MLS3uS4ysVyni7xzhHsE/FMxRMOkhq3GvigiJBbp6KN8x7Om+l3m8+PFvZqoGdVXyLVslTfLhGVtAYpSY0TofE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784277433; c=relaxed/simple;
	bh=vuAef0aUBOeSio60r/pSKcTossm3V61GQJlAyMtLfKU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=iWNAGKoOC5/Z2qQHORotW8KsJXNOejAYXaAjpiZl/K2w5qv9fAHrOKdave5uhwdCwAq9qwftTNgjh6QV/XRVFlb2u/FxmZG+vOuQVy7M1zIWbAGKrd+lMjK7C/HRGI9TGwByaJ3mBGzhSGMSvfUNSGSZcQQ2sJ1JlgOzh/YJ/jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=O9JPLqxs; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fZoqGAeu; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="O9JPLqxs";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fZoqGAeu"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66H6cRSX979781
	for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 08:37:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ToTIYJiHy5tONa3lc6dWWbGZLTEc7JJCb/cDS7cr/tE=; b=O9JPLqxsZkCgr197
	M/tpqBmxSAADbhZYhHXVwD3wXMilrw3Fc3ZntwHY/F0coinkqs0D1n0Tu7zw01j/
	U/AGROZ3OBz+Q1x46l7zOboFq7A+e8u7mlxMi2KPpel/urKTPeLYDFb5pnHiOW2q
	ayQP1LY3oFawv/9rp7zBK51fkBLS91O/P325+7APznXmBbve7w41+29L5V9gQQeY
	gUtfBEvWjx64HJBl5x/PYBW8/4W/M9pJ3hjRoI9JMrj3/8EGT2OOZlATfxaOMTE1
	djsfnG0byTLCb6H3U6hfQ9HsT6bcZ0ulCzFV8fnojOHuooUGoyFlj0lM5IUooQ33
	vEK4CA==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fff9grerm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 08:37:10 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-51bfe3fa93bso155110071cf.2
        for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 01:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784277429; x=1784882229; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ToTIYJiHy5tONa3lc6dWWbGZLTEc7JJCb/cDS7cr/tE=;
        b=fZoqGAeubn8m6hVwj3jq3s2P6GZDcKSJtYw6qmTg/VwRc5JXs+e3U9XVLKgoVSe+nY
         BhFjTjlU118jg6GrFatcne6KVtw0owJJGjsA1YvHVokV3lbFEcU31WSk7+wIUDn8wOD3
         vwE4o9lpihi3iUUzIVGA9cRundyEzM6lAtEVqF2y7YcYfqeP0jbUB1vdLb6kuSTaYwfs
         cAUKw9tt5u90S1Y8U1iGQSIEHsx1EsuBpzSKRbfizy/jvk4B/fbMA2EqiptMES4I32w7
         ERXXjlVfDzfyD6AogrijjBplfaQRx+P1ymJCcTaD8vSZ9/ECszh5VrfeEciA50h0xpkD
         T2pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784277429; x=1784882229;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ToTIYJiHy5tONa3lc6dWWbGZLTEc7JJCb/cDS7cr/tE=;
        b=A/XXAl8YCNx+gEDtBNiXq6GzplL1Nmv4u0pBUZbEQ7/n2pQFqLMxrciYLAnOtLVTq/
         I4BWvhYoJ+NapdJ+lrSw88/PlSzSP2BRF9xReS+MtZ1CDBR2QKwQMF2Z+8X+jBJzkBB7
         GDXuiSvco1gSe7Uz3ArmMA9ptz3DERTql0qj+Py4xZvOjwt0FVVwWlXM7wP/Z3b/J3qG
         ot/e1Zx82Brws+A7qFieQl7CIBavCeMSAELOLg4NI+9l9kOwsCnoyc6iYg7EKP27M9b+
         Z4RcQDJBa7tnDWwuAxDIamLP/+2gPonjfeI+TtU/gIJFSyvGo/HFJ4Ilr3j25duP3yFR
         +qWg==
X-Forwarded-Encrypted: i=1; AHgh+RoZUJlYJDbJYFO2QdHY+VIjF2inBfdEIqxfyX8ipqFMs1fdxOjI02IdJGNe7kNALJ/06sfQBlukbmnyLZg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzymkeszPICKECRZ5cZPmTsyzjUsM7uuzs+ZEqn1OPbDBB9hqSk
	uViYnAIHjGbkp3GT0dCIGorxiIxrp4T4UT+GfvjhFi941kide3v2IvBGoyxVYmj0mFFIUlq6efs
	fiapwze1lafT+AWxkSC5zKue2DJxuUBBIeRx2pYfCp7o5GKsmk2bMXP7Xj/xKgVfZtjQ=
X-Gm-Gg: AfdE7cmQGrGUMPjnOUnvg0fx4v3XA+Ppbdns+MR2vyO5U/z48Kc2uIM2vO0lFovCPwp
	d33xGz/cMgOpx+ryb3+Pf1dY6uk3Gv8y7qQXK/AYOwqedDN/l5ztayXiv/VztbNfd5xnZixfmtB
	tgN25hgqa9/R3gL8v4MwAF/XqAEh3H1xW937Bm3mA6r8who7CgXogBdI8S8x2nFeQwiJbznu2yy
	oSfhgPXglIaZHTyslfp7FOdbl7o6t3T92SwmfUpwCkjlBsDgBptGNaCDJsmVgqlcMjJfhtLCj4M
	z/pFvn12JZ0Q7jUf35RDnOkVeEVE7mKoFSEfwszMV21F3xQbBkM+tj6VBQ0RZ4zspD5sYcglV2E
	jAfgX4EddypxAjxFVKbY70xNOeH2C4A==
X-Received: by 2002:ac8:7e8b:0:b0:516:e00e:6868 with SMTP id d75a77b69052e-5213e0828a4mr11943351cf.46.1784277429600;
        Fri, 17 Jul 2026 01:37:09 -0700 (PDT)
X-Received: by 2002:ac8:7e8b:0:b0:516:e00e:6868 with SMTP id d75a77b69052e-5213e0828a4mr11943321cf.46.1784277429116;
        Fri, 17 Jul 2026 01:37:09 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:dc44:5b1b:5396:79d6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954a2b893dsm31268205e9.8.2026.07.17.01.37.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 01:37:07 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Fri, 17 Jul 2026 10:36:34 +0200
Subject: [PATCH v22 08/14] crypto: qce - Include algapi.h in the core.h
 header
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-qcom-qce-cmd-descr-v22-8-ff0d18b27246@oss.qualcomm.com>
References: <20260717-qcom-qce-cmd-descr-v22-0-ff0d18b27246@oss.qualcomm.com>
In-Reply-To: <20260717-qcom-qce-cmd-descr-v22-0-ff0d18b27246@oss.qualcomm.com>
To: Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Udit Tiwari <quic_utiwari@quicinc.com>,
        Md Sadre Alam <mdalam@qti.qualcomm.com>,
        Dmitry Baryshkov <lumag@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Stephan Gerhold <stephan.gerhold@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Mukesh Kumar Savaliya <mukesh.savaliya@oss.qualcomm.com>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Michal Simek <michal.simek@amd.com>, Frank Li <Frank.Li@kernel.org>,
        Andy Gross <agross@codeaurora.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
Cc: dmaengine@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        brgl@kernel.org, Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1305;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=CUp2WTmSuEfCdx1+Ds/evRL1UENxTV/cwxTY1f9GBAU=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqWemd6cehoOTSgO5KMuQ6mnv8y35bchs1VbAIH
 /rdTqYrAteJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCalnpnQAKCRAFnS7L/zaE
 w7vND/9DxMXd0FXloN6YHYOW6Iw51rxkoLImPEgptMEsGc2uqcMLZrvk/mg7ZWygXJFnZjmEL44
 cceP2ouO6GzVURWecwAyquDtun93JntyCV4ZvcD737qZGhv36Xs4ZKolZbLpKOP8lXFxs69Lekg
 ud70LPwoYhBuOBA0wNw/wiaiIVyK9x8QwPvyGMwal27oisVsGw4tro9wneK75y5Wh2bBOsFsJoO
 Z3N78KsB0JCsMfKjTkq8cIdpOu3jgnZdxQdwMXQKk43sHATCzHWLfiFyhlmivLEaGdKg8w8p467
 PW/cjNI9/wxmjTVd/LxKLogNptkmTHi7lvV0oC7HkeZlkI6X7qKkBBMZK0IzRd3gEX5TPoZ8QAR
 TTlXbnVZ6WoEMmM2cpgbNWVL6igCGE6XlfsHJS4ySsyn5A7X4CcgrytCW3KMtUMpmaOLRAxplT4
 mvQ9h/eA7Z/OrhTuk97AQbrVX+j2vLp50BHgrvQYAREPx1UdO7JR/3k/IkX1fdbpTpUaMEtgFT/
 uxuYYlivYgZXGx1ElH9NtNtEH+zYx8CWaezhWCTXz1cxBjMAANRULiQCTmYIa1Csie9jjst9gkz
 zIrXJ5q8UU+cleRDwV6R17pW2YCdNIEIEAx+IAgr09iCmTwRZx6m3CnrWlgqfQcPcRzaYcAFhkk
 uqpAA5FXfTRmagw==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDA4NCBTYWx0ZWRfX7BTnaTgDrwZz
 T5zyB/I4AFcO6+8zc4uqdnd6BR+j3DNCwlagVJ/dyixsITrgko3ttwvnNGh+jLInQlVw8S3EGqT
 DvLhRt7QjD9rAjemDTaUpUTBPGYmfSY=
X-Proofpoint-ORIG-GUID: EvDFTWSWmvrTLuG5EZQKJMTzm48Fy_SP
X-Proofpoint-GUID: EvDFTWSWmvrTLuG5EZQKJMTzm48Fy_SP
X-Authority-Analysis: v=2.4 cv=TaumcxQh c=1 sm=1 tr=0 ts=6a59e9b6 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=KKAkSRfTAAAA:8
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=rvG61WhHFVBzVmnuldcA:9 a=QEXdDO2ut3YA:10
 a=uxP6HrT_eTzRwkO_Te1X:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDA4NCBTYWx0ZWRfX+40uw79Bpi2T
 vHaqqVAYCqn6N5fqREQ5dDVc7fa+j2FbSLeg02gCg5HoxVNq6qPIgFl5UjriE0Xa6S5RN5Fu4jq
 hj+oMdNsrsqonE0xJjtR1NYa1hzc3fKuHG6zPMG5IhZO/Wf3nG+jSXFJOaHvY2i/XAbrzgU0VTp
 2rEA/odrVHkGfzqj5aMWOj1is5DR6cBGzW77HK1UT+i2Qu84nNAMctS3NSomcvpjpK3R+e5M5JM
 Q2qMPvfrv/TWDIK6QHK4uO4m/zirCQ1QMXFqvn7c451wCWZ5YHBTxaVaYF0WABVHqCI1Xhfsv2z
 EiyjvMrK3BkAmS6rOpQYI61KOWy0X6Vj4yRBddjkrIIArLYrKfLWfGIDxZrXTjvihH/MBqZ+8bD
 tsBRhrzbNxFyst4WOfRng14hW/JiWk9G/KzyPmoOc95YDp+gjNfXFBzyjaic2IcleBEJmy+6tEE
 4C4DqQ8YfhmdAHWxvDA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_02,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 clxscore=1015 adultscore=0 phishscore=0
 spamscore=0 bulkscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607170084

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

The header defines a struct embedding struct crypto_queue whose size
needs to be known and which is defined in crypto/algapi.h. Move the
inclusion from core.c to core.h.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/core.c | 1 -
 drivers/crypto/qce/core.h | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index b52a26ffff5ee733adcf4e8cf8bef75018dfa63e..dd860435d2c47a608c82cc2686583a44ff96c889 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -12,7 +12,6 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/types.h>
-#include <crypto/algapi.h>
 #include <crypto/internal/hash.h>
 
 #include "core.h"
diff --git a/drivers/crypto/qce/core.h b/drivers/crypto/qce/core.h
index eb6fa7a8b64a81daf9ad5304a3ae4e5e597a70b8..f092ce2d3b04a936a37805c20ac5ba78d8fdd2df 100644
--- a/drivers/crypto/qce/core.h
+++ b/drivers/crypto/qce/core.h
@@ -8,6 +8,7 @@
 
 #include <linux/mutex.h>
 #include <linux/workqueue.h>
+#include <crypto/algapi.h>
 
 #include "dma.h"
 

-- 
2.47.3

