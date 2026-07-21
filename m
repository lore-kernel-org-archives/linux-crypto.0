Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB9B44BCB8
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 09:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784627635; cv=none; b=jtQZcbtWUqoxg/vTjXpUym30/VGJXoLI5SB37eOSlNTwAGrDlNH9HIiPD0fr4C4p8LtY98/n6pSCQFoJWNqTNR38TZTRNMXb+oSqJRFFF6q/IZOmYzFXoOq/cdq4V9XnfDEqzyNJbxTX+8cro1It2+9j6aYhDA5THZnUENgAff8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784627635; c=relaxed/simple;
	bh=xpzUbnGjh193lSfK5gZx7kc2XQNv6ufxKPlViYFddTk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QlWlGUl3lPcGF8fx+hPJJ2TB+VCyDOm88kfdHvfHmBwQqvV2GzujcHEO0FB+l6ZWFdhPFDUhsgZi8gkcGSxVvP//vTK3un0O1FK4d528lg59V1gfEql868OO6L1rV7rBoLnyjSqp7suh/DOEqXFF/uTEygkOJRHVNTQQgFSa/Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YtoeMv+u; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Vuc41xZP; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YtoeMv+u";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Vuc41xZP"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66L6fvdf3884328
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 09:53:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	+FZiGElwaCSWHzg5ui6ymy+kLbXQLZQh4fC1+Jp3SCw=; b=YtoeMv+utaxW1Piw
	DPld3BYgCFVJL5zGsD/3NdKhdR208McBGn6bgVxteZ/rs4KYnjLdxlKeucEH/Sda
	H8P9eE2LTTLXzs90eWj0KXa4vKWQH48o/YtGXMtCF8GTsiY2ZlR/U5GhFmfK89c+
	v66UtVOQpDQtbMP0wPGdJ83bG9gjawF7uBfL3O3dW6r0Y+KbVbCsEdBrXk3PUJjN
	ow4oLm1Bhstl7nzZcOON5938EtX9tLnWdVj6wTAImH/BePHeWyQjfUgH302CV+0O
	b8+9iwkROrm79EJIHw80bQVzDq9iftDg8Q4TMJx9hFfnuNKgPpuKe9jrA5eg5tqZ
	11KaHQ==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fhqvcbt70-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 09:53:52 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e8e864ef0so1764789a91.0
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 02:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784627632; x=1785232432; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :from:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=+FZiGElwaCSWHzg5ui6ymy+kLbXQLZQh4fC1+Jp3SCw=;
        b=Vuc41xZPRcy6/sva7q7npNVGv1B9RGPbI5y7ZjC3jbqBEKolsW4kEk7ciqvGErxiNW
         IyS96EkdJqKOCIhXII9q1ds5CiJbDYE6D5XujyUYksVHDieY3LhBeGZGA2zqHQG6Y7uD
         VderotbWLJD4u4mfpLSfRXZWi08ucccwS6xwgpzPmDgsFxMLFYQv6WCLU//8S9IsIxMD
         p85t98RoVDLwpVBvB+/MGCELNVohbQguLjeVu565VfQLSsKP6CSps0DxakPeWR7apA1z
         1ydXAjXJT03SIv/FNofIWQe1ddzBTx/kD7C8MaGCTrk3NeiXTZsxQlxs/Qo18+4X9mkb
         wFXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784627632; x=1785232432;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :from:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=+FZiGElwaCSWHzg5ui6ymy+kLbXQLZQh4fC1+Jp3SCw=;
        b=rtQq+5w9DCYfc64NUnzUG+do+bK/Gr1KMQw40jyVWE3f/zINnaj5O9qD0tRsfCO3sz
         roK0R3HbKKZMGZjnIkBk6SxzAkyFtLJ6ynuX3yZSyOJ1JVvd6lBPQCcTxl7gxcCE8+u3
         kmCBdESsUkLBgwwiWJQ9Mg+L2T1iYNlDDiCK/df437jRTb2XRjPBOz6mmoGmRQ+z7MBS
         mRa+0xfDkIWxtyBpxK7C7eYrScaW8Jq01X+QfkqS5FO3/mdWouA3YuXmuEgTbW6o6WBf
         JgCDiao9IIEv3cCUfVFrKGtT67hvgkGgZNUCO9eaekGbYgPiwIIqG6zQhqsjG8likf4t
         PhPQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr8Zo79ntgVsWjmSj148lTOE+ANOeiOeSR/3mVbd9Ne9FcJmLhj2CHB3cF07lXx+FiFjue4c4ai3rn4488=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz21gTtAosEVPpPC3HX7Coj9JpsAz3jPFVkGXwG2HwSES0Db3Lf
	ROyCQQ2V2s1QtzEqCY35pFJ6U/fTFV47I9rOM7ES1sSCYX8HptnR+CwEBYJhEhIMXGpr5Hg/YCW
	CguLXFDQlHVtvUNjKdm1E2B8Fb9UDHbAk5XNuLh4rK5KOagEGep6PvQarOdXnUaa5Wz0=
