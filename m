Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4283FF1D6
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 10:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782727307; cv=none; b=M9CMK+h/FFdwXdTOaUCYiYBZALINWJrXRQ8UC30MXkmqPmvSVVwmk3knvR8b8MT6ZkoVZqV4PQN14NgM29dTVmMnRSWSqhjgW+pJQjO0Qd3t92cXMuNkqMSrW4uVvuQdydSa7T8Gd2nq+dRkf5I5QwdGYMPQXFeshza50DCzVZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782727307; c=relaxed/simple;
	bh=bxwOj+1r4hE0BIdCr6O2vUvIE65d0GfBKW7+Xew4ns0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=K0bx2WvCbD2308EFILXurz45HAPp6c3A5MtRTjPb29GMmk7u5vkpGlIEIGX7T9rdv+Foi+TmaItIOY3UuNcyHIXd3Pk9WleelGJ7KcwKNr7C5EMorv6cYJAkYjPjoI96v2giUefcdaMgg/p/HZvdS4lWh1ObqTbG0tEsVDqGqKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=A0ka6O8L; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=cvgCI/Wm; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="A0ka6O8L";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="cvgCI/Wm"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65T6r4Mb2088790
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 10:01:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	0kLuBmycbMAXm5ws7TG+DllfddsRIfX83CGKYC8vsgk=; b=A0ka6O8LtQj50Nf+
	xqmQXunSe9B7gTf38ZRn7tK8X6JjzgPsTFKQp6oY81MmP3z+Uj8Dcw1sHlgs3dgt
	TPqsnhf5134g04V/dXYb24PcCrnQEaZuezQX6TUmrfW9A/63IbSDD8r1dWSjvHvN
	4fLghUoydYLPpW4z9Xh16lUlFvYKTHe+9WF3l8/PGuF8+vKDZsIT8EJnyDMeruok
	RCdIohzWdpRjBIjViNIOQv1gP54lslY6wOtFq/Urm/3QsS05MSRxij4FZQaBI0E8
	i+eQ6ZJBlAksCe7PfoaGAByvk9om4Sfpdnt8Bgvbo9M743J2BHihnieu/3jr/z88
	efcSeQ==
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f3k7vh3v7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 10:01:44 +0000 (GMT)
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4959c49e054so1299118b6e.3
        for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 03:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782727304; x=1783332104; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0kLuBmycbMAXm5ws7TG+DllfddsRIfX83CGKYC8vsgk=;
        b=cvgCI/WmYAgNYuklgHqt1P50yu+AN+vYEF4bh3kd2DWY9zQDMMmSBHpUlzoYF+eaVM
         KiG8uahlIOF9t/0shy0UNFzLs+3Y09mSHWJXmm0fjMM2Vv3SvEH91hElr5DdbnNycebT
         cyH+EaVCm+IhrOAM3SqDjlmiYU+aWIsNsk4jt6KQCdtrzJ903fDuq7wIgM8fsMg+QghF
         Btbjs39Netraxj26CbL9WRQ9KDL9zk5aIXOvtlPHbPJMlkBmVegxID819p8FUEzy3khI
         lbNwiFnAh/UJ8jVKFBToYDNn9d564zBqkBTnGB1E+BZUqwpwIoQx9KsmJku9LwQ03g6a
         J0KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782727304; x=1783332104;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0kLuBmycbMAXm5ws7TG+DllfddsRIfX83CGKYC8vsgk=;
        b=YYo7UieL/m+2vKWUUy/09d2d9Lir9ICc7QjNmt3buHJRqt/b86nm9OPDSb+ARgJk94
         Xi1kquvOLJQpdCY7KzJYq7BD2L30Ac/CTYE9wUuVlzgBmWzLPjvibYJbykXBTEVKI6kP
         N0p853Mag8S+DWSKjS0mYP9SqHake0iPSuRBhXz6gsYq1gZF1j0m5jItXQGvdaSawBbx
         saDsn+a6nTnLeUuqYqUjSmMWOyTOdxczjR/gunm/FLhcfvIjcHOT0Eed33fIfUZBniCW
         dtNoJDRte3knlAWE7F1q39Ve4oCLU+xPIRh7onHHsw9ej1/6QityEtg+EykvIP0G5Yol
         UZeA==
X-Forwarded-Encrypted: i=1; AFNElJ9oetp3unXrrP+UWYO1KAacMJc+SQuPKkEeC8un/vmcLROb/BOTRPb78CGGxtu87IwFwDCEylPzZamLrGE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtFRh5O7+RCfnNnuypjzshrpUnFvFO+QsENCXhcsUi5IShKMtD
	imPr7mkburV/K2jy+1Z/awINlwhEhbKa4CKJgUbB+J6T3bzgVVc7QeITNp2NDOADWYMUu/RL2j5
	TizmL94dt38JtwndN0t76IxCYgVFB6NU6NKRo/QXMsK7o8w3OCSAoLxo0/cB1WUnNBO8=
X-Gm-Gg: AfdE7ck3/+AjUYz0a3y49oYE1mCtFQtann+/JXsQSZGMf4dUM8tHDIJpIKyDVO+Ducz
	CYG5GaMe1phyhwYRZNNqBGb8ZSUp6qOTprsGIsuTSASEGAKevZxCno0v4Hbdr1654LS534GBXcx
	HN1Pxn64ehy4Hheeow44bEDHbEYAMHPGBuw/o+K1X9zuH37dDtOfvwxtZ9OSDwkFsBDnRwIhWPi
	EJOKsGgbiGcX5KsxkWgfl+mS/iMqmEhnZcJ4bL0lWrB79D5cjaW8EMSP1NmGMUnwR/gva8K118u
	PdRE1pZ5OuC+nX/AHeef8oj1JzuolHwRXKSfgYBv07wHygzO1I1EUhe5HqDZTfax7A9aWnw4USo
	QDR0PxBU9jn7EstOGSTlD4Twum180ZMXZisHglXFe
