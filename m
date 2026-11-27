Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795757890;
	b=kQSKpKcpuRWY5BnnXvaagZqgJy1NbGYoUSldpl604PKjuMRdBrej6aqGNXy7qbpbGpNs
	 5BaNzLeJcXzatSdOOBP84qixQ5raxFKqL4eC12YEFwMKzpMey9ORYOLJXzaKvSrcu5GqW
	 Q5Pa9IvtRdo80jcllFloCvUYzp/o/PTHIIYGRscvBmQ0FZqdvlqqJQMJPTbo6hj+XJSwu
	 oAEUijMWSdu2tBf1sMtnFq9CesxkJ3s0lNdIIqiE7Ry+Z3d07Z3u/jiyX9EmubsyfvK1u
	 ehqcsQPu9TVCn3mkgB3FiX9oQlL6n2ocLX5Y5nEbuu+nIBL8OCkeNPBE9+GbvDWeoXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795757890;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=Owb0SJ3ZfgyAlnfXWgWsY7QF3Ejq0OG9h/yNLoECbZs=;
	b=wicHzWFM/hHYFsIEBhPvy/166RriZH1yjDNnSJLy8TUqj3LW/wjd+LeSY0QAaMUJONde
	 prvmJD6iV78KO05bSavZV8C4F8P+1Jc4z8ESIVCgcP5Ucd0dTgeOXg8S6Iuk8Hb55BCa6
	 9AN8E4ZpBmc8K6VDekNc2jVeGJOieR+QolVfIW7p9vvuVyPn11zaL2AvSQHElO/C83JVk
	 WdWFvBM6racdEG4/bSlAAcmh9/dXl/9tLvApWYHrokzhHZEY8X7JanxrigI9TFceOyWZ7
	 lBrzt+H2IToBsG40rUvuELBmuGQL2eIrd/UWXIkaGJgGIRuc/cFWkSywBXiSp+1ScOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=lBaCu4fo;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=cZ+5j0s6;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E07606A324
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 05:38:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33E07606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=lBaCu4fo;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=cZ+5j0s6
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AQJwAZW3340049
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 05:38:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Owb0SJ3ZfgyAlnfXWgWsY7QF3Ejq0OG9h/yNLoECbZs=; b=lBaCu4fo6I1f0hp/
	9m0DXSBssWM1gumZcrCKWjXEhx4lFammqAoX5r5Ct6t2qWv9IvQGxqF9w1Xfp17t
	xUDN4YZCR4uz81q1x05mCTmS1BJLfO2C7Brzr0rcSh1zlmF04VKtX4eAp9gEarYj
	bqt47CE13uHX6W5bsYiXPOYTRojsS9OpyM6y7YHfUfT1VZvZWN72GFRotJBK+sxh
	zDvlqtKMtYYVh4LekXeZBVtXeYYkeOZWZtTs2deyc9oalS6j/MZ/nmC5uYcKrqc6
	Vqj2NKCFPtX88jsyFXeMqeoeaKtCmlvXPAGttztbw921f1JK/v8OdQneMeKHLE56
	G7d23A==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j6pgqjbmm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 05:38:09 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3b4b76a2b95so5255939a91.1
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 21:38:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1795757889; x=1796362689; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Owb0SJ3ZfgyAlnfXWgWsY7QF3Ejq0OG9h/yNLoECbZs=;
        b=cZ+5j0s6Bw+cijAnbD/1oQ+VmctASDRDfdwOupth/TZ+ZtGDgzgC7qvLJlbL4bNHrd
         URCKP6fuj771aHw75KYZ78J8h4uj+hCIgpLiVLIlIyxJhgxTLUpSJeWyFNWh1fA3tKB6
         EY/asbP7VinEqV0ZSsM9rHuoKfEKcHF08gFAwggoefJ23K5YlBEqAj8Ba9ZawPzmXZ2s
         /8B2P1DIcW45vyvan4YnZ1YZnuyqdxaLaQ7GybzQiH0lQvPod7AJjHsGTFBQi2gihTaS
         ZN/0sC0SMdxAO3fUA4XNmapSI/aPwF9kbSiSVWG4hitmD41cfirsMAUIn1ewceG9eM/D
         7gpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795757889; x=1796362689;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Owb0SJ3ZfgyAlnfXWgWsY7QF3Ejq0OG9h/yNLoECbZs=;
        b=d6L7njW309dX3DUVOA5TATJNeA7A4bNUf7OBIsSgbJjSCD1Q5aXdh2teRYaFG/+1a2
         viS+/YhWWxtvkgF9uOca04mN8cjkO86/u5O+rjmVABXQ3m5bnZc29mO40MUQReXyoS8/
         muSggPbsfYLJgPMVypjirvrOo1QLTfYhA+gxLv+h5DktXaT89FlMrUaw+3GpgViEoV1i
         Wi3wnc/O6U3L7mf4kbBGVpCO22iVQXH3eIZ6WQ2Hyk/Xtjzckdf9A/7cZ10ztaANTNi+
         HFtfwNC1G+YDwMHpPbtc+b2jL99kb/xim3zPRtYI4rDE0755YjIFvXFVCr8/n9fg8Hma
         zkhA==
X-Forwarded-Encrypted: i=1; AL+hErFP9WHAXqF0qGaa/zwV4GoGTD4/Yhr1L5hO6Cf2Lqw24qwD/Govg3eouuPswaFmkkgcpBFGjU+EcnNSK8k=@vger.kernel.org
X-Gm-Message-State: APuU4Z/CPqsO4YAD4dLCSm3/2Sp3plvjl4DnR3GMOX1dkDRWNZZnMnAW
	PHmjr5HT9DsyyrojFDgV0XybQsJSXreeNYkb2Ma5FV2FwEulffHpERnbGWCP3AgyP08WbK5OX5T
	TTft5bQDnNyLzUL4dbeJV77+DmlfzlOGkehD+kQPA28C941tlU7XN48Hj0o7kEMOo4vs=
