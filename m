Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05E3326933
	for <linux-crypto@vger.kernel.org>; Thu, 19 Feb 2026 09:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771493985; cv=none; b=bUTx3iJI8oETNevn9f7Ve/IpxQuMWKeo9gXJCYRay8JODtwkhTs/E57j/tA4CsNtpEppnb+O/cUawjyUdNKEebN8x1B+4yAvlvUhvqsfSzgEpCVe3zL+sGO/Il+4C9999IylQkv+wvuw2XnZ07lA+g+eyV0HRlgQesdEfj4aggU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771493985; c=relaxed/simple;
	bh=xwCDUg2ytKuLG2nrJFZ2VDmvgWXuCeD1FC2O5By5Gy0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=utIG6Id96mX2Doq9VHZoN9+3UZj0oR+cw7/QU42FRHthgEKwyb5Q89O+7Ei5WWnYowrqqfwXSoOQdycA8Zxh72wnbhp67/uGN99WNbfZAcN6ZSPaNYKJH2zGzH0ToXSOhnqkHwexb+tK5HeBjWU6eiBLFd9zLjvtf1z7TGt7mPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=p71bUXtS; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=FjNZ7yKz; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="p71bUXtS";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="FjNZ7yKz"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61J1F8lW160708
	for <linux-crypto@vger.kernel.org>; Thu, 19 Feb 2026 09:39:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	U4b+6NzjTwARn2L0teShlEhfaZaMG9S6fCU77Gr+qQw=; b=p71bUXtS5RXb4gjl
	SILk8jyDIeVjt4XEInzLeoZzkb1gz+5sgromrK0WJ7MtmgWP83+/FKRtLBK9+/O4
	bbaPl5MbEJrzXKQYYjk9DrN0lrpksWtJW++6VL2qGmM1q5KQ5G+2a+qx8wjBJca8
	og3NX0E+4mQ6Kp3Y+j99K7mNjYWAPi7V+jWkEwgDGz6C3BFpT1JZ15+T+M9/iZuq
	MOnzzRnfJSq595JHzGO6P8cuLnHF8r2GKxsmikJzXBRlOuj/zRGWj6bhwn/SmUUp
	dvnRIb0HioGBg6n1q8nP5A2G4CRvFOPJrqDWo2hS0+9Y4twKmyxtBzvskHgDQytl
	xz3X0A==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cdrpg8y0b-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 19 Feb 2026 09:39:43 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8243a06b397so432875b3a.0
        for <linux-crypto@vger.kernel.org>; Thu, 19 Feb 2026 01:39:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1771493982; x=1772098782; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U4b+6NzjTwARn2L0teShlEhfaZaMG9S6fCU77Gr+qQw=;
        b=FjNZ7yKzmnuOvIUlIA82fASNg2ZBTunLMnRuQKElYbc43z+qge50AzH1NOaavh3mfR
         jl+CHvr4aV1cyYS1Xn9f96q0YFFBeZc8yWOXqqVPIZO7hRQSgeDAv0XZFjAtd4OL982M
         kM8S4F8mGLPvctNcVZ/sOy76R9oQlt9IdL/iN25e/MXGqLrHbpEf9I3ZaONjLSZ4H0Dp
         DRtkQnlbiV3kcyhMGnUP17X7JL7JttiSsRogdA2UPeKCcYo8IDpOREmUfECUzNIT+Rfn
         +kTrMMcJJ8D5GE0/cJlWzhQOvEDAndEeAkynnQ3u7QYckmdt+goYVEwo8jH81UGwqj7n
         sE5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771493982; x=1772098782;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=U4b+6NzjTwARn2L0teShlEhfaZaMG9S6fCU77Gr+qQw=;
        b=dP2uDytOAwnxI9ZiwcRYhWOav4JWuQh7dyKjJSdXr2Fg5Y+IroKP6JxonWEpY+6JKi
         PpSmVi/0UHOC07Myrz9v8q6cSldRI9dCw013f8SQ+uaAj4wxtWVliMSu8zfYp4tj3qLO
         5aTpQL5vDLc5SmBYUCNGOrdxblff4owK1w0GUyJhKlvOKQ7A2qNAMO275TOM3KVENZVR
         BSvYKcW2tisqnumKAUHlI086kk37DZHiHZnCXjRRkjQbpsyWUnKW5Q3n9Jq9OuwosMlK
         +Pxuw8qm0MANS48AaGLrRZb0ZpjDWcTl2G37CaEJhM+hsjF9qesATk47vkz3yDqhJCVl
         OHCw==
X-Forwarded-Encrypted: i=1; AJvYcCX6R9ADpPRLabMO1P4G2FdZy/ES/DIRLpKAzkPYS/Or8Sh7jMBhNEAkqoIaxR09uEKqKJLMe7YTIZv5Vsw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwONlZi8UUxYNKtBtwT4vmkezzd2uq/y2TVUHaRlBMOr1iwqZaH
	bFd4RZPsj0r1h7pgoqXn3/ADK95WGj8lM8D8ougPxGscma/ICMKRHzWqMpIuAU2EkuUB/Jih86i
	Tj+9ILp6/GvMDEVv90eaRtO78mrTlZuPZV08A9T9OB4IjKp9fx1id2rJQJGor/77XQBQ=
