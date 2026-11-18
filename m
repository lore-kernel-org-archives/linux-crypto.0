Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032533;
	b=4CgF2e7dfIYTzvc1f3THbCGi70PILrmm8DSxrhQlwmYti+N+SJ3xq/NHX0Qm1fyAP0P8
	 ywSkAgMctUoBIwvBAw1Far9PzL1x8Wqf3LqHtW/Y9P3cKdE9DDvpO5CT52j+1BVtqiEHz
	 SZadnCtdKrg630eNF888yCzdcsY1eHrd6OUHYGX3qtRg/k9ivPuqwYyIFIbeEPko4+2s8
	 1D1TWFrj1sNiT5dQyY+wIHb3tgusZ9JZGG68MwmdvIkJPF5NWv6qHsJU8u72HTqgqIRaT
	 OyLlR0f0S/JOJ6e3cTpaxlBWjV61SSlVg7tbLIHEVzPjGJZ4KNMqNsVDHF9jHMJdkVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032533;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-TM-AS-GCONF:
	 X-Proofpoint-Reinject:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=sdZwJGrljf/aq3KiOPvW8pwdl5/t+4Q9gbycn487dlw=;
	b=GxXK3JSoadMDKmIH4NJR5in3pAqHygjh0lGDCFwQFxXg2vuIsIEulp7n88+Nn+V/xxQa
	 /gW9pC+ZH96OctC1mOAlt1tAvqoCIN1ne3bXdxupZoOaqk5rRncxturkzDeiIR59pYmRC
	 Jg3rP3hSGv4X5Dq4TKCgjceu1drm2UKAcIXgGuNQQD+N1eFxcmua+snutkkqBhEawQCF9
	 h4JxGjwodPdUm/JhNuYRKNnojCpp7pyG7hWG7rzplyuz1W+Bf0jb3UIl+P2JoGcde+zxQ
	 YKStzQ0RkCqmUtm9OoX6eEai7r1ET7L6F/DtOrbCpXe1Qn+X3EFzRMyk0dTRXCTC/Ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=YQ8hoMWV;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19F6606A31C;
	Wed, 18 Nov 2026 20:08:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C19F6606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=YQ8hoMWV
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AIJQ9Vw755960;
	Wed, 18 Nov 2026 20:08:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=sdZwJG
	rljf/aq3KiOPvW8pwdl5/t+4Q9gbycn487dlw=; b=YQ8hoMWVFmrIikkdFNeW5W
	KiJk40+P1pR4rOOWfLE3HviqqDOwuGUhqSg6QF1nJqkfTSpuO47xmotHa8w7bKYr
	nuKK+cAp48TRppLSg1TLoSo29P6qLLVCUBJM2Vs51UvRBORta428Zew0LPtDdVB4
	+tX1VhvkDG5grFhnsDhvuYnqrIT0Olz9uSUNKy10GLluEkyFaCzjGEzso54sUe4i
	yhYYJ+AjvsJD0H52UKZDBECyNxmKGSCX2pJqcupRiGDHNuKzkH/Hw0VuZ1tZs9b/
	YDBinqj6+klOwDqDv3iiufO53xYnan2XxfUJwYlImjk5BCIoWLPEO/1iEJNRZi7w
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j105vvaus-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 18 Nov 2026 20:08:23 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AIJKGrc1356271;
	Wed, 18 Nov 2026 20:08:22 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j067nhay9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Nov 2026 20:08:22 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AIK8MSK24249052
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Nov 2026 20:08:22 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E79DE5805D;
	Wed, 18 Nov 2026 20:08:21 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8E83758059;
	Wed, 18 Nov 2026 20:08:20 +0000 (GMT)
Received: from [9.47.158.153] (unknown [9.47.158.153])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 18 Nov 2026 20:08:20 +0000 (GMT)
Message-ID: <f38f6d32-16d3-4986-8d6a-9d65517f5317@linux.ibm.com>
Date: Wed, 18 Nov 2026 15:08:19 -0500
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
Subject: Re: [PATCH 1/2] KEYS: fix signature length passed to
 KEYCTL_PKEY_VERIFY
To: florian.bauckholt@cispa.de, David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>, Lukas Wunner <lukas@wunner.de>,
        Ignat Korchagin <ignat@linux.win>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, Hui Peng <benquike@gmail.com>,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20261111-keyctl-pkey-fixes-v1-0-934ebaa267a7@cispa.de>
 <20261111-keyctl-pkey-fixes-v1-1-934ebaa267a7@cispa.de>
