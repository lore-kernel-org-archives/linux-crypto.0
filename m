From: Vladimir Zapolskiy <vz@mleia.com>
Subject: Re: [PATCH 1/2] crypto: s5p-sss - Minor coding cleanups
Date: Thu, 10 Mar 2016 01:40:12 +0200
Message-ID: <56E0B45C.903@mleia.com>
References: <1457259436-32560-1-git-send-email-krzk@kernel.org>
 <56DCD301.4030401@mleia.com> <56DCFE1D.7000106@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mleia.com ([178.79.152.223]:52417 "EHLO mail.mleia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964896AbcCIXkQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Mar 2016 18:40:16 -0500
In-Reply-To: <56DCFE1D.7000106@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Krzysztof,

On 07.03.2016 06:05, Krzysztof Kozlowski wrote:
> On 07.03.2016 10:01, Vladimir Zapolskiy wrote:
>> Hi Krzysztof,
>>
>> On 06.03.2016 12:17, Krzysztof Kozlowski wrote:
>>> Remove unneeded inclusion of delay.h and get rid of indentation from
>>> labels.
>>
>> just in case are you aware of this discussion regarding goto labels
>> http://lkml.iu.edu/hypermail/linux/kernel/0706.0/0809.html ?
>>
>> Practically there is no big need (neither it is a clean-up IMHO)
>> to change column 1 indentation of goto labels, however I do agree that
>> ^[a-z0-9_]\+:$ style of goto labels is 10 times more commonly used,
>> and that means it's a good time to update my ~/.emacs config.
>>
>> Someone may want to fix the style of another 5000+ goto labels one day,
>> though it is better to have an officially agreed policy beforehand.
>>
>> Anyway I do not strictly object against the change, see one my comment
>> below and feel free to add my
>>
>> Acked-by: Vladimir Zapolskiy <vz@mleia.com>
> 
> Actually I was not aware of that discussion, thanks for pointing this
> out. Mostly I encountered the style without indentation but of course
> that does not mean it is the only one.
> 
>>
>>> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
>>> ---
>>>  drivers/crypto/s5p-sss.c | 15 +++++++--------
>>>  1 file changed, 7 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
>>> index 5f161a9777e3..60f835455a41 100644
>>> --- a/drivers/crypto/s5p-sss.c
>>> +++ b/drivers/crypto/s5p-sss.c
>>> @@ -11,7 +11,6 @@
>>>   *
>>>   */
>>>  
>>> -#include <linux/delay.h>
>>>  #include <linux/err.h>
>>>  #include <linux/module.h>
>>>  #include <linux/init.h>
>>
>> Since you are here, can you sort headers out, please?
> 
> You mean sort by name (or by christmas tree)? I can... 

Thank you in advance.

> I am not sure
> about benefits of such patch (which should be the motivation for change).

In general it simplifies navigation through the list of headers for
humans IMHO.

By example, let's look at drivers/media/usb/dvb-usb/dw2102.c :

#include "dw2102.h"
#include "si21xx.h"
#include "stv0299.h"
#include "z0194a.h"
#include "stv0288.h"
#include "stb6000.h"
#include "eds1547.h"
#include "cx24116.h"
#include "tda1002x.h"
#include "mt312.h"
#include "zl10039.h"
#include "ts2020.h"
#include "ds3000.h"
#include "stv0900.h"
#include "stv6110.h"
#include "stb6100.h"
#include "stb6100_proc.h"
#include "m88rs2000.h"
#include "tda18271.h"
#include "cxd2820r.h"
#include "m88ds3103.h"
#include "ts2020.h"

Was it obvious for an author/reviewers that commit 0fecb6c0944f adds a
duplicate?

What is the chance to add a duplicate, if the list of headers is sorted?

>> And I'm pretty sure some more inclusions can be safely removed
>> from the list.
> 
> I checked them while removing delay - all of them seem to be used.

Good, thank you for checking it :)

--
With best wishes,
Vladimir
