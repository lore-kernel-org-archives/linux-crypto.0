Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2186E326957
	for <linux-crypto@vger.kernel.org>; Tue, 17 Feb 2026 10:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771324947; cv=none; b=LRVRMvF4KeIeNNKej2PX9k3U8ZVFpVnbDAbdc8owqnO/GEtTbObJOeR6ts/koJOBFKMey8dpRiAw0FCkWnLCdIMnP7Irom7gQqVyiN/93SK7eubQKAybxljWpXpOcvCJdl8MoRKKyLoMh0iJ7H9Lv0cBKYc2S4YHyKkWMBmoucM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771324947; c=relaxed/simple;
	bh=zwkZhKPwzD2PsE1qcDcLirFWz7+Ud7DF8KDPjOGbD5Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FyBMp9s7JGQbt9ahHniqNBxi9auwyqnmi9ixkbhrY06CD8Xx8aWLLRDAaNO7soN2225SPHyQEp/Hq0GNyWnJ44RZTbCrNSf5nyqSpZ3UPoW1UaE4MzLkJY40m5Flb+9BP4a4v3W7stQ5L7dYHp0QG4iL8YiA9x/V7oKf47qiKxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=SKt6GQ1n; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Qz3mJse6; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="SKt6GQ1n";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Qz3mJse6"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61H89QO1048812
	for <linux-crypto@vger.kernel.org>; Tue, 17 Feb 2026 10:42:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	lERWgpfQ021ixuj5VydJR9LwXl6bNyrORxIkuF1K2e8=; b=SKt6GQ1ndkPWdntu
	fLOUWgc0edVxjIUWHa3CXbm/A1NSIdL++g/98VhYcO7GAKtxPVTuKCJzlwXKxE9b
	SAUMTPjw4+eyh29vXrqfAS8IS+MsiKfoSPGQ0JJKoraYbyML/aCJJ9sID/uB2Czv
	KJdlEzvteTnlVFIj9fJ+YAGJtCqetROozgTpTf2xPXZCcSOnf0F+AKYfdAcnPboO
	ChT48Tc85S8v2/grel88r5+fJMwxqg5F7szz7/2uUta3C4JcrJq8zNUS/KkO3Lp3
	MBQ7/3ehwhfB8WGRxORYxEMVbXm58gcs3SGJggNfT0/CXmcHvvsoWb//3Ns7Re72
	9svWxg==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cc6d8218f-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 17 Feb 2026 10:42:25 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8cb45a6b860so222805085a.0
        for <linux-crypto@vger.kernel.org>; Tue, 17 Feb 2026 02:42:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1771324944; x=1771929744; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lERWgpfQ021ixuj5VydJR9LwXl6bNyrORxIkuF1K2e8=;
        b=Qz3mJse6+k+zYrgF7+ZUunw9+Ak32DY8VTDuF//0Hq81DHCutbPSpzqi1XTmKBVlgy
         2iV8R+zXF/chUUGSoVWYS2dDl3speZc5zAqk3JJRzfyuqJ06nz0ezYhykN5KopXy81Lb
         sWwFLefTjnsH4jfthrfTkA3MRAnnE///C313P2xp2W3V2FZ9mSbquMhirbq+CO6XH/79
         H1ZRjx5bajRqqp5C527EXSCPBy9+pp3ATyxjPxjXeQUIdRGZ8/VJJjSvL8f1KEn9Immf
         yR8PIeKGBlpQUZgoncxm5gu/pLPbh4ei/RGpxofchmXHg8d0Ru+Eo3p40M72QSRxE43r
         YF+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771324944; x=1771929744;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lERWgpfQ021ixuj5VydJR9LwXl6bNyrORxIkuF1K2e8=;
        b=gUvhlvqIDV4Y6NCKMbWBryt3GXX1+EniN578hyfAhKRJVPhmet6eq4pDG/t2QPpiIu
         rLeKpC6c33u9BlUlE2yV0f1GvbwyTL8irn36sAcKyaeHg90690tdtNjJF1WTcf+UI/+Q
         uxH6PiGCb6gQND/CFQ4Ohn6MSB/8I/Ajb7LaN0NHh4VhpA9jagykYN8EQ8oQGA1dhTSW
         BDo0Uqd+y4NjdSrvvbtLm2/aON06PpLZ9eA4C/xz17j4JSJhxVZVIKKxiu49F9k4mHno
         1CBzb0oHWxprN/ccbXNG/MsV4Y094b4plw7BrAQiHbr/JQxKW5AD1APMHJFm5MfeFs8x
         1xNQ==
X-Gm-Message-State: AOJu0Yws+rABsiwxjRD//hzgGqsh3TTld0wZ4YjPWdempHM83hZSFsEF
	n+9UgkaBwhj4HYhL8hVUIsTNrJGZ6qTsz+gi/KYt60IddUkyFYmD0uXWoln6+Isov4QqLnQ5qgp
	uzMgvttXVUapn0sYyBwazhtLBkoQ+RKK0DyOlcUd6crELbDV1skPWj2oJFFwa6nX688s=
