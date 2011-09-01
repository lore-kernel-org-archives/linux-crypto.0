From: Phil Sutter <phil@nwl.cc>
Subject: Re: comparison of the AF_ALG interface with the /dev/crypto
Date: Thu, 1 Sep 2011 15:39:52 +0200
Message-ID: <20110901133952.GB14522@orbit.nwl.cc>
References: <4E5A3FCC.2030504@gnutls.org>
 <20110901021534.GA26330@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nikos Mavrogiannopoulos <nmav@gnutls.org>,
	cryptodev-linux-devel@gna.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orbit.nwl.cc ([91.121.141.167]:54585 "EHLO orbit.nwl.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757466Ab1IANjx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 Sep 2011 09:39:53 -0400
Content-Disposition: inline
In-Reply-To: <20110901021534.GA26330@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert,

On Thu, Sep 01, 2011 at 12:15:34PM +1000, Herbert Xu wrote:
> Nikos Mavrogiannopoulos <nmav@gnutls.org> wrote:
> >
> > Given my benchmarks have no issues, it is not apparent to me why one
> > should use AF_ALG instead of cryptodev. I do not know though why AF_ALG
> > performs so poor. I'd speculate by blaming it on the usage of the socket
> > API and the number of system calls required.
> 
> The target usage of AF_ALG is hardware offload devices that cannot
> be directly used in user-space, not software crypto on implementations
> such as AESNI/Padlock.
> 
> Going through the kernel to use something like AESNI/Padlock or
> software crypto is insane.
> 
> Given the intended target case, your numbers are pretty much
> meaningless as cryptodev's performance can be easily beaten
> by a pure user-space implementation.

I ran the benchmarks on my OpenRD Ultimate, an embedded device equipped
with the Marvell Kirkwood SoC, which also contains the CESA crypto
engine. Hopefully a less "insane" use-case, also from your point of
view. Here are the results of the "fulltest", i.e. init, AES128 and deinit
measured as a whole:

chunksize       af_alg          cryptodev       (100 * cryptodev / af_alg)
--------------------------------------------------------------------------
512              4.169 MB/s      7.113 MB/s     171 %
1024             7.904 MB/s     12.957 MB/s     164 %
2048            13.163 MB/s     19.683 MB/s     150 %
4096            20.218 MB/s     26.960 MB/s     133 %
8192            27.539 MB/s     34.373 MB/s     125 %
16384           33.730 MB/s     39.997 MB/s     119 %
32768           37.399 MB/s     42.727 MB/s     114 %
65536           40.004 MB/s     44.660 MB/s     112 %

although I'm quite sure there's a reason why these values are
meaningless as well, I would like to point out that cryptodev-linux has
outperformed AF_ALG in every situation they have been compared so far.

Greetings, Phil
