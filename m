Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5143806CD
	for <linux-crypto@vger.kernel.org>; Fri, 13 Mar 2026 11:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773402721; cv=none; b=diHeANX/dgSDm1gIS0VAEconVqcl7BwnjfqaKdUK+nWcP3K3XOjK2985xz7r0JnslowHDrt2sPfFqgEnRExa4k4hf/lL3EfOrJG7UZMBpZxHeajT4LWH2UrRkLP1ztyxiX03ueVD4/mjdRxGZOBt3Sq77odQ72bMHjYpBNXOlbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773402721; c=relaxed/simple;
	bh=sxOI1OM0tiE7WtkyILuUlo5L6N3v2T029ANh2c2iziY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qT8Dir2VltzfVqFaSXgBWf4Wr2tYz6KYGGml8a+qDGKgNU13Lr1XN9+OLJCYw0d6uOGuktjMbBGZ9Gldnvpx26JUeAFepN3AkTjOmsYoqdOJkSd3Ey22Bfj1Fw+8VliDuhbBH3MREkBKwMNrupNNgNIVhO52yNDzRNw1sWGe7tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=iWlE0sQj; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=AsS7tSvx; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="iWlE0sQj";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="AsS7tSvx"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62DA85rS1749468
	for <linux-crypto@vger.kernel.org>; Fri, 13 Mar 2026 11:52:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	b4iHfh++NbbmWm/CPLemamwH/eRHGn5P/brlTPJIGlY=; b=iWlE0sQjPlpi7tFp
	wCmsmcnWREXWzmqlRNuwLleMKmkfL6nohvFk/ucro2udIL0WmJlZdjBMaR70o5XR
	0LcsmnWCvahhjwF1ktYqkeCsiI5VR0kaTqTdSyeZ2bRhjCna5oPpKXHOeDLUQ8Yj
	H2Yus1i99E6gkF8szoo0tEIRGxmbHMlf6OL8Pj/3/nPt5ROAenJcTTCMRxmB4JHY
	XxMIPaJsHnG623nh2Us7MKbysfwYRNcC01Rp4vbD1IDp8Bxt+mBUPpb+5fbKt+Ef
	abH033xr9YdeY53xeybT8cwtxg2EmtD5l0awDXMbT944C7mjHsmwmE0fQKCsSB27
	Z+AL4Q==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cvgj6g9nj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 13 Mar 2026 11:52:00 +0000 (GMT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-899efdcdb70so14387646d6.3
        for <linux-crypto@vger.kernel.org>; Fri, 13 Mar 2026 04:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773402719; x=1774007519; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b4iHfh++NbbmWm/CPLemamwH/eRHGn5P/brlTPJIGlY=;
        b=AsS7tSvxF2AkDMGW1US5b+HT2nv7vsbqBrl6UIFG198/e01ST2geUrmolURUlLrM27
         q/y1uGpRi+DH0WMY7nF18tlp3YeuvYWXfUOSQNvRnL0OjaWHourftdbAkzpLkUHdx5xk
         dsl4l62eQklDWOdTd19ukJheNKgDvuPz+H/yp3I+LE3b/hWmTJGPXijpDYJ1ifSbeWef
         5J3qSExzvp4AzProS0WXYtP238WKhR0aEmAgnd8HksYz19OEm/jK6q/eXxKk7YrToglU
         21B8LasvHTXPFXhX7uIdDmT0UimPWyxxH4tUOYalvdfdvASVv/QWtAK8ueL97OsnOTdZ
         WjDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773402719; x=1774007519;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b4iHfh++NbbmWm/CPLemamwH/eRHGn5P/brlTPJIGlY=;
        b=Fgo4VvRO1q7i2NcL8WzffHDaKIb7l2LIfRklFQ1Vt9gWHn7ujZG2Y/HZjoeAHYx1Ng
         QupbkOXuFr7h/Dh9V9j2parFWYHW3qFnbPW0Qzoy64fYCkt8XyXiT0FNQZwVIyJG9CM5
         yjxPZEc+w+52y9Rmwl55GXKyhaFhrxgW0/KShGFSHLTEvsH4pxH76ZdmnA/gdLLLABHL
         goGLQ8b4M0vTbIoWBag/nozPtV2DowK+8v8JeQRH/zdfC35qoX+afReHtP/IjNW8jXxb
         wdXjhkEke/SeDtkGY9iY3SE8Tf+Gz7R+Ux+RDEJ2aRdpQn7CFSSNLhrQWyNO7Ns/0Te8
         FNIQ==
X-Forwarded-Encrypted: i=1; AJvYcCVRhQHs7CEZsh+1SUPPkA2vciDhZBlsojnc6tMFnMdAZJ4OHVjiVndgIPm6cMoPGh0mlUsYclcx67KVZgs=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywke/fZtPBS0LRqLriiyrMgwCG4JUhcO64uJj7fZA1oa4yREd8m
	q+u11zngwD70oDNBCWjRcHv4rdhWS/qIX/KCIprsW730CWY/X9pd/faWRlKgPK/2vaJfCiN+RNi
	tIMW8ahyml4idqUMtdtssAAvOsvoQSW7DmaqpqgZqsg4ENZksE04TITu7NYg856sTGpY=
X-Gm-Gg: ATEYQzx0FCLbxAkH+NxkSoBwaSCOUo/zuOVOYB823EK9Sy3g1QkMfstEZPaZpwojZVB
	LB0R2rYPAw2ppb8g7Akj1YH/A5+w03VMkjrpTv9X60wXlb5CCK3LW2YxKcC8h+edm3jTLf3gttq
	/aa6bCi0qXARY2tcR6TttSZMVtqL9W1gSBKm3VsH71w/KS9WYNo6HIRQDHUn/TiV5scANwxHjNS
	yoFFTWDv25jse7tgzsn7nsUT5GF7y8p0QYA1TGn6YcITIsQG7qyeIINZ7z54TUmFL74I4noO/Y+
	pEdwFtZ/9EsWLR9DfCQXW/Qa7Fm9CO6GSdPbd9cVHr9R4ZfGJWG7ECpKktdw33XT7UNiqZYHUk7
	lmbKwj1hu8dixhQhFkhvZjcJcjURBThgirfScOVw2gAkSaQ9BCG0VnVf2FDkwC+9vw5MkT7/Lqt
	BdCXo=
X-Received: by 2002:a05:6214:809c:b0:89a:4c1b:4f6d with SMTP id 6a1803df08f44-89a81fb81e7mr32514296d6.6.1773402718953;
        Fri, 13 Mar 2026 04:51:58 -0700 (PDT)
X-Received: by 2002:a05:6214:809c:b0:89a:4c1b:4f6d with SMTP id 6a1803df08f44-89a81fb81e7mr32513816d6.6.1773402718430;
        Fri, 13 Mar 2026 04:51:58 -0700 (PDT)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b976cba6e57sm40730566b.8.2026.03.13.04.51.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Mar 2026 04:51:57 -0700 (PDT)
Message-ID: <3a80a27a-0586-41ea-957d-77fa3d023675@oss.qualcomm.com>
Date: Fri, 13 Mar 2026 12:51:53 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/11] soc: qcom: ice: Allow explicit votes on 'iface'
 clock for ICE
