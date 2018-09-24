From: Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: [PATCH] crypto: ccp: Remove forward declaration
Date: Mon, 24 Sep 2018 14:44:25 -0700
Message-ID: <20180924214425.GA22651@flashbox>
References: <20180924172615.25591-1-natechancellor@gmail.com>
 <33c9afa7-ea62-1248-1da4-381f93238627@amd.com>
 <20180924194040.GA17672@flashbox>
 <9cbc1f67-719e-de75-8b0c-2de4da71b2f8@amd.com>
 <CAKwvOdkOp5eV-o9++y=5b=5NS4fG_snT3OA8DGBnsZWtD60cUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ghook@amd.com, Thomas.Lendacky@amd.com, Gary.Hook@amd.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Nick Desaulniers <ndesaulniers@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKwvOdkOp5eV-o9++y=5b=5NS4fG_snT3OA8DGBnsZWtD60cUA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Sep 24, 2018 at 02:42:56PM -0700, Nick Desaulniers wrote:
> On Mon, Sep 24, 2018 at 2:22 PM Gary R Hook <ghook@amd.com> wrote:
> >
> > On 09/24/2018 02:40 PM, Nathan Chancellor wrote:
> > > On Mon, Sep 24, 2018 at 07:18:23PM +0000, Gary R Hook wrote:
> > >> On 09/24/2018 12:26 PM, Nathan Chancellor wrote:
> > >>> Clang emits a warning about this construct:
> > >>>
> > >>> drivers/crypto/ccp/sp-platform.c:36:36: warning: tentative array
> > >>> definition assumed to have one element
> > >>> static const struct acpi_device_id sp_acpi_match[];
> > >>>                                      ^
> > >>> 1 warning generated.
> > >>>
> > >>> Just remove the forward declarations and move the initializations up
> > >>> so that they can be used in sp_get_of_version and sp_get_acpi_version.
> > >>
> > >> I'm not going to out and out object to this just yet.
> > >>
> > >> I am not a clang expert. Can you please provide a make command that
> > >> would explain how you precipitated this complaint?
> > >>
> > >
> > > Hi Gary,
> > >
> > > I can produce the warning with Clang 6.0 using the following set of
> > > commands:
> > >
> > > make ARCH=arm64 CC=clang CROSS_COMPILE=aarch64-linux-gnu- allyesconfig
> > > ./scripts/config -d CONFIG_CPU_BIG_ENDIAN
> > > make ARCH=arm64 CC=clang CROSS_COMPILE=aarch64-linux-gnu- olddefconfig
> > > make ARCH=arm64 CC=clang CROSS_COMPILE=aarch64-linux-gnu- drivers/crypto/ccp/sp-platform.o
> >
> > No, I"m not getting a warning on my system. I get this:
> >
> > ghook@taos:~/src/cryptodev-2.6/src$ make ARCH=arm64 CC=clang
> > CROSS_COMPILE=aarch64-linux-gnu- CFLAGS=-v
> > arch/arm64/Makefile:27: ld does not support --fix-cortex-a53-843419;
> > kernel may be susceptible to erratum
> > arch/arm64/Makefile:40: LSE atomics not supported by binutils
> 
> ./scripts/config -d CONFIG_ARM64_LSE_ATOMICS
> 

D'oh, I keep forgetting to update my gist with my commands...

Thanks!

> > arch/arm64/Makefile:48: Detected assembler with broken .inst;
> > disassembly will be unreliable
> >    CALL    scripts/checksyscalls.sh
> >    VDSOA   arch/arm64/kernel/vdso/gettimeofday.o
> > arch/arm64/kernel/vdso/gettimeofday.S: Assembler messages:
> > arch/arm64/kernel/vdso/gettimeofday.S:28: Error: no such instruction:
> > `vdso_data .req x6'
> > arch/arm64/kernel/vdso/gettimeofday.S:29: Error: no such instruction:
> > `seqcnt .req w7'
> > arch/arm64/kernel/vdso/gettimeofday.S:30: Error: no such instruction:
> > `w_tmp .req w8'
> > ...
> >
> > The only reason I bring this up is that it would be helpful to be able
> > to recreate results. I figure I'm not set up for this.
> >
> > That said... please see my response to Nick.
> 
> 
> 
> -- 
> Thanks,
> ~Nick Desaulniers
