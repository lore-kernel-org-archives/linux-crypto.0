Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794489624;
	b=c0MWpNGqsLUJ2l/4Uh8qphL0tPRfOKVmbVWFPKl7RlqoWzkzQe9BfQBapQd/JH8QIuID
	 mDyt3tbd5LrMOlrP9R7vfsujTUTCnqdgXcjuyW8D2hZdl9MopWxYPpJmerv6+6ZWxXk3V
	 nDObT6e2GBDS24/X8rrgpJUTAU0q65+sE6Y0puXUT99O/bQaz5DsOMl/h08SFjpkpDfEX
	 kFPPpJenOr40TQbW4TUahW4GMeQxhRuNVE8qVLQSmePJYQ0LyCNPT4IQN/97x9ggUaZPe
	 AcVCWMjMap8PkuUAGH9wVcFoJY4F82mVCQBb4BWjPpCiE5+5s3fIIPe8ZtRrbSm46Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794489624;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=sOHdKOtYrE6ti1WsC9g6oDfDHzcpc2yHQ0W/WOvdgbE=;
	b=VjT3Oef1zYxdFpftredRFqt2fBzVUCpW4oIUgI3HPIZT2YmF4qDF6DAEj3TjF2x2mecj
	 puXy1V0wovnS2AP65MnHBuhpztMyFUy4MS58kzraWW8HRr081upyLDZhUrQS20wOBzW3V
	 Dwa+gAHhwHJp+jyq8a6ARbUUu4mDpvyybnl/CZIlfWFoAozY7kMTr3CnGHlbMK3uLDxfv
	 eVAqXPleFdKLjPDPLQdE/FsFM9XgitbbsWMaUoFXEK6pwPqSuyW4pBvbWRpBGcz/74sO/
	 PkA4tngvtB+MeOnUUB2KTijkt70BfcnLfB1/x5bsb3hzAgYXP/8RGDxDTX5U23iLBPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=RTDMxJkF;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=YuDT8Dsz;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91338606A334
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 13:20:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91338606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=RTDMxJkF;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=YuDT8Dsz
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AC7oVjK2818494
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 13:20:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	sOHdKOtYrE6ti1WsC9g6oDfDHzcpc2yHQ0W/WOvdgbE=; b=RTDMxJkF508Dh42y
	BaoG1QT6krm5io92kTIWgovSydZvkRbbYWPAylkUMdx52dharX1koMAVwtZ8+VeZ
	tTRuOg2fyUhzQwuoHPinJzOnAjKIgfZQe0eqIYiwp2LgsDb29upW5LCIcEuQwhB4
	6O5XBOmxtOjBdzSJvmmbseT34r9CvVjI7luek1oKTBU7L26D68Li2d7kHtOhi7gn
	87EbdNi97UAlPilkGjWSj+bK/8BkXN1WA6E0qQg//+AIQaZ0TzmQcSeYcBEUEEt8
	fMl79a7n4O43kEZoHcECn50f0r2uCx2VhHXdtwBAb9xy4+DPDBtGjH7RFjyD01NN
	i+qfTA==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hw9e1954u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 13:20:22 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-94776ee7bf0so704469185a.0
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 05:20:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794489622; x=1795094422; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sOHdKOtYrE6ti1WsC9g6oDfDHzcpc2yHQ0W/WOvdgbE=;
        b=YuDT8DszZktF+6YImAgvTDcPerggXEmGrCWFRa1hYA/1RuPHq35dAt2d9Rx5mdhtZj
         mn8vx/vnXvj+dsHv6l+Q7dy1fx9YHfnGfvMAF/eHEKC1evUg4ScudvvCjlbYOpjuY43n
         i5BPkgqzKQG5OtmgPEDURMLIngIevLpgdrtLq6XXIMnUqQJGyGBZVMQk/xnGvQnmR9UG
         oP/3Lde5g4FnTR91hKlbrBtJnXxzYCezPStaHdCNSb9/mBhaza1kuhhGCB/aeLufFJk4
         y9VSsyLeODJKnho0uLfCZXm9F5m3NksCq7XN7/PzVa/8efqYUw3SIO2C8QpZhYDBC9j0
         5YsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794489622; x=1795094422;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sOHdKOtYrE6ti1WsC9g6oDfDHzcpc2yHQ0W/WOvdgbE=;
        b=dy3jkmsvAFIl6XQ3DIEtcBZE7C7pHmbNjD0q6koNckw3lhsQMsWh3xvkHgRcdM/hzv
         i/OPOmt37RS1L+u/zvINFTAI3kA0IP5BrcTzGKq+tpzLFS7G6Eify/OrJtts1OUxHki3
         oYIH+dDzoOnpCRS5I8Wf68ANKqK/57x1TjZaTlEV/I+UJdIsPsZ7chU4+9P07wTKCo57
         4FThgaQS9+MHUrurHepSkNK0RkRFw2y+gFkZk98E2rsnt/wQJcpCLxQGq+y7xRWQ0KAC
         FmSI0zrQYKAtrBUfZ9JujXjFMW7L9uPG77DnF4W1wCzBQzUcHlCnhvjdLtfS2fNGik6y
         JEig==
