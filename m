From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH] crypto: ccp - Check for CCP before registering crypto
 algs
Date: Mon, 22 Sep 2014 10:07:39 -0500
Message-ID: <54203B3B.70307@amd.com>
References: <20140905153109.14637.12600.stgit@tlendack-t1.amdoffice.net>
 <alpine.LNX.2.11.1409052327320.570@localhost.localdomain>
 <20140915114709.GB4923@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Scot Doyle <lkml14@scotdoyle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0144.outbound.protection.outlook.com ([65.55.169.144]:16169
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754300AbaIVPHu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 22 Sep 2014 11:07:50 -0400
In-Reply-To: <20140915114709.GB4923@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/15/2014 06:47 AM, Herbert Xu wrote:
> On Fri, Sep 05, 2014 at 11:49:38PM +0000, Scot Doyle wrote:
>>
>> On Fri, 5 Sep 2014, Tom Lendacky wrote:
>>
>>> If the ccp is built as a built-in module, then ccp-crypto (whether
>>> built as a module or a built-in module) will be able to load and
>>> it will register its crypto algorithms.  If the system does not have
>>> a CCP this will result in -ENODEV being returned whenever a command
>>> is attempted to be queued by the registered crypto algorithms.
>>>
>>> Add an API, ccp_present(), that checks for the presence of a CCP
>>> on the system.  The ccp-crypto module can use this to determine if it
>>> should register it's crypto alogorithms.
>>>
>>> Reported-by: Scot Doyle <lkml14@scotdoyle.com>
>>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> Tested-by: Scot Doyle <lkml14@scotdoyle.com>
>
> Patch applied.  Thanks!
>

Hi Herbert,

Can you push this patch into the 3.17 release?

Also, it should probably go into to the stable releases.  Is this
something that you request or should I take care of that?

Thanks,
Tom
