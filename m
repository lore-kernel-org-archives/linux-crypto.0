From: Andrew Zaborowski <balrogg@googlemail.com>
Subject: Re: [PATCH 4/8] akcipher: Move the RSA DER encoding to the crypto layer
Date: Tue, 23 Feb 2016 01:01:50 +0100
Message-ID: <CAOq732LxkcSbk93ofENxL-53SFRQEtK7PcLF9LDLYmctX9W7cA@mail.gmail.com>
References: <20160219171806.17223.91381.stgit@warthog.procyon.org.uk>
	<20160219171836.17223.9507.stgit@warthog.procyon.org.uk>
	<56CB68A2.50505@intel.com>
	<1562.1456180090@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Tadeusz Struk <tadeusz.struk@intel.com>, keyrings@vger.kernel.org,
	linux-security-module@vger.kernel.org, zohar@linux.vnet.ibm.com,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:35463 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487AbcBWABw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 22 Feb 2016 19:01:52 -0500
In-Reply-To: <1562.1456180090@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

On 22 February 2016 at 23:28, David Howells <dhowells@redhat.com> wrote:
> Tadeusz Struk <tadeusz.struk@intel.com> wrote:
>
>> I wonder if this should be merged with the crypto/rsa-pkcs1pad.c template
>> that we already have. Looks like the two do the same padding now.

I think that'd be a good thing to do.

>> Should we merge then and pass the hash param as a separate template param,
>> e.g the public_key would allocate "pkcs1pad(rsa, sha1)"?
>
> Ummm...  Possibly.  Is that how it's used?

Currently it only does the padding and doesn't care about the hash.
The input is expected to be the entire DigestInfo struct.

AIUI Tadeusz is proposing adding the hashing as a new feature.  Note
though that the hash paremeter won't make sense for the encrypt,
decrypt or verify operations.

Also note that TLS 1.0 uses the padding to sign data that is not a
DigestInfo structure and even for 1.2 there are situations where
you'll be hashing the data yourself over some time and then you'll
want the algorithm to only do the padding and RSA signing.

Cheers
