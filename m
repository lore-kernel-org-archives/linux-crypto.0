Received: from mx2.zhaoxin.com (mx2.zhaoxin.com [61.152.208.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15525329C5F
	for <linux-crypto@vger.kernel.org>; Thu, 15 Jan 2026 07:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=61.152.208.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768463338; cv=none; b=l4vzPhZOzD2dHOxaIRvqEyRsblmFSxtF0m+GSvGVZPmwCZraJKR8aBxkQXFSNve0gjaINsCBsNbrfjj28NH+Ndv4um/0OGgZH/GxWhdxnl0y/wUV3lD2yPjn2Q5a2oKQmi4rVqna06GPrpAbK2uIoKR/y0/fHzKfqzsZfY/PUIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768463338; c=relaxed/simple;
	bh=A3o6DVrjxxLv+wF6Ewn9yJcsjro1OpHQKU+gOWZRWSI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=dHi3B2UWAhzv44NPNDE1vhIngbG9oT6ilmjxJzokVTU3Z5umyXq2kKimt6ZPz+lsnn0/nHTAbd26hgFHoip+8fEm+FjS/X6RQ/ffb2vBJUuZ7T4iMWWCkd9ILhR/5pSQ8fo5O2xTedjmemPvxlwImv1/U2c6lpyu/zejYVlLMSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=61.152.208.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1768463313-1eb14e7c0217480001-Xm9f1P
Received: from ZXSHMBX1.zhaoxin.com (ZXSHMBX1.zhaoxin.com [10.28.252.163]) by mx2.zhaoxin.com with ESMTP id 829odVcBCXBRJuTc (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Thu, 15 Jan 2026 15:48:33 +0800 (CST)
X-Barracuda-Envelope-From: AlanSong-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from ZXSHMBX1.zhaoxin.com (10.28.252.163) by ZXSHMBX1.zhaoxin.com
 (10.28.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.59; Thu, 15 Jan
 2026 15:48:32 +0800
Received: from ZXSHMBX1.zhaoxin.com ([fe80::936:f2f9:9efa:3c85]) by
 ZXSHMBX1.zhaoxin.com ([fe80::936:f2f9:9efa:3c85%7]) with mapi id
 15.01.2507.059; Thu, 15 Jan 2026 15:48:32 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from [10.32.65.156] (10.32.65.156) by ZXBJMBX02.zhaoxin.com
 (10.29.252.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.59; Thu, 15 Jan
 2026 15:47:28 +0800
Message-ID: <2c5d1b26-8e12-4a93-8525-7fc7b9147bd7@zhaoxin.com>
Date: Thu, 15 Jan 2026 15:47:15 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] lib/crypto: x86/sha1: PHE Extensions optimized
 SHA1 transform function
To: Eric Biggers <ebiggers@kernel.org>
X-ASG-Orig-Subj: Re: [PATCH v2 1/2] lib/crypto: x86/sha1: PHE Extensions optimized
 SHA1 transform function
CC: <herbert@gondor.apana.org.au>, <Jason@zx2c4.com>, <ardb@kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<CobeChen@zhaoxin.com>, <TonyWWang-oc@zhaoxin.com>, <YunShen@zhaoxin.com>,
	<GeorgeXue@zhaoxin.com>, <LeoLiu-oc@zhaoxin.com>, <HansHu@zhaoxin.com>,
	<x86@kernel.org>
References: <cover.1766131281.git.AlanSong-oc@zhaoxin.com>
 <aa8ed72a109480887bdb3f3b36af372eadf0e499.1766131281.git.AlanSong-oc@zhaoxin.com>
 <20251219181805.GA1797@sol>
 <7aa1603d-6520-414a-a2a1-3a5289724814@zhaoxin.com>
 <20260112193445.GA1952@sol>
From: AlanSong-oc <AlanSong-oc@zhaoxin.com>
In-Reply-To: <20260112193445.GA1952@sol>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: zxbjmbx1.zhaoxin.com (10.29.252.163) To
 ZXBJMBX02.zhaoxin.com (10.29.252.6)
X-Moderation-Data: 1/15/2026 3:48:25 PM
X-Barracuda-Connect: ZXSHMBX1.zhaoxin.com[10.28.252.163]
X-Barracuda-Start-Time: 1768463313
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.36:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 1988
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.153062
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------

On 1/13/2026 3:34 AM, Eric Biggers wrote:
> 
> On Mon, Jan 12, 2026 at 05:12:01PM +0800, AlanSong-oc wrote:
>>> Is it supported in both 32-bit and 64-bit modes?  Your patch doesn't
>>> check for CONFIG_64BIT.  Should it?  New optimized assembly code
>>> generally should be 64-bit only.
>>
>> The XSHA1 and XSHA256 are supported in both 32-bit and 64-bit modes.
>> Since newly optimized assembly code is typically 64-bit only, and XSHA1
>> and XSHA256 fully support 64-bit mode, an explicit CONFIG_64BIT check
>> should not required.
> 
> Right, all the x86-optimized SHA-1 and SHA-256 code is already 64-bit
> specific, due to CONFIG_CRYPTO_LIB_SHA1_ARCH and
> CONFIG_CRYPTO_LIB_SHA256_ARCH being enabled only when CONFIG_x86_64=y.
> So there's no need to check for 64-bit again.
> 
>>> What is the difference between X86_FEATURE_PHE and X86_FEATURE_PHE_EN,
>>> and why are both needed?
>>
>> The X86_FEATURE_PHE indicates the presence of the XSHA1 and XSHA256
>> instructions, whereas the X86_FEATURE_PHE_EN indicates that these
>> instructions are enabled for normal use.
> 
> I still don't understand the difference.
> 
> If you look at the other CPU feature flags, like X86_FEATURE_SHA_NI for
> example, there's just a single flag for the feature.  We don't have
> X86_FEATURE_SHA_NI and X86_FEATURE_SHA_NI_EN.  If the CPU supports the
> feature but the kernel decides it can't or shouldn't be used for
> whatever reason, the kernel just doesn't set the flag.  There's no
> separate flag that tracks the CPU support independently.
> 
> Why can't the PHE flag work the same way?

Unlike most x86 CPU features, the PHE extension uses two bits to
describe a single feature: a present bit and an enable bit. On Zhaoxin
processors, these two bits are always identical. Therefore, in the next
revision of this patch, I will only check X86_FEATURE_PHE_EN, as with
other CPU support checks. Thanks for the suggestion.

Best Regards
AlanSong-oc


