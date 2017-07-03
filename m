From: Corentin Labbe <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4] crypto: sun4i-ss: support the Security
 System PRNG
Date: Mon, 3 Jul 2017 20:31:41 +0200
Message-ID: <20170703183141.GA9516@Red>
References: <20170626122055.5253-1-clabbe.montjoie@gmail.com>
 <CAH6sp9Nm-hDxNSNNYxonBzSGyM769WoKQwjX2CN-RPRr=Oxu4g@mail.gmail.com>
Reply-To: clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org, wens-jdAy2FN1RRM@public.gmane.org,
	linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	"linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Frans Klaver <fransklaver-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-sunxi+bncBD7YLCN32UNBBGM35LFAKGQETA5V4QY-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Content-Disposition: inline
In-Reply-To: <CAH6sp9Nm-hDxNSNNYxonBzSGyM769WoKQwjX2CN-RPRr=Oxu4g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Post: <https://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/linux-sunxi
List-Subscribe: <https://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org

On Mon, Jun 26, 2017 at 02:36:43PM +0200, Frans Klaver wrote:
> Hi,
> 
> On Mon, Jun 26, 2017 at 2:20 PM, Corentin Labbe
> <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > The Security System have a PRNG, this patch add support for it via
> > crypto_rng.
> 
> s,have,has,
> s,add,adds,
> 
> >
> > Signed-off-by: Corentin Labbe <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > ---
> >
> > Changes since v3 (note: the v3 miss changes and version tag sorry)
> > - Replaced all len values with bits / BITS_PER_LONG or BITS_PER_BYTE
> >
> > Changes since v2
> >  - converted to crypto_rng
> >
> > Changes since v1:
> >  - Replaced all spin_lock_bh by simple spin_lock
> >  - Removed handling of size not modulo 4 which will never happen
> >  - Added add_random_ready_callback()
> >
> >  drivers/crypto/Kconfig                  |  8 +++++
> >  drivers/crypto/sunxi-ss/Makefile        |  1 +
> >  drivers/crypto/sunxi-ss/sun4i-ss-core.c | 30 ++++++++++++++++++
> >  drivers/crypto/sunxi-ss/sun4i-ss-prng.c | 56 +++++++++++++++++++++++++++++++++
> >  drivers/crypto/sunxi-ss/sun4i-ss.h      | 11 +++++++
> >  5 files changed, 106 insertions(+)
> >  create mode 100644 drivers/crypto/sunxi-ss/sun4i-ss-prng.c
> >
> > diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> > index ab82536d64e2..bde0b102eb70 100644
> > --- a/drivers/crypto/Kconfig
> > +++ b/drivers/crypto/Kconfig
> > @@ -618,6 +618,14 @@ config CRYPTO_DEV_SUN4I_SS
> >           To compile this driver as a module, choose M here: the module
> >           will be called sun4i-ss.
> >
> > +config CRYPTO_DEV_SUN4I_SS_PRNG
> > +       bool "Support for Allwinner Security System PRNG"
> > +       depends on CRYPTO_DEV_SUN4I_SS
> > +       select CRYPTO_RNG
> > +       help
> > +         Select this option if you to provides kernel-side support for
> > +         the Pseudo-Random Number Generator found in the Security System.
> 
> This sentence does not parse. "Select this option if you want to
> provide kernel-side for ...". Alternatively: "This option enables
> kernel-side support for ..."
> 
> Frans

Thanks, I will change it.
