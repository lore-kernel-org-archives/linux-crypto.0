Received: from mx1.zhaoxin.com (MX1.ZHAOXIN.COM [210.0.225.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A2A29AAFD
	for <linux-crypto@vger.kernel.org>; Thu,  5 Mar 2026 06:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.0.225.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772691655; cv=none; b=Tu5CovrnVBXbEHvZllu9WtVIo+2mDSNHUPrMsySrZBcqIj+q0u5a79smEgJ9x4+opy1OKgC4KUNK2UxetYFC4AqF/iDoTWZVZZgry28tDLQmXE1Aw2A8vRCBwc7xUbg6Aauku582K806LOaNqmTp+2lHTuKMR1gm7QMWlgML4WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772691655; c=relaxed/simple;
	bh=DpE1EIq3D1AgNWW87thKIvs7DLv9tz4RbqJo6Th9Xvs=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:References:
	 In-Reply-To:Content-Type; b=A0lhjYSUFNWgmzP8inU+mP8HmYWstkgpNms/Srix8YiMJQ6j2X619sWQHH9cVWKQXiSJ6MXHoUkXlSB5R8Ile8zGE3Y5PrUDoWFDTs6lUCR92NA2DP3wYySeXhisOA/fxlXMQMRD7/QKxwcAF6c/oExK76ryj+VDrONiLPUf1MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=210.0.225.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1772690930-086e235c8457ad0001-Xm9f1P
Received: from ZXSHMBX1.zhaoxin.com (ZXSHMBX1.zhaoxin.com [10.28.252.163]) by mx1.zhaoxin.com with ESMTP id HafJTd7l5Uizxp6O (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Thu, 05 Mar 2026 14:08:50 +0800 (CST)
X-Barracuda-Envelope-From: AlanSong-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from ZXSHMBX1.zhaoxin.com (10.28.252.163) by ZXSHMBX1.zhaoxin.com
 (10.28.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.59; Thu, 5 Mar
 2026 14:08:49 +0800
Received: from ZXSHMBX1.zhaoxin.com ([fe80::936:f2f9:9efa:3c85]) by
 ZXSHMBX1.zhaoxin.com ([fe80::936:f2f9:9efa:3c85%7]) with mapi id
 15.01.2507.059; Thu, 5 Mar 2026 14:08:49 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from [10.32.65.156] (10.32.65.156) by ZXBJMBX02.zhaoxin.com
 (10.29.252.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.59; Thu, 5 Mar
 2026 09:36:55 +0800
Message-ID: <0a26d6f2-ea17-434d-8298-bb047c399803@zhaoxin.com>
Date: Thu, 5 Mar 2026 09:36:24 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: AlanSong-oc <AlanSong-oc@zhaoxin.com>
Subject: Re: [PATCH v3 1/3] crypto: padlock-sha - Disable for Zhaoxin
 processor
To: Eric Biggers <ebiggers@kernel.org>
X-ASG-Orig-Subj: Re: [PATCH v3 1/3] crypto: padlock-sha - Disable for Zhaoxin
 processor
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>, <Jason@zx2c4.com>,
	<ardb@kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>, <CobeChen@zhaoxin.com>,
	<TonyWWang-oc@zhaoxin.com>, <YunShen@zhaoxin.com>, <GeorgeXue@zhaoxin.com>,
	<LeoLiu-oc@zhaoxin.com>, <HansHu@zhaoxin.com>
References: <20260116071513.12134-1-AlanSong-oc@zhaoxin.com>
 <20260116071513.12134-2-AlanSong-oc@zhaoxin.com>
 <20260118000947.GE74518@quark>
In-Reply-To: <20260118000947.GE74518@quark>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: zxbjmbx1.zhaoxin.com (10.29.252.163) To
 ZXBJMBX02.zhaoxin.com (10.29.252.6)
X-Moderation-Data: 3/5/2026 2:08:48 PM
X-Barracuda-Connect: ZXSHMBX1.zhaoxin.com[10.28.252.163]
X-Barracuda-Start-Time: 1772690930
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://mx2.zhaoxin.com:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 514
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.155399
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------

On 1/18/2026 8:09 AM, Eric Biggers wrote:
> 
> On Fri, Jan 16, 2026 at 03:15:11PM +0800, AlanSong-oc wrote:
>>
>> Signed-off-by: AlanSong-oc <AlanSong-oc@zhaoxin.com>
> 
> Since this is a bug fix, please add Fixes and Cc stable tags.
> 

I will add Fixes and CC stable tags in the next version of the patch.

Please accept my apologies for the delayed response due to
administrative procedures and the recent holidays. Thank you for your
review and valuable suggestions.

Best Regards
AlanSong-oc
