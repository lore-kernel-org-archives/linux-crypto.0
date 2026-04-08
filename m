Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B4440DFB6;
	Wed,  8 Apr 2026 13:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775655326; cv=none; b=rq5vq+J/gwWX90sBlaNxlRbG21EDyKEo7HrrQNuUoz37K2OmigQKtCTKhSI98nFYwUe4u8QV+Cam0O/CLfZ63HFQbJl/lKS6ldeGAgJq6eW4SiLokwSqGtYUsCQzjWtxjBrijcuE2bku5ApktoJ2AYFgsp2KrUQ8NLBNTmvOsD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775655326; c=relaxed/simple;
	bh=pKYwxd4LBTqEhM6hCZIw3Kn68SmgW59VpsnURopbGDA=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=D/HV3Nu4I4NkYN8//Nk5FVy2wEKYD2TrR24oLJIq5BD2sHDpF/KKWU1ImfrGzmPJVkSWnjD2VAjKTGVqrYNmnI2lue7wfGpR8SSHSnmZh6+gMsBKW3RBrxsFNRBaogA0bW2AaiKkML2+IaPDKaiuZADOnXZQqgrSJ4FlBiglKjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TCO6/05K; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TCO6/05K"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6387GlMf2297870;
	Wed, 8 Apr 2026 13:35:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=d5Y3KY0dMo0TgrLopZUKISrQg98Co+2h0Y1v4hiJY28=; b=TCO6/05KJrzf
	WEOthB7UJf0GP/bSE43RBLCDkIteri73tcDi3h9CZGB05Mp4gbLfdz/4LVcb7aQU
	wL/uMWQmKjCT/AKCH87h8ewTyiFVg4o9BGWxPKNNyKhPIQ++2MIAjrBDPD7EnjgL
	X3+jRRR8R/3+njLgCVjTjCl10qIdbgCP8o2xL3T/JjnXB7syBDTNK+rteGJwCBUP
	+aBvAMV5AsR+YbuletvcixvfBbl0st0cXp18e3ykg5ivPL1JHDkyZ6f6oFAKFoQz
	XMRFL5O12BDThH2vZJ4p1dXHIahxk+kYY0MyAaLAJp6dKuL9NofJndRyWtjXN/09
	TCm4yEIcPA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dcn2fymq4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Apr 2026 13:35:16 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 638BDP2H014375;
	Wed, 8 Apr 2026 13:35:15 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dcmg4qjp8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Apr 2026 13:35:15 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 638DZEZi54133228
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Apr 2026 13:35:14 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 867AB58051;
	Wed,  8 Apr 2026 13:35:14 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 17DA258060;
	Wed,  8 Apr 2026 13:35:14 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Apr 2026 13:35:14 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 08 Apr 2026 15:35:13 +0200
From: Harald Freudenberger <freude@linux.ibm.com>
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, x86@kernel.org,
        Holger Dengler <dengler@linux.ibm.com>
Subject: Re: [PATCH 0/3] crypto: Remove arch-optimized des and des3_ede code
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <0982d4341f58e2f1181bc472dc9c9d8542148e3c.camel@physik.fu-berlin.de>
References: <20260326201246.57544-1-ebiggers@kernel.org>
 <0982d4341f58e2f1181bc472dc9c9d8542148e3c.camel@physik.fu-berlin.de>
Message-ID: <ccb1363db0aa040838396090155b3e66@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=KeridwYD c=1 sm=1 tr=0 ts=69d65994 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=OYnC2Dc2cL2ZEEg1iL4A:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: Let_FE7PP79Oblt4XoC5LMQd5IYZHbeL
X-Proofpoint-GUID: Let_FE7PP79Oblt4XoC5LMQd5IYZHbeL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA4MDEyMyBTYWx0ZWRfX4VnxltOHjW9r
 IAqA5nFhl1Ec5hzY172frg3xLp23tfItBNfnmGBeuq6/Mzqi6VcEI++IKPxpzFjRcKbEkH01Kq0
 QDjgoNVtecjsrk+v74FYJk7RAGKa2c4IDDpd8q0xbke9owmahihjeEP+PuphjXtMTRZrY7YvbMW
 f9Si40rFKOW0wU4Ky621B7m9Ba/9WftC/zluz340+e6w0xL9+w3MP0jx/g+8PfPT1vzqrLf5NN8
 6sJc4fK4q7+3WPbIDtTOkZfvoJ4WA2cbZ9Ea6uucV/zxuMM1SDf0BYTpqP7zGl/hpMOUZHqM18K
 BGJa5pXPzwC4Wdm1pIgp46TDjM/wJCcF1yXTujRBnq7mPoCA8nMRrrDr8xOraLFYx9pUCNJa1z2
 jTNtTLHvGwToUTFki/QIuO6GzVp3sQDzUzc/InwOCdCPOwgr0burT3Xtz5NPG3LY4mEn6M2CfDN
 sKCjfflSKW0u2Wunorg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-08_04,2026-04-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0 impostorscore=0
 clxscore=1011 phishscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604080123

On 2026-03-26 21:20, John Paul Adrian Glaubitz wrote:
> On Thu, 2026-03-26 at 13:12 -0700, Eric Biggers wrote:
>> DES and 3DES are cryptographically obsolete and insecure by modern
>> standards.  Continuing to maintain highly specific, complex assembly 
>> and
>> glue code for them, especially when the code isn't testable in QEMU
>> (s390 and sparc), is unnecessary and risky.
> 
> We're working on getting crypto instructions added to QEMU though.
> 
> Adrian

Hi Adrian

I am about to implement some of the cpacf instructions for qemu.
Eric and others complained about being unable to test the s390 in-kernel 
crypto
implementations and thus I am about to improve this. As soon as my patch 
series
is in a good shape I'll forward it to you. As of now my main focus is on 
AES (ECB,
CTR, CBC, XTS) with and without protected key support.
Please let us not do this work twice - so get in contact with me and 
Holger
about possible s390 specific crypto implementations for qemu.

Harald Freudenberger
