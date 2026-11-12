Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794523160;
	b=eG33uLrTOlRO+JE/VWDQzi0jjcKxbYhqGpTnJOLczV/I3FAYJvdK3UrQKyZnhbHq2zx3
	 khcGpj/z3c379Eas3O/B3DZlqslnH1b83vwelEGA0cSO3AP/AmvTz6Iy5RsJvHQSEc6zz
	 b0enwj8G+JuKeS1TjjK6qjfaZfIH5f80DXzov7vPhyqDYJuipBik35jmRtK/9n9/CddD1
	 SzcDLBxdaShtN1SqDAOsqv+h3Ct42zubcsMMpvshFaiZaFSfIfcUABv238BWpBlbZQcJz
	 qugahgE068fqnvIVu90K1A1dIA9YAamWmr0ZUhoEZK5aP9XNP4FETxxgXHA0X2XIgYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794523160;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=sGGcy2KQT/yHVLFw/oNaZ5cTVhBQ4bGJXIg4frh5/9o=;
	b=S5fjCuGTBLHVJvDbYKMdFAbpsVbWrhe/yDxonxYvGa27tc+4mmQUeKcg8/FEndLbQU1Q
	 rQyzP2/JbinL1iY41iZnyiVa6HR+CcM9rNL83YIz85252Ycpmk6EykcKqOV8CHteSVhxA
	 uNXiEYdPfArzZqfwgNSHobSypGfeJrbe0iIbAGDYQIkrmGytnJh87BE4qmSA0Lf+AM74w
	 ShmVw7jiSaqtiUX+a4beJKOPSXLU/kvfEzXoSxpkt38T9pMV6W5cU3cHPmK5M37pkFOqK
	 1jt7XO7qHn3QZm0RsMcNr99mz0phvvN2QGjiR1ijuD+MpklGU03wfHEqb5tNQ6K0mxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=lFdGgymK;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=TkFMentW;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBFF6606A327
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 22:39:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CBFF6606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=lFdGgymK;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=TkFMentW
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ACJZjpO3120869
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 22:39:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	sGGcy2KQT/yHVLFw/oNaZ5cTVhBQ4bGJXIg4frh5/9o=; b=lFdGgymK7lNB1gPh
	AqCApXcN1v0eRiuoeCk8jkwYRPAMOH+R/tnOJkFWb2e4+GFm/Oop4e+gixzbAZTo
	cedgeE2GpVV82a93MUYgS2PQhqo9C1E7hfZybw/FnR6gIWsiR90PuJnoCcH7sWQW
	8yTlHJpzQwJWD5yVIwlGBXuRi/XinY9mn+c++FBTnnGP4NrUwAL86uuA98c+ZF+O
	HsfbKNALYAvIkHwHddd8BDY4Eiqm7HmZxtjTzDIZrwsUvfJxvyISVqkhI4TifYHE
	4NdxFdpEo0O8ALPBRq55+DCi/M9Yib8K4z2K8GNEnF1WNcpQYYGP/JIAWCTUwsY0
	XvQvXQ==
Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com [74.125.82.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hwbx32gxc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 22:39:19 +0000 (GMT)
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-1383723dfddso295604c88.0
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 14:39:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794523158; x=1795127958; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sGGcy2KQT/yHVLFw/oNaZ5cTVhBQ4bGJXIg4frh5/9o=;
        b=TkFMentWElLK0LJH5w9orkjubExaybeGzMhto7e6iFW4iF751KLUlR5ufm3JUbACNG
         Khn2QUbFUV595/I91Ax/ftCm3s6QWqn5olnthw49JSL1ApBGCOfvkVwjaS2bNcp1MacN
         CNlyfZZsCIrcKg2/XC3f57V/NzobSFo7Sxk49bAFHo8WK6QZ37GlKG96AwSWNL5Y8zp3
         hGwTqHx6vQaE86snsqgnqJPzNCvi3G73c0B25bx2PCEXAUTZeX1J+K6xSjWMmMkhfMQg
         DmckrYWIDTqvRw2hJ1S14TNLJ9dN4xyH6WDW9ooKhKRVuZ/pIY2B93/OCRluBRkK5+/v
         3Yyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794523158; x=1795127958;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sGGcy2KQT/yHVLFw/oNaZ5cTVhBQ4bGJXIg4frh5/9o=;
        b=B5tbiF71ibbrqWJoQSOulXddfPxrMN1FNAprXUzH0N2WhKGW0qC1T654OB7l32xA84
         OwgIy8L+xPCYKFOS2vZKqCjWwneDOpGBix8iu5xVRyGY/VIPZfJBvwrP9KFGAwdOVvl8
         nbQp3wzwcszMCoixWnaJ36Dyf4SEAAHYw/8eJePDkbNPqpVZRTW+6QqwW9aZEWHvIQ0S
         ACnAj2/NKap08XW1L+Nu0nm1Ar2ZOibOduQ7KIFZyxMJFXocXHM2C/c13kIWpZybgcsk
         6XcNYXToJitd/ar80s09JnjWV4NVo3PhkbIj4EM45YGyfOSU1g+HwQXBXsYtfIojR7Qe
         DMKg==
X-Forwarded-Encrypted: i=1; AL+hErEKRrMKWnk1GzihnSpQx1CAFG9zE4bHGX7pESRlJc5H8z+SHkfK4JDi6hldhc2Qp0kEm9RzWKJCtbYlvwo=@vger.kernel.org
X-Gm-Message-State: APuU4Z9IocsrG/ngLYNNaaGdjczE+O97Tgg0UU9KwFPbfz7hZQZ4w59+
	xFaVIALzGyXmvJATzx2V+tK3WO/qil2T564+9pcf5vPwotIVu7SS4YLgOMfCdWXdSzEKmRLGalC
	ImHnVJu03Kt7KqbSEbiKELrKvWiZ62qixt4V5DsOb3/YB1njRanuLF1SJwzo6ZjNbyes=
X-Gm-Gg: AYBFou0Bg/22mavYSGwmJ8pL461M+hwHNxQTd3D7nnRDQN+Y6Yp+AOnZOj3FyxKs/oP
	IaKmEG4wKIwbSbC5XDmoX4trr7573oUtH3Gen5SQwwG99scLtg5IxvutPO5fAOguoL/Y4R0b312
	uyjgD1eZEWqdxiU2zFRMWpoDi/WjYatlZZWXfYJMeotKIHiLyfU+Qw77IMiPmAC4Wlzdt/I/LvL
	hNqEC0kgF4FMcmxdyQsYtci4TfOyDBor22Px7PB5XkjwhU4zEsfIaGuHquQjXbX0VVX9Za8qjpu
	nC267gI5QVwLlhLnuN/8XuCFr/BssxaSDI/Z67Xo+fhCSt4jJIJ828sgNZacDiWJtbVcHRYj080
	iL5R3okYtJ9Hi/1OGoUb4S1LifXyWmkofPHkaOEJ0IfwYrReXZbt4aMhNAWPwQ7Sg0XIJpvcLE+
	l8VxhL/gzk4A==
X-Received: by 2002:a05:701b:240b:b0:1b2:6cba:7f88 with SMTP id a92af1059eb24-1b503169447mr760676c88.44.1794523158288;
        Thu, 12 Nov 2026 14:39:18 -0800 (PST)
X-Received: by 2002:a05:701b:240b:b0:1b2:6cba:7f88 with SMTP id a92af1059eb24-1b503169447mr760641c88.44.1794523157705;
        Thu, 12 Nov 2026 14:39:17 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031468b7sm2333496c88.5.2026.11.12.14.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 14:39:17 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Fri, 13 Nov 2026 04:08:27 +0530
Subject: [PATCH v13 1/6] soc: qcom: ice: Add OPP-based clock scaling
 support for ICE
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
Message-Id: <20261113-enable-ice-clock-scaling-v13-1-258dc817bd63@oss.qualcomm.com>
References: <20261113-enable-ice-clock-scaling-v13-0-258dc817bd63@oss.qualcomm.com>
In-Reply-To: <20261113-enable-ice-clock-scaling-v13-0-258dc817bd63@oss.qualcomm.com>
To: Abel Vesa <abelvesa@kernel.org>, Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <mkp@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Authority-Analysis: v=2.4 cv=S+5MU4sP c=1 sm=1 tr=0 ts=6af64017 cx=c_pps
 a=JYo30EpNSr/tUYqK9jHPoA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=Ncwwxt0CvNVXG9qWacgA:9 a=QEXdDO2ut3YA:10
 a=Fk4IpSoW4aLDllm1B1p-:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDA5MCBTYWx0ZWRfX8+si6dZcGJtH
 T7Rs/5ozS2YrvGOunJOV10YP+3ab2iAi4aaZaLvmAAt4PWfiA0Po8xvDtvebbJVbgIb7shCxw80
 al+Zc1PihkAzSnOp6U6hn7LxOouUwH1ADfEgeLtZT+KzD7O3SnaeVyBCsfQYSpJLqusDl8SGrba
 nIZJ6iAmG5Ww/QlsqQSUHSFWdi7S5T921bPrO9yeuXK/eWY33QzLxuFmn02PflspljqiIEOir/R
 KO4fcexRCHtDGTad7embUnerDmG2PWitF4dZF0+qoRubawDE+t49QKsCxJDANRDWXWyC0hxXQJ3
 ODrxp5JZr4cairuRm+4gIgZFGDJ7cvwyo/T70NDbFCA+C9K+7GTMxc1LUaP9OVwuXMw3u4yECyp
 Doe21rPeVH6UPTkDgE7OAP2EM2RfllSu3xWZBakVJzfp7RS/d3GkxhmDT0nCuUG0ajo7hPHw/Cm
 xMqQYmiGMDNwe0r6Wnw==
X-Proofpoint-ORIG-GUID: 4AFltQjT_23RZtjLscjHTAKmvIYAnzlQ
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDA5MCBTYWx0ZWRfX+Lw6ECCuD5YK
 RW3FX9i1lwV1LZFpkXxXgV2RuHWeJVRUhNokWv+6rZrOySLQ8dTgfElaQIwTRwa6BPPFNa8VInr
 pk2W+GC+NXpmGKBQ22nWfdRrrAAXySs=
X-Proofpoint-GUID: 4AFltQjT_23RZtjLscjHTAKmvIYAnzlQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_03,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 clxscore=1011 phishscore=0 malwarescore=0
 adultscore=0 spamscore=0 suspectscore=0 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120090

Register optional operation-points-v2 table for ICE device
during device probe. Attach the OPP-table with only the ICE
core clock. Since, dtbinding is on a transition phase to include
iface clock and clock-names, attaching the opp-table to core clock
remains optional such that it does not cause probe failures.

Introduce clock scaling API qcom_ice_scale_clk which scale ICE
core clock based on the target frequency provided and if a valid
OPP-table is registered. Use round_ceil passed to decide on the
rounding of the clock freq against OPP-table. Clock scaling is
disabled when a valid OPP-table is not registered.

This ensures when an ICE-device specific OPP table is available,
use the PM OPP framework to manage frequency scaling and maintain
proper power-domain constraints.

Reviewed-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 drivers/soc/qcom/ice.c | 75 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/soc/qcom/ice.h |  2 ++
 2 files changed, 77 insertions(+)

diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index f9ac45505908fc175f87098e9807c4642c3df321..2259dbecb8b513ff9f2731a969e126118dfb9b1c 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -17,6 +17,7 @@
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/xarray.h>
+#include <linux/pm_opp.h>
 
 #include <linux/firmware/qcom/qcom_scm.h>
 
@@ -113,6 +114,7 @@ struct qcom_ice {
 	bool use_hwkm;
 	bool hwkm_init_complete;
 	u8 hwkm_version;
+	bool has_opp;
 };
 
 static DEFINE_XARRAY(ice_handles);
@@ -560,6 +562,50 @@ int qcom_ice_import_key(struct qcom_ice *ice,
 }
 EXPORT_SYMBOL_GPL(qcom_ice_import_key);
 
+/**
+ * qcom_ice_scale_clk() - Scale ICE clock for DVFS-aware operations
+ * @ice: ICE driver data
+ * @target_freq: requested frequency in Hz
+ * @round_ceil: when true, selects nearest freq >= @target_freq;
+ *              otherwise, selects nearest freq <= @target_freq
+ *
+ * Selects an OPP frequency based on @target_freq and the rounding direction
+ * specified by @round_ceil, then programs it using dev_pm_opp_set_rate(),
+ * including any voltage or power-domain transitions handled by the OPP
+ * framework.
+ *
+ * Return: 0 on success; -EOPNOTSUPP if no OPP table; or errno from
+ *         dev_pm_opp_set_rate()/OPP lookup.
+ */
+int qcom_ice_scale_clk(struct qcom_ice *ice, unsigned long target_freq,
+		       bool round_ceil)
+{
+	unsigned long ice_freq = target_freq;
+	struct dev_pm_opp *opp;
+	int ret;
+
+	if (!ice->has_opp)
+		return -EOPNOTSUPP;
+
+	if (round_ceil)
+		opp = dev_pm_opp_find_freq_ceil(ice->dev, &ice_freq);
+	else
+		opp = dev_pm_opp_find_freq_floor(ice->dev, &ice_freq);
+
+	if (IS_ERR(opp))
+		return PTR_ERR(opp);
+	dev_pm_opp_put(opp);
+
+	ret = dev_pm_opp_set_rate(ice->dev, ice_freq);
+	if (ret) {
+		dev_err(ice->dev, "Unable to scale ICE clock rate\n");
+		return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(qcom_ice_scale_clk);
+
 static struct qcom_ice *qcom_ice_create(struct device *dev,
 					void __iomem *base)
 {
@@ -738,6 +784,7 @@ static int qcom_ice_probe(struct platform_device *pdev)
 	unsigned long phandle = pdev->dev.of_node->phandle;
 	struct qcom_ice *engine;
 	void __iomem *base;
+	int err;
 
 	guard(mutex)(&ice_mutex);
 
@@ -756,6 +803,34 @@ static int qcom_ice_probe(struct platform_device *pdev)
 		return PTR_ERR(engine);
 	}
 
+	err = devm_pm_opp_set_clkname(&pdev->dev, "core");
+	if (err && err != -ENOENT) {
+		dev_err(&pdev->dev, "Unable to set core clkname to OPP-table\n");
+		/* Store the error pointer for devm_of_qcom_ice_get() */
+		xa_store(&ice_handles, phandle, ERR_PTR(err), GFP_KERNEL);
+		return err;
+	}
+
+	/* OPP table is optional */
+	err = devm_pm_opp_of_add_table(&pdev->dev);
+	if (err && err != -ENODEV) {
+		dev_err(&pdev->dev, "Invalid OPP table in Device tree\n");
+		/* Store the error pointer for devm_of_qcom_ice_get() */
+		xa_store(&ice_handles, phandle, ERR_PTR(err), GFP_KERNEL);
+		return err;
+	}
+
+	/*
+	 * The OPP table is optional. devm_pm_opp_of_add_table() returns
+	 * -ENODEV when no OPP table is present in DT, which is not treated
+	 * as an error. Therefore, track successful OPP registration only
+	 * when err is not -ENODEV.
+	 */
+	if (err == -ENODEV)
+		dev_dbg(&pdev->dev, "ICE OPP table is not registered, please update your DT\n");
+	else
+		engine->has_opp = true;
+
 	xa_store(&ice_handles, phandle, engine, GFP_KERNEL);
 
 	return 0;
diff --git a/include/soc/qcom/ice.h b/include/soc/qcom/ice.h
index 4bee553f0a59d86ec6ce20f7c7b4bce28a706415..4eb58a264d416e71228ed4b13e7f53c549261fdc 100644
--- a/include/soc/qcom/ice.h
+++ b/include/soc/qcom/ice.h
@@ -30,5 +30,7 @@ int qcom_ice_import_key(struct qcom_ice *ice,
 			const u8 *raw_key, size_t raw_key_size,
 			u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
 struct qcom_ice *devm_of_qcom_ice_get(struct device *dev);
+int qcom_ice_scale_clk(struct qcom_ice *ice, unsigned long target_freq,
+		       bool round_ceil);
 
 #endif /* __QCOM_ICE_H__ */

-- 
2.34.1

