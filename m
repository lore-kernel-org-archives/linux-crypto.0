From: Casey Leedom <leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: Re: DMA error when sg->offset value is greater than PAGE_SIZE in
	Intel IOMMU
Date: Tue, 26 Sep 2017 20:50:02 +0000
Message-ID: <MWHPR12MB16007D021D7067D0E134F938C87B0@MWHPR12MB1600.namprd12.prod.outlook.com>
References: <20170920080151.GA3348@gondor.apana.org.au>
	<26992a1e-edb3-ed78-ce8e-31e0739d75f4@arm.com>
	<MWHPR12MB160092A868C613FF64CA9EE9C87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
	<20170925155430.GB131920@otc-nc-03>
	<MWHPR12MB16004E2A92CC3FFEC6313DDBC87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
	<afa02763-4556-0e14-7d1b-1c044cdc1ff7@chelsio.com>
	<6d2af675-7b97-6eaf-4daa-d7bf80a05923@chelsio.com>
	<437a9bd8-d4d6-22ca-1a64-1a3e73f1101a@arm.com>
	<20170926143441.GA136940@otc-nc-03>, <20170926144032.GA90930@otc-nc-03>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xuy <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>,
	"linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	"dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	Harsh  Jain <Harsh-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
To: "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20170926144032.GA90930@otc-nc-03>
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

  So just to be 100% sure I understand the patch you're proposing, you got
the first use of VTD_PAGE_SHIFT wrong; it should have been VTD_PAGE_MASK?  I.e.

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 6784a05..d43b566 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2254,10 +2254,13 @@ static int __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
                uint64_t tmp;

                if (!sg_res) {
+                       size_t off = sg->offset & ~VTD_PAGE_MASK;
                        sg_res = aligned_nrpages(sg->offset, sg->length);
-                       sg->dma_address = ((dma_addr_t)iov_pfn << VTD_PAGE_SHIFT) + sg->offset;
+                       sg->dma_address = ((dma_addr_t)
+                               (iov_pfn + sg->offset) << VTD_PAGE_SHIFT) + off;
                        sg->dma_length = sg->length;
-                       pteval = page_to_phys(sg_page(sg)) | prot;
+                       pteval = (page_to_phys(sg_page(sg)) +
+                               (sg->offset << VTD_PAGE_SHIFT)) | prot;
                        phys_pfn = pteval >> VTD_PAGE_SHIFT;
                }

???  And I'm still confused about this portion:

-                       sg->dma_address = ((dma_addr_t)iov_pfn << VTD_PAGE_SHIFT) + sg->offset;
+                       sg->dma_address = ((dma_addr_t)
+                               (iov_pfn + sg->offset) << VTD_PAGE_SHIFT) + off;
 
Isn't iov_pfn a Physical Page Number and we're adding a Byte Offset
to that?  I would have though that it would be more like:

    size_t page_off = sg->offset & ~VTD_PAGE_MASK;
    unsigned long pfn_off = sg->offset >> VTD_PAGE_MASK;
    ...
    sg->dma_address = ((dma_addr_t)
                       (iov_pfn + pfn_off) << VTD_PAGE_SHIFT) + page_off;

  I want to be sure that Harsh has a concrete patch to work with when he
wakes up.

  How about it Robin, Dan, David, Herbert, what do you guys think of Raj's
proposed patch?

Casey
