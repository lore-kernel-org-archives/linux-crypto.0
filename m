Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794526751;
	b=QTe+rE8VJmOkvMZCmNFtkg/HCJFE7ZWaIM8R9HEAKpUwXimLi1cNFi9bR/5ts4wMhCjo
	 woXmVez0cef9RIF4Jf/y5uF3/k27UUSQWYIATVOZ9f5AcOKajHX308248FLEwLsDOJdO/
	 142RJV9N0iWFE/e+QKMwNb9SiU3JIb7a5DNaWi4BQrPHlYo4SK4QMIbwKyZNv+9wwSQuz
	 IPYtyoLcuy4wGvzx/ycXJQTt0JpIO3L3tsX3F/ZV0Rs2NvTs5pHuzNdIAxKKhfqdSic+F
	 ICvIA3w1TkFb24KHc3m4MlTfpYo5CunLsH6iZJHogQcTEkJrFA8UHBFrT7TuRHfZqFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794526751;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:From:To:Cc:References:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-TM-AS-GCONF:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=4zVGoVjCRdgaWBt94fG/mAD1qJpqINHzjmtczK3XPec=;
	b=MtqIrX9tfxcyOu/LjuM/aV6MX0HbmC1YDzCmUjJhIwdAabuy2T+HsTblERNG7PfSChoM
	 CIzyn9dwYhdccu6y/wWLuVWJJXNPwj9GDOJp5lV9Y2kZtnrhyqSoKzDHMZFfDZG62cf3Z
	 tb2R6l2PrGZP1sDzly+BB7eMOCph7dFuboa2FAKcsfqRlf+vuCmkVYcZOJ74dnmj1Oxro
	 iM/KPf0bIjzC2oWxyw2nm28E9SbQM0X5XfA93xbw+5DoYELDAFChEwwyiidMAuARpdXue
	 PGI1M5TBzQ4RG7PUjsQ/6G+2+6uK35pQPNFOF6HUZEYZjSB3BQvTZmfCxF4ZrdbD31w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=trU3VAvW;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBD3606A321;
	Thu, 12 Nov 2026 23:39:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8EBD3606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=trU3VAvW
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ACNEaB51062135;
	Thu, 12 Nov 2026 23:38:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=4zVGoV
	jCRdgaWBt94fG/mAD1qJpqINHzjmtczK3XPec=; b=trU3VAvWaJDmxLu3pdiPZw
	wBim2nu1uoYTG+3Is84O1VmzrRVpEc9KnEqohJcMJedEEGXuEVN56ITKZdHBzpNm
	pANxU+WwkzYsNKw3zftLPD/vQetu22B8AiaHRtTIFZ9BpcFaPRNqrZ3Fqc5RWm5e
	tgoN7MnLHFigcxsViq6V3F+u430pvZ6n1xMbV+PciQmdiFtyafvK+pFgOdRwJdLf
	/N9t91IOWnyvongnjs92fzuELwRONXGg8SaLk61qTfhNZxM3SnxCXSNVenK2V1PP
	Ngokx61F+F2zUoWM0RwrvxaTp9nONOHESf1lC9TTP7aCfzrgGEL2zpu8H0t1o0VQ
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hssdm12j1-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Nov 2026 23:38:48 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6ACNJpoQ1433233;
	Thu, 12 Nov 2026 23:38:48 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hvkq0y89u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Nov 2026 23:38:48 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6ACNclgC19202598
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Nov 2026 23:38:47 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AF76E5804E;
	Thu, 12 Nov 2026 23:38:47 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DA27B5803F;
	Thu, 12 Nov 2026 23:38:46 +0000 (GMT)
Received: from [9.47.158.153] (unknown [9.47.158.153])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 12 Nov 2026 23:38:46 +0000 (GMT)
Message-ID: <d3a49bde-769f-48a9-ab1b-0374d3d4753e@linux.ibm.com>
Date: Thu, 12 Nov 2026 18:38:46 -0500
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
Subject: Re: [PATCH] crypto: ecdsa - Reject non-DER X9.62 signatures
From: Stefan Berger <stefanb@linux.ibm.com>
To: florian.bauckholt@cispa.de, Lukas Wunner <lukas@wunner.de>,
        Ignat Korchagin <ignat@linux.win>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jarkko Sakkinen <jarkko@kernel.org>
Cc: linux-crypto@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20261112-ecdsa-x962-der-v1-1-36b24c5f5e11@cispa.de>
 <e852580d-9e18-4733-a431-2db8c5f9c2a3@linux.ibm.com>
