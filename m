Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947A33FCB37
	for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 13:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779801098; cv=none; b=nsu6Es59SbOX4dwZL0kEc60UXDSqGPmZXrEKQXdqB7klepATBWeX4UK290NM7VZ1ocVxKUzZr/0/dKJqj4hsBT4w0lETsqmDjUUxtOwCvTxjHOBg6j3csVRnd5hjca2bkI7jLyvl0myP3EcH8XQtjvuuleada4Fm96+8Ngd5MDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779801098; c=relaxed/simple;
	bh=bxwOj+1r4hE0BIdCr6O2vUvIE65d0GfBKW7+Xew4ns0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=p9R3R+17mgwPTVgkDBp807amiCfOZr3Y2NNmvuYTuc0pZ4+j/MbiUrSY/CDVkNA2amzAJTegepXxNxMtnQLSigSRjiEbAN37Duv8q9RzsclajwE41JiafeK//kbJuLuqPv8jY705Uy0eB3UjYA078Dyk9HdB6+Z+06+9m1RJxdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PDOAI/V1; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Gk3cyrUJ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PDOAI/V1";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Gk3cyrUJ"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64QCsWhI2496593
	for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 13:11:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	0kLuBmycbMAXm5ws7TG+DllfddsRIfX83CGKYC8vsgk=; b=PDOAI/V1AKIUSIf2
	8LvaPFxs17fPgR2zWuSNdcb52ZTD7gi2jw3ii9z1SM41iXVk8OQRCO2FQ8q+SCR5
	/JtflcFoClrGzQmpfoYS0ldnVSFWfiuBacXjOhhagtO3maaNOe1M7d4zUOs8ZS91
	kavXyaLsQB9MFi43fZT5WgWWEtTwgvwSlQoQQ4XI+ACQXYpWsi/f1B9vEVPrVQ2A
	a34h7/8I5jh5U+cF03+RU5qJoMWZ83H76KJNLuPc4Xk+bFRanecdzOazy+2CYEIM
	uvhPz/zOxWKEOIgbwkrD9f56P6L4eCuTSvqn5h3N4stymJ1FC05EUDPwCYYkObuA
	6CRf1w==
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ecpyqmda5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 13:11:35 +0000 (GMT)
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7de44ba64e7so17037377a34.1
        for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 06:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779801095; x=1780405895; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0kLuBmycbMAXm5ws7TG+DllfddsRIfX83CGKYC8vsgk=;
        b=Gk3cyrUJO0YjRjrjoHWvyDOzMXHfoFlmHDVTiPLpf0CkSIbx/aYYSq5pwYIvaLjp66
         u38dwR2697GWy+9GtzuvCah94e1Vr5gy1jryK/MjkjkOnomWB/zzMFwVVLwl6FW9TjPG
         Kp7iFYIm4UWriWQRf5SkMtea0L7lTMqRWfiIZTw30HxGguDRk1+dYW+dLd7NqTYNJ9+X
         INbk8PiPvGAWluKj+8BMOy6lap0/95dZbfOm3I2NwBo09wGdKpjHSNOfoSYCOVQy5Ykj
         pBsd4caG0izV+/f8jcg3Tr49WCtQ6nL4QjZrr7w1D9sP2ZjbVtdyo8W0ad+fVIqPQ38P
         y/Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779801095; x=1780405895;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0kLuBmycbMAXm5ws7TG+DllfddsRIfX83CGKYC8vsgk=;
        b=QoAhNGWQ6icNwOE+HR2114R/w1yXcBVEUypUBIQH8903zKrcAX2kcHlO7RQMRDjA3r
         S95AKUb024npcGXbcI/NWmvJYtbz1I5Ge9kAbtNI6H9pxlqtOYwGu5jDAxaDPLNWTF4U
         ycDV8ACGY7t030UeIyVk8RmULiXpWyjAHvkGPTWtRF2/Ck5+vozJgc37sm3BkYmxz9Pm
         ruUDwl1nvO4oDx+sby4hC9Sgjmhz8TwOJAaKhrmJSPK5MGDSc4wvFhompCkUsqrnrxC0
         kWQBVUUINalEE/n2FQ18UjpAuf2wg0ra65Fym/W8VMpZ1BbiKgsH0FuvYkBE6BFjbqVQ
         6bgw==
X-Forwarded-Encrypted: i=1; AFNElJ9WRdUz9udxuEr0DaI7ZPCNS1cg503K5/jGg9SvCwdw8/+WT6mZioKkwA2eDcSwJhMEbZqD/g8h7yaap1E=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYePbQOksN2vqBj5fwHC3O9zNjPxJoAdgWC3xPXaTLU87np7cN
	5DgvvGMFuEBob0sJ5lYVbrFcVszrQ6lZbjOcpqrtPwbNTVBNUQLCyxdmqSICCmnFGylTLS4zArU
	BUAhMsqQ7x/DEUJG7qPdoVecyuH7qZ3D0qBrSQ098PBAXa3/IwjSp7g7XQCuEayb4rvY=
