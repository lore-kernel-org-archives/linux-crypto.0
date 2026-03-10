Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB18D3A6B86
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 15:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773157500; cv=none; b=qyL+O2lSJHI132znVxGr+6m9QvRTRwp0VUUaT3U9X0yJTWhI9vlZP0c2dtfRu6LWa3q+WculsSE0NoygRGXhBOUZc0NJyacnDtmpuJDzrf3HscRBkbmnQemSk/j1FvovCVMKH82jhwXkYIjBWgE842HPECoyRorhAZUtcobqr5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773157500; c=relaxed/simple;
	bh=D/DbbvsYNV6WfJJN+Y3qtsfzsdueJP3Q7cdgK44aCk4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=o6VP/P7GztKq416YFPTEmilnBR+uvBh7qIt3bfrlv8bvs+105KmiDVUgadxViXxQjpXYYvz2Cq/OyblsLzzyVfbsNVAJmNTobQrXvHJ/q9KPU11R0nRrYLI2TvJocpPI49U9Ihpg5okMvY60r4ZYweF/7BjmDtwx5K2Abvxdkgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=AiiIpaWq; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=HjRBsOvf; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="AiiIpaWq";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="HjRBsOvf"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62ACaWg5024189
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 15:44:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	f+eJOMoesWuzpXTSR4Li0Qt2PYtZi1rSvrjFdAlx9Tk=; b=AiiIpaWqXpKki8Pc
	E3kqxUeNlVehTwfUf6LJcxsxWMB7siFCCcIG5f4I9yV3d5ZQnhcUJkjWnQ6ug+yZ
	tz7kdDeW4FHe4xEvYwhZwlKkolXvkubh6ia37LjVcq4zQnrp7kXI+hdI2gRdUZBb
	OLUU13nTGJYXelzoKii2PhLCul5m2sKecjvt/+iqiOmKiK24h51zOLg2ZdNeprln
	E3xzMxw6YD5zYk4qWmz4ex0JToc6tYTA0bN7qlOZugdMCWk2R2jZZP6Zxz3wEqUR
	h0SdDk022Cy+6H95diIM+F74vieQIb8Ne3a/o/ao1yskWfElX0qCHj81OHxQlS04
	e6d/ww==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ctg5nhk54-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 15:44:57 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8cd77bc8186so3321826485a.0
        for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773157497; x=1773762297; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f+eJOMoesWuzpXTSR4Li0Qt2PYtZi1rSvrjFdAlx9Tk=;
        b=HjRBsOvfx0HIzDwkEvIia1S4NAIdAlW6a+0D1CHkPq7AyoVMWDNLkgRUVqTRUw2l6Z
         msklg09bqfIh2OfEzZfSYLx2TDldHdHcCYuSBnwrylA6c1Cne8gMv4+/pVnveomaYlEa
         Wo4GLYTvmGeZA03+BXw/bDzyQMkQc7fREO+RdjWzykmBFHl/dmsOtavL+uGAardFadbM
         La6T90YCiA+WC5AIB0c1HksbYa4Ijt49fEeWOCeIpSSrpwk3uhI97t0XkWNX6Iox8F2x
         z6/dVaopvpfypGClGzx0qmGMDBmwHgnOZA2TclKcYB7tWl1C6bv8fwxrHO022newbt38
         TTtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773157497; x=1773762297;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=f+eJOMoesWuzpXTSR4Li0Qt2PYtZi1rSvrjFdAlx9Tk=;
        b=l+pzNHAkrIBATdCW2whatyX2p78y3TaYROB0CYKMNImS3lT4NGFFIhYobs1OXKJQIb
         buscAWGHpp1JuPGOkxS8KCHuiozEyi/93bbWXlVjRnztikU0Ys+R0Lf0cGW2JPJ4sW9A
         0qzNICEcSoTAXcn/rNY1QsQTcMnfKwztk7NHIbTc0ksHlUDlalAwdzaXUkYF4iMaJ5wv
         qBL00BBtc76c0S7Lntrl3P9w1HKn8u9l/wUKN2Bzss6hADHzk0YLZMJLTNRI9JJUnj4T
         JM4rknZYB3OZSct7tBJqdXk1hH2cU2f+tL7PVb3ypUnBOYD7ZtTu95ztyRWJh6A0hULn
         cpfw==
X-Forwarded-Encrypted: i=1; AJvYcCVZse8l3co4to3gbTTQWFFC5w4Qjx86/3yEqGGdAfhvllM3czs5ADw0rbTduDoXRZQJ4EgbScTQGJZBoQI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8Z2GPhtBN5qsJJSFsZkxTHUGH5DSedJZ0df3MwD7nL+9eDfWU
	1h4HSoEr5AgqVzvhBTadxmlmVZQLRHbqVZ/YfgCKJpzfZjpgaFyZn/bsA8p+6RxLoLVQn3POh97
	gL6GfSkH4MKg6EzV1vh9YZcesNrtg2/sJJTYAHm7z3Z164wlySdm9UebVx9EuwOU+Lf8=
X-Gm-Gg: ATEYQzz7y2tUMAAQwtuFz7WkEEGszyZFXGwsYBULz6VR24ioTu9NOpaD177GNmfabrd
	TpsTHnrpLR9qyBQW/27JWrcAIaiufPGZOBy6GWVHvpo6SNPPVWNQ+AsV+OjQ+QHnqpmjZBHCkcW
	Ok+zXylBZP9tBkyPIRpeveoZiAnSjUGl/XQHYiR/QVi2QP9XJuu1toNEWglkBdpopI1HH5AoDOb
	+XqC14owiSfVlz3XXoJk0YTwx5RzP14H3BDcgV8LW3/H9iTRZ3reXXKnZAQcbPXCsKOUBml28cV
	SqtNt7hbn8/9x3FYwDbICe6P6GtQEt3HudPMRoSN6LZ87azJ0aT1BzyWNHApfnYp1tRIUowkbyU
	fdUfC1G/WxFn6AIqSROPJnOK7xIRthsLupw4Qjw6cBWRlQIizeJvy
