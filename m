Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB2F36215E
	for <linux-crypto@vger.kernel.org>; Fri,  8 May 2026 14:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778251314; cv=none; b=d2UghAmI9C47g4ZV2qjVZkvTsS2hPtk7xxqkeAKY0IrVWnYyVpoKFwBSJGNCc5Kd3VV/2Eu9unqKypRq9YwbFhClwUY55C5/Km+k3WXnikV+JID4I7x8NJ/COF9iWfrAXyUlxACO6gKk0EJzklMWJ3HP+4wrKP9BGXjAi/pnS84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778251314; c=relaxed/simple;
	bh=pr96u8fpX27t/b9mvJO/e3weEQIF9Gqfw+8cGBAORNY=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=nNANxhGfRyFFgHfZABqW2eNiUoHc62ClLD/CMeqVs54l5Rimb4zjvyxho7FH9FQ7oOACfTPJIecoB0OVoKlFlItHKANWuWDwUOoycIrB5cIoEPpKg+L+HWK+NxrVTihC9RKUpmAXF4129xwMLLAbWOW9s+wa1Cl7aJFZAbdV7m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=RGkdlTJw; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=NQ0KEhOg; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="RGkdlTJw";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="NQ0KEhOg"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 648BABLZ2778219
	for <linux-crypto@vger.kernel.org>; Fri, 8 May 2026 14:41:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	wIVVKibPHGx2DZJ1/yR4RDqxK0+CG0k31mIdHaLooRE=; b=RGkdlTJw6nwQwk2N
	1L1ixZMmBw/Mi1FGQ+YdLhNLYgz0OnG7tcromWyV5cIBu4VxeO2vHJGMOXGHzjbJ
	/FtkYtFcoidwWmlQ6KcOBKrd80UpwZWdWJ2uApl18wLFZWRylv6jZEmN97aPTe1M
	qjSJWXn5W3KGa8XqexlxXBc+nJAUZxNly51f+VyJqUVSNMYrEK3Tn8COLZHj1HPt
	0SqDSguMxsYiKWLNltkTOL9njUESG+YIMY8PZEaWVIIM8kZu/oycoGFvsK53UC/a
	dpEVVwTWiGEqWHJYa387u7HA9bP1P4rgVSl7uIyDVUXSHhlC18tFmmlYMD9wn36I
	qL5Xng==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e1285kqc7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 08 May 2026 14:41:52 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-366122e01fcso2253499a91.2
        for <linux-crypto@vger.kernel.org>; Fri, 08 May 2026 07:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778251311; x=1778856111; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wIVVKibPHGx2DZJ1/yR4RDqxK0+CG0k31mIdHaLooRE=;
        b=NQ0KEhOgTZDSXyqwQ8jENoigrzrYI+b8JTW7I4qNhgvAD1CTRQ6rgHb4PfqUYrJyLu
         YuY08pAZvjI8WD6NIzmmenU8ODB1WErBVuaP15nSFJ6AVmqVJqxuSKgA2t1McUd4y+WK
         S208SMJUFdbC6ge/3kbZWq+6XgTCU5CjN7NtLMJvc6LsAXwg1YMSn9tDGyZdtlYSCZv0
         YwzXTfhs4gx/66aqq0PJf94Oo8DAnS1QHLa19LTuic3VfcSHvpgq1AHxsnHtEty6zKn7
         ScXnwvX3uKMUzn7Hu62nf54V5EhFQpk+M8OjwKInKCX9F/tc9YX6R9BNWe3g0a4wyvqW
         H1+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778251311; x=1778856111;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wIVVKibPHGx2DZJ1/yR4RDqxK0+CG0k31mIdHaLooRE=;
        b=e4zVLERkQ7bv6fC49+P3Mexw45ZjUUhXAgY6JH6wsyOv0Zrcr8uqoZ5o30JpHmGuQe
         079pOl/Sy2xVNdz2bSgJ8J9Ug3Nz/L67IznopY5HRoYXZl8vdohmFe3ea/3++v5hKUJs
         lJ3JwPnC3iledw3oUjBo5oNhekV8DYkQDs2TFRCo+bUUEDk2CG2HVnKSDOw16GXy40kY
         NECc/R7PJilDJpuKaDDDXE0+ktTvlUoeogMUo/W4J905KWmaOphhrkbdJW7w3660Qsnv
         S+5iChPWlzsU8yi8o1g0voeTN3Hruhv0P4U1fl5KOqZIz7s2I4bOnj7ayXtKb2ny0DqV
         /UbQ==
