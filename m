From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [RFC] KEYS: Exposing {a,}symmetric key ops to userspace and
 other bits
Date: Wed, 02 Dec 2015 14:27:52 -0500
Message-ID: <1449084472.2652.20.camel@linux.vnet.ibm.com>
References: <23924.1448017665@warthog.procyon.org.uk>
	 <1448203311.2546.34.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Marcel Holtmann <marcel@holtmann.org>,
	Tadeusz Struk <tadeusz.struk@intel.com>, dwmw2@infradead.org,
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Petko Manolov <petkan@mip-labs.com>,
	"Mark D. Baushke" <mdb@juniper.net>
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:43402 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbbLBT2z (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Dec 2015 14:28:55 -0500
Received: from localhost
	by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
	Thu, 3 Dec 2015 05:28:52 +1000
In-Reply-To: <1448203311.2546.34.camel@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, 2015-11-22 at 09:41 -0500, Mimi Zohar wrote:
> On Fri, 2015-11-20 at 11:07 +0000, David Howells wrote:
> > 
> >  (*) Add Mimi's patches to allow keys/keyrings to be marked undeletable.  This
> >      is for the purpose of creating blacklists and to prevent people from
> >      removing entries in the blacklist.  Note that only the kernel can create
> >      a blacklist - we don't want userspace generating them as a way to take up
> >      kernel space.
> > 
> >      I think the right way to do this is to not allow marked keys to be
> >      unlinked from marked keyrings, but to allow marked keys to be unlinked
> >      from ordinary keyrings.
> > 
> >      The reason the 'keep' mark is required on individual keys is to prevent
> >      the keys from being directly revoked, expired or invalidated by keyctl
> >      without reference to the keyring.  Marked keys that are set expirable
> >      when they're created will still expire and be subsequently removed and if
> >      a marked key or marked keyring loses all its references it still gets
> >      gc'd.
> 
> Agreed.  I'll fix and re-post soon.

In addition to Petko's 3 patches, the ima-keyrings branch
(git://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity.git) contains these two patches.

d939a88 IMA: prevent keys on the .ima_blacklist from being removed
77f33b5 KEYS: prevent keys from being removed from specified keyrings

As the IMA patch is dependent on the KEYS patch, do you mind if the KEYS
patch would be upstreamed together with this patch set?

Mimi
