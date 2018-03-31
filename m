From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] crypto: cavium: zip: Remove unnecessary
 parentheses
Date: Sat, 31 Mar 2018 08:17:34 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1803310816360.2373@hadrien>
References: <20180328175736.17360-1-rvarsha016@gmail.com>
 <1522260676.12357.121.camel@perches.com>
 <CAAFX7JTfWdaGra+kWBJt-GXVVO601K03qWnExFKFD_9vxS-03g@mail.gmail.com>
 <1522441039.2210.50.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Varsha Rao <rvarsha016@gmail.com>, linux-kernel@vger.kernel.org,
        cocci <cocci@systeme.lip6.fr>, linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
To: Joe Perches <joe@perches.com>
Return-path: <cocci-bounces@systeme.lip6.fr>
In-Reply-To: <1522441039.2210.50.camel@perches.com>
List-Unsubscribe: <https://systeme.lip6.fr/mailman/options/cocci>,
 <mailto:cocci-request@systeme.lip6.fr?subject=unsubscribe>
List-Archive: <https://systeme.lip6.fr/pipermail/cocci>
List-Post: <mailto:cocci@systeme.lip6.fr>
List-Help: <mailto:cocci-request@systeme.lip6.fr?subject=help>
List-Subscribe: <https://systeme.lip6.fr/mailman/listinfo/cocci>,
 <mailto:cocci-request@systeme.lip6.fr?subject=subscribe>
Sender: cocci-bounces@systeme.lip6.fr
Errors-To: cocci-bounces@systeme.lip6.fr
List-Id: linux-crypto.vger.kernel.org



On Fri, 30 Mar 2018, Joe Perches wrote:

> On Thu, 2018-03-29 at 21:03 +0530, Varsha Rao wrote:
> > On Wed, Mar 28, 2018 at 11:41 PM, Joe Perches wrote:
> > >
> > > On Wed, 2018-03-28 at 23:27, Varsha Rao wrote:
> > > > This patch fixes the clang warning of extraneous parentheses, with the
> > > > following coccinelle script.
> > > >
> > > > @@
> > > > identifier i;
> > > > constant c;
> > > > @@
> > > > (
> > > > -((i == c))
> > > > +i == c
> > > > >
> > > >
> > > > -((i <= c))
> > > > +i <= c
> > >
> > > Why just the "==" and "<=" cases?
> > > Why not "<", ">" and ">=" too?
> > >
> > > Why not expression instead of constant?
> >
> > Initially I had the other cases too and used expression instead of
> > constant. But the results included only "==" and "<=" cases with
> > constant. Along with one false positive case.
> hmm
> Perhaps you should use something like this?
> @@
> identifier i;
> constant c;
> @@
>
> -(
> \(i == c\|i <= c\|i < c\|i >= c\|i > c\)
> -)

This is not safe with respect to !.  The following seems to address this
problem:

@@
identifier i;
constant c;
expression e;
@@

(
!(e)
|
-(
\(i == c\|i <= c\|i < c\|i >= c\|i > c\)
-)
)

julia