X-Gm-Gg: AR+sD11DEFjz9gO2pRty6U3GA2WGiScxXqFGxj/uth59bfPUt7mq9FNl7qlPLMx97Fw
	hI9MYwiqyge45P48g00h8QnaS2qKZo08j9W7KJy0FMJ+nI1uYKAnlPmcDqQKhghTdigKiDYQQK6
	o0nuNDO3QoyrsQd63abL5cfZXxtBHC3iupbNCjQw56Av0gUeqQcd24ZK3jJczEF9ecNnM8zNJk7
	AVkZ1s/J3uoOXVd6NLiXeExasKRSgzIgK+2jhH0sFA3zOqpf/jj0D1UvjP1Qjt5HV7zvQK87aws
	kj7dOrOUmTNhFuomCjIwQfDu/28L2hxI7jSdb7xqKwGdXjN3HudOwFDQJDQP7yTXAawYqE5B4YJ
	08UFnvkjwNxNYSddNehSOcFVNCXc=
X-Received: by 2002:a17:90b:5908:b0:380:71eb:4014 with SMTP id 98e67ed59e1d1-38e4b448c32mr19469484a91.15.1784627631457;
        Tue, 21 Jul 2026 02:53:51 -0700 (PDT)
X-Received: by 2002:a17:90b:5908:b0:380:71eb:4014 with SMTP id 98e67ed59e1d1-38e4b448c32mr19469463a91.15.1784627631037;
        Tue, 21 Jul 2026 02:53:51 -0700 (PDT)
Received: from [10.92.203.75] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e9234d3a5sm1217787a91.9.2026.07.21.02.53.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2026 02:53:50 -0700 (PDT)
Message-ID: <574de566-e594-489a-be43-012fb9f4d906@oss.qualcomm.com>
Date: Tue, 21 Jul 2026 15:23:45 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] arm64: dts: qcom: hamoa: Add ICE node for UFS inline
 encryption
To: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
Cc: kernel@quicinc.com, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Konrad Dybcio <konradybcio@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Rob Herring <robh@kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <20260721-devtool-v1-0-ade633accb41@oss.qualcomm.com>
 <20260721-devtool-v1-2-ade633accb41@oss.qualcomm.com>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Organization: Qualcomm
In-Reply-To: <20260721-devtool-v1-2-ade633accb41@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIxMDEwNCBTYWx0ZWRfXyt+7ozHC7RCY
 sfCsV3LwHisNbluVSm99OuEXjP30daUVqjMeeOlch5fXlISSnFoIpCB00cpB6/7Fxg/GQ/BFvbg
 UFyia4yP/njnWfxZaSkRWh5B9l25BNI=
X-Proofpoint-GUID: JH0aISm-u1o2fnDisSaE4IHS4pnPRauw
X-Authority-Analysis: v=2.4 cv=OMYXGyaB c=1 sm=1 tr=0 ts=6a5f41b0 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=LSKOxhpK5ssQvjm95bMA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: JH0aISm-u1o2fnDisSaE4IHS4pnPRauw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIxMDEwNCBTYWx0ZWRfX77APwRB+/YBp
 TXoI5iMZ85JE3lR1OLVWdiH6qhbWW2wK2IexG3XWnfv/Ljjr00K8SO5sC1Ndhp5NSPyOhUPo6z4
 jqqDbGBqbdIFwM3i5MCVcRp5lPY+5HfW2MBuoTn7mICkSht86n/t83USKFNqrPj8Qqnr2jnbuS8
 q3FAqYiPG7EdlNxYe04VQDaevyNwel7w/fzedvetcJENFhGfcVbIFHjTeBq0CqKJxjuGPvm7WxD
 lndJXPaj4MD0ddqCMRp10n4KhIgYOTIdeyqObHKYFtnqYbKetob876mIaJp6YtqNGS/gs2sfVnt
 5j2Mql1wmtYJzXiVUcIZQBNwObUzB8N5vwaYaCms3ZEu4S0wzsxUe1qmmZ1eqIXpvsluw0B0fJr
 Tw4K3jnMWr9BeM4bt/lau2IBHTtl1ZAtbEsnoVEXjPGPx2tbvdbZN2alFOyF93XbMwnPZNx5H5x
 mOgm1L0z4UsDTwTGVcQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_06,2026-07-20_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 priorityscore=1501 suspectscore=0 lowpriorityscore=0
 bulkscore=0 malwarescore=0 clxscore=1015 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607210104

Hi Wenjia,

On 21-07-2026 02:52 pm, Wenjia Zhang wrote:
> Add the Inline Crypto Engine (ICE) device node to enable hardware-

Nit: We're not 'enabling' but 'describing' hardware that is present on the SoC.
I suggest we re-phrase the wording to reflect that.

Regards,
Harshal
> accelerated inline encryption for UFS storage on the Hamoa IoT EVK
> board (Qualcomm X1E80100 SoC).
> 
> Signed-off-by: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
> ---
>  arch/arm64/boot/dts/qcom/hamoa.dtsi | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
