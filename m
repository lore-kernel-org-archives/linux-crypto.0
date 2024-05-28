Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF9F16727D;
	Tue, 28 May 2024 12:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716899870; cv=none; b=MjtVBWPxBJFx9/ro4ctt3MIko9ptVxBuOw17S647mXQGRZv4kWP6omrQ+m+RbL08FJqKv32twkFaaaGnQwviW1bmN7xXPW+ROWootv2S0ma3vf8jt7jpMb8dnlLDj1FcGDnps3KYaVW5gzLBn2DCwFRpfv7K3Shq8ASK2eHTflM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716899870; c=relaxed/simple;
	bh=hd9Ak4slR6v9infr9CoTSeDmxLojFf7x+Z23XzbdJ7U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tYTHfu8KGNgmuU63vSJXotNiUMFLT9m5Bhul2+DKc8WzQhpBIhlcYGUOpQbeiTSx+ueZCk+5g1l+LVF7xiyZcOmjsOTx0WxNOigzU7GiKkXbcm5Lkj0x4lIQVday4FoMcS8AvfCIgCr2yHs4hwoexH5TyplUHVpMjTkzx0iMooA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pk+PGCP2; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pk+PGCP2"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44SCWO2l011133;
	Tue, 28 May 2024 12:37:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=pp1;
 bh=PvOf0uIMxDxLmNDeH9tJ2VfYkeNXKpQfJFPurb0OLqI=;
 b=pk+PGCP2d4s/F4c9UavntZmGt/deyvRXU2gfPHz2oiQZ84kVh2uKIcwvomo1PQ8GXjMV
 79eGUtWol/1Kw3oaP2FGRLGy+7bQa1p1wrEYDPzfSss6fVAC5bQKHrnrwt0rtIx8modG
 nXHPRZzpvPx+INMlKEH4cJfXF2AmRLeFAMGp38jFniYqWgC3iRIUhd5QmZ5GDrEPjNw0
 DRzF1SDNixow7p6AG8vOMpEY3FzXEwRXSm2qpErUpb3Nhh9Hm5KlInnWbTl+xZBFWp6a
 RVytdKiamaLZkZB+LETgcz6WNRaAyX5lE8+ixVJ4DIh3ICQGue4JEazmgyivh48lbdR+ mw== 
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ydfc480by-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 May 2024 12:37:41 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44SBlWXA006716;
	Tue, 28 May 2024 12:37:40 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3ybtatf342-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 May 2024 12:37:40 +0000
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44SCbcRx47317360
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 May 2024 12:37:40 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 25B885805B;
	Tue, 28 May 2024 12:37:38 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8DEBA58055;
	Tue, 28 May 2024 12:37:37 +0000 (GMT)
Received: from [9.47.158.152] (unknown [9.47.158.152])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 28 May 2024 12:37:37 +0000 (GMT)
Message-ID: <b5ff9003-065f-437f-bf6b-7f1ae0a0364a@linux.ibm.com>
Date: Tue, 28 May 2024 08:37:37 -0400
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ecdsa: Fix the public key format description
To: Jarkko Sakkinen <jarkko@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
References: <20240527202840.4818-1-jarkko@kernel.org>
 <D1KQDPOZRWCW.1763CCYF1B84X@kernel.org>
 <D1KRILI1KRQ8.2CNPU7PFES0VI@kernel.org>
 <D1KRXI87G4S0.1ROKTQENIZHT7@kernel.org>
 <D1KS7LCALKD4.1J13QGYGZ6LBW@kernel.org>
 <D1KSLKGUWGFO.21T4OBXQQ88D@kernel.org> <D1KSSWD7FA94.5705Z3J7LKZA@kernel.org>
Content-Language: en-US
From: Stefan Berger <stefanb@linux.ibm.com>
In-Reply-To: <D1KSSWD7FA94.5705Z3J7LKZA@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8l5eGJnZtAtglmTQ42pXHNf36TkcJNfu
X-Proofpoint-ORIG-GUID: 8l5eGJnZtAtglmTQ42pXHNf36TkcJNfu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-28_09,2024-05-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 mlxscore=0 phishscore=0
 malwarescore=0 impostorscore=0 clxscore=1015 mlxlogscore=892
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2405010000 definitions=main-2405280095



On 5/27/24 18:59, Jarkko Sakkinen wrote:
> On Tue May 28, 2024 at 1:49 AM EEST, Jarkko Sakkinen wrote:
>> On Tue May 28, 2024 at 1:31 AM EEST, Jarkko Sakkinen wrote:
>>>>          ret = crypto_akcipher_set_pub_key(tfm, data, 3 * x_size + 1);
>>
>> Noticed this mistake i.e. fixed it with "2 * x_size + 1"
>>
>> This is results earlier failure:
>>
>> ecdsa: (tpm2_key_ecdsa_query+0x10d/0x170 <- ecdsa_set_pub_key) arg1=0xffffffea
>>
>> Totally lost with the expected input format after trying out various
>> options.
> 
> OK got it working with:
> 
>          ptr = &data[0];
>          *ptr++ = 0x04; /* uncompressed */
>          memcpy(&ptr[0], &x[2], x_size);
>          memcpy(&ptr[x_size], &x[2 + x_size + 2], x_size);
>          ret = crypto_akcipher_set_pub_key(tfm, data, 2 * x_size + 1);
>          crypto_free_akcipher(tfm);
> 
> Had still a few "off-bys".
> 
> Makes me wonder why this is not in ASN.1.
> E.g. TPM2 stuff and for instance RSA code takes ASN.1.
> 
> This all and the required prefix byte really should be explained in
> the documentation of this function. I.e. follows the RFC in the sense
> that number is big-endian and has the prefix byte, but it does not
> follow it in the sense that x and y are not in input octect strings.
> 
> Why is that? Does not feel right intuitively.

You found the appropriate documentation -- thanks.
The old function documentation stated that it takes 'raw uncompressed 
key data from an x509 certificate'. So, one should take the data from 
the x509 certificate starting with 0x04 as shown here.

         Subject Public Key Info:
             Public Key Algorithm: id-ecPublicKey
                 Public-Key: (256 bit)
                 pub:
                     04:c0:55:b4:68:7a:80:bc:0e:ba:b3:66:40:5f:07:
                     aa:27:d4:da:b4:79:2e:4d:a4:f4:f4:33:b1:22:6a:
                     6c:e9:8c:30:8d:6c:df:ac:65:f0:93:d9:7a:70:7a:
                     05:dc:7a:7d:b3:91:18:22:9a:5c:86:9a:87:72:3b:
                     32:1a:92:81:1d
                 ASN1 OID: prime256v1
                 NIST CURVE: P-256


These are two concatenated x & y coordinates with a leading 0x4. The 
numbers are not ints in ASN.1 format but 'plain' integers.

A *signature*, however, is in ASN.1:

     Signature Value:
         30:45:02:21:00:d9:d7:64:ba:5d:03:07:ee:20:a0:12:16:46:
         31:e6:8e:66:0c:17:0d:74:07:87:58:5a:13:fc:14:62:98:9a:
         99:02:20:59:ff:29:9c:52:b9:0a:35:3c:4b:03:bb:47:0e:c8:
         3e:2d:cb:3e:1c:d3:51:88:91:b1:40:e3:03:86:1b:2a:e8

30:45 => sequence containing 69 bytes
   02:21: => first coordinate with 0x21 bytes
     00:d9 => 0x21 bytes of ASN.1 integer with leading 0 to make the 
following 0x20-byte integer a positive number (its most significant bit 
is set).
   02:20: => int with 0x20 bytes
    ...



> 
> BR, Jarkko
