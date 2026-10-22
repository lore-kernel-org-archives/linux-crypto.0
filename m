Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792655582;
	b=buuS6aSCrCejI07MYt7Qe5H/9cYHRbA/wvIsI4CRIhUfApDUWCBGny0hF2RM3yIbgl13
	 ybOlFOEbmjAcaAU7a9FqYvgWEkXk7I9FZA6ojhfYyf1Vm1CevRpXoiraxn+YSGlGxjiyQ
	 X8q4MFd5vlRUywnNOrwouWFhekTq1/tTMPHTZDjfNMzi+TaQhc8GMLN7aN+4buOKlrBdl
	 IY5y8Nh8BaiX2zYyrf2QJCEjF1pzEFPKIoGCtbwuLICxI2SxwV4QMfwqcWMdsKSdjSA7j
	 XMQp525Dwtpj+thVvXNr+hEvXcTStShokQfvKoH2meOlFYru2bwOwgrhq6SXUebg30Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792655582;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=w5R/EMiCSy5UL1544MdsdrlhihqU4IA08SYLZffTjoA=;
	b=1abRj59Mo1a8RGdB7OSI3Uym9u+VcwhDL0lQpi+2L0qr43tSUxlBENnGeo5bKjxSmEAQ
	 1FLNw+Yb09ViK6WQjkrPzqozuf/76kE1HgKgirC1KuBjFwQoOqii4QBVqBS0L5n/kfoI4
	 exnow800awPZzBC7XoCtk3BOCcA+oojo233QuMwmHd7+mTwsr1lpI/UClx7tlJN72eSmn
	 cMs1druMmA/F/g0ujK2NxFEArqZw1mvTlZfB/7Tuq7uIPtPKzmzgyW6jBkHMVsUArsyGH
	 UXpevYf1Yl8NeFeOSxp/L2djLzlb+XtnDjYcRxZno5N8XYiKHazOZtvby2HRmpoeuYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="FD/cWQ0z";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=TCHmvtdC;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54D1606A31B
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 07:53:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B54D1606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=FD/cWQ0z;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=TCHmvtdC
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69M6xvGA1560115
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 07:53:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	w5R/EMiCSy5UL1544MdsdrlhihqU4IA08SYLZffTjoA=; b=FD/cWQ0zypBppPYH
	tbmhXPLAhxqkilh4cXr955iPq/UR/hDJHE2brirXN3GsVdedCGKuMAGq+hRfVFcD
	LQuulUdeFRW9Xm1w19TXnDrgYoEQzpt2Ap2BcKUG6WKZ657etO0MAxDOSAtZ3TbX
	CrENa1mAF238TwXAjrg3ecXGQXLOmhdu3RDEBdDn2eH1LSZyZR5G1YWleNm+rNqU
	KVQ3sM6WGY3NxnHFIMbuKCRgYkPViX9tbPMeqOAU9GNFHTrjAEcm29CRssRwQP+E
	dbTfjddRj9zKlBuStYaf9/9QW60yDRrHo7G/54ukGIeReBmgspeVuhCagdvuBVzk
	ufUTJg==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hf93ahb9h-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 07:53:00 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93f2bdebfc5so44770385a.1
        for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 00:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792655580; x=1793260380; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w5R/EMiCSy5UL1544MdsdrlhihqU4IA08SYLZffTjoA=;
        b=TCHmvtdCQ2wae4MftEKib9cRqAuTJiiTipQUzM6YvMWW92eDI1p5ReaqgZXqkm1aH3
         Hmjs//5FN5dA7C2Eh1fnoF7tjJ8mjHhiabtZJ8C40Qeo2Rcj8KmHFr5bG1oRrAc76fCf
         EEgVPppusA88we0VK1qUcNfUi2PJBIxDLKU3y7lO087A/j/B+rn8cNB7zkN84ZzEVlsT
         G+r2we2ng45jIb6XxNNQP5YSh+OpNOSynSQ3pG3oq3BDWJ4G/fSkPq+N20lMlxrq2HrE
         hScOzmygKUsOA25r13UDsq39LWc+oTzQnIWF73BDFXu8DrYe5UPKXdnhp+Vok7zc0qii
         Jcyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792655580; x=1793260380;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w5R/EMiCSy5UL1544MdsdrlhihqU4IA08SYLZffTjoA=;
        b=AanhFZu3Pl+JebmeUm2gd8D6Zow8H0Ao19kakmfddoh49Ixoh8s1s9seHkCfT0Nfhi
         b5dvfByo9LnE8y8pqCx8m9V0iXc0tIw52qvfvDfq7vzQWzhPQsTkFRhtwwocmSt8C1KB
         0xr/EYTUFg0BfHDfJk/Yh++ocWFUtpoQoDHlOGgLsYqEuCxaNqaAbalmQ5u4d5OFPtNP
         EII5EegYGi5u6uBAQ/R7gamINVYnef084BlABHc/68GC3hJMDAWWwoGJP4LHMh58fsUP
         JbdD2jbEsTGda+kCo0HygG1YWrzurIYnipVJ53b58AqP4wARbDo4NvE6OWnMBLetAWxs
         /yXQ==
