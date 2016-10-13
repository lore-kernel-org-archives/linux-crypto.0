From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 3/6] crypto: ccp - Add support for RSA on the CCP
Date: Thu, 13 Oct 2016 22:14:42 +0200
Message-ID: <1547080.B9ogqa6rZv@tauon.atsec.com>
References: <20161013144542.19759.6924.stgit@taos> <1603902.uM94ZuZj0Q@tauon.atsec.com> <8b8ed058-6512-ab28-446b-3c32bf91fcb0@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Gary R Hook <gary.hook@amd.com>, linux-crypto@vger.kernel.org,
        thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
To: Gary R Hook <ghook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:49854 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756496AbcJMUOs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Oct 2016 16:14:48 -0400
In-Reply-To: <8b8ed058-6512-ab28-446b-3c32bf91fcb0@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 13. Oktober 2016, 15:08:41 CEST schrieb Gary R Hook:

Hi Gary,

> On 10/13/2016 01:25 PM, Stephan Mueller wrote:
> > Am Donnerstag, 13. Oktober 2016, 09:53:09 CEST schrieb Gary R Hook:
> > 
> > Hi Gary,
> > 
> >> Wire up the v3 CCP as a cipher provider.
> >> 
> >> Signed-off-by: Gary R Hook <gary.hook@amd.com>
> >> ---
> >> 
> >> ...snip...
> >> 
> >> +}
> >> +
> >> +static void ccp_free_mpi_key(struct ccp_rsa_key *key)
> >> +{
> >> +	mpi_free(key->d);
> >> +	key->d = NULL;
> >> +	mpi_free(key->e);
> >> +	key->e = NULL;
> >> +	mpi_free(key->n);
> >> +	key->n = NULL;
> >> +}
> > 
> > Could you please see whether that function can be turned into a common
> > function call? crypto/rsa.c implements the same code in rsa_free_mpi_key.
> 
> I am happy to do so, but was unsure of protocol. rsa.c is in a module, which
> makes my module depend upon another. I do not want to do that. And moving
> this function elsewhere makes no sense.
> 
> I would go with an inline function, but there's no obvious place for it.
> The RSA software implementation uses the MPI library, but there's no
> requirement to do so (witness the qat driver). Thus, an inline function
> can't
> be put in internal/rsa.h without moving the rsa_mpi_key definition and
> referencing mpi.h.
> 
> I think that RSA+MPI things, such as rsa_mpi_key and this function, could go
> into internal/rsa.h, but it would be necessary to #include mpi.h.
> 
> Or: create a new include file that contains these (and any other) RSA/MPI
> amalgams.
> 
> Which would you prefer?

I would guess it should go to include/crypto/internal/rsa.h as an inline 
considering that the "internal" header files are for crypto provider code.


Ciao
Stephan
