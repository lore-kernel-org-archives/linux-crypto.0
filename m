From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 4/8] akcipher: Move the RSA DER encoding to the crypto layer
Date: Fri, 26 Feb 2016 11:42:14 +0000
Message-ID: <8830.1456486934@warthog.procyon.org.uk>
References: <CAOq732KiaTLY9PidbHZ5H8GvDgi5kpxRopd8rDqvrXpCUtwgTg@mail.gmail.com> <20160219171806.17223.91381.stgit@warthog.procyon.org.uk> <20160219171836.17223.9507.stgit@warthog.procyon.org.uk> <56CB68A2.50505@intel.com> <1562.1456180090@warthog.procyon.org.uk> <CAOq732LxkcSbk93ofENxL-53SFRQEtK7PcLF9LDLYmctX9W7cA@mail.gmail.com> <12696.1456224917@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, Tadeusz Struk <tadeusz.struk@intel.com>,
	keyrings@vger.kernel.org, linux-security-module@vger.kernel.org,
	zohar@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Andrew Zaborowski <balrogg@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbcBZLmR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Feb 2016 06:42:17 -0500
In-Reply-To: <CAOq732KiaTLY9PidbHZ5H8GvDgi5kpxRopd8rDqvrXpCUtwgTg@mail.gmail.com>
Content-ID: <8829.1456486934.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Andrew Zaborowski <balrogg@googlemail.com> wrote:

> Without overhauling akcipher you could modify pkcs1pad so that sign
> takes the hash as input, adds the DER struct in front of it to build
> the signature, and the verify operation could at most check that the
> DER string matches the hash type and return the hash.  But I think
> RFC2437 suggests that you rather compare the signatures, not the
> hashes.

Whilst that is true about what RFC2437 shows, I wonder how strict it wants to
be about that rather than it just being a convenient way of describing the
algorithm.

The advantage of doing it the way the RFC suggests is that you get to use the
EMSA-PKCS1-V1_5-ENCODE operation twice, thereby saving code and only having
one place for bugs to occur instead of two - but you can argue this either
way.

That said, I would be okay with it returning just the message hash with the
padding stripped off, providing the padding is validated in the crypto layer,
if that's necessary.

David
