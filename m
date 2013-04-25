From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Fwd: crypto accelerator driver problems
Date: Thu, 25 Apr 2013 17:31:18 +0800
Message-ID: <20130425093118.GA27867@gondor.apana.org.au>
References: <loom.20130425T054131-302@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Vakul Garg <vakul@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:44153 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751744Ab3DYJbV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Apr 2013 05:31:21 -0400
Content-Disposition: inline
In-Reply-To: <loom.20130425T054131-302@post.gmane.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Vakul Garg <vakul@freescale.com> wrote:
> Herbert Xu <herbert <at> gondor.apana.org.au> writes:
> 
>> 
>> On Wed, Jan 26, 2011 at 10:26:33AM +0330, Hamid Nassiby wrote:
>> >
>> > As you know, I posted my problem again to crypto list and no one 
> answered.
>> > Now I
>> > emphasize one aspect of the problem as a concept related to IPSec 
> protocol,
>> > free
>> > of my problem's nature, and I hope to get some guidelines at this time. 
> The
>> > question is as following:
>> > If IPSec delivers IP packets to hardware crypto accelerator in 
> sequential
>> > manner
>> > (e.g, packets in order: 1, 2, 3, ..., 36, 37, 38,...) and crypto 
> accelerator
>> > possibly returns back packets out of entering order to IPSec (e.g, 
> packet
>> > 37 is returned back before the packet 36 to IPSec, so the order of 
> packets
>> > is
>> > not the same before entering crypto accelerator and after exiting it); 
> Is it
>> > possible to rise any problem here?
>> 
>> We do not allow such reordering.  All crypto drivers must ensure
>> ordering within a single tfm.  Between different tfms there is no
>> ordering requirement.
>> 
>> Cheers,
> 
> 
> Hello Herbert,
> 
> Does this mean that processing of all the crypto requests from a single tfm 
> must be serialized even if they execute on multiple different cores?

Correct.  Conceptually a single tfm is like a thread, if one
wanted parallelism then multiple tfms should be used.  Of course
there are exceptions such as pcrypt.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
