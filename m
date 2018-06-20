From: Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH v2 0/5] crypto: ccree: cleanup, fixes and R-Car enabling
Date: Wed, 20 Jun 2018 10:51:46 +0200
Message-ID: <20180620085145.7bxfbu7bi45sftnk@verge.net.au>
References: <1527171551-21979-1-git-send-email-gilad@benyossef.com>
 <CAMuHMdVXrppnFEBmR3xhwNu3i0N3mVE1+FJRjEcWBYpHHbsAsw@mail.gmail.com>
 <CAOtvUMc8D9DQFC6vZ+GnaVBg5uFVrQmOrnSQKz7ZPHGh4BCsZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Mark Rutland <mark.rutland@arm.com>,
 "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
 <devicetree@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
 Geert Uytterhoeven <geert+renesas@glider.be>, Stephen Boyd <sboyd@kernel.org>,
 Will Deacon <will.deacon@arm.com>, Michael Turquette <mturquette@baylibre.com>,
 Magnus Damm <magnus.damm@gmail.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 linux-clk <linux-clk@vger.kernel.org>,
 Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
 Rob Herring <robh+dt@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 "David S. Miller" <davem@davemloft.net>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <CAOtvUMc8D9DQFC6vZ+GnaVBg5uFVrQmOrnSQKz7ZPHGh4BCsZg@mail.gmail.com>
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

On Tue, Jun 19, 2018 at 04:57:15PM +0300, Gilad Ben-Yossef wrote:
> On Tue, Jun 19, 2018 at 3:58 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> > Hi Gilad,
> >
> > On Thu, May 24, 2018 at 4:19 PM Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> >> The patch set enables the use of CryptoCell found in some Renesas R-Car
> >> Salvator-X boards and fixes some driver issues uncovered that prevented
> >> to work properly.
> >
> > With DEBUG enabled on R-Car H3, I see lots of
> >
> >     ccree e6601000.crypto: IRR includes unknown cause bits (0x00000098)
> >     ccree e6601000.crypto: IRR includes unknown cause bits (0x000000C0)
> >     ccree e6601000.crypto: IRR includes unknown cause bits (0x000000D0)
> >     ccree e6601000.crypto: IRR includes unknown cause bits (0x000000D8)
> >     ccree e6601000.crypto: IRR includes unknown cause bits (0x000000E0)
> >     ccree e6601000.crypto: IRR includes unknown cause bits (0x000000F0)
> >     ccree e6601000.crypto: IRR includes unknown cause bits (0x000000F8)
> >
> > during boot. Is that expected?
> 
> Yes. The condition itself it is reporting is not necessarily bad. It
> means that driver
> did not act on certain HW notification during interrupts and that's
> OK, we don't act on all of them
> depending on configuration - e.g. if you have CONFIG_FIPS enabled and
> an active TEE module or not.
> 
> I can rate_limit the message if it bothers you but other than that it
> is a harmless debug print.

Rate limiting sounds like an excellent idea to me.
