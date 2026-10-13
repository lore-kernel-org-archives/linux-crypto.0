Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DE84BD36A
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 09:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791885509; cv=none; b=HNS2TxEPuaeJhv5ptoK3uuM9eTv0UnwPIB9vycCjyZNU6XfqU9Cdgi0f7Ln4T+fyBGwSORoT5teAuNzw46MuhHno5+BUvhB9Lt6EJH5bij6M10HaGK/sQZgKoTnElAz6vRJZ8NQhho1NTOTHWhXm+YjBQnIB0vtDP3bc4l/3vkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791885509; c=relaxed/simple;
	bh=BTo589LyHoilOJ9M5NJk84H5bj4PKpXKKV1lrBMQcw0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=IuVu2FCZxV/YUeQDDdSmvhFr0x0petkIXHV5azwez2/LzP1J5a679DXVMqIZ/9bKGbIZ+tUtgSeWLNiZlC2l7kdcm/b6qz56nCl3e0gYiLGk316uvjUbalZ93N2W3wPG+5FkdX2+dl1I3Xt/OQhVfhLg+MUww+J+OhfecfzL/mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Tl8vK1f3; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=SUn/knlN; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Tl8vK1f3";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="SUn/knlN"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D8xvQL790919
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 09:58:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	SKBUa966Lm1r8eGX6K/b272wBYAQUh99MD+pqT7I2HU=; b=Tl8vK1f3sOhjnIW8
	DNtYrKQLIdU7lomskTwiJYlJNdJydm+gAu/w+XPyyq09lt/JM/vnt9hJ/6DNvnjQ
	EtXeX+XCZ2WH4jsm0+yBMqLI8rxO+X3c2MIP5HrfaFd1t6S/7oy+TDYsxVuiUjCd
	e/myHrBwToS75vZSiTjLjVGaBOsnfVCXaxtLpKsPBLNdPUcoLn1jLbDJIT59uwCs
	AQfV40aFZ+U3jOKXN0EuCMF+FBxySriBbV/FLXsZ04CHIeNLrc8Lfv0IzGMfLRFP
	K26F0szMMiruDo+SfssO2aPaP+XUZLxrZHWWHrZ4xiVzTll0B5NDHxGI8G8R9XxH
	OEHAvA==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h9hmjr8dp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 09:58:24 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93ce7a85f04so634169285a.0
        for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 02:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791885504; x=1792490304; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SKBUa966Lm1r8eGX6K/b272wBYAQUh99MD+pqT7I2HU=;
        b=SUn/knlN5XPHKj65RxIHCH4zfEgio1xiznvN8IMKb72AyiqQBZiNKS2nflwduF7pvK
         CUh9QOrPFx7k5BZ9Uxt3XcE2rdabn4V6dicn0+q7xHiovdW+yiyeX14xbFgyLwSViYke
         JHkxws67ubGy1uc9dzJNES6TxllGkXZ2+A3saQfAmDk33czqMRs7l1+0UrqTJ82DU/Lw
         0cGf/g0F3cCKo3Twzgxb1KWiYOxLBAdH4ATfz7i0QU0Dh2k0ii/Iz8/j9eyvJBZH61h1
         yDU2W4YD+kELL6mQqGkYMNc3AtKTJ+exbEFqAET+cocbuCDQxBmf2JujdLF+dUlIfmIF
         +SRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791885504; x=1792490304;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SKBUa966Lm1r8eGX6K/b272wBYAQUh99MD+pqT7I2HU=;
        b=p7y+qaMIxvVWE6RjUlnXfBtM6GnqTsBnNJZsz1d6nWzaWYo0SertlxcTZ4ZCzehZQs
         4+eipeyLqsvbWHkZ/mvmxf5z+RWrWMyWrIsPdAbU+feCcNfuM7rPZmaIxvxw+V9QO34k
         DWXA0eyDNi2nmPSylQwzzinYQeH0AWo6zu8Yj0FDq8KkkAbEHJ+FBZoUJTXc4A1cWf2x
         MqvSM30DDCm87DFmAM+pQM3qzCjCUjT/zc1tgS8s2KFDMI/xycMuvgrtlrUa8ekjZPjL
         jG8TliyBvjo/KxYskNueKrmPmKnk1//qIvZR9ALJmba7Pp0sFeQpzTFrtQFSfeZ6Lc0O
         MKZw==
