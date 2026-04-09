Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7EE3BED4A;
	Thu,  9 Apr 2026 11:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775732551; cv=none; b=csfXRkVMjSk2QznWEcACkH89JZ5HZ/ojvUdwmduRKD/y829gGSEaKQeClldudf9lIEgGVdnzNqrqeL8lIn2U+rTbuKlrtw7NAv+VPlkIi3YcKOx88K7L6voQEMHKCxADlMlzXFDhF/Sop+PWEIIb79vVVNzCXMw0r7dj8kVkWV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775732551; c=relaxed/simple;
	bh=52xoCoomqrF5WcBna2OKFT4m8+395iYAp3/zAnHiEU8=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=mq38k20omPzgEgBdJ7sHmEK+39P+9JXZxzG0MgMO6UNTz0rvXuAxjo9wN/KPj7o1jIXMoMxXkjphbAvGLJ9LQ0AN4T4JF32JJenkoCxz80TCi7fJ/iIpN3TdGYwOtmndulLFy7faTjWBJVDQr4+IGRfX5FDJ44KYS6x8kE8tNlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QM2X43so; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QM2X43so"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638JEEku2211010;
	Thu, 9 Apr 2026 11:02:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=aRI3KTKCgL8td0F1L+BS1JbWXX4gW6ENXsgBz4vkJFI=; b=QM2X43sof1Lg
	FWZ9OOp+/p4u3a6cPhDW+Gbt+EpL7Cq5YBL/m06A07Z91WqjdE+E88nH3mGV0F7l
	ZTNsZ3q35ymLflkMjFffN++y6vjNQ4h/BKpwT9pNp0HU0o897pJpG5+KiZGtqFap
	biQj0YiHVDQB2ljgfjNSKqhnkJZDJtQjbGXQhMhoQbAN4Q1kmwo1C2y0bdfu25iy
	3ekSOVx1B7ydp4I8Mm7PIFJhh3ImrMrvagdYm4SuJdc7BiaDswI78WT9EShfZUU7
	fWGggT2Mqc1RBTlpvs5wz69STEiyLTdPM06mApy7AgX3cf8M665rqSb9dg66D8Ze
	U+AajZxK8A==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dcn2hkqb9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Apr 2026 11:02:24 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63986LlF026655;
	Thu, 9 Apr 2026 11:02:24 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dcmg838cg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Apr 2026 11:02:24 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 639B2NFN14418600
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 9 Apr 2026 11:02:23 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CF9E0580C8;
	Thu,  9 Apr 2026 11:02:23 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6A566580C9;
	Thu,  9 Apr 2026 11:02:23 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  9 Apr 2026 11:02:23 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 09 Apr 2026 13:02:23 +0200
From: Harald Freudenberger <freude@linux.ibm.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Holger Dengler <dengler@linux.ibm.com>, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/3] crypto: s390 - Remove des and des3_ede code
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <20260327173229.GB3407398@google.com>
References: <20260326201246.57544-1-ebiggers@kernel.org>
 <20260326201246.57544-2-ebiggers@kernel.org>
 <65c3d229-57ee-4980-a13f-bc9661b4dda1@linux.ibm.com>
 <20260327173229.GB3407398@google.com>
Message-ID: <b5ddfc370755c60fbdcfbc954391a088@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDA5NyBTYWx0ZWRfXwpQ4HoefbzbT
 i7qTGPpifmClMxH7+LDYgCu6y+XEkp5uGaib4bMSs+igMDRlZLiaEXpC6+MhQ9RGzZQRkOCxlk3
 S6CRIQygmRjr83fZas3uNHn5JUX2DGWCrR/Pi1UURKau8lGh6zMn0sJf6dwHJSH3Fsu2tQ02XE2
 HaqjDHYMBXvPhdnBDXGl095aqR3A0gBzYCsWCnrkaWX+jfk9dDw5Ms0Ha553rI/+Ymo25et15Yd
 p7TrV3Oj2Fduap4E1UI1VOkex1+JkVobmHTHH+CuhovKZnLHFiqm9Q+mA0EirOC4L+2YQu+k73B
 TQ0tvSMudI66Ir/v4EzhDqR/Gb7gUJqtj/+56TP0lyNv/kcNZ39VpfQ0O3cF/zxPM9iq/mpdaCs
 jCPXEQM1Y9FFX49zNhwXLDClYzri9NE4RZuLvgUrgVv/O/b6KCWIv4O6TsGj+6mqEaqXx9DFdfU
 CFfdh8oiMjvAwFM+lAg==
X-Proofpoint-GUID: mGc0xoxsUcJ1RFQ21OsWeuzsZ02FeeO4
X-Authority-Analysis: v=2.4 cv=a/wAM0SF c=1 sm=1 tr=0 ts=69d78741 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=Vl4isb59Ea5TTis8JccA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: mGc0xoxsUcJ1RFQ21OsWeuzsZ02FeeO4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-09_03,2026-04-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501
 phishscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604090097

On 2026-03-27 18:32, Eric Biggers wrote:
> On Fri, Mar 27, 2026 at 09:52:31AM +0100, Holger Dengler wrote:
>> Hi Eric,
>> 
>> On 26/03/2026 21:12, Eric Biggers wrote:
>> > Since DES and Triple DES are obsolete, there is very little point in
>> > maintining architecture-optimized code for them.  Remove it.
>> >
>> > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
>> 
>> Are there plans to completely remove des/3des in-kernel crypto support 
>> from
>> the kernel or is it just the arch-specific code, that is removed?
> 
> Just the arch-specific code for now.  It will just make these like RC4
> and MD4 which are still implemented for compatibility reasons but only
> with generic C code.  Someday (years from now) we should remove all of
> these entirely, but for now the best we can hope for is simplifying the
> implementations to just the generic C code.
> 
> - Eric

Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
