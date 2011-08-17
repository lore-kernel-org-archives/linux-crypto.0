From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: Re: [RFC v1.1 1/5] crypto: GnuPG based MPI lib
Date: Wed, 17 Aug 2011 14:42:36 +0200
Message-ID: <CAJU7zaKsnugdgz9VohW+vXWs7kdajv07okZm58DHvM=c0W-HFw@mail.gmail.com>
References: <cover.1313082284.git.dmitry.kasatkin@intel.com>
	<b1b21a68321fa5fc79295a28e4560391606b043e.1313082284.git.dmitry.kasatkin@intel.com>
	<4E49456A.4020506@intel.com>
	<CAJU7zaKYRLO1yfNBZOho6LSczYr+PPvHT7zfmo=kSoVcM=O2ng@mail.gmail.com>
	<4E4BB2A9.30508@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, zohar@linux.vnet.ibm.com
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <4E4BB2A9.30508@intel.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Aug 17, 2011 at 2:23 PM, Dmitry Kasatkin
<dmitry.kasatkin@intel.com> wrote:

>> Was there a particular reason to select the GnuPG mpi lib? Why not
>> include gmp (the gnupg mpi lib is a very old fork of gmp), or some other
>> big number library?
> GNUPG MPI kernel port was available and has shown the best performance
> comparing to other kernel implementations
> such as LibTomMath and once other rsa implementation..
> In fact I took libtommath from your cryptodev-linux#newapi project.
> I have patches and RSA implementation in my git trees.
> IIRC performance was about twice worse than in Gnupg MPI lib...

Quite impressive [0]. In GnuTLS we had the same (2x) performance
optimization by switching to gmp from the gnupg mpi. I remember
some projects ported gmp to linux kernel, but I don't know how wise
that would be. Gmp (and the original gnupg mpi - don't know about the port)
have no easy way to indicate memory allocation failure. That
was my reason to select libtommath instead of them.

regards,
Nikos

[0]. There is a limitation in libtommath as I ported it in the linux
kernel. It uses 32-bit numbers even in x86-64. Libtommath required an
128-bit type to support 64-bit numbers that was available to
user-space via gcc but not in linux-kernel. Performance of mpi was not
my goal then, so I didn't investigate it more.