Content-Language: en-US
From: Stefan Berger <stefanb@linux.ibm.com>
In-Reply-To: <20261111-keyctl-pkey-fixes-v1-1-934ebaa267a7@cispa.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: HKXXmG-UC4fI07WkkUIKC_mzZd1qDZ8L
X-Authority-Analysis: v=2.4 cv=Z8x5j3RA c=1 sm=1 tr=0 ts=6afe05b7 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=fjpi1DcuFi9e4zuLaT0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: tqJB5qfQ6hOs4knfl_yxa9eK_24yXY4i
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE4MDA3NyBTYWx0ZWRfXzX4OhltihA4R
 UjGEpAfYLdZIsa4xf1+UXd1ahOexugaiV5mO99pHy2W4TiwIPCp2DOYNENk8CDKrF/LCaB9IzYW
 cHXHofYmbkjF6QtfAEFlf6+qbc8C8vA=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE4MDA3NyBTYWx0ZWRfXwCwSUwf0dsZa
 1nFeFGeo7vv/dnyEuuRVK6u4Hpuw3TtvSCtaN4wjakjj82yChlWHzk0xR9+K9vQQF0f02iWF21i
 WqnUQXWsFwkTMuueCwCzOxqsW2vJTUpfaALf1O1CHw92uxXRc5nXCMcCIFPYoARtKaOw1xzP/0Q
 eNcRThOMpS59MOPl6v7OVbjaDnnLuvj9lli/RArQy/EfsbeOqoKzuKmJ6gw4A+vDrPPYWD39nb5
 2xE/+0+wz2DKrBWT8OGat/lJT4pR6RupSbmaueYIuUIkU+QuA05RndKt3bWm/pvuO6eFMRmun0b
 9Sv9oQH2zrBXOyUWYTnIF5HOLfxvBx0niMlD4TNaBplrGzi7eL0EyAPCqWWkVki5l7cTEyWx9Sl
 dX8GoqGH7sT5zFageKRgRQyvwwQBXFMpTQ955Qrto9viPavPscL7Ty7jNrlYDgf5XagQcqw412D
 r4IuG8dt35wtodx5kSA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-18_06,2026-11-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 adultscore=0 bulkscore=0 clxscore=1011 impostorscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611180077



On 11/11/26 10:56 AM, Florian Bauckholt via B4 Relay wrote:
> From: Florian Bauckholt <florian.bauckholt@cispa.de>
> 
> Commit cb481e59ea6c ("KEYS: fix overflow in keyctl_pkey_params_get_2()")
> made keyctl_pkey_params_get_2() set params->out_len to the maximum
> output size of the operation instead of the size provided by the caller.
> It does so for KEYCTL_PKEY_VERIFY as well, but verify has no output
> buffer: out_len shares a union with in2_len, the length of the
> signature.
> 
> As a result keyctl_pkey_verify() ignores the signature length passed by
> the caller. It copies max_sig_size bytes from the signature pointer and
> passes max_sig_size as the signature size to the verification.
> 
> This makes no difference for signatures that are always max_sig_size
> bytes long, such as RSA. A shorter signature, e.g. a DER-encoded ECDSA
> signature, is followed by whatever is behind it in the caller's memory,
> or the call fails with -EFAULT if that memory is not readable. The
> x962 ECDSA template currently ignores data following the signature,
> which hides the problem.
> 
> Use the length provided by the caller, which has already been checked
> against max_sig_size.
> 
> Fixes: cb481e59ea6c ("KEYS: fix overflow in keyctl_pkey_params_get_2()")
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/all/20260919221742.3709658-1-benquike@gmail.com/
> Signed-off-by: Florian Bauckholt <florian.bauckholt@cispa.de>

Tested-by: Stefan Berger <stefanb@linux.ibm.com>

> ---
>   security/keys/keyctl_pkey.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/security/keys/keyctl_pkey.c b/security/keys/keyctl_pkey.c
> index 15b6bf6399b5..794fa3d01911 100644
> --- a/security/keys/keyctl_pkey.c
> +++ b/security/keys/keyctl_pkey.c
> @@ -160,7 +160,7 @@ static int keyctl_pkey_params_get_2(const struct keyctl_pkey_params __user *_par
>   		    uparams.in2_len > info.max_sig_size)
>   			return -EINVAL;
>   
> -		params->out_len = info.max_sig_size;
> +		params->in2_len = uparams.in2_len;
>   		break;
>   	default:
>   		return -EOPNOTSUPP;
> 

