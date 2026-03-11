Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290E338BF9E
	for <linux-crypto@vger.kernel.org>; Wed, 11 Mar 2026 09:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773221849; cv=none; b=azKAqNje3d9J41kTPkyKLKE891o+rNDb2+InJ6j5kXl8sAFAPRWnhWVJhUwdrBxOe/yNd/rvleZIdtiiZVVc2RL7PixIBnKsPETqZP8EFJWzWy84Kvl6zK8xuWRa2s4SUTX+ShI+jKJrobXsAeV5fW1jD3EaoX0TG5vL0CtE8hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773221849; c=relaxed/simple;
	bh=pF4GQiA7jvnZgBC54j4Dfq8dPem5XQ3kKfwQVAcH4L0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZCWuDaN0HalmtvwuyaCCUSAErIbUaANMLBQV5eeYutWFz3JRAipm3k9C0uCD5ii0CfmDp9HjbgHldA3w6pDFCmJlYOjmOhhtpUQyOH28ET6mnMxSX49I+FS3+rWtSFM9f1xzUq996uwMXoRnq/uqcIp9O63Ap1lm+p5T09RCcw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=n1HQOBn/; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=AUpuQGXV; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="n1HQOBn/";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="AUpuQGXV"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62B7rGEZ508387
	for <linux-crypto@vger.kernel.org>; Wed, 11 Mar 2026 09:37:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	40tIXU7cpeWTlzqhwuIGhVm3nGVn1Y46aL7j8H2qW+M=; b=n1HQOBn/3p5qvPlC
	hmJWDPUyX+6JDUJcfuv1/caZ6Ocuz4Rt3mXIm3hKzw7neeV/PReLOTdTV/Gh9xig
	Fe5Z+imfftHAfyUskWOrfVkIBe+rM8hXtf4pt1FrQ7IEQ+sOfsjC9+QJ+yj+afxT
	+i5EHQNQxjQW2voTEOdI8IKiucoUfDpcQJvLje1QPALrg/hC6CYzWUINaQpQ/ySZ
	6okBF/1UdlHdKsEzapYkToNMIonK9ACqEpPwb/w9S2aV2HRpD9QyH+exiupGfr9C
	nxg3qncq4sxMtVr/reN3cOg/XgE5XVGTUapbEETAchdn3qqq+ankXuB3zhSDz/7Y
	dsUQuw==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ctppak6a8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 11 Mar 2026 09:37:26 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2ae4f27033cso106319835ad.3
        for <linux-crypto@vger.kernel.org>; Wed, 11 Mar 2026 02:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773221846; x=1773826646; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=40tIXU7cpeWTlzqhwuIGhVm3nGVn1Y46aL7j8H2qW+M=;
        b=AUpuQGXV4ELpjqc/y2A47UZBq/ze+5fnvie5LJEk+wNBZwoTM7Uf6cu6xkTu4OJUnP
         8T4YSOD6XGRpQSkVaqe2TQLFFOqUI6kum6FpLMovPBdiU6knjzAP72gnx2XtgsD1pRss
         w5mvDYb7J3ZJzUUcufYH55aZEkQpmP2uGy6tSwrZqUdq8xfqanHVRzr+ELiiAVstlpM3
         fL0jXaLV7Bleas3Tg3EXmlYtj0BZ4djqBEEh+Plb/k6gtqKDOJzkL6nzf0CKFZHp4mL+
         Dmh61Uor8OYD4FcAJBMUGxQZ5RS/KrytwqILaaFqnnS/xfwKc/js0RMXnVbLCWTAwt2a
         xWRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773221846; x=1773826646;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=40tIXU7cpeWTlzqhwuIGhVm3nGVn1Y46aL7j8H2qW+M=;
        b=p5eI2pkRhOLysAjGoc/TTOA9a6spraKVfzd0FYucM60jGLdLBVCP8A/4va4MlqGUOh
         h7+te/tzXpcs01TjT+8Jt9/A688YgB4GscSFMUoTanuXpREHjUTiOrXtuKmnYWhep5Ny
         p5belEwV5O6rp5Pq/a8PKK+7zyRgL3nRCUWEnNjkQRxR/IZzQ6dLwnCC2E1uWX4pQX64
         zNqt6C0liMr0hBAKRfTwCbjw3QtlIuaLftjwhZlJlLMoQQIpECLafuRpEOaXMPjct7e/
         KxfDxe27ZnePHSAq/7colN0LqOo1vRoVLxS8fAdO22MXkRQI/c9cK0xF3OcT+ZyEkDe/
         PCYA==
