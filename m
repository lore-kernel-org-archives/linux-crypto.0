Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D97B3ACA73
	for <linux-crypto@vger.kernel.org>; Mon,  2 Mar 2026 12:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772455654; cv=none; b=AKfP8/Ms8TkRhqjxOt0Op/8VoMTiz7mx437TlwfDI+Ylankpp2SMHMGbNgPtQMUw+fz/THC9Fvhj34mNLjMMRGpTkHg6ksHV6g3xVd51PjUtvSlwxNrQ1oY7zLuhHUcdpGsVlj58c8tn2hBYjszS1Pm5Pm53VlT5Ja5GcEyR7gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772455654; c=relaxed/simple;
	bh=pJ4iAt7874rcqFlGJ+jurrn+MAbXtuSXcTqMFZeR8fU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q9HOrQs6bPcg8TFV4SP/J5obZ9+H95xJsg5vz6ihrxcA9yYEeOhhKMIC4b6EABsCqEWxvcaKT59ziwAeGUZwPrVVaTbXLpSTuNswR/jq85Rmwmxf+LyAVb4PQUzJIu7TlsJs81QdCWyqhWeux1q3iWyibcBYZ3GvNPp0uN6ERK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=LrHaU/vm; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=DXMKlx7K; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="LrHaU/vm";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="DXMKlx7K"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62281pju2624089
	for <linux-crypto@vger.kernel.org>; Mon, 2 Mar 2026 12:47:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	nVABGUu4mY4JMI9362kjhkOtFnXqgezOf4nKx95HeS4=; b=LrHaU/vm+HW3238O
	wLNgX8f/3KQfa8miTon4/uGg3sQs9GLbmLax9c979MeszYLiO054HK0m89iBCQ9P
	zsq1aQJfMCkqG8jz21inUozmBKbK+ABfPrr7JLMXcoD0YL/rJrAg/vvCspv/WHyq
	MHNRX8Um7uaKCDianlo8LSTzWFCgnnQ5j6X0/x6vkqciprj20N6HURscfA1f+JHa
	ahL65sqmYEsw84JS81vsuY9zvr9dAztp1WNkKZetcmQcRfbMb4fIjnSLpr1xMWcb
	5vXj43JY11v3wjBhCyeVapO8gaLbvQWvvs9XMhibqhqpivo7W4YMKkHOKPYh493c
	mfnhMQ==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cmgbaucv0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 02 Mar 2026 12:47:32 +0000 (GMT)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-89a01982dc5so2453066d6.3
        for <linux-crypto@vger.kernel.org>; Mon, 02 Mar 2026 04:47:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772455652; x=1773060452; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nVABGUu4mY4JMI9362kjhkOtFnXqgezOf4nKx95HeS4=;
        b=DXMKlx7Kgiep8BzyHjztkMvevpPBipSLt/lX4OCB6CwQtBXbHXoEqvXYywufHQiDFe
         F/mu1ewK3rJOEKpJchgAExnrF7pCxrM+xnLJIoMuW420cCAFFojotH9k5spxQgh7y5IS
         Bp1iWaOmaCuvAZaqC7aX+H3TVdVRxdwWWDGJZkjqcdAI1AIwEmCzt+kQmAGX+KPenPbT
         t+71IVKVFrL1WznPBL0XWTtDgYgjHV6yUZpHqkFS/4nLlYML42RN7zRyY0GB+y6Kh+xd
         IxtkWNH+RhBb8SH4aExgSJNTgAtFnFcPyo9lNC1aB4Hl67a6bIfyI4JboO+I3y8VtUEu
         IS2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772455652; x=1773060452;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nVABGUu4mY4JMI9362kjhkOtFnXqgezOf4nKx95HeS4=;
        b=K5PLF/T18+9rIwDd9++esxp+7jpKom0fP8xaTimDDI3N2FIL0KlYua0YPTx9mIxxRz
         KULUWCWuyCcKOY1uKKC9018Wf9HnGsoFEyyoDittdvsqQtbZiK8PJ5/m6CMHUx5TZD4h
         wMzZqUdh018qo6vMA8X829Lvxaq+dQGTC/Z8DcCU5DYvbIhl+yWhx66BG2zJRiTuWYkP
         z3GkgqXkXfHWcSvCBWo+3nqQJ/LbnY0YRI5dQibQ+NWFrrFAy1LK/IDt21MslnRT7zE8
         DgVPtdDPEF3UKu4ehiWE93sHVvuO7CQ5nxU3a6Y+LjGG8FGkShLDce/JmC7gsAWPw7mb
         6pvA==
X-Gm-Message-State: AOJu0YzzCL6C9IiTePOIfUYvW+61BmajlesJZAuL+AlmZ3H5oR9Buakl
	589vqKI5k6kcHZYg+DqkdLpoHl363lCdfOpUFyqPdBFIUpxdILcX1LT+AXMacPkM/4gDu1rs0FR
	yxmlqa45+lKUvjKxhHSm/bGwMp573NTofMGUvN6iSVSkErlCMLu2wFch3O5jVfAcP+Fs=
