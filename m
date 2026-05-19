Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019333ED3A4
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 13:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779196709; cv=none; b=ueVd36sCE4zr6ml3HHmFpIyZNuEzCJf/neoXJNJu8OiZjp3tqG4amI6/2eqMySJVVs6zHC1IV/myd+k4dI+0MgWccSfjvfeUUQetCKktpU+JoRmF6HnNU1ghDRsF83p+4AGUQ8VcmvvGLD3vQ/h+2nTbq9catjiL1GRI4DnHDrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779196709; c=relaxed/simple;
	bh=i/hee7JvrUVQKgQBcZArSmkn8SGmb1u4xa8efxbKLTk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Bz5F6QQpBb4eaTySYEvxEvLP2qzuVNYnL9fa7Xywx/xbrCa0ckzJcs3O/hM+PAnB77lT0rU/+NhfjLJ1GcrA2uov3gBtPvH0rLNC3NP1jYe7Ol//4Bw/mobGvp6vFIwUJPcjylMLxFe70mD60HSNZYBVvI8HXwKtJRUb9EAzRSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Wpp7bdD7; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RSPEBmbI; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Wpp7bdD7";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RSPEBmbI"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64JAhQk7867065
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 13:18:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Ntxg0h8brd5Zc8YpW5fnE29VKbWAlpqls1uKilqWgRI=; b=Wpp7bdD7iDoC4I38
	aiPh4ic3YWuhFlkZSOFbiW+wWkkN3pDFK96/UYn2CunmxadYtELhHGPUd9U8GMfg
	QeG7IkA2xhGomE0b6gED832EVHwPplQtIoslT7KRtcesGYIMZ15aCpHJzttJ6sD6
	OQ1ENe4MaPQxsgbj1/jFpuTvlfkE6fA74ZSpcsMXKP9timFJd0wK2fzF1PPnMw7A
	oSn7EUj24knHVSgMoKkS+4/I9WZp9uC2zre+EwZJ6RrDCmT9CH1vO4Q3Xpyeqker
	5qn/b6NwF8kWB/wIjFifI6j51+aSaktOt2n+RjtFf3V0hlWKg2W4R3P6xegkiIIr
	ZIEgRg==
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e8hv1hvhr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 13:18:25 +0000 (GMT)
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7dca6ecdd85so5693799a34.1
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 06:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779196705; x=1779801505; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ntxg0h8brd5Zc8YpW5fnE29VKbWAlpqls1uKilqWgRI=;
        b=RSPEBmbIOoGKpavHQ6lXwIS/2KowbHss/kcVao94NIlCsOMaHeo9FwIH4y966sL6A+
         NNTJ2h4Ll74aodSWAXE0s+/gMlyeqKFK3L9Rg0z3YDBP6+DTucjfceeDN0n2jv8owR5I
         eHLN3fKEALjUbSf6GtbmuLWLZoWTu9FxmhAVJjQXMLRtTqVkaiC+drxyzRoAU5zgpX8f
         0LzcpC5+TBV4ahGYQyKNhzeYT5R59MTA4YfLORghY89gko+MgZLN2tC07MVMg7eCxAhl
         sDIRYWp81LX09p1ymZs+7iPLFinsskfCH5fEghoxxiOkbt8nSR3rgDbvPt2mkmXv/QyJ
         EChA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779196705; x=1779801505;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ntxg0h8brd5Zc8YpW5fnE29VKbWAlpqls1uKilqWgRI=;
        b=DSIcRqsCCHl+iQjEHpuz1ws0FIMmPB1rAIh9yJ5fEUcYkZgpP4j7nSq3DLLu+kGNzU
         mkiaQVIjK4TZ3vArCpkBBPvNLO6jCWatdAwybKwcFbDxmTkEYQS2oMf9e6VAfIKsdLF2
         BZOdddLnWwxIXUNqR1fI2ZbUsg788JL3gKOVLcM7WNPVc0pu+YaTsRmDq9Wj+BKDfpVf
         Iw4kIiaRT4O1Q4RzI9bp9jkRgUNjl3OCOFBfdMx2mgOY0UkQr/PTia64BwyT2oAtP/Q1
         2TTk+PGKhBAgMh+NEcdlMfajyGJ7LiBcvt6gCIk6n1YRZxq+Wb2ozXtrIjfUpcpOgSK9
         dxIA==
X-Forwarded-Encrypted: i=1; AFNElJ/sK9J+OjmIKEM4moHy+tDiXswH2F/WKwvJRN+AfN0e97B5IQpvwpKbHp2n/xrtuZ3v7zWIUWxZjOVfkOQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4dSFU4u5lfxe6iUPuAZL24yEtoPgmgCvqDChkJm+rZMd7r/uS
	q7SDQ9A9shN1To0SMJwhjM9dFFL6RueBLp+Qqyj1Xp/RiST1SX4bIuH3YJXov7n8DO+cy2VBP8q
	OsG1lnDNTL+dc/LB1YCpBZiWZ7/stmznVjqvvDNtD7EiVYG74RKSfrTcXvQVkoEMbbns=
X-Gm-Gg: Acq92OFBDPu19LNdocHTS2gmX5xjR/nu1sjclf2RU8QRLYrK5FJvXi1NQrto06Pk9Uo
	JhwOfAnK3H3VNe+uGydVfRsjvWyNx+DyAJJ2ksph1TFUa7P6UbbzzwJgzM7dgQgriAL557BQbM8
	G2oTwcMt9Ux28yv3mjS3zLWAdEWqayF0z3EJJieG13FyFGyjQLOvTQ+jSBDqnwg7/C77Js7yUCN
	I6e6g/jwo56aIXil2VMDHDkwxLhWglAT3kGfq1YHOMbNuS1KWeMwZi+ajyKXLLoFoO9QZZzmv+k
	FvEoWM8paD5dGo0J+zGW4X40ZaZ4P4X06QcwBt640yNfCzU5MXJ4EX1fcXXPgNHq4RQ/W0B3CZ6
	9FThmWudRpN1ENy9+trNz80f2LJHh/c9+BMXP9gSxgB/zOAPm46E=