X-Gm-Message-State: APuU4Z8Qer+n5Pu3d7CDOsB7/hEfaS2PYgkyyqK9UFhFoDSiLb5jMB0V
	IIggprtjp6UQhW5XTSVUvVvEKOFkudvujfjnSy3mWZ8mgzh2sKZF3FwptZjC8yGuoFYS5VwQjmC
	1yfwjPxkVhdlLgqChC4VS/3h/v3K2U6L7ODI4WW0MYetuWKzqaA9q8+SuHmm2zKMGOwU=
X-Gm-Gg: AYBFou2wKo5/U1T6xDJWSWg11FnIs73w/5dNzEZn+uPIpbVHoF1dfA+uRFjpp+uT9gP
	DfcjwgE9YX2RVe7HlOENdM3uZEVQL7CosNMXhXtP1mkiU2Ly3FVjl1qniq4IiOg7I3rHsMgY+7z
	voBZSV9qz1azv46dxSlbQVC1l3EmX8w3NY2Amlzb44VbQBUBczkAa7dmOqwi4oa+AEzXkUN5PWo
	1ucAiML3r+BJuWz7UppYsefoobFLxHci69QRkj+PHRusZUJ7RFwqgo8Pkz3a/axDJmn/pcVJaNn
	7eVUYMqht6247SfR86k0V7dryh3UinzgBWhPt5OtN3iR4p47ULspgGkJhm257hud+aHWyq87qEH
	pD7V6rIg0zg/CeSnRzaoBXjJ0/6eqJFUUe2k/8iReENqhGI6rSt5WRY6Awh31khwUXrhQ7kgXN4
	TRy57yFYdYmlQK4C0TKT8JQsyWyzQ938I7g563C0EGjaKGD0jNKseAk0Rqz72bD1c=
X-Received: by 2002:a05:620a:8018:b0:93f:4921:6965 with SMTP id af79cd13be357-947b00b3c2amr815416085a.61.1794489621893;
        Thu, 12 Nov 2026 05:20:21 -0800 (PST)
X-Received: by 2002:a05:620a:8018:b0:93f:4921:6965 with SMTP id af79cd13be357-947b00b3c2amr815410785a.61.1794489621347;
        Thu, 12 Nov 2026 05:20:21 -0800 (PST)
Received: from brgl-qcom.local (2a01cb1d00dc7e0089167b9b97a26c96.ipv6.abo.wanadoo.fr. [2a01:cb1d:dc:7e00:8916:7b9b:97a2:6c96])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-498369a495csm16744366f8f.55.2026.11.12.05.20.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 05:20:17 -0800 (PST)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Thu, 12 Nov 2026 14:20:08 +0100
Subject: [PATCH v12 1/2] crypto: qce - Only register algos if the user
 really wants it
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261112-qce-fixes-broken-label-v12-1-7b5b9c7083ed@oss.qualcomm.com>
References: <20261112-qce-fixes-broken-label-v12-0-7b5b9c7083ed@oss.qualcomm.com>
In-Reply-To: <20261112-qce-fixes-broken-label-v12-0-7b5b9c7083ed@oss.qualcomm.com>
To: Bartosz Golaszewski <brgl@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Eric Biggers <ebiggers@kernel.org>,
        Demi Marie Obenour <demiobenour@gmail.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Pankaj Patil <pankaj.patil@oss.qualcomm.com>,
        Birk Skyum <birk.skyum@pm.me>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        stable@vger.kernel.org, Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2262;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=uNWdf7JMTPD50Oq4Q34RGGw6aCVGFgeAIRGofUpNzcU=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBq9b0JlqMlRyBVpFc0kBTJiSqRQUy68ErqMNtxR
 wWCrVcf9EuJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCavW9CQAKCRAFnS7L/zaE
 w6arEACorZuR3+d3VjlfFgy8L0TymbxxLQjd/fjA019WVhb2ONi1ho9cV/b7XiBgidpiNufnH67
 bvQBcnu867YgJe1vsh4hc0DBLnCufY66fk5SePylcV6oAirKwoHY4/kG9KpnhDj1oTOwnA4IFhs
 K/fzmC9PoPAN51Xa7rg+oltR/p5rp5uqBBnOyZvd+ZsEVnFvfA/zIMcHzXs3wdgCsI/nTMWzGS9
 leSaSR5m6f89F/pUDDl0oO6jjKrFhTG1CbGwkgAmTRo7nfuG2cqMoh2i3iGY8iEL+EkmbH2WAG/
 /Dp9ffP3b07xP8jHS0FHDOqFLvsaVc6nGKWkhxhsVQU4lLzTwn1AT7sNUlgKROfI/tZ7iD+3VFD
 sSR8klidK+ywgzSP5dyUzOvkjMOmRirQbYT0rlaSCe8HhWDSRz9rt5eGEQIP+NbZCV8IjgMIm2q
 6vU5KKIpbQweuGP1PPQDMAjlFWLQpxwftmSUB+Q65KwaUjX7lov0hO04rtNkrq0Krwvch2sUVXN
 9Kshp07fgmVrz/O6dujFwyfGJPie48+kMzD6rzGOIRGaqZ10xc7YW12IUooa6SZScHdaIOtAM01
 YBUOiwoWw4Va1FwqOYSVkGCHvLGUfLs291wqvCDlt05OFwrWugQfTiflKAHs4wEDFDTv/ZmgDFU
 0ThVkge3KjgRyYQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDA1MyBTYWx0ZWRfXxGtA2gIXsJge
 p9jTOkKync5T1mJH3Xpa8wyXv2V7S4SlxH0uLz6FftwE3PPZfjEV6pLUoZisLbX3WjSFeI7ZtED
 wUaIJSfw0EZAVilDXU1UoAL9uG1B48bXTd4p1hdDRZIQqcInx2aZCCPAmspEds71JcaLzrg+Vwt
 kKvUeXSeJcQXbgJkgUw/Oh7Kvp6gW34oV+GEsU+cGWMJB1Dll2qwxcHK/2T+KzRGgCHzBOsHR3n
 lApwLLdfxcDTPAjy/cu/WK8DdWGg3bqGfDALHg2Nk2JU+XL9tiNXFhksq7YoGUgjUMzTvLiRVV3
 Qnys4tJIKOMurZfE3ZGwuU3QiEseup3IR8WSr2oQVm6gUHLoocXTt9yFIGzDXkAG/DW6y+HzFaq
 h4MT8MNlA/U/mXPyQisGvcI+sJafBUqxPN8wD201ks4fuPgxe662TFGJycGN0TIHexo693voUxQ
 by1PrvF1U0Orgo/jbhw==
