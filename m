From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/10] KEYS: Change how keys are determined to be trusted
Date: Wed, 21 Oct 2015 14:11:08 -0400
Message-ID: <1445451068.2459.302.camel@linux.vnet.ibm.com>
References: <20151021151314.4583.90962.stgit@warthog.procyon.org.uk>
	 <1445446968.2459.272.camel@linux.vnet.ibm.com>
	 <CA+5PVA5Oz9dwrPY_+65J58iqaQ3RehCp2J5PPPkxsF1ObiCOvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	linux-security-module <linux-security-module@vger.kernel.org>,
	linux-crypto@vger.kernel.org,
	"Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
To: Josh Boyer <jwboyer@fedoraproject.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+5PVA5Oz9dwrPY_+65J58iqaQ3RehCp2J5PPPkxsF1ObiCOvw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 2015-10-21 at 13:21 -0400, Josh Boyer wrote:
> On Wed, Oct 21, 2015 at 1:02 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > On Wed, 2015-10-21 at 16:13 +0100, David Howells wrote:
> >> Here's a set of patches that changes how keys are determined to be trusted
> >> - currently, that's a case of whether a key has KEY_FLAG_TRUSTED set upon
> >> it.  A keyring can then have a flag set (KEY_FLAG_TRUSTED ONLY) that
> >> indicates that only keys with this flag set may be added to that keyring.
> >>
> >> Further, any time an X.509 certificate is instantiated without this flag
> >> set, the certificate is judged against the contents of the system trusted
> >> keyring to determine whether KEY_FLAG_TRUSTED should be set upon it.
> >>
> >> With these patches, KEY_FLAG_TRUSTED is removed.  The kernel may add
> >> implicitly trusted keys to a trusted-only keyring by asserting
> >> KEY_ALLOC_TRUSTED when the key is created,
> >
> > Ok, but only the x509 certificates built into the kernel image should be
> > automatically trusted and can be added to a trusted keyring, because the
> > kernel itself was signed (and verified).  These certificates extend the
> > (UEFI) certificate chain of trust that is rooted in hardware to the OS.
> 
> That doesn't sound accurate to me.  The cert built into the kernel
> image doesn't extend the UEFI certificates.  In most cases, it is a
> ephemeral cert that is automatically generated at kernel build time
> and then discarded.  It is not chained to or derived from any of the
> UEFI certs stored in the db (or mok) variables.  The built-in cert is
> used for module loading verification.  I agree that it should be
> trusted, but not really for the reason you list.  Perhaps you meant
> the key that the PE image of the kernel is signed with?  If so, the
> kernel doesn't load that.  Only shim (and grub2 via shim) read that
> key.

This is similar to the concept of the MoK DB.  Keys added to the MoK
aren't signed by a UEFI key, yet they extend the UEFI secure boot
certificate chain of trust.  Similarly, the certificates built into the
kernel image don't need to be signed by a UEFI/MoK key for it to extend
the certificate chain of trust.

> However, that does bring up the UEFI db/mok certs and how to deal with
> those.  The out-of-tree patches we have add them to the system keyring
> as trusted keys.  We can modify the patches to use KEY_ALLOC_TRUSTED
> to preserve that functionality I suppose.

Certificates are use case specific.  Just because a key was trusted at
the UEFI layer doesn't mean it should be trusted by the kernel (eg.
Microsoft key).  To illustrate this point, David Howells/David Woodhouse
recently posted/upstreamed patches to differentiate how keys loaded onto
the system keyring may be used. (Reference needed.)

Mimi
