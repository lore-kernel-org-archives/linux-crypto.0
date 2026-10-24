Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792849669;
	b=Yh78/g2HrZJXGYOVOyPXrorwjT3kTeGnGszWvEAm760pKKQBDIrLRWn6dEngeotEPX4K
	 ZEQzFxFyEbXaxvtuWSU+R1yLFok44fBHzqnyuD0TpZfEhno7hwoHsvKHpHtNITcnU6yEI
	 FinsbDlcxu6VnxwyqKcgFScfXjuwarWpgNhYW1RtzUbfyg4omOWL96xeNTx0E/uRYAX/D
	 O7LzRWVVJUQ9TlpKo+wDkAjoTyFa6PGaLkqP4DW9nxb3JpkwuyA9AUA06NAgyPAqdKY+p
	 VBaV4l5esD108uUQEdgDb3AXPE+vJEmqynQczljOCR4mkciyVavctIywx9YfjiWQYNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792849669;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Organization:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=biPhynUTSKbI2UIg5XKWQGsnKDaI2r52w9/sBmJ42sc=;
	b=EcLv7J9xirs1W+WZxOnFSht02/uk6ltt71oahPYdBeCoRRZpySrRIJAmOYYEBycFrzou
	 ZO7SF/sB9lilX7l9+n/1wIKfdqArIU9XYK1lYs3m9qOWslxcXTwythRscDvGnAJxMASKj
	 Cm1k4qJXo06NCGb9qskRuLKEC4Gf0tdZXu7Fu3NbQmBqIS7qH4fOMx3EmLa7iMEjQqMj6
	 P7fHQ5xA05kwok/63pC5Uj3R2+mamm/fS0zMJFsvnkDoU9i4j6ttEtGbmr03qslTViMAj
	 T8bEtgFPE2fz1UNuN88++ZYWBZfvk0qoTuAPZ63gZyeXOpM7zrY86xBx2V8lzv35N4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=FiLnUzka;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=a7G+7SId;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E7F606A31A
	for <linux-crypto@vger.kernel.org>; Sat, 24 Oct 2026 13:47:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 25E7F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=FiLnUzka;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=a7G+7SId
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69O8oTWJ2217627
	for <linux-crypto@vger.kernel.org>; Sat, 24 Oct 2026 13:47:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	biPhynUTSKbI2UIg5XKWQGsnKDaI2r52w9/sBmJ42sc=; b=FiLnUzkaym5pkLb4
	nfk+1JYT+1hU8zdZ3ho/UwnAd87+v74x8sFZ+iWBi4eLLK29NEcHFn/eW1s3Pd/i
	LLk/oMACDIUaECzOq6uFh8mcj7y28Uxk0Cn3/cO+prX9rSwYVxaWD3Zs2LhAGUkH
	JU0uVhWEVinx7Q7CM3527DXvHRXKoBGc2wS1KtwbZihDAYq25jpCD5iDiRYmHrAj
	FzqYjUFDzGf7+UgrJs1+KJEKpJScTkC+kdCfwsWxlp0Rio/5s/0/fC0gEZ0BJvcQ
	3aJuUnHclgBD70GeaShdTutoo3uRkZ1sTFVQU2hQoDVtc+vyWYFP1RnTS0tK/wjM
	PtGcJA==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hgjcgsc7d-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Sat, 24 Oct 2026 13:47:48 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-341eff9e381so4731565eec.1
        for <linux-crypto@vger.kernel.org>; Sat, 24 Oct 2026 06:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792849667; x=1793454467; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :from:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=biPhynUTSKbI2UIg5XKWQGsnKDaI2r52w9/sBmJ42sc=;
        b=a7G+7SId5bSX/6rLAtRFXZFLo9f/I18V+EhCLHuiRQ6SvlLW96aZspaEpcmDtHuIZ9
         XJGY5oDUmQpPDM54zDBreQA5vh426HDU7q4/X+5qJd4q3tjY1SqJrzh0c0nVBCkhe5rZ
         Lz/dsB3jbZ1HUOll0vBaV0nVrPgvgaGsB3BH7bSSmaUNg8oBalbEyJJShvxad25oXGEr
         EvftNwx5tI7o3CFAcgh6PXsEtWb+VzRGbZJt0+1JVG4PqC0Q3dprwUBGUw/FJwUrNdcz
         UwHMfB8J5N2cwUqZQvufV0+YlwEW/rCbLWDuwJ/7K77QJQg1PQHlIABzfg6gMpbMUlVK
         Zqog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792849667; x=1793454467;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :from:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=biPhynUTSKbI2UIg5XKWQGsnKDaI2r52w9/sBmJ42sc=;
        b=zL2EChs674etyNFWyvp8TRUO/2vIHFV1rb7UI+saDOjxRFwtm7pYuD5PGgm9c+OkU7
         FOIQoHP2lbzxmheJ52jC4OUK4OGlvLuci6SZFn7jW90cVgmCADacOA9hHsVPNMki5Fw0
         cknwq3oKHVrpuCjldJD6zZVQsXB1R6q28AfEl0Awm2VJroBGVAaFbkv8NdYCjMp/EgtN
         GsSA1vh5Encxh/XhKbb7hVt+T7eNu8IPrGxqitLqs4IU2HMXU4NL2eJhMroTjBBJ42rs
         UcRv0YvfBGvp7m4u339FwZuqpCaBDY1rRSen87D4yCysm3DKVPwL7ohZxMaiiBG7kmQC
         28Xg==
