Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3B33E1223
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 14:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773756175; cv=none; b=Ie9IJy8AI+FM5LXZM8mWabKZAcZ118aj0Yq+/DxUW0XNdBz1c5sY7UYwdxQTsmiJXYIDUf7x8fxOzkT8Bu8tG8kcqDLBDREPRl7YNWiDeUbGoajlUCTNCOJd0poPLkV+G7O9zdkzGB1pkq+g4DVFLmwoEZZJvUq1P3hhNTlaKaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773756175; c=relaxed/simple;
	bh=D/DbbvsYNV6WfJJN+Y3qtsfzsdueJP3Q7cdgK44aCk4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Z/0iAxNCDUc9NIaRl5Y5inKtko06htHOSFTRMYOuRfOm+g6dg/5bxar7y9Qu53nDjbPIRHX63BV9ADX7nz7sccqjFLiHn2Fhy5QDl+Tp5UHRegyG3b6xvX/6iwGwaKlOjdrjlWKPVSE5dwNnxOvHBXXX2oPQaK91/ySws8M0CmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=J37dUWlT; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Eo5XXe/v; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="J37dUWlT";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Eo5XXe/v"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62HD50Lk668945
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 14:02:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	f+eJOMoesWuzpXTSR4Li0Qt2PYtZi1rSvrjFdAlx9Tk=; b=J37dUWlTLsOBHZNw
	6VWyQj6ki0vlQA2P3S0na4xyWdhNPs9TDNzuJJSFoQjH5fBV/QAWAfxiy2E1HFnb
	nZCg51GLiYXD6kHA/6H7g91aXCBDusODHpczTtOz5LgVs2l9UrJo6CGFnAdTM/tG
	gLCPkDyjPQ1NErUhdpw5td/7TX3+ph3DBVdoeRI1tFvVovQFatQGBM92690KJQRW
	hUt4eq4SL8o5318WBT3o75smfaeZ1Obbh+NFSqm120ZJVwCEF4b2KnpV8apFn565
	u/bYwBcOlBCadZk+bmmdQzTuk0D4McN2Akv30CKisYxHRyrz58sa0B6RvvzoT2b6
	R4fjqw==
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com [209.85.217.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cy7he06w0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 14:02:52 +0000 (GMT)
Received: by mail-vs1-f70.google.com with SMTP id ada2fe7eead31-5ffca417657so50210484137.1
        for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 07:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773756172; x=1774360972; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f+eJOMoesWuzpXTSR4Li0Qt2PYtZi1rSvrjFdAlx9Tk=;
        b=Eo5XXe/vi6x5mu0H5msxVvxUNa5flaq7ScWGaqBzitwGTWOICBUMiYuzhM5u79Nf54
         53AAYhRyzhTa4L2VC1v/3ZbV9YO1fxSHwNSiGpodF7L8nw1J03V4DqJF53uEJ5PhJYFa
         AyKs47tI8kcrx+oX0eGvHD7K+UKWWP02U38L0anQUOcV9kNwz3Ef1KXl6lp9fFu+fa3w
         pluxYapaqG+Gd/dDxaaUWHlH1EMfZn2uQY1uWbgEyib7IRJ8dOGQVsH0ghhq8XpPx6T2
         krG9c7Jx3MBh4eIIaCFUeg3B3kKGxekul6iXMe5L9+6TCfhk2JINMSoHGbCNmnChxZcO
         KvNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773756172; x=1774360972;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=f+eJOMoesWuzpXTSR4Li0Qt2PYtZi1rSvrjFdAlx9Tk=;
        b=i4/hUnvm5fKbuvvv7XTLBjXK9PxWMJLGXVEhBM+7EEkuhC/xkz9Ay9CoORKn4vP62R
         JeDjkb/SSMzq43LbLEZxbTXdAcQnaE2wcZd1+yjBjD2vmGCpqCbwGwGjrZHskWczZO2b
         veoeNLl9NOZIJi1t+mSp/xkiTgxFXNw0Mjgulmcyb1a+1CkmcP+7c8/ZvkC3EhzrQYSH
         uMqBy952RSQe/eatTeFflcWLlnsBDo7YC9kpM5j1j2CjzIBL8Xp0DfhIIv35G3QWgJXG
         j0gRENjzNMDVa685kXHLMhobrw2ormpy8378sJjqtjuzkI9YW7c+ZEh9cke50wrrNM4f
         wSuQ==
X-Forwarded-Encrypted: i=1; AJvYcCXqT20jyjYf/YuUfgw4B+2E5ZI/ujLrLPDgr7rKl3fKtK4T0plT7ZQX8skfmA/F8eubuquAIdGbrkE0/8Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2qO63AyNzG9g/6cZh5B/0o8zUhUgbA9e4anK4Dw42zgZXUYsz
	LZo3SgcopAXwWPdqQPDMPRBkD45rSf6Nx6rsUqbf6Opjphuy1+eRMvg5Gb2iLUnk/Ef08kkIy/Z
	BmOZp++T4o5zlbRYvYEHCecBxQnp2xw2681eC5c7ZUL0C4lFMv21Xzre7qqrM3q4Cfqo=
X-Gm-Gg: ATEYQzxRph1dgi2o/B4JD+6WChyFve7hZKfUMM+/fXV+pzIlwGZc28gpVJQpMwpsnI/
	SpgtDGFNpdk1+MdG2+JTfLICHeNedqWyLt5aVGWz3Fwygo/UcQWMkffm9DDuuI/kbd03PBIhRTi
	Z0gxHrEvx/z9vRLzW+gqQalx7S8CFU2sS7O85rUm2rffaZcFdbNFys/jRD83V8gJiKYLeDliD00
	t9aiL4o0cE4rI/g+MkuAlg4o3GUkjFBCZCGHFAsA9f4JqwaQBKlgz3zdMWOT/HP+jr1u7/4uAvE
	N0efY3/7JvCix6M+S8C6qHlJvZDA6hIeR6pEjBm5z6K07BzGgzqHg/HKuDzV3ZYFLTn8Ei5LFm1
	9U9c/RsUzk/kXd3O9wyJnkyki2kIAEolJ+J1hmc56mhu1QWP4g9AI
X-Received: by 2002:a05:6102:c8e:b0:5ee:a494:1747 with SMTP id ada2fe7eead31-6020e5694e3mr8012681137.36.1773756172418;
        Tue, 17 Mar 2026 07:02:52 -0700 (PDT)
X-Received: by 2002:a05:6102:c8e:b0:5ee:a494:1747 with SMTP id ada2fe7eead31-6020e5694e3mr8012635137.36.1773756171962;
        Tue, 17 Mar 2026 07:02:51 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:6aa2:dd35:4d6d:8eec])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b4938854csm9359709f8f.34.2026.03.17.07.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 07:02:51 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 17 Mar 2026 15:02:13 +0100
