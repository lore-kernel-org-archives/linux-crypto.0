Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794602755;
	b=G440dgQT08XpohPVCIIe+YN2bvhH1BJ3Jvn11aJ0v+/TXa2aBTfma4nQJgeSimXUEfBi
	 Pf7xkhAVEfZV9EAgNMCr0lLH0kqfWyUjK8Thc250pV9aIgAvTHgg1AfsFahmg8pSjTtTy
	 /pZ47hNW/ivYyoEz93n+l3xDd4vKE1He7mv6/lvEpmjmbt7tKzkjgvJBwTsZFQaTMTUEk
	 HsOMc5qOAift5JtHHW1ukJKAERY/0cqTX+s22oENvYqugU20FON4TGV0ngWXgTAvcU5c5
	 2pqKQkFxPrCynWM+rMUGMNwYXj2FF3fChOyU0Cl0L3vIm/NJQoNKl1RrM9tHAwrGaDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794602755;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:From:To:Cc:References:
	 Content-Language:Organization:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=b8GYNp9h1BN6LZCaFYnOi9RO+fehzDHVEHwdAXLSsuk=;
	b=5Y6SRS7ftbm9oWkEUateMlLoxSKfvlp1Wzh6xex/+ozIkCFs6NbJ5IQnlFQoibcx/3sW
	 bnP0Yxr6SDa9LhDqJ5B8GMFENubsviZuybqX7tsv/GNgiq0u+LuhA/Q0V/sZuo5+5Vr2J
	 Gs0p7ADlD0RvMWGQo7jYR1h6EGlU1c2DEC3wNvu+kUGK/G6Ib2+wKQYhDwfqZy1HuTZrl
	 IT7P0K6bprVKu2vD+j9KD30LR8r98p7bfgjZDBP6cub6gFz4RqCksqwhP6bSAr2P2Umu7
	 iXIhFu59a+mjka6EYeOI67YVTVCn5Et3Uk1NLpy7pt0jX9KmicJrUUP/8VG6QvuX7wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=VXmdwO09;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Onaae1lG;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1EF3606A336
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 20:45:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1EF3606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=VXmdwO09;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Onaae1lG
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ADKWvLs1986944
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 20:45:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	b8GYNp9h1BN6LZCaFYnOi9RO+fehzDHVEHwdAXLSsuk=; b=VXmdwO09mKW3S/x7
	+wEETAizqcfOdCmVksYiKAMMhQWrf7IC3qpiAIDefnCV0TTrYQO+R5Eb+tl0zjEg
	he3zfJ7lkuESA7BZyVmMg57NxOvxb5P4C58dfVAQPM0z9NIb0oVpEJRKbyg50gbD
	feXOft05NYpxwrw/WfkvGll4+YdpVgKQ1A5l36nYKVTekTJsw1zxH1SfdfI/Q03k
	9TZ3dqYlPc1L/xJaeNLsJ7qxzG33VnLOuibXnGcag8J4X1dAHwBJTmqBRaXtXllE
	d5XOtILggd9s+D/cZNEm8rUlnPxZshrEzxOvvMs2THAAdJ3bHBwk/wiOBCZm6Xw2
	ZDOufw==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hx9pdg1f9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 20:45:54 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-36ecd5db581so1494222eec.0
        for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 12:45:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794602753; x=1795207553; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=b8GYNp9h1BN6LZCaFYnOi9RO+fehzDHVEHwdAXLSsuk=;
        b=Onaae1lGNOEN7jdMfTLsV/pXQVx/0MlEAe48h8hw7biWEbxWf9EYmuLYT4SBo8CmWj
         yBrOTMWc48C6J+EDIqoX3q4X09pgmLrq9J796aVEK5r3Ldz9ipIlv/pceaLCHa4qGJHd
         YsQ33LqN+gjWQB+78HKKEO0nZwAqfR7lgcbgn3pjLB+6kNb1v9Vu9prZvp3MtIZU/pwu
         +ENGvcSz+UqVsQV4qGXvuVsjKrbN5G0Ai5dpM5lj/vVJJqd71BBQmjyJse+lvXQ1vqZ3
         oaSlqb+EO2UNTG2uIKe6so8GsE3nBY10vQ6mMUXn0cKVazKF64QRPVajAMs8O9tMoITw
         6APQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794602753; x=1795207553;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=b8GYNp9h1BN6LZCaFYnOi9RO+fehzDHVEHwdAXLSsuk=;
        b=Zrq7SmdGbM8xE/oB0K0amnGHz7mHopv6RT9x/ksmfyEa+rTGXHIyi1UZ7p2mkr3vy3
         xb5SIzV14jKjAtdm1W9JNhGksfn6xGEIiuSkV1e9kgtVCShpFMFAjX1DtU+ubh2IuIh0
         INZMLyO5OP2QVrhJBYpySU6qJsk9RC8dbfT/Udsnw5Rdn3ZLae8+GX02ivTOzjB/n9jk
         /UFJi0lK5oPd2dna11f+KlUEDeFYcR14MiUqCS/XKc5XqjN+LCj650kgxbnOv8V/Q7ij
         bk5BYTeVVUT+8njQYhayQv7Gb1YAh9frhKTo0UPJfHnDtU/EiNmH2Hh1u3mbMlP18Zh3
         G6vA==
