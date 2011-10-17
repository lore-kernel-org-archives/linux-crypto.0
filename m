From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v2.1 1/7] crypto: GnuPG based MPI lib - source files (part 1)
Date: Mon, 17 Oct 2011 16:50:51 +0100
Message-ID: <15891.1318866651@redhat.com>
References: <alpine.LRH.2.00.1110151125280.24994@tundra.namei.org> <cover.1318598705.git.dmitry.kasatkin@intel.com> <92d93a9fe52e048a21d19732c31d80c9ec44de77.1318598705.git.dmitry.kasatkin@intel.com>
Cc: dhowells@redhat.com, Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	zohar@linux.vnet.ibm.com, herbert@gondor.hengli.com.au
To: James Morris <jmorris@namei.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190Ab1JQPwJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Oct 2011 11:52:09 -0400
In-Reply-To: <alpine.LRH.2.00.1110151125280.24994@tundra.namei.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

James Morris <jmorris@namei.org> wrote:

> > +MPI mpi_alloc(unsigned nlimbs)
> > +{
> > +	MPI a;
> > +
> > +	a = (MPI) kmalloc(sizeof *a, GFP_KERNEL);
> 
> Generally, typedef structs are frowned upon in the kernel.  I'd prefer to 
> see this (and any others) changed to a normal type.

In this case, however, it makes it easier to compare back to the original
code.

David
