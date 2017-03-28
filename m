From: Gary R Hook <ghook@amd.com>
Subject: Re: [PATCH 1/2] crypto: ccp - Reduce stack frame size with KASAN
Date: Tue, 28 Mar 2017 10:56:55 -0500
Message-ID: <e802c4f7-78d4-bbca-4ac4-3b9b528a8e67@amd.com>
References: <20170328095814.3734615-1-arnd@arndb.de>
 <f04b2ede-f291-2ffa-d4a8-124d4af06199@amd.com>
 <CAK8P3a2T4ZmT+EWqARw0L7X+E-B36_RwmBRD7PM-8YBnSMR0Pw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>, "Hook, Gary" <Gary.Hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-cys01nam02on0085.outbound.protection.outlook.com ([104.47.37.85]:56093
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752228AbdC1P5L (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Mar 2017 11:57:11 -0400
In-Reply-To: <CAK8P3a2T4ZmT+EWqARw0L7X+E-B36_RwmBRD7PM-8YBnSMR0Pw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 03/28/2017 10:10 AM, Arnd Bergmann wrote:
>>> -};
>>> +} __packed __aligned(4);
>>
>> My gcc 4.8 doesn't understand __aligned(). Shouldn't we use
>> #pragma(4) here?
>
> That is odd, the __aligned() macro gets defined for all compiler versions
> in linux/compiler.h, and the aligned attribute should work for all supported
> compilers (3.2 and higher), while #pragma pack() requires gcc-4.0 or
> higher.
>

Tried again in a couple of trees. Not sure what I did wrong, but the 
compiler
seems to be happy now. Huh.

Will submit a V2.


-- 
This is my day job. Follow me at:
IG/Twitter/Facebook: @grhookphoto
IG/Twitter/Facebook: @grhphotographer
