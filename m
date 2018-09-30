From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v6 07/23] zinc: ChaCha20 ARM and ARM64
 implementations
Date: Sun, 30 Sep 2018 04:33:20 +0200
Message-ID: <CAHmME9rw=khsP=8PzbWUtwjVh55stzgr1qHcQUi8h7-a--Sr7w@mail.gmail.com>
References: <20180925145622.29959-1-Jason@zx2c4.com>
 <20180925145622.29959-8-Jason@zx2c4.com>
 <CAKv+Gu8knzzmK4_KouFQWKzMdHFgEsk-CtBrcuAvk0bYkDFO=w@mail.gmail.com>
 <CAHmME9qtN8kiKnMHTa76r9a_5Ou_s3WhAMT_HnH7-1FeoHUOZg@mail.gmail.com>
 <CAKv+Gu9FoFQymp2-=rUeh14CkUKON389OCE7stYCOFwKZpaCrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
 Netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 Russell King - ARM Linux <linux@armlinux.org.uk>,
 Samuel Neves <sneves@dei.uc.pt>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Andrew Lutomirski <luto@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 David Miller <davem@davemloft.net>, linux-arm-kernel@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAKv+Gu9FoFQymp2-=rUeh14CkUKON389OCE7stYCOFwKZpaCrg@mail.gmail.com>
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

Hi Ard,

On Sat, Sep 29, 2018 at 8:16 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> > You mean to say that since these nobs are def_bool y and are
> > essentially "depends on ARM", then I should just straight up use
> > CONFIG_ARM? I had thought about this, but figured this would make it
> > easier to later make these optional or have other options block them
> > need be, or even if the dependencies and requirements for having them
> > changes (for example, with UML on x86). I think doing it this way
> > gives us some flexibility later on. So if that's a compelling enough
> > reason, I'd like to keep those.
>
> Sure. But probably better to be consistent then, and stop using
> CONFIG_ARM directly in your code.

Ack.

> > The reason it was added was indeed because of:
> > https://lists.01.org/pipermail/kbuild-all/2018-September/053114.html
> > -- exactly what you suspected, ARCH_RPC. Have a better suggestion than
> > !CPU_32v3?
>
> Yes, you could just add
>
> asflags-$(CONFIG_CPU_32v3) += -march=armv4
>
> with a comment stating that we don't actually support ARMv3 but only
> use it as a code generation target for reasons unrelated to the ISA

Alright, I'll do exactly that. Though, if the rationale for this has
to do only with codegen -- with what the C compiler does -- then
shouldn't this be set globally for CONFIG_CPU_32v3? I couldn't find
any macros that test against __LINUX_ARM_ARCH__ being 3 in the
assembly, so this shouldn't be a problem I don't think. Maybe I'll
send a patch.

Jason
