Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B4B18D658
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 10:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774349296; cv=none; b=gX9dkHbSfhAUCoxwwRiZWM55UelyFdWyAV+NbAikZsiLGciMPyBM3lshq6ScndCMcVjUcf0Vd3w2/mndCUcBa2zMSHCHZZWL+1gMQ3yn94arWGjoLdljMg0Xusw1v0ONJkEFc7cmOtEKPXVcHG2y7X/IsraJTlR0vzdzUBlX7fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774349296; c=relaxed/simple;
	bh=9jANrywhGynZWMyKf2n6PWYNg/VaHuMRL315X+Xlo3E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YQNbBzmdil2kRwwF1hnqJig39jD8tMiFroRvznBkitpmmkGvi62BttDCYvY4SAEzgKcuCp8pE9dvGGnqlh+3F5c1m8IszuPBtZQOJf7gLxpFBkW86I1Hmvv4xsYV7lYXvO2nbgZ6lSjAFQ/EOArqt51De+bXgiU5ytraI7pEULs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ORsAYmbI; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=eTRBdWHw; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ORsAYmbI";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="eTRBdWHw"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62O6XZPU409104
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 10:48:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	c9FRDksXZJcHie1G3wv2p+BeUJQkrbEedFfbFCXtXWM=; b=ORsAYmbI2YD1uoKq
	sva6GsEUA0I1BErH8DvCmRJhaBkGlZBWR7ctc/cx+OVmFmun+i+D2G74Lvwf8c0k
	APJG8qjHIipGdXj7jHuuKuVW7rLeWPS0T+UiVbAPBwU5MH8oYLxeidh469PEh1QQ
	btMTy6GRPg8W5kB3yIcO7RM5MhyubkiWUVBlohVSXdiwro8Li0f4QZ23pj7fHJOD
	BbnERRAwTExypJsxNTjsFTrqFuEEkBwd2OkgpSbwFyq/Cg6sH94L/vt9V2Vc8GCI
	a/9WSRWHUSCRYl4epM2Qy5pe2i+/Z60rnE6dlBYucww2AydB7DmfuyZGJ6VxDJe5
	OKR6Bg==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d3nexrwqe-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 10:48:14 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2aeb90532f6so24539095ad.0
        for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 03:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774349294; x=1774954094; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c9FRDksXZJcHie1G3wv2p+BeUJQkrbEedFfbFCXtXWM=;
        b=eTRBdWHwoB23asfu6+AJoIAXAd72CK8XnMHuFeN6G0V2QssreW3JmOAn6Hr83KqXZU
         uYlaswOb+0lIYdT6OJ3Frva8uJGDcVXtUpFdQQ6j9tvDMNxqlhN+UVyXPWWNPyDhMpNC
         kLOntOBTUtI6fYzKb9T1O5eFOWSIVyWsO2bRPD1Dpv6afFhrqv6rA5ZR2J9oGYEyLcQI
         mLuMS42FusJIpj9hHdVuqjmZo+WL8rUFankgqzmocw085fri7lMozHHzAX557m3QbjHA
         MOrDV1qS2vSf3xBTDOhdXRZ7vvQcWfl1Od6a+HIXXfvinKuek/4326/qJUGJzYjZv3id
         9stA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774349294; x=1774954094;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c9FRDksXZJcHie1G3wv2p+BeUJQkrbEedFfbFCXtXWM=;
        b=MZy6wgk8CXcq+LXhDgHMXORZYrwBaUhLF9KrcX5C5X5uDakIlQ763Oz1Q1pUXHwtnd
         jEM+QnEkdzhp9Kq0D9UO7BJazxS/vJucU3hxRQ6HIC47KLMFNMdMTgiSy0b/cSFviGpH
         zgFZOuhD7gquMuQtLb8uBH67GK25XX3NLED7nL0IDs4CwE4+1/suEzZJUqQy4utPsqhV
         OHCJ/VHzwwV6nqZflx/BQIAhH4eMWgsShA9vpgr0IbzMpWWDexRR4Il0oGhJYVAJoM44
         PLj6sZyY2sEU1U2RxzQVIjOKg1D/BzjbHc2s6u+Vgf8hfofbEyrNJaVY3BFKQOCwSGFs
         JnqA==
X-Forwarded-Encrypted: i=1; AJvYcCUiqT69nIiMa5/MzLqNrm0zrnGMrN2lIJHXBKi5iClYfcbJNT7IgOyqL+ep3qCU0ppL0+3u3+bP8iqSf7g=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsfosaDObwZzal4MITYGeT+v89sXimd77ej6pE9YPB967CyuwN
	DV23Vub21aE5+orfKk6jJL5D30cy0yJ0Ivsngh1UqEm3E4Srxn0exoY44M3Pu+MYQ31hmaEnfvX
	Le8drgA08AKl4luqPXq864JdrObH3zxF3CA3LrmyE2Mg6fZAG+w0S6P/wfTVpoQUulOU=
