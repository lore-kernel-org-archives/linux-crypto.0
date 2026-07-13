Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2208E414DF1
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 13:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783947715; cv=none; b=o5aaXhMwKRJsAH6FxkY48hRaJDDGVo8ffeqHf2j0wn31blRkhekfFxllrwWhstPxv+hDO5ylBLLk6pZoGSXH1KShUr0RRS4uI3KvVDAp38buZKkstwTXXeiZ/JBSIsYCBq8r+SyQWpLMLJsUJEMT99oo4h3znf8MxLKbeMHzMr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783947715; c=relaxed/simple;
	bh=vuAef0aUBOeSio60r/pSKcTossm3V61GQJlAyMtLfKU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dKyMr4OycQAhcvWgKAqLyf9oWBhelyG97bxExwsh0HfD/IABKsFlJSuV91Tkdgkz+lbgj7/YndJlC+VqUIb3FsIyNNuWH8jxl6zlYVTNuVpQmvRQgLjf+4AS4ScanXLuhA72xjJ+FtehbjuhxII7tbeloShXZAxUqUhBX6qP0hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=C++bvYKo; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=hNLaHypu; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="C++bvYKo";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="hNLaHypu"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66DCDbwH1299339
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 13:01:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ToTIYJiHy5tONa3lc6dWWbGZLTEc7JJCb/cDS7cr/tE=; b=C++bvYKoKA4PWl7z
	Fj9/BoSaXCBYnuw4KX+woJ/i+yg+v7xY+sKp+//LJvvMGIjjIxqwRDB6wqhSMZuo
	eLjIT97Gph/mHA6sWUtUhzbQU2W0NnUTG/jtz/CPXdh9v1y6UAj0IIPfzqK3r6ha
	Dml2jt6/TjwYUxG1S+gasWwylClH7hIkIhbIL7jJkMRQH0bDnsxBZH/8VUkq2NgZ
	XQ/I3TP2rSvZL0s2xLCC9XzKyG0MPv1icVvtjGaKC8RgTJlF5bb+MEIYcnUhs4s4
	RZzMTzfGw9eES+jL/zP+neNSSsSdxErLHfIm8x3LeoYZ8uYJGhIpVunKCPXBheCR
	8SHQDw==
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fcwk3gq2k-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 13:01:53 +0000 (GMT)
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-6a18e349abfso3974443eaf.0
        for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 06:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783947712; x=1784552512; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ToTIYJiHy5tONa3lc6dWWbGZLTEc7JJCb/cDS7cr/tE=;
        b=hNLaHypuslDplWc7Ulnx0KfNsLEu0cOCdn6DY+q9pfcKDw/ac625dY+JBGQAFstH2x
         oLb+/nqGTBUNKtXVD4elAoR4joq9CF7HjWCiMSPGLF7I0Ha7L/t08zKZT90Z9gC9pIfM
         KtIMciey8iVdBAW4lmCZ6h1x0t+3S/BqB9jVlHwIP8iIeuiNP6UJJHulL+9wxUvRaVOy
         PfXS+LOENfTdjEv+Y3ziuugihZ3b8XOxF5msV9Lx+dYYmetzs6k2N86t/QzjdwASHZqd
         NTETux1zEe0v1yMxY1SkGg45UZFl4ZcQENKNoXUGWfWZDtmUAEGwTlMNd6fQ99hhVNUt
         ti3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783947712; x=1784552512;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ToTIYJiHy5tONa3lc6dWWbGZLTEc7JJCb/cDS7cr/tE=;
        b=B/zk/yjEd0zFgZ4GVyHoid9/ORMpevB4Xz8ciMwwXvDPTA6vSNpz2Ue5l+1KwFqP4T
         +mGSFzWnKRoDPz9xH7VxzLuVxujj5CAB300FHhO+yCTdgynfgaEL0a4c27ZZKoTgfP/8
         UazuPE2u05/D7Q79fFVCw/GECfX4KYZ0bOxLNbRXsC9S1z8CJM0VPW0pyLXTQXeaQh/o
         PvsJzkqqIV7znBP7KN+LWNAIzBBwnYkKsttHDCl4vagf/vSa5hcQ8oxldPc68W7C48uf
         JTRqH2wmHrsE2f2rRoSUWsbwTC+GZ6BePnDG1IlBH/tiZq88LlbkQrlgC1tyJp0GlWpm
         2rOg==
