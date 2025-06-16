Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700E127FB10
	for <linux-crypto@vger.kernel.org>; Mon, 16 Jun 2025 10:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750071023; cv=none; b=mP/wd/yUnGGouDStjc3UvDOCWcKZr51l7VEjbOxinujiITgSMVNE3culVV/21TpQ/BUYGWusezP+EzAsw5fygSRpyilX5xx4nj2qXYSRvhtS5TGKuncH1yIL59jUCPEySWifyJgx1UkkBvAJd7udPtuFJFDeM7sW0RAc3zaUDUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750071023; c=relaxed/simple;
	bh=WFXyuIl1ai7zW0/bNIEBCW5gSywUyqO1acDZrRnaqoU=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=jgxextRjWDK9u6AG/A6LHERTdAFXIvKVGo1SaR3KPdYOzKp1bR/3Jhmq7YS0/rnhTYUM8eaGdpT2R5Q+6L2c5TN48/Wwa7k1GLrEC5jF2c4crZ1Y0D0rPIxVz6hAunQQD5t2ybJkezbFppDzF/mYPdRORWFauWhRujLHUv845Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NlMmUu5z; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NlMmUu5z"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55G9Tbx7029530;
	Mon, 16 Jun 2025 10:50:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=gzAVNTd9kAiXR8EDovxsCWEhs2XX686pdIXH3YYqDXE=; b=NlMmUu5zttb7
	/zwmOTXJOPN19UGBxJDmHvgbokg3y8c/sV9eFz4SWvnFEqlIKvs7XNjovLCnLPu9
	ICJQ/Wgw9TiU/cmmdJ8FrG+GfRNcqwy60NxXRHaskZOXuP1mj3nAlIYAtQ2fTKkn
	UndHIJiFA0WgMemH4xnL+8Ad9tbr0xTMwXGG4O3mowzNBhh4Vrb3jn4e4ET5bDpy
	h0Drcy3+uhqZdvcHFQ+oHt/o/ks9jeXE+mOq7vxlsII0moV5I90uqrMoUW/lx3lM
	5/5CM6bRiA/44LcIKMzDsznxiAoQPg5wKwzNiaks4XbMbu/dCUrJEpmpn22ct3Fr
	iCyFdBUmnw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4790s49a3g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Jun 2025 10:50:10 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55GA8YXb014247;
	Mon, 16 Jun 2025 10:50:10 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 479p425cb4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Jun 2025 10:50:09 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55GAo8Zu60293438
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Jun 2025 10:50:09 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AB75058054;
	Mon, 16 Jun 2025 10:50:08 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2AA7A58060;
	Mon, 16 Jun 2025 10:50:08 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 16 Jun 2025 10:50:08 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 16 Jun 2025 12:50:07 +0200
From: Harald Freudenberger <freude@linux.ibm.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ingo Franzki <ifranzki@linux.ibm.com>,
        Herbert Xu
 <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, dengler@linux.ibm.com
Subject: Re: CI: Another strange crypto message in syslog
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <20250606174508.GA53397@google.com>
References: <d4520a75-c765-406b-a115-a79bbdf8d199@linux.ibm.com>
 <20250605142641.GA1248@sol> <66d4c382f0fbe4ca5486ccfa1f0a4699@linux.ibm.com>
 <20250606174508.GA53397@google.com>
Message-ID: <319c7c1d4af5c1014d4a88ade39207ea@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE2MDA2NyBTYWx0ZWRfX+Koi0jr8t6Bt yZnkvDJBxBGMU6ddg8JhQjN7g7X96BlthzXmrKK48e4jId6JC4jo68wMVgi0fFiPpnli3VQnDkz R2Cki0RFPLtqK0Hw3+fiir4ht3IPItjau8idySVNiGeKfUOmxcjlzz3ogAAa/OPbJl66t1UvL6q
 d019mrcEFcyWlJZWb9E2T9OeI0z2BpR0HibxsZ+IIXk154u4D9dLAYS+0Kzt8pCeO72oLp8Z72k S6Mi6YteMGPXgN5FVo3g4FU1rdFVJtyCN7MKpm8zqtcsw/6GnD0m9cl/pyU6RsiPgtBO+LqxsoV EaEaXp8nj8kliLDlCY8y230x/5m9PjzOirUrlvoic4rI4mTkT4XMHZv9WBIKeD1ewLqCiOndZR4
 JKBGQ/vgdiWrGuKqOFAz/VB8PbSNnfEkpCu/9LBInnOC4kCpWRq1tcIJvitJ/pUpx4X9iKNQ
