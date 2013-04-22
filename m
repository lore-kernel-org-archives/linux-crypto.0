From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] lib: Add lz4 compressor module
Date: Mon, 22 Apr 2013 14:29:05 -0700
Message-ID: <20130422142905.3e4fff72671bb3e245055eee@linux-foundation.org>
References: <CAOAMb1D8rokZpQpp6mEJw6KXcQq8fJUWBJoC5+ZfkNaE6WvAZA@mail.gmail.com>
	<CAMuHMdXXoaQjb9sRK=X3gEDwqQBJcJQtaJbUGB8cJmteHSN3vQ@mail.gmail.com>
	<51750159.07d70e0a.5461.ffffec64SMTPIN_ADDED_BROKEN@mx.google.com>
	<CAMuHMdUv=GR6s=BYXHR7KyaKCUSxmkJO8dzZJMRktu3cUCTbsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Chanho Min <chanho.min@lge.com>,
	"Darrick J. Wong" <djwong@us.ibm.com>,
	Bob Pearson <rpearson@systemfabricworks.com>,
	Richard Weinberger <richard@nod.at>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org,
	Yann Collet <yann.collet.73@gmail.com>,
	Kyungsik Lee <kyungsik.lee@lge.com>,
	"Linux/m68k" <linux-m68k@vger.kernel.org>,
	sparclinux <sparclinux@vger.kernel.org>,
	Linux-Next <linux-next@vger.kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdUv=GR6s=BYXHR7KyaKCUSxmkJO8dzZJMRktu3cUCTbsw@mail.gmail.com>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, 22 Apr 2013 11:24:21 +0200 Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> On Mon, Apr 22, 2013 at 11:22 AM, Chanho Min <chanho.min@lge.com> wrote:
> >>> +#define HTYPE const u8*
> >>> +
> >>> +#ifdef __BIG_ENDIAN
> >>> +#define LZ4_NBCOMMONBYTES(val) (__builtin_clz(val) >> 3)
> >>> +#else
> >>> +#define LZ4_NBCOMMONBYTES(val) (__builtin_ctz(val) >> 3)
> >>> +#endif
> >>
> >>It seems at least m68k and sparc don't have the __builtin_clz() functions:
> >>
> >>m68k-allmodconfig (http://kisskb.ellerman.id.au/kisskb/buildresult/8572593/):
> >>
> >>ERROR: "__clzsi2" [lib/lz4/lz4hc_compress.ko] undefined!
> >>ERROR: "__clzsi2" [lib/lz4/lz4_compress.ko] undefined!
> >
> > gcc seems to define __builtin_clz as __clzsi2 in some architecture.
> > But, kernel doesn't link libgcc.a.
> > If kernel should use gcc's built-in function without libgcc.a,
> > do we need to port __clzsi2 to 'arch/*/lib/*'?
> 
> That's another option.

Without having seen the patch ....  Yes, if we fix it this way then we
also fix it for future callers of __builtin_clz().