X-Forwarded-Encrypted: i=1; AFNElJ/HYHftc5twbZQUwYhMZUx1LtryXiMKkfeZGDok/BTq3r4ZHkzUtWNYqeb9ZE74KNbbOsJh3vtVlEHwM9c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0RrvjbNdu2CTfyt18lFLLGNGITVGP2r2PY+5FaCrCz/FlMRRH
	L3mOp2DmDtGbqMptGzRt4+20DzTP6ecEtsaz6qX2udXN4f/1F+dohtd3Xd5fjAa7cIeoaLJGCaH
	mVxQcGWcyMw50uM+SEKX4pevJmy2cYdmw3w954hjIr0C/3/aWWxhUazxJDevMb7Xot5s=
X-Gm-Gg: AfdE7ck057gYoGqOY/XvokLfnosZV05VChZk67gss3rgIYlQ0q11s8r6g2tveRNDQ2O
	PhsZBo4HNW+VsYQouNYYQj3msdc/o4fJ3H1f38OKG5GVd2bWfGGdW2kDL0/nrrrylCmZhNFSV4x
	G8I8VsCVEfUIgoMYRj5+16SlqHxEHhucazBxtI2V7TXRuJ30TtV4XDbrywF8U+tnciwTloOI7MX
	/zNJ9p8q/i7iMLWnnh9YSjU+ZD7pocuwrmYFpG7dzNU8wVw2iyyZ8yNiwvRXv3ZUh9J/GmSfKPR
	dF42UAoQGMRE+LBqTH29uutGNZF6UqZ3yAQKENs3uT3W6y3ThHxlF9Gc58tQ7GXXqSPshZJ1oVd
	STf6CyVuR1UmlXof2DXTO4OZ8LxA/TclRETTwyXJG
X-Received: by 2002:a05:6820:1a0a:b0:6a3:7d5a:1ae0 with SMTP id 006d021491bc7-6a38b9f0c0cmr6902390eaf.29.1783947712307;
        Mon, 13 Jul 2026 06:01:52 -0700 (PDT)
X-Received: by 2002:a05:6820:1a0a:b0:6a3:7d5a:1ae0 with SMTP id 006d021491bc7-6a38b9f0c0cmr6902275eaf.29.1783947711045;
        Mon, 13 Jul 2026 06:01:51 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:8881:83b8:89fa:1a2a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493f2d97527sm306129725e9.2.2026.07.13.06.01.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 06:01:49 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 13 Jul 2026 15:01:09 +0200
