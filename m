From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v1.3 4/4] keys: add new key-type encrypted
Date: Fri, 12 Nov 2010 21:23:33 +0000
Message-ID: <27900.1289597013@redhat.com>
References: <1289595738.2731.80.camel@localhost.localdomain> <1289404309-15955-5-git-send-email-zohar@linux.vnet.ibm.com> <1289404309-15955-1-git-send-email-zohar@linux.vnet.ibm.com> <26689.1289591135@redhat.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
	linux-crypto@vger.kernel.org,
	Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
	James Morris <jmorris@namei.org>,
	David Safford <safford@watson.ibm.com>,
	Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
	Mimi Zohar <zohar@us.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1289595738.2731.80.camel@localhost.localdomain>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> > Why do you allow the master key to be supplied by a user-defined key rather
> > than requiring a trusted-key unconditionally?
> 
> This is for systems without a TPM. The logic needs to exist, whether it
> is here or in EVM.  By doing it here, a user could provide a passphrase
> in the initramfs, which is used to decrypt the encrypted key.

I thought that might be the case.  In which case, it might be better to allow
someone to add a trusted key, supplying both encrypted and unencrypted
versions of the data so that the TPM need not be consulted.  You might want to
mark such a key so that it can be seen when it is dumped.

But if you're going to use a user-defined key, you really need to prefix the
description with something suitable.

David