X-Forwarded-Encrypted: i=1; AJvYcCWawYvgk0bzgQxFYZm6XQBW8aCp/vJmcLvRXy34GT+DRzHPfrZpsKOLHBmraFuZk2mGurlx/89TyDcMok8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnQisJz+vfUILFgVZOd9PlP9W+4ydPxyg5f3Eq9+t1hUDqNvJN
	IQP3kfW68f0MygXpYp4goBqXRRRYIBx0jNgdXOgk+a7Rf0HA8O88oVne02xyPvNArO5qT7599pe
	OJBenqKoab/Q7jRkkBKLA5tFDYDeNXKwUelB/EQ+bMyrplolPbo99+I+taVtMXypfwu0=
X-Gm-Gg: ATEYQzzDb8dcJM9L4VF+6tUbRpC/3dpyu1W4o///kDhR213eNtasZX4+Q5BGIxplJMV
	d7//hoXz1v7/7RPfJicEfIU7tWLiJ+MseO/aVwI21siRJETRaVd+ikcYYA/Vwz3eUzWYkemWvPt
	4+qLX/MHVxseLubrq9VraskmXiQ0NdNgfpnUa4xnVQO9zwScqvDcyo2SJadLOlPGwC77SP3Rfit
	YwA+A2cjOJA81aYKwP/H2YR4zOs/rhb5NJzL4k1KSTkUfqD3y45WwMaaDEkpPGTilf0eOef2F9M
	CpwxsCt7Oy2Z1SQIuaf0qrtkoVOYHVIrnsLj8fIXCYFW28LiicjcFsjXxiJoLOpe2YBsVcCdOHQ
	ZtLnud1RjqdmuxBYJCCt/po0ieq6EAmruWHeK/SmHrmkyeLg3mHY=
X-Received: by 2002:a17:902:e752:b0:2ae:7fa3:df1c with SMTP id d9443c01a7336-2aeae7feba0mr19090465ad.21.1773221845824;
        Wed, 11 Mar 2026 02:37:25 -0700 (PDT)
X-Received: by 2002:a17:902:e752:b0:2ae:7fa3:df1c with SMTP id d9443c01a7336-2aeae7feba0mr19090135ad.21.1773221845295;
        Wed, 11 Mar 2026 02:37:25 -0700 (PDT)
Received: from [10.217.223.121] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aeae35f0dbsm17237595ad.69.2026.03.11.02.37.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2026 02:37:24 -0700 (PDT)
Message-ID: <a2d6c630-e4df-4cdf-8b10-64d87d24bf8f@oss.qualcomm.com>
Date: Wed, 11 Mar 2026 15:07:15 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/11] dt-bindings: crypto: qcom,ice: Allow
 power-domain and iface clk
To: Krzysztof Kozlowski <krzk@kernel.org>,
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
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
References: <20260310-qcom_ice_power_and_clk_vote-v2-0-b9c2a5471d9e@oss.qualcomm.com>
 <20260310-qcom_ice_power_and_clk_vote-v2-1-b9c2a5471d9e@oss.qualcomm.com>
 <2ac2efad-3533-490e-bb42-f21c4e950277@kernel.org>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
