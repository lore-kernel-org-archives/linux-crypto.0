Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792655518;
	b=DrtED2WgE6qO/WYSt2zDQcoeTkocp4fWcgh7Xngq7bpb8umIhOYLs2liUPpcWH4OEzxn
	 RIqCofPN4GVSq392GUIBrVCrJSdjJ3Qd4HjlInrcRtQTFcqrB+nOi7gKHzL2G8MroOPq4
	 Xe2tUYrGGRRF1EooITQmMNArSZCeZVf7HTuAm4PYTrCECtqekHztURbM8CqZCUsjrUKDh
	 oT0V92EKQA0wX5/mfAJgvfcQvYQWBSV9KK/2RNo1WqNbLPzYEe3gFf/UYutElXykEitti
	 iVsBbRPrlxTob+mZL/DPf0h1cDpriBgJNDNziijghj+QbJT15NwoaWJl/1ETDbHFvmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792655518;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=mD8i6+sZedw7U7XL9M1rnQ27aUG9edu4EMXiuxKiP8Y=;
	b=C3uQlrXjwx7QFbLREvafcjwJMR4aK+vXWeL+EU2W3anzykJglgYRmDl0RKqZriBULvE/
	 /x1/itUhvzqCS8VodOo4UbtfR//3mAS9iqfqo1HzRAj0j9Yp3SuslVa+NONA4bKo1jZqx
	 aqmLmhbAOaOZbEIb/vA/vufOdDAHf92sm4f1fityWN8IfBYrunlf4Rc/T6burc7ZkldO9
	 9PpCHJr1Unq74c2cykSrqDqOuPTIL10tMXcCD5kKH0cySo/z+awaYsQBrwHdjmZw9O1yx
	 DC9mOW9fe3XEzp5lFRhLLvvwuRWyuDmlsIoSZGHMRyAEOi7Fa7ZRGtdhd1g8q+GjM4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Rs8GCwNw;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=GSFfqMeA;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AAE9606A31A
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 07:51:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9AAE9606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Rs8GCwNw;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=GSFfqMeA
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69M709944136785
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 07:51:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	mD8i6+sZedw7U7XL9M1rnQ27aUG9edu4EMXiuxKiP8Y=; b=Rs8GCwNwEm/O9xBB
	8SvWsmGXd/wa+HuuKatpUZHduOZbB4g8jLz2AAgQeSPBIHJvpsyZsmcBqvGkyY4W
	xPnOynHrHlaPPq3qo5TFCcQ6kapN2i2zWvdIGum6oxJWz8LmNsy+AZRAKCPTAuLE
	Gqn3yuNSX6NAjIW73NCY20SohJJ5cK8thoMABRCKFyrBaP+Z4xqjS1oTtuTnF39E
	y4CbpBKMT1a2zkMX4BrGiAdFeYtIxMgE6KiVRO7pv4Bbi9FIdoiFsyYadqYc9RWg
	1mH1xd17CSwo4cqXgrK6hoDeoXPs7NGd/wCjOG6h0zZL6YdkGIGcXoBWL/dLPpYP
	M60lEA==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hf93d9ahx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 07:51:56 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-530cd3dff25so2470191cf.0
        for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 00:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792655516; x=1793260316; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mD8i6+sZedw7U7XL9M1rnQ27aUG9edu4EMXiuxKiP8Y=;
        b=GSFfqMeA3Od/GItiEMElqlmSxrJZj5F4Zy0dkX7hLEvidvFaYlB2ppzKPQhX+Ku/Rg
         cSad6hNpAtNJrdJf/4+I1WoGpDtXkAVlkkfFvnOrGqTLTnHDj3uqk1kRLZJbXOyojzfD
         vnEkYGEC31lca1MPxsp2+qW1vlvM73kYQSnhnIJOCzIIiulbKkbJvpntPcuML8ZzuXLf
         FaZRTzCNX6IjnjiuX06RHzb3mCzPJ1ErGf0dYG5MPRSisAPCH19xL61xbA13zlRvnxHM
         Ic4xjJSkvFgMw0rR3aRze4DmUc2OgB4OqU7u1K7Wzriwk3R83GUh6mMPMdgv5VNL2WQ3
         mIIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792655516; x=1793260316;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mD8i6+sZedw7U7XL9M1rnQ27aUG9edu4EMXiuxKiP8Y=;
        b=tP+kfGHgCJbGUjzRuePO8fWOdjvqJEapggaCxBwIylfxXGOXPr3b4hGQpsTSV0OnbD
         Az/JclGbopkr9emTMzKs8Q5Xjh0zigWD7OyAgb8kxNEuBh89SlxPlEPw21C2vobg8DPJ
         ukDLibMjTe3xElvxhA0mw6ARi7WwhttL0Y3sUQEvVwoHiBwE7R99+ziBJVli422Y2j57
         wlePULNcm7RgGrOXw25JvFQXTrtWBoOyhKnKx/gyOrF3JPIfC2Xh0As4QMG51fY6zig1
         kgIrBfpmUUki8fED6xmvYZ4cViBdL3+3gdh5BLi4VqbLLVNWpz45sd+sxJzljQqRNpsl
         mRQw==