X-Forwarded-Encrypted: i=1; AKwUvBycQ3jshm5xR6GZdlKbQARB8e7Ig2Af3zabQ30i2PNAx5qnsH0mT38zLgtZs4sHTBv6J9vjTce2Xs4aFCU=@vger.kernel.org
X-Gm-Message-State: AFq9FYJ1zXT72N+oT15EsPacqlvVUqCCKd1L4X5v0aVVZJOIdjL3ySqf
	V+D5yuywe+mQo8w4IkkA8dl/7gVAg38L1eGhYcNhIB2z8yyLBzm9TOKBxrOlSJKBIZHuGyhKxKx
	826loJQ4ITJHgvqT8j0+T/ISDr8cLyExVcCKj72BHg/uvmIi+OJs8mKL+us8qBFdJVqhTLxpSA9
	c=
X-Gm-Gg: AYBFou2rFh1/Of3TPEdHFtSoFukDCjcuXkbvGgbBDS3naber2VUIIz+eRuycbHFeCIl
	ZLEgZyLq3FUVpUvZPb7ZH2WHfAObnuXK6bUbXM2FyrFm99uI45lAvY6Tpx0hGxIu7tKDymYDpqW
	S2eDcutIUDkcRmwMIGRoTnVVXGtRyp4vR0KR2g9W7LWVgEuZ+nsgvOpTYTHX7xi+aGG0nlugkIK
	h9WS5nXnzNlTrKeYY+5z1tjIKoQt8kSGE6R7L9ot5DuUxry7gcf1faCbY7EDk4NzHzJTtSk6Tn2
	68uOghFuSCZiH53gj9kwVDtC7K4TqbALBvPFkfgwuHzHofxXZtk+wo5kNELn4jDn52p7p6JtyAw
	jkpJiExpep/Tt5C2ztGxY27wv6XKv
X-Received: by 2002:a05:7022:3f0b:b0:14a:51c8:ea06 with SMTP id a92af1059eb24-19936873b40mr3015022c88.29.1792849667412;
        Sat, 24 Oct 2026 06:47:47 -0700 (PDT)
X-Received: by 2002:a05:7022:3f0b:b0:14a:51c8:ea06 with SMTP id a92af1059eb24-19936873b40mr3014995c88.29.1792849666881;
        Sat, 24 Oct 2026 06:47:46 -0700 (PDT)
Received: from [192.168.29.10] ([49.37.153.119])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-19894d5a10csm7575697c88.1.2026.10.24.06.47.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Oct 2026 06:47:46 -0700 (PDT)
Message-ID: <9be32afc-4794-4163-868b-a0af29d8a2f4@oss.qualcomm.com>
Date: Sat, 24 Oct 2026 19:17:36 +0530
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
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
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
 <21185cf6-253e-48bf-ae7c-bb160a4c089d@oss.qualcomm.com>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Organization: Qualcomm
In-Reply-To: <21185cf6-253e-48bf-ae7c-bb160a4c089d@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI0MDA1NCBTYWx0ZWRfX7Q7DNuJnWOLc
 B22ZO3DdYaVn/dWUOVmVJs+/Gi1s4HRwz/dLuxQb/2ZtAZsUOQdeFi395UbWc2orbU4/Ig4kCnR
 DbSahtXwiUL1ferc1ApG6C3e+1u91Kc=
X-Proofpoint-GUID: zZWiufW2pMuqA1rzViTUOGZD6NesZsi6
X-Authority-Analysis: v=2.4 cv=JvhkP84C c=1 sm=1 tr=0 ts=6adcb704 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=hZ1hWxSZf3UX9FuxeSnJ0A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=63Wl8F-6p0i4whe-SeQA:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI0MDA1NCBTYWx0ZWRfXybQYJq2gJ3bR
 6OLPHBaMBpijOXj62a9wL87HsgCQPEXpU7wtZkAAB4mZv510fGPXCRqR9wgQ1ZROZ/hxbDa4QYP
 T01vwz5lT/4VfV59mXJ4ThdhIE8H895bU0xDiiiaGViUkVxCPk+AtycmE0rIEJmuBoivR4jBZ4F
 UUH5ma+svfIh3khPUys/XDQQSj0tpZwuqWJwsyYrtg2psuuCa4RknJpyp3SaTcjk+rWXA8t5YwX
 hKggDdWcBPDjZZeIpZSgo4f/IUdHFwfjKBFKoEadQXznzZX7G9Y+pvaAMCN5f2gRx8TSRYQuqQ1
 iIYjcRQK3fv3RbrQOtvkkA/qLs8WvQIz/9LwGQmx4No0OrFeQ0BAu+fj73oCbxQZ9dNPd3HK2Nn
 ZyQi+9yTA6c4FV99CiFlwmm3+mRjk6jAC6wqe1uTuT2n08pNxu0N/gpQBWH8+6yGeaCNLP91sv6
 LOVRHhk1wfMzfZukX8Q==
