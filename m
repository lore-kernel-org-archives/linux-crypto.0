Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102BA3BB4D;
	Wed, 15 May 2024 13:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715778003; cv=none; b=ui0/NL5Cxg0ZX/kA0hsM8mHMdLtXnlHv8PWOrHFafWqoSUm2roBLKDPYg3+YeY/P9K9CzvVFKw5KtnOuNKDdZZ3qCVmeMXBD+u8R78H+QbxKqNZXC5dILltw0vc7BKQCJkR7NfmwOaZUD4ylR2pwwlFmx2uJFCyUbeMaxT9rYXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715778003; c=relaxed/simple;
	bh=zywkICdLaNTDXdJI/rwjuI6SI68uWOHYP+ueXmHrQbM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FbN64hBqCdJJk73OJEZiiu0la/m9Sa4OX1hS18g7xUWPU/24iXxrgBjBBm3CKbZ/nxTkAoCxHxbQySYMHv+H9zFuA7WW93lrHXISw3HRcOY3E7YiFp85uFhiUo612hvbSVc5SfHkXPW2v/MY/fMN4A75nq2x6rrFH5vdaSgYG+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TEeTVv7C; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TEeTVv7C"
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44F9SrQx016508;
	Wed, 15 May 2024 12:59:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=utdxrJinQ3y3ssW67uY8/Vj2gKWk7dVKOdUrx/aByzo=;
 b=TEeTVv7CfS7LIh1J0XHjvyUbr/hk3lJtfWgJK0M0nTGdwCUknp1BqL+wceuIqAcU56rl
 i/w9NPn6fKdkLJFkVBhCc4gLIN0vMgeLJ3M3G4DtLfJxpW1DwiX5+myGBuvikgNIiF7Z
 xLF5VJNsE01TrfA5sVJk5Po/XT/L3Ha+QmJ6ERDvdP0W4zeH2i0QQbxsBTfWWAovEXXm
 DOnG1Z99Xy6ayDR3909a8HVMbG3dQZ9bExJuHp8YrMJI7DA1MCMZQjAo1YnNB0a+CnqZ
 sHCbE8sTSqejJCFKb+Se1wgar/krjASe0jHD39t9nFckKgzKaA9T8gTpTGtmcoL1sK3+ sA== 
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y4te9rgrt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 May 2024 12:59:44 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44FA70pQ006132;
	Wed, 15 May 2024 12:59:43 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3y2nq2u836-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 May 2024 12:59:43 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44FCxeB450856216
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 May 2024 12:59:42 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 064FD58054;
	Wed, 15 May 2024 12:59:40 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C27A45805D;
	Wed, 15 May 2024 12:59:38 +0000 (GMT)
Received: from [9.67.88.41] (unknown [9.67.88.41])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 15 May 2024 12:59:38 +0000 (GMT)
Message-ID: <3d857119-8eb4-4dc0-8543-f30922d53187@linux.ibm.com>
Date: Wed, 15 May 2024 07:59:38 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] crypto: X25519 low-level primitives for ppc64le.
To: Andy Polyakov <appro@cryptogams.org>, linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, leitao@debian.org, nayna@linux.ibm.com,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au, ltcgcw@linux.vnet.ibm.com, dtsen@us.ibm.com
References: <20240514173835.4814-1-dtsen@linux.ibm.com>
 <20240514173835.4814-2-dtsen@linux.ibm.com>
 <dc5aadc2-308d-4f24-8a59-45da21b8b2e5@cryptogams.org>
Content-Language: en-US
From: Danny Tsen <dtsen@linux.ibm.com>
In-Reply-To: <dc5aadc2-308d-4f24-8a59-45da21b8b2e5@cryptogams.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DlR67ri-zm08JTzNj0Bkvc7vRlejwpzl
X-Proofpoint-ORIG-GUID: DlR67ri-zm08JTzNj0Bkvc7vRlejwpzl
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-15_06,2024-05-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 priorityscore=1501 malwarescore=0 clxscore=1015
 bulkscore=0 spamscore=0 suspectscore=0 impostorscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405150090

Thank you Andy.  Will fix this.

On 5/15/24 3:11 AM, Andy Polyakov wrote:
> Hi,
>
> Couple of remarks inline.
>
>> +# [1] https://www.openssl.org/~appro/cryptogams/
>
> https://github.com/dot-asm/cryptogams/ is arguably better reference.
>
>> +SYM_FUNC_START(x25519_fe51_mul)
>> +.align    5
>
> The goal is to align the label, not the first instruction after the 
> directive. It's not a problem in this spot, in the beginning of the 
> module that is, but further below it's likely to inject redundant nops 
> between the label and meaningful code. But since the directive in 
> question is not position-sensitive one can resolve this by changing 
> the order of the directive and the SYM_FUNC_START macro.
>
> Cheers.
>