X-Gm-Gg: Acq92OGq4rLJynbiWVAxrKQWYrTzkqK4c8ljyzF6H0Eti9wQb+1Sp43FOyxfuZCahk8
	wjG1Hl2EZVVdOIoM7Zc9p11662JxhEY4oYB7JlRHM0AsiLv+r7c2NkN5G23waBvd5ACuLF0xV8k
	FVSJu0EltF1wk6upBdNQCTkfPvdWJaDkhKREGkoe1jF0IhlPuu5au/44bARofnbc/ktVm3lI2ib
	1GPSKjhItbP5zzv4ag70KK8BzWJIrP1yoW8byuFFteRT5AH7Ann+evGbcdzLei5D3utY8oTeur0
	jEG9XJQrp/LPAFbGTSHbsqx5SY/4EjS3/DkkTHA2eehIweZxRZySXScWKem2iZ5HVp4tNYxZ/DS
	9vU8RIh1X3NH7WjWFE3KXIG5vcRwbd4fXVEkmTE7jNNHl81/Sgvw=
X-Received: by 2002:a05:6820:4c0b:b0:696:1262:2ac5 with SMTP id 006d021491bc7-69d7eb32a22mr9146009eaf.2.1779801095093;
        Tue, 26 May 2026 06:11:35 -0700 (PDT)
X-Received: by 2002:a05:6820:4c0b:b0:696:1262:2ac5 with SMTP id 006d021491bc7-69d7eb32a22mr9145993eaf.2.1779801094678;
        Tue, 26 May 2026 06:11:34 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:15ba:1d70:65ea:9578])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6d5e484sm34259426f8f.30.2026.05.26.06.11.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 06:11:33 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 26 May 2026 15:10:56 +0200
Subject: [PATCH v19 08/14] crypto: qce - Include algapi.h in the core.h
 header
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-qcom-qce-cmd-descr-v19-8-08472fdcbf4a@oss.qualcomm.com>
References: <20260526-qcom-qce-cmd-descr-v19-0-08472fdcbf4a@oss.qualcomm.com>
In-Reply-To: <20260526-qcom-qce-cmd-descr-v19-0-08472fdcbf4a@oss.qualcomm.com>
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
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqFZvwlwWuPPOocJK5HTgo9RXGebXz1TH1fLJDZ
 zRrnPDCeUeJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCahWb8AAKCRAFnS7L/zaE
 w4J4D/9TZ8zl+AagDemgV18CxEwlfF5SmO5X5h9N+TTNFeKXSps3Y65GYLhqqOcDTwQ9yafpTQo
 KslC9G7SJjpvzgeNNc2wTbbg6CSoLLgcU/+BZ9aBBUqclXF5KYZkku7BhnlA08xrcEP997eICkl
 fs/sGTC+6k/jVAe7ECWAF2F5HFM7yLvmqrRG99CEqe/ALf2yPaUvxFUUm9YAb56si7pAwpRnVNi
 Jh0g+2REUzCY5DaxJ+ZIBbX3PdDnnrnB6guGPnXEGiDZo1Y0vU3zjZkE6rSBez6L9wksn0tT7lr
 M8uM3wUPXFpgXqJM6sycWYIora5fV37jTMvt3Wcehn3ZR5CBwXxv9gj/KHnD1WR7oiciKughspM
 u9OzucZa544EBjJDx4vfMpaEvl8CTJhnAX+r6i4mLpJMyuU6fMrlK0vxuCovpLxezrvCMywAM/f
 pftFIIt6/7wETddPCn9EJoqeXw+AH+T3K2U9QSZyioq2WWQHRET99cOe8gGv4tjcQx4pPMFS/aQ
 1KtXTttCSCGY9C69bDcp0AV1JBJKBZoAqNhobsXE1vEccka1CoK4tvm/AZDfpCsIc+RWRk1s1MU
 AWpLZ6pbXtgTIN7LxL7wtShVZLIN/uMKbkwIR4+hsQJV+nDyNxSxmtzGmyDq+wtPiUWEM8U3+xf
 F5T6OyqVNo46OTA==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Authority-Analysis: v=2.4 cv=dtfrzVg4 c=1 sm=1 tr=0 ts=6a159c07 cx=c_pps
 a=7uPEO8VhqeOX8vTJ3z8K6Q==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=KKAkSRfTAAAA:8
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=rvG61WhHFVBzVmnuldcA:9 a=QEXdDO2ut3YA:10
 a=EXS-LbY8YePsIyqnH6vw:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: Q_9_yflILJHr73ZKiN-_kADCf66oOTm3
X-Proofpoint-ORIG-GUID: Q_9_yflILJHr73ZKiN-_kADCf66oOTm3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI2MDExNCBTYWx0ZWRfX+28iXwUwwkJO
 NIc7dpAwy9DIGhx6e64jMsLIwI/9iT/4USWZAFOhM6HllxJqwee5nbsC4TB1qAF95hYPEcWb0LD
 Q4rVC31aLwYcpqKeujUiy5jsVo19aYZCCBR7k0IEwMjH3bWl6fwzbICXJ2242tQ2sLYCB1aNzj3
 S2wOp46MrZSMLauQStZzamLQYx9OO52xvFyIcWv20sdvH7OmaPcgmXkMJp/QzmpqeiylWmHYfkp
 TBFjB1ZFSaP330uMXvkgmCUnx+/G2OIs3LQcnYgP1vXMMSidlDSFQH+QfnwGFmc7F6iLZWXRvVJ
 XXKYVGplNQ8RUYnUd6x3Q80fBLQmQ3O8IRebscixSU8SoUWLaaDPIZ2zRjpjXL3f4n7j9h5esxN
 MpdgmoWNgfvwGe5g7YgAGaJO7WalNxnwzvZaTAgpC0L4lVEpD5ObE0ZjP1bqlU1gsQY4sDloB9c
 vOo/BNU35jnezGdoocA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-26_03,2026-05-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 suspectscore=0 bulkscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605260114

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