X-Proofpoint-ORIG-GUID: f3p31kRhs0pLJDatqME-Alm-W1cC7Nlc
X-Authority-Analysis: v=2.4 cv=Qc9mvtbv c=1 sm=1 tr=0 ts=684ff6e2 cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=nqbsJgCpBFVI0rgiQ9sA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: f3p31kRhs0pLJDatqME-Alm-W1cC7Nlc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-16_04,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 spamscore=0 impostorscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506160067

On 2025-06-06 19:45, Eric Biggers wrote:
> On Fri, Jun 06, 2025 at 09:19:18AM +0200, Harald Freudenberger wrote:
>> > The crypto self-tests remain disabled by default; there's just no longer
>> > a
>> > difference between the "regular tests" and the "full tests".  The
>> > warning makes
>> > sense to me.  There should be an indication that the tests are running
>> > since
>> > they take a long time and should not be enabled in production kernels.
>> >
>> > If this is s390, arch/s390/configs/defconfig has
>> > CONFIG_CRYPTO_SELFTESTS=y.  Is
>> > that really what you want?  I tried to remove it as part of
>> > https://lore.kernel.org/linux-crypto/20250419161543.139344-4-ebiggers@kernel.org/,
>> > but someone complained about that patch so I ended up dropping it.  But
>> > maybe
>> > you still want to remove it from arch/s390/configs/defconfig.  There's
>> > already
>> > arch/s390/configs/debug_defconfig that has it enabled too, and maybe you
>> > only
>> > want tests enabled in the "debug" one?
>> >
>> > - Eric
>> 
>> Looks like we have no other options than disabling the selftests in
>> defconfig.
>> We have debug_defconfig - with all the now huge set of test running in 
>> CI.
>> But for my feeling it was making total sense to have a subset of the 
>> tests
>> run with registration of each crypto algorithm even in production 
>> kernels.
>> However, as wrote ... there is no choice anymore.
> 
> There's still a command-line option cryptomgr.noslowtests=1.
> 
> If you really want it, we could add back a kconfig option to control 
> whether the
> self-tests run the "fast" tests only or not.  I thought that the only 
> use case
> for running the "fast" tests only was for people who are misusing these 
> tests
> for FIPS pre-operational self-testing.  (Which has always been a poor 
> match, as
> FIPS requires only a single test of any length per algorithm, for only 
> a subset
> of algorithms.  It's totally different from actually doing proper 
> testing.)
> Those people should be okay with the command-line option.
> 
> I do think the idea of running the tests in production kernels is 
> questionable.
> There are enough tests now that you can't run all of them (and indeed 
> you are
> not asking for that), which means the production testing will be 
> incomplete, and
> the real testing needs to be done in the development phase with a build 
> that has
> the tests enabled anyway.  The same applies to other kernel subsystems 
> too.
> 
> - Eric

In general I agree to this. Clearly it makes no sense to run all
the tests all time when a new algorithm is registered.
The thing is ... everybody wants to test as close as possible to the
production systems. So the kernels are usually build for production - 
now without
any selftests. But all the Linux distributors happily patch whatever 
they think
is necessary and build production kernels - now without any in-kernel 
crypto
selftests. The only places where selftests are now executed is in 
'special'
environments like CIs or on development systems and hopefully findings 
there
are handled seriously by the maintainers and developers.

Harald Freudenberger
