Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4ED280CC8;
	Tue, 24 Jun 2025 11:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750764890; cv=none; b=ad+yrEdx/F29FPi4NbbFYMzn5a9G7BXpw0j4cERWz7hV8ZoJW5MBvouvddFJ0UIY/mQTgedY0522omKyeTyA2BjRk+OPPhRRO0I4QtRQJTqlkUp0g0ICuja1laQGOpFJqJ3c3SePkEjrVML387BQlMHHVev+xxeobqrT4bEoWyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750764890; c=relaxed/simple;
	bh=I56jR4SHRGc/7qYercd0jjbBbzvzDn3U0VA6cnWqbRI=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=fDQPIHTvON0KoK4Rv3cYq8T5KVlxk6UM2dCp9hjR/MRx2z3V9uJTY4jLVkvxCfts7qdRlf8O/i35czPfbfdTSA0fbUiF7fR+SBMaYcpwPrJStHTJ/r7jjreM3i+o1vY4/mAan7ZcyX2p3AKLJLi6m4OqcG/Fxw0BswRrNbWtjRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=KU1LWdIU; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KU1LWdIU"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55O7CgTS007532;
	Tue, 24 Jun 2025 11:34:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=2Q45rfihutU+8A8RDLFgLW3bDr/Zr42BT8QrNnMnHN4=; b=KU1LWdIUMiNx
	K5Vcv0GAQccIYdefCE9FzweJfFcdYE2PmCCsiAEJwYYKLN61x1wk77XqmEKs4hVA
	fPbGqm2Gw62X6IdkptoG+KIe0ZL9y+LICkylr+RMti98V7IX3yYn3avclXRq6j9Q
	jcGm+YIY0tixb/lXS7gmKsfJJui7chYbdkPacfySY4cA+Ce0xgFSFyYDIZiFa+ve
	uUdya01g//TwT3o7yiRbnFl6I5+SnxyUk6fCwtcYEMHI99Lzb3tKonIkZQaZpCEn
	Vn8vSlEg7xSDh0XanPjshu6b3aXpgsgrAdaQ4VWXpAZsbpfICHVW6r9eYQP6fjFZ
	bLrRJUlEWw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47dj5tra9x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Jun 2025 11:34:45 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55O9SJu7014987;
	Tue, 24 Jun 2025 11:34:44 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 47e72tkwku-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Jun 2025 11:34:44 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55OBYgxl24707342
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Jun 2025 11:34:42 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6320D58054;
	Tue, 24 Jun 2025 11:34:42 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9017A58064;
	Tue, 24 Jun 2025 11:34:41 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 24 Jun 2025 11:34:41 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 24 Jun 2025 13:34:41 +0200
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        dengler@linux.ibm.com, ifranzki@linux.ibm.com, fcallies@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com
Subject: Re: [PATCH v12 0/6] New s390 specific protected key hmac
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <20250617134440.48000-1-freude@linux.ibm.com>
References: <20250617134440.48000-1-freude@linux.ibm.com>
Message-ID: <65e586b07ff55f21f3909509b6591f41@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: pbscxPkXbyoBIvLkDfa7sxQeimh7LdC7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI0MDA5NSBTYWx0ZWRfX7rEwadzt8Jjs R96lTMzCFTeEbSz/y8QSGIxVDevjr9dSVEZHk5urtN4WgtKADdtobcocCLou3ymOWEpUcyxXoMG lB9OMssArF+G9BYNfefkOfqx07BbJD+MbQxji7t30i5pJNYrra8gNcQ4nlzHlV09tzKmtRXtmvO
 XgJ3cVgA0Dk6glCnBqsooLG2yQ15n+oDexYYkZwfFD9gzfTLxN/ZCbhCo3h6f78xbmAS3At/w7T Ci/GLnyqfvuGOWUGLDQbXd5ohsayjWHgGL1lFm35a+ew8BfUgbYC+cvMzQor+XzAEEFPVN+htiP 0jO1WBoP4UjS6nRjWt5Nz2e5ppwAspRnFBzJInBPHPMX0GTxO4b+zehO6DFEKu/dnoJryBARnnS
 B7VxfbW312L02ctUQ9PRHrmjWAqi4zQxjIolUO5hdsd6ehezGbptlBMg0DNQgqJ9b3656dYR
X-Authority-Analysis: v=2.4 cv=MshS63ae c=1 sm=1 tr=0 ts=685a8d55 cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=mghUvs484taJzBYtdHAA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: pbscxPkXbyoBIvLkDfa7sxQeimh7LdC7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-24_04,2025-06-23_07,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 spamscore=0 mlxlogscore=999 impostorscore=0
 clxscore=1015 phishscore=0 malwarescore=0 suspectscore=0 adultscore=0
 priorityscore=1501 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506240095

