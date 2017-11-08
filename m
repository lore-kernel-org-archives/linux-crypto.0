From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: [PATCH v2] lib/mpi: call cond_resched() from mpi_powm() loop
Date: Wed, 8 Nov 2017 12:49:02 -0800 (PST)
Message-ID: <alpine.OSX.2.21.1711081239190.27414@mjmartin-nuc02.sea.intel.com>
References: <20171108191804.GA74965@gmail.com> <20171107221527.98433-1-ebiggers3@gmail.com> <25888.1510145417@warthog.procyon.org.uk> <17716.1510172232@warthog.procyon.org.uk> <20171108202803.GA14292@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Cc: David Howells <dhowells@redhat.com>, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tudor-Dan Ambarus <tudor.ambarus@microchip.com>,
        Salvatore Benedetto <salvatore.benedetto@intel.com>,
        keyrings@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171108202803.GA14292@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 8 Nov 2017, Eric Biggers wrote:

> On Wed, Nov 08, 2017 at 08:17:12PM +0000, David Howells wrote:
>> Eric Biggers <ebiggers3@gmail.com> wrote:
>>
>>> This probably should be grouped with my series "crypto: dh - input validation
>>> fixes", as this is also a fix for Diffie-Hellman.  I was actually expecting
>>> Herbert Xu to take these patches, as Diffie-Hellman is now part of the crypto
>>> API (crypto/dh.c); none of the patches actually touch security/keys/.
>>
>> Fine by me.
>>
>>> If you'd like to maintain the Diffie-Hellman implementation(s) you should
>>> get yourself added to MAINTAINERS for the relevant files.
>>
>> It touches the MPI lib, though, so it also potentially affects RSA and stuff,
>> which is why I introduced it to the kernel originally.
>>
>
> True, mpi_powm() might also be reachable by adding a key of type "asymmetric",
> in which case this fix would need to go to older kernels than v4.12.  If I have
> a chance I'll see if I can find a reproducer.

CONFIG_KEY_DH_OPERATIONS and use of mpi_powm() by KEYCTL_DH_COMPUTE goes 
back to v4.7, when the MPI library was called directly. KPP was not 
implemented yet.

--
Mat Martineau
Intel OTC
