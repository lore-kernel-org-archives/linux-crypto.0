From: David Howells <dhowells@redhat.com>
Subject: Re: [RFC PATCH] KEYS: Provide keyctls to do public key operations
Date: Fri, 15 Apr 2016 23:00:59 +0100
Message-ID: <5133.1460757659@warthog.procyon.org.uk>
References: <571137C3.1050805@intel.com> <18908.1460671231@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, pjones@redhat.com, marcel@holtmann.org,
	dwmw2@infradead.org, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683AbcDOWBF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Apr 2016 18:01:05 -0400
In-Reply-To: <571137C3.1050805@intel.com>
Content-ID: <5132.1460757659.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Tadeusz Struk <tadeusz.struk@intel.com> wrote:

> > --- a/crypto/asymmetric_keys/signature.c
> > +++ b/crypto/asymmetric_keys/signature.c
> 
> Since this file implements the enc/dec operations also
> should it be renamed to crypto/asymmetric_keys/public_key_ops.c
> or something similar? signature.c is a bit confusing now.

Yes.  Or maybe accessors.c.  I'm also tempted to merge it into
asymmetric_type.c.  One question is how many other ops we might want to add.

It might even be worth making the functions key_encrypt_blob(),
key_decrypt_blob(), key_create_signature() and key_verify_signature() and
jumping through the type ops table.  I still haven't decided whether I want to
go to that extent yet as it leads to an extra function call on the stack.

> This will work perfectly for the algif_akcipher. Thanks for providing this.
> I'm going to rebase my patches on top of this and resend.

Note that this is a bit thrown together.  I'm travelling right now and
conferencing next week which is why I haven't managed to test it yet - so
beware, there may be dragons;-)

> Should I use your keys-next as a base for the new version?

That's the base I used.

David
