Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9123E63A9
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 10:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774349212; cv=none; b=G9uzPw3wCv8hf/23xQi4GK/KpdJFTpTW0NnxPfabVKJdtgghmuynBLDETllpkcBB0efxqdXEEtb0rAITK9YIKdmF9hpK6tcshDOwI+Fy52eL/m2UgscS14AB+nRRQjZZb63Uh1v2wzW6NbYPNAEiQ4j7GZhjgLOV48lUWm7bLkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774349212; c=relaxed/simple;
	bh=zGCxf41ucmcI39BJMZDvVMwlgpqtPp9lWSYfUynxSOA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MgJHproeMdI8BXYIBAxp4jhL7EeboDN+RAzulSHqUjhqYjyER6nkG1zEr0kZZYjJTMuq9E46aMuKCqwzFAKJWTv9vBCml4/EM3mRrU2yLfCcs0zlTMrVotdDgW6mkKyw0fe5VX16o5HlNd6e749riJ16j9k020Ic3VYwO6UiGgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=E2AcAC+x; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=J22bjL2s; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="E2AcAC+x";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="J22bjL2s"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62OA1Mbl1761751
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 10:46:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	xlCUXbyRu6XleGl7smMiG5330ZG+N8aHkYDHhXS+3Qg=; b=E2AcAC+xVw2u7H6i
	EEcGIIk9O3FeyN4ru6dCXEcf1Op7FmCI9QWQrJdGjuk1cFcocGOFF7cM9ymMHU50
	0/aqOIgJdcg8CfxLNpbTbyhaFD327oTFNal6qMnzD03FuKCnoizEuT/mkNueTn2a
	85M2E8dAPYvMMN09J3XumtQ9bm4UzTd1l60SllQmBwWdSZLiVWWQIl0wogq5+6A9
	oJHXE19wMHveVM2Rq6199pFBtU4FXd+r46WtilwGeN+GF8TkUG5ju6mAz63sTpDh
	kRy+TxpfdtkYe3rfFCpsatweiYJnJKtOoa8HrAOqmatMp/zOAWs0bNzJi93gnI6V
	WZp7Fw==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d36f0c3hq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 10:46:47 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-829b7ed8964so3834123b3a.2
        for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 03:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774349207; x=1774954007; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xlCUXbyRu6XleGl7smMiG5330ZG+N8aHkYDHhXS+3Qg=;
        b=J22bjL2sCOwDc/E/RsYD9I3XFtnOAKPe76bK6y1I0BTCqwZHNHIMFMc9AZzrqeMzrx
         +zu+141IT96N4dXEY57kySSkBPeSwnnEYW4VhvzT2msJKbVHPMwhfz/vuHHaLN/HUiE1
         q6VEl44aUbbBERbYLEo2naLQSDP/uRU5i18c3sw2f+8OT2eUM6hb7moeisphBf5SotyA
         uK4FuKwP9uQ/WJ0gyxRI3bxGryKkeGbIle45z0Z1CLPAaKF0JbKML3Ag978LEFm5QqGt
         w0u7Y/vTS1t8FU6yEXmP3pIe2+DtnEMYjGpYR11BWhB17bl5e+516CrK0TPFOjiIw1rY
         kvaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774349207; x=1774954007;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xlCUXbyRu6XleGl7smMiG5330ZG+N8aHkYDHhXS+3Qg=;
        b=I3j4nW9IwqUjxjE0FoeKcFK5E5Q1c4sJj64IRPWxKdDNOYL1yhaL9+PWw49T51Z0iB
         Jt2+Am1MkFx59sB5C5DJNWpgbkOAp31WrygUJRs0LALLCZiPIJ2oyNwdwnPxXRyf3pzc
         pjlwFyK/VMVxKJbVzs+RfmC3zucQ0a8U9M7KaL/rLRL3VMdnE/Zii6gOkhXsKmuzvzwb
         kIC9EkjWBI53tvQiEjlsjKFFCec2XDiVRVr57rjVzBitkHrtzRQNTcjTvAlpRhs/KHYl
         dLGtglZroY+8EGsiFM7l3Ov85kfA8DMORi9+O4YYOF2JQcEbChmC3U/DJq/K6ybdxv32
         63Fw==
