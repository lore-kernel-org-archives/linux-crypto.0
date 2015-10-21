From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/10] KEYS: Change how keys are determined to be trusted
Date: Wed, 21 Oct 2015 13:02:48 -0400
Message-ID: <1445446968.2459.272.camel@linux.vnet.ibm.com>
References: <20151021151314.4583.90962.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: keyrings@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151021151314.4583.90962.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 2015-10-21 at 16:13 +0100, David Howells wrote:
> Here's a set of patches that changes how keys are determined to be trusted
> - currently, that's a case of whether a key has KEY_FLAG_TRUSTED set upon
> it.  A keyring can then have a flag set (KEY_FLAG_TRUSTED ONLY) that
> indicates that only keys with this flag set may be added to that keyring.
> 
> Further, any time an X.509 certificate is instantiated without this flag
> set, the certificate is judged against the contents of the system trusted
> keyring to determine whether KEY_FLAG_TRUSTED should be set upon it.
> 
> With these patches, KEY_FLAG_TRUSTED is removed.  The kernel may add
> implicitly trusted keys to a trusted-only keyring by asserting
> KEY_ALLOC_TRUSTED when the key is created, 

Ok, but only the x509 certificates built into the kernel image should be
automatically trusted and can be added to a trusted keyring, because the
kernel itself was signed (and verified).  These certificates extend the
(UEFI) certificate chain of trust that is rooted in hardware to the OS.

Other keys that the kernel reads and loads should not automatically be
trusted (eg. ima_load_x509).  They need to be validated against a
trusted key.

> but otherwise the key will only
> be allowed to be added to the keyring if it can be verified by a key
> already in that keyring.  The system trusted keyring is not then special in
> this sense and other trusted keyrings can be set up that are wholly
> independent of it.

We already went down this path of "transitive trust" back when we first
introduced the concept of trusted keys and keyrings.   Just because a
key is on a trusted keyring, doesn't imply that it should be permitted
to load other keys on the same trusted keyring.  In the case of
IMA-appraisal, the key should only be used to verify the file data
signature, not other keys.

The trusted keys used for verifying other certificates should be stored
on a separate keyring, not the target keyring.   Petko's patches define
a new IMA keyring named .ima_mok for this purpose.

Mimi

> To make this work, we have to retain sufficient data from the X.509
> certificate that we can then verify the signature at need.
> 
> The patches can be found here also:
> 
> 	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-trust
> 
> and are tagged with:
> 
> 	keys-trust-20151021
> 
