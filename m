Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBC81D9A62;
	Mon,  2 Dec 2024 17:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733160331; cv=none; b=Dj6x6OXAxE58y54rU+/+5r3+vUHt5QSpq4laIM3Pt4ChUGZliZXN/BAEkAdhcM73n0NFrlarC8T9VnMkFx7i1At6+dgOShGpwHoOrQc0KwtGi6bZcKcY1h03I0H1ehvFUxA+LwUVbNizzt5Gxb/pKKF53a9ht6zuKxk6jx3AJVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733160331; c=relaxed/simple;
	bh=DGPwgTuhgiud7cWykDwGgrJhq81oeOPkfZ2q8xduvtE=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=glpIVTQkuluUyCFachHj37TZ4/P7Y3clb1rHQOYFCkWULEpeaQ1fB5igCCjFLMmzBbG4W1fyaMYJnof/QM6mIc01zeSLo1g4ZnJvlgmgTp4JKXkxW0+qCRDILgiZhJ3E2wWqASSYrhUp7PkgbsmqdOK0xUEwJGm1b/xSXUtggr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=sXAUKd7C; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sXAUKd7C"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B28ljRl026106;
	Mon, 2 Dec 2024 17:25:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=FdN+GlQcEvvns5MVMrS6wzrFOdzWnYYhMDBM5PhQboU=; b=sXAUKd7C3dxd
	boETAIXIQz2hQsQAek6e3TTUrPr1CYSltv6DefxCYRwsco2vnObESTcYI2peIOcD
	raWUDjUlAAvglVkzwQc2Z7S9tKrqdFZ33uRq87IlATVRzC4kRnjAjfjLcWKSwqsv
	JDQKwg21YKKnvE6HVDw2nSCLapnKSZOGrDuHiNjUrqQyxKZR4jS7ilafivhl85RL
	Djy0wc1Zua3A2CZ5IAOv2aYRaqv7gRzm80cebUEUmPiWEQTDFDZAoNekyQaJsOKe
	WywlsYDfKe80kS09vt6EbyAJyTep2LAdpzoyOifU67nOsBQ8jqBoMr5QcGEhquj/
	90i3UfvtIA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 437tbx9w6u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Dec 2024 17:25:24 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4B28AMc9006819;
	Mon, 2 Dec 2024 17:25:23 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 438f8jans8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Dec 2024 17:25:23 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4B2HPMub22676188
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 Dec 2024 17:25:22 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6DFE758067;
	Mon,  2 Dec 2024 17:25:22 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 358D258056;
	Mon,  2 Dec 2024 17:25:22 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  2 Dec 2024 17:25:22 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 02 Dec 2024 18:25:22 +0100
From: Harald Freudenberger <freude@linux.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: davem@davemloft.net, dengler@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v6 2/2] s390/crypto: New s390 specific protected key hash
 phmac
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <Z0nUQQ9E32xq0SY4@gondor.apana.org.au>
References: <20241129111059.303905-1-freude@linux.ibm.com>
 <20241129111059.303905-3-freude@linux.ibm.com>
 <Z0nUQQ9E32xq0SY4@gondor.apana.org.au>
Message-ID: <c86548e680a151394fa814f543103481@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: E8GNS3_70ChhMV-6F9jbWnW_te4bq5xc
X-Proofpoint-GUID: E8GNS3_70ChhMV-6F9jbWnW_te4bq5xc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 mlxscore=0 suspectscore=0 mlxlogscore=680 priorityscore=1501 bulkscore=0
 phishscore=0 adultscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2412020145

On 2024-11-29 15:48, Herbert Xu wrote:
> On Fri, Nov 29, 2024 at 12:10:58PM +0100, Harald Freudenberger wrote:
>> 
>> +static inline int phmac_keyblob2pkey(const u8 *key, unsigned int 
>> keylen,
>> +				     struct phmac_protkey *pk)
>> +{
>> +	int i, rc = -EIO;
>> +
>> +	/* try three times in case of busy card */
>> +	for (i = 0; rc && i < 3; i++) {
>> +		if (rc == -EBUSY && msleep_interruptible(1000))
>> +			return -EINTR;
> 
> You can't sleep in an ahash algorithm either.  What you can do
> however is schedule a delayed work and pick up where you left
> off.  That's how asynchronous completion works.
> 
> But my question still stands, under what circumstances can
> this fail? I don't think storage folks will be too happy with
> a crypto algorithm that can produce random failures.
> 
> Cheers,

- The attempt to derive a protected key usable by the cpacf instructions
   depends of the raw key material used. For 'clear key' material the
   derivation process is a simple instruction which can't fail.
   A more preferred way however is to use 'secure key' material which
   is transferred to a crypto card and then re-wrapped to be usable
   with cpacf instructions. This requires communication with a crypto
   card and thus may fail - because there is no card at all or there
   is temporarily no card available or the card is in bad state. If there
   is no usable card the AP bus returns -EBUSY at the pkey_key2protkey()
   function and triggers an asynchronous bus scan. As long as this scan
   is running (usually about 100ms or so) the -EBUSY is returned to 
indicate
   that the caller should retry "later". Other states are covered with
   other return codes like ENODEV or EIO and the caller is not supposed
   to loop but should fail. When there is no accessible hardware 
available
   to derive a protected key either the user or the admin broke something
   or something went really the bad way and then there is no help but the
   storage device must fail.
- How can it happen that a re-derive is needed? A re-derive is triggered 
when
   the cpacf instruction detects that the protected key is not valid any 
more.
   A protected key includes a verification pattern (hash) of the firmware 
key
   used to encrypt the key. This hash is checked on each invocation of a
   cpacf instruction. So when the code execution "awakes" on another 
machine
   ("live guest migration" of an KVM guest to another machine) the next
   cpacf instruction will complain about verification pattern mismatch 
and
   the protected key needs to get re-derived from the source material.
   It could also happen via suspend/resume on the very same machine when
   there is something in between (for example the whole machine runs a
   cold-start). It does NOT happen out of the sudden without any reason,
   but the code affected is not aware of any "live guest migration" or
   "suspend/resume cycle" and thus as the crypto algorithm implementation 
has
   no awareness of a "live guest migration" just happened - it looks like
   this occurred suddenly.
- Do I get you right, that a completion is ok? I always had the 
impression
   that waiting on a completion is also a sleeping act and thus not 
allowed?

Thanks for your help and being so patient with us.



