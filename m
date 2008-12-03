From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH] crypto: talitos - Fix modpost warning
Date: Wed, 3 Dec 2008 09:36:05 -0600
Message-ID: <9DE57422-83C5-4561-9D94-4C74865E5994@kernel.crashing.org>
References: <1228278556-1056-1-git-send-email-galak@kernel.crashing.org> <20081203120640.GB9818@gondor.apana.org.au> <75DC3D14-4019-4C55-A553-C54063790DD8@kernel.crashing.org>
Mime-Version: 1.0 (Apple Message framework v929.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linuxppc-dev@ozlabs.org,
	linux-crypto@vger.kernel.org
To: Kumar Gala <galak@kernel.crashing.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:55993 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240AbYLCPgS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Dec 2008 10:36:18 -0500
In-Reply-To: <75DC3D14-4019-4C55-A553-C54063790DD8@kernel.crashing.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On Dec 3, 2008, at 8:52 AM, Kumar Gala wrote:

>
> On Dec 3, 2008, at 6:06 AM, Herbert Xu wrote:
>
>> On Tue, Dec 02, 2008 at 10:29:16PM -0600, Kumar Gala wrote:
>>> Removed __devexit from talitos_remove() since its also called from
>>> talitos_probe().
>>>
>>> WARNING: vmlinux.o(.text+0x28a008): Section mismatch in reference  
>>> from the function talitos_probe() to the  
>>> function .devexit.text:talitos_remove()
>>> The function talitos_probe() references a function in an exit  
>>> section.
>>> Often the function talitos_remove() has valid usage outside the  
>>> exit section
>>> and the fix is to remove the __devexit annotation of talitos_remove.
>>>
>>> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
>>
>> OK, but what about the __devexit_p reference on talitos_remove?
>> We should remove that too.
>
> missed that one.  will fix up and post a new patch.

Nevermind.  Al bet me to this fix :)

- k
