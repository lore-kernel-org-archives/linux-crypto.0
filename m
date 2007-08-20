From: Andi Kleen <ak@suse.de>
Subject: Re: {twofish,aes}-{x86_64,i586} versus C implementations
Date: Mon, 20 Aug 2007 12:16:18 +0200
Message-ID: <20070820101618.GE16680@bingen.suse.de>
References: <200708200234.25620.ak@suse.de> <E1IMveX-0002Kv-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <ak@suse.de>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:55655 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216AbXHTJWX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Aug 2007 05:22:23 -0400
Content-Disposition: inline
In-Reply-To: <E1IMveX-0002Kv-00@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

> Are you sure you get the C version when both are built-in
> or loaded as modules? If so then we have a bug in the priority
> code.

The usual use case is: Somebody -- either admin or some command 
implicitely -- executes modprobe aes because some text file
specifies the aes cipher. At least on my system that loads
the C version when both are enabled. modprobe will not load
multiple modules in this case.

I don't think modprobe knows anything about these priorities.

> We don't, but the system is meant to allow multiple
> implementations to coexist and picking the best one
> at run-time.

But that would require teaching the module loading user space
about all this first, right?

Also if one implementation is always better than the other
then I see little reason to ever have both.

-Andi
