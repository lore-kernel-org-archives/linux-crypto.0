From: Stephan Mueller <smueller@chronox.de>
Subject: Re: key retention service: DH support
Date: Tue, 24 May 2016 09:14:52 +0200
Message-ID: <1884439.7dZQH0lY4q@tauon.atsec.com>
References: <1522711.HEekpKlqDU@positron.chronox.de> <27639.1464073468@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
	mathew.j.martineau@linux.intel.com
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34702 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417AbcEXHO4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 May 2016 03:14:56 -0400
In-Reply-To: <27639.1464073468@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 24. Mai 2016, 08:04:28 schrieb David Howells:

Hi David,

> Stephan Mueller <smueller@chronox.de> wrote:
> > With the new DH support for the key retention service, support for DH
> > derived keys pops up.
> > 
> > The implementation in security/keys/dh.c returns the DH shared secret
> > straight to the user space caller.
> > 
> > I implemented a KDF with that exact scenario already in mind: [1].
> > 
> > I am wondering whether the shared secret should be processed by a KDF
> > before returning the data to user space?
> > 
> > [1] http://www.chronox.de/kdf.html
> 
> Adding Mat to the cc list.  If we want to modify the new DH keyctl, we have
> a very short time window in which to do so.

The KDF patches are fully tested. All that would be needed on the key 
retention side after the shared secret generation are the following calls:

kdf = crypto_alloc_rng(NAME, 0, 0);

crypto_rng_reset(kdf, <shared_secret>, sizeof(<shared_secret>));

crypto_rng_generate(kdf, LABEL, sizeof(LABEL), outbuf, outbuflen);

NAME would be the KDF type such as "kdf_ctr(hmac(sha256))"

LABEL would be an arbitrary string defined by the key service (e.g. 
"LxKeyRet").

Ciao
Stephan