X-Gm-Gg: AZuq6aK8R94wj9ZpZoV1aw2jqv57cMgIEE7833vV88AHwuviPuQL25VmzyX22cwMKd7
	vcpq6mwakkSN9N1zBC0sFdTnEE6R8VYwhyvlztC8+lEPnmiMn/Xynq6ciheBn3rHyXm1UZ/IuUf
	jZdFnXAECddDH0kHLkTbobRWG5/gPIHV4893y3UvWejV+/p/Pv5h5VJG+3T3INi4VGtI0aAOokZ
	sBMfKKbUyVf/wlVk3wPCPfk8cDpAzRE9tgsTauhOoyi1lkH7/fLskzRLX0lKj6k1lPnAmRPd9Zf
	UefXIbJDul/TW2K29vSPBYnJMQPoSVjZk040QD1AWJZS+5DbC5Ve52IoLE59YxdGNT76twMcmDn
	1swkOp7hq2qs1YcPQNLdCkTzqy2zJM4/4F6WvrBxU3oRT507IZsyKWQIK2DGZPD50o5EXmt874G
	bEC9w=
X-Received: by 2002:a05:620a:40c9:b0:8b2:fe27:d2ff with SMTP id af79cd13be357-8cb408cab72mr1172602185a.8.1771324944422;
        Tue, 17 Feb 2026 02:42:24 -0800 (PST)
X-Received: by 2002:a05:620a:40c9:b0:8b2:fe27:d2ff with SMTP id af79cd13be357-8cb408cab72mr1172601485a.8.1771324943969;
        Tue, 17 Feb 2026 02:42:23 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8fc763810asm330777466b.43.2026.02.17.02.42.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Feb 2026 02:42:23 -0800 (PST)
Message-ID: <e5fe09e4-758e-43ed-a134-55bcf3a198b7@oss.qualcomm.com>
Date: Tue, 17 Feb 2026 11:42:22 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] crypto: qce - Add runtime PM and interconnect
 bandwidth scaling support
To: quic_utiwari@quicinc.com, herbert@gondor.apana.org.au,
        thara.gopinath@gmail.com, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, quic_neersoni@quicinc.com,
        quic_kuldsing@quicinc.com
References: <20260210061437.2293654-1-quic_utiwari@quicinc.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260210061437.2293654-1-quic_utiwari@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=bqVBxUai c=1 sm=1 tr=0 ts=69944611 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=COk6AnOGAAAA:8 a=1gNIoQPsFeqS8mZPopYA:9 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE3MDA4OSBTYWx0ZWRfXw4Xsh1bPN1RE
 5RpXk+7aPwRDFkVTJSa9KcypjNGrA0iBQW9Nr7GOhO9ZU/Gt763TgeiZAX6Hnxk9m8ire09S72K
 vR0OshTR1B0HIJ6nMTr2ix10fhj17FI1V3BzdvQi2WOzs60YI5tflP2mPcFQvKECe0+U122Pkc3
 6S6PHFeabE949ZMMtMqBxgbaPnZ1xSycSgd0U9TqPTRIxweL8rQN/oAaKNclDj0WCJSswZfLHZ/
 cfLDRzkKbImdjUe8EuiZfTgo1gJqUZTjajc+gf6RSr3qeVN4AKh5vV6/u0QNWtRzW/tTNr3hiKY
 cwxHTT0BUPj4Adyj/ELRhX2NiCT/wxfxUCAPf2YnCn3AbJB/RgKIgtjilpw3MGFUD3vv7BRzvsX
 M2gmR/UHFeNOLCzKeCiRzN2m5FiKk+pimJ60vEqfv4Gl1ENls4yawUTBz5yAfkDaNtsHP/LG/mw
 vrhV4ikaJy4YVmxu2XQ==
X-Proofpoint-GUID: ckXZU9ZYhfwcnsiE-RCaGgAI9RmT-iI9
X-Proofpoint-ORIG-GUID: ckXZU9ZYhfwcnsiE-RCaGgAI9RmT-iI9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-17_01,2026-02-16_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 adultscore=0 phishscore=0 clxscore=1015
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602170089

On 2/10/26 7:14 AM, quic_utiwari@quicinc.com wrote:
> From: Udit Tiwari <quic_utiwari@quicinc.com>
> 
> The Qualcomm Crypto Engine (QCE) driver currently lacks support for
> runtime power management (PM) and interconnect bandwidth control.
> As a result, the hardware remains fully powered and clocks stay
> enabled even when the device is idle. Additionally, static
> interconnect bandwidth votes are held indefinitely, preventing the
> system from reclaiming unused bandwidth.
> 
> Address this by enabling runtime PM and dynamic interconnect
> bandwidth scaling to allow the system to suspend the device when idle
> and scale interconnect usage based on actual demand. Improve overall
> system efficiency by reducing power usage and optimizing interconnect
> resource allocation.
> 

[...]

> +	ret = pm_runtime_resume_and_get(dev);
>  	if (ret)
>  		return ret;

I expected this to use the new helper too, removing the need for gotos
altogether (unless this path needs some other handling which doesn't
immediately jump out to me)

[...]

> +static int __maybe_unused qce_runtime_resume(struct device *dev)
> +{
> +	struct qce_device *qce = dev_get_drvdata(dev);
> +	int ret = 0;
> +
> +	ret = icc_enable(qce->mem_path);
> +	if (ret)
> +		return ret;
> +
> +	ret = icc_set_bw(qce->mem_path, QCE_DEFAULT_MEM_BANDWIDTH, QCE_DEFAULT_MEM_BANDWIDTH);
> +	if (ret)
> +		goto err_icc;

Just one of these is good - icc_enable() simply calls icc_set_bw() with
the last known rate. Since we're not setting the rate any earlier,
just keeping the set_bw() alone seems like the way to go

Konrad
