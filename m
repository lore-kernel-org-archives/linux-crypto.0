From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: [PATCH 07/21] KEYS: Create a key type that can be used for
 general cryptographic operations [ver #3]
Date: Wed, 18 Jan 2012 12:56:15 +0200
Message-ID: <CALLzPKY87L_GTP57MwA=iz4Cn3inboBszJ5OfOSYtUcRJn4KQg@mail.gmail.com>
References: <20111202184229.21874.25782.stgit@warthog.procyon.org.uk>
	<20111202184354.21874.57647.stgit@warthog.procyon.org.uk>
	<1326718394.2276.1.camel@falcor>
	<21109.1326814340@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, keyrings@linux-nfs.org,
	linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, arjan.van.de.ven@intel.com,
	alan.cox@intel.com
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:19304 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752938Ab2ARK4S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Jan 2012 05:56:18 -0500
In-Reply-To: <21109.1326814340@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 17, 2012 at 5:32 PM, David Howells <dhowells@redhat.com> wr=
ote:
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>
>> Nice! Basically the 'crypto' key type ties crypto/ with security/key=
s.
>> Other than the posted pgp key parser used for verifying kernel modul=
e
>> signatures, I assume another use case could be to expose kernel
>> cryptography to userspace. =C2=A0As there was a submission
>> https://lkml.org/lkml/2010/8/20/103 to do just this, there must be
>> userspace apps that would benefit. =C2=A0This architecture would add=
ress a
>> number of concerns raised with the prior submission. (Refer to
>> http://lwn.net/Articles/401548/.)
>
> :-)
>
>> You'd probably want to move the 'crypto' key type to its own directo=
ry.
>
> Yeah.
>
> I'd also like to see if Dmitry's work can be absorbes into this infra=
structure.
>

Hi David,

Crypto keys is very nice idea.
We thought some time ago about having dedicated key type for handling
public key cryptography operations,
but did not go that far. Also I did not want to mess-up with GnuPG
formats and just made straight-forward RSA implementation,
which can be handled by any crypto library, such as openssl.
We can easily take GPG signing scheme into use for IMA/EVM when it
gets to upstream.

- Dmitry

> David
