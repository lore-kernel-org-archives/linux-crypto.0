From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [Cocci] [PATCH] crypto: cavium: zip: Remove unnecessary
 parentheses
Date: Sat, 31 Mar 2018 10:55:44 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1803311054580.2373@hadrien>
References: <20180328175736.17360-1-rvarsha016@gmail.com> <1522260676.12357.121.camel@perches.com> <CAAFX7JTfWdaGra+kWBJt-GXVVO601K03qWnExFKFD_9vxS-03g@mail.gmail.com> <alpine.DEB.2.20.1803310817420.2373@hadrien>
 <CAAFX7JTEK5NyvKmYoC6b4tSv9a7Gv1WHONmp4nXxnuz8rqOmxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Joe Perches <joe@perches.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, cocci <cocci@systeme.lip6.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
To: Varsha Rao <rvarsha016@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAAFX7JTEK5NyvKmYoC6b4tSv9a7Gv1WHONmp4nXxnuz8rqOmxw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On Sat, 31 Mar 2018, Varsha Rao wrote:

> On Sat, Mar 31, 2018 at 11:48 AM, Julia Lawall  wrote:
> > On Thu, 29 Mar 2018, Varsha Rao wrote:
> >
> >> On Wed, Mar 28, 2018 at 11:41 PM, Joe Perches wrote:
> >> >
> >> > On Wed, 2018-03-28 at 23:27, Varsha Rao wrote:
> >> > > This patch fixes the clang warning of extraneous parentheses, with the
> >> > > following coccinelle script.
> >> > >
> >> > > @@
> >> > > identifier i;
> >> > > constant c;
> >> > > @@
> >> > > (
> >> > > -((i == c))
> >> > > +i == c
> >> > > >
> >> > >
> >> > > -((i <= c))
> >> > > +i <= c
> >> >
> >> > Why just the "==" and "<=" cases?
> >> > Why not "<", ">" and ">=" too?
> >> >
> >> > Why not expression instead of constant?
> >>
> >> Initially I had the other cases too and used expression instead of
> >> constant. But the results included only "==" and "<=" cases with
> >> constant. Along with one false positive case.
> >>
> >> --- a/drivers/crypto/cavium/zip/zip_main.c
> >> +++ b/drivers/crypto/cavium/zip/zip_main.c
> >> @@ -99,7 +99,7 @@ static struct zip_device *zip_alloc_devi
> >>   */
> >>  struct zip_device *zip_get_device(int node)
> >>  {
> >> -    if ((node < MAX_ZIP_DEVICES) && (node >= 0))
> >> +    if (node < MAX_ZIP_DEVICES && node >= 0)
> >
> > Why is it a false positive?
>
> The parentheses around multiple expressions in if statement is not
> considered extra, right?

< and >= should bind tighter than &&.  But perhaps one could fine the
original code to be more readable.

julia
