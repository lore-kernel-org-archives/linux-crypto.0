Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794492655;
	b=tasyTWGgQGahQ65arVZjsJ3Gsgzq20c0ocI4UKk0itcF1QC0i2yOJyeKy30zOfdRB09v
	 v6WnoXKbcezrBjzL2mk331Cg+6MGhevHktFS3iNGWgsXcPqVDQu7aicVSOMi/JV4rZDNL
	 dswTHB9qEgOs53jFvQSR0/0Kh5q+uiBZ3vHVbEBkoi3bH+xmIHRzMYC8GOygGO68KJ4KU
	 KCTTVgw2S1A/dtR1CAvSRQmfXWFPjp4l7PdgYFbvWrhqGPnXlfdcc79mp36DCHhe/d6bX
	 ET+b5+1XJLX/GubgOoRqbR56NEimnvUWC1H0GyfKZ0I5EjC8EUm1R2ls3+xfvkj8KEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794492655;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=oXGSSXGtbkPXvB7nHrz702paXG7FvJx+QlGDGhbF1l0=;
	b=a9hFYkG6bLiCmav2dWDfzU1kNOWj4FtMugHwfoT6XY6T0VsqKF7F/R3Q5A958rUGJnAo
	 mBavQU9gSJSuvfnW+a2XrBWbjmlkidl69i7QaajOI92+PNbSrQLVI14X+BU74F75++uI/
	 oHI9EI37ZxtvbwAZ34nvVzPUmnDayprHjwwyddk4oQymd5Luyvw/T5jadNg5cVScMNuZL
	 Zq83viTzkEBmXDccb2Y0kt41u1nFJVF1lHj5GYTQlyfJTWebuNqgJ0zw7chGf9sZIP8Cg
	 a97LhdMWlGWxkVaqzstIs+mc9ms5ejeoON62beROQnCG4SZWGOL592zVjKjWVsNCEZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=bgaAsR3u;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=JxltDWoQ;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CA2606A331
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 14:10:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38CA2606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=bgaAsR3u;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=JxltDWoQ
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ACE2e822818859
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 14:10:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	oXGSSXGtbkPXvB7nHrz702paXG7FvJx+QlGDGhbF1l0=; b=bgaAsR3uveq5FK+A
	AoA994h54RJAfAESM0C/mGXB/bkwKxtovBnQGAegTxo745VO1rn2Zhzqc8tOfxfn
	Xlon1xTjuv0t2/G12xCkRd/Aa4CnAtJk5JPJGkEu4K3ZU+fMCmWuHvWFdpC1HdVJ
	3yymi6x3LcVchLDDAJoR408idd4ZECadXHtdFN2RXjKQZxsBcydFGNipzn2F06Ay
	c8NKELgHzMn9/piAMZQmBljBQWNxO8IcL8+PBb17Jz96pVWz6botSNSTmVpOWJ4t
	PkWqL5acXVJgXGOFOzp6RF3sixiLnEjWovQMqkzezyISyc+L5Rf4mV9hv6NeMmV6
	cASBJg==
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com [209.85.222.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hw9e19ay5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 14:10:53 +0000 (GMT)
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-99c3b473613so253238241.1
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 06:10:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794492652; x=1795097452; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oXGSSXGtbkPXvB7nHrz702paXG7FvJx+QlGDGhbF1l0=;
        b=JxltDWoQnKQ/hklAS6rif7acZugzdi1Yn21cPhuVUeGLS25Gd0/hc3JLduVeOcZPBz
         UZY/8qBcb4nXJKx/zLo5hckXF3VaqatMLQWVmRuY1e5sOtdkyOmhxJNVmlq7u/T1erS5
         UuY63AVMmg9Zsyfp++6umgABhpK0Lox0ppFPHzstm0YxWPJ/jkyrSXaKEcaoPWke4q6g
         Klla771a58UyBSpCbwPKn2vm7bioHqVy2ekCQz1KSdRHUZ4tlCbvb3mtnivTIuxPpHaA
         Gkhi1m8yd8+cv/HBobNndmB8mRo1SmaYnGWG6/jKFAIEk3cngduCooA3r8JSRaZbBKzI
         Z9JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794492652; x=1795097452;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oXGSSXGtbkPXvB7nHrz702paXG7FvJx+QlGDGhbF1l0=;
        b=TCiWlFS6aRj3+/hmexibSqmRyPq76YyuuKEieBdDn1KVQ4J/7nDVB+O4IqygekNl0D
         XXZqgPL9LgNFcrEZFMtv8FNNePAw39JuAss4D2h6TyhyBQiQ6U+HVqQk2SvzFKVD0GH5
         a8f9N3np8FdwuXRwJadzAG/JcEvlbbpxLI7jTIwImK04XoCvX8PZJMChAUt845vHc7rz
         riwHMJSuwdTvJkE1j559HP/d3PEkL2kR6fqddtrxiGlVgwe0Mh+0CtnCT2+pmahcQ7CE
         /O8E8/q29JJr2LSBkRCFs+aGy8+wl2ioEX6kxcCbwIoF5wRXwwhgt9MrpgSedj2d278Z
         PEjQ==
X-Gm-Message-State: APuU4Z8ErlNDCopNOpsE4QEQfwhJyTSM43HYPYjoPx4sS7K7ZK6BfxJs
	VxHn+pdt9/hD8kthJL3b+iSd6OD/34bAmpFVRrM3FvVSaK5IYTloOhKB3qFSy1XGgU1RJ43e2Th
	XoxubgWkeoyG9RzGzggY8BDIpaen/kMGbfsMr1mmJdb46CIYUVg+4aSfL3OM08YfeitE=
X-Gm-Gg: AYBFou08kHEAcMNeAN5cC3spwyCQO9qf7HSkoE/UGyIUbt5tlHbu3aSG9iXFVKfnYZs
	cYBm0PW5y9j3HTFJx9aXFhikwVeygp3qKpVvcHGcNzWyBVOHqKYbLPbGoUZ7xpg7uDIcpf/N06+
	VstnDSZ0cPKXtLqHURBwb8dD0DSoIb5I1AGPLjQU/9W6FCiSUsBQz2pPMsL7f5PkWrG/oTjOMXO
	Nsj4cslaeXmW4TF+cLlx7kF5o7W1ZRgm2QhBkZX+YyE819GYVldOwMacPW1cYamW01tb0usaJVO
	ImabUMCDNXAicGryKPt+3Vloh45caLMnm6m1CytSLMdACe1Vvs6pZj9V/HR+pw3/Hknc1Dh+RWm
	eCG8uqwQSdTu6gNO0Cje+xNx79uTu8/uSIn0qfgxK44nlpgJtHt288IN5W27atoOPRSdHdV+old
	ni5qdG4QFLoZASWNBkaSXzvroWLLP+BSYiTFBV5uQMj52vBoQjbJvm7g3Z15YkwMg=
X-Received: by 2002:a05:6102:370d:b0:7d2:cc5a:f0bd with SMTP id ada2fe7eead31-7d4fb2e28b4mr2056775137.19.1794492652237;
        Thu, 12 Nov 2026 06:10:52 -0800 (PST)
X-Received: by 2002:a05:6102:370d:b0:7d2:cc5a:f0bd with SMTP id ada2fe7eead31-7d4fb2e28b4mr2056752137.19.1794492651710;
        Thu, 12 Nov 2026 06:10:51 -0800 (PST)
Received: from brgl-qcom.local (2a01cb1d00dc7e0089167b9b97a26c96.ipv6.abo.wanadoo.fr. [2a01:cb1d:dc:7e00:8916:7b9b:97a2:6c96])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e271378sm81817775e9.13.2026.11.12.06.10.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 06:10:50 -0800 (PST)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Thu, 12 Nov 2026 15:10:42 +0100
Subject: [PATCH v11 2/4] soc: qcom: add core driver for the Qualcomm Crypto
 Engine
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
Message-Id: <20261112-qce-fix-self-tests-v11-2-b86a65ee7107@oss.qualcomm.com>
References: <20261112-qce-fix-self-tests-v11-0-b86a65ee7107@oss.qualcomm.com>
In-Reply-To: <20261112-qce-fix-self-tests-v11-0-b86a65ee7107@oss.qualcomm.com>
To: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Demi Marie Obenour <demiobenour@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Russell King <linux@armlinux.org.uk>, Abel Vesa <abelvesa@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, brgl@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Pankaj Patil <pankaj.patil@oss.qualcomm.com>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4989;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=DCwoS/LvISiRO16djPQOua92B5KrkSUJ5INr10E+D0Y=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBq9cjlekHn4adtDthK6Pr87Jj53xre20mrcTQ/l
 5BLTafMcjKJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCavXI5QAKCRAFnS7L/zaE
 w0inEACoUhLjGJYZi7GYfjLxc1TvdYUHF6eRl6bNiexRnFPqT6JqZ1KNVQOZMlXFof1HS/7Si8h
 Wj6tA0dVrD19EWqYCtHC298iY83qy93sQ/DKAMKPo3q2dZp1+2F6TlVXsL1/oih63tNo3aiQLAd
 TXvkpEBz0X2WPWc7zII6oQY3+SwyYRHL5nefoox99nnJR3Ije4rXm6RBOMmNT8afJr0Vcvt133D
 0uD4vbFFaCfTMrHOcWxp7Zu+iR+jGglAxfmUzzos6LTNqBYqFeOTagj84iTJMjcWBDQu+Hd5x1l
 YPGIgGqDYEWnUsUi05nZi5LrjuOwTEG4LU3tIGXEVNkKe2kqG0AQ4yYGh0t8AQRtqI6popUrBar
 gx87wC28mfapTGWpys+p9tog+VEHLSyStKOE9u1mDO9PzWb1C2ft4aWa0mK5FQUhg79+SQPYXE7
 Chh/sFAe7v2JQ7NzpbTWNJE0kGY0+51Voi6EHA9RDGDSKlkT04PAkhqoid2TEwXYnKS0Uzp/nCA
 nWgESU0DskrkVu4LLDQKwYe3FKJroz0nOWp2iUae76VUi0u0r79dTvuO6z3uVILgPP92DCpB/vq
 saXfP9JjD+7yX3s6fxKQSbk3TKKpMyP55yR5f8OhliOcyDkNYEXeTrQ4+7SOwnv6iy+ip5WN//L
 duzddPjJWHL/g8w==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDA1NiBTYWx0ZWRfXwNVZE6CE9V39
 9If3LwD2kxe6YnZo1e2grs1RAk0EqPKCSBCAdO+yU8qeuK0RePAxdopP9/D3/BbEy09eHQhjn/g
 eGVXbLAnVn+hRUdOUj03AlFO69CSFid1qxwLIK143PqS5FZppLPCScE//4J1AWT+GVofWkG3W1l
 yEEGFNcic36JIk6QMwrvL24Zkc/2SXVwbbZWu7gh4dXBynsyIGw6xfnIHsWfEYP++0K0thNkAa/
 6X9GRP9VOBYle0oYVCfj5kSi5tmx5c9tLufsPx9zPLNnbwWFtqtvZgYXwUwiF1PzHTNwfZAvXU8
 zcehFG8IhoD6qsGQ4N7hvhTz8v18uDt4vPpUwqlPLlMJHfzxhit4/1KlokDMS2jtnDz4UpStmyN
 k6fYdyev41XvYH4OqGF2ye7yQp732zaxFm9E5rw//Xgl+rFKD2ITNfqsexxbs4MHqq7b3LCL5nS
 Bd0kXLGsGYCjhyOgKSA==
X-Proofpoint-GUID: xbtX4ByJtMXMP9CyJoWCIFB4jzzvdNaM
X-Proofpoint-ORIG-GUID: xbtX4ByJtMXMP9CyJoWCIFB4jzzvdNaM
X-Authority-Analysis: v=2.4 cv=F6fC5ahN c=1 sm=1 tr=0 ts=6af5c8ed cx=c_pps
 a=UbhLPJ621ZpgOD2l3yZY1w==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=EUspDBNiAAAA:8
 a=MCZKxbAby-unP1KIBZoA:9 a=QEXdDO2ut3YA:10 a=TOPH6uDL9cOC6tEoww4z:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDA1NiBTYWx0ZWRfX0s/20ocZD233
 Bt5bq/jbrT/uM3TG0e1vCdHR5T2hfgPdOoqrKKE91asJ/sBUZ84AA8NnXOzKSiv5y9JhV9O0Kyk
 CxAyt2HNBilJcBMcjqL7JR4irQNfl/M=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_01,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 malwarescore=0 spamscore=0 clxscore=1015
 bulkscore=0 phishscore=0 lowpriorityscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120056

Add the core driver for the Qualcomm crypto engine. Its task is to bind
to the qce DT node, set up runtime PM for interconnect down-scaling and
register the auxiliary device using the crypto offloader driver.

Tested-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Tested-by: Pankaj Patil <pankaj.patil@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/soc/qcom/Kconfig    | 11 ++++++
 drivers/soc/qcom/Makefile   |  1 +
 drivers/soc/qcom/qce-core.c | 92 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 104 insertions(+)

diff --git a/drivers/soc/qcom/Kconfig b/drivers/soc/qcom/Kconfig
index 535c8619197b3e889e536da072ab89d3bb729804..67d54d5211ff21bae77cd8408fa47af630060949 100644
--- a/drivers/soc/qcom/Kconfig
+++ b/drivers/soc/qcom/Kconfig
@@ -121,6 +121,17 @@ config QCOM_PMIC_GLINK
 	  Say yes here to support USB-C and battery status on modern Qualcomm
 	  platforms.
 
+config QCOM_CRYPTO_CORE
+	tristate "Qualcomm Crypto Engine core driver"
+	depends on PM
+	select AUXILIARY_BUS
+	help
+	  Core driver for the Qualcomm Crypto Engine. Say yes here to enable
+	  the top-level driver that binds to the devicetree node representing
+	  the QCE, registers the sub-devices implementing actual QCE
+	  functionalities and sets up runtime PM allowing the interconnects to
+	  scale down.
+
 config QCOM_RAMP_CTRL
 	tristate "Qualcomm Ramp Controller driver"
 	help
diff --git a/drivers/soc/qcom/Makefile b/drivers/soc/qcom/Makefile
index bddd6f0a583673047067b1f0be725b8bb5d860de..9ef0f11d015852d1f599769074d761f1140c08e9 100644
--- a/drivers/soc/qcom/Makefile
+++ b/drivers/soc/qcom/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_QCOM_PMIC_GLINK)	+= pmic_glink_altmode.o
 obj-$(CONFIG_QCOM_PMIC_PDCHARGER_ULOG)	+= pmic_pdcharger_ulog.o
 CFLAGS_pmic_pdcharger_ulog.o	:=  -I$(src)
 obj-$(CONFIG_QCOM_QMI_TMD) += qmi_tmd.o
