From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] crypto: arm64/crc32 - detect crc32 support in assembler
Date: Fri, 27 Jan 2017 10:52:45 +0000
Message-ID: <20170127105244.GF21144@arm.com>
References: <20170127104039.29351-1-mbrugger@suse.com>
 <CAKv+Gu8P3U6_u7FdRFSdDL9jdKaJQuqHbrQ-7Qu900f8R1voZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Matthias Brugger <mbrugger@suse.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexander Graf <agraf@suse.de>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 Yazen Ghannam <yazen.ghannam@linaro.org>,
 "David S. Miller" <davem@davemloft.net>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8P3U6_u7FdRFSdDL9jdKaJQuqHbrQ-7Qu900f8R1voZw@mail.gmail.com>
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

On Fri, Jan 27, 2017 at 10:43:16AM +0000, Ard Biesheuvel wrote:
> On 27 January 2017 at 10:40, Matthias Brugger <mbrugger@suse.com> wrote:
> > Older compilers may not be able to detect the crc32 extended cpu type.
> 
> What do you mean 'detect'? Could you describe the failure in more detail
> please?
> 
> > Anyway only inline assembler code is used, which gets passed to the
> > assembler. This patch moves the crc detection to the assembler.
> >
> > Suggested-by: Alexander Graf <agraf@suse.de>
> > Signed-off-by: Matthias Brugger <mbrugger@suse.com>
> > ---
> >  arch/arm64/crypto/Makefile      | 2 --
> >  arch/arm64/crypto/crc32-arm64.c | 3 +++
> >  2 files changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
> > index aa8888d7b744..0d779dac75cd 100644
> > --- a/arch/arm64/crypto/Makefile
> > +++ b/arch/arm64/crypto/Makefile
> > @@ -48,8 +48,6 @@ CFLAGS_aes-glue-ce.o  := -DUSE_V8_CRYPTO_EXTENSIONS
> >
> >  obj-$(CONFIG_CRYPTO_CRC32_ARM64) += crc32-arm64.o
> >
> > -CFLAGS_crc32-arm64.o   := -mcpu=generic+crc
> > -
> >  $(obj)/aes-glue-%.o: $(src)/aes-glue.c FORCE
> >         $(call if_changed_rule,cc_o_c)
> >
> > diff --git a/arch/arm64/crypto/crc32-arm64.c b/arch/arm64/crypto/crc32-arm64.c
> > index 6a37c3c6b11d..10f5dd075323 100644
> > --- a/arch/arm64/crypto/crc32-arm64.c
> > +++ b/arch/arm64/crypto/crc32-arm64.c
> > @@ -29,6 +29,9 @@ MODULE_AUTHOR("Yazen Ghannam <yazen.ghannam@linaro.org>");
> >  MODULE_DESCRIPTION("CRC32 and CRC32C using optional ARMv8 instructions");
> >  MODULE_LICENSE("GPL v2");
> >
> > +/* Request crc extension capabilities from the assembler */
> > +asm(".arch_extension crc");
> > +
> 
> Will should confirm, but I think this is a recent feature in GAS for
> AArch64, so this may break older toolchains as well.

Yes, the .arch_extension directive isn't universally supported by AArch64
gas so we can't rely on it unconditionally. The best bet is to check for
the support and, if it's not present, then disable whatever feature relies
on it. See the lseinstr variable in Makefile.

Will
