Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A003B38BD
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 09:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777281374; cv=none; b=dTlMLae9LwDd+tf94ptU7HTDZ/eiyzkQoH8C5V6r7nwhxY/kLK77vpuFX/DNbIpVo0itmkR4dZETZOi/2HMJr2pyxw9qBieMDep8eZKskQHrof86u7SmO/29Zr8HDe20S0oq9oCSoo/85mm4Pt0Bv1v5qEq52N9CDoD2oahLE0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777281374; c=relaxed/simple;
	bh=D/DbbvsYNV6WfJJN+Y3qtsfzsdueJP3Q7cdgK44aCk4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jGCxJ911+r4dNXwn6dPTjgdy3GV/lAL1BvPq8Zue00t2AHt1O0gjskCsVVCuG7qeEmmFShKLPP/9IkvTl4FduAR2yz7SXaxVeTn3PK7UmumeEECvSsRsyARk2RonG6L5HOtzFj7mLHhs/6y/tODMuffa3XOIoqdTPDyFc+52nZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=R+v7DjpM; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fzpaYRHd; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="R+v7DjpM";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fzpaYRHd"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63R8TBRx665673
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 09:16:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	f+eJOMoesWuzpXTSR4Li0Qt2PYtZi1rSvrjFdAlx9Tk=; b=R+v7DjpM08+VfYYe
	DvlbCzMwrLEpzHZnl5Al6qc0t40P97FFU6xI/9E4QoAq3KnHxmgfpg27qYuOmBxo
	OOa7zyswxeUZE+I12hssbqfgHajbiqVhal/ueXQ+70V//PrUYKzWvKAjS1VQnscO
	0H+t/5izpRpn2PcckM/Qw6LA/kZ3MdfpbQWaDpMGTWT3K+OhA3Ro6QvbSDnqM20R
	IfUiG29/CqFdSr/5ZunEkOcsHS7zt5FpIzrwsd+X4pBoQ/Mfi1/7smS6NSgFoyVS
	wxpfcDn4L/q92cyRkTeyQhjX78n1ioegvCiJ7tbfw3ey907cu/aFI7RPfQib86kB
	aAUtXw==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dt30n0kw9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 09:16:11 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-50d9a6a853bso138899291cf.0
        for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 02:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777281370; x=1777886170; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f+eJOMoesWuzpXTSR4Li0Qt2PYtZi1rSvrjFdAlx9Tk=;
        b=fzpaYRHdhMspOmjmgmeoaRrLajWIKqwtOsWKXHgVdBG3xY5Gc6idlrsILiNiR6h0nF
         R2PT3d3UavovCmRmZh6x+jB+elKsxJRQIxxBu1lxyyDWo8BcTTJsHGFvS6qgZAWDW6lo
         B/ndpIC2X+e1R7k9+5MJzE8mAFN1MHO4ykI8ISeYIgKYWLR+vQylGMN3Wy0wAA3PoDEJ
         VsbwSDrYO3zFnpov0Q72pt7vLPHjnAAu/B1JKiQC+DX6wc8BqDaxht0i9fRxithQ0+41
         9XWefSEB1ok+Y2leFejrySh3Efn2gAqq3FDafS203YuRMEx7eoRGMDVHTBwJZLOV4bxu
         QhjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777281370; x=1777886170;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=f+eJOMoesWuzpXTSR4Li0Qt2PYtZi1rSvrjFdAlx9Tk=;
        b=bF2PBeNEPNZrhwWswOp1Bctb9OhwEo8nJRlZlx30RIUtJqciGww+a2umK6XWKm3+SE
         TRohI9rjCZIWo5LhgDWrAW+/IPUgsNr7AeFyFxU9M316gWl0fQQo1nby7GwK3J1A3JGP
         /23RcJ+FUw4r6la/IkLmful+q9D2SdFrg38c5BmurNfTYyc70oruiJCakhpQ2CpqRVPn
         IhWhfKldAYeDwj4RQVFkjAUUfe53YRV9SrJO6cwrol++7gDvAGywFeFnZFYso2riuz7f
         dMJmC6zAHZobgdcIO2wd8m3CGg46bTkIvwQe583d8vr6Yhg0zz0zbcZZCgh8L5IJ2VX1
         /HJg==
X-Forwarded-Encrypted: i=1; AFNElJ9oH5Fd7VFYZmq6HVywrLxazoJTRRCjVvIrMF5CWXAKB7sqtMLXMc9J/Iau/wENonxs9ExQoVcG5b7j8IA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZZ6kYSpPsmvMPLfZMMwX1hLXZMs2ys4u5frjRNTremjeQQqgh
	oONN9WPgIO6OeCRqlY0iF+E7/6uYkb4P09RQcaqVdIRRS7m0WG809IsItnp2AB3GdSV9aqrig2j
	wDNa11BBlp0/uJ3hFmdlT/9GUNcWH2xtdPhU28/xwpZXmaWjsbITLFzj2UHfAiDRhd50=
