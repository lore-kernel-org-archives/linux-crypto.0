Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E752E03E4
	for <linux-crypto@vger.kernel.org>; Tue, 21 Apr 2026 09:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776763688; cv=none; b=mMWxTQbVZyaZIBwvQevK02MmXKNWH4xHp8+bROrp4wb0/ef1hYiy0i6W9hLYX/efkrwIeokAq3Vyb1hZuMHRQ2NXwu2LRvp4cvirDJDFEkoITmH3og45JCwBg/I7rW5+t9ZI73TrnsdLoJCSfL8eGwmqsj7mmAJYEeW86PCu0E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776763688; c=relaxed/simple;
	bh=ZNfISKpSCjCGscK8/Ib7YAmiEv+e/c+WMOCf3R0g/PI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dTPt9/PYECj7LhgLnWyqiXBtbW+YWIiPi4UUAlT22TpoW94shm1ouCBcqjH9AK6W0GmD4wVTOJOREaK5CYDt89qXMaTgOVETbfRCa+0RdLIGkfd9x0H0zXPvcl2Wi/pb/vdp01TfXQeneTZX8GwkFwJ8eRWIE1vlPUD367pB9/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JSqRt6Zx; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YJJhwMiN; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JSqRt6Zx";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YJJhwMiN"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63L8Cg9A2281666
	for <linux-crypto@vger.kernel.org>; Tue, 21 Apr 2026 09:28:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	XG0WfbWW1KDOp5vpDhXYtbdAi1HkcHqFYHF/2b8RrvE=; b=JSqRt6Zx2TClGGPY
	pZEMExS6VcQRHcHEpVMr/j0SPz/WC8Xi9eciiwDm0NptLMro2QP9hPghccAbaeEB
	zEXir5DaIo5+ifXjHJexGJLSHcmYAQ3S1YLvce7BdYigOgDPtSBsNmGZO4JNGpO/
	Zd53XcYEdtuNerSMa10xiMW1BjjwLaRydqfVgkBhYr4wGUHzpn/IqxCprRSZBIlw
	DuXxXi2Xtsm/ZKzo5NGT7hXKS5/lQYyCTDwPvDELq4PDTi2K9aK2eN77FM+6Co6t
	ohQiTqvqlocMYHOhbPccrM0TgtJenAI2+Rucws+eBJQTLSapeCMHN8oJ+ugCe+xF
	ZBjVmA==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dnh59ctuc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 21 Apr 2026 09:28:06 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-35fbb5779e8so4564985a91.3
        for <linux-crypto@vger.kernel.org>; Tue, 21 Apr 2026 02:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776763684; x=1777368484; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XG0WfbWW1KDOp5vpDhXYtbdAi1HkcHqFYHF/2b8RrvE=;
        b=YJJhwMiNhB00860yBSygbabpBN731bckynniNwSvQdgrG47616tAyQGxDNNMGnd+/X
         yfz52Bv7JOraGzXfloqzWSbjoPdewPa0j3pTQ3RDuaMcQmHMRnZ8DAf53bySG4Z+cDOO
         X1hKiscjVV2EGH2LV61Gbfeb0TgLqFa01FBPO/gaEJnq5YZW1W/PpTB0JwGtovdm+Jq+
         TpYPzPaGNAQBQ4HCYcYfitHiKgrWR4ahzIQh7lHWQ5+wjuEhvS8Cg4V7kyVro0DaAZOK
         E0PwNYUr2kuFD/0dBKgvSAYIYHPSCy5JvFyDIVHb5ZvYHKiki+PKmVBZtk7rilyzE2y9
         MA5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776763684; x=1777368484;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XG0WfbWW1KDOp5vpDhXYtbdAi1HkcHqFYHF/2b8RrvE=;
        b=PHJQU75ATnuQF50whA3yuioxjBJG8PoFlS+zHKxG1bosRnXlCQnCCPj7BbvLQ79RIU
         IA9dSgO+ktejNGhpFGRV8dOJCLo1y3OyvOvkRuhR8WzSipod+pziQqtAyDW/Gl2KDRIE
         NC9XKPii2LB7Twgy1RltQ/D+ETVnJG/2PD68Lrexl80oK6BtWuqyRGVOw9vRhjWMZcYy
         demOK2BjLxs9/e+wvC19+5DH+f6T8MSG4a174wWs91BjTA3Ethr4c1Ujmy5HW/ojnDig
         a7JHooYMsdxNfdDidkLr9oK3M+kszzwCfmmP+ytx7jof67vmcTh2IpPsd2+oqDqK/osy
         gJhg==
X-Forwarded-Encrypted: i=1; AFNElJ8sOIJuDrJJXLz9c62bCn2q14Ux+BbO+6iNbGgktNpEHAhznV7Tf/bqmmfArkXkyJ9nVsaGQInpdxNxv6Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YxR2J9bymC+b3cM9bn/Y+8nzvSduilxU+IeQ/H34aBDtmaiHOF/
	Lb8sB8rBIdXAVSTprmoIQ7qbAXNd+mVEiZf842LGhN7m2xO4ZN1AN3W1N1OUbBhfOod7626/HSo
	BUwxb0Fo+uI2XpyIEqVtf59enqnuqJ3hB7KY+PukZFbSlzmxxxqDIWvrIC+ReqEueGkI=