X-Gm-Gg: AZFdTZe0eoumy3qB2gIbo6d+wjU4Bw4RKJxuLHB5D1g8tvFcV1EmWzTJ78WnlNfQExZ
	BZ4AKkAUqm//Qjzcv9nBzMKE71XKlfIDEUxDqqCHeCjCDYp1u1H0zhtPOpsccJWPMMvxDxKJPiN
	V1jqKpEtRLJyKY0a9N4m0mj1mcMwcINSQqqvztnRtVsEM98ZijrEgvwTbP45IPlOuAX8yk5pOa9
	7AcUdfnSsY4HfnQt6vsmsZ8KWB0OigbLFX6i5SLVzOmQiRBLWjKcI6IuOD9ymt7/lSiMtx2YmUa
	rm7Pmhh6fWcJew9u8yaKdVrFewLB5YhRY4G84/+1aWVyZEMPviqmUM65Qo4F/WES6fLsMvYSDca
	JKO8M0exuzyxCIkf2ogRVpa+17FuFExRdyolt0f8G++3D9vgUrAozE1qWxNIWpOUBzqAj4xRuJP
	ZoFNLZ
X-Received: by 2002:a17:90b:2e47:b0:3b4:a63:d56d with SMTP id 98e67ed59e1d1-3b41c7e119bmr22968531a91.1.1795757888674;
        Thu, 26 Nov 2026 21:38:08 -0800 (PST)
X-Received: by 2002:a17:90b:2e47:b0:3b4:a63:d56d with SMTP id 98e67ed59e1d1-3b41c7e119bmr22968496a91.1.1795757888236;
        Thu, 26 Nov 2026 21:38:08 -0800 (PST)
Received: from [10.218.31.125] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41adcafe0sm38855983a91.16.2026.11.26.21.38.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2026 21:38:07 -0800 (PST)
Message-ID: <ce0b6c2e-e913-4c8c-9acf-7bbd443f5fb4@oss.qualcomm.com>
Date: Fri, 27 Nov 2026 11:08:01 +0530
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] arm64: dts: qcom: shikra: Correct QCE node
 configuration
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Bartosz Golaszewski <brgl@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
References: <20261116-shikra_qce_fix-v3-0-9ae31470ef48@oss.qualcomm.com>
 <20261116-shikra_qce_fix-v3-2-9ae31470ef48@oss.qualcomm.com>
 <5cde45d9-40c3-48b8-8074-41342d0cc11e@oss.qualcomm.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <5cde45d9-40c3-48b8-8074-41342d0cc11e@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: C8lGRZ_igBj3xVJEEkeJx2hP4Grr9M-J
X-Proofpoint-ORIG-GUID: C8lGRZ_igBj3xVJEEkeJx2hP4Grr9M-J
X-Authority-Analysis: v=2.4 cv=A7H5rKWG c=1 sm=1 tr=0 ts=6b091741 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=YcclnU47V90UdgMnL5QA:9 a=QEXdDO2ut3YA:10 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI3MDAyMiBTYWx0ZWRfXxl4xvke+0O8t
 qdyDmS0/VuxCaN9MyLVpd0oTlCsQqXICZXG8ehdAtElKwyU9KMHu7zcMJKeud/qf+/XivKdOMpM
 xGlBipnIqzHcipJr4LclbvhHmR6q2J8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI3MDAyMiBTYWx0ZWRfXyWpiwWB5mw8w
 P4Ratn406fC95e8G64BKasFLl67KNchs6RvnRTfDXRftLPS1XJdR/SarMqKc5td8uW0QKGU0QnQ
 vJVXMFmXYVSLI/onhgm/c2PKxLGfHlKp3mlveCHeIZR4DRiKcs2T8p3JaIsigAoIHwf8mCL/G3Y
 /eTyiYaEX+ofOsXQXsEVrHkUz85rfvDqFcVpD8pms9dFThjvY1cHKe5oQ8mrqSHnz36sfLCQ3HG
 AGMvdzTSDQgEhkM6G91Y29e/kIT/6JSt7igQGogRf4OVooSh8x3WIlEx8oKPoSw7xms30e//sHm
 QP8MLRk0jy3QPnA/d678qJGiJDbnDOcc4r716kmfo6d3liMcT6HwYd2oN8Pb9RW83YOeIKmH7KW
 VNKtQdCAG54VP9cHDgrXrYUG8oM5tb+oVBNh0l4MSlQy1AKggRoLuRwsr1MRI3wUcUQVvCt+C12
 xEGlEAtHU96gEhY34mw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-26_05,2026-11-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 spamscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611270022

On 26-11-2026 19:46, Konrad Dybcio wrote:
> On 11/16/26 9:59 AM, Kuldeep Singh wrote:
>> Shikra QCE requires an explicit core clock, which is missing from the
>> current configuration. Adjust fallback compatible to "qcom,ipq4019-qce"
>> and specify core clock to match updated binding description.
>> The crypto interconnect path is already described by SCM node, which
>> votes for MASTER_CRYPTO_CORE0. Drop the duplicate interconnect vote from
>> the QCE node.
> 
> I understand the need for the clock, I don't quite see what we
> achieve by removing the interconnect

Yes, interconnect voting should happen and I fixed that in v4.

-- 
Regards
Kuldeep

