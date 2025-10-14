Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998FD14D283;
	Tue, 14 Oct 2025 11:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760440214; cv=none; b=rr9NzJ1qsHwoRXAG0ah2+S6dwB05s0Vxd3gQz7tWiFlsXul3teqJv0nrQneyhWDBMF71/3R5+XlnjTKRi2HIV4MZ949ugH0IqpXXcFNvEveGUR1k21+VskCFnayR1MWdCtOcqcGF/idAg9M5+FIpHYQPZgs900Pv5tJ1SWNeT2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760440214; c=relaxed/simple;
	bh=Su1trznTyl2I4WqZjFoXa+05zzFZGLSVKyCFAYBmGOs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hh3RCuEdbigrglTwLz+8I46JULxPxX2NhBHqSEoIUekUvF6hpU8asnKoZZIWayz6ej8Rjj3vYrBjrJmpSgqsCfFSzDM3vPs5OcgCBCug2NI3CUWLtOJF5rUCVkkN/r9Vf8qaPVBNQzL8JKCXHF6fzpoUOYSvDvFxFt7Zzp2/ZZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ba5eBIOz; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ba5eBIOz"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59DN8oc3009098;
	Tue, 14 Oct 2025 11:10:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=9E2eDA
	36u7Z1oVyNR/of4XYRJQ60In40OmKoyK4PVmI=; b=ba5eBIOzU5PiGTOVXT8zG7
	Q6YMqA9GzVii6/FPiop4wfgnlKJVoiooMeSRfysJ6pL2DvzAVp6pVcdycELDH/Ur
	ZqxuMajLBAnoK4Bpmqusu+wg16cZctwCNFdp2N24puDZaiuwj5ulT9E4dJfGLrDX
	WcLRZF0SYSpc0o7kqZXJj9mcjsydbn2liY/Ao1msPRPqr6TKjv20SXaqNmErjBoc
	sE+ovsH9Kw8EvnKnAyr7ptWjezhiwN4yAvJPjlCP290h5WM3zxzB4zjXFRmpSIc1
	iRkwxE5gHxxk0j4wvcffP264xzACvnTH9gzGXSXrVXxSRXBluDKZ2/2loGke1fLg
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49qewtx75t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Oct 2025 11:10:08 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59EAvP7P003626;
	Tue, 14 Oct 2025 11:10:07 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49r1xxtp0c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Oct 2025 11:10:07 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59EBA2VE7078220
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 11:10:02 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0B788200E6;
	Tue, 14 Oct 2025 11:01:06 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D3D6F200E5;
	Tue, 14 Oct 2025 11:01:05 +0000 (GMT)
Received: from [9.111.132.230] (unknown [9.111.132.230])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 14 Oct 2025 11:01:05 +0000 (GMT)
Message-ID: <2b7bbd44-dd3f-42f8-bc7a-75f5b6b2a0e3@linux.ibm.com>
Date: Tue, 14 Oct 2025 13:01:05 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] crypto: s390/phmac - Do not modify the req->nbytes
 value
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        herbert@gondor.apana.org.au, ifranzki@linux.ibm.com,
        mpatocka@redhat.com
References: <20251014105308.27663-1-freude@linux.ibm.com>
From: Holger Dengler <dengler@linux.ibm.com>
Content-Language: de-DE
In-Reply-To: <20251014105308.27663-1-freude@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZjcyfwpM7opDc_vbVs96mG3XEFRKCyPK
X-Authority-Analysis: v=2.4 cv=Kr1AGGWN c=1 sm=1 tr=0 ts=68ee2f90 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=w46-cfdy0MOtRbFV-QQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: ZjcyfwpM7opDc_vbVs96mG3XEFRKCyPK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAxNCBTYWx0ZWRfXzXxN5uUb0nzn
 4pn4ThCKoUDjpfeMnm5MKBM8bt+ms2iV2nsaHKfNbbRdsu5f5q3RSHObVtF/ajXBoA38iTkPsk4
 nzfBAPONhzRM7MKup4O9R7qzdcm6vWltjgyj1N31nuHyGSFAHdknvclqLsJ0y54KuLh+JBlreZf
 tTEGJkPU2XbdupJ1FG3+e/tVgFU8ECBifvKNdf0o4eAJPds0yl53wLP+zbxb2Qz+1qcS6CSm+Ha
 X+ZbpP6V/nXuMgNJ7qZcPwoJgD+pybmVk45DHzmPUXXH2gduKPCah8BFpbMUSQFmxkU/NIxhVm3
 yi/Gfg7RN+chEG6XToh/oq8KihADF13CVHElGuYczg5aYp8A6KBPjVhluzxf70Nc12vffSv9q4R
 0ey4k6989QVqtBH1LHROlB+BbmZv8w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-14_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510110014

On 14/10/2025 12:53, Harald Freudenberger wrote:
> The phmac implementation used the req->nbytes field on combined
> operations (finup, digest) to track the state:
> with req->nbytes > 0 the update needs to be processed,
> while req->nbytes == 0 means to do the final operation. For
> this purpose the req->nbytes field was set to 0 after successful
> update operation. However, aead uses the req->nbytes field after a
> successful hash operation to determine the amount of data to
> en/decrypt. So an implementation must not modify the nbytes field.
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

Reviewed-by: Holger Dengler <dengler@linux.ibm.com>

And please don't forget to pick Ingo's R-b and T-b tags (or let b4 do the job).

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com