X-Gm-Gg: AeBDietR+m6oZWcF7cEURzT1K2P8la+esGhtE30Lon/suG1AAuj2a4YJcjV130VRawl
	MeXmjSlvl9E19kaf7wfGQL2HKCnOXStNQzIJ1p9VzHHuAAkXGqw4MpuMG6ho4X4WVyiNMuMCqwc
	IHNu/eN0+4TT6bfkD9xZ+LZ0TBqduKGRMVD9WUJ0cpzkr4Jzydm6v7uryuku4NoDShVZdMqfoO6
	QL+Ozod9fxZwluOejbky/e6eK9vuqYzE6Q6ji8VUqcmMKQD8GIHNix2bnO9NjoyOHml1JAiJECV
	IzwloGCROpsU42r2x5EZUoHHwNdyXmkPI83zTzUxJKrZNs6Hha6zOgjWK/zSGk8WwXdYs31/VXY
	po0swefv03eN4RrR0XL/asBjkMfsBheChvHLXavkGLafmm3c5KWCJshN3dwnrahA=
X-Received: by 2002:a17:90b:394e:b0:359:d54:846f with SMTP id 98e67ed59e1d1-361403f10f9mr16859872a91.7.1776763684512;
        Tue, 21 Apr 2026 02:28:04 -0700 (PDT)
X-Received: by 2002:a17:90b:394e:b0:359:d54:846f with SMTP id 98e67ed59e1d1-361403f10f9mr16859847a91.7.1776763684031;
        Tue, 21 Apr 2026 02:28:04 -0700 (PDT)
Received: from [10.218.21.127] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3614198f775sm15294860a91.16.2026.04.21.02.27.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 02:28:03 -0700 (PDT)
Message-ID: <743ae20d-1894-4566-992f-db8dccebee9f@oss.qualcomm.com>
Date: Tue, 21 Apr 2026 14:57:52 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 12/13] arm64: dts: qcom: milos: Add power-domain and
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
        Alexander Koskovich <akoskovich@pm.me>,
        Abel Vesa <abelvesa@kernel.org>
Cc: Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
References: <20260416-qcom_ice_power_and_clk_vote-v5-0-5ccf5d7e2846@oss.qualcomm.com>
 <20260416-qcom_ice_power_and_clk_vote-v5-12-5ccf5d7e2846@oss.qualcomm.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260416-qcom_ice_power_and_clk_vote-v5-12-5ccf5d7e2846@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: JWlugNOxwd4FFcP853OqQnMJruEiig5e
X-Proofpoint-GUID: JWlugNOxwd4FFcP853OqQnMJruEiig5e
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIxMDA5MSBTYWx0ZWRfXzd/gbmEKVLeY
 YGJC8Vl4qoJJ+HTa+NUCcQnGI9pOD6ts90XncpEz7qWqmbsdA0Tw0rgZys6xfTSkiskCl8VJnPO
 pw3U1xsr9c0ui4DC4/8NKSuhWS/QgIGEMOQhKCmgo3NzZO2auJJi+3E3Yt+PH8cI5RNhsbTx1MZ
 V1MND/XPSPewCplo0FlEXNmtmm3K4GXjCYRyH1Ol1gyK+MKjGjpE0nX1PzJkawrwk8I2Q4GjiqU
 jdzHT9sL84RS5pFrInH2y62jBH6Xt4PxiGBWrPuwG4YmloLWSB582pfqEQB5NsiDz3XcJFQng46
 E182MCw5tYvfRYzzz6lLeQoEUJTHtqgnTc6XFDr6c7kPu36X9+KgcrIZYomVyH5qU1wkualvYRr
 xxsMKUpZ7TJ6zdIFuzFjp3NRXzR6RKhAC0t0hkz19VFYotqOOw6NH7cP3h/YkwTkH0w9UurNrpm
 vN7YakkLVbdfwIORMFg==
X-Authority-Analysis: v=2.4 cv=HNrz0Itv c=1 sm=1 tr=0 ts=69e74326 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=RcdfdvLsBkETvr5PKcUA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-21_01,2026-04-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 adultscore=0 spamscore=0 phishscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604210091

On 16-04-2026 17:29, Harshal Dev wrote:
> Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
> for its own resources. Before accessing ICE hardware during probe, to
> avoid potential unclocked register access issues (when clk_ignore_unused
> is not passed on the kernel command line), in addition to the 'core' clock
> the 'iface' clock should also be turned on by the driver. This can only be
> done if the UFS_PHY_GDSC power domain is enabled. Specify both the
> UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for milos.
> 
> Fixes: 04bb37433330e ("arm64: dts: qcom: milos: Add UFS nodes")
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>

Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

-- 
Regards
Kuldeep

