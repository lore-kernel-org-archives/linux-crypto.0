From: David Howells <dhowells@redhat.com>
Subject: Re: [Keyrings] [RFC][PATCH 00/16] Crypto keys and module signing [ver #2]
Date: Wed, 07 Dec 2011 14:29:32 +0000
Message-ID: <28095.1323268172@redhat.com>
References: <alpine.LRH.2.00.1112061151520.25445@tundra.namei.org> <4EDCABBD.9020401@intel.com> <20111129234258.13625.21153.stgit@warthog.procyon.org.uk> <776.1323085419@redhat.com>
Cc: dhowells@redhat.com, "H. Peter Anvin" <h.peter.anvin@intel.com>,
	keyrings@linux-nfs.org, alan.cox@intel.com,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, dmitry.kasatkin@intel.com,
	linux-crypto@vger.kernel.org, arjan.van.de.ven@intel.com,
	Herbert Xu <herbert@gondor.hengli.com.au>
To: James Morris <jmorris@namei.org>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.00.1112061151520.25445@tundra.namei.org>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

James Morris <jmorris@namei.org> wrote:

> > However, we don't have to include the DSA stuff in the kernel; I can always
> > discard that patch from the upstream-aimed patchset.
> 
> I'd encourage dropping DSA, as there appears to be no legacy justification 
> for its inclusion. 

Okay, done that.

David