+obj-$(CONFIG_QCOM_CRYPTO_CORE)	+= qce-core.o
 obj-$(CONFIG_QCOM_QMI_HELPERS)	+= qmi_helpers.o
 qmi_helpers-y	+= qmi_encdec.o qmi_interface.o
 obj-$(CONFIG_QCOM_RAMP_CTRL)	+= ramp_controller.o
diff --git a/drivers/soc/qcom/qce-core.c b/drivers/soc/qcom/qce-core.c
new file mode 100644
index 0000000000000000000000000000000000000000..d51a791bb1a3682b7593928cd9857a1c00e60bbe
--- /dev/null
+++ b/drivers/soc/qcom/qce-core.c
@@ -0,0 +1,92 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2026 Qualcomm Technologies, Inc. and/or its subsidiaries
+ */
+
+#include <linux/auxiliary_bus.h>
+#include <linux/device.h>
+#include <linux/device-id/of.h>
+#include <linux/err.h>
+#include <linux/interconnect.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+
+#define QCE_DEFAULT_MEM_BANDWIDTH 393600
+
+static const char *const qce_core_aux_devs[] = { "crypto", NULL };
+
+static int qce_core_probe(struct platform_device *pdev)
+{
+	struct auxiliary_device *auxdev;
+	struct device *dev = &pdev->dev;
+	struct icc_path *mem_path;
+	const char *const *subdev;
+	int ret;
+
+	mem_path = devm_of_icc_get(&pdev->dev, "memory");
+	if (IS_ERR(mem_path))
+		return PTR_ERR(mem_path);
+
+	dev_set_drvdata(dev, mem_path);
+
+	ret = devm_pm_runtime_enable(dev);
+	if (ret)
+		return ret;
+
+	PM_RUNTIME_ACQUIRE(dev, pm);
+	ret = PM_RUNTIME_ACQUIRE_ERR(&pm);
+	if (ret)
+		return ret;
+
+	for (subdev = qce_core_aux_devs; *subdev; subdev++) {
+		auxdev = __devm_auxiliary_device_create(dev, "qce", *subdev, NULL, 0);
+		if (IS_ERR(auxdev))
+			return PTR_ERR(auxdev);
+	}
+
+	return 0;
+}
+
+static int qce_core_runtime_suspend(struct device *dev)
+{
+	struct icc_path *mem_path = dev_get_drvdata(dev);
+
+	return icc_set_bw(mem_path, 0, 0);
+}
+
+static int qce_core_runtime_resume(struct device *dev)
+{
+	struct icc_path *mem_path = dev_get_drvdata(dev);
+
+	return icc_set_bw(mem_path, QCE_DEFAULT_MEM_BANDWIDTH,
+			  QCE_DEFAULT_MEM_BANDWIDTH);
+}
+
+static const struct dev_pm_ops qce_core_pm_ops = {
+	RUNTIME_PM_OPS(qce_core_runtime_suspend, qce_core_runtime_resume, NULL)
+	SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend, pm_runtime_force_resume)
+};
+
+static const struct of_device_id qce_core_of_match[] = {
+	{ .compatible = "qcom,crypto-v5.1" },
+	{ .compatible = "qcom,crypto-v5.4" },
+	{ .compatible = "qcom,qce" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, qce_core_of_match);
+
+static struct platform_driver qce_core_driver = {
+	.probe = qce_core_probe,
+	.driver = {
+		.name = KBUILD_MODNAME,
+		.of_match_table = qce_core_of_match,
+		.pm = pm_ptr(&qce_core_pm_ops),
+	},
+};
+module_platform_driver(qce_core_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Qualcomm crypto engine core driver");
+MODULE_ALIAS("platform:" KBUILD_MODNAME);
+MODULE_AUTHOR("Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>");

-- 
2.47.3

