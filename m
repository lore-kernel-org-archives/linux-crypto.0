From: Casey Leedom <leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: Re: DMA error when sg->offset value is greater than PAGE_SIZE in
	Intel IOMMU
Date: Tue, 26 Sep 2017 17:30:15 +0000
Message-ID: <MWHPR12MB16005396DDE5BD2DADE07233C87B0@MWHPR12MB1600.namprd12.prod.outlook.com>
References: <20170920080151.GA3348@gondor.apana.org.au>
	<26992a1e-edb3-ed78-ce8e-31e0739d75f4@arm.com>
	<MWHPR12MB160092A868C613FF64CA9EE9C87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
	<20170925155430.GB131920@otc-nc-03>
	<MWHPR12MB16004E2A92CC3FFEC6313DDBC87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
	<afa02763-4556-0e14-7d1b-1c044cdc1ff7@chelsio.com>
	<6d2af675-7b97-6eaf-4daa-d7bf80a05923@chelsio.com>,
	<437a9bd8-d4d6-22ca-1a64-1a3e73f1101a@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>,
	"linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	Michael Werner <werner-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>,
	"dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	David Woodhouse <David.Woodhouse-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
To: Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>, "Harsh  Jain" <Harsh-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>,
	"Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <437a9bd8-d4d6-22ca-1a64-1a3e73f1101a-5wv7dgnIgG8@public.gmane.org>
Content-Language: en-US
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

| From: Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>
| Sent: Tuesday, September 26, 2017 7:22 AM
|
| On 26/09/17 13:21, Harsh Jain wrote:
| > Find attached new set of log. After repeated tries it panics.
|
| Thanks, that makes things a bit clearer - looks like fixing the physical
| address/pteval calculation to not be off by a page in one direction wasn't
| helping much because the returned DMA address is actually also off by a
| page in the other direction, and thus overflowing past the allocated IOVA
| into whoever else's mapping happened to be there; complete carnage ensues.
|
| After another look through the intel_map_sg() path, here's my second (still
| completely untested) guess at a possible fix.
|
| Robin.
|
| ----->8-----
| diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
| index 6784a05dd6b2..d7f7def81613 100644
| --- a/drivers/iommu/intel-iommu.c
| +++ b/drivers/iommu/intel-iommu.c
| @@ -2254,10 +2254,12 @@ static int __domain_mapping(struct dmar_domain *doma!
|                  uint64_t tmp;
|
|                  if (!sg_res) {
| +                       size_t off = sg->offset & ~PAGE_MASK;
| +
|                          sg_res = aligned_nrpages(sg->offset, sg->length);
| -                       sg->dma_address = ((dma_addr_t)iov_pfn << VTD_PAGE_S!
| +                       sg->dma_address = ((dma_addr_t)iov_pfn << VTD_PAGE_S!
|                          sg->dma_length = sg->length;
| -                       pteval = page_to_phys(sg_page(sg)) | prot;
| +                       pteval = (page_to_phys(sg_page(sg)) + sg->offset - o!
|                          phys_pfn = pteval >> VTD_PAGE_SHIFT;
|                  }

Robin,

  Harsh was able to do an initial test of you proposed patch above and his
test setup survived for 2 minutes with iperf traffic before his PEER went
belly up.  Since his PEER isn't on a Remote Power IPMI, we'll have to wait
till tomorrow for further tests -- Harsh does have to sleep some time ...
:-) But the 2 minutes his test machine did survive were Very Promising!
 
  And I see that Raj has also sent a couple of proposed fixes now.
It's just as well that Harsh is off to bed now so we can hash things out
while he sleeps ...

Casey
