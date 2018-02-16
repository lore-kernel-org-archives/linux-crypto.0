From: Boris Brezillon <boris.brezillon@bootlin.com>
Subject: Re: [PATCH] Update Boris Brezillon email address
Date: Fri, 16 Feb 2018 15:54:55 +0100
Message-ID: <20180216155455.36168609@bbrezillon>
References: <CGME20180216104523epcas3p1c45769e365a181963f8328237d270854@epcas3p1.samsung.com>
        <20180216104449.15546-1-boris.brezillon@bootlin.com>
        <dbe89241-4d05-d369-2894-fdc0b2d80b80@partner.samsung.com>
        <20180216121619.3edad6fb@bbrezillon>
        <4086d3a7-c79d-6906-2778-caccd647ffe6@partner.samsung.com>
        <20180216150050.6051cc26@bbrezillon>
        <138ed639-992d-2d87-4dd4-973323cdcad7@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Cyrille Pitchen <cyrille.pitchen@wedev4u.fr>,
        linux-mtd@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        Mike Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-clk@vger.kernel.org,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
To: Kamil Konieczny <k.konieczny@partner.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <138ed639-992d-2d87-4dd4-973323cdcad7@partner.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Adding back all the people that were Cc-ed on the initial email.

On Fri, 16 Feb 2018 15:18:21 +0100
Kamil Konieczny <k.konieczny@partner.samsung.com> wrote:

> On 16.02.2018 15:00, Boris Brezillon wrote:
> > On Fri, 16 Feb 2018 12:21:53 +0100
> > Kamil Konieczny <k.konieczny@partner.samsung.com> wrote:
> >   
> >> On 16.02.2018 12:16, Boris Brezillon wrote:  
> >>> On Fri, 16 Feb 2018 12:07:42 +0100
> >>> Kamil Konieczny <k.konieczny@partner.samsung.com> wrote:
> >>>     
> >>>> On 16.02.2018 11:44, Boris Brezillon wrote:    
> >>>>> Free Electrons is now Bootlin.
> >>>>>
> >>>>> Signed-off-by: Boris Brezillon <boris.brezillon@bootlin.com>
> >>>>> ---
> >>>>> Note that I'm planning to take this patch through the MTD tree.
> >>>>> ---
> >>>>>  .mailmap    |  7 ++++---
> >>>>>  MAINTAINERS | 10 +++++-----
> >>>>>  2 files changed, 9 insertions(+), 8 deletions(-)
> >>>>>
> >>>>> diff --git a/.mailmap b/.mailmap
> >>>>> index e18cab73e209..50c1d6bf36b2 100644
> >>>>> --- a/.mailmap
> >>>>> +++ b/.mailmap
> >>>>> @@ -33,9 +33,10 @@ Axel Lin <axel.lin@gmail.com>
> >>>>>  Ben Gardner <bgardner@wabtec.com>
> >>>>>  Ben M Cahill <ben.m.cahill@intel.com>
> >>>>>  Björn Steinbrink <B.Steinbrink@gmx.de>
> >>>>> -Boris Brezillon <boris.brezillon@free-electrons.com>
> >>>>> -Boris Brezillon <boris.brezillon@free-electrons.com> <b.brezillon.dev@gmail.com>
> >>>>> -Boris Brezillon <boris.brezillon@free-electrons.com> <b.brezillon@overkiz.com>
> >>>>> +Boris Brezillon <boris.brezillon@bootlin.com>
> >>>>> +Boris Brezillon <boris.brezillon@bootlin.com> <boris.brezillon@free-electrons.com>      
> >>>>
> >>>> ------------------------------------------------------------------ ??????????????????    
> >>>
> >>> Is there a problem with this line?
> >>>     
> >>
> >> I think you want to delete all 'free-electrons', yet here you add this  
> > 
> > I'm clearly not a git expert, but according to man git-shortlog [1], the
> > format I'm using here allows mailmap to replace the old email by the
> > new one, which is exactly what I want.
> > 
> > [1]https://git-scm.com/docs/git-shortlog
> >   
> 
> Ah, I see, but why do you send patch for .mailmap ?
> it is your private file, not global one, I do not want mine .mailmap
> to be replaced by yours :)

No, it's not private, it's part of the git tree.

> But beside this, you can use sed script
> 
> sed -i -e 's/free-electrons/bootlin/g' .mailmap
> 
> Please just resend this with patch for MAINTAINER's only
> 

.mailmap is versioned for a good reason, and I don't see why I couldn't
update entries for my emails, especially since those entries already
existed before this patch.

-- 
Boris Brezillon, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
http://bootlin.com