X-Forwarded-Encrypted: i=1; AKwUvBxGXieSX9bpzOf1yh84W2yII+BZmbtgRGWm3Wsr34PTOvFVt83B+PjcPoYSs7mYqEWjEtnHYa3MtrwgtHQ=@vger.kernel.org
X-Gm-Message-State: AFq9FYLHBl1p/cmkzLcSNNVwVPWithMl3uU3Tg/50KLOIup+UVB9Qy9/
	VTd5XwQXanfmZCc0dBd85cj+zBGX9xGKW2FtRQnXhI1Mu7yZMtPLAy1517k855yPOjnaZfjYKkd
	CmRgE/eNZE2a6oh1AJAvj5ELKiSNCKMLX1XD/sBxQ+IwSsz2QJkUyDdkvwdTV9gDYbos=
X-Gm-Gg: AYBFou0UheO7oEw7ZMKPZLWZrjUGEwlO2M+eGMgb+2hw+AdpDAlboV9hmF4utA9sK5v
	pYgms8iG3vu9lzcTyy16xA5ZX4r80NEngXAk2IiJfKX54/DudBbd95upOYEF78tAEYM8PfpR4je
	EUBhRcWInKsNs95IhVVzXbb/Uq0Wde9OnJr2xGjDZOkIiQVrVCPETDLSWmGS2Nca8TNtEfhweg3
	05XTuwUyD1SlVB9pxxTDIzRcRdVXW2k6ErDAjE6NrnqfAcuTK5b9iRJekVO0lbw69cI6AMc4inP
	Y5PPlWwSsdi5aG4IzSV57TmXPy6gD+w7rEqt+w3QRa9xHijcFhnDfR+Asfgm6QCW+bFmPw57Vtv
	Y/eTvvcLtKrCnKuKhqO0+UA==
X-Received: by 2002:a05:622a:134b:b0:535:162c:2e81 with SMTP id d75a77b69052e-5369bb640a1mr78941761cf.5.1792655515706;
        Thu, 22 Oct 2026 00:51:55 -0700 (PDT)
X-Received: by 2002:a05:622a:134b:b0:535:162c:2e81 with SMTP id d75a77b69052e-5369bb640a1mr78941591cf.5.1792655515211;
        Thu, 22 Oct 2026 00:51:55 -0700 (PDT)
Received: from [192.168.226.26] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c468a5e13d2sm74998766b.72.2026.10.22.00.51.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2026 00:51:54 -0700 (PDT)
Message-ID: <0b389532-a917-49fc-a827-3b90d3ffd95b@oss.qualcomm.com>
Date: Thu, 22 Oct 2026 09:51:51 +0200
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIyMDAzMSBTYWx0ZWRfX816GgBdgEGvI
 44pFvfRbgDNINTt7XIdnyezHmz87au6rxmv0Enrk0bULOYdAaSKxG4gZ7YlIL6v7zGoCNQGGO5A
 GwQuqEek9PO9WisiMXB2EwN45eSSaqo=
X-Proofpoint-ORIG-GUID: KKWY4A68AlY6iLXgSSz80-GuYOnvTA3_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIyMDAzMSBTYWx0ZWRfX0/2h7Tu/XiKu
 K3WqegEh3RD8C5E6Dcsrt7n6oBepbhE5GUn5ci7RZG5cImib+L9tavz69Ss/hGBIKCAFDM0kZWK
 r8QcV6GvJZGHeqkyU3FzdKJcGSSA8WImxk5HwcIDgpEE58/4mB1R/nlMx/MvcgfeqCXAVrXXWbW
 RyWR65463CKkYP+21M+dCK3I2hc2vYNh+Ko4UqPnwwSIgm4cifXj+Ye7rRTMWgDI4iO3Vgwn5RE
 rx6tFECzSHJsKAKQTeG84qcXnbbZa7JWJ3u6VilVrZ2zJdrKAJ1UUZgnj1xnBgo+VNhI/UT0O42
 FBdzmCN+y8iGQMIA0tr58XmkDfybTu59IlMm44K8NgdJ0phDw0ABCJOJ6f0Hhar1Awg4zVa/BN0
 7N2pNXqoe1MFapWq2O53FnT2RbeGR+q9vKfMUfzj+hd2j48AP35WsOigFA0LRYRBUxrTqwvc7Vc
 WzQ2ASetqHsZLx67mNA==
X-Proofpoint-GUID: KKWY4A68AlY6iLXgSSz80-GuYOnvTA3_
X-Authority-Analysis: v=2.4 cv=TIPQ2Fla c=1 sm=1 tr=0 ts=6ad9c09c cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=NdAFo_9X05hEFN5eng0A:9 a=QEXdDO2ut3YA:10
 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-22_03,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 clxscore=1015 adultscore=0 priorityscore=1501
 suspectscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0
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

This can return an ERR_PTR()


> +	out_size = param[0].u.memref.size;

This returned size is not validated, there are a couple occurences
of that



> +
> +	memcpy(lt_key, buf, lt_key_size);
> +	memzero_explicit(buf, out_size);
> +out:
> +	tee_shm_free(key_shm);

LLM is concerned about freeing the key without zeroing the memory
first

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

Should we care about the specific retval that comes from the TEE?

> +	}
> +
> +	data->session_id = sess_arg.session;
> +	dev_set_drvdata(dev, data);
> +
> +	qcom_ice_ops_tee.dev = dev;
> +	qcom_ice_svc_ops_register(&qcom_ice_ops_tee);

This can fail (but it currently returns void)

Konrad
