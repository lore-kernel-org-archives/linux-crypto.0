From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 07/21] KEYS: Create a key type that can be used for general cryptographic operations [ver #3]
Date: Tue, 17 Jan 2012 15:32:20 +0000
Message-ID: <21109.1326814340@redhat.com>
References: <1326718394.2276.1.camel@falcor> <20111202184229.21874.25782.stgit@warthog.procyon.org.uk> <20111202184354.21874.57647.stgit@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, keyrings@linux-nfs.org,
	linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, arjan.van.de.ven@intel.com,
	alan.cox@intel.com
To: Mimi Zohar <zohar@linux.vnet.ibm.com>, dmitry.kasatkin@intel.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1326718394.2276.1.camel@falcor>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> Nice! Basically the 'crypto' key type ties crypto/ with security/keys.
> Other than the posted pgp key parser used for verifying kernel module
> signatures, I assume another use case could be to expose kernel
> cryptography to userspace.  As there was a submission
> https://lkml.org/lkml/2010/8/20/103 to do just this, there must be
> userspace apps that would benefit.  This architecture would address a
> number of concerns raised with the prior submission. (Refer to
> http://lwn.net/Articles/401548/.)

:-)

> You'd probably want to move the 'crypto' key type to its own directory.

Yeah.

I'd also like to see if Dmitry's work can be absorbes into this infrastructure.

David
