From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Subject: Re: [PATCH v3] crc32c: Implement CRC32c with slicing-by-8 algorithm
Date: Sat, 1 Oct 2011 15:52:00 +0200
Message-ID: <OF34B3D797.8C95417C-ONC125791C.00497BA8-C125791C.004C2C5A@transmode.se>
References: <OF1BEE9025.31A1BE17-ONC125791B.00203167-C125791B.00211B4A@transmode.se> <20110930161223.GW11984@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-crypto <linux-crypto@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: djwong@us.ibm.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110930161223.GW11984@tux1.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

"Darrick J. Wong" <djwong@us.ibm.com> wrote on 2011/09/30 18:12:23:
>
> [putting mailing lists on cc]
>
> On Fri, Sep 30, 2011 at 08:01:36AM +0200, Joakim Tjernlund wrote:
> >
> > (Just happen to see this patch in the archives)
> >
> > - This is basically an copy of Bobs crc32 work and duplicates code, this
> >   code needs to move into /lib/crc32.c and use the existing framework.
>
> Which framework are you talking about?  lib/crc32.c appears to be a simple
> module that exports a utility function.  Do you mean that you want to merge the
> crc32{,c}defs.h and gen_crc32{,c}table.c code?  Do you want a build script that
> starts with only a crc${ALG}_defs.h file and stamps out gencrc${ALG}_table.c
> and crc${ALG}.c boilerplate code and then builds it?

I meant adding a crc32c_le in crc32.c and extend gen_table to generate the crc32c table.

>
> I really don't know; from my perspective there was a slow implementation in
> crypto/crc32c.c and I wanted to speed it up.  crc32c seems to be in crypto/ and
> not lib/ so that the implementation can be replaced with a hardware accelerated
> version at runtime (crc32c-intel).

It was a mistake to place it there IMHO.

>
> For crc32 which has no such hw replacement (as far as I know), moving it into
> crypto/ would incur the overhead of going through the cryptoapi for not much
> benefit.  On the other hand it wouldn't be hard to put the crc32 code into
> crypto/.

No, CRC is not a crypto. It is used by other subsystems like file systems that
has nothing to do with crypto. Compare with the internet checksum, I think you
will have a hard time moving it to crypto.

> >
> > - Slice by 8 is just half the speed on my ppc32 compared to slice by 4 so
> >   it can't be enabled for all archs. Best to start with all 64 bit archs
>
> <shrug> I suppose I could make CRC32C_BITS configurable.  What is the hardware
> profile of your ppc32 processor?  How much L1D/L2 cache?  slice-by-8 does have
> a big cache footprint.  On the other hand it's faster than the slice-by-4
> (crc32) and Sarwate (crc32c) code in the kernel, even on old slow 32-bit x86
> processors (PII, PIII, P4).

It is a low end embedded 333 MHz CPU with only L1 cache. How much faster
is slice by 8 than slice by 4 on these old x86 machines?

Bobs last version tested for 64/32 bits arch and selected slice by 8/slice by 4 based
on that.

>
> > - Last time I tested Bobs slice by 8 on ppc32 it didn't work.
>
> ... is crc32c broken *now*?  It seems fine on x86/amd64/ppc64.

Don't know, I haven't tested it. Don't have much time ATM and I don't
want to test something I don't agree with.

 Jocke