X-Forwarded-Encrypted: i=1; AL+hErGvyRZ0uuGc6RKH+As85swOwHigDZ+6AedCPdk+OhX6vl7hAJA/cUA6yYCL8yeHPYoQDuNLpzNPIHHZWbM=@vger.kernel.org
X-Gm-Message-State: APuU4Z9e655h9nICOaPQ9Vx8c6yQiNmqYe5+a3pKZU1YshjkT9do0Su0
	LD3vskwaSGGSvh1mICJDYY3AKdELO8mMleQw993cSCbIlqfUYnpAL51FB4GdiWNxpfwzOOqn0G4
	KbcChQ4+D6FnBV26RbtQes6xc8utPMAusRmaDS/08DrsdbHBG7Z4tfLyEXES9SxP9V/I=
X-Gm-Gg: AYBFou2KNbziFiexrEN2Ji0XgvgMxsos8Ww85b6rgMxbo7Bkr4VYpur8b0Ebs8TjXVh
	rXjMXGncpDEaswAizRFoB9Wkn+q6ONZE5bZDnrEV0Q/5ua1ntN/xL2R/EfnM4EhfE53XTeSQCES
	xdwlrlHO8ZGAbmAukhOTcNJXZlCbTp18ulr7nuyL8mEMb2cIcXnVTHv8O9TwHPJEtA7yhf0dIAK
	rdnVb0Q94a5Oly49oU8pm1iOndViHPPm5j91Qvpl4Nd/GIyJA5hO9V8g7LmRaq48Gr3QgVjomMU
	Ev8axgWbONUcW20Xlgi6/6CVSuqUqpnSpneeWpuVrC2Sj7GbsMvmc8aL/esXDrlUq2K7GgH/bn1
	VqvthiXjZTq/iqA7oWOf8MDSLDWRpXPhbaOE96I7xLszxHNC0811qJrrYXKpDHWYC/YQ1PYFshd
	yEmQ==
X-Received: by 2002:a05:7301:4614:b0:36a:12bb:7f8e with SMTP id 5a478bee46e88-379655d45c1mr2796748eec.13.1794602753181;
        Fri, 13 Nov 2026 12:45:53 -0800 (PST)
X-Received: by 2002:a05:7301:4614:b0:36a:12bb:7f8e with SMTP id 5a478bee46e88-379655d45c1mr2796723eec.13.1794602752466;
        Fri, 13 Nov 2026 12:45:52 -0800 (PST)
Received: from [192.168.29.10] ([49.37.154.218])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37955332a77sm9032968eec.4.2026.11.13.12.45.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2026 12:45:52 -0800 (PST)
Message-ID: <1317a8b2-2f12-416c-aa12-8d0262e0d3c9@oss.qualcomm.com>
Date: Sat, 14 Nov 2026 02:15:46 +0530
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
Subject: Re: [PATCH v2 4/6] tee: optee: Register TEE devices on the platform
 bus
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
To: Eric Biggers <ebiggers@kernel.org>,
        Bjorn Andersson
 <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        Sumit Garg <sumit.garg@oss.qualcomm.com>,
        Selvam Sathappan Periakaruppan <selvam.periakaruppan@oss.qualcomm.com>,
        Jens Wiklander <jens.wiklander@oss.qualcomm.com>
Cc: Basant Kumar <basantk@qti.qualcomm.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        op-tee@lists.trustedfirmware.org
References: <20261111-ice-migrate-tee-svc-v2-0-29d19f6c92ab@oss.qualcomm.com>
 <20261111-ice-migrate-tee-svc-v2-4-29d19f6c92ab@oss.qualcomm.com>
 <197d7d58-9791-483f-9a7f-40747f44d1ee@oss.qualcomm.com>
