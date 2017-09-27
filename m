From: "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: DMA error when sg->offset value is greater than PAGE_SIZE in
	Intel IOMMU
Date: Wed, 27 Sep 2017 07:48:48 -0700
Message-ID: <20170927144847.GA95654@otc-nc-03>
References: <MWHPR12MB160092A868C613FF64CA9EE9C87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
	<20170925155430.GB131920@otc-nc-03>
	<MWHPR12MB16004E2A92CC3FFEC6313DDBC87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
	<afa02763-4556-0e14-7d1b-1c044cdc1ff7@chelsio.com>
	<6d2af675-7b97-6eaf-4daa-d7bf80a05923@chelsio.com>
	<437a9bd8-d4d6-22ca-1a64-1a3e73f1101a@arm.com>
	<MWHPR12MB1600694D099E1CFAD6849A68C87B0@MWHPR12MB1600.namprd12.prod.outlook.com>
	<CAPcyv4jtYMZJ6V5VoXkGrcZ+ykWvYp1=qXrqJkjknk8Q_BVwgA@mail.gmail.com>
	<MWHPR12MB160060436AC70CB5BE8C0C6EC8780@MWHPR12MB1600.namprd12.prod.outlook.com>
	<20170927181802.3dcd7efb@m750.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: nd-5wv7dgnIgG8@public.gmane.org, Casey Leedom <leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>,
	"linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	Michael Werner <werner-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>,
	"dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Harsh Jain <Harsh-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
To: Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170927181802.3dcd7efb-h2/QxWiDqNo@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hi Robin

On Wed, Sep 27, 2017 at 06:18:02PM +0100, Robin Murphy wrote:
> On Wed, 27 Sep 2017 16:31:04 +0000
> Casey Leedom <leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org> wrote:
> 
> > | From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > | Sent: Tuesday, September 26, 2017 9:10 AM
> > |   
> > | On Tue, Sep 26, 2017 at 9:06 AM, Casey Leedom <leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> > wrote: | > | From: Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>
> > | > | Sent: Tuesday, September 26, 2017 7:22 AM
> > | > |...
> > | > ...
> > | >   Regardless, it seems that you agree that there's an issue with
> > the Intel | > I/O MMU support code with regard to the legal values
> > which a (struct | > scatterlist) can take on?  I still can't find any
> > documentation for this | > and, personally, I'm a bit baffled by a
> > Page-oriented Scatter/Gather List | > representation where [Offset,
> > Offset+Length) can reside outside the Page. |
> > | Consider the case where the page represents a huge page, then an
> > | offset greater than PAGE_SIZE (up to HPAGE_SIZE) makes sense.
> > 
> >   Okay, but whatever the underlaying Page Size is, should [Offset,
> > Offset+Length) completely reside within the referenced Page?  I'm just
> > trying to understand the Invariance Conditions which are assumed by
> > all of the code which processes Scatter/gather Lists ...
> 
> From my experience, in general terms each scatterlist segment
> represents some contiguous quantity of pages, of which sg->page is the
> first, while sg->length and sg->offset describe the specific bounds of
> that segment's data. As such, the length may certainly (and frequently
> does) exceed PAGE_SIZE; for the offset, it's unlikely that the producer
> would initially construct one greater than PAGE_SIZE instead of just
> pointing sg->page further forward, but it seems reasonable for it to
> come about if some intermediate subsystem is processing an existing
> list in-place (as seems to be the case with crypto here).
> 
> My opinion is that this may be a slightly unusual case, but I would
> not consider it an illegal one. I think most DMA mapping
> implementations would handle it whether intentionally or not.

In this specific case, it appears that 

scatterwalk_ffwd()->sg_set_page()

sg_set_page(dst, sg_page(src), src->length - len, src->offset + len);

and 

static inline void sg_set_page(struct scatterlist *sg, struct page *page,
                   unsigned int len, unsigned int offset)
{
    sg_assign_page(sg, page);
    sg->offset = offset;
    sg->length = len;
}

The src->offset + len seems to be the culprit putting it past the page.
Looks like in the cases when it breaks, the offset is already towards
the end of page.. and adding the len, puts it over the limit.

When dealing with the offset > PAGE_SIZE, is the expectation you have another
additional entry for sgl? for e.g.

if sg->page = X, and offset=4092. and len = 16. Since IOMMU only understands
4K pages this last entry needs to be adjusted?

I'm not sure if the offset+len is a buffer overflow situation or just 
trips IOMMU. 

Cheers,
Ashok

the scatter gather list, should we 
