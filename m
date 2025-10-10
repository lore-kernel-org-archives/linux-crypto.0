Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2385231830;
	Fri, 10 Oct 2025 08:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760085662; cv=none; b=WM7KJmXMLOS8HUniTkxYoAmDLbYBqSUn+NgUT6CvhZvnD9u/WcJZTpWFgasTsEexNiUl6KVRKWpMTlZitBoXusfcb5b7CLi1TgB6uIj9j8KsAFCAI2YR109azD7Oj5cJyYmzJoOMWW9vbC16I/wmnShToDSsCGn8AB//uFmsWbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760085662; c=relaxed/simple;
	bh=XwpwIRkEIv4SYYLw+4YNpxTaDQ0UaMTxFWbqRVNXtoE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=k84yvXbL0ke0ZrbbT0wAGrugXg/qTdZnSDDjYV3NKL5P02d+jDkG280uhlO8LZndFfeeSPk73UIPBbpUB8tvEd7Q/jKTB2FXlXIvvEYMcg1eciFP5OsMnw7RMh6SL1IIi8SW4QlEqpQZujOaHHODmOre7GfyMj0kqFcWFg/1x5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ck0ksyAc; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ck0ksyAc"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 599KSeV4002113;
	Fri, 10 Oct 2025 08:40:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=v4zbV5
	rdgjMhCpYVqkKeNz8rDni5tZf7Rrcd5hEinMk=; b=ck0ksyAc8xrADG7aOq1qkc
	+1OfosiFUmEJoIO0+7lKjK5iqbuDDbsCEVzPQNLmJha83afHR2ugo91pGZI0TNdY
	wRWnWDmcrGhvj3h7UR6wqNLFdwfL3PNE4bMI0YXiEUmtn1VcPt8is174c7SlrIuL
	3qGomyyX9SIFoeWJS93K4gpASc+OKSShzxBb8yeohMKuOcJ2v4xjzUF1zpxybp5n
	MFnSCahVeH2CKIxUsOWVEQXiA+gOHqd12Oi2lYpeNWDZEPKrVlL7bmi1V8yfJ26f
	j7xA7Rtk++eqFAePy8JLI/gyN+dNbQV0qWjB+R7HQL8C3RA+nAB1ADcdyRAUSoMg
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49nv871frd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Oct 2025 08:40:54 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59A7utCi020997;
	Fri, 10 Oct 2025 08:40:53 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49nv9n0y9j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Oct 2025 08:40:53 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59A8en3i52363676
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Oct 2025 08:40:49 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BFD4C20043;
	Fri, 10 Oct 2025 08:40:49 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9A56C20040;
	Fri, 10 Oct 2025 08:40:49 +0000 (GMT)
Received: from [9.111.194.191] (unknown [9.111.194.191])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Oct 2025 08:40:49 +0000 (GMT)
Message-ID: <01d6f348-46af-4b4b-8f99-f10a75131cbc@linux.ibm.com>
Date: Fri, 10 Oct 2025 10:40:49 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] crypto: s390/phmac - Do not modify the req->nbytes
 value
From: Ingo Franzki <ifranzki@linux.ibm.com>
To: Harald Freudenberger <freude@linux.ibm.com>, herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        mpatocka@redhat.com, dengler@linux.ibm.com
References: <20251009160110.12829-1-freude@linux.ibm.com>
 <546f224a-70b9-4108-b6f9-4ddacc305b25@linux.ibm.com>
Content-Language: en-US, de-DE
In-Reply-To: <546f224a-70b9-4108-b6f9-4ddacc305b25@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hb91fQIT37XjnILwBYltQmEDY2QqMpeW
X-Proofpoint-ORIG-GUID: hb91fQIT37XjnILwBYltQmEDY2QqMpeW
X-Authority-Analysis: v=2.4 cv=MKNtWcZl c=1 sm=1 tr=0 ts=68e8c696 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=HFL11G2TRnG_llR-b0MA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfX1XLtMsx7xBGJ
 0rzx1ZnWii1lIV5bDswWimkOdfk82GGiLsdzBkNLzQ1id8Gckz5VhwC+i/WG8Nvru96SsofSxSs
 v2p065HECSQRJqvXGFD/UzpEHyi4khqPpyD0pIcByJiebKJMqZE0GzXhxMXaXnqHK/CMkuZ8zt1
 8Ecmn2mA4Wrn2ZhTZB7UlVNxUJ3ZdRcbLT+LO0vGWqgV4kCDjZr5dUNOfQC8faIAFokRhYaaGv6
 AC7WH2EvA3hz0+PcbatqFIkmHU4BPYl3V5/Qbp7L9o1YpD408ReqavSYMPEIxwz8uND2I1pWZ7N
 4cysQq5GwlNKzJugEiZm1hcqPcFSM0ALNV2A9s1eDZKraq9lFdJQ2ldM9lE/7vD2P0DGygFr4sP
 uud9gVCoH4NSTDRl7/HswWg0zAB0QQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-10_01,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0 spamscore=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510020000
 definitions=main-2510080121

