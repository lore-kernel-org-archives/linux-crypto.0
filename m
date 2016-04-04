From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH 1/4] mm: add is_highmem_addr() helper
Date: Mon, 4 Apr 2016 17:05:58 +0200
Message-ID: <20160404170558.0e3278b5@bbrezillon>
References: <1459427384-21374-1-git-send-email-boris.brezillon@free-electrons.com>
	<1459427384-21374-2-git-send-email-boris.brezillon@free-electrons.com>
	<57022253.70400@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	<linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>,
	Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	Dave Gordon <david.s.gordon-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, <linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>,
	Vinod Koul <vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	<dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Mauro Carvalho Chehab <m.chehab-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>,
	Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>,
	Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>,
	<linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	<linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>,
	Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>,
	<iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Vignesh R <vigneshr-l0cyMroinI0@public.gmane.org>
Return-path: <linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <57022253.70400-l0cyMroinI0@public.gmane.org>
Sender: linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Mon, 4 Apr 2016 13:44:11 +0530
Vignesh R <vigneshr-l0cyMroinI0@public.gmane.org> wrote:

> Hi,
> 
> On 03/31/2016 05:59 PM, Boris Brezillon wrote:
> > Add an helper to check if a virtual address is in the highmem region.
> > 
> > Signed-off-by: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
> > ---
> >  include/linux/highmem.h | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> > 
> > diff --git a/include/linux/highmem.h b/include/linux/highmem.h
> > index bb3f329..13dff37 100644
> > --- a/include/linux/highmem.h
> > +++ b/include/linux/highmem.h
> > @@ -41,6 +41,14 @@ void kmap_flush_unused(void);
> >  
> >  struct page *kmap_to_page(void *addr);
> >  
> > +static inline bool is_highmem_addr(const void *x)
> > +{
> > +	unsigned long vaddr = (unsigned long)x;
> > +
> > +	return vaddr >=  PKMAP_BASE &&
> > +	       vaddr < ((PKMAP_BASE + LAST_PKMAP) * PAGE_SIZE);
> 
> 
> Shouldn't this be:
> 		vaddr < (PKMAP_BASE + (LAST_PKMAP * PAGE_SIZE)) ?

Oops, yes indeed.

Anyway, given Russell's feedback I don't think I'm gonna follow up on
this series.

Sorry.

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
--
To unsubscribe from this list: send the line "unsubscribe linux-spi" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
