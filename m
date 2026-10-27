Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793082844;
	b=rq1UkD9ze5geJxCxbAdCQbH0SUaWHK4jTasOsLiBE9j0KtnTFw1d8HjDCHdUrn9hVQSx
	 BOpzaGUpWhEkzh52LUGIey3SfkpjG/kCuO+qIL63QDezjHjEwG8Jt/uAqHPOvp/m99q/o
	 jyhoR1GdVdPIsZbRatg5KMJDhKsR8BklNp3KiKoLHphM1IZFgR7kF2ln2MktNzHDVoJZ7
	 es/+HUUI87COrS+7hbsE0nH0vZdkISf8CKOgj6bKqoR2MKV8SDeIjKONG+JU8w1eCO8jj
	 eiKjHBZBugoHw9xbBsSUScTW1zp8XnNi49kq4O+rxNFZwc8Zn7Y3kqQliMVffxb2i1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793082844;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Organization:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=ZtzWFSKtvsdQlpx1vNzzCA9A+CSSMDGzxEbgDk/QeEM=;
	b=xhTfAicR4lGq00fV5UXCjVwMGQ8cIf3X6r2kSy/tVm2XFWiCytGL31qLcrFEUe+cnJ2M
	 P0PAuxK7KtdIFOnc8iI3nviyr+rD/ukfw45loR1ZCuy8yVfkDZz+Ghkbw24vCEvFMNzVv
	 iWvd38odhwQrBIkNKm53QISW3XGYyG32ePKvByc0zr8TFVvzulnwZJWIrhAGsuPSnZNM5
	 cPVYoxm4s4fjefLNh9VhL9nm+x4t3KjbUNBWcfbxY3B4w4k2AK8Hqa+lUyoSbRRcGGZ2w
	 rsD/elORrsGpBoY7ridf+XqkJ68SuMLF4u5a7+j0hSGPBEe2zJ3YKhZ2CK/IMb4VKSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=g5m6F+dr;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Mm3BCJUM;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDBE606A31E
	for <linux-crypto@vger.kernel.org>; Tue, 27 Oct 2026 06:34:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3FDBE606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=g5m6F+dr;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Mm3BCJUM
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69R5ZKuD1850635
	for <linux-crypto@vger.kernel.org>; Tue, 27 Oct 2026 06:34:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ZtzWFSKtvsdQlpx1vNzzCA9A+CSSMDGzxEbgDk/QeEM=; b=g5m6F+drEHQbgNHy
	PdD/eoai3n3Zr7ZOTf5sb5iN1PqIXksIwhCzg3Xtya0lrXb19GZlI9NCAWnF1fyl
	+id/BU9W+R6wI+DU1TKG6jPyLN4hT8hXezSFPvHnHDOarSjzJ3BgwaIA03spEyD6
	bQlXNZomSGWrXBqzgprMSqfVqkgg/xYYuVG3AVuFNQoPH18AfAPUN706bNIsfYmG
	lvhg005Lf9NLbMqvSWx3dKSr+pD67iQREJtf0eRjYygaC7PXWqE9IvckZYyJq3s9
	q0pterFffdOCDi/onRvaZUAJtm3oNg2kys9UezdXJWV2b3Pwv2Cl5vQCPK03Ep1O
	wJ34zA==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hj4sf43yp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 27 Oct 2026 06:34:03 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3abfcf726dcso5644781a91.2
        for <linux-crypto@vger.kernel.org>; Mon, 26 Oct 2026 23:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793082842; x=1793687642; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :from:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ZtzWFSKtvsdQlpx1vNzzCA9A+CSSMDGzxEbgDk/QeEM=;
        b=Mm3BCJUMtzIz/7AEdB86oiDIG+ymZlln4Q+zgLFFa9nD/LPQJFfNf1FeByLYbv1cmm
         hfQP3UHgiDQZ+G1RMVomfpkTMo0VcWPxpWKpJfrt0McTcHZp+v54Apjedv9ReU3sRtzd
         VpuB6G5hNozt9Kkne6EO7zSN4kl8RkRGnQYDDdja0uMSxGwGxAei1TcFxoCAxWRR74TY
         /ZUFSGXw3wCqzuXhSPEnj5QhEiyiC/BUAo8feNYrRBbYpxBM6a59JRYCjf+ojBIdbmZq
         hWiMVHktZYOkwX1syED7E8lNunbPJtuD0fqIMgQ9AfmqUkkZdcLoCVrRYlwgjf5Ao8iB
         zSSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793082842; x=1793687642;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :from:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ZtzWFSKtvsdQlpx1vNzzCA9A+CSSMDGzxEbgDk/QeEM=;
        b=hxpSg8o3GOChIJtO7P0W3utlF4vHQtNuRPUr+vxePFwOeV6Vr4YHaS+XSCps8bhZ9O
         f1WwHIq/VkWuZuo/kkuR6tSUNRnhuSPNwUi2aLMD5TMm2yZ5hPpPO5PK7TQf6KJooIcU
         0t60p9ngi46YbO8QP+WTGnqPza7BnWbdDJu4Hzovi+sxxh0hQC7XaVA1CwzpOyKdQN7Y
         kYJnkFpmdfbY1SHNexIAK0M0lunU6zPvUE+uYTgobShnPJqmrMgfk6alPqTMUMQetl9k
         8IdC/wjLLA50q4k8p2leUk00x+IoVYkzlmPfSWw93uFqE7+D3tNvxOrZdpDH5R/1QTDY
         0s6w==