X-Gm-Message-State: AFq9FYIqs8+OzyscSuiJ7obWyhViQZPLgOdriG2BfmnyW/nEzmjuNoGZ
	DZL0cm8di886LxH1SH45Yd7js/pHgaQZeQl0tn1dvdSNcV6HkYbpMm5DSo8sVLdfz1gXwUYWQDT
	4bWWiQnDEiPdE1CrSOuy1P5BS6AQAAmV80ZAWItnaRQbhuNV95KCIheFSZJX+SrtLGDU=
X-Gm-Gg: AYBFou2XG6/YoAKCG1R/rYzvFY51EYDYAihhjT6lvWTeRa5KA08Kmu6nMhiUdyETcdc
	zRAeZz3rPqbSacIXAD/iYiCuSNevWkechXbkDjuQbLb9x7oqGnXamO3WtlRrNr0ySHyoUlIRvw1
	80Jw0zQ3EQJfjmlhnAzCkK8K/WRRE0MQtOnUDeK6k2wL2T0mkMDtC0793g9kHidDNOc6kFwCYoE
	OirsqQ8z9fJ4zradjOMCnztEY0fleHpDpqtzUMoP6MCf23YpvBGT1YwJqgwEi3oGP8wJ2BcUWGd
	0OZc2ERPH4iW0pcY3FuFDPnucwTCisqU1m56PvWs1pPKrIFL2BsfC4nCHg+lZuhs9SaoDeXtjWs
	O/XtB6rq7adKneyrBDd30JEILWSnB
X-Received: by 2002:a05:620a:17a0:b0:93e:c12c:f130 with SMTP id af79cd13be357-93ec12d064cmr1899139185a.75.1791885503853;
        Tue, 13 Oct 2026 02:58:23 -0700 (PDT)
X-Received: by 2002:a05:620a:17a0:b0:93e:c12c:f130 with SMTP id af79cd13be357-93ec12d064cmr1899135185a.75.1791885503421;
        Tue, 13 Oct 2026 02:58:23 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:8916:7b9b:97a2:6c96])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bb6beaesm209412025e9.0.2026.10.13.02.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 02:58:22 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 13 Oct 2026 11:57:38 +0200
