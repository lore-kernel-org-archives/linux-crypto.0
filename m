From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v3 1/4] crypto: add template handling for RNGs
Date: Mon, 18 Jul 2016 17:37:43 +0200
Message-ID: <1543509.dMjNnZsrjW@tauon.atsec.com>
References: <2944776.2qGGKJgDkv@positron.chronox.de> <20160718071417.GA12600@gondor.apana.org.au> <CACXcFmk2huwT94eVec46Dmfs2p3dcMNzf+nUaFRgYPB-AnZo3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	mathew.j.martineau@linux.intel.com, dhowells@redhat.com,
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org
To: Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34708 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbcGRPhr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jul 2016 11:37:47 -0400
In-Reply-To: <CACXcFmk2huwT94eVec46Dmfs2p3dcMNzf+nUaFRgYPB-AnZo3g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 18. Juli 2016, 11:23:26 schrieb Sandy Harris:

Hi Sandy,

> On Mon, Jul 18, 2016 at 3:14 AM, Herbert Xu <herbert@gondor.apana.org.au> 
wrote:
> > Stephan Mueller <smueller@chronox.de> wrote:
> >> This patch adds the ability to register templates for RNGs. RNGs are
> >> "meta" mechanisms using raw cipher primitives. Thus, RNGs can now be
> >> implemented as templates to allow the complete flexibility the kernel
> >> crypto API provides.
> 
> I do not see why this might be desirable, let alone necessary.
> Security-critical code should be kept as simple as possible.
> Don't we need just one good RNG?

Well, why do we have multiple symmetric ciphers, hashes, or asymmetric 
ciphers? This allows different users to pick the cipher he likes. Maybe there 
is an issue found in one of them and having multiple at the disposal, allows 
an immediate fixing of issues.

Furthermore, the kernel crypto API supports hardware implementations. So, on 
one arch, you may have an accelerated SHA256 whereas on another you have an 
accelerated SHA512. And accelerated implementations are not only useful for 
speed improvements, but for security purposes as well (like cache-attack 
resistance).

This applies to RNGs too. Furthermore, I think an SP800-90A DRBG is a good 
one. But many people find this standard smelly just because of the Dual EC 
fiasco. Or it is smelly because it was developed by the US organization called 
NIST.

At the level of the kernel crypto API, no policies should be enforced. 
Policies (such as what is the "right" cipher) should be defined outside the 
kernel.

Furthermore, the RNG approach shall be usable for mechanisms that act RNG-like 
but are no real RNGs. The prime example as given with the patch set is the 
KDF. A KDF acts like an RNG, but is not considered as one. Now, there are many 
different types of KDFs out there. SP800-108 is one (defining three types), 
SP800-56A defines more.

For the KDF implementation I did not want to hard-wire the KDF logic with a 
defined cipher like SHA-256, but allow the caller to define the used hash. 
Thus I need the plumbing code do to that.

Ciao
Stephan
