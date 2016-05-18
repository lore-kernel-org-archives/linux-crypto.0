From: Gary R Hook <ghook@amd.com>
Subject: Re: Typos and RSA
Date: Wed, 18 May 2016 10:57:26 -0500
Message-ID: <573C90E6.8000203@amd.com>
References: <573B8BA3.8020902@amd.com>
 <ae33e745-feca-c588-015d-bf2b4ca461f0@intel.com> <573B9F54.7050006@amd.com>
 <6203568.4quGhfsc99@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	<linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0091.outbound.protection.outlook.com ([207.46.100.91]:64698
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753262AbcERP5d (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 May 2016 11:57:33 -0400
In-Reply-To: <6203568.4quGhfsc99@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Ah.... enlightenment can be such an uncomfortable thing...

On 05/17/2016 05:56 PM, Stephan Mueller wrote:
> Am Dienstag, 17. Mai 2016, 17:46:44 schrieb Gary R Hook:
>
> Hi Gary,
>
>> Thanks so much.
>>
>> There are exactly 3 references to that symbol (in my freshly pulled copy
>> of cryptodev-2.6).
>> testmgr.c precipitates my questions, and public_key.c doesn't actually
>> provide any content
>> in the source input buffer, neither modulus nor plaintext. Thus, it
>> doesn't clarify things
>> either.
>>
>> But I truly appreciate your attention.
>>
>> So I'll go ahead and ask, because I did look at the two areas mentioned
>> by Stephan, but
>> neither seem to clarify (to my admittedly ignorant eyes... I'm a real
>> newbie on crypto here)
>> usage.
> Here is an example from a current code of mine (all kccavs symbols are private
> to my code):

Yes, thank you. After spending more time wandering through rsa.c & 
rsa_helper.c
I have come to realize that I have been laboring under a paradigm imposed by
my implementation requirements. Now that I have that cleared up, the 
answer to
my question it self-evident.Although I'm still not clear on why testmgr 
feels
the need to create a SGL table with an empty second element (for the 
existing
tests), rather than a single SGL. But that's neither here nor there.

As I said, I'm a newbie with lots to learn about this stuff. Thanks for your
patience.
