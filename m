From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/7] staging: ccree: remove ccree from staging tree
Date: Thu, 18 Jan 2018 10:41:32 +0100
Message-ID: <20180118094132.GB28652@kroah.com>
References: <1515662239-1714-1-git-send-email-gilad@benyossef.com>
 <1515662239-1714-2-git-send-email-gilad@benyossef.com>
 <20180113132100.GC17515@kroah.com>
 <CAOtvUMeypjMxhC0CxSf_+Pj2K5ZZGVXRzO1BtBwv7_2V_0vP-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOtvUMeypjMxhC0CxSf_+Pj2K5ZZGVXRzO1BtBwv7_2V_0vP-w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jan 18, 2018 at 10:39:11AM +0200, Gilad Ben-Yossef wrote:
> On Sat, Jan 13, 2018 at 3:21 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Thu, Jan 11, 2018 at 09:17:08AM +0000, Gilad Ben-Yossef wrote:
> >> Remove the ccree driver from the staging tree in preparation to
> >> introducing it in the crypto tree.
> >>
> >> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> >
> > Heh, no, just make a patch series that adds the driver to the correct
> > location in the crypto tree.
> >
> > If that gets accepted, we can then delete the staging driver with a
> > separate patch, after the fact.  No need for it to be in this patch
> > series.
> 
> Yes, I should have been more communicative as to why I am doing this, sorry.
> 
> The problem is that if you apply the patch adding the driver to
> drivers/crypto/ the kernel
> no longer links due to symbol name collisions.

Then as the first patch in your series, just mark the staging driver as
relying on BROKEN, and all should be fine :)

thanks,

greg k-h