Content-Language: en-US
Organization: Qualcomm
In-Reply-To: <197d7d58-9791-483f-9a7f-40747f44d1ee@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: 6K-xPzp1Q8seb4ak1bMq0goJgcskmTE5
X-Authority-Analysis: v=2.4 cv=FdaiV5+6 c=1 sm=1 tr=0 ts=6af77702 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=KJEteu+P7FD/DYblE0u4eA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=b45o4kL6AAAA:8 a=EUspDBNiAAAA:8 a=EpkGB4z7we3iSK_TefgA:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22 a=dhdsR-PFWuPJUldTnwXm:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEzMDA4MSBTYWx0ZWRfX1VAoKKT0COrI
 loxAvkVcGoT+DUr5o4GmuFnuSPTk3KwpA6pVG1+v6+M4VM1Gc4o2qE4SikNQ4nPuWgwuDQNxegl
 FFxUTKjlOno9OuJYs0hqDvJyRRudnstVW0nArytmBml634MF14NvsNoA6WyHXTmr2ZZxSGmz7FB
 StsMgjlDFbFsAdHpmwD2AWhRca9JbACA+zztbEYuhe0hmKh741xer0kdnl/91knveaik2mSwgEK
 BLXOs3YNcfmLFDMxTkbo5/uMVBoUk6C8gIQfE+44iQ8UeqiTDfOihVGgZWZmsJkA/ixpz086iLn
 4jHvdxD8LzE4o77HEQdJvoH4kx8Nk0fbU/DPTHCqhwNOEhlFpsdI5juikNrKXsDXinDcIbfDWij
 Mmynj+NOsL9Mq23dUUpcGfymLjxAueTNoNl57XpFdtDnVmyKmNFO+m27/Cd7e+MdJ5XqGfm/nZp
 K/VZP2B7anbrlSLyxyA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEzMDA4MSBTYWx0ZWRfX+H78aCw1Hcpz
 23jNo8Cjo5Vfo6r5MMj7G/3Y7xujyfn+aC6Xk6lDYUGLMlxpOwdge/pH4vmxfnKRasCukIrBuIK
 JCVqizv5kfztW7v44qprIvT0txBfrH8=
X-Proofpoint-ORIG-GUID: 6K-xPzp1Q8seb4ak1bMq0goJgcskmTE5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-13_06,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0
 clxscore=1015 suspectscore=0 bulkscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611130081

Hi,

On 11-11-2026 08:27 pm, Harshal Dev wrote:
> + op-tee@lists.trustedfirmware.org, Jens Wiklander <jens.wiklander@oss.qualcomm.com>
> 
> On 11-11-2026 07:47 pm, Harshal Dev wrote:
>> The Qualcomm Inline Crypto Engine (ICE) driver is an independent platform
>> driver which polls on availability of a TEE interface (SCM driver) before
>> checking if the ICE secure service is supported by QTEE by querying the
>> qcom_scm_ice_available() API.
>>
>> The TEE subsystem currently does not provide any way to notify regarding
>> the availability of a TEE interface, i.e. whether QCOMTEE or OPTEE have
>> probed. And so when migrating to the TEE subsystem via an ICE TEE client
>> driver, ICE needs to defer probe until the OPTEE ICE Pseudo TA becomes
>> available on the TEE bus. This means that for OPTEE builds without the
>> ICE PTA, the ICE driver would indefintely defer probe and the dependent
>> UFS/SDHC storage driver will fail to come online.
>>
>> Add support for optionally registering the back-end TEE devices which
>> represent a particular TEE (say OPTEE) on the platform bus via the
>> tee_platform_device_register() API. 

I've been thinking a bit more about this. Instead of introducing a new
API on the TEE subsystem for re-registering the back-end TEE device on a
platform/auxiliary bus, can we just register the (OP)TEE device on the TEE
bus itself once all the Pseudo TAs have been enumerated?

This could be a reserved device with a reserved UUID that the client drivers
cannot interact with via the usual tee_open_session() function, and would be
returned an error.

A TEE client driver who wants to be notified once all the PTAs have been
enumerated on the TEE bus can register for this reserved OPTEE UUID and be
informed of this event via its registered probe() function for this device.

The TEE back-end device would be a sort of "end-of-line" marker for all the
PTAs on the TEE bus.

Let me know your thoughts.

Regards,
Harshal

>> This allows drivers which poll on
>> TEE secure interface availability to be notified even if the TEE service
>> itself is not supported.
>>
>> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
>> ---


