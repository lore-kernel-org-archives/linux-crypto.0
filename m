Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C930537F739
	for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 11:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776857696; cv=none; b=I6DPMOP0+1n2qEfKOo8KrU6csgpsx8JHZmkfIQhkXbn2Pd7eK5qPGBJkMNuBW6j6O1FwQI7MLkbx1GsOeEuIMIFJoX6KcmiIQ3L8KCkau1530B3Pag8NuXJoKPTrNaY9LCEkvR8Xk0Q5o3b0j5EU71HHk3eMj1HgJ9kHkfJqSNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776857696; c=relaxed/simple;
	bh=oQYA1C2/yJyBSHaQ7CVd3HS1eb2vRrc2iFVxGKUvoy0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dwpefy2xH6nCTQVMF9inpZ88Ud9Opsbru6AYBuPqx+994a96+fYjpM8pWua18yVADk8/ukljIJtVdcuLM+wOk/p635idaJvZLg1nxYqKTcFsfkqS+8AnHD1hcLM9bqc0ARVOD8I0aQZMQ9S5OUVug9t8UbYRMO/kkE9kahR6mCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Rc+hQT8h; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=B3rGu4/r; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Rc+hQT8h";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="B3rGu4/r"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63M96EOp664048
	for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 11:34:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=VhO0gxSkAXa9LgLOly/QryTc
	7t2IcIRH7zgG51UsBJ8=; b=Rc+hQT8hm+RCIrJkigO0+vZkRLzezCnvKoOYjE7A
	vdA7xdFGq1aZrsdp4o+cZz0HFBZBcPkU/GK8ydRrNVdKLaKyaTuJ87tcdzyzmMj4
	zmi9WoYQ0glEOxetGncThQsWZc2vBSisfREnXR8tMS0PFX9QdUJP46kLcjjgzgIp
	yJZe4sccvRsHClemJ8Bkta2BJMmsYCpCv6cDqPtZFsiVn4wlnJKoGlrtUxp11RRq
	q+KEdXsbHMc1ViaP0ckoTnj+klZjbSovZRERM1vRdqvOlMp7Iz44Q6dsWpwemdUb
	A8lt/H8qqSp1TjaRcSlofCltQ1hUxhHQ5Sf6q1ij5SkY9w==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dpudgrhg1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 11:34:55 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-2dd1c74508cso8618041eec.0
        for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 04:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776857694; x=1777462494; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VhO0gxSkAXa9LgLOly/QryTc7t2IcIRH7zgG51UsBJ8=;
        b=B3rGu4/rSVAqspWR1b0DQcVDslltnL9OXkjqom0oigWYW44D6L4F26tPU7RGxlQb50
         fH1+4B55mOKzkgjCtsgsIeFWhq5HFbYuRWHsXGgkrP8AwKFSU9zvIYOeA83qjk2qhOD3
         n5FWfdo9p2+Nui6WjZWjfmf3ukqiwqiWOEAKm/Xo+7k5TmJ1iVh0xrAXBHcHNYu11tSE
         0Op51J0mrIYa8u5pwtoItcDJWBBkg2OpNmOVqtS3EunVVaB5gelShe+0bgaQI8u31ioL
         Yzo0hEgmoiSTOtxCtnO1U7Aqqzs94amynrYBX7dhrSh5vPcVngpkFMCwwxn5DZgv0Jhw
         t6YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776857694; x=1777462494;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VhO0gxSkAXa9LgLOly/QryTc7t2IcIRH7zgG51UsBJ8=;
        b=Wz2cXeehtBnZfe4A7jqC/ha969NVQlPi6ECnEi1LUPMrNu8FCEj6DRWKrgAu+kp8jN
         ZxAWMQyrkmjeZHstvAgpMJ96doUq8kCiqbDNuxFD0xu6CQl2eUYXhIRpYBpAxp3vHMK5
         B9NYzRkH85Hh+POwZDcNnq5L1vKLjSJF+FESIE3/1BBwTPMIxd9fwHnZPVTFIPlagrwu
         DVjt2tsHmHsWfnSGw6x1SVmtvaanlBtRFpR3RdbGhDmcny4FuNblycczWoGqfmxf/KGc
         zcsIHYW0xB+UptaxiEHswFyGE3Qr1s+bHZWiFRg2jxIweJf7BPCNYXGP+ovma5h/9KHn
         ZvLQ==
X-Forwarded-Encrypted: i=1; AFNElJ/MgSVleMmh94DpGoQZKX9KqB/4IRSoDPwEJ6SDpjImJNyn47G+E5r1SZRQ7CIGijYN1NGv2iC4l+yPW0Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzb25sh5Zx+eHRf0JTG9+E1UTeCkGlKc/cfmLO9kSiiCnF2lJq1
	YMetxamTUZ0SWKvXLyJiN9RsDdIx2mTPfpDApXmFqM58HPEyEOG85cLZoiNj+3ZmxFV6G0v1ihX
	sgbs336DmUL9dVGCeVu8La+2z0Lo698nF6QqX4+bY678TkG43jrzmoi+Dt8iqvkGi6OA=
