From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH] crypto: talitos - Fix modpost warning
Date: Wed, 3 Dec 2008 08:52:29 -0600
Message-ID: <75DC3D14-4019-4C55-A553-C54063790DD8@kernel.crashing.org>
References: <1228278556-1056-1-git-send-email-galak@kernel.crashing.org> <20081203120640.GB9818@gondor.apana.org.au>
Mime-Version: 1.0 (Apple Message framework v929.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@ozlabs.org, linux-crypto@vger.kernel.org,
	kim.phillips@freescale.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:50614 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbYLCOyt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Dec 2008 09:54:49 -0500
In-Reply-To: <20081203120640.GB9818@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On Dec 3, 2008, at 6:06 AM, Herbert Xu wrote:

> On Tue, Dec 02, 2008 at 10:29:16PM -0600, Kumar Gala wrote:
>> Removed __devexit from talitos_remove() since its also called from
>> talitos_probe().
>>
>> WARNING: vmlinux.o(.text+0x28a008): Section mismatch in reference  
>> from the function talitos_probe() to the  
>> function .devexit.text:talitos_remove()
>> The function talitos_probe() references a function in an exit  
>> section.
>> Often the function talitos_remove() has valid usage outside the  
>> exit section
>> and the fix is to remove the __devexit annotation of talitos_remove.
>>
>> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
>
> OK, but what about the __devexit_p reference on talitos_remove?
> We should remove that too.

missed that one.  will fix up and post a new patch.

- k
