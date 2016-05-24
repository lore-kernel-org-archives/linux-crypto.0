From: David Howells <dhowells@redhat.com>
Subject: Re: key retention service: DH support
Date: Tue, 24 May 2016 08:19:41 +0100
Message-ID: <28895.1464074381@warthog.procyon.org.uk>
References: <1884439.7dZQH0lY4q@tauon.atsec.com> <1522711.HEekpKlqDU@positron.chronox.de> <27639.1464073468@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, mathew.j.martineau@linux.intel.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752990AbcEXHTo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 May 2016 03:19:44 -0400
In-Reply-To: <1884439.7dZQH0lY4q@tauon.atsec.com>
Content-ID: <28894.1464074381.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Stephan Mueller <smueller@chronox.de> wrote:

> The KDF patches are fully tested. All that would be needed on the key 
> retention side after the shared secret generation are the following calls:
> 
> kdf = crypto_alloc_rng(NAME, 0, 0);
> 
> crypto_rng_reset(kdf, <shared_secret>, sizeof(<shared_secret>));
> 
> crypto_rng_generate(kdf, LABEL, sizeof(LABEL), outbuf, outbuflen);
> 
> NAME would be the KDF type such as "kdf_ctr(hmac(sha256))"
> 
> LABEL would be an arbitrary string defined by the key service (e.g. 
> "LxKeyRet").

So there wouldn't be a change to the DH keyctl (including functional)?

David