X-Gm-Gg: AeBDievIR/rQBdq7j6FZElVKV2wlWlMKXIqwPsaai+YF4zrNbJykpKP7Cu/E2IRCUqM
	AYufiHjq3Pvfh1fpklFxIJZwBwwKYhwanaPBvrUWcoJ6B0Hw0ik03DKk+2NFqJd+vDaeco6PSHB
	XrwENIQyv5VKjIRJTHsa75EcP39/grTxgo7MKLJqowty+6HBGoQhyt7im8g1YKkX+VMC/0BtP9j
	oXyj5Zfdt4F8Yb8EjjyNuOboJ836Gwow/h92rp431CsP54KNJ0dCTsdKU2IRRMZD8Lh4zb+OLWt
	Hp2Oj25zVV9AQ47nK0kRSR5hb1XPe1UKvUeOEY6Ad7mreQbQ7F8VnbgDJoAvd5wGa+UEHclcx23
	ObLGHGVY+qkmnIJQ7EHNotgWi+n3whUokQDtQd9lkUY5AJXZ3FnYDpTPfnUO36ryMqQRfWes8Yu
	Q=
X-Received: by 2002:a05:7300:748f:b0:2c0:d46d:cfc2 with SMTP id 5a478bee46e88-2e478a2f02bmr11207697eec.23.1776857694409;
        Wed, 22 Apr 2026 04:34:54 -0700 (PDT)
X-Received: by 2002:a05:7300:748f:b0:2c0:d46d:cfc2 with SMTP id 5a478bee46e88-2e478a2f02bmr11207677eec.23.1776857693771;
        Wed, 22 Apr 2026 04:34:53 -0700 (PDT)
Received: from QCOM-aGQu4IUr3Y (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2e53ccce426sm23243943eec.16.2026.04.22.04.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 04:34:53 -0700 (PDT)
Date: Wed, 22 Apr 2026 19:34:47 +0800
From: Shawn Guo <shengchao.guo@oss.qualcomm.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <lumag@kernel.org>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: crypto: qcom,inline-crypto-engine: Document
 Nord ICE
Message-ID: <aeiyV37HvuCyS4BY@QCOM-aGQu4IUr3Y>
References: <20260420073301.1250197-1-shengchao.guo@oss.qualcomm.com>
 <dd5ee12e-1aac-494f-a8f8-74e236ecb47c@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd5ee12e-1aac-494f-a8f8-74e236ecb47c@kernel.org>
X-Proofpoint-ORIG-GUID: 9Ex8OREly8SJLtYu05NRyz7Do1jXt6gv
X-Authority-Analysis: v=2.4 cv=c5ibhx9l c=1 sm=1 tr=0 ts=69e8b25f cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=lhIjiZdZG9_ld_Bbx38A:9 a=CjuIK1q_8ugA:10 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-GUID: 9Ex8OREly8SJLtYu05NRyz7Do1jXt6gv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIyMDExMCBTYWx0ZWRfX+FEl+M7hQqcM
 yNp3M0S2jrByESvz9RnUmHpapaoFnHY0bTMem8RkIqzEbbvMv9Z7HyMUzdjxxvXu/uhs5+QT/Jz
 /2FgBPW20YZ7ou+DtPHcYLrtaGlFmOWEfAVMeYqtWnAg0V9dRvg/xTEAoGPBtJ0akehepd6YtfN
 qwhQCwTcWXAUKwe09BKYNFbMaUZ4wGL7p+i+aSyemoTX59E1h0azGdGAwiAd2qoUK8ODVVkRvDQ
 TaIUa08Cbe2dWVNLccyx8j2CfyHj4USmIhqjLspgo3M9JSvcI1FBu+IZt1aWNuXI09BmN9lpccf
 iGhTbocTvJYDJrLDIY9YySDUQe9R2sxlIzUh3/OFs2XEjLrzSuO1Jw8kJAeZbhZdMLInx2pCvfC
 2xe1CHDfTOpUGE6mPWoQcmhqMJEHHY9bm2fTWyQou9btXM+km/minXZ/vCIVxTA6bdTR3X5lYV5
 Iqi9r80FqK5n3cdyQpw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-22_01,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 impostorscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604220110

On Mon, Apr 20, 2026 at 10:27:56AM +0200, Krzysztof Kozlowski wrote:
> On 20/04/2026 09:33, Shawn Guo wrote:
> > Add compatible for Inline Crypto Engine (ICE) on Qualcomm Nord SoC
> > witha fallback on qcom,inline-crypto-engine.
> 
> Don't explain what the diff is doing. Explain why. Why do you use fallback?

I will reword it as:

Document Inline Crypto Engine (ICE) on Qualcomm Nord SoC which is
compatible with 'qcom,inline-crypto-engine'.

Let me know if you expect more than that.

Shawn
