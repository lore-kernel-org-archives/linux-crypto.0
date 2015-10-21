From: Petko Manolov <petkan@mip-labs.com>
Subject: Re: [PATCH 00/10] KEYS: Change how keys are determined to be trusted
Date: Wed, 21 Oct 2015 21:48:31 +0300
Message-ID: <20151021184817.GQ23618@localhost>
References: <20151021151314.4583.90962.stgit@warthog.procyon.org.uk>
 <1445446968.2459.272.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	mdb@juniper.net
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from lan.nucleusys.com ([92.247.61.126]:50922 "EHLO
	zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754970AbbJUTTi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Oct 2015 15:19:38 -0400
Content-Disposition: inline
In-Reply-To: <1445446968.2459.272.camel@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 15-10-21 13:02:48, Mimi Zohar wrote:
> On Wed, 2015-10-21 at 16:13 +0100, David Howells wrote:
> > Here's a set of patches that changes how keys are determined to be trusted
> > - currently, that's a case of whether a key has KEY_FLAG_TRUSTED set upon
> > it.  A keyring can then have a flag set (KEY_FLAG_TRUSTED ONLY) that
> > indicates that only keys with this flag set may be added to that keyring.
> > 
> > Further, any time an X.509 certificate is instantiated without this flag
> > set, the certificate is judged against the contents of the system trusted
> > keyring to determine whether KEY_FLAG_TRUSTED should be set upon it.
> > 
> > With these patches, KEY_FLAG_TRUSTED is removed.  The kernel may add
> > implicitly trusted keys to a trusted-only keyring by asserting
> > KEY_ALLOC_TRUSTED when the key is created, 
> 
> Ok, but only the x509 certificates built into the kernel image should be
> automatically trusted and can be added to a trusted keyring, because the
> kernel itself was signed (and verified).  These certificates extend the
> (UEFI) certificate chain of trust that is rooted in hardware to the OS.
> 
> Other keys that the kernel reads and loads should not automatically be
> trusted (eg. ima_load_x509).  They need to be validated against a
> trusted key.
> 
> > but otherwise the key will only
> > be allowed to be added to the keyring if it can be verified by a key
> > already in that keyring.  The system trusted keyring is not then special in
> > this sense and other trusted keyrings can be set up that are wholly
> > independent of it.
> 
> We already went down this path of "transitive trust" back when we first 
> introduced the concept of trusted keys and keyrings.  Just because a key is on 
> a trusted keyring, doesn't imply that it should be permitted to load other 
> keys on the same trusted keyring.  In the case of IMA-appraisal, the key 
> should only be used to verify the file data signature, not other keys.
> 
> The trusted keys used for verifying other certificates should be stored on a 
> separate keyring, not the target keyring.  Petko's patches define a new IMA 
> keyring named .ima_mok for this purpose.

The concept is not new.  Some embedded applications are multi-tenant and 
typically have uptime measured in years.  The current CA hierarchy model of the 
kernel is somewhat limited in terms of dynamically adding trusted certificates 
and trusted keys.

.ima_mok was introduced as an intermediate keyring storing CAs that are 
themselves signed by CAs in the system keyring, which is trusted by default.  
Only keys that have been signed by certificate in .system or .ima_mok may land 
in .ima keyring.  This:

	.system ---> .ima_mok ---> .ima ---> actual.key

gives us the ability to extend the chain of trust and also cover the above 
criteria.  That said, .ima_mok may be used for a whole bunch of other cases.

Think of a kernel module that comes from one of the tenants or even the machine 
owner.  They obviously don't have access to the Manufacturer's signing key 
(CA-M), but do have certificate (CA-O) that has been signed by it (CA-M).

This certificate (CA-O) can now go to .ima_mok (or whatever the name) and 
successfully verify the kernel's module signature.  CA-O may even sign another 
certificate, CA-O2, and by the above rules it may also go into .ima_mok.  And so 
on...

I think that in general having an intermediate CA keyring adds a lot of 
flexibility to the kernel's key management, although it's typical use does not 
make this mandatory.


cheers,
Petko
