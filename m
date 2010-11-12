From: David Safford <safford@watson.ibm.com>
Subject: Re: [PATCH v1.3 2/4] key: add tpm_send command
Date: Fri, 12 Nov 2010 09:48:50 -0500
Message-ID: <1289573330.4341.31.camel@localhost.localdomain>
References: <1289514356.2726.18.camel@localhost.localdomain>
	 <1289404309-15955-3-git-send-email-zohar@linux.vnet.ibm.com>
	 <1289404309-15955-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <6651.1289504931@redhat.com>  <22962.1289571072@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
	linux-crypto@vger.kernel.org,
	Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
	James Morris <jmorris@namei.org>,
	Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from igw2.watson.ibm.com ([129.34.20.6]:54816 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab0KLOtT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Nov 2010 09:49:19 -0500
In-Reply-To: <22962.1289571072@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 2010-11-12 at 14:11 +0000, David Howells wrote:
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > > > +	module_put(chip->dev->driver->owner);
> > > 
> > > Where's the corresponding module_get()?  I suspect this should be wrapped to
> > > match tpm_chip_find_get().
> > > 
> > > David
> > 
> > The module_get() is in tpm_chip_find_get(), which is just a helper.
> > (It's used this way throughout tpm.c)
> 
> I'd make a function tpm_chip_find_put() just to wrap module_put() and then
> place it with tpm_chip_find_get() in the sources.  That makes it easier to see
> what's going on.

Or alternately rename the helper to tpm_chip_find_and_module_get()?
In either case, this is really up to Rajiv (the maintainer for tpm.c
who has already acked this patch), as this usage already appears in
other places in tpm.c. There would have to be a separate patch fixing
this for all of the instances. Rajiv, your thoughts?

dave