X-Gm-Gg: ATEYQzx/CToTTnC9mNnl0zctoffVJehpt9UvaYcVRq7UayfcxMkGpIRNfceYdET4Gol
	mtpdVekMfC1pVFC5cpuzmBkmh6rawBuSnmnzrsJZggCyaXxmixTGTGB3nB2L6NgTvGKjX8Nl7yj
	x+hOERrr1bFXU9BiPZPJzDWMFBGpp3kUvylR8gHjBSMVrVo8FeGQY/Et/utSL1wtLk0q3KB6e9d
	/iqdV+QfW+Wg4m33qMhOkumxzezWUGlg3Cxxboxj7fQqHuVthL9y9v8xTpDhDjp9gCCjgz4xLcE
	nUzO3pR85UWu5og5bMKycN6ChgwNem6KDoqxtfBGnvXBY4hsIxchR8ZU2QUdkQJ9q1pkWJzdz19
	9NdKDW03Tg4tiFypp2JDuLm2LkA5Rt2FQ3jy/NOeUR55ZVU/J+u7V
X-Received: by 2002:a17:903:22c6:b0:2ae:5a55:3ded with SMTP id d9443c01a7336-2b0827f767cmr149400655ad.45.1774349293672;
        Tue, 24 Mar 2026 03:48:13 -0700 (PDT)
X-Received: by 2002:a17:903:22c6:b0:2ae:5a55:3ded with SMTP id d9443c01a7336-2b0827f767cmr149400415ad.45.1774349293190;
        Tue, 24 Mar 2026 03:48:13 -0700 (PDT)
Received: from [10.218.44.178] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b083679867sm166698485ad.65.2026.03.24.03.48.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2026 03:48:12 -0700 (PDT)
Message-ID: <63b6b7c0-92ff-45d3-9559-3ec3b3a30a1d@oss.qualcomm.com>
Date: Tue, 24 Mar 2026 16:18:02 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/11] arm64: dts: qcom: monaco: Add power-domain and
 iface clk for ice node
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
        David Wronek <davidwronek@gmail.com>,
        Luca Weiss <luca.weiss@fairphone.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Melody Olvera <quic_molvera@quicinc.com>,
        Alexander Koskovich <akoskovich@pm.me>
Cc: Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
References: <20260323-qcom_ice_power_and_clk_vote-v4-0-e36044bbdfe9@oss.qualcomm.com>
 <20260323-qcom_ice_power_and_clk_vote-v4-5-e36044bbdfe9@oss.qualcomm.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260323-qcom_ice_power_and_clk_vote-v4-5-e36044bbdfe9@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI0MDA4NiBTYWx0ZWRfXx8ZZbV1GELdp
 6u7XqSXNSmn61UGp/xcbMHiiS2OidSOho8s/RnyyJuUZuDnoDv7dfNjUdCM3CyLZwduGVgyQUFA
 q6nX5zNEgWTf+0fBwJU/xu1hA3nM0uYMeT+j6V3aVjigRaziBYjMY8HbrkXc4unO7epBTFB6SWc
 EFTMukuEIxUy3vg8OR3xHC/t9RhML98oH1Ec7M+qdn3huu8q+7hhreZh6qlWu3SwyMTJtUiVZO1
 0122kBP4ZuAkRYbgEg9UDJpJ/LO/oKH7aEnDRkcIjnnNFcEmPvNnDO1XnUwriUjRD+q304Iz7+n
 aLi2ggtC7DS3+V9HVs7xA93QtY2/AF8ERsKdzNTTvOGQVy/nNITeiDOMYDaurnOGC67SDGVg1Rq
 SkPQ7kZA1fMQUkY2u+/dcDsjuAk6cWow1iHVoyWw3O7TAK7/ap6Rw7MVgUkKcNW1JkixeIZJpEa
 LCvb+6nXMsfRvZNMyPQ==
X-Proofpoint-GUID: 2KWcfo2pU1C2TuTrlHXUdYLjZqr77Bt8
X-Proofpoint-ORIG-GUID: 2KWcfo2pU1C2TuTrlHXUdYLjZqr77Bt8
X-Authority-Analysis: v=2.4 cv=Bd/VE7t2 c=1 sm=1 tr=0 ts=69c26bee cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=RcdfdvLsBkETvr5PKcUA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-24_02,2026-03-23_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 phishscore=0 suspectscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603240086



On 3/23/2026 2:47 PM, Harshal Dev wrote:
> Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
> for its own resources. Before accessing ICE hardware during probe, to
> avoid potential unclocked register access issues (when clk_ignore_unused
> is not passed on the kernel command line), in addition to the 'core' clock
> the 'iface' clock should also be turned on by the driver. This can only be
> done if the GCC_UFS_PHY_GDSC power domain is enabled. Specify both the
> GCC_UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for
> monaco.
> 
> Fixes: cc9d29aad876d ("arm64: dts: qcom: qcs8300: enable the inline crypto engine")
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>

Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

-- 
Regards
Kuldeep

