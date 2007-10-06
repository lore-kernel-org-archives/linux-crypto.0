From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH] [crypto] load the SHA1[1|256] module by an alias (v2)
Date: Sun, 7 Oct 2007 00:02:20 +0200
Message-ID: <20071006220220.GC3645@Chamillionaire.breakpoint.cc>
References: <E1IMveX-0002Kv-00@gondolin.me.apana.org.au> <20070820101618.GE16680@bingen.suse.de> <20070820120605.GA13163@gondor.apana.org.au> <20070930124239.GB24811@Chamillionaire.breakpoint.cc> <20071003073522.GA7285@gondor.apana.org.au> <20071004083512.GA11305@Chamillionaire.breakpoint.cc> <E1IdMSX-0004KV-LS@Chamillionaire.breakpoint.cc> <20071005085744.GC10959@gondor.apana.org.au> <E1IdnjO-0006eu-JQ@Chamillionaire.breakpoint.cc> <20071005151051.GA13666@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:52265 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753850AbXJFWCX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 6 Oct 2007 18:02:23 -0400
Content-Disposition: inline
In-Reply-To: <20071005151051.GA13666@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-10-05 23:10:51 [+0800]:

>On Fri, Oct 05, 2007 at 03:12:10PM +0200, Sebastian Siewior wrote:
>> Loading the crypto algorithm by the alias instead of by module directly
>> has the advantage that all possible implementations of this algorithm
>> are loaded automatically and the crypto API can choose the best one
>> depending on its priority.
>> Additionally it ensures that the generic implementation as well as the
>> HW driver (if available) is loaded in case the HW driver needs the
>> generic version as fallback in corner cases.
>> Also remove the probe for sha1 in padlock's init code.
>> Quote from Herbert:
>>   The probe is actually pointless since we can always probe when
>>   the algorithm is actually used which does not lead to dead-locks
>>   like this.
>
>Thanks.  I'll apply this tomorrow.
>
>BTW, the dead-lock does exist after all.  The lock that's held
>is the user-space file lock held by modprobe.  Assuming that
>padlock-sha comes before sha in the alias list, then the second
>modprobe will hit padlock-sha again and dead-lock.

Really, hmm. That CRYPTO_ALG_NEED_FALLBACK flag is unused than? 
I try to remove the hardware specific code and test the via-sha code as
it once I have some time in my hands :)

>Cheers,

Sebastian
