Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6481C3019BA
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 10:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766138918; cv=none; b=rhdaxWaoSeTUs8rS+3lmqPp4a5+UYsN4hHvIh+ogd50UpxJc69enR1uoU78OPUd0oeVYcroZICqD8QinbUThOMbQwf5hpeQNcCHA+RP0dUpJNXWl17w8G9Ew54OmGYXf848Xj4knagEkZz1IRDVXxCQogZilHR4wWzAmh9efYeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766138918; c=relaxed/simple;
	bh=D/DbbvsYNV6WfJJN+Y3qtsfzsdueJP3Q7cdgK44aCk4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=cV0Nz6kBCcfLDm5PEBMvcHAqZAyc6YNsRkmoCsCEB0qCjq4W88ztS2iYpf9JCUqlz9OLcpzthtRbY8M9NcOLobqBVwVOnLL4Smrfq4FCteVOyLexsP3xgMI4UU6O5LfrrNu/tZdBmmBgMV4pM0OnnsdGVXfAliP3o/A3U8CodtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZDIoAg4C; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Szd/7eu1; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZDIoAg4C";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Szd/7eu1"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BJ4cgwV1772191
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 10:08:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	f+eJOMoesWuzpXTSR4Li0Qt2PYtZi1rSvrjFdAlx9Tk=; b=ZDIoAg4Cc6xVpFhw
	Btnbxl/g+ye7C4oWpu41TA7qnrOPbGWtcnDqsNDMPp3wVlAqbDdbdWGyiMA3YaHb
	ac42bjAMY2hW/hHq8bUJAuE4NhdolIh5DxqlA1M8TwB7OAP6gJyb2tPzrbfWZVaa
	+UEKtbHKX+t9JZl6yBGBtlb9STQiYn8K2o8+tQBeNGlMbcK/McB588mGbVBx9RMr
	SPZgN0nnigIgP0rIAUv03Q90xBVypBQsSH02vv3kZcxiabEv1V4y+L4u7WQEpjS0
	k+nqJnegjjyT++1Sm+Sb4ikxZIvL9br7XV3ryae12abBYDqWVQ9Qe2JNbZjSilXv
	0kxTpQ==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4b4r2bj8n0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 10:08:35 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4ee04f4c632so28717081cf.3
        for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 02:08:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1766138914; x=1766743714; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f+eJOMoesWuzpXTSR4Li0Qt2PYtZi1rSvrjFdAlx9Tk=;
        b=Szd/7eu1Ye+znIJdTDyfStdw3G+aPgvI91udf69G6NbzpCiDSFnJttfl3X81fo5KIx
         Za76cuUxoIVgWJVfabIw5gJm/Duz2/7jgYdijnwgPpZQcABMe8CZZMW8JYf2J8gVjkpz
         Ws0j+kO70Jh5GLsBapH8uDwDDEeBypBHF6n/NpiAaWmen90jwQJCMEV9NKg6ODx0csPq
         sQD/i3Jvv5QUo+xKMeRzK6q+FxKUippC+hpKnqdtpMQGF9ecX+bI1fGv5tog5uBAF0vv
         4Dc05nT5HOBQNo9/58RjJnotBZ9Rjym4Tp9gKiAxS/WecAyis1S/ZoNq60MbCU3lOosq
         Mb6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766138914; x=1766743714;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=f+eJOMoesWuzpXTSR4Li0Qt2PYtZi1rSvrjFdAlx9Tk=;
        b=R5N1Ceb5NmdB7OBsSVOYOkq+PvQMTYl3lzA63GxyPX/eTEvFtM5Z8yKFAVwH6gvWqa
         gA0K7GgDwpYNnP2bVtOaVTsuZ2LBKL6NX721Th9J9FB0NKRst7IDRzwTqhehgU7MEQI+
         3AWC9wwUvNBpuMLwsy3RlCtgInevrUiDsEU9O3uF/XQeMDnkkxqqwWuFtNswtGK5k67M
         jAqzXlLaUhyM4AhX5SjqqcqtRfF0yuytQeGXVvk28JQSlHJ6k4NHipSXby/9fQVEnbTo
         +UTJXT35kGTbWiZueaX/x3seOXydIDhqXM5gldCYsY3DI4mQfU30xIiIGwQob7S+/wxz
         fDkw==