X-Proofpoint-GUID: 37n9Fjz-hj1b436i8YcziqdH1j_8zIXW
X-Proofpoint-ORIG-GUID: 37n9Fjz-hj1b436i8YcziqdH1j_8zIXW
X-Authority-Analysis: v=2.4 cv=F6fC5ahN c=1 sm=1 tr=0 ts=6af5bd16 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=XywcRVADl8Xu_msC9vwA:9 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDA1MyBTYWx0ZWRfXyaFJICkGv0xV
 7ohWqUzecIa86luS0rwZKsL9+juePhn3NdyQJznFgZfmHeVqA/ZRXTjiQdYKW1d/4pCckGWFMF+
 zQ3PZ0ivoBc0To+MNq/oMp4uLZdGeq4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_01,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 malwarescore=0 spamscore=0 clxscore=1015
 bulkscore=0 phishscore=0 lowpriorityscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120053

This driver's crypto algorithms still have a few issues that need
addressing which don't currently trigger any self-test failures. For
that reason: don't register the algorithms unless the user really wants
it.

Add a module parameter to the QCE driver that by default causes the
driver to *not* register the crypto algorithms. It will only be one if
the user explicitly passes the do_register_algos argument as true.

The power-management part of the driver is kept as is to allow scaling
down of interconnects gating of clocks by runtime PM.

Cc: stable@vger.kernel.org
Tested-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Tested-by: Pankaj Patil <pankaj.patil@oss.qualcomm.com>
Tested-by: Birk Skyum <birk.skyum@pm.me> # X1E80100, Lenovo Yoga Slim 7x
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/core.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index a009c791417b707c5d4e98fc30111863dd8809fa..ddb4df3d227f801e566422491b488c5fcb777717 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -10,6 +10,7 @@
 #include <linux/interconnect.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/platform_device.h>
 #include <linux/pm.h>
 #include <linux/pm_runtime.h>
@@ -22,6 +23,10 @@
 #include "sha.h"
 #include "aead.h"
 
+static bool do_register_algos;
+module_param(do_register_algos, bool, 0444);
+MODULE_PARM_DESC(do_register_algos, "Enable registering the crypto algorithms.");
+
 #define QCE_QUEUE_LENGTH	1
 
 #define QCE_DEFAULT_MEM_BANDWIDTH	393600
@@ -259,9 +264,11 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	qce->async_req_enqueue = qce_async_request_enqueue;
 	qce->async_req_done = qce_async_request_done;
 
-	ret = devm_qce_register_algs(qce);
-	if (ret)
-		return ret;
+	if (do_register_algos) {
+		ret = devm_qce_register_algs(qce);
+		if (ret)
+			return ret;
+	}
 
 	/* Configure autosuspend after successful init */
 	pm_runtime_set_autosuspend_delay(dev, 100);

-- 
2.47.3

