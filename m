From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v6 0/3] crypto: caam - add support for RSA algorithm
Date: Mon, 23 May 2016 15:02:57 +0200
Message-ID: <3395695.ChDFsreWpU@tauon.atsec.com>
References: <1463660118-19188-1-git-send-email-tudor-dan.ambarus@nxp.com> <2370625.CgO9A4qjJ6@positron.chronox.de> <AMSPR04MB536BAC8C0E2406B390B1C4CB84E0@AMSPR04MB536.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Horia Ioan Geanta Neag <horia.geanta@nxp.com>
To: Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:39808 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859AbcEWNDB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 May 2016 09:03:01 -0400
In-Reply-To: <AMSPR04MB536BAC8C0E2406B390B1C4CB84E0@AMSPR04MB536.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 23. Mai 2016, 12:56:18 schrieb Tudor-Dan Ambarus:

Hi Tudor,

> Hi Stephan,
> 
> > as I am looking into the RSA countermeasures, I am wondering how much of
> > countermeasures are actually applied inside hardware implementations.
> 
> Please point me to the reference RSA countermeasures so that we have
> a common point of start.

As the entire MPI logic is derived from libgcrypt, I am planning to use the 
libgcrypt implementation as a basis to implement the blinding defined by the 
Handbook of Applied Cryptograpy 11.118/11.119.


This is the code from libgcrypt:

    {
      /* First, we need a random number r between 0 and n - 1, which
         is relatively prime to n (i.e. it is neither p nor q).  The
         random number needs to be only unpredictable, thus we employ
         the gcry_create_nonce function by using GCRY_WEAK_RANDOM with
         gcry_mpi_randomize.  */
      r  = mpi_snew (ctx.nbits);
      ri = mpi_snew (ctx.nbits);
      bldata = mpi_snew (ctx.nbits);

      do
        {
          _gcry_mpi_randomize (r, ctx.nbits, GCRY_WEAK_RANDOM);
          mpi_mod (r, r, sk.n);
        }
      while (!mpi_invm (ri, r, sk.n));

      /* Do blinding.  We calculate: y = (x * r^e) mod n, where r is
         the random number, e is the public exponent, x is the
         non-blinded data and n is the RSA modulus.  */
      mpi_powm (bldata, r, sk.e, sk.n);
      mpi_mulm (bldata, bldata, data, sk.n);

      /* Perform decryption.  */
      secret (plain, bldata, &sk);
      _gcry_mpi_release (bldata); bldata = NULL;

      /* Undo blinding.  Here we calculate: y = (x * r^-1) mod n,
         where x is the blinded decrypted data, ri is the modular
         multiplicative inverse of r and n is the RSA modulus.  */
      mpi_mulm (plain, plain, ri, sk.n);

      _gcry_mpi_release (r); r = NULL;
      _gcry_mpi_release (ri); ri = NULL;
    }


"All we need" in the kernel is mpi_invm and mpi_mulm.

> 
> Thanks,
> ta


Ciao
Stephan