X-Gm-Gg: AeBDiesRQH+f1F17qRdtTElm9Q89ui3xK+rzKQ4af+DBJFefmmRSb2ODWThygsrpU9a
	KsKZ4kngktRMnzVJ3B+htyic9hknOE2Xa/9fWOdKUhB/zYZnpdystqd3PgktDujdL7GrLv8govl
	+Oq9oGvUDj87gd60gDPOvuWsgp5vyetlM+sdRCKzrDj2LAZg5SgIUPHLNzUA6ZWWiBcsnm8WQB0
	AF1WV9ITt3ZxSZSn1psJTHgqUTx1FIjVUd+YRyajetOzrpt6J7zvvJnHAIwrtwv/ML4hDdnD8KP
	pBSIkdIqowTb9Kz16xnKPEPyAssiE3DPEg+dIde12MrI/1VBuwQ7B45CoctweXDJnRoWRVFEJOV
	Y+TsZOFavLotpCb0Iy/iOotfHA/QL1Aoi/LUa1Bp6lfJkrjqrHTUa3LmokffSuQ==
X-Received: by 2002:a05:622a:3d4:b0:50d:9174:cf33 with SMTP id d75a77b69052e-50e36bd1596mr641063821cf.16.1777281370264;
        Mon, 27 Apr 2026 02:16:10 -0700 (PDT)
X-Received: by 2002:a05:622a:3d4:b0:50d:9174:cf33 with SMTP id d75a77b69052e-50e36bd1596mr641063091cf.16.1777281369336;
        Mon, 27 Apr 2026 02:16:09 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:5062:ae86:23aa:702c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a6dbfd4b5sm40559365e9.28.2026.04.27.02.16.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 02:16:07 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 27 Apr 2026 11:15:39 +0200
Subject: [PATCH v16 06/12] crypto: qce - Include algapi.h in the core.h
 header
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260427-qcom-qce-cmd-descr-v16-6-945fd1cafbbc@oss.qualcomm.com>
References: <20260427-qcom-qce-cmd-descr-v16-0-945fd1cafbbc@oss.qualcomm.com>
In-Reply-To: <20260427-qcom-qce-cmd-descr-v16-0-945fd1cafbbc@oss.qualcomm.com>
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
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBp7ylCsbY62JQL78TQ6pa7tPcwWzVMzgWmfI8mt
 neuwrXBYoyJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCae8pQgAKCRAFnS7L/zaE
 w8GeD/0f0hGSRTrxbft+ky11wNOHW6gpPsQUMZxchB0jlKZ06wEuqPjrZmdzeq+eFBN9PavylCt
 2MNzx7fi40kYNwqJ3ZU7eF808EBXT1WsdhK+plZ4zsg0u6zYoa2WqRQ/KZx6ED+iV5qDs79L+/j
 Mv+BBesfRJAMPzZhSWCx9FPsdPoaxXa3C2jchI5FFLjnS9paJsdyyZAEV2F9mrQAmZqw+gGaSx2
 iHgY8CAfTIkOzIKhxx1TMDvnk6B16lf1z8tc2T8xRZj+96st4cD0rbunTmtnh26mjKkAKEuDHXG
 zqryNCPVQesibGbyDEsCNgPatTUxvF70H8FF410ZTbApyNigXMvMfPkrPwrvvh2rWCCjk8ZcR23
 HuOz/8sExodRlzZli0bLZvKZ0GHLJdcHKKqvYsUchm233e1Y/xauvgTduCdrpGGiQf3foEm99wA
 +y6BteSGDADA65/leQTZO0/Z5m2v1x5XLLo+4yIGiZc7nftUdAVxK4+ZT4KudGm4MMl5MjQ/+0m
 kvqsMyoIJBlHhHwN0eL1ODj9pQT8g5CJzM+F7SYWGhXV5nP4KxRp/U/qJ8jy2lWy5vN760hSLhR
 QwWaoZc3l/2FNDTuAjNeMf5SftLEj7NZYJpaH/DtfWmtARmll7laFLAwj3bmLoMqDbx1JGtnB30
 Y4KS4Mro9F37KwQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI3MDA5OCBTYWx0ZWRfX+smebb/yyzz9
 p6teI/70rmpjV3MB8nd988mKLD9z2IRBgn1gbRkdKhk3flRkboQA6+W+0u19AXU8O2yNz168P5l
 Fou4rqxf6Eb418SM8Zhs5nT5M4MR2N+Zf1LuLNgYupf7WP3btjXCT+CIDev3JrCG7wYVR9tJOdi
 SWl/WS+o/CaCLo9Tq1ki02lUWSm4leUt/M28b1nUjrFzdJ3pwNBaNo6xRymuuFvY1Dkn+ceUrPJ
 kp62TWI/ESMIZQLZ19KQ5ntM0lrfqJX21cHVx4Ih4GJz60FqOYrWTXWwEi99EozzySgpqLyDyTp
 S9Lxbd4ChyI7PnEm7XCoUca8buPHBjD5Rb/9U4R/LMUchYNhmeEWZFEPaR7GQtoVFzPEivHzk4e
 +rNuUYtXtSEL6pJ43y7TE+NKSI9cdDvgVW7o7fXg1guyDIeWZT3hn9ijEabkdEiIbzRBfLy+xWu
 2LN/RAj06dSZJOwjC4g==
X-Proofpoint-GUID: TfS_FNcPTJvyZvaBKSN6XKukW2Fqgzkm
X-Authority-Analysis: v=2.4 cv=efANubEH c=1 sm=1 tr=0 ts=69ef295b cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=KKAkSRfTAAAA:8
 a=EUspDBNiAAAA:8 a=rvG61WhHFVBzVmnuldcA:9 a=QEXdDO2ut3YA:10
 a=uxP6HrT_eTzRwkO_Te1X:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: TfS_FNcPTJvyZvaBKSN6XKukW2Fqgzkm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-27_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 spamscore=0 phishscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2604270098

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

