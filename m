From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH 14/16] X.509: Add an ASN.1 decoder
Date: Wed, 19 Sep 2012 14:17:47 +1000 (EST)
Message-ID: <alpine.LRH.2.02.1209191416060.29525@tundra.namei.org>
References: <20120914103930.1e16ad8b@pyramind.ukuu.org.uk> <20120913234802.3575.77103.stgit@warthog.procyon.org.uk> <20120913235005.3575.46218.stgit@warthog.procyon.org.uk> <13189.1347989652@warthog.procyon.org.uk>
 <20120918195115.6ddcf5fc@pyramind.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: David Howells <dhowells@redhat.com>, herbert@gondor.hengli.com.au,
	pjones@redhat.com, rusty@rustcorp.com.au,
	linux-crypto@vger.kernel.org, zohar@us.ibm.com,
	dmitry.kasatkin@intel.com, linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tundra.namei.org ([65.99.196.166]:41997 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061Ab2ISEZ7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Sep 2012 00:25:59 -0400
In-Reply-To: <20120918195115.6ddcf5fc@pyramind.ukuu.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 18 Sep 2012, Alan Cox wrote:

> On Tue, 18 Sep 2012 18:34:12 +0100
> David Howells <dhowells@redhat.com> wrote:
> 
> > Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > 
> > > Why do this in the kernel.That appears to be completely insane.
> > 
> > A number of reasons:
> > 
> >  (1) The UEFI signature/key database may contain ASN.1 X.509 certificates and
> >      we may need to use those very early in the boot process, during initrd.
> 
> Ok that makes some sense.

I'd like to see some serious effort at code review and testing before this 
code is merged.


- James
-- 
James Morris
<jmorris@namei.org>