X-Forwarded-Encrypted: i=1; AKwUvBz6lLwriNiShHFRZxj3jOeN73pM8W+u0MqgSYlCmHg/8IHb4W30WBc9jKrYzfA7UdM+KoR0ccmagl95B30=@vger.kernel.org
X-Gm-Message-State: AFq9FYLCHamlv4e/INkg/eQlJgBmSpbfzoMs4MRz7m8yJ+yGKN1ZG/CK
	VpynwO+Xderxii+4FFmej9x8ZaN55kWu397IKkeHcusG/aJLdP3yDX7c4TAAvSkK+YhGeDUzz3p
	tDjv84ECcJ4fhMvsk2FNisenqXMJkfi6ogn1GWobs9mJOeOeKfiH7mNNRfaLABD0f/+g=
X-Gm-Gg: AYBFou2vOQOMmm2TX9sBWqB3JuxnyoDgAZinD0Jm31Et5gGjNSs5YYrBMhMuT5Ak7IS
	z+Tc+a1MBNsorzDhw38OvsBYqVSjnR4Ec9y/32R60RWIDnpJnhorYRUyY5JpGHX+V14GmePHXDC
	4+yPAaIdoAfMmZn8NhjspciHssLeM2twjOEvqxrLXTWYTyeUehgtWowf4umseeqIbaB8mw/8yEd
	fORsKq4uRxW2ivxxvr9fsw2M1GYUT3haGMxQptjqajtXPkQyOuPiZzy3AgiWo8gDra62fpLiEBq
	fVsD/Y1HLT/Xo/S15ipnwiEevDOTxMm0BaqAiaM7dKyDbGRMEKRk8d4HOx2BNkv2qzB8DFzvEZZ
	NjkA9bMxoY5mDLitFFYkMew==
X-Received: by 2002:a05:620a:6087:b0:93f:25c7:a4e7 with SMTP id af79cd13be357-93f57f5510emr963216085a.4.1792655579881;
        Thu, 22 Oct 2026 00:52:59 -0700 (PDT)
X-Received: by 2002:a05:620a:6087:b0:93f:25c7:a4e7 with SMTP id af79cd13be357-93f57f5510emr963213285a.4.1792655579386;
        Thu, 22 Oct 2026 00:52:59 -0700 (PDT)
Received: from [192.168.226.26] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c468a55c76fsm77938166b.36.2026.10.22.00.52.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2026 00:52:58 -0700 (PDT)
Message-ID: <21185cf6-253e-48bf-ae7c-bb160a4c089d@oss.qualcomm.com>
Date: Thu, 22 Oct 2026 09:52:56 +0200
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
Subject: Re: [PATCH 3/5] firmware: qcom: Add an TEE bus based ICE back-end
To: Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        Sumit Garg <sumit.garg@oss.qualcomm.com>,
        Selvam Sathappan Periakaruppan <selvam.periakaruppan@oss.qualcomm.com>
Cc: Basant Kumar <basantk@qti.qualcomm.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20261021-ice-migrate-tee-svc-v1-0-b035be7aab0a@oss.qualcomm.com>
 <20261021-ice-migrate-tee-svc-v1-3-b035be7aab0a@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20261021-ice-migrate-tee-svc-v1-3-b035be7aab0a@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIyMDAzMSBTYWx0ZWRfXy9UojdGNjxWZ
 v8oGtcxNr0eSxQvyGfry6rjoFI6FKsA6l3azGf6OkNA4xzmy1BrqCIrUrLdnLq8zZH8Ly2vFLnL
 3oS42SuQQ+svmli9yGe7Ac1gJGigZa/iug3Qd6me7Kngxwuj5TJ+R3jtnVHhLx0AQPLeYexkrLJ
 pssytmOtfLwub8clfrT7AtmZ0ssAymOoOJMYN6lhZcLIxE7WF2gTDdBvg55pfOrnBkC4a0l5F8N
 3YQD/vHiuB1wXVRg4MORTYJjP3bzfW5/ZdKucJI1ucbHhCcZXCDYUpthyz4Qrpxi7KbFTL8B4Va
 fL2UQbHwSg9sB+J6AEhyJNzpmhQkJeJaz0K/bysfFFpWi2ZLttNGhjG+5ieBDK04HsR3dvx/eJ+
 kdvyGVLlaPtgIWJeZUElxBIJsiqqfNkCmFPGTrdAlMFeqEOFDgOu4zkOfScBa4tM1etfrnb1X96
 xkQMW5f0i2jUzEYtHxQ==
