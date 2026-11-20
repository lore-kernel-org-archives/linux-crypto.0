Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795176600;
	b=zFhwtbAEPGnOYimcfMQMI824ZGFYnC9BgUFDHtOXtVPZeaFbYgv0zIs0L4DsACeXgjkr
	 a+Go+96fY6qfLW24OspWyrZfXgQ9aEANtUICf4V3C33j7W2J5u2qFxJBUn68rqtvGMoT8
	 Z45euWLvj4vv/HrV4nKBqYxWxkbotfSfJykMy7nwVC0KQAYAWE9Z6VMceh+xkvDJuM6K1
	 dZQpIUdwNuGxp8VYV9qU+4hIAJt0c9y+yveLQeawSU+E2oDrn36eaYAoBnUPStdNoRFYV
	 iXxQZyAUPISe8oysKLCYr7hOywRDtpYWM0Ghrle7Gu4/oHQgb+c3EPp0PqpV4+j3jCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795176600;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=NgFZenonLIOYrddnj7GBaw7dtDGJBTol3GdISdWN9zA=;
	b=HQSikbQ6cHCeqfsu8u1TvZfp2+5etfhV6c5oSy7N/G90zBsu1N7ICGj0wMuwN9cwJ9Pl
	 mthi+Ef9GIW1gQuiI7aCqV30U4mN0WARtRa+Iv8oUYTazhwjcb7Jx9ZYFIAShUrkg69W2
	 9QaFmn6GYZpE7AW+PSaBA17VmIaD5mPJ3t2fD0jm6iTb+1XDh3TD9XzTBeRUp0LtsvVY5
	 wghAy5BBJtG0yT2AePsOZnHflBvlQesrz5kjzREjM8DPxfLJml9Hf1XqTuIpU2q4LOXJ1
	 LNHDyizfHJpGd2qPWx+PgfEOfZuFBE0m89ei+NMgMljJYPVfeh4Mblo5nCIrUH2KD6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=UqHLWQpi;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=JPrSDN0x;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FF6606A320
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 12:09:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B3FF6606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=UqHLWQpi;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=JPrSDN0x
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKBoblv1203420
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 12:09:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=NgFZenonLIOYrddnj7GBaw7d
	tDGJBTol3GdISdWN9zA=; b=UqHLWQpi1vKez1h/j4dKBd+k37dj9G2exi2kPZNR
	VGUaCftrWXxEer91rCfRSiJ+94Xnq6Qh7hdGQ8tIqDLpgmkcjB5NiAPU8AOY3eSN
	HJDcfDQhq8GE24Ao2/MKETS/+qQy0SQWXX2IqmCmk8HAXUculPOeX5u3yHJSOp2p
	xH4W2D/0oLjxNS/4HvX8Z1MynpO/FhomeVd05WS5c0b6MzsQ/wRO88wbkmjfErQ+
	/YTrL69kBb4hcZUPfeKNmjn5xiA/zm8PVLVazLIpDQW9rBYI1AyAIyfVZXtQqg6p
	MHfvuAV9vbZ6FwbdpnhcJ8drdzdBVBg7zGZc4oju3VDpWw==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j27fykj2u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 12:09:58 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-94960131befso146134585a.0
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 04:09:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1795176598; x=1795781398; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NgFZenonLIOYrddnj7GBaw7dtDGJBTol3GdISdWN9zA=;
        b=JPrSDN0xE574o4MVMz74XqzX8BBzW94o0pcSq5sns6DvwJiVfhVybkatQum5RPgITR
         UmLzChvWYGI09dcBFHK2n2J2ZY8YfUFaDY4b9mFU6dDsDatCJsy/TzeG4T5BDUrPuk9k
         eaWPBEVzNwZb92OfTuBC17lzJU71yLGlbe0Ftpwj8kmJym3nRJ3LZO80M//jC5cpYA63
         x9c2n30X3uI+JBuBFuS77ybyYaYghK7EhLntijjZ8dr+qpuUIiiQKFxOwXlXhTDtTczf
         JlKhJRH2MukAJ7t/k0L/jpff/8MPZZq1zgktoOPRwsiFvBlZKAt6xhPpkLnYYgAJD6jt
         H5rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795176598; x=1795781398;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NgFZenonLIOYrddnj7GBaw7dtDGJBTol3GdISdWN9zA=;
        b=NAkaBo0h5ShlqxEoDiIqeAo1DRW6mXVXgvqa9Ts6kqHrQF4e1G6JRCZ2FnLXA/5+Mo
         ndaqYbi+PPeQkng0hGfm+Sc2ZZCVqwPrdQGGq4xVKRjsFMSeqtP7W2j+9jLtiFozpzF9
         cuu13YVxmwZLhwpYAUiAs6S5MV9zSjaUGdN+cLkzQSbjDDpk7VGcYpTDRhFwhwH+EVzk
         8sLOFI1Jy6YfBptILIjcky9WSEcLHkiohal873z/rHvjPd/wXS3+wsRJA13sDXI+8g0R
         FsHPwvuCj7RQoFABmKBdKpLXesx7Klr6Yfe7Wqyguq33l45PXAurKP8gJsltvx1puPWi
         KNdQ==
X-Forwarded-Encrypted: i=1; AL+hErEyGkgza9RKztRQ8nMai9bG7wMk4otd2eQL2lGC4AZJSBijdWcNr99jq1DE7FiGWTENgmCsjEliauTZL1E=@vger.kernel.org
X-Gm-Message-State: APuU4Z+6sztdBEyhhJ/Tp39Av9vqnY67vC9Qt6f4NZwW5+TwCRzXUdEC
	hTutGNyAEtaVjaqwV3GUasEh/dIg+jwr+ueDQNNulZ2bnSMnPLrnPOZwbEebK9kb8/SaS1fsvE3
	asSL0YfetZSJm5bF62U0K6LoVSmWdjI6n81nGYVZYrErEwHIWV6SJgsDERT9sOtystrw=
