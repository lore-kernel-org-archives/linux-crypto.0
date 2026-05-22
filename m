Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F47A449EB7
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 13:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779457241; cv=none; b=vDLAa7SW7beefxew4yElmZtvQuSSOXyLDJP30FDxQzR/fU3edzp+muGEgf9vSv9B1xOxHLNEowHBOk7lgEZsai0lJ2q8vjG63Cy34g59xyZyB661igqQsMT8FPOtscBM4UnNGtg7qLP5sCMeE5YzHAQPWlRXpGYMeAKitEGb2e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779457241; c=relaxed/simple;
	bh=bxwOj+1r4hE0BIdCr6O2vUvIE65d0GfBKW7+Xew4ns0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jlBK/gFUYfTekNNGFF2on8e/joXK/cFOnwIVo8hEaJIDAvP2+pEAJ76bNudwBDy1LwOM8TBh8kUTOKtCf3vtQs603SE6SZ1ii6q1mXXI/JGJFNjIkGrO0JFUmT47eSBj4qlzl9ksn0EjaAFp3Y3Vo3G1K5QF+PoredJqa3OxtVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hFm1zlHV; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=iMDIhkNr; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hFm1zlHV";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="iMDIhkNr"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64M8xPVY2765573
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 13:40:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	0kLuBmycbMAXm5ws7TG+DllfddsRIfX83CGKYC8vsgk=; b=hFm1zlHV59sE12if
	pH8nBKLuhP6tWQZ0fP7EK7qHeZMHzzVSn65kEsR3gU/057Gti5OwtXpDrMq9fm9y
	TluGSxSuzgq2UOdFUtwxn31I8KMEjnGq5rbycHpvhIlAyfLSPulmXS9GzaOkyz+S
	wdU9TKltnzwoyBPKJFxwG8+mc/pOhfjBR4pFYT9vzh/pz3B5Ip+1RpEtlCf34rHa
	EZpl0mYsufGeMNgd17FHUuo7PsQlzB4k7eVilvJU+M9sLOq3wh/pOkPpH4cszi2f
	NkZo6Sun0lWJus0/deIkBPx/CNeUsq0zduFkQsrf+x4/2hNbdwXeu5K0d/Jz7qj0
	ofdc0w==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ea3u7w65v-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 13:40:36 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-51650041428so2890751cf.3
        for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 06:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779457235; x=1780062035; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0kLuBmycbMAXm5ws7TG+DllfddsRIfX83CGKYC8vsgk=;
        b=iMDIhkNrs7zwWiTWV9K93dC9SFDj3tYoFSzGcwvSLQloqSTisitZQa68CgeBodJifj
         bn9e3AnBJ0alYv9Pbh/jY+jSTDaiFspQ2w8bhDOUQolXO0oVpV8hFhpUwdATTo4RFbJA
         +nmKTf1pGtJ9HweHms7ZrPnnFoLard7/+cWD6MFlOr1XcK6pabFm0j4THrBLOSZa9yDd
         epb9ZmW+l709lydwE8GvDZj2af2r6KZjI4/5bZmP6eEPkDd7oSRLgd7MeFPaDzZTBTJG
         EiiJ+KEZK6g1pa2rN04n5YoHEeonccbHNVhlRmx+/TIfmrRNqknvAmw/i5tbEnJsZibx
         gudA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779457235; x=1780062035;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0kLuBmycbMAXm5ws7TG+DllfddsRIfX83CGKYC8vsgk=;
        b=nk6jNUILI97jy2Fqap/KMIUcv0KfTlsv0oDVOc1syKPNTj0HU7S2EuEZ/2nGFdJDKJ
         N9MUflFguUHYLMaV/0RBgX3wXOey+PLjhW5ev/0DpyPXlHn0YVhe64Z/rF/HqNYew8rM
         lSULe+imvOEfkWp/BSJ1JqMV4hUgWcT5FVy8kVysk/J6LHe5MaDF9B8b5Cx1Q6RQVE58
         Ojk0vSHNTAC6Gb2Ep/HXseIbOi97ptqnYlpvTQFNkqAvyRuOBF3egM3CDn2yJQ5YmEMw
         vqmhc4lEwzHN3Jo4KNyiDSOJxOgfdWEL3mOuudFn0TmmkafLLKyZ1zVUuYCnbOIWjCHp
         LWdA==
X-Forwarded-Encrypted: i=1; AFNElJ9iTYxHnvRWAnYMXqDmYlywlN9eDfyLfjfbroZKQFV1TgEcG6tvm24iX2dOBFkG8aVQbugJIdG17pXWmHQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUmT9FIhJSAY0dRCBEFgScV7EIR5WCbl0BMKW4/AabDgJyy4/n
	0BmmT5gvS8PNYdNQ9U7CNUiVN17E3R5FW7xDMGPTYmeR1ai0qVvnrOAp9uv5fVv2BgIK7ZVjC4j
	XZufK0zrJgk7P5NEo2gjL/r7fQO53dlJDRlU7IB76VWhrKw2tJ4rVKYFjwVA0V3pvml59EP2bur
	s=
X-Gm-Gg: Acq92OEzWL0AT737YxlzKSxfT8vCUwWKiFSiIPqe81VA4yIy5xTrFNtv6m6kCIzfInT
	FwuNF0K70DKHj9ToCeVv2gSvoqylB2AR3K7kli4iyiMIhFk8nIkal7vmi3Wf8Jh4bxvERYvsWMy
	bRFUHm3k1v7xV69g8LNU3PXFgUcJaHyXr/smfpsThtmYyVD8VQn69r7i6InYxa6Y97Ln2UTdCid
	In6eGA4Qp5C5EHeAmKcTq/2AEp0MsgWgoCiXRhGfdL2im++wyr0EdYCjimQCffMXXV3Yfkon+WN
	Bs70teqERt2KO2XybYRUF0cjTLQ48Ln9anZw17FykGt5rxX3w08cvirjqUKHFmFkihbl+FIOljE
	XHMrVs/VnVb9MhotBRlyKh2L4lBzGaQZxTDAEUCREZTRVKhLR5f1UsTsq72E8
