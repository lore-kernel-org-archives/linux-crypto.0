Received: from mx2.zhaoxin.com (mx2.zhaoxin.com [61.152.208.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40ADA25776
	for <linux-crypto@vger.kernel.org>; Wed, 17 Dec 2025 04:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=61.152.208.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765947407; cv=none; b=d9zBOw8fRY23yLKEOdLSZvGU1wZm3j83B9BV0/prJ8PkFA+FUeD/n9jNaFQnTBgjlE4Fvt018rPHiayc4C+/gED7/4M/6ZzCULNdGoiR8qlo07alix4mKAhc/h/VByzJ/1UuzgXZLh7FEleOrOOh91A5B3JNZ7PY2ZXhGOA8ReE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765947407; c=relaxed/simple;
	bh=8MscW9NMqNUNk9mVtwc1uYe4hV35ELC3iugJO391g34=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=CC07fhkRZG9v4fKWDow3/Gfxh5eYCtGptXgQSHNVqLOfuiYEDZhmAKjpsuSBj/F7O3p+XgXi38n2onW8xlURFjJIqXydDSrfAjevNFL+NBNEmEyGuhDF1c9KMDnZRXQUa2osRU17semyAf3Ehtdd+P37INtl0n7tlFgsAXuu+Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=61.152.208.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1765946658-1eb14e3d8af47a0001-Xm9f1P
Received: from ZXSHMBX1.zhaoxin.com (ZXSHMBX1.zhaoxin.com [10.28.252.163]) by mx2.zhaoxin.com with ESMTP id nnuJvdCSHctPGrIN (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Wed, 17 Dec 2025 12:44:18 +0800 (CST)
X-Barracuda-Envelope-From: AlanSong-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from ZXSHMBX1.zhaoxin.com (10.28.252.163) by ZXSHMBX1.zhaoxin.com
 (10.28.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.59; Wed, 17 Dec
 2025 12:44:17 +0800
Received: from ZXSHMBX1.zhaoxin.com ([fe80::936:f2f9:9efa:3c85]) by
 ZXSHMBX1.zhaoxin.com ([fe80::936:f2f9:9efa:3c85%7]) with mapi id
 15.01.2507.059; Wed, 17 Dec 2025 12:44:17 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from [10.32.65.156] (10.32.65.156) by ZXBJMBX02.zhaoxin.com
 (10.29.252.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.59; Wed, 17 Dec
 2025 12:31:27 +0800
Message-ID: <cd6a8143-f93a-4843-b8f6-dbff645c7555@zhaoxin.com>
Date: Wed, 17 Dec 2025 12:30:57 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: padlock-sha - Disable broken driver
To: Eric Biggers <ebiggers@kernel.org>, Herbert Xu
	<herbert@gondor.apana.org.au>
X-ASG-Orig-Subj: Re: [PATCH] crypto: padlock-sha - Disable broken driver
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>, larryw3i
	<larryw3i@yeah.net>, <stable@vger.kernel.org>, <CobeChen@zhaoxin.com>,
	<GeorgeXue@zhaoxin.com>, <HansHu@zhaoxin.com>, <LeoLiu-oc@zhaoxin.com>,
	<TonyWWang-oc@zhaoxin.com>, <YunShen@zhaoxin.com>
References: <3af01fec-b4d3-4d0c-9450-2b722d4bbe39@yeah.net>
 <20251116183926.3969-1-ebiggers@kernel.org>
 <aRvpWqwQhndipqx-@gondor.apana.org.au> <20251118040244.GB3993@sol>
From: AlanSong-oc <AlanSong-oc@zhaoxin.com>
In-Reply-To: <20251118040244.GB3993@sol>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: zxbjmbx1.zhaoxin.com (10.29.252.163) To
 ZXBJMBX02.zhaoxin.com (10.29.252.6)
X-Moderation-Data: 12/17/2025 12:44:16 PM
X-Barracuda-Connect: ZXSHMBX1.zhaoxin.com[10.28.252.163]
X-Barracuda-Start-Time: 1765946658
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.36:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 1781
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.151677
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------


On 11/18/2025 12:02 PM, Eric Biggers wrote:
> On Tue, Nov 18, 2025 at 11:34:50AM +0800, Herbert Xu wrote:
>> On Sun, Nov 16, 2025 at 10:39:26AM -0800, Eric Biggers wrote:
>>> This driver is known broken, as it computes the wrong SHA-1 and SHA-256
>>> hashes.  Correctness needs to be the first priority for cryptographic
>>> code.  Just disable it, allowing the standard (and actually correct)
>>> SHA-1 and SHA-256 implementations to take priority.
>>
>> ...
>>
>>> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
>>> index a6688d54984c..16ea3e741350 100644
>>> --- a/drivers/crypto/Kconfig
>>> +++ b/drivers/crypto/Kconfig
>>> @@ -38,11 +38,11 @@ config CRYPTO_DEV_PADLOCK_AES
>>>       If unsure say M. The compiled module will be
>>>       called padlock-aes.
>>>
>>>  config CRYPTO_DEV_PADLOCK_SHA
>>>     tristate "PadLock driver for SHA1 and SHA256 algorithms"
>>> -   depends on CRYPTO_DEV_PADLOCK
>>> +   depends on CRYPTO_DEV_PADLOCK && BROKEN
>>
>> It's only broken on ZHAOXIN, so this should be conditional on
>> CPU_SUP_ZHAOXIN.
>>
> 
> I.e., it's apparently broken on at least every CPU that has this
> hardware that's been released in the last 14 years.  How confident are
> you that it still works on VIA CPUs from 2011 and earlier and is worth
> maintaining for them?

Given the lack of a verification platform for the current padlock-sha
driver, and the fact that these CPUs are rarely used today, extending
the existing padlock-sha driver to support the ZHAOXIN platform is very
difficult. To address the issues encountered when using the padlock-sha
driver on the ZHAOXIN platform, would it be acceptable to submit a
completely new driver that aligns with the previous advice?

Best Regards
AlanSong-oc