X-Gm-Gg: AYBFou3RzCmrWL3Cbsze1zTWUvTXeab2/A2RJoyR+Xrpt6WIQyU/QTYbP/C4+MGi/MO
	DuvALcuXL6ZwtuflQnaixeQm9RCwjVwKH7ax4ZHHsRymYbyjOOpc/Jbr2bct2622x0ga1OeTZVw
	FEYbqbll0qkTnTp85LA/n0C+OH3q9ojoJ1te3SLBqXQ3pA62mzkjWETr0vtOy2KtEJAkAmyYESo
	2xTBG1tdih8XYgzaT1Yiu5WSeppTgiEz5NYXNnYZLRixrLzcysbdxGHLzrhX/UdoKZDPvaIeEJi
	FaCV2iLmtOfGAe38qsJog/7/N4qWj1zwdNjPqh5G8UhLcxZOTn8Dwa/ffR+dvDcvya0fYkcEk3G
	gCMeSO4ARJ40qZ1v+EgVhqJlRx2lo9PObgWUE4Wcx93ax1hj1yngjW9K5ThCuuoXy
X-Received: by 2002:a05:620a:199e:b0:947:82db:2f9d with SMTP id af79cd13be357-949ba7e18fdmr433991885a.2.1795176597829;
        Fri, 20 Nov 2026 04:09:57 -0800 (PST)
X-Received: by 2002:a05:620a:199e:b0:947:82db:2f9d with SMTP id af79cd13be357-949ba7e18fdmr433983685a.2.1795176596918;
        Fri, 20 Nov 2026 04:09:56 -0800 (PST)
Received: from oss.qualcomm.com ([188.27.161.77])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab65cb4341sm5645885f8f.4.2026.11.20.04.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 04:09:56 -0800 (PST)
Date: Fri, 20 Nov 2026 14:09:54 +0200
From: Abel Vesa <abel.vesa@oss.qualcomm.com>
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: Bartosz Golaszewski <brgl@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
Subject: Re: [PATCH v4 2/2] arm64: dts: qcom: shikra: Correct QCE node
 configuration
Message-ID: <pjcdhrc7b3gs3ll5ml3d3ohnuivtc4rcotnhnx32rydc7htmfm@y37lvdnugj35>
References: <20261120-shikra_qce_fix-v4-0-5249e31394ce@oss.qualcomm.com>
 <20261120-shikra_qce_fix-v4-2-5249e31394ce@oss.qualcomm.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120-shikra_qce_fix-v4-2-5249e31394ce@oss.qualcomm.com>
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDA0OCBTYWx0ZWRfX1HC4l3PNdBEo
 JceGfRu51NXSrXeXFVNlrHZIK/5jitJbOR6GhJ74NkYP1HoWNmkO7NG6iEr7WRODlqoK7AjK1XI
 L5BMiXuVCvTqc0djrs4VwAZRBbmrTWw=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDA0OCBTYWx0ZWRfX2VAtTHTMNIdT
 5bBg1speN3ZC5gaKEKaxzVpk1h18hCIuM/njt9VQcfSFEXFWBz4siqUQ3AkUF1XnmOD8jcdXV8C
 nkhNyXXVYY+8jkvdd7HwjVhDYjwHYX8X1mpxCxipo/9O90oJBKK6m6RMrucdfLnWkXtO/BDMvzS
 MzQTKJZHo8R5q42yldri5sK5q5jrvAm38F9yfoKSvnz+cuNUUgLZy1FWGL/0Z8kFH+ncoOA3BYm
 d8wtwTa/n9VOdRkdwZJ0GVKX7Wme8Zsi6WnKGBVLDh4Zk6kOXhvgSJb/9wEkDi/6hWTSiBXEGDq
 N1orehp0dKuQfTpCxSO/KumEdztEIg4vNcM0eyx3zwjwny+gsSuZDYw9DZYq7a1UfbOnd6HsK35
 5TR2BoN9d+YAACgMZx9AZfCM1rCiR1tLqyWr4hnFLCLzwLIDRaSLJ7pqW85OupRa1qkRGnitJkC
 hYVKZmTFAhJtZAZSIYg==
X-Authority-Analysis: v=2.4 cv=GZKCDgXL c=1 sm=1 tr=0 ts=6b003896 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=asF+/XNaGoxFafzDDLC1GQ==:17
 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=l6_oCbVy_dZ6_alwpPcA:9 a=CjuIK1q_8ugA:10
 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-ORIG-GUID: SreGykgS5YXiEYJCNpa288cF1Nact7i-
X-Proofpoint-GUID: SreGykgS5YXiEYJCNpa288cF1Nact7i-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_04,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 impostorscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611200048

On 26-11-20 16:59:53, Kuldeep Singh wrote:
> Shikra QCE requires an explicit core clock, which is missing from the
> current configuration. Adjust fallback compatible to "qcom,ipq4019-qce"
> and specify core clock to match updated binding description.
> 
> Cryptobam is controlled remotely and its clocks are therefore managed by
> remote crypto subsystem.
> 
> Fixes: 099cd05d200b ("arm64: dts: qcom: shikra: Add ICE, TRNG and QCE nodes")
> Tested-by: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com> #on shikra device
> Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
