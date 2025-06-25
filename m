Received: from mx1.zhaoxin.com (MX1.ZHAOXIN.COM [210.0.225.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760CF1A4E9E
	for <linux-crypto@vger.kernel.org>; Wed, 25 Jun 2025 02:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.0.225.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750819979; cv=none; b=m7zDqE/HOYICzsBFpOnG5YUMTZ4LaIHp923rwICmFj4pLi4uxvXH+ZX5rfZvx5ctggGpmkfDDd2kpje+EcYPbl0sjRAK4n43dmFahp5i9wvIGiqsaKfTMxXfiEB51crrkEI6B7Xx+tIIwCIhPjMLEKT0UJ6k+XTYgxAwDSueQd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750819979; c=relaxed/simple;
	bh=5Vc/UGNf9cacJtpbOxvWORJCZbxG0TDrntdUXMei9cg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=kO11XIhvrDjCIVtWY6ZzaLbW8iBmfDBrDQv3AO5hYT4GL5YOmjnXBxPPRSSmoCXA7qrsU1Zh7f8Pcxm72lJDMgILEiZP/fuYvnX+5xUG5ANpVoBFjBtzGSq6pktLuTHeO7WIQTeKwBMXDWzzqSbRLEBQIg12ai7aBciGL1ZUZwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=210.0.225.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1750819244-086e2327854ec60001-Xm9f1P
Received: from ZXSHMBX2.zhaoxin.com (ZXSHMBX2.zhaoxin.com [10.28.252.164]) by mx1.zhaoxin.com with ESMTP id 9lNAzvJPGrj7CAlD (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Wed, 25 Jun 2025 10:40:44 +0800 (CST)
X-Barracuda-Envelope-From: AlanSong-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.164
Received: from ZXSHMBX1.zhaoxin.com (10.28.252.163) by ZXSHMBX2.zhaoxin.com
 (10.28.252.164) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.44; Wed, 25 Jun
 2025 10:40:43 +0800
Received: from ZXSHMBX1.zhaoxin.com ([::1]) by ZXSHMBX1.zhaoxin.com
 ([fe80::2c07:394e:4919:4dc1%7]) with mapi id 15.01.2507.044; Wed, 25 Jun 2025
 10:40:43 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.164
Received: from [10.32.65.156] (10.32.65.156) by ZXBJMBX02.zhaoxin.com
 (10.29.252.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.44; Wed, 25 Jun
 2025 09:51:57 +0800
Message-ID: <bcaaccf4-4048-48a0-a9f9-64902a16a049@zhaoxin.com>
Date: Wed, 25 Jun 2025 09:51:56 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: padlock-sha - Add support for Zhaoxin processor
To: Herbert Xu <herbert@gondor.apana.org.au>
X-ASG-Orig-Subj: Re: [PATCH] crypto: padlock-sha - Add support for Zhaoxin processor
CC: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <CobeChen@zhaoxin.com>,
	<TonyWWang-oc@zhaoxin.com>, <YunShen@zhaoxin.com>, <GeorgeXue@zhaoxin.com>,
	<LeoLiu-oc@zhaoxin.com>, <HansHu@zhaoxin.com>
References: <20250611101750.6839-1-AlanSong-oc@zhaoxin.com>
 <aEpgKQ1I0VDSfhO0@gondor.apana.org.au>
 <0575ec9d-a6b8-4932-a1aa-9646813957a2@zhaoxin.com>
 <aFkdNoQFmr8-x4cu@gondor.apana.org.au>
From: AlanSong-oc <AlanSong-oc@zhaoxin.com>
In-Reply-To: <aFkdNoQFmr8-x4cu@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: zxbjmbx1.zhaoxin.com (10.29.252.163) To
 ZXBJMBX02.zhaoxin.com (10.29.252.6)
X-Moderation-Data: 6/25/2025 10:40:42 AM
X-Barracuda-Connect: ZXSHMBX2.zhaoxin.com[10.28.252.164]
X-Barracuda-Start-Time: 1750819244
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.35:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 479
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.143354
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------

On 6/23/2025 5:24 PM, Herbert Xu wrote:
> Thanks for the explanation.  There is no requirement to use struct
> sha1_state.  Just supply a custom version of the struct for the
> shash descriptor that includes the necessary space.
> 
> IOW do the copy in the rarely used export/import functions, instead
> of on every hash operation.

Sorry for the late reply. Thank you for your suggestion and review.

I will send an updated patch soon.

Best Regards
AlanSong-oc