X-Forwarded-Encrypted: i=1; AFNElJ8iwpcrPkoIZN+j+JeBE0JIQDzZNah1A/4EEoTmmti3zuWbIzlHC+Y2tN7K3JOqLezzxwKF70LkBplRVkA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+X97PhIZtyDAdqzUT0EvzFsFFTiNs/ec2nYBMtIkjXfbklVlT
	NrJIL/uIbDPhnEp6aOebB6HCk1ZllhHwFp9NuQT+TaExQFcLUcGemdFUqWl8j4KIxHdr4QvliD0
	RZs4WRc2LliPLQC22cIyyU/9vjcGL8/rBh+sHCKwYwC+rENvTlu7Lt1TNVcgUTNSuEtg=
X-Gm-Gg: Acq92OE8u7pHf1hEA6wbHolYvT/wGW3TroRUjQuBVaZLOZ7xMDlbnV5lW4xLUHwD6rP
	hSuwI3fFOk5gr+Dbk6vBVHiNEoHgtsdQkaeIcl/Gl3CzXEEX28GBM+7remTVnze+CdvzQBK1JkP
	LmOUJ3I860MOt/eJwMHqs55fi40kgjdclYSrKloHanGApGnDLIVl7irjNHMkBzkiSPD9NkWn0zc
	b659zdh1aYnzFyEb99tg0l2kYorDli967v/NKjVNvamtmNMBxYLycvoQyIh2REzEbzPwO8rg15E
	/G7MBAiJvAWkTCCKzcHUvKgVdcvv2t83/oZdxtsIbxFIgRIwofxnJK6KZvOUmIPWU+fOI7Zi06O
	vZZm23ACJIxtixU5Tv6boSIUgZ0xBVuiV/iW67OQQcRoPCpo=
X-Received: by 2002:a17:90b:164d:b0:366:346a:6891 with SMTP id 98e67ed59e1d1-366346a6cf8mr5460379a91.16.1778251311181;
        Fri, 08 May 2026 07:41:51 -0700 (PDT)
X-Received: by 2002:a17:90b:164d:b0:366:346a:6891 with SMTP id 98e67ed59e1d1-366346a6cf8mr5460312a91.16.1778251310566;
        Fri, 08 May 2026 07:41:50 -0700 (PDT)