X-Forwarded-Encrypted: i=1; AJvYcCWohAafbLEG+4eIssFRYoHXohLVMXD5SURtBNvlD7oXBuiHvEJHXN4FwabV/lBBHoVP5pKoG5GzFXlOSTg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzpsqb/XCtRM6BvW0LyBFF4ExxowX89r1kHDt/vOJvt7kFgnAzc
	5WWUN5QpnhVU6ycLsAoEmIL0iw4HD85AEQpJsJxx5fg2kMjx7V0vVbOqIPb68e8RHfJ3fszQhP5
	jFi6nk7CpJQBFkxRnjqzw9pQembxJVc6yKgDR3Ww0nonoVzI4p8tE1Py349NGEgjByzY=
X-Gm-Gg: AY/fxX6aYaWu1MraE4qryOpppa8FeAbl+3avtS6qyPs5h5DHGh9j+SsU6dSBGfF8N4k
	8rpFbWztI/gv2v74V8S4bMW0IWLmPf68C56YEVwNGWRcJmjACI57P/FnzKD+kL0sbxVhn8Wx4+w
	c/zqt7LFnWFnS3FQUthQOez5o0zDliI34btT4KP1RCNXRifppyWBYU53afYjQjZE22tYqLU6lBS
	aHp3937chnTLYp0eeTsdgnD4bDJVOtbbc66SOud0rRulTXIew3r/aqTwBjOM5Io4QSIYAilIuDk
	2YADgdv976Ci5QCI/Bz9OLLSEdAw8hfDrBlvc6x6ZkG8wKFW7C3y8EcxeUyWmqyI7mloc+ZagX/
	PPs17csuZD1KeyeIrbr+hDvCzT9s6OnpoN56xhQ==
X-Received: by 2002:a05:622a:1146:b0:4ee:3e74:43d8 with SMTP id d75a77b69052e-4f4abd752b8mr34646491cf.38.1766138914097;
        Fri, 19 Dec 2025 02:08:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IETiUyWjk72Laxdo1Vk6nOQPiwxV9KFZsPrNPyv8M50TH4aZslHUQCws2mR1FSndQbsPgKHlQ==
X-Received: by 2002:a05:622a:1146:b0:4ee:3e74:43d8 with SMTP id d75a77b69052e-4f4abd752b8mr34646161cf.38.1766138913566;
        Fri, 19 Dec 2025 02:08:33 -0800 (PST)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:a48:678b:dad2:b2eb])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324ea82f6asm4209571f8f.27.2025.12.19.02.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 02:08:33 -0800 (PST)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Fri, 19 Dec 2025 11:07:44 +0100
Subject: [PATCH v10 05/12] crypto: qce - Include algapi.h in the core.h
 header
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251219-qcom-qce-cmd-descr-v10-5-ff7e4bf7dad4@oss.qualcomm.com>
References: <20251219-qcom-qce-cmd-descr-v10-0-ff7e4bf7dad4@oss.qualcomm.com>
In-Reply-To: <20251219-qcom-qce-cmd-descr-v10-0-ff7e4bf7dad4@oss.qualcomm.com>
To: Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Udit Tiwari <quic_utiwari@quicinc.com>,
        Daniel Perez-Zoghbi <dperezzo@quicinc.com>,
        Md Sadre Alam <mdalam@qti.qualcomm.com>,
        Dmitry Baryshkov <lumag@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Michal Simek <michal.simek@amd.com>