X-Forwarded-Encrypted: i=1; AKwUvBxuAJs+ExmpTqgY8JzVNxphtBG+y8BEUA2Ztb53QJcmepUpNXweLPp/3Lzv1b7RYnwh19hd4LOQobREifI=@vger.kernel.org
X-Gm-Message-State: AFq9FYLfztuh/rBXm/PFrEwQHti4Y09DmJHJH150ITQZ2C+1kNPef/eG
	/6rpW1Yxh3mlUaSuv02V8VRPJVTUiUAB8m5fVrtmQZj4IqfnucxtqgqFTW8UQamw1mfDu021hHo
	IY3f7GBfnofE9sI9DiVCqTAjj0pMvBhBUeCEO27PpLk9gY97LsrJtSLdpHV8s7uRnFXM=
X-Gm-Gg: AYBFou01G1cnW0bl20KOTT1mkXLfac2wx3+5x3dKBLAne58WV2rE+5NR24APWM7/+Ac
	eOHuJilXyytBdgiETe/zrRS0UyAe8+Bi3RVT6JCGe5tvKzYWf45AsaRsHTaWykMbnxh9GWq4lZn
	JG+C5PdkFMPOKKzAH1J1wPU8rTFqKZLvuMmtgv2jyOKWCZuw9m4vwwmjbOzhBCW8qGwqOPGBDwf
	hXM6N+HuCNUsFjCdp4ggdG2xXRUQwnbuvtvgtB2KR+RLTLtZQeRC7dkWr9iByo5jvp8NWC3BeoQ
	mfnuav1OEkBancMinN4I+u+5IAs2/7D/38sYRlYBmqV/HWqDqddFv6OtpeMacHIV6RGh6rDLxdF
	RVl2/X7vhZuR3nxCTKpGsDUNfnw==
X-Received: by 2002:a17:90b:3803:b0:3ac:a204:aa27 with SMTP id 98e67ed59e1d1-3adeb101a2dmr7179863a91.66.1793082841940;
        Mon, 26 Oct 2026 23:34:01 -0700 (PDT)
X-Received: by 2002:a17:90b:3803:b0:3ac:a204:aa27 with SMTP id 98e67ed59e1d1-3adeb101a2dmr7179851a91.66.1793082841527;
        Mon, 26 Oct 2026 23:34:01 -0700 (PDT)
