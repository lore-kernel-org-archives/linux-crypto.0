Received: from mx1.zhaoxin.com (MX1.ZHAOXIN.COM [210.0.225.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FAFB1F1302
	for <linux-crypto@vger.kernel.org>; Wed, 17 Dec 2025 09:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.0.225.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765965049; cv=none; b=fMykL5ffrGmLBh4NWz6b26RxQc6BS26YHeko/CdUvlVo+E1enA3BQQLklolNFW1XbI1W/no5JrzZnZlSfn8CEaMdxsbk14eXtYL+QtXo7WHU3vIVkMYggfFb8gz//6iiXP2jH0fGalJ/FPgqMM0Y7mv5lZ6qnAW82GuxezSWcbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765965049; c=relaxed/simple;
	bh=+d3YNfwmIyeoC2NED+GG4MA+EfH+hauMrMLExjHm8+c=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=FX6bCw0lyADxCTnOu2vVVTfsNerfTKAI2xWEOGCJCYoMLFpIeknuxrvq1a/FRHKLt7gyV6HiaasTyTRnFCE5bbIH9CkmKvEC5a7InD0Kdk51XuX+Ne7Vwj1dxLaMf+eMPQFlw8qE+a5uWYIucXhstI9ZC5Yok1+vKQfvzPbmqlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=210.0.225.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1765963903-086e230b311c1790001-Xm9f1P
Received: from ZXSHMBX1.zhaoxin.com (ZXSHMBX1.zhaoxin.com [10.28.252.163]) by mx1.zhaoxin.com with ESMTP id uaIQz7PdJZDKrDxO (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Wed, 17 Dec 2025 17:31:43 +0800 (CST)
X-Barracuda-Envelope-From: AlanSong-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from ZXSHMBX1.zhaoxin.com (10.28.252.163) by ZXSHMBX1.zhaoxin.com
 (10.28.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.59; Wed, 17 Dec
 2025 17:31:42 +0800
Received: from ZXSHMBX1.zhaoxin.com ([fe80::936:f2f9:9efa:3c85]) by
 ZXSHMBX1.zhaoxin.com ([fe80::936:f2f9:9efa:3c85%7]) with mapi id
 15.01.2507.059; Wed, 17 Dec 2025 17:31:42 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from [10.32.65.156] (10.32.65.156) by ZXBJMBX02.zhaoxin.com
 (10.29.252.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.59; Wed, 17 Dec
 2025 17:04:47 +0800
Message-ID: <f82e5d10-4300-4f7a-befe-fed524b52d92@zhaoxin.com>
Date: Wed, 17 Dec 2025 17:04:25 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: padlock-sha - Disable broken driver
To: Herbert Xu <herbert@gondor.apana.org.au>
X-ASG-Orig-Subj: Re: [PATCH] crypto: padlock-sha - Disable broken driver
CC: Eric Biggers <ebiggers@kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, larryw3i <larryw3i@yeah.net>,
	<stable@vger.kernel.org>, <CobeChen@zhaoxin.com>, <GeorgeXue@zhaoxin.com>,
	<HansHu@zhaoxin.com>, <LeoLiu-oc@zhaoxin.com>, <TonyWWang-oc@zhaoxin.com>,
	<YunShen@zhaoxin.com>
References: <3af01fec-b4d3-4d0c-9450-2b722d4bbe39@yeah.net>
 <20251116183926.3969-1-ebiggers@kernel.org>
 <aRvpWqwQhndipqx-@gondor.apana.org.au> <20251118040244.GB3993@sol>
 <cd6a8143-f93a-4843-b8f6-dbff645c7555@zhaoxin.com>
 <aUI4CGp6kK7mxgEr@gondor.apana.org.au>
From: AlanSong-oc <AlanSong-oc@zhaoxin.com>
In-Reply-To: <aUI4CGp6kK7mxgEr@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: zxbjmbx1.zhaoxin.com (10.29.252.163) To
 ZXBJMBX02.zhaoxin.com (10.29.252.6)
X-Moderation-Data: 12/17/2025 5:31:41 PM
X-Barracuda-Connect: ZXSHMBX1.zhaoxin.com[10.28.252.163]
X-Barracuda-Start-Time: 1765963903
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://mx2.zhaoxin.com:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 772
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.151688
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------


On 12/17/2025 12:56 PM, Herbert Xu wrote:
> On Wed, Dec 17, 2025 at 12:30:57PM +0800, AlanSong-oc wrote:
>>
>> Given the lack of a verification platform for the current padlock-sha
>> driver, and the fact that these CPUs are rarely used today, extending
>> the existing padlock-sha driver to support the ZHAOXIN platform is very
>> difficult. To address the issues encountered when using the padlock-sha
>> driver on the ZHAOXIN platform, would it be acceptable to submit a
>> completely new driver that aligns with the previous advice?
> 
> Perhaps it would be easier if you just added Zhaoxin support to
> lib/crypto instead?

Sincere thanks for your helpful suggestion. I will add ZHAOXIN platform
support to lib/crypto.

Best Regards
AlanSong-oc

