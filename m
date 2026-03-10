Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C833A9D8B
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 03:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773111804; cv=none; b=BVuhCz0vsB3FOhWSIja2Bow7vh25XwS9/sikspE9U+ksig8VBfl6k+aS9U37jvVqrp8jPnnO54yB0f64igzcgyX4PPIsf7MP5IedU1CklaYYoShJfDrZ2e6s9/RZLgkQ6NxeBYhINLhVA2ChD4X2WfuxQhDI6o8N/QXG3wQuy9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773111804; c=relaxed/simple;
	bh=t2hQRdgGbYx74rKpJUZlmjpa6gqXMeuqZD2quztaKAI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B99kogbPOJ8P7KYfsU+HXTdaY5NvOZKZGVamALUS0ZQvxlvJcCB+QtW2k6KFvdi/pxV2uUcDhmr/nYv8szF/tySLjl5h5Tft9TjdKh2LHaInC+VqQ6pWOmPkfHFFyFQzcM32rBiDe7RPWLhUTgnmPEmQS+9mp8XJrWyibxgOYTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=fOdozkCs; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Cyzh6IHV; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="fOdozkCs";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Cyzh6IHV"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62A2EJrn247058
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 03:03:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=3pKDvUPvCEfyOzyBACg8qvsQ
	G8+QAHKva07I6Clvx1U=; b=fOdozkCsPpQh5t5RBrEm6zb3eQaGxpubIx1Ub9gx
	Sa802PtMhverTqdavRdOL0wrV295Ugu3eizoHX6sRJK2jsrsNunZ8W3YoyvFMYvO
	fF9cTtI3TuNBo3USQxCkNcM6xMIMcAF+yPmX59C1YVoGckhqFFLEwDDtTvZZzCg4
	+U/H016huvazDheaZjRM3ww9IKP2IWcMK30J1S/V5ZHxo0amDbSC39JwlFaiGuki
	l5V+zSR2kaSVTdjs0VRK3HrpK9lXztVp33FI6/tqBx6JeF7uHThXmtkWRHvl7LaC
	2peBzzeVM+8hi634Zjl8lBDM3S3AkrDysg7xKQfmdiWdJA==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ct8800gvb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 03:03:22 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8cd827a356aso1068769285a.3
        for <linux-crypto@vger.kernel.org>; Mon, 09 Mar 2026 20:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773111801; x=1773716601; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3pKDvUPvCEfyOzyBACg8qvsQG8+QAHKva07I6Clvx1U=;
        b=Cyzh6IHV0m0txbEnqD4udjAjrODTe7/ZvXj7FQ4r0nUW/jSPThieamiDU1YZkJhKCM
         E+5WnyO3DKJIjqJkPuA4p2Ast1AB3oROfxwO90faopteulRdpldatR2M8yzpwUSMCpPp
         SJcIq7WfsXZgtiPsxxrXML6G8J2uzMfDvJuKeU2alw7OhbZPMMjzu1sQo9PmAGfBSaR0
         +/0KD7/PxNAWDHwlyISVgNmNryS3Ra6s2nlPbB+4C81KVFtht1/cGRWQAEuOMSIVhifg
         oOoJ2l7hu0qKrf6jjeLtXNsR8hgK5ldhoxG7z1M//tRdg7+Al4zhbkfL/uosit8POX+8
         HYYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773111801; x=1773716601;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3pKDvUPvCEfyOzyBACg8qvsQG8+QAHKva07I6Clvx1U=;
        b=mGQNlJZuC3dMQInXF5/ARz2HdosxstY2YY/dtBX9ULjHDgmnHdZ6o6XRajUEHZvOMz
         121uJJdm2wXm9Yz9/wNZezJ49crbZW0gfLcouf6XS4Xqb2IciNscw82Fak4P4Y0MB2oc
         JyjBQ3WlJJdenaqc0BXBcKIW2hiJA4pUflQs2UbJIpHJODJ/4Hc80EACfTxW3JMwj0qH
         pE8JiOIlitmozYH80ChpkYlwoZ9uV5PUskpSJ9L8YmkIdCv9UNc7V3lGqoHBhj3BS6FE
         FiyAWLPIpiXNbMm8j5QjvotcXVwn4fc26yPn/4GFbdlBIq9AE++Z1wVUBw9xje0NkNN9
         RMBQ==
X-Forwarded-Encrypted: i=1; AJvYcCWSYrYOwHKH9EHVTvB4/2BMrCJ3xj/Fi1Co15OclHsANGzzR8FgGI+i2Ff8QrGPBb4gMQI4QFo3zeY6gH4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWU9cWBaYFzfJv4CBMRQ2UWgzXR3VRN0SJN4vBem3BsibU4QMV
	R06s/2YR8Ho42Borfy7/7yVp9i9UOpwuafxE6QHLiWVIxOBIQyOhMrrJo5lQBar3XZwmBpmZUPk
	RL4xdBVFGLB7hFYlv2phfNcSew6S1IDYPhzQ7x1Fdp7haYJbig80edF7cuH+NKMmwCBT30IOTFx
	0=