Subject: [PATCH v10 09/14] crypto: qce - Only register algos if the user
 really wants it
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-qce-fix-self-tests-v10-9-57162a38a554@oss.qualcomm.com>
References: <20261013-qce-fix-self-tests-v10-0-57162a38a554@oss.qualcomm.com>
In-Reply-To: <20261013-qce-fix-self-tests-v10-0-57162a38a554@oss.qualcomm.com>
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
        stable@vger.kernel.org, Pankaj Patil <pankaj.patil@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2040;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=BTo589LyHoilOJ9M5NJk84H5bj4PKpXKKV1lrBMQcw0=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqzgCjfkFfcvdRQWCBkFNL1of0hUYnxgFsM4rW5
 Cy+MblccIeJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCas4AowAKCRAFnS7L/zaE
 w2DmD/4sPvJlL9A3eTDDbbXlheWJQeMjlx1DeCwaXPTQhkxVNVr/++1jeq13qih8qq8E4/fG3c2
 AIdk54M7WJGowYSkDTLz7u6d1R8GqFDr0U7EGNpwKOjJg9I0GLQFFctX4OUihDBL336tmpYJXlS
 em4Lc/klqBPpDLGxCWNiYLNhhAA0J25rLCVINDfUarrwghIsk6da/lWaqxrIVM99jzBaWv2tOcx
 GgunepprukRd3WFg+646XhuLU2w/033yNqyD3bTQfCU41AQeNe9SzUmvQQdrZ46HobzRZhM4jPG
 hLxgE/Q+mlno7HUVrgCco0od/NuXvdmTsxQu64wIBVtcRFkwaYF3WRXObDGrEprFSMqZvutV3jj
 PuIoH0cLXx2n52U/o1mUleski4gmGjf0wvDeG7cGzRr3YWHDaol//r9fsEZh3Tq3kpm4YmpaiAe
 4BI9lozsYieQHaZT5wa18mou7pF6dbUDS+T+gq1xVzp6pvD6ljwc2ZkX8GxQLPFRYH+aztBSPEa
 XW7ZhZZOcSTaRBjZVd6Sn4SyFGL/DwEfnd/lU7u8u0twq92iZCvoZS+2c1tCP6WgG9S+WBWuBYn
 /JWGPNniSe6SjnSNvBlj2vgN21mPGVT/gMk9Se58jgjS340huz5fUHXvf1PZFFytHDV5w1unQoz
 cCoVTA8/WH6n+Pw==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOSBTYWx0ZWRfXz/Mot9mvJfnB
 AD4K36HkwFsvdlpDQxL4E88p+fXzsNAyj8JISkkH0IdeHnzJKiQDjlfYYaqEWAZMeLxMbX8tyhM
 V3BoOSSLza7dLzVEgcaDyML1jq5f7WM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOSBTYWx0ZWRfX3oft9mZYFSz7
 UcwRNMleHPhxZDnEYs+V3Ua429BYJmX0HKsXqyR+XfzSxZ421EVSZXE9chXmIRlMRdA4Pgv4J6R
 3egiYXBM7GsTBfqrQdxGOwUA2LCc8p+R7rowh0C8Nt9WJ8+1H989UQUSyEJ0fdi6mLOBjwjdZGV
 OxBrUzQIoaxUA0eFD2G9FJqE+DldkZjgpVpdSlPnQKvjN4NYDuQeRSOnsKpYxmlucYS8x5jdgZ5
 4dvF8EGAxtQf36XbsWtqqJgLtP2AauuO2nlraQl8t1/Msj/j1N33IE3q1Fb54c30AUFtEeRe/l6
 fJU0/dSohb/3kpCau68Hw5HTRYlPAdin9g+wPrrwEyK3mjFzG2iJ01aCBVh9l8tKOdoDBBma77Z
 pG1cwf2iZPTfV3HcGBEYG+lyJMYbTwqApomrejqZQDBDB8FOClVKcMkBkMJqz+7UEtM942rxHJg
 bBzU/rJ7C2Dw/L+Uing==
X-Proofpoint-ORIG-GUID: TR06BmxfGBXZV4IuuUWsa21ZfGwq7s26
X-Authority-Analysis: v=2.4 cv=O5+sLx9W c=1 sm=1 tr=0 ts=6ace00c0 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=s_o0qblw2luIdUq6tZ4A:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-GUID: TR06BmxfGBXZV4IuuUWsa21ZfGwq7s26
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 adultscore=0 spamscore=0 priorityscore=1501
 bulkscore=0 malwarescore=0 lowpriorityscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610130039

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
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/core.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index bf3c1bc3ba7bde5e5d08e06071c67ba77af95695..5b1bf7a50f88c890da1f0820fb9e070b3d3f4708 100644
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
@@ -22,6 +23,9 @@
 #include "sha.h"
 #include "aead.h"
 
+static bool do_register_algos;
+module_param(do_register_algos, bool, 0444);
+
 #define QCE_QUEUE_LENGTH	1
 
 #define QCE_DEFAULT_MEM_BANDWIDTH	393600
@@ -259,9 +263,11 @@ static int qce_crypto_probe(struct platform_device *pdev)
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

