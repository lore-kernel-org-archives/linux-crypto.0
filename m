From: Andi Kleen <ak@suse.de>
Subject: Re: {twofish,aes}-{x86_64,i586} versus C implementations
Date: Mon, 20 Aug 2007 15:06:39 +0200
Message-ID: <20070820130639.GN16680@bingen.suse.de>
References: <200708200234.25620.ak@suse.de> <E1IMveX-0002Kv-00@gondolin.me.apana.org.au> <20070820101618.GE16680@bingen.suse.de> <20070820120605.GA13163@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <ak@suse.de>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:38951 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755223AbXHTMMn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Aug 2007 08:12:43 -0400
Content-Disposition: inline
In-Reply-To: <20070820120605.GA13163@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

> That would be the best.  However, it's not hard to do a
> simple probing in the kernel until modprobe(8) gets this
> feature.

Sounds like a big hack, and at least for aes / aes-x86_64 and
twofish it's not needed.  Just disable aes on x86.

The only problem is the select issue with wireless.

Unfortunately 

select CRYPTO_AES_X86_64 if X86_64
select CRYPTO_AES_I586 if X86_32
select CRYPTO_AES if !X86

produces warnings for unreferenced symbols :/
Perhaps it can be just removed for now.

> > Also if one implementation is always better than the other
> > then I see little reason to ever have both.
> 
> Well it's not that useful for an assembly implementation
> that works on all instances of a given architecture.

I meant on x86. Sure for other architectures the C version is needed.

-Andi
