From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] crypto: cavium: zip: Remove unnecessary parentheses
Date: Fri, 30 Mar 2018 13:17:19 -0700
Message-ID: <1522441039.2210.50.camel@perches.com>
References: <20180328175736.17360-1-rvarsha016@gmail.com>
         <1522260676.12357.121.camel@perches.com>
         <CAAFX7JTfWdaGra+kWBJt-GXVVO601K03qWnExFKFD_9vxS-03g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        cocci <cocci@systeme.lip6.fr>
To: Varsha Rao <rvarsha016@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAAFX7JTfWdaGra+kWBJt-GXVVO601K03qWnExFKFD_9vxS-03g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, 2018-03-29 at 21:03 +0530, Varsha Rao wrote:
> On Wed, Mar 28, 2018 at 11:41 PM, Joe Perches wrote:
> > 
> > On Wed, 2018-03-28 at 23:27, Varsha Rao wrote:
> > > This patch fixes the clang warning of extraneous parentheses, with the
> > > following coccinelle script.
> > > 
> > > @@
> > > identifier i;
> > > constant c;
> > > @@
> > > (
> > > -((i == c))
> > > +i == c
> > > > 
> > > 
> > > -((i <= c))
> > > +i <= c
> > 
> > Why just the "==" and "<=" cases?
> > Why not "<", ">" and ">=" too?
> > 
> > Why not expression instead of constant?
> 
> Initially I had the other cases too and used expression instead of
> constant. But the results included only "==" and "<=" cases with
> constant. Along with one false positive case.
hmm
Perhaps you should use something like this?
@@
identifier i;
constant c;
@@

-(
\(i == c\|i <= c\|i < c\|i >= c\|i > c\)
-)