X-Forwarded-Encrypted: i=1; AJvYcCUI+W3Xzpu4WwOkgW/rmBdBYF0hFHHrXb9zByjjTYfSCVVSwswPZBbCpBJkb2EDbSmjy+opa+hjDaUI974=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXBlw6vYFNyakKY5zV569/6Cfu5pz3r99Brt3t6jQuNupuSZJ6
	Rmys5XtB9ozRAl9oq6mMmMkQORIdFTdjFxXMW5Rmdzf4IHkH9v1XC8HSNe2/Q3VH0+5tkNFzSCL
	FL6bF/ouAHZFMF4kbHxcH4pB+YdMTlaSB5WyKgkkhDOENXJIiQFexZNRAY+4ua/BDYks=
X-Gm-Gg: ATEYQzxxsZZO86Ae0oEj5lQZtsi+4nQl1NFkRVQGaXiTJhbiNaWYBSNLPOdHeu2f6Pt
	1/52p1gyIt8xKLOsqktm4vXNtGti+avwQIJbe8srV4sInUoFBlvY4zCI5y2wvQ6ztBmvW3EzDaM
	9Ka/OByvsyv7kJAonedPR1CdGyv/mVkhlwNyHRgqQ3jzOCU9IENVDQvfZlBq3KblwYp0FWUbAn5
	K9huKg3+OU/7EuhhjpvkceTyo9qOyAclk1Tl6IEHSS842f344//NfIB8J1+RNZX2R9MVLJL756R
	SnhV2Q2wY1Xk0vHlCEdaq3RCloKh6bsAOVRbUtq3ZGaTBm0uuCHt8BL5P3BPcRe1Fb9hYSMaLCH
	wKGwT5IsG2pXQpoq0IqPyhGN0CG8s7WE2P8VbLBtp3MJKsLDhjC7s
X-Received: by 2002:a05:6a00:4fcc:b0:81f:5238:5560 with SMTP id d2e1a72fcca58-82a8c211eeamr12266113b3a.13.1774349206712;
        Tue, 24 Mar 2026 03:46:46 -0700 (PDT)
X-Received: by 2002:a05:6a00:4fcc:b0:81f:5238:5560 with SMTP id d2e1a72fcca58-82a8c211eeamr12266082b3a.13.1774349206165;
        Tue, 24 Mar 2026 03:46:46 -0700 (PDT)
Received: from [10.218.44.178] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b0409f409sm11946398b3a.31.2026.03.24.03.46.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2026 03:46:45 -0700 (PDT)
Message-ID: <873e8ad2-50cd-4c09-9a51-20ad745fe8dc@oss.qualcomm.com>
Date: Tue, 24 Mar 2026 16:16:33 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/11] dt-bindings: crypto: qcom,ice: Fix missing
 power-domain and iface clk
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
 <20260323-qcom_ice_power_and_clk_vote-v4-1-e36044bbdfe9@oss.qualcomm.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260323-qcom_ice_power_and_clk_vote-v4-1-e36044bbdfe9@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=b+q/I9Gx c=1 sm=1 tr=0 ts=69c26b97 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=YA6uSS_--xYBq1kDVlIA:9 a=QEXdDO2ut3YA:10
 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-ORIG-GUID: lGaaQ78LAdVmR0jutvoGCZWcTuPks9gl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI0MDA4NiBTYWx0ZWRfX5fxTCnry7ga5
 Om9fEHdlQNQrRHoz39VllmqMQ/0/2iENSMQh9MyK7Gws/tgZVDlXuh7nUhknFJdWAIOgGCDOEo+
 iMB3bs6IoUDAD4phnwU7HmcAmt8yoZJSrA0gOhMfzrCuJ91ROksqJn7s7Fs5mVMOD5UDiUzhUN8
 8c44w5bb2LXVsqa3GG7aRCB+b835jZF4uCNQpUxd6jWzAYNMkzr8KPZSoU00w8HfirgiC7ZjSE6
 n5VPb0hL6yPHsoZx6IBqAE/WmfHaQCYub5wAM9aw97XJvNNzg2W4OTvCqoVK1sGALf9GxJJDi91
 taJ1DsJKHjUsVxhm2jZUj0MZwu5UaqHDJ94CScnHGf79LhrcD2xW1189U6R5t+I+peRG6SUXyUA
 yfKikBIcfgFXVekyOnhXwnZ3Xud2plCGd3eQPsBQYo/X5sZI8UYRixEZwcHD1g988EJxMLl6Nyk
 e0RjMQkBAO0288A8IGA==
