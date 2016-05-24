From: Stephan Mueller <smueller@chronox.de>
Subject: Re: key retention service: DH support
Date: Tue, 24 May 2016 09:29:15 +0200
Message-ID: <2025704.nsKCcck7Ux@tauon.atsec.com>
References: <1884439.7dZQH0lY4q@tauon.atsec.com> <27639.1464073468@warthog.procyon.org.uk> <28895.1464074381@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
	mathew.j.martineau@linux.intel.com
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34708 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbcEXH3T (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 May 2016 03:29:19 -0400
In-Reply-To: <28895.1464074381@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 24. Mai 2016, 08:19:41 schrieb David Howells:

Hi David,

> Stephan Mueller <smueller@chronox.de> wrote:
> > The KDF patches are fully tested. All that would be needed on the key
> > retention side after the shared secret generation are the following calls:
> > 
> > kdf = crypto_alloc_rng(NAME, 0, 0);
> > 
> > crypto_rng_reset(kdf, <shared_secret>, sizeof(<shared_secret>));
> > 
> > crypto_rng_generate(kdf, LABEL, sizeof(LABEL), outbuf, outbuflen);
> > 
> > NAME would be the KDF type such as "kdf_ctr(hmac(sha256))"
> > 
> > LABEL would be an arbitrary string defined by the key service (e.g.
> > "LxKeyRet").
> 
> So there wouldn't be a change to the DH keyctl (including functional)?

Assuming that the LABEL and/or the KDF name are not configurable by user 
space, the only potential difference I would see is that a user could ask for 
the length of the output data.

Think of it like the KDF in a network protocol where the shared secret has 
some length X but the caller needs data of length Y for a specific use (e.g. a 
symmetric key plus an HMAC key). The use case for such "local" DH operation 
would be the writing of encrypted data while the system is locked. The 
encryption of the actual file data is done using a symmetric algo with 
symmetric key, potentially with an integrity key. Usually, the DH shared 
secret size is not equal to the size of a symmetric key. So, a KDF would be 
needed to bring it to the right size.

Ciao
Stephan