X-Received: by 2002:a05:6808:14c3:b0:495:d41b:10 with SMTP id 5614622812f47-495d42a46c2mr1731327b6e.1.1782727304242;
        Mon, 29 Jun 2026 03:01:44 -0700 (PDT)
X-Received: by 2002:a05:6808:14c3:b0:495:d41b:10 with SMTP id 5614622812f47-495d42a46c2mr1731296b6e.1.1782727303830;
        Mon, 29 Jun 2026 03:01:43 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:4640:d76a:6126:9b65])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4705f8ea729sm24729405f8f.0.2026.06.29.03.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 03:01:42 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 29 Jun 2026 12:01:10 +0200
Subject: [PATCH v20 08/14] crypto: qce - Include algapi.h in the core.h
 header
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260629-qcom-qce-cmd-descr-v20-8-56f67da84c05@oss.qualcomm.com>
References: <20260629-qcom-qce-cmd-descr-v20-0-56f67da84c05@oss.qualcomm.com>
In-Reply-To: <20260629-qcom-qce-cmd-descr-v20-0-56f67da84c05@oss.qualcomm.com>
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
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqQkJwZW/a1/FuvH+070Jy1CpCEea0E8JvEmVzo
 Vx9kiBjUdKJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCakJCcAAKCRAFnS7L/zaE
 wxs1EACIsX7YXdr0sjn4qm314IKBsfprLT063avihs0rpsQj/lF6gjwKnOvz7YbgGt07qTdu471
 NjRS+H5wDqPpZsXjIsJYB1SyURJB/A4vHaxe+rz827ME9Khl/5mFQmZGQKJ6VVBNDEeqhXBVzRb
 hhu6lfcmYU21pyqYv6ipDsw2IJLmT9SUab0OrNtYv/7anpnWBCeZtAmY+gQMs5ZzVX05GL3k2wG
 D6mCAWaJr1JU5Z8oNvbXBr3ayY0WvK1YgyRwT8GsqDPJ8PrOhZ7iai8WOjYiO7h0U236rSUoQ44
 jjpq5qor9RFHTMWJQTs+EPy1AROczrf3asQpQ70STVF35srSGEIekQES2mweoQoWTaR8Cwf815v
 cPqwvRX8JzY8lOsrxl1aOCGk9pZGD8zkwqo8jiquq8Gf6M3b1tLu4LFo2uLNTK1zvvDkIWsO53G
 Bi8P+hxhFmVDauM6iWRl+iWtfflXiJByzL3Kp+l8ZtlL08hm5XTieSj5In+jxdOir7YxN9zZjZP
 o+QWqZwbW5Pz+iqBhCfQz8nWjv1TqVlRb/dhlL29VgtdmsmNLDKmGYtOJRglb9Q1PozGlxdW7iT
 bziZJdpTgOL2VhzrJc1tG/dceQ8OLmKsS3Oc8O5joydTPZMfAeujfQKVVUKBS5lDpXovjURgMVL
 p9Zrsp/UAdloztg==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: geIj4nLYcBM2umbei3h4yBiqk3TedLO6
X-Authority-Analysis: v=2.4 cv=CqCPtH4D c=1 sm=1 tr=0 ts=6a424288 cx=c_pps
 a=4ztaESFFfuz8Af0l9swBwA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=KKAkSRfTAAAA:8
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=rvG61WhHFVBzVmnuldcA:9 a=QEXdDO2ut3YA:10
 a=TPnrazJqx2CeVZ-ItzZ-:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI5MDA4MCBTYWx0ZWRfX57+S3j1Lgk6M
 cyWkPr56l/SjtHI+ljus67+klzfp/Q9qtOfKmxXxoPNjd/8jqg9WpcPOEQenJW+w/ecFuA/NJzB
 Qjbd44VyUYcX3/EJV9+XeD1PsT63Vi0=
X-Proofpoint-ORIG-GUID: geIj4nLYcBM2umbei3h4yBiqk3TedLO6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI5MDA4MCBTYWx0ZWRfXxIVphrc/9J07
 lrnWyE/XpHKtPhq5RY0Pp5OmEC/X/y6LqTVuKv4ZIsU3Ugb7vCebe8Mi7wYwzd+w+dpK7gsaPcs
 rZ+ApoeuVjnulPUopa+9KiygXwXc3aR4dQhTyI5dNTVgleQo8eKZxLRTWCBXwY2XQgqXfhZTTk9
 u7ECYoNxN07Oh3N2mNEK9OWHt493527aWovAzyjxj61eU1rEPn8x/9BJHS87CnFQY8VxIhj52un
 3U01rrDlQpl6tTY/Lk4Y1w9ABVu4/gR7cnDpe2IZxRz0VLSGLsfIYamQrPlbPkBSjnGoCvUDJPp
 oVNgpHDDpYsOUNndYleWxUfX33pklYwGtsLnOi0YxXHTLRkaSL2ZCwwl+yYl5egQLyIApVCehqJ
 Pq9QN+3uN0tAMYr+AW1Mb/96Svh+gFlB+V/HcW/itO6FZg/bRBOstVdsjZ405gJ5sKwsoXByp8r
 MmQ7jBihRz0BNaFSyWg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-29_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606290080

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