Cc: dmaengine@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1260;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=SMWOwwGJxSzHnqJ7yBoaojvGxwV6GTuJEaiwl2WXaqU=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBpRSQR/MRuqHz4YHU9TEMN8SBEr98n35SSm14FR
 aNGRXRJQEqJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCaUUkEQAKCRAFnS7L/zaE
 w72MD/9EkEe/K9FSAd92hRRaw77bZNUMabNTVrznwnoM/8Pl7f4xOFCUWphhGK3X/72hrAg7vLy
 SEnzXTKn9wKCGiOvapvxRhoL0QRufeXLpKYdxPm8iglsh2Qhn8VWj4hp0j4DX0jwRxtiN9qXdqU
 VlctspkyIq/+sHc4hdqsuq7pgk6+hxMt1NKsQJASXDPyjj7WunZKoF7Ch/vXvr5qh9otUS1+6gZ
 /xk8Ihm0srAYCo3SLVjIggbdhFsQSRxznES2nzRwpmAk/W1Fmj+yX/rvNe+W7hXAayDw+wfg6bY
 5qSw3CY6OorJaWRE44nIjbT8jtc0JBbj1GQYC/yjgvW06SaVALiXPwtptUwczpyz09hEdKnMO0K
 LmXZl8+KZwQHSfPes2ovo07fBflzhO54O9Ds1LVr/5vpPk09gV0ogSqSsU91IsSceMbR+17Hu8v
 bCVPXPOAORcELLx7tz50ZkMS0Z5Z8VgjD4GSRFfo9rGam7qq2FAA7eH/wWR1VXTvvCuq2QDvf/g
 S8/OIgrVrMoNCjBqoAkmAOMKryGOkSE2xJcYB9iaYYNnzmttJNE2db91TbE2aEc/oD1Vxoh1GPD
 FzU/i8AdptZ1r1KRQraIiheo7EJTk/L6qTBTnmGSPqaNQJcsUIJ0QiH01S+ndtMAw0m4MaGaxrW
 UgLNEvLbhjn2frw==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: wz0xwV-_R6WdgU7lmVAT9HU9YiGClvgr
X-Proofpoint-ORIG-GUID: wz0xwV-_R6WdgU7lmVAT9HU9YiGClvgr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE5MDA4MyBTYWx0ZWRfX4eLeArDdtarT
 cW64N/Gj6S92V/K5fgK+HGnUchoCVDoAT0PnO1RYVhjQ96q72bTDKj7WdCsp2j/vlAIOSr3XoU5
 KVP6xmy3tn2nZf2V2N5JC/v362IVnlhleR95Wglvcik00aSDJNnyCAt/b6aLQGwt+XBaOtVAN/q
 JqDRgDrFavJx6HANqmsJHgPtw+Z+Qe8xJvO7/gknJ+HFqGjRpNJHGazy5N2okgqrA+02BNecISL
 7fTlmjGy2hZaxy5hMBckDI72bg7fUXywJgv12OUbWKn5FOwP4yDqEFQt0ksLIBzcZlwavnnQdWh
 vc9pVl5kCYbfqcN4jpaRn3PNizqC6c+DiUcVJnkv+MwVWaA29aueyj+10ynRFV2Jm9VEQMoQ3gR
 xfkiSxHFocF1GAyS/TptaZRxSllbFYzR7leTt3jAKd5RWcKy0YQtjGfHUzYQYuT7x6E0cF7uXZC
 TQMhYJoVM30rQWrnBgA==
X-Authority-Analysis: v=2.4 cv=WYwBqkhX c=1 sm=1 tr=0 ts=69452423 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=rvG61WhHFVBzVmnuldcA:9 a=QEXdDO2ut3YA:10
 a=a_PwQJl-kcHnX1M80qC6:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-19_03,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 priorityscore=1501
 clxscore=1011 phishscore=0 adultscore=0 suspectscore=0 spamscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2512120000
 definitions=main-2512190083

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

The header defines a struct embedding struct crypto_queue whose size
needs to be known and which is defined in crypto/algapi.h. Move the
inclusion from core.c to core.h.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/core.c | 1 -
 drivers/crypto/qce/core.h | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index b966f3365b7de8d2a8f6707397a34aa4facdc4ac..65205100c3df961ffaa4b7bc9e217e8d3e08ed57 100644
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

