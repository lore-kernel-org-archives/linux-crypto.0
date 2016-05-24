From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] hwrng: stm32 - fix build warning
Date: Tue, 24 May 2016 10:32:34 +0200
Message-ID: <12548318.auB4PSA3KC@wuerfel>
References: <1464007448-25395-1-git-send-email-sudipm.mukherjee@gmail.com> <6297051.TAxtzW5OIB@wuerfel> <CALszF6AxXY0LK5fToFg3095+gz6xcZz8KHaYqc=o39vjpBYDmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALszF6AxXY0LK5fToFg3095+gz6xcZz8KHaYqc=o39vjpBYDmA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tuesday, May 24, 2016 9:59:41 AM CEST Maxime Coquelin wrote:
> 2016-05-23 22:35 GMT+02:00 Arnd Bergmann <arnd@arndb.de>:
> > On Monday, May 23, 2016 6:14:08 PM CEST Sudip Mukherjee wrote:
> >> diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
> >> index 92a8106..0533370 100644
> >> --- a/drivers/char/hw_random/stm32-rng.c
> >> +++ b/drivers/char/hw_random/stm32-rng.c
> >> @@ -52,7 +52,7 @@ static int stm32_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
> >>  {
> >>       struct stm32_rng_private *priv =
> >>           container_of(rng, struct stm32_rng_private, rng);
> >> -     u32 sr;
> >> +     u32 sr = 0;
> >>       int retval = 0;
> >>
> >>       pm_runtime_get_sync((struct device *) priv->rng.priv);
> >
> > Does this work as well?
> >
> > diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
> > index 92a810648bd0..5c836b0afa40 100644
> > --- a/drivers/char/hw_random/stm32-rng.c
> > +++ b/drivers/char/hw_random/stm32-rng.c
> > @@ -79,7 +79,7 @@ static int stm32_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
> >                 max -= sizeof(u32);
> >         }
> >
> > -       if (WARN_ONCE(sr & (RNG_SR_SEIS | RNG_SR_CEIS),
> > +       if (WARN_ONCE(retval > 0 && (sr & (RNG_SR_SEIS | RNG_SR_CEIS)),
> >                       "bad RNG status - %x\n", sr))
> >                 writel_relaxed(0, priv->base + RNG_SR);
> >
> > I think it would be nicer to not add a bogus initialization.
> Hmm, no sure this nicer.
> The while loop can break before retval is incremented when sr value is
> not expected (sr != RNG_SR_DRDY).
> In that case, we certainly want to print sr value.

Ah, you are right.

> Maybe the better way is just to initialize sr with status register content?

>        pm_runtime_get_sync((struct device *) priv->rng.priv);
>
>+       sr = readl_relaxed(priv->base + RNG_SR);
>        while (max > sizeof(u32)) {
>-               sr = readl_relaxed(priv->base + RNG_SR);
>                if (!sr && wait) {
>                        unsigned int timeout = RNG_TIMEOUT;


I think that introduces a bug: you really want to read the status
register on each loop iteration.

How about moving the error handling into the loop itself?

	Arnd


diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
index 92a810648bd0..fceacd809462 100644
--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -59,6 +59,10 @@ static int stm32_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 
 	while (max > sizeof(u32)) {
 		sr = readl_relaxed(priv->base + RNG_SR);
+		if (WARN_ONCE(sr & (RNG_SR_SEIS | RNG_SR_CEIS),
+			      "bad RNG status - %x\n", sr))
+			writel_relaxed(0, priv->base + RNG_SR);
+
 		if (!sr && wait) {
 			unsigned int timeout = RNG_TIMEOUT;
 
@@ -79,10 +83,6 @@ static int stm32_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 		max -= sizeof(u32);
 	}
 
-	if (WARN_ONCE(sr & (RNG_SR_SEIS | RNG_SR_CEIS),
-		      "bad RNG status - %x\n", sr))
-		writel_relaxed(0, priv->base + RNG_SR);
-
 	pm_runtime_mark_last_busy((struct device *) priv->rng.priv);
 	pm_runtime_put_sync_autosuspend((struct device *) priv->rng.priv);
 
