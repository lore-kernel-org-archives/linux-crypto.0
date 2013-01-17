From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 2/3] KEYS: Separate the kernel signature checking keyring from module signing
Date: Thu, 17 Jan 2013 21:20:28 +0000
Message-ID: <30183.1358457628@warthog.procyon.org.uk>
References: <1358449049.2689.87.camel@falcor1> <20130117180352.27885.79893.stgit@warthog.procyon.org.uk> <20130117180400.27885.2973.stgit@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, dmitry.kasatkin@intel.com,
	linux-kernel@vger.kernel.org, keyrings@linux-nfs.org,
	linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1358449049.2689.87.camel@falcor1>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> Lets assume accepting built in keys should is acceptable for all use
> cases.  Adding additional keys from userspace is probably not acceptable
> for all use cases.  Those keys should be added to specific 'trusted'
> keyrings.
> 
> EVM and IMA-appraisal have separate keyrings for this reason.  I might
> be interested in allowing third party packages to be installed and
> executed, but that doesn't imply that a security.evm extended attribute,
> signed by a third party application, is acceptable.

We should probably look at using the capability of X.509 certificates to
indicate what a key may be used for and noting that in the public_key struct.

David
