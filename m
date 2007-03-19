From: Jan Glauber <jan.glauber@de.ibm.com>
Subject: Re: Problem with key sizes
Date: Mon, 19 Mar 2007 15:25:39 +0100
Message-ID: <1174314339.7212.20.camel@localhost.localdomain>
References: <20070316152347.GE13744@Chamillionaire.breakpoint.cc>
	 <E1HSQHB-0000Sn-00@gondolin.me.apana.org.au>
	 <20070317202853.GA7454@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate8.de.ibm.com ([195.212.29.157]:35934 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbXCSO0V (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Mar 2007 10:26:21 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate8.de.ibm.com (8.13.8/8.13.8) with ESMTP id l2JEQIj4097428
	for <linux-crypto@vger.kernel.org>; Mon, 19 Mar 2007 14:26:19 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2JEQJce1007770
	for <linux-crypto@vger.kernel.org>; Mon, 19 Mar 2007 15:26:19 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2JEQI6X019818
	for <linux-crypto@vger.kernel.org>; Mon, 19 Mar 2007 15:26:19 +0100
In-Reply-To: <20070317202853.GA7454@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, 2007-03-17 at 21:28 +0100, Sebastian Siewior wrote:
> * Herbert Xu | 2007-03-17 15:12:17 [+1100]:
> 
> >What exactly is the aes-special algorithm and where can I find a copy?
> The only difference between -special and -generic is the limited key
> size. It was just an example.
> 
> >Yes key length support is missing as far as algorithm selection
> >is concerned.  I haven't worried too much about it because there
> >hasn't been that many algorithms needing this.
> >
> >So my question is how hard is it to make aes-special support 16-bit keys?
> I was browsing through the api and noticed that the key size is not
> considered (except in proc code). If aes-special utilizes some hardware
> device to do the job it may be possible, that the hardware does not
> support all key sizes. This is the case for the Geode AES driver [1] and
> for the s390 aes driver [2]. The latter checks at runtime what key sizes
> are supported 

Currently aes-s390 registers for all three AES key sizes even if the
hardware only supports 128 bit keys. Could be changed easily to only
register for 128 bit keys but this would change nothing (beside having 
correct output in /proc/crypto). 

> while Geode can only handle 16 byte long keys (according to
> the source). 
> The author may still add part of the aes-generic code as a fall back or
> try to load a fullback algorithm like VIA PadLock SHA1 does [3]. I
> prefer the latter. Anyway: I don't like the idea of adding fall back code
> for a key size, that I never claimed to support.

Having fall back support for unsupported parts of an algorithm sounds like 
the right thing to me. In include/linux/crypto.h I found:

/*
 * Set this bit if and only if the algorithm requires another algorithm of
 * the same type to handle corner cases.
 */
#define CRYPTO_ALG_NEED_FALLBACK        0x00000100

which is currently not used but looks like someone has thought of implementing
that kind of fallback method?

OTOH, if aes and padlock are the only two cornercases it may be easier to
implement the fallback manually. Are there other algorithms / hardware accelerators
that would benefit from a generic fallback method?

Cheers,
Jan
