From: Matthias Kaehlcke <mka@chromium.org>
Subject: Re: [PATCH v2] crypto: arm64/sha: Add constant operand modifier to
 ASM_EXPORT
Date: Tue, 18 Apr 2017 10:34:01 -0700
Message-ID: <20170418173401.GA128305@google.com>
References: <20170405183458.193068-1-mka@chromium.org>
 <CAP=VYLpejcYwXUMtCCkXmjXw=T1tBJLn21aVi-9v_VGmEinjRg@mail.gmail.com>
 <CAKv+Gu_DHBT=2YA9h+ao3pZXgEV5KsO9ia+J90wtLuDX=a4+eg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 Grant Grundler <grundler@chromium.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>,
 LKML <linux-kernel@vger.kernel.org>, Greg Hackmann <ghackmann@google.com>,
 Michael Davidson <md@google.com>,
 Paul Gortmaker <paul.gortmaker@windriver.com>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 Robin Murphy <robin.murphy@arm.com>, "David S . Miller" <davem@davemloft.net>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_DHBT=2YA9h+ao3pZXgEV5KsO9ia+J90wtLuDX=a4+eg@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

El Tue, Apr 18, 2017 at 04:35:02PM +0100 Ard Biesheuvel ha dit:

> On 18 April 2017 at 15:47, Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
> > On Wed, Apr 5, 2017 at 2:34 PM, Matthias Kaehlcke <mka@chromium.org> wrote:
> >> The operand is an integer constant, make the constness explicit by
> >> adding the modifier. This is needed for clang to generate valid code
> >> and also works with gcc.
> >
> > Actually it doesn't work with all gcc.  I've got an older arm64 toolchain that I
> > only use for syntax checking (and hence I don't care if it is the latest and
> > greatest) and this commit breaks it:
> >
> > arch/arm64/crypto/sha1-ce-glue.c:21:2: error: invalid 'asm': invalid
> > operand prefix '%c'
> >   asm(".globl " #sym "; .set " #sym ", %c0" :: "i"(val));

Sorry about that :(

> > I'm currently reverting this change locally so I can continue to use the old
> > toolchain:
> >
> > $ aarch64-linux-gnu-gcc --version
> > aarch64-linux-gnu-gcc (crosstool-NG linaro-1.13.1-4.8-2013.12 - Linaro
> > GCC 2013.11) 4.8.3 20131202 (prerelease)
> > Copyright (C) 2013 Free Software Foundation, Inc.
> >
> > $ aarch64-linux-gnu-as --version
> > GNU assembler (crosstool-NG linaro-1.13.1-4.8-2013.12 - Linaro GCC
> > 2013.11) 2.24.0.20131220
> > Copyright 2013 Free Software Foundation, Inc.
> >
> > Maybe it is finally too old and nobody cares, but I thought it worth a mention.
> >
> 
> Thanks for the report. I think we care more about GCC 4.8 than about
> Clang, which argues for reverting this patch.

I agree, we certainly shouldn't break GCC.

> I understand these issues must be frustrating if you are working on
> this stuff, but to me, it is not entirely obvious why we want to
> support Clang in the first place (i.e., what does it buy you if your
> distro/environment is not already using Clang for userland),

There are environments that use Clang for userland, like Chrome OS or
Android. Debian releases with GCC, but also does Clang builds of most
of its repository: http://clang.debian.net/

I would also argue that Linux directly benefits from additional error
checks provided by Clang.

> and why the burden is on Linux to make modifications to support
> Clang, especially when it comes to GCC extensions such as inline
> assembly syntax.

Personally I'm on the pragmatic side. 99.9x% of the kernel already
builds with Clang (at least for arm64 and x86), only a very tiny
fraction of the code needs adaptation, which should ideally result in
the same code for gcc and clang. And it's not like Clang is just
another proprietary or niche compiler, it's the other big open source
compiler out there, since the effort is relatively small it seems
desirable to support it without out-of-tree patches. In parallel there
is also work ongoing with upstream Clang to improve compatiblity.

> It is ultimately up to the maintainers to decide what to do with this
> patch, but my vote would be to revert it, especially given that the %c
> placeholder prefix is not documented anywhere, and appears to simply
> trigger some GCC internals that happen to do the right thing in this
> case.
> 
> However, the I -> i change is arguably an improvement, and considering
> that the following
> 
> asm("foo: .long %0" :: "i"(some value))
> 
> doesn't compile with clang either, I suggest you (Matthias) file a bug
> against Clang to get this fixed, and we can propose another patch just
> for the I->i change.

Ok, I will see if we can get this fixed in Clang.

Thanks

Matthias
