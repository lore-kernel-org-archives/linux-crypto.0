From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v2] lib/mpi: call cond_resched() from mpi_powm() loop
Date: Wed, 08 Nov 2017 20:17:12 +0000
Message-ID: <17716.1510172232@warthog.procyon.org.uk>
References: <20171108191804.GA74965@gmail.com> <20171107221527.98433-1-ebiggers3@gmail.com> <25888.1510145417@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: dhowells@redhat.com, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tudor-Dan Ambarus <tudor.ambarus@microchip.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Salvatore Benedetto <salvatore.benedetto@intel.com>,
        keyrings@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171108191804.GA74965@gmail.com>
Content-ID: <17715.1510172232.1@warthog.procyon.org.uk>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Eric Biggers <ebiggers3@gmail.com> wrote:

> This probably should be grouped with my series "crypto: dh - input validation
> fixes", as this is also a fix for Diffie-Hellman.  I was actually expecting
> Herbert Xu to take these patches, as Diffie-Hellman is now part of the crypto
> API (crypto/dh.c); none of the patches actually touch security/keys/.

Fine by me.

> If you'd like to maintain the Diffie-Hellman implementation(s) you should
> get yourself added to MAINTAINERS for the relevant files.

It touches the MPI lib, though, so it also potentially affects RSA and stuff,
which is why I introduced it to the kernel originally.

David
