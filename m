Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B1F4766B4
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 17:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784826614; cv=none; b=s27EVyCZ3BvL1QMYzfVjggGPcNahSbWESn5t4KrC8tNhuFt9+fbWD+Y76MphE7qSvSSSLU9xXuwqxMDTULnoZSzsbBCs5sGNkgPeSXbWnS4ORHgAs6ipskzP2RVthBgCHrenvVEjx4/wgVAt+H6uXmrI8TWyRpovl3wS5Urr8wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784826614; c=relaxed/simple;
	bh=vuAef0aUBOeSio60r/pSKcTossm3V61GQJlAyMtLfKU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hX56apIvK8AGY9DQuhwo0hqRcdl/G60w3hv6YJU3fswFSHeSEca1Xft7QTMn6O8m7hG8pMtYqG3EHW7h5w0m4chSP0agf8w3k50OtuxLu9RheLYwe6xmBmE1kIKtrEyKygFVD4vy7Fg6tuqK3AOW5+tzwl8M73xuD1wSRQnnGXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=B7Lxjbnm; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PTpoZalI; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="B7Lxjbnm";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PTpoZalI"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66NF4ekS1324510
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 17:09:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ToTIYJiHy5tONa3lc6dWWbGZLTEc7JJCb/cDS7cr/tE=; b=B7LxjbnmkxUZXHF0
	L0C07w/pnWCQsRcnPxj9APVQJ+cvacENCp3pCXw7Dt7Ux0JhwCOHFJzkHK3r92rp
	PcycRnBC77OII2w4x+ZZ0Li6A4CKu4fxNbfu+u5pOvCXuj5DQTyJGpYekhqi5H+t
	9bcYyDHzP46wL66IegPdjou2M0wnDb9t/OnEp1mu+3uKUix5D6uWsVCmQDA/ES4R
	5b+/2+DPxTPdrUCwUPT8UE/ZfEScuAOH0djAar9BqaDLfenfTkgT4JJl8Dpx5BDk
	2puWi0UbS3j1tc0qBhrI5rtDjBiW560Q5Pl2EYuIOpUgJoYG12VCa8Z3Se7evwJ2
	yd8xFg==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fkn9a0my1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 17:09:57 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-51c19493ac2so22572411cf.1
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 10:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784826597; x=1785431397; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ToTIYJiHy5tONa3lc6dWWbGZLTEc7JJCb/cDS7cr/tE=;
        b=PTpoZalIDNKn7dCVB9MjSfLKy9iHf8JVMVi6c4EMhrrPuXYY+W4WSSJYPr0HDNcYfT
         diRfbjE1mcGSlXig4SjM3DIPQQ1JTBGDGLMshYsnLkC1rcasoNBprwSidQdX9omMjB0N
         G4jsTHnee+4gMAKoowT+OdpdS611rF0HmQgPJB2K+9F93U610AY17uMGZK0o/52E4nlC
         USTfeDgEwCLGKnYMI1MrR26VPFT2MFdJW/+a0xoZSHyIfeUGbtwqSU755e1rFrifkWqb
         YcMTfjxfC/G5xAFODdlXsyK23Kt2ZTP13E31LV7GF0IfUO74qVrkm1NCTlRsQ4lNz7kZ
         fH4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784826597; x=1785431397;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ToTIYJiHy5tONa3lc6dWWbGZLTEc7JJCb/cDS7cr/tE=;
        b=madXC2K0dHTZxfbBZtFjh/ifm/FMMB5kc+YivvBj2WnOXiCixi73kjgpA6PlhXnb1x
         ybxOY46vm6A397+ucUIFuBkpmf4cacuiy23hp8gLNWpKGVCIwQc0JZeqzUj5btkMSF8L
         wx0WlF/U1Gzo+PPTR2GLEb1Txs7dhAUYcRj2XIrqm+ZBH19V64Vy6vhE3OM9L8RHSSW3
         83fsl7C5MXDjXpj1w9RLByr0WJGiTEc180A/1yJCGNudV93faRpSwqMJOOQQN6yp60Ss
         6KAJU5RN1KO2Ly1z80c0I93SC8M8H8Kv5yOcLpK+b3hqbgeD6RmsLuulopvex02LtZpI
         VV/Q==
X-Forwarded-Encrypted: i=1; AHgh+RolFdAMMFyxJHhj/Dhiellp4dBmO25Sz9XW45bruYkKg6zMdgBLJIcr1lE3dm28M+3M0rQtsFxeGxkEA/k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/ukurDjIU77lYgZgl4oQtSqqvWdWNYp10/ZDJsmkXV5HQNhYo
	58mOKrAurUc8c/wEYEq5hZOrgGO+sFAchfgDlGOTuxi/vrT7YmG2pk/fZ3UaoBu9FeERFxiM/km
	bU8ARA+p3y1f5vgPu7ZhwhX0ZzuEi60+C0ckOlpV9a6db1iRNK3S9EmIboemTbsBhEWc=
X-Gm-Gg: AR+sD10kkZ+WAOAnNF2I9rPHsCDVB+UP3AynUeVBjXAuvEEhinHb0PECJJlOGZ7v78V
	6uuvpGX5FpVjvD0C4LGmXt3uWChzOkNCKJ8v7hq9WIpo+QWjWyMgXWP5euN7PcXq/EPmiODOBDa
	ovzW9XwG9nPSF7+wCSVeSJ5NBpNRTyRPAPWE/cVzEA6Q8+5vUysPRvf6gk0iQof30dlCM/DUwsB
	KC8urFzYpXaic2xWPEtN9ydkD/r6sjV4MHSD7BGBh52CT0iO+4vldNejJTa9zAChXUSAT8zeXZo
	qvAE9IaPJaQO//nNuqnyuQ/5qL2iW6vRpK/3LOc+U5fBdDNpAVpMXxxFSjsaKnO151DZ2r9Ejg7
	rCxtw43Xff9zr+r+mmopgvz6tgv8F
