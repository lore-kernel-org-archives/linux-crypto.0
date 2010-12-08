From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v1.5 5/5] keys: add new key-type encrypted
Date: Wed, 08 Dec 2010 10:54:24 +0000
Message-ID: <13657.1291805664@redhat.com>
References: <1291762122.2680.31.camel@localhost.localdomain> <1290556535.2604.16.camel@localhost.localdomain> <1290552635-3356-1-git-send-email-zohar@linux.vnet.ibm.com> <4182.1291383725@redhat.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
	linux-crypto@vger.kernel.org,
	Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
	James Morris <jmorris@namei.org>,
	David Safford <safford@watson.ibm.com>,
	Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1291762122.2680.31.camel@localhost.localdomain>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> > > +static struct key *request_trusted_key(const char *trusted_desc,
> > > +				       u8 **master_key,
> > > +				       unsigned int *master_keylen)
> > 
> > You need to annotate the function with an __acquires() to indicate that it
> > returns with a lock held for Sparse checking.  I think you should be able to
> > do:
> > 
> > 	__acquires(tkey->sem)
> 
> hm, only after addding '__acquires' are there Sparse errors.

Leave it, then.

David
