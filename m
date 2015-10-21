From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/10] KEYS: Change how keys are determined to be trusted
Date: Wed, 21 Oct 2015 14:33:36 -0400
Message-ID: <1445452416.2459.312.camel@linux.vnet.ibm.com>
References: <20151021151314.4583.90962.stgit@warthog.procyon.org.uk>
	 <1445446968.2459.272.camel@linux.vnet.ibm.com>
	 <CA+5PVA5Oz9dwrPY_+65J58iqaQ3RehCp2J5PPPkxsF1ObiCOvw@mail.gmail.com>
	 <1445451068.2459.302.camel@linux.vnet.ibm.com>
	 <CA+5PVA535Z1zbXiBRckqP7r0gM_S+8=RaS46b501Ko7cHj-hkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	linux-security-module <linux-security-module@vger.kernel.org>,
	linux-crypto@vger.kernel.org,
	"Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
To: Josh Boyer <jwboyer@fedoraproject.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:57434 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbbJUSdq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Oct 2015 14:33:46 -0400
Received: from /spool/local
	by e28smtp04.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
	Thu, 22 Oct 2015 00:03:43 +0530
In-Reply-To: <CA+5PVA535Z1zbXiBRckqP7r0gM_S+8=RaS46b501Ko7cHj-hkA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2015-10-21 at 14:21 -0400, Josh Boyer wrote:
> On Wed, Oct 21, 2015 at 2:11 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > On Wed, 2015-10-21 at 13:21 -0400, Josh Boyer wrote:
> >> On Wed, Oct 21, 2015 at 1:02 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> >> > On Wed, 2015-10-21 at 16:13 +0100, David Howells wrote:
> >> >> Here's a set of patches that changes how keys are determined to be trusted
> >> >> - currently, that's a case of whether a key has KEY_FLAG_TRUSTED set upon
> >> >> it.  A keyring can then have a flag set (KEY_FLAG_TRUSTED ONLY) that
> >> >> indicates that only keys with this flag set may be added to that keyring.
> >> >>
> >> >> Further, any time an X.509 certificate is instantiated without this flag
> >> >> set, the certificate is judged against the contents of the system trusted
> >> >> keyring to determine whether KEY_FLAG_TRUSTED should be set upon it.
> >> >>
> >> >> With these patches, KEY_FLAG_TRUSTED is removed.  The kernel may add
> >> >> implicitly trusted keys to a trusted-only keyring by asserting
> >> >> KEY_ALLOC_TRUSTED when the key is created,
> >> >
> >> > Ok, but only the x509 certificates built into the kernel image should be
> >> > automatically trusted and can be added to a trusted keyring, because the
> >> > kernel itself was signed (and verified).  These certificates extend the
> >> > (UEFI) certificate chain of trust that is rooted in hardware to the OS.
> >>
> >> That doesn't sound accurate to me.  The cert built into the kernel
> >> image doesn't extend the UEFI certificates.  In most cases, it is a
> >> ephemeral cert that is automatically generated at kernel build time
> >> and then discarded.  It is not chained to or derived from any of the
> >> UEFI certs stored in the db (or mok) variables.  The built-in cert is
> >> used for module loading verification.  I agree that it should be
> >> trusted, but not really for the reason you list.  Perhaps you meant
> >> the key that the PE image of the kernel is signed with?  If so, the
> >> kernel doesn't load that.  Only shim (and grub2 via shim) read that
> >> key.
> >
> > This is similar to the concept of the MoK DB.  Keys added to the MoK
> > aren't signed by a UEFI key, yet they extend the UEFI secure boot
> > certificate chain of trust.  Similarly, the certificates built into the
> 
> Right, because UEFI is verifying shim, which verifies grub2, which
> verifies the kernel.  I get that.  However, it's irrelevant.
> 
> > kernel image don't need to be signed by a UEFI/MoK key for it to extend
> > the certificate chain of trust.
> 
> The certificates built _into_ the kernel need to be trusted in all
> cases.  It is how module signing is done.  So a user not using Secure
> Boot, or even not using UEFI, still needs those embedded certs trusted
> so that they can load modules.  It has nothing to do with UEFI or some
> single-root-of-trust.
> 
> At any rate, I believe we are both saying the embedded cert needs to
> be trusted so there's little point in debating further.  I just wanted
> to point out that this need has nothing to do with UEFI.

Right, the embedded certs need to trusted.  But that trust needs to be
based on something.  One method of establishing that trust is (UEFI)
secure boot, which verifies the kernel image signature, including the
embedded certs.

Mimi