X-Received: by 2002:a05:6820:2210:b0:69b:8ff9:f582 with SMTP id 006d021491bc7-69c942ea069mr12773849eaf.14.1779196704907;
        Tue, 19 May 2026 06:18:24 -0700 (PDT)
X-Received: by 2002:a05:6820:2210:b0:69b:8ff9:f582 with SMTP id 006d021491bc7-69c942ea069mr12773803eaf.14.1779196704457;
        Tue, 19 May 2026 06:18:24 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:3fb6:74e3:3c25:ba2f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48febe7dd22sm143969195e9.7.2026.05.19.06.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 06:18:23 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 19 May 2026 15:17:50 +0200
Subject: [PATCH v17 08/14] crypto: qce - Include algapi.h in the core.h
 header
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260519-qcom-qce-cmd-descr-v17-8-53a595414b79@oss.qualcomm.com>
References: <20260519-qcom-qce-cmd-descr-v17-0-53a595414b79@oss.qualcomm.com>
In-Reply-To: <20260519-qcom-qce-cmd-descr-v17-0-53a595414b79@oss.qualcomm.com>
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
 bh=gp3ozjJqNmPcKgZWuLmeZiKenwHgr/5p/hE4XK3neEo=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqDGMJEm+/I7jaukvMGFVKNTuI1fcVuKpYxWb+z
 EhXy4Ob8CyJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCagxjCQAKCRAFnS7L/zaE
 w0kDD/sFScbmmtz15PotswAR9YiIMUnrxV8XlWAaQrjE/X9I56qxQn0geSxVIOi0vlJVOkYfNKH
 h62TLU806m3MLp2yxzgc6zLaVPeDMc3aspdFE9y78JhaAO5tHEZePfCxirCTcFadJ0Q3qfJWHKT
 fGg8H3oDxEOAuwcZGaYN/NgcV2qMogjNjozLyEwe7Res4GS9EPC8ECE16wkMHyKXapUjo/zVxSh
 uHKh/n5/1JqFoJorSH/6vVzrlwQge/mwrMU3duAmpyVJjZmpAqLORLN9gxavRKbSdhC/+9nHcgv
 sMPbOo5V2fyLqDbBeDgT2/XqptGcjEFStiPoX7JY2THmWyQ1o9ZGwiZnd6uYGle5YiTSgQssAlk
 MACTDu/d6RkAPftlKNt7UyX2ZfjSZKYt8PlEd41aUj0QCj9g3m8OjU28XtYwnlZldOXeCaaw+ZX
 mmz8d68fkK2vgRIDQLtGXMLz1wdYLNxHFqawyL9NUnPS1wuUjN9YdDvR+ZVjawLcoqfbDIT/r1w
 mE5ustcH122bjCpa9uLJaLVDtKXEAd73kvRlAk9lIa29pzBo37wK0gxK+0XNsFcyyOfrqbwgLAO
 JUjtVG3+lm3oSp6D5IAzE6Jwi5PT3bEuwwq1XStAb5RvhTl8x6Gjcsfl6ikS2igyTROyt/LyEN7
 FNVg7zAa6cEqO0Q==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE5MDEzMSBTYWx0ZWRfX+wtDgUZpd3hM
 KyfQHoZ3NgT8G/jPhtkBNbLHVc5iXF6D7n6UgAMkX2fh8CxwFBDY8u0ghPzrkcFEQ0RSQSWhyhY
 pAEByCWgnf2oRz0HYzMnSkXoi7t0XuUgEiA12Ychn9L3rAVMKykIs4ZHaF5W6pqpik23Zl2haB/
 2a4OeUAgtLRx9tlfIu9pJ+zFZHB7EJtERu3PjNpQ2JdheuqGAF5kAPwOZZnXedegxfMGm1s9IRQ
 t/+rSm9u8Laex2aPRs0Iub1d7XOVsfD6c59fjYm7f9N20+94Y6TgHJlPmRjDz6bNzELASooNcPT
 0QYdkmKHRoyw4ajhEIKW00+eL8Exj2MSYTYleP07L8ZX5nAy1zP2dDvSfuaSqSSWFQp8XxmifLh
 exqhOJXbkWK76l0ypKbfHTXR/SL+SDeLihw/iiZgjtus8+KXoq8bFtXkiHijT6qiWFD+AfYwgPD
 c2qbKB75O6tuFGfjp0g==
X-Proofpoint-GUID: 5uo5S5C93IG3JWlawvzlyng6Nzjnjnpt
X-Proofpoint-ORIG-GUID: 5uo5S5C93IG3JWlawvzlyng6Nzjnjnpt
X-Authority-Analysis: v=2.4 cv=WZM8rUhX c=1 sm=1 tr=0 ts=6a0c6321 cx=c_pps
 a=OI0sxtj7PyCX9F1bxD/puw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=KKAkSRfTAAAA:8
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=rvG61WhHFVBzVmnuldcA:9 a=QEXdDO2ut3YA:10
 a=Z1Yy7GAxqfX1iEi80vsk:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-19_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 priorityscore=1501
 phishscore=0 spamscore=0 impostorscore=0 adultscore=0 bulkscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605190131

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
index e82fc862c74b20c34ea5abd6c0b98b71089a3fee..5f724db7c65930991218557394d99574418fb68c 100644
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

