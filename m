Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6AA225EF90;
	Tue, 25 Mar 2025 18:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742926243; cv=none; b=XiArqvVi+98FNV7v2z2+slCgtxu++NQPXqCnL2hJm55UkuAOt0WhD5wEeFazRPG5Bh3N2e5cazLWm6uiA3Fg2y/iEVV8n5kDAP+z2zwb0n9SZhLiSaJ/kUzAvBR4RE04qp0ujlg8O5vjmBWHArTo6KgAt8dEI+k0J8/m8ggecX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742926243; c=relaxed/simple;
	bh=3meA6QebgpcfGe2Vp3GUcuOU34OuRrsssJ+h7QcYQtA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nm1zbL7oiXQpJRGCWYZcvF11olEfGq9fnqYC9szl/lD1H2mb7jcM9JS25dPXe29fbWVeeqJ4UTac8z1k4262xAn7aKnv4BJyttSE+vdnwf2zm3EMSgT9aFlQV/eM95JSRzZLY4qKHt7HkDhLcFQbyoPlJmcACs22WIWjSgQ+v50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Cu6tabK8; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Cu6tabK8"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52PEOhVN027698;
	Tue, 25 Mar 2025 18:10:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=m8bPoE
	EzwxicbIZ0HqZaTaWDkzQ7EBXE5jY3xeVaYLo=; b=Cu6tabK8/ayehedRkGbZ8l
	rHaVHMgsE3KOaaGGqw1MWlmj4UH9le8TagVcoBkwCJx+163PKyUtu4DDfmvQyEMe
	H19uJ2HZHo4SSkS2G4HEgtGgM9UlB2stk0Y7geiuocFPNBqX8mVgRofuC6EG20pV
	6pJS660O32CJPSbUY3sbJkiT6wYkalxOXUV7uDkelLOSpxZR+udlthY2Zgw09wH1
	64bSbAyL/SJVWZ+2vBjHfssOWJpRRjv/AREe/sFnlWGvr6ZSLwSjzcfQzUzF9C/2
	V7pMQvndLlC6H6XgIx83rzwDa494vh33PNdzPKmzUC7Vzhlnl7U5zfFwKHEAN8dg
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45kbjwxeke-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Mar 2025 18:10:38 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52PFuFDI030325;
	Tue, 25 Mar 2025 18:10:38 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 45j7htcw29-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Mar 2025 18:10:37 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52PIAauu30999142
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Mar 2025 18:10:36 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 360B020040;
	Tue, 25 Mar 2025 18:10:36 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A280F20043;
	Tue, 25 Mar 2025 18:10:35 +0000 (GMT)
Received: from [9.171.41.98] (unknown [9.171.41.98])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 25 Mar 2025 18:10:35 +0000 (GMT)
Message-ID: <bcaa276c-3c26-44da-b06b-4935bc1384f0@linux.ibm.com>
Date: Tue, 25 Mar 2025 19:10:34 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: s390 hmac
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Harald Freudenberger <freude@linux.ibm.com>
Cc: linux-s390@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
References: <Z-AJFwndherQBH2W@gondor.apana.org.au>
 <1aa33386ca1c39438fd17ea651a21903@linux.ibm.com>
 <Z-JntzkWQqc-Atlc@gondor.apana.org.au>
Content-Language: en-US
From: Holger Dengler <dengler@linux.ibm.com>
In-Reply-To: <Z-JntzkWQqc-Atlc@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YIVtMlbX8pTz9RvoOmFNpNjYOYoAkKMc
X-Proofpoint-ORIG-GUID: YIVtMlbX8pTz9RvoOmFNpNjYOYoAkKMc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-25_07,2025-03-25_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 phishscore=0 spamscore=0
 clxscore=1015 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0
 mlxlogscore=934 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2503250119

On 25/03/2025 09:22, Herbert Xu wrote:
> On Mon, Mar 24, 2025 at 11:04:56AM +0100, Harald Freudenberger wrote:
>>
>> that is the ikp bit in the s390_kmac_gr0 struct:
> 
> Thank you Harald!
> 
>> union s390_kmac_gr0 {
>> 	unsigned long reg;
>> 	struct {
>> 		unsigned long		: 48;
>> 		unsigned long ikp	:  1;
>> 		unsigned long iimp	:  1;
>> 		unsigned long ccup	:  1;
> 
> I hope I don't have to worry about ccup and can just leave it
> as zero during import, right?

I've to do some further test to be 100% sure. This bit is an indicator, if the instruction has updated the hardware crypto counter for hmac or not. Normally, it should be initialized with 0 before the first instruction call and after the instruction call the flag indicates, if the counter has been updated or not. If the flag is 1, it should be 1 for the following calls, otherwise the hardware crypto counters show wrong statistics.

I've no idea how to set the bit on import correctly, if parts of the hmac operation has been processed by another cipher implementation. Setting it to 0 means, the partial hmac operation is counters as a full operation. setting it to 1 would mean, that the operation after an import is not reflected in the statistics.

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com