To: Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        cros-qcom-dts-watchers@chromium.org,
        Eric Biggers <ebiggers@google.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Jingyi Wang <jingyi.wang@oss.qualcomm.com>,
        Tengfei Fan <tengfei.fan@oss.qualcomm.com>,
        Bartosz Golaszewski <brgl@kernel.org>,
        Yuvaraj Ranganathan <quic_yrangana@quicinc.com>,
        David Wronek <davidwronek@gmail.com>,
        Luca Weiss <luca.weiss@fairphone.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Melody Olvera <quic_molvera@quicinc.com>
Cc: Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>
References: <20260310-qcom_ice_power_and_clk_vote-v2-0-b9c2a5471d9e@oss.qualcomm.com>
 <20260310-qcom_ice_power_and_clk_vote-v2-11-b9c2a5471d9e@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260310-qcom_ice_power_and_clk_vote-v2-11-b9c2a5471d9e@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEzMDA5MyBTYWx0ZWRfX36d3DZ3DcxQS
 d6JC4shYM/22OjqB068QmJ9lXfvaIZFozhUf2jYeYc4LBW1D0B+4q174ce7DMlzjfAv/pGdQDTF
 /HunY6qO01SCIiJQLJUTzmGwcLVC6h+kyHec6ezkVBhoyTHI/kbBOdeL6IedJ3bUy+o9jsz5A9S
 vmj/2wlzKidkKjQQSkSuAStlqimTEHCPnBXw4TFUpVbPOOith3rLY0zi8zNbg7FUp8DFDb4S6ME
 LzfhQS07caeZikxUP5pjSpPXmZWURFmdluc1LNA/PlKPLE7mnF4Dhq44J3ceCg3PBKxI9wI36j0
 gcQXcfNjxfueeS2NaCKPncm5y2fd7xTFpGtm3GKkKTEpfG/IE/UOg66QpA3BlAGd2TlnqyHtbra
 p8DAXmh21zSKvpoCZm0zcpW1KP02dRPJXT0hd4JYr8UY82sv9BWaqRQsa/2aJB5BaKebifyuxVN
 pLKXQ6mq6jVl9WRFUzg==