X-Received: by 2002:a05:622a:446:b0:516:db5d:ebf6 with SMTP id d75a77b69052e-516db5e07aemr19429591cf.59.1779457235453;
        Fri, 22 May 2026 06:40:35 -0700 (PDT)
X-Received: by 2002:a05:622a:446:b0:516:db5d:ebf6 with SMTP id d75a77b69052e-516db5e07aemr19429081cf.59.1779457235055;
        Fri, 22 May 2026 06:40:35 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:2fa:6280:a48f:fb37])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490454c600esm44912825e9.3.2026.05.22.06.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 06:40:34 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Fri, 22 May 2026 15:40:01 +0200
Subject: [PATCH v18 08/14] crypto: qce - Include algapi.h in the core.h
 header
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-qcom-qce-cmd-descr-v18-8-99103926bafc@oss.qualcomm.com>
References: <20260522-qcom-qce-cmd-descr-v18-0-99103926bafc@oss.qualcomm.com>
In-Reply-To: <20260522-qcom-qce-cmd-descr-v18-0-99103926bafc@oss.qualcomm.com>
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
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Michal Simek <michal.simek@amd.com>, Frank Li <Frank.Li@kernel.org>,
        Andy Gross <agross@codeaurora.org>,
        Neil Armstrong <neil.armstrong@linaro.org>
Cc: dmaengine@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        brgl@kernel.org, Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1314;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=Qxst61jdIT+8Ht+en2AytpIG+5WhKs6TgGXh9cEYbqk=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqEFy6BGklBaP1lW8n9Q0gaQ++0gYBLLHAPfPUj
 Pn6QDYsHf2JAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCahBcugAKCRAFnS7L/zaE
 w21JD/4iKA4zWq1eo8131QpnLuCtj0jhM/ZelDuhM9ibrZfv91X7S4xQ1LFEKU0g7zq9/dfmIbo
 QBDd0DRHFHuoxjwJF47NHYwHeQsnWtuQaanIlkITMdxltp4vjT9NSZN1ls1mk/KdfUBwdGg7q9t
 odm2ClpGr/UxBis3w/Dmqp0jox/D5T0YFE4xxzEkLWnIsjSFvo4lH/mL8IQbyH/uBOC0T8fNdu3
 2YyixuTnTC/Wr+lHT37sthmfP1J8vUL+l3Pog8Os3LTz+UVeLaM4xaOEmPgQwldLjsRxYtjujGt
 ID6a/vSU3AgusypMEuPexklUuxUba/4SohLgBW11Jg4CrgFFTt1CBwa3nJx4w9H38K4jxBBdAEA
 nFADhoYg9ISvEbMutcACZbTrtaGNrhwkx9l3HliHrhVGJAX3FMBdwVxHnrv8EAK2ljpfI5eHSnB
 pAcmC10IlfcpBUq+BpOCy5PqEVWxEzp68go8jdiAux6NC00i/izE2baJBjQUOx+YNevTECGPsoh
 OpbDGgsNqfYck1Za/oVuXor6E/pQ3woJioHCcybDuCQB/tty24iWhvjLZAGoaDALiFVrsMe6kN/
 SZw/Yz/aJM9+eicofXDvybZpmUadpzf+RC0QQxcpuCIiIZCEYzZZaDt+N9c9sNIDvfRCw3IJyi4
 tVBYEj1xMmvK2dA==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Authority-Analysis: v=2.4 cv=aIXAb79m c=1 sm=1 tr=0 ts=6a105cd4 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=KKAkSRfTAAAA:8
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=rvG61WhHFVBzVmnuldcA:9 a=QEXdDO2ut3YA:10
 a=kacYvNCVWA4VmyqE58fU:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: qZr0BXgoMbIcAkMZd7R8eKR_0NFrNxlp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIyMDEzNiBTYWx0ZWRfX5JRzl+nEKMSM
 8vn/aMPx2as0gtmdJby8zdMLs2YdEkzFiZxeBbKxknt2ZGScnX+1Ey2hD/pKHlLMRJFLSR4qSln
 wpFjTYktkRAJqVG+1Md0bAe2Dwit3N1+hUChwIxkC4LoyTxrNnEanjFqc4l5dpxyYxXg0HDC6pu
 Jp7ML9panSuVjpARnTFFBaRnMv95KLLbJ3EP0h/HGH1K/438upNyooYGUZpSKQLe7Omh20RvOZS
 IOlpMvFAqJTQUhVQOecDfl8Upu3ZlsnXgTi1PfE33lmZuw4PC5oWVfLo3snryUI+sWGLDVp/YNq
 e5yJe/2XyI+7o6djhctbi5/6dW73h8v+3+JEu+uDA8hHn8sRM3pBGWNGnBpkOKsZAvso86mbbMH
 DDr/RnLaZTvjJkLNrMPzIQX+IGO4I2zr3+6leCLVqJpimVbsn6ROvVW81KbI7+2c/h6ncieIp/o
 31eFH7MZOdsRvM68RTg==
X-Proofpoint-ORIG-GUID: qZr0BXgoMbIcAkMZd7R8eKR_0NFrNxlp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-22_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 spamscore=0 suspectscore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605220136

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
index f671946cf7351cd5f0c319909bafd87e3af701c7..ad37c2b8ae53a373bb248aff06c3b7946e8439a8 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -13,7 +13,6 @@
 #include <linux/mod_devicetable.h>
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

