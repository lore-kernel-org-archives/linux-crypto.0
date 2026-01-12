Received: from mx1.zhaoxin.com (MX1.ZHAOXIN.COM [210.0.225.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB2D246770
	for <linux-crypto@vger.kernel.org>; Mon, 12 Jan 2026 09:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.0.225.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768210229; cv=none; b=oVrCJnl0MHS+bAR8+ohb10nAKPA0azudbNj2jgo94sReZh+CRRi6Dlu5hv9AJTlqYAwSuV5/hVR2+r1TQNKSughGoohtgOksDk1I393BD8c4xdJvgKapZTlk9bk+oXU2AFY5bqaqUmrQBPqnGfbs+AbZD4wv//eSXAlWVLPICGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768210229; c=relaxed/simple;
	bh=muqEyrrFZNCXzAct5ZGS75CS/yaNxalGdlGvJP2/Yjc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Naxhi4O1lW/5tSl6Lo1VymSUhjGhUlawyLYLwk4/VSCzwfIFjUQr8LYAb0/b08i0t1QGqCtAKTMjFJXZBVugryB1jijTO8riClDvUYsHFI1ruNaOB8XIGAk6djZcOMvnEGZTZZ/4Y35rrnc+Ft/yPJhxTf9P22Ea612JyIEl4Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=210.0.225.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1768209497-086e2306f614c40001-Xm9f1P
Received: from ZXSHMBX1.zhaoxin.com (ZXSHMBX1.zhaoxin.com [10.28.252.163]) by mx1.zhaoxin.com with ESMTP id Bzr6BW985YcYbLuh (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Mon, 12 Jan 2026 17:18:17 +0800 (CST)
X-Barracuda-Envelope-From: AlanSong-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from ZXSHMBX1.zhaoxin.com (10.28.252.163) by ZXSHMBX1.zhaoxin.com
 (10.28.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.59; Mon, 12 Jan
 2026 17:18:17 +0800
Received: from ZXSHMBX1.zhaoxin.com ([fe80::936:f2f9:9efa:3c85]) by
 ZXSHMBX1.zhaoxin.com ([fe80::936:f2f9:9efa:3c85%7]) with mapi id
 15.01.2507.059; Mon, 12 Jan 2026 17:18:17 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from [10.32.65.156] (10.32.65.156) by ZXBJMBX02.zhaoxin.com
 (10.29.252.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.59; Mon, 12 Jan
 2026 17:12:41 +0800
Message-ID: <c4c74973-93c6-4c89-bf1c-33ca8521d251@zhaoxin.com>
Date: Mon, 12 Jan 2026 17:12:40 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] lib/crypto: x86/sha: Add PHE Extensions support
To: Eric Biggers <ebiggers@kernel.org>
X-ASG-Orig-Subj: Re: [PATCH v2 0/2] lib/crypto: x86/sha: Add PHE Extensions support
CC: <herbert@gondor.apana.org.au>, <Jason@zx2c4.com>, <ardb@kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<CobeChen@zhaoxin.com>, <TonyWWang-oc@zhaoxin.com>, <YunShen@zhaoxin.com>,
	<GeorgeXue@zhaoxin.com>, <LeoLiu-oc@zhaoxin.com>, <HansHu@zhaoxin.com>
References: <cover.1766131281.git.AlanSong-oc@zhaoxin.com>
 <20251219183357.GA1602@sol>
From: AlanSong-oc <AlanSong-oc@zhaoxin.com>
In-Reply-To: <20251219183357.GA1602@sol>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: zxbjmbx1.zhaoxin.com (10.29.252.163) To
 ZXBJMBX02.zhaoxin.com (10.29.252.6)
X-Moderation-Data: 1/12/2026 5:18:15 PM
X-Barracuda-Connect: ZXSHMBX1.zhaoxin.com[10.28.252.163]
X-Barracuda-Start-Time: 1768209497
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://mx2.zhaoxin.com:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 2490
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -1.62
X-Barracuda-Spam-Status: No, SCORE=-1.62 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_SC0_SA085b
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.152921
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.40 BSF_SC0_SA085b         Custom Rule SA085b

On 12/20/2025 2:33 AM, Eric Biggers wrote:
> 
> On Fri, Dec 19, 2025 at 04:03:04PM +0800, AlanSong-oc wrote:
>> For Zhaoxin processors, the XSHA1 instruction requires the total memory
>> allocated at %rdi register must be 32 bytes, while the XSHA1 and
>> XSHA256 instruction doesn't perform any operation when %ecx is zero.
>>
>> Due to these requirements, the current padlock-sha driver does not work
>> correctly with Zhaoxin processors. It cannot pass the self-tests and
>> therefore does not activate the driver on Zhaoxin processors. This issue
>> has been reported in Debian [1]. The self-tests fail with the
>> following messages [2]:
>>
>> alg: shash: sha1-padlock-nano test failed (wrong result) on test vector 0, cfg="init+update+final aligned buffer"
>> alg: self-tests for sha1 using sha1-padlock-nano failed (rc=-22)
>> ------------[ cut here ]------------
>>
>> alg: shash: sha256-padlock-nano test failed (wrong result) on test vector 0, cfg="init+update+final aligned buffer"
>> alg: self-tests for sha256 using sha256-padlock-nano failed (rc=-22)
>> ------------[ cut here ]------------
> 
> This cover letter is misleading, as those self-test failures will still
> exist regardless of this patch series.

Indeed, those self-test failures will still occur even with this patch
series. I will add a separate commit in this series to restrict probing
of the padlock-sha driver on Zhaoxin processors based on the CPU family,
and explain the reason for those failures in that commit.

>> To enable XSHA1 and XSHA256 instruction support on Zhaoxin processors,
>> this series adds PHE Extensions support to lib/crypto for SHA-1 and
>> SHA-256, following the suggestion in [3].
>>
>> v1 link is below:
>> https://lore.kernel.org/linux-crypto/20250611101750.6839-1-AlanSong-oc@zhaoxin.com/
> 
> Please run the sha1 and sha256 KUnit test suites
> (CRYPTO_LIB_SHA1_KUNIT_TEST and CRYPTO_LIB_SHA256_KUNIT_TEST) before and
> after this series, with the benchmark enabled (CRYPTO_LIB_BENCHMARK),
> and show the results.  For this series to be considered, the tests need
> to pass and there needs to be a significant performance improvement.

In the next revision of this patch, I will add the KUnit test suite
results as well as benchmark results for SHA1 and SHA256.

Please accept my apologies for the delayed response due to
administrative procedures. Thank you for your review and valuable
suggestions.

Best Regards
AlanSong-oc

