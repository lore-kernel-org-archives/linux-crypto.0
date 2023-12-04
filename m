Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=uni-rostock.de header.i=@uni-rostock.de header.b="Wp1y7VjE";
	dkim=pass (1024-bit key) header.d=uni-rostock.de header.i=@uni-rostock.de header.b="qAgQWY57"
X-Greylist: delayed 299 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 04 Dec 2023 04:11:47 PST
Received: from mx1.uni-rostock.de (mx1.uni-rostock.de [139.30.22.71])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0DAEE6
	for <linux-crypto@vger.kernel.org>; Mon,  4 Dec 2023 04:11:46 -0800 (PST)
Received: from 139.30.22.84 by mx1.uni-rostock.de (Tls12, Aes256, Sha384,
 DiffieHellmanEllipticKey384); Mon, 04 Dec 2023 12:06:45 GMT
DKIM-Signature: v=1; c=relaxed/relaxed; d=uni-rostock.de; s=itmze; 
 t=1701691605; bh=OCIXVOliNM/mKvIQEs2vJxlTlzv3NC4XIbxWAn96+Ls=; h=
 Subject:Subject:From:From:Date:Date:ReplyTo:ReplyTo:Cc:Cc:Message-Id:Message-Id; 
 a=ed25519-sha256; b=
 Wp1y7VjEAET3niNQ+QN86zfAKFiRJFGS9odoGivA3yfsm//StMnWDZ/lM+VxvgB76jlvkm1+R/CDY9vWw/u5Cw==
DKIM-Signature: v=1; c=relaxed/relaxed; d=uni-rostock.de; s=itmz; 
 t=1701691605; bh=OCIXVOliNM/mKvIQEs2vJxlTlzv3NC4XIbxWAn96+Ls=; h=
 Subject:Subject:From:From:Date:Date:ReplyTo:ReplyTo:Cc:Cc:Message-Id:Message-Id; 
 a=rsa-sha256; b=
 qAgQWY57jeYONfIMve0kMF2WH2kRlp0IPOUUsFiVmN/lbRtgwH3ofWVwfEU08OJN1Uinl8ynIQUAO+TlRqSeKO0hQvozLYy0W004hgb7Bedst9RMTuHa3Dt/nQYGYPl6YOOLyvUlIei2zq+tMhiNH0xqnac1KLJG5AT7FMDJewI=
Received: from [139.30.201.32] (139.30.201.32) by mail1.uni-rostock.de
 (139.30.22.84) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.40; Mon, 4 Dec
 2023 13:06:44 +0100
Message-ID: <6cffe622-bf4b-4cba-bfac-037c5aa89a25@uni-rostock.de>
Date: Mon, 4 Dec 2023 13:06:43 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: jitterentropy vs. simulation
Content-Language: de-DE
To: Johannes Berg <johannes@sipsolutions.net>, Anton Ivanov
	<anton.ivanov@kot-begemot.co.uk>, <linux-um@lists.infradead.org>
CC: <linux-crypto@vger.kernel.org>, =?UTF-8?Q?Stephan_M=C3=BCller?=
	<smueller@chronox.de>
References: <e4800de3138d3987d9f3c68310fcd9f3abc7a366.camel@sipsolutions.net>
 <7db861e3-60e4-0ed4-9b28-25a89069a9db@kot-begemot.co.uk>
 <8ddb48606cebe4e404d17a627138aa5c5af6dccd.camel@sipsolutions.net>
From: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>
Organization: =?UTF-8?Q?Universit=C3=A4t_Rostock?=
In-Reply-To: <8ddb48606cebe4e404d17a627138aa5c5af6dccd.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EMAIL2.uni-rostock.de (139.30.22.82) To
 mail1.uni-rostock.de (139.30.22.84)
X-TM-SNTS-SMTP:
	6F2B22E2EF85B60F7C1A3ABE4129E3D73B303944A0C3E9D993A51785A6D002632000:8

Am 01.12.2023 um 19:35 schrieb Johannes Berg:
> [I guess we should keep the CCs so other see it]
> 
>> Looking at the stuck check it will be bogus in simulations.
> 
> True.
> 
>> You might as well ifdef that instead.
>>
>> If a simulation is running insert the entropy regardless and do not compute the derivatives used in the check.
> 
> Actually you mostly don't want anything inserted in that case, so it's
> not bad to skip it.
> 
> I was mostly thinking this might be better than adding a completely
> unrelated ifdef. Also I guess in real systems with a bad implementation
> of random_get_entropy(), the second/third derivates might be
> constant/zero for quite a while, so may be better to abort?
Maybe dump question: could we simply implement a timex.h for UM which 
delegates in non-timetravel mode to the x86 variant and otherwise pull 
some randomness from the host or from a file/pipe configurable from the 
UML commandline for random_get_entropy()?

I would say, if the random jitter is truly deterministic for a 
simulation, that seems to be good enough.

Said that, it would be nice to be able to configure all random sources 
to pull entropy from some file that we are able to configure from the 
command line, but that is a different topic.

> 
> In any case, I couldn't figure out any way to not configure this into
> the kernel when any kind of crypto is also in ...
> 
> johannes
> 
> 