X-Proofpoint-ORIG-GUID: zZWiufW2pMuqA1rzViTUOGZD6NesZsi6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-24_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610240054

Hi Konrad,

On 22-10-2026 01:22 pm, Konrad Dybcio wrote:
> On 10/21/26 5:43 PM, Harshal Dev wrote:
>> Add support for a TEE client driver which forwards calls from the Inline
>> Crypto Engine (ICE) service (invoked by the ICE driver) to the OPTEE ICE
>> Psuedo-TA.
>>
>> The ICE PTA supports both ICE Legacy and Standard modes. In Standard mode
>> Hardware Key Manager v1 is supported.
>>
>> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
>> ---
> 
> [...]
> 
>> +static int qcom_ice_tee_generate_key(struct device *dev,
>> +				     u8 *lt_key, size_t lt_key_size)
>> +{
>> +	struct qcom_ice_tee_private *data = dev_get_drvdata(dev);
>> +	struct tee_ioctl_invoke_arg inv_arg = {
>> +		.func = PTA_QCOM_ICE_GENERATE_KEY,
>> +		.session = data->session_id,
>> +		.num_params = TEE_NUM_PARAMS,
>> +	};
>> +	struct tee_param param[TEE_NUM_PARAMS] = { };
>> +	struct tee_shm *key_shm;
>> +	u8 *buf;
>> +	size_t out_size;
>> +	int ret;
>> +
>> +	key_shm = tee_shm_alloc_kernel_buf(data->ctx, lt_key_size);
>> +	if (IS_ERR(key_shm))
>> +		return PTR_ERR(key_shm);
>> +
>> +	param[0].attr = TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_OUTPUT;
>> +	param[0].u.memref.shm = key_shm;
>> +	param[0].u.memref.shm_offs = 0;
>> +	param[0].u.memref.size = lt_key_size;
>> +
>> +	ret = tee_client_invoke_func(data->ctx, &inv_arg, param);
>> +	if (ret < 0 || inv_arg.ret != 0) {
>> +		dev_err(dev,
>> +			"ICE generate_key failed, ret=%d, err=0x%x\n",
>> +			ret, inv_arg.ret);
>> +		ret = ret ?: -EINVAL;
>> +		goto out;
>> +	}
>> +
>> +	buf = tee_shm_get_va(key_shm, 0);
>> +	out_size = param[0].u.memref.size;
>> +
>> +	memcpy(lt_key, buf, lt_key_size);
>> +	memzero_explicit(buf, out_size);
> 
> LLM says: s/out_size/lt_key_size here?
> 
> Or said another way, currently lt_key_size and out_size are not
> cross checked
>

Ack. Will cross-check these values. 
> [...]
> 
>> +static int qcom_ice_tee_probe(struct tee_client_device *ice_dev)
>> +{
>> +	struct device *dev = &ice_dev->dev;
>> +	struct qcom_ice_tee_private *data;
>> +	struct tee_ioctl_open_session_arg sess_arg = {
>> +		.clnt_login = TEE_IOCTL_LOGIN_REE_KERNEL,
>> +	};
>> +	int ret, err = -ENODEV;
>> +
>> +	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
>> +	if (!data)
>> +		return -ENOMEM;
>> +
>> +	data->ctx = tee_client_open_context(NULL, optee_ctx_match, NULL, NULL);
>> +	if (IS_ERR(data->ctx))
>> +		return -ENODEV;
>> +
>> +	export_uuid(sess_arg.uuid, &ice_dev->id.uuid);
>> +	ret = tee_client_open_session(data->ctx, &sess_arg, NULL);
>> +	if (ret < 0 || sess_arg.ret != 0) {
>> +		dev_err(dev,
>> +			"tee_client_open_session failed, ret=%d, err=0x%x\n",
>> +			ret, sess_arg.ret);
>> +		err = ret ?: -EINVAL;
>> +		goto out_ctx;
>> +	}
>> +
>> +	data->session_id = sess_arg.session;
>> +	dev_set_drvdata(dev, data);
>> +
>> +	qcom_ice_ops_tee.dev = dev;
>> +	qcom_ice_svc_ops_register(&qcom_ice_ops_tee);
>> +
>> +	return ret;
> 
> This is always a 'return 0'
>

Ack.

Regards,
Harshal 
> Konrad