X-Proofpoint-GUID: AmDxN8mWih7AnoRgvUst2k1wxrYn4mRy
X-Authority-Analysis: v=2.4 cv=feg4WEQF c=1 sm=1 tr=0 ts=6ad9c0dc cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=SRtFinbuMe9puuQICA4A:9 a=QEXdDO2ut3YA:10
 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-ORIG-GUID: AmDxN8mWih7AnoRgvUst2k1wxrYn4mRy
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIyMDAzMSBTYWx0ZWRfX2KgPhoV+g6F5
 rbN6k4zN6sy51uw9kWvmbPHZqfplSgVhMuGQthRzmiq2rMMkfXeX5/nArlukaPBQONIti7oReDe
 90cy/l2TgKTMAoX/t06zylqLu/j4YE4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-22_03,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0 suspectscore=0
 spamscore=0 adultscore=0 priorityscore=1501 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610220031

On 10/21/26 5:43 PM, Harshal Dev wrote:
> Add support for a TEE client driver which forwards calls from the Inline
> Crypto Engine (ICE) service (invoked by the ICE driver) to the OPTEE ICE
> Psuedo-TA.
> 
> The ICE PTA supports both ICE Legacy and Standard modes. In Standard mode
> Hardware Key Manager v1 is supported.
> 
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
> ---

[...]

> +static int qcom_ice_tee_generate_key(struct device *dev,
> +				     u8 *lt_key, size_t lt_key_size)
> +{
> +	struct qcom_ice_tee_private *data = dev_get_drvdata(dev);
> +	struct tee_ioctl_invoke_arg inv_arg = {
> +		.func = PTA_QCOM_ICE_GENERATE_KEY,
> +		.session = data->session_id,
> +		.num_params = TEE_NUM_PARAMS,
> +	};
> +	struct tee_param param[TEE_NUM_PARAMS] = { };
> +	struct tee_shm *key_shm;
> +	u8 *buf;
> +	size_t out_size;
> +	int ret;
> +
> +	key_shm = tee_shm_alloc_kernel_buf(data->ctx, lt_key_size);
> +	if (IS_ERR(key_shm))
> +		return PTR_ERR(key_shm);
> +
> +	param[0].attr = TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_OUTPUT;
> +	param[0].u.memref.shm = key_shm;
> +	param[0].u.memref.shm_offs = 0;
> +	param[0].u.memref.size = lt_key_size;
> +
> +	ret = tee_client_invoke_func(data->ctx, &inv_arg, param);
> +	if (ret < 0 || inv_arg.ret != 0) {
> +		dev_err(dev,
> +			"ICE generate_key failed, ret=%d, err=0x%x\n",
> +			ret, inv_arg.ret);
> +		ret = ret ?: -EINVAL;
> +		goto out;
> +	}
> +
> +	buf = tee_shm_get_va(key_shm, 0);
> +	out_size = param[0].u.memref.size;
> +
> +	memcpy(lt_key, buf, lt_key_size);
> +	memzero_explicit(buf, out_size);

LLM says: s/out_size/lt_key_size here?

Or said another way, currently lt_key_size and out_size are not
cross checked

[...]

> +static int qcom_ice_tee_probe(struct tee_client_device *ice_dev)
> +{
> +	struct device *dev = &ice_dev->dev;
> +	struct qcom_ice_tee_private *data;
> +	struct tee_ioctl_open_session_arg sess_arg = {
> +		.clnt_login = TEE_IOCTL_LOGIN_REE_KERNEL,
> +	};
> +	int ret, err = -ENODEV;
> +
> +	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	data->ctx = tee_client_open_context(NULL, optee_ctx_match, NULL, NULL);
> +	if (IS_ERR(data->ctx))
> +		return -ENODEV;
> +
> +	export_uuid(sess_arg.uuid, &ice_dev->id.uuid);
> +	ret = tee_client_open_session(data->ctx, &sess_arg, NULL);
> +	if (ret < 0 || sess_arg.ret != 0) {
> +		dev_err(dev,
> +			"tee_client_open_session failed, ret=%d, err=0x%x\n",
> +			ret, sess_arg.ret);
> +		err = ret ?: -EINVAL;
> +		goto out_ctx;
> +	}
> +
> +	data->session_id = sess_arg.session;
> +	dev_set_drvdata(dev, data);
> +
> +	qcom_ice_ops_tee.dev = dev;
> +	qcom_ice_svc_ops_register(&qcom_ice_ops_tee);
> +
> +	return ret;

This is always a 'return 0'

Konrad
