From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [RFC] KEYS: Exposing {a,}symmetric key ops to userspace and
 other bits
Date: Sun, 22 Nov 2015 09:41:51 -0500
Message-ID: <1448203311.2546.34.camel@linux.vnet.ibm.com>
References: <23924.1448017665@warthog.procyon.org.uk>
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
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:50589 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbbKVOmC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 22 Nov 2015 09:42:02 -0500
Received: from /spool/local
	by e28smtp08.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
	Sun, 22 Nov 2015 20:11:59 +0530
In-Reply-To: <23924.1448017665@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 2015-11-20 at 11:07 +0000, David Howells wrote:
> Hi Marcel, Mimi, Tadeus,
> 
> I want to consider adding or doing the following bits to the keyrings
> facility, aiming for the next merge window:
> 
>  (*) Bring in the patches that I posted to change how the trust model on a
>      keyring works.
> 
>      The model will then be that keys aren't automatically marked trusted, but
>      linking a key into a keyring that is marked trusted-only will validate
>      the key against the contents of the keyring before permitting its
>      addition.

This trust model is flawed.   We've already discussed this trust model
back when first introducing the concept of a trusted keyring.   Refer to
the v3 "ima: extending secure boot certificate chain of trust" patch set
https://lwn.net/Articles/576563/, which describes two methods of
verifying a certificate before adding the key to the trusted keyring.  

The first method  "4/5 KEYS: verify certificate is signed by a trusted
key on the target keyriing" is similar to the method being proposed
here.  The subsequent patch "5/5 KEYS: verify certificate is signed by a
trusted key on a particular keyring" rejected using the same keyring for
validating the new key being added.  It defined a new separate keyring
for validating the keys.  (Neither of these patches were upstreamed.)

Dmitry Kasatkin proposed a third method, which identified the "trusted"
key(s) on the system keyring, instead of maintaining a separate keyring.
As there wasn't a usecase requiring a separate keyring at the time, his
approach was upstreamed.  Now Petko Manoliv and Mark Bausche  have a
valid use case scenario for having a separate keyring.  (For the details
refer to:
https://www.mail-archive.com/linux-security-module@vger.kernel.org/msg03503.html)

With the proposed trust model change, the keys trusted to verify file
signatures would be allowed to also verify certificate signatures.  For
example, a system owner trusts company A to verify file signatures, yet
they want to retain control over which certificates may be added to the
keyring.  Just because company A trusts company/government X, doesn't
mean the system owner also trusts company/government X.   By having one
keyring, other certificates signed by company A could be added to the
keyring.

>      Note that we can then vary the policy on a per-keyring basis.
> 
>  (*) Add Mimi's patches to allow keys/keyrings to be marked undeletable.  This
>      is for the purpose of creating blacklists and to prevent people from
>      removing entries in the blacklist.  Note that only the kernel can create
>      a blacklist - we don't want userspace generating them as a way to take up
>      kernel space.
> 
>      I think the right way to do this is to not allow marked keys to be
>      unlinked from marked keyrings, but to allow marked keys to be unlinked
>      from ordinary keyrings.
> 
>      The reason the 'keep' mark is required on individual keys is to prevent
>      the keys from being directly revoked, expired or invalidated by keyctl
>      without reference to the keyring.  Marked keys that are set expirable
>      when they're created will still expire and be subsequently removed and if
>      a marked key or marked keyring loses all its references it still gets
>      gc'd.

Agreed.  I'll fix and re-post soon.

Mimi
