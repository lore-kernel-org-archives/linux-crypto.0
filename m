From: Andrew Zaborowski <balrogg@googlemail.com>
Subject: Re: [PATCH 4/8] akcipher: Move the RSA DER encoding to the crypto layer
Date: Tue, 23 Feb 2016 12:25:28 +0100
Message-ID: <CAOq732KiaTLY9PidbHZ5H8GvDgi5kpxRopd8rDqvrXpCUtwgTg@mail.gmail.com>
References: <20160219171806.17223.91381.stgit@warthog.procyon.org.uk>
	<20160219171836.17223.9507.stgit@warthog.procyon.org.uk>
	<56CB68A2.50505@intel.com>
	<1562.1456180090@warthog.procyon.org.uk>
	<CAOq732LxkcSbk93ofENxL-53SFRQEtK7PcLF9LDLYmctX9W7cA@mail.gmail.com>
	<12696.1456224917@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Tadeusz Struk <tadeusz.struk@intel.com>, keyrings@vger.kernel.org,
	linux-security-module@vger.kernel.org, zohar@linux.vnet.ibm.com,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: David Howells <dhowells@redhat.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <12696.1456224917@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi David,

On 23 February 2016 at 11:55, David Howells <dhowells@redhat.com> wrote:
> Andrew Zaborowski <balrogg@googlemail.com> wrote:
>
>> AIUI Tadeusz is proposing adding the hashing as a new feature.  Note
>> though that the hash paremeter won't make sense for the encrypt,
>> decrypt or verify operations.
>
> The hash parameter is necessary for the verify operation.  From my
> perspective, I want a verify operation that takes the signature, the message
> hash and the hash name and gives me back an error code.

>From the certificates point of view yes, but the akcipher API only has
the four operations each of which has one input buffer and out output
buffer.

Without overhauling akcipher you could modify pkcs1pad so that sign
takes the hash as input, adds the DER struct in front of it to build
the signature, and the verify operation could at most check that the
DER string matches the hash type and return the hash.  But I think
RFC2437 suggests that you rather compare the signatures, not the
hashes.

Cheers