Received: from ehlo.thunderbird.net ([2409:40f0:1188:45b6:d004:fdff:fedc:161b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-367be8be938sm109356a91.4.2026.05.08.07.41.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 May 2026 07:41:50 -0700 (PDT)
Date: Fri, 08 May 2026 20:11:45 +0530
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
To: Bjorn Andersson <andersson@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
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
        Abel Vesa <abelvesa@kernel.org>, Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v5_01/13=5D_dt-bindings=3A_crypto=3A_qco?=
 =?US-ASCII?Q?m=2Cice=3A_Fix_missing_power-domain_and_iface_clk?=
User-Agent: Thunderbird for Android
In-Reply-To: <b8805117-d54f-4e42-a7d4-6fa18af63e69@oss.qualcomm.com>
References: <20260416-qcom_ice_power_and_clk_vote-v5-0-5ccf5d7e2846@oss.qualcomm.com> <20260416-qcom_ice_power_and_clk_vote-v5-1-5ccf5d7e2846@oss.qualcomm.com> <afmuncmBrrvddHTU@gondor.apana.org.au> <b8805117-d54f-4e42-a7d4-6fa18af63e69@oss.qualcomm.com>
Message-ID: <CC0E438D-5544-4BB8-8512-7F93A7FA4DC1@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA4MDE1MCBTYWx0ZWRfXyx54FpeTdtfT
 5zvkX7Q+jtae0R5+1hj2FXlbjJhiF3ZmpT2phB9eUxjTAwRaNXzgYrADeLUjerpLnCn0UG4sCrc
 8oNZDff+Md5m/AVZkZliVWyyBNVa8hN5eyJMHNXnbRGNg9W1VrQict8DEkGc9N6hvaUhQhhocRS
 WQBeHqA0j2g9cSWE0tW+gThPo0yP+SRFO7Zttq4b9Cov6nYajjIjkQIzOxB8QoEMNN7GvV911ym
 6UWX3ItKOmazPJpWXrVXt8tYlI1qzq79YzZYzbroTuOwxvU0DC8rQyr2J/cEMhbpCyQZqQ4fGK+
 QjwVa/EDaTiRdxNCwV3FAbHQJ57nQeZaA7jm47r4PATHFIRWbzA0vM5FuihkpINTUzWlqrwRDGG
 ruPUr3e/xA385OP/4pTIut3PYFvBLWVqr+iiMseswouGgEwNH8dTmKfYuXN8UReSJx5tGp/yP8Y
 SFDfEk2alb0q1E7Y13w==
X-Proofpoint-GUID: foXOeIQI-MEyF89q4GzhIT9d1ogHAmVZ
X-Proofpoint-ORIG-GUID: foXOeIQI-MEyF89q4GzhIT9d1ogHAmVZ
X-Authority-Analysis: v=2.4 cv=NKblPU6g c=1 sm=1 tr=0 ts=69fdf630 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=puQWGBksFvoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=5CtyM_Wnw1_u-mjX28QA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-07_02,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 spamscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 suspectscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2605080150

Hi Herbert,=20

On 7 May 2026 3:50:21 pm IST, Harshal Dev <harshal=2Edev@oss=2Equalcomm=2E=
com> wrote:
>Hi Bjorn,
>
>On 5/5/2026 2:17 PM, Herbert Xu wrote:
>> On Thu, Apr 16, 2026 at 05:29:18PM +0530, Harshal Dev wrote:
>>> The DT bindings for inline-crypto engine do not specify the UFS_PHY_GD=
SC
>>> power-domain and iface clock=2E Without enabling the iface clock and t=
he
>>> associated power-domain the ICE hardware cannot function correctly and
>>> leads to unclocked hardware accesses being observed during probe=2E
>>>
>>> Fix the DT bindings for inline-crypto engine to require the UFS_PHY_GD=
SC
>>> power-domain and iface clock for new devices (Eliza and Milos) introdu=
ced
>>> in the current release (7=2E1) with yet-to-stabilize ABI, while preser=
ving
>>> backward compatibility for older devices=2E
>>>
>>> Fixes: 618195a7ac3df ("dt-bindings: crypto: qcom,inline-crypto-engine:=
 Document the Eliza ICE")
>>> Fixes: 85faec1e85555 ("dt-bindings: crypto: qcom,inline-crypto-engine:=
 document the Milos ICE")
>>> Reviewed-by: Kuldeep Singh <kuldeep=2Esingh@oss=2Equalcomm=2Ecom>
>>> Reviewed-by: Krzysztof Kozlowski <krzysztof=2Ekozlowski@oss=2Equalcomm=
=2Ecom>
>>> Signed-off-by: Harshal Dev <harshal=2Edev@oss=2Equalcomm=2Ecom>
>>> ---
>>>  =2E=2E=2E/bindings/crypto/qcom,inline-crypto-engine=2Eyaml | 35 +++++=
++++++++++++++++-
>>>  1 file changed, 34 insertions(+), 1 deletion(-)
>>=20
>> Patch applied=2E  Thanks=2E
>
>Herbert has pulled out of picking this patch from his tree=2E
>As discussed, since this DT binding update relies on DTS changes in commi=
ts 12 and 13
>of these series, they should all go through the same tree=2E
>
>Can we aim to pick this series via the qcom-soc tree to ensure the bindin=
g and DTS changes
>are applied together? Since the 7=2E1 fixes window is open, I am hoping f=
or this to be
>picked up this week or the next=2E
>

Can you please confirm for Bjorn once
that you're not picking this up and he
can pick it from his tree?=20

Many thanks,=20
Harshal

>Regards,
>Harshal
>
