Received: from www.kot-begemot.co.uk (ns1.kot-begemot.co.uk [217.160.28.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB814A7
	for <linux-crypto@vger.kernel.org>; Mon,  4 Dec 2023 04:50:38 -0800 (PST)
Received: from [192.168.17.6] (helo=jain.kot-begemot.co.uk)
	by www.kot-begemot.co.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <anton.ivanov@kot-begemot.co.uk>)
	id 1rA8PA-007FyB-66; Mon, 04 Dec 2023 12:50:32 +0000
Received: from jain.kot-begemot.co.uk ([192.168.3.3])
	by jain.kot-begemot.co.uk with esmtp (Exim 4.96)
	(envelope-from <anton.ivanov@kot-begemot.co.uk>)
	id 1rA8P7-00AJ5F-0e;
	Mon, 04 Dec 2023 12:50:31 +0000
Message-ID: <2ea67aa8-3a6c-0f2e-93c6-446ea28f8b2f@kot-begemot.co.uk>
Date: Mon, 4 Dec 2023 12:50:28 +0000
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: jitterentropy vs. simulation
Content-Language: en-US
To: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>,
 Johannes Berg <johannes@sipsolutions.net>, linux-um@lists.infradead.org
Cc: linux-crypto@vger.kernel.org, =?UTF-8?Q?Stephan_M=c3=bcller?=
 <smueller@chronox.de>
References: <e4800de3138d3987d9f3c68310fcd9f3abc7a366.camel@sipsolutions.net>
 <7db861e3-60e4-0ed4-9b28-25a89069a9db@kot-begemot.co.uk>
 <8ddb48606cebe4e404d17a627138aa5c5af6dccd.camel@sipsolutions.net>
 <6cffe622-bf4b-4cba-bfac-037c5aa89a25@uni-rostock.de>
From: Anton Ivanov <anton.ivanov@kot-begemot.co.uk>
In-Reply-To: <6cffe622-bf4b-4cba-bfac-037c5aa89a25@uni-rostock.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -2.0
X-Spam-Score: -2.0
X-Clacks-Overhead: GNU Terry Pratchett



On 04/12/2023 12:06, Benjamin Beichler wrote:
> Am 01.12.2023 um 19:35 schrieb Johannes Berg:
>> [I guess we should keep the CCs so other see it]
>>
>>> Looking at the stuck check it will be bogus in simulations.
>>
>> True.
>>
>>> You might as well ifdef that instead.
>>>
>>> If a simulation is running insert the entropy regardless and do not compute the derivatives used in the check.
>>
>> Actually you mostly don't want anything inserted in that case, so it's
>> not bad to skip it.
>>
>> I was mostly thinking this might be better than adding a completely
>> unrelated ifdef. Also I guess in real systems with a bad implementation
>> of random_get_entropy(), the second/third derivates might be
>> constant/zero for quite a while, so may be better to abort?
> Maybe dump question: could we simply implement a timex.h for UM which delegates in non-timetravel mode to the x86 variant 

Sounds reasonable.

> and otherwise pull some randomness from the host or from a file/pipe configurable from the UML commandline for random_get_entropy()?

Second one.

We can run haveged in pipe mode and read from the pipe. Additionally, this will allow deterministic simulation if need be. You can record the haveged output and use it for more than one simulation.

> 
> I would say, if the random jitter is truly deterministic for a simulation, that seems to be good enough.
> 
> Said that, it would be nice to be able to configure all random sources to pull entropy from some file that we are able to configure from the command line, but that is a different topic.
> 
>>
>> In any case, I couldn't figure out any way to not configure this into
>> the kernel when any kind of crypto is also in ...
>>
>> johannes
>>
>>
> 
> 
> 
> 
> 

-- 
Anton R. Ivanov
https://www.kot-begemot.co.uk/