X-Gm-Gg: AZuq6aKaesxXHaH7ayKGU/I8FhpnbUdoEkvvQs8VtU+ZhIBtQsY2tvW9kHaJjLsUnQN
	oBzcv1k5rab+GRxUTQZOSvrX4GQxx9B86jaQcB3xH/jCveUVuVsI9TER04skLvzJs5qgu3esuDZ
	qN4uSUuB7B7VYquYno6VkNqwn7WYTRY7/ojqMsAXhU5u13tV3g30t6Usb2HXXBw9t4E80AfxlYj
	5k613uUPVExOpq09u0o4PGA8i0VbJoVK9zeVD7ior7iAAlhDlY00+xgMkEMIzJF8gUXLSgG6I6Y
	GEGt+NTaPwwBoOwepkPmMdQdeqsoY5aI0zt0wQ+BRTwDs6v3M3oRo280U45dMC87JvCxxBHDlRO
	otk3oCy4ugxhrqi+/emKhUCbjHZ1YixkU/VPsMScks9qIaGBdmWkm80TzJhs=
X-Received: by 2002:a05:6a00:14cd:b0:824:a6d8:3fc0 with SMTP id d2e1a72fcca58-825274bb376mr4199763b3a.25.1771493982395;
        Thu, 19 Feb 2026 01:39:42 -0800 (PST)
X-Received: by 2002:a05:6a00:14cd:b0:824:a6d8:3fc0 with SMTP id d2e1a72fcca58-825274bb376mr4199742b3a.25.1771493981923;
        Thu, 19 Feb 2026 01:39:41 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824c6a2ac83sm17710250b3a.12.2026.02.19.01.39.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 01:39:41 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Thu, 19 Feb 2026 15:09:16 +0530
Subject: [PATCH v6 4/4] soc: qcom: ice: Set ICE clk to TURBO on probe
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260219-enable-ufs-ice-clock-scaling-v6-4-0c5245117d45@oss.qualcomm.com>
References: <20260219-enable-ufs-ice-clock-scaling-v6-0-0c5245117d45@oss.qualcomm.com>
In-Reply-To: <20260219-enable-ufs-ice-clock-scaling-v6-0-0c5245117d45@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-GUID: LX4RR8Hg-purKCUupT4l9BJID4g69aMu
X-Authority-Analysis: v=2.4 cv=JrL8bc4C c=1 sm=1 tr=0 ts=6996da5f cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=EUspDBNiAAAA:8 a=u1bwIIJuvd_SIhYoViIA:9 a=QEXdDO2ut3YA:10
 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDA4NyBTYWx0ZWRfX7w8KhSNKO2Be
 XUzGR0pDOytQqNczQg60hDyGtMkhvEEvQjZHVHlOWGy2Ad17L7sgmx2DDA5FaZg9YDE9/fOAG6S
 qCsfdiyRwDjJuz/xoS8/09rHwGnqwFw3qIxZ0Tni9urIZUTvkctDYaeZSzezhRCEqT+mn0XdF6D
 SlVrPKI/thr7Ocb8lSlx06l+3RV6znOH0oJ9XfyCvVMuTZXWRptqcMte3UXxws20O8gFrlP0o6l
 AQFFfAmp94O+MWq1QPm2ekbYowqa2u+SBUe0ZaOELxqBeBm5tEIEJHNmCKGtEQOQ2zpJ/kZGRLn
 89JPSy5f6GW1N+KeKnu16ZQTGTeQXyUg8C+WHudi4umtVXF4t2S6HA3tLWoGCokYdcHfzcHxPtb
 tbvtfyKYWHWwyjJEBp4s1C2+0gouHQnycLQxDIMxiQP4CxOIX7gQw3UvylhFjdQb67TtJ/y0j4O
 oDWOzTVMNLZOConqr4Q==
X-Proofpoint-ORIG-GUID: LX4RR8Hg-purKCUupT4l9BJID4g69aMu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_03,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 lowpriorityscore=0 impostorscore=0
 phishscore=0 bulkscore=0 clxscore=1015 spamscore=0 adultscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602190087

MMC controller lacks a clock scaling mechanism, unlike the UFS
controller. By default, the MMC controller is set to TURBO mode
during probe, but the ICE clock remains at XO frequency,
leading to read/write performance degradation on eMMC.

To address this, set the ICE clock to TURBO during probe to
align it with the controller clock. This ensures consistent
performance and avoids mismatches between the controller
and ICE clock frequencies.

For platforms where ICE is represented as a separate device,
use the OPP framework to vote for TURBO mode, maintaining
proper voltage and power domain constraints.

Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 drivers/soc/qcom/ice.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index 1372dc4a4a4d0df982ea3a174df8779a37ce07c6..a60a793f9c230e08ebd7cae89a828980e762db27 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -665,6 +665,13 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
 			dev_info(dev, "ICE OPP table is not registered\n");
 	}
 
+	if (engine->has_opp) {
+		/* Vote for maximum clock rate for maximum performance */
+		err = dev_pm_opp_set_rate(dev, INT_MAX);
+		if (err)
+			dev_warn(dev, "Failed boosting the ICE clk to TURBO\n");
+	}
+
 	engine->core_clk_freq = clk_get_rate(engine->core_clk);
 	if (!qcom_ice_check_supported(engine))
 		return ERR_PTR(-EOPNOTSUPP);

-- 
2.34.1