On 10.10.2025 09:55, Ingo Franzki wrote:
> On 09.10.2025 18:01, Harald Freudenberger wrote:
>> There was a failure reported by the phmac only in combination
>> with dm-crypt where the phmac is used as the integrity check
>> mechanism. A pseudo phmac which was implemented just as an
>> asynchronous wrapper around the synchronous hmac algorithm did
>> not show this failure. After some debugging the reason is clear:
>> The crypto aead layer obvious uses the req->nbytes value after
>> the verification algorithm is through and finished with the
>> request. If the req->nbytes value has been modified the aead
>> layer will react with -EBADMSG to the caller (dm-crypt).

I guess the place where nbytes is used after the verification is in
crypto_authenc_decrypt_tail().  This is called either directly by
crypto_authenc_decrypt() if crypto_ahash_digest() completed synchronously,
or in case or async completion, via the authenc_verify_ahash_done() callback.

crypto_authenc_decrypt_tail() then does:

	scatterwalk_map_and_copy(ihash, req->src, ahreq->nbytes, authsize, 0);

	if (crypto_memneq(ihash, ahreq->result, authsize))
		return -EBADMSG;

Where the scatterwalk_map_and_copy() uses the ahreq->nbytes value to know the
amount of bytes to copy. If this is zero then the copied ihash value is wrong and
thus it returns -EBADMSG.

Not sure if the number of bytes could be saved elsewhere, to allow that the
requests's nbytes can be modified by the digest (if this is desired to be allowed)?
Otherwise, a comment in the header file that nbytes must not be modified might be useful.

>>
>> Unfortunately the phmac implementation used the req->nbytes
>> field on combined operations (finup, digest) to track the
>> state: with req->nbytes > 0 the update needs to be processed,
>> while req->nbytes == 0 means to do the final operation. For
>> this purpose the req->nbytes field was set to 0 after successful
>> update operation. This worked fine and all tests succeeded but
>> only failed with aead use as dm-crypt with verify uses it.
>>
>> Fixed by a slight rework on the phmac implementation. There is
>> now a new field async_op in the request context which tracks
>> the (asynch) operation to process. So the 'state' via req->nbytes
>> is not needed any more and now this field is untouched and may
>> be evaluated even after a request is processed by the phmac
>> implementation.
>>
>> Fixes: cbbc675506cc ("crypto: s390 - New s390 specific protected key hash phmac")
>> Reported-by: Ingo Franzki <ifranzki@linux.ibm.com>
>> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
>> ---
>>  arch/s390/crypto/phmac_s390.c | 52 +++++++++++++++++++++++------------
>>  1 file changed, 34 insertions(+), 18 deletions(-)
> 
> I can confirm that this fixes the failures reported at https://lore.kernel.org/dm-devel/fec83aad-c38b-4617-bb9a-0b9827125d79@linux.ibm.com/T/#u
> Also, having the operation in the request context makes the code even more clear IMHO.
> 
> Tested-by: Ingo Franzki <ifranzki@linux.ibm.com>
> Reviewed-by: Ingo Franzki <ifranzki@linux.ibm.com>
> 
> 


-- 
Ingo Franzki
eMail: ifranzki@linux.ibm.com  
Linux on IBM Z Development, Schoenaicher Str. 220, 71032 Boeblingen, Germany

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Wolfgang Wendt
Geschäftsführung: David Faller
Sitz der Gesellschaft: Böblingen / Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM DATA Privacy Statement: https://www.ibm.com/privacy/us/en/