Subject: [PATCH v13 06/12] crypto: qce - Include algapi.h in the core.h
 header
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260317-qcom-qce-cmd-descr-v13-6-0968eb4f8c40@oss.qualcomm.com>
References: <20260317-qcom-qce-cmd-descr-v13-0-0968eb4f8c40@oss.qualcomm.com>
In-Reply-To: <20260317-qcom-qce-cmd-descr-v13-0-0968eb4f8c40@oss.qualcomm.com>
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
        Michal Simek <michal.simek@amd.com>, Frank Li <Frank.Li@kernel.org>
Cc: dmaengine@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        brgl@kernel.org, Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1260;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=SMWOwwGJxSzHnqJ7yBoaojvGxwV6GTuJEaiwl2WXaqU=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBpuV72seWPix5C5UOqBs0Dp63n1k65CTcZe5fCY
 yykFpDMoe2JAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCable9gAKCRAFnS7L/zaE
 w1sGD/9CfCSpmvX3BBs39L75twLMua/5LB7A1lDSNRSXgMm2cNZmPwLevSoCxGK9J0luJJjmDxb
 1LIQrNrz1Ct7+GrAmR1pdB0DJtPJbOCUsbj5SPE9fH2KY5g8RgpUqJcoOtLHfegLaeE+lhQb5Tf
 T3sEonHjE4xiYMumBoq5KuuHSFZaQiGmUs8OL1lbbhikfsQrFPfej61pf3QlIyfsG2JdhPzfCa1
 4RFS2bmN0836Hup8dj7ixmv7zz/XZtumaqlhKnxO77YdfDwW4Qlwd9KY+DMaaf0rMd0xyrWSdO9
 wYfppuy9Tp/Lk4G2lhCNL8hAmHndDBNJZk14YiZemTB5iQ55aMQ5HmopEj10+eWrgSbXOOV3usN
 QMkBvIU+Bt00I/vdhbrBwVllQBFGy6bMd83nvjnqr56XeCkab4Kalfz6F5WGiEZ2uzsb9Ze/+85
 KUMMRbBAnqaZW+ZHcGUakvUXrDgmF666nFEObqVslKjkAAHhOHr2CbgB1PqpztwsdmzUsWI8a/J
 ncm7bElz4hpt0H2h4N/olme/2OpC72Lsigb+eq/On95ZlxQ8Tp3L+dYYgJXIHLBNCHodD4HWxXf
 j4EyMjgLuliwK2o/VcxyxTrTcc7hCtY+JTkikwyuBzYR7EY3w+nq6Lw23Vpog+LaxmiAooXUJ5h
 PbIDsCpOPR1R7YQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: hYGXwxRgANbsf9GLCutOCXu3JiLXYc3B
