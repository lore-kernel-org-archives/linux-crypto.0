Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE849263C8C;
	Fri, 10 Oct 2025 07:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760082927; cv=none; b=Zg1Qm/VNEgWnmku7Ez9bfeG3Tju2u8830fXmF/7K3zvY+bGPhnz0dQ2fVD5rpSlKq/TrqeRVQ1byz0E27vfYbloiQqCBCOCKHM9XUTupuDkchgzE9DqAcBAe7Zldy+DWF5a8UhRC/sccW2n5xXNocK0LPcwWAGL8SO+0EC5V010=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760082927; c=relaxed/simple;
	bh=VvcViXm2vn5ZWdL1BLjjd6jA3rX3kqdbB1aplxCTGng=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZoFaUGX9yf6qryVLKmW5F4sqQckhrCvaQ2ptWxF8eK4pudV27O1V9DLRhixscywdpy01hSzSJqPVgsz+h/hk2bP3O2uvkometrb53PWG1iSzRr9G9dNOl5Sph9mko2h+qcLW7n8WVXo58YZnJc0LM+hp1o7JloAYztM98VEBWxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tV81qmI8; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tV81qmI8"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59A0HRpS031361;
	Fri, 10 Oct 2025 07:55:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ehBoT9
	J3zeJZizLM6hGKNGcU7YX63TYI4sw2gzuob4k=; b=tV81qmI8cYGbylgPIcFEVb
	B7U/SNJMtPBH4sNQr8V3TTPQz57C8dznoAJEek/RHFy4ghn/xuy3VbAJ88/whN63
	gN8vxK08JoZsmdol06ZAsw8wzZejAH7K3HKDxP+8sCsO70czeobuH1iEayvGHa3k
	TsHKIbg7ja123cMxP8uqTeIBy/hrsiFYZvx9j/gPomMsG7VtPMSd/huvGQHJNZg4
	SGztAvOGeeIEHmAitmzZJhtJX7CmnVKxwEp20ofQwXbul76dHz/fC027iPBC0S4v
	0H0ignWtps+RRRsVbzZZh/HhQF86eEEGx+irpjgV+4MopP8alajFod93TxtbYgTw
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49nv81s7hr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Oct 2025 07:55:20 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59A7UBDl021043;
	Fri, 10 Oct 2025 07:55:16 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 49nv8srs23-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Oct 2025 07:55:16 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59A7tDlJ60293466
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Oct 2025 07:55:13 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 86E69201FC;
	Fri, 10 Oct 2025 07:55:11 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 612A2201FA;
	Fri, 10 Oct 2025 07:55:11 +0000 (GMT)
Received: from [9.111.194.191] (unknown [9.111.194.191])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Oct 2025 07:55:11 +0000 (GMT)
Message-ID: <546f224a-70b9-4108-b6f9-4ddacc305b25@linux.ibm.com>
Date: Fri, 10 Oct 2025 09:55:11 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] crypto: s390/phmac - Do not modify the req->nbytes
 value
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        herbert@gondor.apana.org.au, mpatocka@redhat.com,
        dengler@linux.ibm.com
References: <20251009160110.12829-1-freude@linux.ibm.com>
Content-Language: en-US, de-DE
From: Ingo Franzki <ifranzki@linux.ibm.com>
In-Reply-To: <20251009160110.12829-1-freude@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xjVBw_SFFXpcOG9rP6eGNrF5CeEB3o-5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfX+5mWHu8om/Ir
 AgUEXemEFArMrmsw3jDd79nRrAOsgcr+6D7cx5sC7TvPJO1NKZKkH+hH5u6ifqoLCJ6uqiJyiW0
 mLXBV6b7/6m4PKpyb8FWVBIjLGScRMretJ7lBdgGB+8wKQCJi6nICv/eoGAs6cQekjrY/0fwAJC
 zYxq6LTPpFsPAW8Yffzkz9GlSbrY2IBynZHH2F+/AOV0+oWAiDEwOJZDE742R1XjF3ztAlkE6Ei
 U7p3H5RkNAN70GB3fvcpmBcr6d+Vmw2yMYwSAc32SumA0bXrmcAxcFdSZU4hytull8RxYPrJLyK
 eTmBsgh8u5DQeveeNyHQP7AOZhH70VXAbWozNrHOuVBCyvZlOCdKKTLavf9GCQP0tH/9a++FV/r
 zlkbQ57xj/iAwQ9doQ6nXB1i0AAQMA==
X-Authority-Analysis: v=2.4 cv=cKntc1eN c=1 sm=1 tr=0 ts=68e8bbe8 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=UKNKdhry9jmQh5V8IYUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: xjVBw_SFFXpcOG9rP6eGNrF5CeEB3o-5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-10_01,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 impostorscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 phishscore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510080121

On 09.10.2025 18:01, Harald Freudenberger wrote:
> There was a failure reported by the phmac only in combination
> with dm-crypt where the phmac is used as the integrity check
> mechanism. A pseudo phmac which was implemented just as an
> asynchronous wrapper around the synchronous hmac algorithm did
> not show this failure. After some debugging the reason is clear:
> The crypto aead layer obvious uses the req->nbytes value after
> the verification algorithm is through and finished with the
> request. If the req->nbytes value has been modified the aead
> layer will react with -EBADMSG to the caller (dm-crypt).
> 
> Unfortunately the phmac implementation used the req->nbytes
> field on combined operations (finup, digest) to track the
> state: with req->nbytes > 0 the update needs to be processed,
> while req->nbytes == 0 means to do the final operation. For
> this purpose the req->nbytes field was set to 0 after successful
> update operation. This worked fine and all tests succeeded but
> only failed with aead use as dm-crypt with verify uses it.
> 
> Fixed by a slight rework on the phmac implementation. There is
> now a new field async_op in the request context which tracks
> the (asynch) operation to process. So the 'state' via req->nbytes
> is not needed any more and now this field is untouched and may
> be evaluated even after a request is processed by the phmac
> implementation.
> 
> Fixes: cbbc675506cc ("crypto: s390 - New s390 specific protected key hash phmac")
> Reported-by: Ingo Franzki <ifranzki@linux.ibm.com>
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> ---
>  arch/s390/crypto/phmac_s390.c | 52 +++++++++++++++++++++++------------
>  1 file changed, 34 insertions(+), 18 deletions(-)

I can confirm that this fixes the failures reported at https://lore.kernel.org/dm-devel/fec83aad-c38b-4617-bb9a-0b9827125d79@linux.ibm.com/T/#u
Also, having the operation in the request context makes the code even more clear IMHO.

Tested-by: Ingo Franzki <ifranzki@linux.ibm.com>
Reviewed-by: Ingo Franzki <ifranzki@linux.ibm.com>


-- 
Ingo Franzki
eMail: ifranzki@linux.ibm.com  
Linux on IBM Z Development, Schoenaicher Str. 220, 71032 Boeblingen, Germany

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Wolfgang Wendt
Geschäftsführung: David Faller
Sitz der Gesellschaft: Böblingen / Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM DATA Privacy Statement: https://www.ibm.com/privacy/us/en/