X-Proofpoint-GUID: lGaaQ78LAdVmR0jutvoGCZWcTuPks9gl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-24_02,2026-03-23_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 adultscore=0
 malwarescore=0 bulkscore=0 suspectscore=0 phishscore=0 clxscore=1015
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603240086


On 3/23/2026 2:47 PM, Harshal Dev wrote:
> The DT bindings for inline-crypto engine do not specify the UFS_PHY_GDSC
> power-domain and iface clock. Without enabling the iface clock and the
> associated power-domain the ICE hardware cannot function correctly and
> leads to unclocked hardware accesses being observed during probe.
> 
> Fix the DT bindings for inline-crypto engine to require the UFS_PHY_GDSC
> power-domain and iface clock for new devices (Eliza and Milos) introduced
> in the current release (7.0) with yet-to-stabilize ABI, while preserving
> backward compatibility for older devices.
> 
> Fixes: 618195a7ac3df ("dt-bindings: crypto: qcom,inline-crypto-engine: Document the Eliza ICE")
> Fixes: 85faec1e85555 ("dt-bindings: crypto: qcom,inline-crypto-engine: document the Milos ICE")
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
> ---
>  .../bindings/crypto/qcom,inline-crypto-engine.yaml | 35 +++++++++++++++++++++-
>  1 file changed, 34 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> index 876bf90ed96e..ccb6b8dd8e11 100644
> --- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> +++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> @@ -30,6 +30,16 @@ properties:
>      maxItems: 1
>  
>    clocks:
> +    minItems: 1
> +    maxItems: 2
> +
> +  clock-names:
> +    minItems: 1
> +    items:
> +      - const: core
> +      - const: iface
> +
> +  power-domains:
>      maxItems: 1
>  
>    operating-points-v2: true
> @@ -44,6 +54,25 @@ required:
>  
>  additionalProperties: false
>  
> +allOf:
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - qcom,eliza-inline-crypto-engine
> +              - qcom,milos-inline-crypto-engine
> +
> +    then:
> +      required:
> +        - power-domains
> +        - clock-names
> +      properties:
> +        clocks:
> +          minItems: 2
> +        clock-names:
> +          minItems: 2
> +

Hi Krzysztof,

As motive here is to enforce 2 clocks for upcoming targets and keep
minItems as 1 for already merged ones for ensuring backward
compatibility. Can we do like below?

allOf:
  - if:
      not:
        properties:
          compatible:
            contains:
              enum:
                - qcom,kaanapali-inline-crypto-engine
                - qcom,qcs8300-inline-crypto-engine
                - qcom,sa8775p-inline-crypto-engine
                - qcom,sc7180-inline-crypto-engine
                - qcom,sc7280-inline-crypto-engine
                - qcom,sm8450-inline-crypto-engine
                - qcom,sm8550-inline-crypto-engine
                - qcom,sm8650-inline-crypto-engine
                - qcom,sm8750-inline-crypto-engine

    then:
      required:
        - power-domains
        - clock-names
      properties:
        clocks:
          minItems: 2
        clock-names:
          minItems: 2

This will ensure for every new target addition, default clock count is
enforced as 2 default.
Please share your thoughts as well.

-- 
Regards
Kuldeep