X-Proofpoint-GUID: _rPMv-3ojOamElNa14BGp76215BVgwaP
X-Proofpoint-ORIG-GUID: _rPMv-3ojOamElNa14BGp76215BVgwaP
X-Authority-Analysis: v=2.4 cv=H+vWAuYi c=1 sm=1 tr=0 ts=69b3fa60 cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=KYTvFk41Yb9jba8_3vwA:9 a=QEXdDO2ut3YA:10
 a=pJ04lnu7RYOZP9TFuWaZ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-13_02,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015 malwarescore=0
 adultscore=0 impostorscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603130093

On 3/10/26 9:06 AM, Harshal Dev wrote:
> Since Qualcomm inline-crypto engine (ICE) is now a dedicated driver
> de-coupled from the QCOM UFS driver, it explicitly votes for its required
> clocks during probe. For scenarios where the 'clk_ignore_unused' flag is
> not passed on the kernel command line, to avoid potential unclocked ICE
> hardware register access during probe the ICE driver should additionally
> vote on the 'iface' clock.
> Also update the suspend and resume callbacks to handle un-voting and voting
> on the 'iface' clock.
> 
> Fixes: 2afbf43a4aec6 ("soc: qcom: Make the Qualcomm UFS/SDCC ICE a dedicated driver")
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
> ---
>  drivers/soc/qcom/ice.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
> index b203bc685cad..e05dc7b274e0 100644
> --- a/drivers/soc/qcom/ice.c
> +++ b/drivers/soc/qcom/ice.c
> @@ -108,6 +108,7 @@ struct qcom_ice {
>  	void __iomem *base;
>  
>  	struct clk *core_clk;
> +	struct clk *iface_clk;
>  	bool use_hwkm;
>  	bool hwkm_init_complete;
>  	u8 hwkm_version;
> @@ -316,6 +317,13 @@ int qcom_ice_resume(struct qcom_ice *ice)
>  			err);
>  		return err;
>  	}
> +
> +	err = clk_prepare_enable(ice->iface_clk);
> +	if (err) {
> +		dev_err(dev, "failed to enable iface clock (%d)\n",
> +			err);

dev_err(dev, "Failed to enable 'iface' clock: %d\n", err);

(this line is very short, no need to wrap, also some nitty touch-ups)

[...]

> +	engine->iface_clk = devm_clk_get_optional_enabled(dev, "iface_clk");

Check for IS_ERR, _optional won't throw an error if it's absent,
but will if there's anything more serious that's wrong

Konrad
