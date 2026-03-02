Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E5741C0D4
	for <linux-crypto@vger.kernel.org>; Mon,  2 Mar 2026 15:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772467062; cv=none; b=YrMZ/JTXnm78Le6NhRUACpRcLcH3LiLtjrqiulEMgeNF+1tQ1VDUxhdfO/G5GNRvjsEqicYYQFlZHVC1Eig//wcr5ePPffZ/Vwu6Ae1FQTN+q2K8kTxfha0bm/9QBUxvMDUQgFkEQEVVwZKy/dNBI/PhpUzSCHG31ql7CkthCjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772467062; c=relaxed/simple;
	bh=D/DbbvsYNV6WfJJN+Y3qtsfzsdueJP3Q7cdgK44aCk4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OzgKkQf8a5y8dRsU0xszAifJYzDGQQbtTt7U+rP4j/i5+dP60UVGpKdGsUJyxQn8eg9JYQL9QjabAIlivQGd/NmGLzqmkkSurJfcfPv88vOgNBEU+y5q8Fanb40p7i73Umg/CgziCWVnau579p/XvTONW41BzW+cz57Yxso4h9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=SBllgFz6; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=GRYo3eiq; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="SBllgFz6";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="GRYo3eiq"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6229JZ0E3742101
	for <linux-crypto@vger.kernel.org>; Mon, 2 Mar 2026 15:57:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	f+eJOMoesWuzpXTSR4Li0Qt2PYtZi1rSvrjFdAlx9Tk=; b=SBllgFz6RRZIhcTk
	Ovu6OJSriXhpnFIAcfKMJw1i/J3Db+QzABVLKRafiE1IbZWrDg4NHUqNrjA7lNrK
	AyezPrXWrAuZXainW2H5Y42tef0FKODWk9H5vHx+DPptzFfBc+GR1MXkgv1KJ4NS
	2ARW3hIZdFf0XxToG+oeM2qWDWJMdi9W+NOhFXILIMNfHes4+NS9OHveiEpR7Usn
	yq6Df3jmdOd0C+Nn5nNpgFdRwxZdhjmzoMDHnwyEPpa8Z0rzAORzNvv7DfCczp0s
	iKGijakEU+5qPOZP8FhzdzVxGg91cT6KzZhnGEN4Elap/cHHUhCbbng4LEcgovh0
	GS64IA==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cn7trhba3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 02 Mar 2026 15:57:40 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8c70e610242so48899585a.2
        for <linux-crypto@vger.kernel.org>; Mon, 02 Mar 2026 07:57:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772467059; x=1773071859; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f+eJOMoesWuzpXTSR4Li0Qt2PYtZi1rSvrjFdAlx9Tk=;
        b=GRYo3eiqJxLRXkxitrukb4G0FUXi6oUabzpHMWF1MC/wLXzQnkI3f51cpcDvH3hx+Q
         1119A8+zX98PctGdbhZzyUDlLPQNZWIanHvEq257jKdOHk5oaGFZoJnMjRQL3xirEa+a
         B0RTNl15X8LfApj3kfqDZoZqU1aB338IhtynQVRzo6lOekQStSquocRdsjMrKVcPpSRT
         SVG0zirxWvRr0bVuHT3lhsjYGk20gcbyEjBB8ZKzWO9FEwpWPwcotLzSxNtVukj6W822
         HD3x1semrSQuKCP8D2gr0flD48tdCtzs6LGqtKqWT5eNToLgKC2P0mDZq+1YXOdUkTeW
         3MaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772467059; x=1773071859;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=f+eJOMoesWuzpXTSR4Li0Qt2PYtZi1rSvrjFdAlx9Tk=;
        b=Ndca0S3OwN+m8Ay8Wpru+4ePr6k3TLxSKzL1mkl1+cs2JzrTkejhLpq8h4ae5/17Iu
         3ZRBItDbOI/+vaiZRSaG4FpLlOhEIzGRkbMhVBGAP6iV7II2ia3/KoTSf7LM8OSfmdDV
         +GfStm687K7mV9GS8giz0PW20VpFT3ElrIpLWgQ7NVY5dwKIBjPqAnzE+KijOlKm17yJ
         GSlpeJ+/bUMTk4ihy4ip9YLX1dugIEAKpafVG1fCpZfRj67Uk0Af8Rmx8IDbIDg54svq
         mDHfrbO7Tvz8WsT25bPeQMNdNfOBhV+Q8BRb9ZPmUlMuGhiLgT2DrWW2nxQBgO05jAEy
         hG6A==
X-Forwarded-Encrypted: i=1; AJvYcCWoUxNo1oADxgxAVoWx6hCFpnMvBNcxvgu7CgQ9zFWzYaP+AupXqsS7DgvI1hcOvdITDiLQ0wLSefVeek4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZYW5Sm+5k39KVraqK745pvPeO/99K1vzi7rdmX4t5Xs0R1HNO
	mVse4an8rKkbZlL0HLI3D18rS95V0zOIPmKPr1Pce6eqnlLS5PSvuxLTM2EUZT0vi/9SbaGxHW1
	++GpzgI31xfMRdGaqVa0XoVUfSan8mflUS+s1CRBiG2q6HLCXRSP/+Nbt1b8Zeymodkc=