X-Proofpoint-ORIG-GUID: hYGXwxRgANbsf9GLCutOCXu3JiLXYc3B
X-Authority-Analysis: v=2.4 cv=QsVTHFyd c=1 sm=1 tr=0 ts=69b95f0d cx=c_pps
 a=N1BjEkVkxJi3uNfLdpvX3g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=KKAkSRfTAAAA:8
 a=EUspDBNiAAAA:8 a=rvG61WhHFVBzVmnuldcA:9 a=QEXdDO2ut3YA:10
 a=crWF4MFLhNY0qMRaF8an:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDEyNCBTYWx0ZWRfX3O7VekQ1Fquz
 9mvJPCBdsN1iQ/GHjZT0M7ANqvFzt64qCgDa8Iuhp2rH2K+uFgADfqC/MYo4xvyjeBwdyI1BbQs
 /NGjaj5s+ppilUfuGtFmbj8EnKqEWWtjxGWqjlQuiVRYGMj8EQVF+Yj7WuRPVcZxCbCRWtPsvxx
 +4LVRVf403FOKfCFF80WUhoa84lrTEfA9GNT7EXSPzXLZedrfcFCHsp6ZzK2py3jAxBs6OEBfTR
 EPIe0fc5uilTy181eiVq+v2G6P5WZGhGNo0+MysQyYlO8ESUMo78FmSFz7MPAmBv7/0flYYI1uY
 Yc9xrGc9RCG7r1+YlmQSrGIN8uiMWlsHs0jaiXpagqDz0Q6S7D91rTmPiDGmeGDBv4iiUXwyv21
 0reJ+8AcjQOWulpYRNbXnQULCCY5Nqx0GDYhebQV9IQdmicm6neiktTN9z+KltARWi+A1YAiK2A
 Z7l5fj65LBYW2bj0UNQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_01,2026-03-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 priorityscore=1501 spamscore=0 adultscore=0
 clxscore=1015 lowpriorityscore=0 malwarescore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603170124

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