X-Gm-Gg: ATEYQzx9ZBCV1hSDQ2wy4LKKm1YvGaEjv5xphcAoCPAblbEWHsLVJYuJUcSn53kQ/9o
	ACXYV3ktEimVYix2UEjF+w0EF/TDNWzka1dYWCmijkR1OTSqu63EXgMPOJ+WoznVAQiwx1IVlsG
	EW/852fqvbA8B93DuiDhfUIo2ICFDwD4nTB74D7wM9LKjl7Bht1i+4siIXdOQEjefnJ8tSoLumD
	xVL8COOri4d17QVVFAU8CzS/Z47yUWDtzAkxnDmjlSqgoZHgWx/YH1GyddB0DQX9Qrx31UdBmhS
	giXKM2IEu4jtdIiv0nRWfDdOke7qmp+YUPlz+x9U6Dfefgy+7+HgpYtEKOlz5I7BqKOWuHSHnD7
	dikjOfzgGesfYk1EGa2ionl2jhgZImH9iiaKfiIzpOZ2FF5aux1xKXdpYFyWIodZkA0LS/yTzns
	d1UuonLuGtFKlzpB2Xu8JLZMgHCpAlJDXXLRc=
X-Received: by 2002:a05:620a:29d5:b0:8cd:8569:b957 with SMTP id af79cd13be357-8cd8569bd6fmr794239085a.43.1773111800774;
        Mon, 09 Mar 2026 20:03:20 -0700 (PDT)
X-Received: by 2002:a05:620a:29d5:b0:8cd:8569:b957 with SMTP id af79cd13be357-8cd8569bd6fmr794237585a.43.1773111800369;
        Mon, 09 Mar 2026 20:03:20 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a13d08ce21sm2480729e87.82.2026.03.09.20.03.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 20:03:19 -0700 (PDT)
Date: Tue, 10 Mar 2026 05:03:17 +0200
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Alexander Koskovich <akoskovich@pm.me>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] arm64: dts: qcom: sm8250: Add inline crypto engine
Message-ID: <eg6nhsofxz3v2vh3crcbtivunszfuxkmirn5ckjxvuw3w53fkp@kesjd5jc52dd>
References: <20260309-sm8250-ice-v2-0-0c8c46ccc814@pm.me>
 <20260309-sm8250-ice-v2-2-0c8c46ccc814@pm.me>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309-sm8250-ice-v2-2-0c8c46ccc814@pm.me>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDAyMiBTYWx0ZWRfX5jA+9AJ0QCTx
 AERx+/AJ9TtZh5NYBIJwnO5QpJi2yRmVaU3moESw80tC0sIBlAKzPERtbW7xicbhbq554hIapjl
 gsYLHV3z9ix0kw5QCO1rKyESulICA4Mv2baGBBDYzjBV2CBKz9LP2o1u9v7Qs1Gabc/aeBfe1HT
 5wd3L3sqoGPM8aX9XJCzgpAyVOs9JQUrPP++IZ4cnBaE2LzFYB77hWZp/jn5w/Wmp7uOqoE3oQm
 iBBBDbJjhVrya6WsD+TrkMrj0lg2KRDiPLL21Nslhm4yvu9hE7DIQhc4myz7t7/r3/uhX0f/Z7m
 w1Ta59SNrpMOO7LQD2BBtHKY0bxnDRWyad9tKB2lEh5ws9TEsw270Iv6ln768V8EJbHC1YNPB6W
 kDH0Hnxz/62Kmac43YkvIbnVb+jH8dJDfiEmsyuHVbC/fBh0y6x5o3hYf+El4RlV2ieyPP5KUV1
 Fg23mW1sOYvGL5Hm5BQ==
X-Proofpoint-GUID: ReumUJbSRi6_5I3AJ5xaJ_RV5BGucx1k
X-Authority-Analysis: v=2.4 cv=Jtf8bc4C c=1 sm=1 tr=0 ts=69af89fa cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=F1DPrRZ4MOdNTT26lOgA:9
 a=CjuIK1q_8ugA:10 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-ORIG-GUID: ReumUJbSRi6_5I3AJ5xaJ_RV5BGucx1k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 malwarescore=0 priorityscore=1501 phishscore=0
 impostorscore=0 bulkscore=0 clxscore=1015 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100022

On Mon, Mar 09, 2026 at 09:50:35PM +0000, Alexander Koskovich wrote:
> Add the ICE found on sm8250 and link it to the UFS node.
> 
> qcom-ice 1d90000.crypto: Found QC Inline Crypto Engine (ICE) v3.1.81
> 
> Signed-off-by: Alexander Koskovich <akoskovich@pm.me>
> ---
>  arch/arm64/boot/dts/qcom/sm8250.dtsi | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 

Please pick up reviews from v1

-- 
With best wishes
Dmitry