In-Reply-To: <2ac2efad-3533-490e-bb42-f21c4e950277@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: 27VnoRADKJKzw_6RsadoJ6ZIeplh8HfN
X-Authority-Analysis: v=2.4 cv=D7BK6/Rj c=1 sm=1 tr=0 ts=69b137d6 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=P-IC7800AAAA:8 a=EUspDBNiAAAA:8 a=e2fiLVR9xI0WNA4mEikA:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22 a=d3PnA9EDa4IxuAV0gXij:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzExMDA4MSBTYWx0ZWRfX9Bm5P5eJUkrl
 i3HUWsch29Lafet+AJtgrzqR9C/IbGHEAeNpx4kNT8DpmVxKn3uvsnpEMn3q8beSEXIJyOD+2eN
 bpx+kze0xlKYsLiX42Wx5WuSDi1hBavHJWDJjmmJGasI/K6w8J2xJzgvSQACvobUqmYhCp0b7Ek
 WWKtmpDc/vlRo+Id744pmr7WmrAp3K3lhpT3unEcQ9MTR8ckfwa5IIBEpIysfWuNNLqYgxjRFD+
 x1Wh3IeqqYIqLSszO6Rz7AJ9cOt0vI1wI6FjGYqw/9vA67r8ATnugzWeGvZIMHtcMG3+vYlKTSc
 mCxz/jbl6wYqSmXzJ77hrhWifVblRzjo2ngpzU5fSUDz/1bV/pBURYSQv++vH2CBmuqUNd+vXxz
 VUnnVrR99rwsMpKnzDhCvAEgTY6dHnwTbf+/wnuR2PALTitsaqXQFT5l2eqRDejJUJegp1CSgie
 18+JKR23/I6+tWth3QA==
X-Proofpoint-ORIG-GUID: 27VnoRADKJKzw_6RsadoJ6ZIeplh8HfN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-11_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 impostorscore=0 spamscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 adultscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603110081



On 3/11/2026 1:55 AM, Krzysztof Kozlowski wrote:
> On 10/03/2026 09:06, Harshal Dev wrote:
>> Update the inline-crypto engine DT binding to allow specifying up to two
>> clocks along with their names and associated power-domain. When the
>> 'clk_ignore_unused' flag is not passed on the kernel command line
>> occasional unclocked ICE hardware register access are observed during ICE
>> driver probe based on the relative timing between the probe and the kernel
>> disabling the unused clocks. On the other hand, when the 'pd_ignore_unused'
>> flag is not passed on the command line, clock 'stuck' issues are
>> observed if the power-domain required by ICE hardware is unused and thus
>> disabled before ICE probe. To avoid these scenarios, the 'iface' clock and
>> the associated power-domain should be specified in the ICE device tree node
>> and the 'iface' clock should be voted on by the ICE driver during probe.
>>
>> Fixes: f6ff91a47ac57 ("dt-bindings: crypto: Add Qualcomm Inline Crypto Engine")
>> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
>> ---
>>  .../bindings/crypto/qcom,inline-crypto-engine.yaml       | 16 +++++++++++++++-
>>  1 file changed, 15 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
>> index c3408dcf5d20..d9a0a8adf645 100644
>> --- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
>> +++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
>> @@ -28,6 +28,16 @@ properties:
>>      maxItems: 1
>>  
>>    clocks:
>> +    minItems: 1
>> +    maxItems: 2
>> +
>> +  clock-names:
>> +    minItems: 1
>> +    items:
>> +      - const: ice_core_clk
> 
> core

Ack. I'll introduce a check for this specific name here as well:
https://elixir.bootlin.com/linux/v7.0-rc3/source/drivers/soc/qcom/ice.c#L582

> 
>> +      - const: iface_clk
> 
> iface or bus

Ack, will call it 'iface'.

> 
> I don't understand why this is flexible and commit msg does not explain
> that. Devices do not have one and two clocks at the same time. You miss
> proper constraints.
>

I agree, it might confuse someone reading the commit message the first time.
I'll re-write the commit message to make it explicit that even though these
two properties are 'required', for the time being we are introducing 'iface'
clk and 'power-domain' as an optional property to maintain bisectability,
and that the properties would be made 'required' in a subsequent commit once
the DTS changes which are part of this patch series have reached the top tree.

Let me know if any concerns with this kind of commit message.

Regards,
Harshal
 
>> +
>> +  power-domains:
>>      maxItems: 1
> 
> 
> Best regards,
> Krzysztof