X-Gm-Gg: ATEYQzzSi7ck82Q5DM7yXmjcsvBHof/w4KvzdSpuH68mIVeFmivxZxEhRVlhOv1Anyj
	Yo0UtO+a5dUSAL46OYbBrs2EFwRy6/HXV6XuZ9AMi5hD3eoyYuXyXgeUQm9p+gxJjuNaMl7TW6i
	HZE1AioyY21Xhw63V2rYWengPXfq+6KWks+Xg9cBYWCY4kJwHyvEMlpAZriJtrF5rBiyDakb3Mv
	bLTh10chjkC25WVSSAmP10hvdwmF9K8UYTIJKbl0MpG6UMdNMkzXGZNRkd8SImooT8GDlA8SQGQ
	oAe2EilI3dbgRnPIQkU/TY8gPqmSKrH3Jk93ClscYFGLSWgGY2G+Y6pXUm0RGpsp88ZBPPsTKMi
	pQVbqXotzQ8BU4N19g5ME5vbW7ajgIcSTbqqIWdr8JQXz3BVx4se7
X-Received: by 2002:a05:620a:2846:b0:8ca:3175:cc9f with SMTP id af79cd13be357-8cbc8d836f0mr1605848685a.7.1772467059434;
        Mon, 02 Mar 2026 07:57:39 -0800 (PST)
X-Received: by 2002:a05:620a:2846:b0:8ca:3175:cc9f with SMTP id af79cd13be357-8cbc8d836f0mr1605843285a.7.1772467058928;
        Mon, 02 Mar 2026 07:57:38 -0800 (PST)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:87af:7e67:1864:389d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439b41831easm11282438f8f.12.2026.03.02.07.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 07:57:38 -0800 (PST)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 02 Mar 2026 16:57:14 +0100
Subject: [PATCH RFC v11 01/12] crypto: qce - Include algapi.h in the core.h
 header
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-qcom-qce-cmd-descr-v11-1-4bf1f5db4802@oss.qualcomm.com>
References: <20260302-qcom-qce-cmd-descr-v11-0-4bf1f5db4802@oss.qualcomm.com>
In-Reply-To: <20260302-qcom-qce-cmd-descr-v11-0-4bf1f5db4802@oss.qualcomm.com>
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
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBppbNjIaYMypGt8AbHNF5MYs8KdA7K86/B7cDgS
 54sf6/cmuqJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCaaWzYwAKCRAFnS7L/zaE
 w0cOD/94s/2bVOYiPJCqENniMi93N9mRVCLsomcrtCgqWQvkUCVNkga72G4hnTw/2yRADy6XCw5
 AaBdMHMZAhqkwyDDEMKOY5lurPDLsKWEGa84cNzNu42n6FPk8fn6zQkRtK24uloTiYe7nh+cB6A
 Vb3IJrFrUxsFV7PulNIIYL1fFbLG97Ih7FGicxvVJH2NoA2Cbsz3UeJ8thK5XKlxbOz6GPqH+AX
 F+idKBhFVulPgzv7whqCc6Y012RFhROz68EM4/haYyBx0faNOkok+XPFGCo6nPOw164Eu2JKjC3
 IX+SAfJXSoxiwSv4jFzy5MMkm1DALxwNW9jO8v0kvS+BR0d8Op8UPp5DuNy2dgHm8pn5CBcHumq
 1ETgZZYJVZmQgQf4q8+eR9OfgmOhOZjZFubdu4f+fo+yeH8XBb1jx84zR6xjG9TGHJwa2O5TiwQ
 4/9SD0YOPRMu7fXfpOn8RPNOrtCyc2tc009e0h94GKnlEgrgjDpieFzn5AQ1Z7UFj0nRk5B57+8
 hS6c9rykHJnGLOR7oOIX4nb6/cuG/kouDAUF+TPDwVWYEd4Hg8FCfk4ESBu+/WdxskI55J9RDcT
 TpM4UmipiuyNO8k/P8QAjdaRMQdaVGP82uw2gPD9qg+NBgF6MGKVSBYKoPX/s+IcmRdIo8MbsVY
 AK3NULbojNbu+qw==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDEzMyBTYWx0ZWRfX8YyIlWY26Ym+
 +ric/luSk8/ejJIh+Td7a1EBMHv/Mn/rRxyPw0BX+1ib70HBlMjY8T0Ltn5Z9SfAlfaYoa/1F3F
 EgnwdcVkxzfRZebmpHeMluCJ/DxnRRO9CcakPxwjqsQ4gXCj/hQ/x0TdwsCrhK7PyVMvuLZFLeY
 qR5cy4Q1XMdXD/saPsy2nk9JMtjREbYn/TGkVShpApMlzq2BE7yHuY3z0zV38+jkvxz/6+6pX3A
 3KpZJju0NhkGft8D96aogi0lGiWdSWoeLEInJVSmhnY2w08JN2F/mwRh8grSZjIue8Ml0SpvRIM
 mIlC1F+8g0ILKuJ/xrJHvA4ks4qHWYJrqMS6kXYXajXB1mMYEvo122xolc51gyZZJPme1j+OHNA
 6tl4wn3fZ+snAWQNw0zbMfcnpJVkpLoBFgGWij7qZvWRx3M3z6Y7xFdregYB7v3seIezf4lsYng
 7WbMOSbvANSf4F4wbtA==
X-Authority-Analysis: v=2.4 cv=TNhIilla c=1 sm=1 tr=0 ts=69a5b374 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=KKAkSRfTAAAA:8
 a=EUspDBNiAAAA:8 a=rvG61WhHFVBzVmnuldcA:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: 207n5yc2go3ZC1hhtayebrsVxhuA9Yif
X-Proofpoint-GUID: 207n5yc2go3ZC1hhtayebrsVxhuA9Yif
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-03-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 bulkscore=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0 impostorscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603020133

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

