From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v1.3 2/4] key: add tpm_send command
Date: Fri, 12 Nov 2010 14:11:12 +0000
Message-ID: <22962.1289571072@redhat.com>
References: <1289514356.2726.18.camel@localhost.localdomain> <1289404309-15955-3-git-send-email-zohar@linux.vnet.ibm.com> <1289404309-15955-1-git-send-email-zohar@linux.vnet.ibm.com> <6651.1289504931@redhat.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
	linux-crypto@vger.kernel.org,
	Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
	James Morris <jmorris@namei.org>,
	David Safford <safford@watson.ibm.com>,
	Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1289514356.2726.18.camel@localhost.localdomain>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> > > +	module_put(chip->dev->driver->owner);
> > 
> > Where's the corresponding module_get()?  I suspect this should be wrapped to
> > match tpm_chip_find_get().
> > 
> > David
> 
> The module_get() is in tpm_chip_find_get(), which is just a helper.
> (It's used this way throughout tpm.c)

I'd make a function tpm_chip_find_put() just to wrap module_put() and then
place it with tpm_chip_find_get() in the sources.  That makes it easier to see
what's going on.

David