Subject: [PATCH v21 08/14] crypto: qce - Include algapi.h in the core.h
 header
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260713-qcom-qce-cmd-descr-v21-8-bc2583e18475@oss.qualcomm.com>
References: <20260713-qcom-qce-cmd-descr-v21-0-bc2583e18475@oss.qualcomm.com>
In-Reply-To: <20260713-qcom-qce-cmd-descr-v21-0-bc2583e18475@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1305;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=CUp2WTmSuEfCdx1+Ds/evRL1UENxTV/cwxTY1f9GBAU=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqVOGdIJMZbD30Ir6MPnqFekcNPq0AjO4fvaXMy
 HuGbWZzdr6JAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCalThnQAKCRAFnS7L/zaE
 wxivD/93ThfidN7R0lxtpI59l//wvd89SN9EFKqvevdrZmeZUM2n9BNk+0V2zIQ/T75BQQ/4WoK
 5ZMmrneskmHZk00O2+JYrEgdsKna+qpriKe/bGoKg8wPoAC2u/Q/bChbfeisnpJnJ+/bVi0PfiO
 ORlAvQ1g0DCmTfKYWa0t46jTTlivRLUqzZ6kHY5EbciCGV8omxWLlkQLvDOJZrhJDK0aRjRgGl6
 iR7inEOFnjy2WbUB34Nu4NQj/aGtKNs/3gwtkmXqyEz+FlyzZ4niadDM8RcA/4Sz1QzS95SgX6C
 DkhSgZuZSA8ilJDdzP9fE/ZUYWAkJ7/UY5Q3E4n63UgGlRPZJqCVA7v0PZqchnWcn6d36C6tWRW
 jM9eJRbvimDuWPnpUZtp078615VgWGDjrD8W/4XbWARxrl1IYQWtR+ECB65+ekY9fctfEbF5avG
 WK1lvxeXw95NQvdHd118d8o1BLMucX0PHPjz7oj51Rv4c/ZhD9KcufolYQfQ8T4RuHHTjYF6Cuv
 Bx1DA2U+E0jeIpGnIRDte0bm9ou9JYRcNGMPkEO2jG/adpYdbMhf2Fh/V1sgHRp4teFYA+bi20n
 Fmk070j0OyWbe6NEIF33u7HjXVT7WO045hedaI6Ajug85whxWdL91I+PqIoA2DDCJ/JxhBYrE/7
 UZBBDi+BCq4stKA==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-ORIG-GUID: 8DNVv3j60PVstxJTzIwUn9xRNEX5PYVM
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEzMDEzNSBTYWx0ZWRfX9UKkstF8ZTAf
 SqFpCm8zq9vYGVkB78pbg75mIWEV5CekLs4tXflImvWJxKTJGS83B/Hku/+EEMcBY37Ji7FwLsi
 u4p3XRlIunVH1Nq8hdGzB9yC6pJMwFQ=
X-Authority-Analysis: v=2.4 cv=e6c2j6p/ c=1 sm=1 tr=0 ts=6a54e1c1 cx=c_pps
 a=wURt19dY5n+H4uQbQt9s7g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=KKAkSRfTAAAA:8
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=rvG61WhHFVBzVmnuldcA:9 a=QEXdDO2ut3YA:10
 a=-UhsvdU3ccFDOXFxFb4l:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEzMDEzNSBTYWx0ZWRfX/5Gu7DqLb1cX
 S2dnCSKqVH0B6tagN00zK8qHpLJCAQqW+3jWKJsqib+eKlVKeUZkfhe0O+548yqbPOq8L2QGILp
 EuKk+7sZ3i08YVmMN3o5M5zJv7O+EEDPo9J7Gp/3Jrve0Rwa7HucaDxrw/DzUAmEV65Z3Df7aRW
 CCykaBJVEtQMhmrKvtfZjSkRGiLvX6cBttDPpS5Swap6ss1Y000jkC4NQvo4PlwbAwCcdOEkgsl
 iCU1Gm2nkEoH6Psvy4RShpOyOuxPcOcmzM/px5gAhYUPw6gaB1Ee7UQi2UqJdIOj1s09iTC3WiG
 iLPaI6P99XL+4R/jhcYBiEAHQA1qgfCyl0moFl3zrEu/E42GYfQyQmXJiFL2cZtCPv8y99jUfja
 1ixgCU0opR9K/btuQYmJdHcID5bgUoTGk8GwIP3TL7ytrfrTwM1KszG+L2HzbWgTaOvcLLOXY2P
 kIwKwTb9aUkxGeh4n0A==
X-Proofpoint-GUID: 8DNVv3j60PVstxJTzIwUn9xRNEX5PYVM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-13_03,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 phishscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 malwarescore=0 impostorscore=0 suspectscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607130135

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