Received: from [10.218.26.96] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae404274b2sm2238992a91.5.2026.10.26.23.33.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2026 23:34:01 -0700 (PDT)
Message-ID: <236471c7-cf05-4019-a590-b803fc471484@oss.qualcomm.com>
Date: Tue, 27 Oct 2026 12:03:55 +0530
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
Subject: Re: [PATCH 0/5] Add support for a TEE agnostic Inline Crypto Engine
 service
To: Eric Biggers <ebiggers@kernel.org>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        Sumit Garg <sumit.garg@oss.qualcomm.com>,
        Selvam Sathappan Periakaruppan <selvam.periakaruppan@oss.qualcomm.com>,
        Basant Kumar <basantk@qti.qualcomm.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20261021-ice-migrate-tee-svc-v1-0-b035be7aab0a@oss.qualcomm.com>
 <20261024185602.GF2553@quark>
 <b5cc804e-0f73-4ec9-88bf-ef6dd04eea83@oss.qualcomm.com>
 <20261025171903.GA2212@quark>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Organization: Qualcomm
In-Reply-To: <20261025171903.GA2212@quark>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI3MDAyNSBTYWx0ZWRfX2g1oKmHEVPGg
 +vLI1dYoqcpdX6yxP8Nkuogwuq+vNbBSg+FaghpaDGuVS/7JOXYqlYApjZRJQhhjA0h22RQIJkF
 dSolgDWC7mkje2RgwR+5P4rzMXYA6xs=
X-Authority-Analysis: v=2.4 cv=ZOdCCn7b c=1 sm=1 tr=0 ts=6ae045db cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=_ITZaPDcee3h4uv5GAYA:9 a=QEXdDO2ut3YA:10 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-GUID: WFpSwnq_0brpohDgfeVo1Ucww5_74P6Q
X-Proofpoint-ORIG-GUID: WFpSwnq_0brpohDgfeVo1Ucww5_74P6Q
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI3MDAyNSBTYWx0ZWRfXynrxbhXCXnOf
 iK5Z/bIxmyiUi7JVkezw2SEmt1+pojen17E5/h62f9KbMZBV6hqepJxy/IdbTzvKAvwEaPD3ZiS
 0s3pl0gOHkLafbX8wj+L9GlzfneO90EGRWA9VKCVDtqm+R46+VkVzAEK8Uin7SxQJ0uzqQgM7m4
 M62PHGtan0Q05SZdjtxoIgEWQdQzJIV3Ti+wiGNP3ueIswo6uhWTX69i8AKjxVMcE+01YYhnXRJ
 DAtBM9/VbDSemIt+ZL60+iDc+igt5HpZXMcJ6yf/AFlulMqSxPxZdYiCmskjWYsRkK7HEDov90S
 y9dMWuhz5gS4LTv3tLEDDcO9tqMZJWBll9BdtSF9k/ZQ7JFx2N4V9kQcVeP8E9cfSLQlqOu2Wn2
 dVTlTJTmczqbN2S5CWFkJ+lnkSsSsoMs2cIWa8kGbqBLtxw90NKGgFiUI5RiAWlGVD3aSEIXtmV
 JGqjLRiQVJZEc5+FhaQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-27_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 adultscore=0 spamscore=0 bulkscore=0 impostorscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610270025

On 25-10-2026 10:49 pm, Eric Biggers wrote:
> On Sun, Oct 25, 2026 at 10:16:49PM +0530, Harshal Dev wrote:
>> By moving the TEE call re-direction to a separate middleware we are ensuring
>> that we only touch the 9-10 lines in the driver which depend on the TEE firmware.
>> Merging this functionality in the ICE driver would substantially increases
>> the total file size.
> 
> Again, it would be simpler to handle it directly in the existing
> qcom_ice module.  Yes, there will then be more code in that module, but
> then the new single-user middleware module wouldn't be needed.
>

Sure Eric, I don't have any deep preferences here. I will move the middleware
to the ICE driver itself.

Ack.

Regards,
Harshal 
> - Eric