X-Gm-Gg: ATEYQzxfz5pYuMYGAgc7pvqzc23bbGaxeM66/Oh1UlyO91MLCDd6DnbBCyPUbztoBbz
	DAssR+63ywzTkVwqpNruvPw070P+ZgCNgqdav+kd+hh5ad2vvNI1FkrrSv02fl2YQcGnGXTmXbQ
	+lJlwKqA8zNXWp6MSVJrYT5oUlF2IH09gLb12JINpcrnxlNDLnFJR0VKFPIRca3pd2CG1N0CnGa
	onq2rs0FCBjYPL9KqpsTWEhr2Sg6rL/5kEqdyNfilDdRYPgZzt3GI207m5ajz5LD7ZBcA5K9mmJ
	VotOGzTtyeqt4RXaIbxoAijZI/EZevCjnWBnrZPDY0AjNWQsGHM4k7nSNM6WMbNCerwwWQ7naPr
	ELfOOd668LZXCo+xhj1GLI+Ho7+w2AJKQgxSIObpHwl1Srynb2S3LcA9ISwa9+c9IinowjbSdoJ
	26Qiw=
X-Received: by 2002:a05:6214:5e07:b0:89a:a9:569f with SMTP id 6a1803df08f44-89a00a95abfmr14245006d6.2.1772455651875;
        Mon, 02 Mar 2026 04:47:31 -0800 (PST)
X-Received: by 2002:a05:6214:5e07:b0:89a:a9:569f with SMTP id 6a1803df08f44-89a00a95abfmr14244796d6.2.1772455651326;
        Mon, 02 Mar 2026 04:47:31 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b93973d3ec4sm266490366b.66.2026.03.02.04.47.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 04:47:30 -0800 (PST)
Message-ID: <68c63578-ff12-4f4a-86a0-212c2a6adfd6@oss.qualcomm.com>
Date: Mon, 2 Mar 2026 13:47:28 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: qce - Remove return variable and unused
 assignments
To: Thorsten Blum <thorsten.blum@linux.dev>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260302113453.938998-2-thorsten.blum@linux.dev>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260302113453.938998-2-thorsten.blum@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDEwNyBTYWx0ZWRfX41/h+AvkYnGw
 Z3RtJXGYN/I0QfNUtiBp6n6nl0srIh9Gni0ax2SN7fHllRAKGEV/0Dgoo38Ke5o5wDN6Nap8S1b
 NaeV5Intt9aEdolL04qQhnjrR2o1sSBrt0hsiOBNWsdhUiLfub7RlXfT3mxHC/KWa4V8uCn6eJu
 B516qR5tvVJ62XAhoDqSiUL+87mrsHL4LC5fckH81rDjfXkdEU9UALWAAfQmQWzOqSbnkIyzzDo
 9tgLQ5aYtjhQdZuiLa3w4137y27+qo7LloQsnrsoa+6UrjtL7z9Cvm0KmMWF3sRxSr3ij7VDHU0
 DjYoWs4f5KwtCDTySJBR9r7a11PsWSGRas3OTex3oXtIIWI8BCEguoosclPQOqn2lLX5uQ/fJbN
 lbtD9ce84/SmlBZQAhoH7r3wc1jfKIMYqQ454Slvlqmy7zD6o2pZYsFETwKdmuocurakPnL/UAJ
 q7w2HhSdYLxX+0NPPWA==
X-Authority-Analysis: v=2.4 cv=QfVrf8bv c=1 sm=1 tr=0 ts=69a586e4 cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=CZKHD8RhjnvZNWBU2NoA:9 a=QEXdDO2ut3YA:10 a=OIgjcC2v60KrkQgK7BGD:22
X-Proofpoint-ORIG-GUID: 63DBGydDBQQE9skXPbS1gQDEn_xQAree
X-Proofpoint-GUID: 63DBGydDBQQE9skXPbS1gQDEn_xQAree
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 spamscore=0 bulkscore=0 clxscore=1015
 adultscore=0 lowpriorityscore=0 phishscore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603020107

On 3/2/26 12:34 PM, Thorsten Blum wrote:
> In qce_aead_done(), the return variable 'ret' is no longer used - remove
> it. And qce_aead_prepare_dst_buf() jumps directly to 'dst_tbl_free:' on
> error and returns 'sg' - drop the useless 'ret' assignments.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/qce/aead.c | 12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
> index 97b56e92ea33..67a87a7d6abd 100644
> --- a/drivers/crypto/qce/aead.c
> +++ b/drivers/crypto/qce/aead.c
> @@ -35,7 +35,6 @@ static void qce_aead_done(void *data)
>  	u32 status;
>  	unsigned int totallen;
>  	unsigned char tag[SHA256_DIGEST_SIZE] = {0};
> -	int ret = 0;
>  
>  	diff_dst = (req->src != req->dst) ? true : false;
>  	dir_src = diff_dst ? DMA_TO_DEVICE : DMA_BIDIRECTIONAL;
> @@ -79,8 +78,7 @@ static void qce_aead_done(void *data)
>  	} else if (!IS_CCM(rctx->flags)) {
>  		totallen = req->cryptlen + req->assoclen - ctx->authsize;
>  		scatterwalk_map_and_copy(tag, req->src, totallen, ctx->authsize, 0);
> -		ret = memcmp(result_buf->auth_iv, tag, ctx->authsize);
> -		if (ret) {
> +		if (memcmp(result_buf->auth_iv, tag, ctx->authsize)) {
>  			pr_err("Bad message error\n");
>  			error = -EBADMSG;
>  		}
> @@ -144,16 +142,12 @@ qce_aead_prepare_dst_buf(struct aead_request *req)
>  
>  		sg = qce_sgtable_add(&rctx->dst_tbl, &rctx->adata_sg,
>  				     rctx->assoclen);
> -		if (IS_ERR(sg)) {
> -			ret = PTR_ERR(sg);
> +		if (IS_ERR(sg))
>  			goto dst_tbl_free;

This could be made much better with a DEFINE_FREE()

Konrad