Content-Language: en-US
In-Reply-To: <e852580d-9e18-4733-a431-2db8c5f9c2a3@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=POqaavqC c=1 sm=1 tr=0 ts=6af64e08 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=NEAV23lmAAAA:8
 a=mwj20vjdbvDfV6NRdAIA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDA5MiBTYWx0ZWRfX9SHWQoKPC6oq
 U/znpCb7CofyXopXG92JmttE19o7Agr5y6IIhb1XnBczeYMp9CjVfwX6Xs/3YDY0fkkHRRXAhft
 ewxgrtbhjLUrd8im5oAWJSkgkhNJHEvuKYcGzQj0/t0Ky8wNOivgGSxLPEL+CXR/g3smdaJdEF9
 j4ciCjU9WW9UqD6Deb9i6RU8JR34J8IRDi+4ox6KGQ2bP/IlqrT6iwVjF2dRP8gPYKReLMOH3Zo
 nXXHDdzmKG0FtppdbbPs6q93DGTRz1RnBhqYVCjpfEMp0f8sKtgEDNJqOi3+IyQT8CK8Pz32gPA
 wejyjidb4kbizwWBphjDfEcngkKC4yz6eQfCEvskaxnEuYUj57nE8HyHd0zErBsef6yOJhsCyVk
 0LDbSRd1mAROU3WrxcnOBZpfHM/2G5Fd8Q/1Wehxvf2g92xY25u1FH7+UuprGvuVMRAxpGyiwCe
 UmEBTUYHLFdBFo1DnIg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDA5MiBTYWx0ZWRfX+kz9qZD7TgXo
 YEXEYm19zDJLDs+I0BE5MeQrVYtqaUE1spaNXChQ9m/gp7tTi/BPb7MpFLwOOivvr/3cg90pFSQ
 r2HF8YgIpdLMroINeO4ExCB2rTWOr/0=
X-Proofpoint-ORIG-GUID: 6lFRnLOOA61UAmLwNkwJR1cYIqylLTiU
X-Proofpoint-GUID: 6lFRnLOOA61UAmLwNkwJR1cYIqylLTiU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_04,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 impostorscore=0 malwarescore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120092



On 11/12/26 12:06 PM, Stefan Berger wrote:
> 
> 
> On 11/12/26 5:47 AM, Florian Bauckholt via B4 Relay wrote:
>> From: Florian Bauckholt <florian.bauckholt@cispa.de>
>>
>> The x962(ecdsa-nist-*) template decodes Ecdsa-Sig-Value with the
>> generic BER decoder, and ecdsa_get_signature_rs() only strips one
>> leading zero byte without looking at the INTEGER's sign or encoding.
>> As a result the following encodings of a valid signature are accepted
>> as well:
>>
>>   - a SEQUENCE tag without the constructed bit (0x10 instead of 0x30),
>>     as the decoder ignores that bit when matching a constructed tag
>>   - non-minimal length encodings of the SEQUENCE, r or s (long form
>>     where the short form fits, or padded with zero bytes)
>>   - indefinite length for the SEQUENCE
>>   - data following the SEQUENCE (the decoder does not check that the
>>     whole buffer was consumed)
>>   - r or s with the most significant bit set but without the leading
>>     zero byte, i.e. a negative INTEGER read as positive
>>   - r or s with a superfluous leading zero byte
>>
> 
> I have a user-space test suite here:
> https://github.com/stefanberger/eckey-testing
> 
> It tries to load openssl-generated self-signed certs into the kernel and 
> this fails now:
> 
> $ ./test-ecc-kernel-keys.sh
> Testing with curves:  prime256v1 secp384r1 secp521r1
> Testing with hashes:  sha224 sha256 sha384 sha512 sha3-256 sha3-384 
> sha3-512
> Good: curve: prime256v1 hash:   sha224 keyid: 927415098 
> keyctl_pkey_verify: Invalid argument
> 
> 
> 
>> RFC 3279 section 2.2.3 and SEC 1 section C.5 require Ecdsa-Sig-Value to
>> be DER-encoded, so all of these are invalid and should be rejected.
>>
>> This is a behaviour change for every user of the x962 template (X.509

I would say a 'potential but unlikely behaviour change' because if you 
signed with a tool (e.g., OpenSSL) that created properly (DER-)formatted 
signatures in X.509 certificates, then those signatures still verify 
with your patch applied. I would assume that most people signed with 
such a tool. In your patch you seem to add more tests for proper DER 
formatting that all existing x.509 certs and signatures should meet, right?

>> certificates, module and IMA signatures, KEYCTL_PKEY_VERIFY): signatures
>> that are valid ECDSA signatures but are not DER-encoded used to verify
>> and are now rejected with -EINVAL. The p1363 template is not affected.

What breaks the signature verification test in my test suite currently 
was pointed out by AI. For signature verifications using the 
KEYCTL_PKEY_VERIFY interface, it currently would pass along an input 
size of 72 bytes for a secp256r1 signature, which is the max. size, but 
this does not always correspond to the application provided signature 
size, which may for example be just 71 bytes. Your patch now detects 
that commit cb481e59ea6ca extended the input buffer by a byte that 
shouldn't be there. So this fixes it for me and is an error introduced 
for signature verification in that patch. Bbefore that patch it used to 
set params->out_len = uparams.out_len which is equivalent to 
params->in2_len = uparams->in2_len per that union used in that structure.

index 15b6bf6399b5..d27f8b22224a 100644
--- a/security/keys/keyctl_pkey.c
+++ b/security/keys/keyctl_pkey.c
@@ -160,7 +160,7 @@ static int keyctl_pkey_params_get_2(const struct 
keyctl_pkey_params __user *_par
                     uparams.in2_len > info.max_sig_size)
                         return -EINVAL;

-               params->out_len = info.max_sig_size;
+               params->in2_len = uparams.in2_len;
                 break;
         default:
                 return -EOPNOTSUPP;