On 2025-06-17 15:44, Harald Freudenberger wrote:
> Add support for protected key hmac ("phmac") for s390 arch.
> 
> With the latest machine generation there is now support for
> protected key (that is a key wrapped by a master key stored
> in firmware) hmac for sha2 (sha224, sha256, sha384 and sha512)
> for the s390 specific CPACF instruction kmac.
> 
> This patch adds support via 4 new hashes registered as
> phmac(sha224), phmac(sha256), phmac(sha384) and phmac(sha512).
> 
> Changelog:
> v1: Initial version
> v2: Increase HASH_MAX_DESCSIZE generic (not just for arch s390).
>     Fix one finding to use kmemdup instead of kmalloc/memcpy from test
>     robot. Remove unneeded cpacf subfunctions checks. Simplify
>     clone_tfm() function. Rebased to s390/features.
> v3: Feedback from Herbert: Use GFP_ATOMIC in setkey function.
>     Feedback from Holger: rework tfm clone function, move convert key
>     invocation from setkey to init function. Rebased to updated
>     s390/features from 11/7/2024. Ready for integration if there are
>     no complains on v3.
> v4: Rewind back more or less to v2. Add code to check for non-sleeping
>     context. Non-sleeping context during attempt to derive the
>     protected key from raw key material is not accepted and
>     -EOPNOTSUPP is returned (also currently all derivation pathes
>     would in fact never sleep). In general the phmac implementation is
>     not to be used within non-sleeping context and the code header
>     mentions this. Tested with (patched) dm-integrity - works fine.
> v5: As suggested by Herbert now the shashes have been marked as
>     'internal' and wrapped by ahashes which use the cryptd if an
>     atomic context is detected. So the visible phmac algorithms are
>     now ahashes. Unfortunately the dm-integrity implementation
>     currently requests and deals only with shashes and this phmac
>     implementation is not fitting to the original goal any more...
> v6: As suggested by Herbert now a pure async phmac implementation.
>     Tested via AF_ALG interface. Untested via dm-integrity as this 
> layer
>     only supports shashes. Maybe I'll develop a patch to switch the
>     dm-integrity to ahash as it is anyway the more flexible interface.
> v7: Total rework of the implementation. Now uses workqueues and 
> triggers
>     asynch requests for key convert, init, update, final and digest.
>     Tested with instrumented code and with a reworked version of
>     dm-integrity which uses asynchronous hashes. A patch for 
> dm-integrity
>     is on the way but yet needs some last hone work.
> v8: Added selftest. With the selftest comes some code which wraps the
>     clear key into a "clear key token" digestible by PKEY. The
>     selftest also uses import() and export(), so these are now also
>     implemented. Furthermore a finup() implementation is now also
>     available. Tested with AF_ALG testcases and dm-integrity, also
>     tested with some instrumented code to check that the asynch
>     workqueue functions do their job correctly. Coding is complete!
> v9: As suggested by Herbert use ahash_request_complete() and surround 
> it
>     with local_bh_disable().
> v10: Split the pkey selftest patch into 3 patches. Slight rework of the
>      setkey function as suggested by Holger: When selftest is running
>      as much as possible of the production code should run. So now the
>      key prep with selftest is one additional if/then block instead of
>      an if/then/else construct.
>      Code is ready for integration and well tested.
> v11: Utterly rework with the insights collected with the paes rework
>      and the basic work done with the pkey rework over the last 5 
> month.
>      Note that patch #1 effectively reverts commit 7fa481734016
>      ("crypto: ahash - make hash walk functions private to ahash.c")
>      from Eric Biggers.
> v12: Fixed some typos, adaptions to 128 bit total counter,
>      misc_register() invocation was missing in the patches series,
>      added Herbert's proposal for a new function crypto_ahash_tested().
> 
> Harald Freudenberger (5):
>   crypto: ahash - make hash walk functions from ahash.c  public
>   s390/crypto: New s390 specific protected key hash phmac
>   crypto: api - Add crypto_ahash_tested() helper function
>   s390/crypto: Add selftest support for phmac
>   crypto: testmgr - Enable phmac selftest
> 
> Holger Dengler (1):
>   s390/crypto: Add protected key hmac subfunctions for KMAC
> 
>  arch/s390/configs/debug_defconfig |    1 +
>  arch/s390/configs/defconfig       |    1 +
>  arch/s390/crypto/Makefile         |    1 +
>  arch/s390/crypto/phmac_s390.c     | 1048 +++++++++++++++++++++++++++++
>  arch/s390/include/asm/cpacf.h     |    4 +
>  crypto/ahash.c                    |   26 +-
>  crypto/testmgr.c                  |   30 +
>  drivers/crypto/Kconfig            |   13 +
>  include/crypto/internal/hash.h    |   30 +
>  9 files changed, 1133 insertions(+), 21 deletions(-)
>  create mode 100644 arch/s390/crypto/phmac_s390.c
> 
> 
> base-commit: 1029436218e50168812dbc44b16bca6d35721b0b
> --
> 2.43.0

Hi Herbert,

as the phmac implementation uses the newly introduced 
CRYPTO_ALG_NO_FALLBACK
flag, we can't deliver this patch series via s390. I talked with Heiko
about that and there are two options:
1) We (s390) pick your patch 4ccd065a69df ("crypto: ahash - Add support 
for
    drivers with no fallback") together with my patch series for the next
    kernel's merge window.
2) You (crypto) pick my patch series into your cryptodev-2.6 for next
    kernel's merge window.
I would prefer option 2 as most of the patches anyway deal with crypto
and Heiko and I do not expect unsolvable merge conflicts with the next
kernel's merge.
So what is your opinion?

Thanks,
Harald Freudenberger
