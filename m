From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v5 0/3] crypto: KEYS: convert public key to akcipher api
Date: Sun, 07 Feb 2016 00:43:53 +0000
Message-ID: <12277.1454805833@warthog.procyon.org.uk>
References: <20160206142705.GA23978@gondor.apana.org.au> <20160206074731.GF22220@gondor.apana.org.au> <20160202180848.2887.9937.stgit@tstruk-mobl1> <11215.1454752821@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: dhowells@redhat.com, jmorris@namei.org,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, zohar@linux.vnet.ibm.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbcBGAn4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 6 Feb 2016 19:43:56 -0500
In-Reply-To: <20160206142705.GA23978@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu <herbert@gondor.apana.org.au> wrote:

> > Hmmm...  That means that the crypto branch and the security branch =
are going
> > to conflict.
>=20
> I thought you were OK with it going in now as you said that you'll
> fix it up later.  Sorry for the misunderstanding.  Do you want me to
> revert?

Ummm.  I did say I'd take it on top of my patches.  How did you take it=
?  Did
you merge Tadeusz's branch?  If so, I can probably merge it into mine a=
lso and
git will Just Do The Right Thing=E2=84=A2.

David