X-Received: by 2002:a05:622a:386:b0:51c:f3:34df with SMTP id d75a77b69052e-5283ddf7e49mr38796591cf.30.1784826596628;
        Thu, 23 Jul 2026 10:09:56 -0700 (PDT)
X-Received: by 2002:a05:622a:386:b0:51c:f3:34df with SMTP id d75a77b69052e-5283ddf7e49mr38796041cf.30.1784826596112;
        Thu, 23 Jul 2026 10:09:56 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:cd9c:212:1357:7832])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85b9a64dsm18472999f8f.1.2026.07.23.10.09.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 10:09:54 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Thu, 23 Jul 2026 19:09:14 +0200
Subject: [PATCH v24 08/14] crypto: qce - Include algapi.h in the core.h
 header
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-qcom-qce-cmd-descr-v24-8-4f87bb4d9938@oss.qualcomm.com>
References: <20260723-qcom-qce-cmd-descr-v24-0-4f87bb4d9938@oss.qualcomm.com>
In-Reply-To: <20260723-qcom-qce-cmd-descr-v24-0-4f87bb4d9938@oss.qualcomm.com>
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
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqYkrG0VLs+VISSBWfLayx/0GnGbzVv/3UnOYeu
 At3Nys1tmOJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCamJKxgAKCRAFnS7L/zaE
 w1E5D/wOKIYx6yDd8LZ32i8TxjBbQHNdN9m1zJ8Yao3Roa38cxzQJEB1eI2zUMduHnYBaeu9tg4
 VKbKKPrK7byHWwNRhin/x8eYccQvhXXEijM7yWACZ1pJw9V4QRz+c9nM/Y2NgXXP3J0peax7wk1
 VEy3rcgfFR6ObVQI+AZR4A92sndpV3IaqIWjsFRTqjYJ6hnbhBm4cVgof6xHq4yY8+FkQcFS+0V
 Sb1Qv5ill/33pVV6WXzYfbv63h84gFSFbqm9Sx9za6+DWJLWJ1+PAtl0BU02+lG5mRFMhHi4UcY
 gMXVkAVFRQBE3BQlb4+8EZZUqT9tluw1upXIeH94iEYDCRitcD6A8+UlNVpzTrKjWs8h8VCqHQT
 fqiQrLQNSmyeEWL3ZtDSF4jXh1pwwpEXiRkYVqskDZ9ZaDIgp/PKyP1txTzjjsSsImUsXXGzygz
 evA9OqUVc8f68cdl+fMl+XtT0Kdn65NPeZE2FVIDo8KffMNHjIOJzKKFAO5HsVk8fZAhRzkFDtC
 mKH+OWiB7CINj3E6/YWyZ6igQ4Lssq6xUe0pl357qphKcYM3rJzOXeo3LxDF9EMPaIKCbjzjLrX
 vMU9OL9rpqPg41NJRPD1OvQ9e7aBowndyXwNGgE7ANqSOfrn1xGEZC3ZBPF1PLRQwDDgia66UFo
 SH+lyo5j032fUZA==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDE2NyBTYWx0ZWRfXwhkfe0clHWxX
 RSPrC9T4B4lkwqAzl+0LJf6a6N6nAGOoL2jRRr/khIR3FlYdB31ohliC/WhlhzD90M88MJkIAZv
 0okfY8GVBWtQt8AjFt/P3KdpcdSAS+HkzeKZcNitI44bFk2mOLP1Hb1+RdH7fXOsDJp/sO+A9NG
 EVeShIrs5JfPMEv8k2sRovxz036yqsL68Mytq1yEhck/uD/N2H3s9dO/K3Iu+/oMp4oYQHAlFI0
 ClUTn+v/em711HjUM2fMr0SkBUC24lRRyk1reIz1n93NbnFRFqdFUSX5wDgsFvr8ydCSlnCHNot
 WdrArESJVBUA6qaVjnZwJkLcN5OcTTncIAC38Kz27c62i1f/8yP9YWGHlzbxrf095JVrODmOQbH
 BpQcxct2BY3lWfbqYewfVWYtyquAjU+WKlMuv/Mq3GCcDDXZBc0yQGaygv98Ms49Tb/R8M5hZD/
 LMecgI4zc0Ssda7PdmQ==
X-Proofpoint-ORIG-GUID: DM8B6UQcdzkYsAtyeT1uHhPECrdDdR2A
X-Proofpoint-GUID: DM8B6UQcdzkYsAtyeT1uHhPECrdDdR2A
X-Authority-Analysis: v=2.4 cv=WOdPmHsR c=1 sm=1 tr=0 ts=6a624ae5 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=KKAkSRfTAAAA:8
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=rvG61WhHFVBzVmnuldcA:9 a=QEXdDO2ut3YA:10
 a=a_PwQJl-kcHnX1M80qC6:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDE2NyBTYWx0ZWRfXwa20pQQ29uGY
 Thsx4x8hZUUqq8uZkKDt2pT2AYjhhCfIwNdBLc/vuD8Ck+hM8Evh0Z+tArzhS2F3As/La0zSYdV
 nzGYqr/JNwNzB8I7NJHpWVo+/MeNFMk=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_04,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0 adultscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607230167

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