X-Received: by 2002:a05:620a:459f:b0:8cd:9231:8b54 with SMTP id af79cd13be357-8cd923194c3mr566019485a.62.1773157497199;
        Tue, 10 Mar 2026 08:44:57 -0700 (PDT)
X-Received: by 2002:a05:620a:459f:b0:8cd:9231:8b54 with SMTP id af79cd13be357-8cd923194c3mr566014485a.62.1773157496748;
        Tue, 10 Mar 2026 08:44:56 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:47e6:5a62:7ef7:9a28])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439dad8d968sm35991600f8f.6.2026.03.10.08.44.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 08:44:56 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 10 Mar 2026 16:44:20 +0100
Subject: [PATCH v12 06/12] crypto: qce - Include algapi.h in the core.h
 header
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-qcom-qce-cmd-descr-v12-6-398f37f26ef0@oss.qualcomm.com>
References: <20260310-qcom-qce-cmd-descr-v12-0-398f37f26ef0@oss.qualcomm.com>
In-Reply-To: <20260310-qcom-qce-cmd-descr-v12-0-398f37f26ef0@oss.qualcomm.com>
To: Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Udit Tiwari <quic_utiwari@quicinc.com>,
        Daniel Perez-Zoghbi <dperezzo@quicinc.com>,
        Md Sadre Alam <mdalam@qti.qualcomm.com>,
        Dmitry Baryshkov <lumag@kernel.org>,
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
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBpsDxlQlPRGUaNldGUW96+bRTO91zN0L2uk+4lc
 p7wTjvcvw+JAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCabA8ZQAKCRAFnS7L/zaE
 w1apD/908hNmtgNlCAkn+L4FvAUewZLgyKgr7/esEj6bAVtRnLpfcUCo0hBzMtaE/Hth0b7A0UR
 KA0Dw+RN2+eykOGbwnPDt05CrE8OvQoBuIb1i/eKE4U/IE/rFfrVPL8IRfThjmL5W9AeTe2Vz5n
 hINZasNUEJ+aq3aK52cswdgiA91NE/MJ/WrnnblFg20UAfGGA0d+fmSp387KVqDJzvzzHD9VERo
 NA6x/wmIGLTwTMU7X7sIUutSdcEg8CTS8fLIjY1Ulrt+XrTyl3/qUy4EWskQsicRt8hianEOzAn
 kyj6bjzdwtB44d+O0dhAZZh2qr5YuvVe9FN1Y9P3H5lENTsmMgs+nxoo3JBXZ7kKI5B1iF08HO7
 He80y17YYXV1Srm1WzCqhuD8AbVEjMyNPf/WtgHsryifrn6VAYtr+9wA0d/Zw/Hzmq0C98TNYbe
 qSprE3oj6noh1N0bocANjUNppSpEXTaFb9qGrB54FKQs3nLDFDRtrNB9Z7fg+SAgRCk88MVk271
 Ki2vA3S2jAM1lczzFC41+dR0afoCuhJiEF4oHHshQ3TRNR5CxTscGnHY3kuJUY28wv4Bs/GZ7cx
 La3R9NQJXxH6NQSFPm/MuuiMjerNZTFcDyUZggHmcRoq0O4h4ppoeR/noHkz99DeI+fXIrTPhpS
 Viyzyo4xyU5GOug==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: aSLAGxXtkjGp8i12nYqV3cOxueXVpVks
X-Authority-Analysis: v=2.4 cv=ervSD4pX c=1 sm=1 tr=0 ts=69b03c79 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=KKAkSRfTAAAA:8
 a=EUspDBNiAAAA:8 a=rvG61WhHFVBzVmnuldcA:9 a=QEXdDO2ut3YA:10
 a=IoWCM6iH3mJn3m4BftBB:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: aSLAGxXtkjGp8i12nYqV3cOxueXVpVks
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDEzNyBTYWx0ZWRfX8Fd6+mzbZSy3
 KkiNSoSCaWSkpIlpRl2feb1okF4cGzc693wWZXMnH8x6GSoDiIWUFTsJ52TYqw05Yfco0Fylgx6
 HKzJLKLMVwOtPO6rDTB9hGK/1qeaiANUp7Mqu/kkVgcqNdUnQ7H+KREHrYOJvs6AIgkDgzZh/6M
 DOxANjB5qy2errlDsjx9CCAGrio0kdLYbjSuUAp87Dp3+o4+yhLxC7GCC73muir9D5HI234c5ND
 Xxx5HB+CI525/UN4PuhNmusZTPVedipbip8EJEWJo/75tJoO5r9g0Ug5mIAoVj2WimtIfKrPgKP
 W8eCfmjd8Rytnwzoa7s5R/3MW5Q8Gq0smjBPNy1trXGJBn9GIIJgTQxGgMgu/T+nl2ep/21iMCT
 I2kcFB9PNRvudGXChWT0KkAtyr/mjIKwVEd9zPW7JxoA+fou8Bsb8jbXMOL48PpVISIIAnFfuB2
 mwOW/XhcF81U+Ex0ndw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_03,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0
 malwarescore=0 phishscore=0 adultscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100137

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

