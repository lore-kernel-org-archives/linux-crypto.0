From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 21/21] MODSIGN: Apply signature checking to modules on
 module load [ver #3]
Date: Sat, 10 Dec 2011 10:37:23 -0800
Message-ID: <20111210103723.6c89405f@infradead.org>
References: <87boriouwa.fsf@rustcorp.com.au>
	<20111202184229.21874.25782.stgit@warthog.procyon.org.uk>
	<20111202184651.21874.57769.stgit@warthog.procyon.org.uk>
	<2657.1323456206@redhat.com>
	<8739csq5ac.fsf@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: David Howells <dhowells@redhat.com>, keyrings@linux-nfs.org,
	linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com,
	zohar@linux.vnet.ibm.com, arjan@linux.intel.com,
	alan.cox@intel.com, Jon Masters <jcm@jonmasters.org>
To: Rusty Russell <rusty@ozlabs.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:56592 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab1LJSgs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 10 Dec 2011 13:36:48 -0500
In-Reply-To: <8739csq5ac.fsf@rustcorp.com.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> 
> Yes, there may be more than stripped and unstripped.  You may need to
> do fancy things.  But now, adding a signature is so easy that it's
> not a real problem.  And we can always have a hook, like:
> 
>         if VARIANTS=`make-module-variants $MOD`; then
>                 for m in $VARIANTS; do sign $m >> $MOD; rm $m; done
>         fi

but that requires you to keep the key around.
the most simple and common deployment of this is to generate a key,
build the public key into the kernel, sign the modules as you build the
kernel, and then destroy the key.
And THEN it gets deployed.
