From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: DMA error when sg->offset value is greater than PAGE_SIZE in
	Intel IOMMU
Date: Thu, 28 Sep 2017 18:33:12 +0800
Message-ID: <20170928103312.GB8118@gondor.apana.org.au>
References: <6d2af675-7b97-6eaf-4daa-d7bf80a05923@chelsio.com>
	<437a9bd8-d4d6-22ca-1a64-1a3e73f1101a@arm.com>
	<MWHPR12MB1600694D099E1CFAD6849A68C87B0@MWHPR12MB1600.namprd12.prod.outlook.com>
	<CAPcyv4jtYMZJ6V5VoXkGrcZ+ykWvYp1=qXrqJkjknk8Q_BVwgA@mail.gmail.com>
	<MWHPR12MB160060436AC70CB5BE8C0C6EC8780@MWHPR12MB1600.namprd12.prod.outlook.com>
	<20170927181802.3dcd7efb@m750.lan>
	<20170927144847.GA95654@otc-nc-03>
	<MWHPR12MB16005D59D7A33F3D5BE43395C8780@MWHPR12MB1600.namprd12.prod.outlook.com>
	<20170927190745.GA96373@otc-nc-03>
	<MWHPR12MB16007E5363E79173C52BFA19C8780@MWHPR12MB1600.namprd12.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "nd-5wv7dgnIgG8@public.gmane.org" <nd-5wv7dgnIgG8@public.gmane.org>, "dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	"linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>,
	"linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	Michael Werner <werner-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Harsh Jain <Harsh-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
To: Casey Leedom <leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <MWHPR12MB16007E5363E79173C52BFA19C8780-Gy0DoCVfaSVsWITs4OkDoAdYzm3356FpvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
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

On Wed, Sep 27, 2017 at 10:13:04PM +0000, Casey Leedom wrote:
> | From: Raj, Ashok <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> | Sent: Wednesday, September 27, 2017 12:07 PM
> |
> | looking at the debug output i got from Harsh it still looks like a bug in
> | the code.
> |
> | [  538.284589] __domain_mapping nr_pages 0x1
> | [ 538.284600] __domain_mapping sg_res 0x1 sg->dma_address 0xf291000e dma len
> | 0x38 pteval 0x3cbce3003 phys_pfn 0x3cbce3
> | [ 538.284604] chelsio driver - offset 4110 len 56 dma addr f291000e dma len
> | 56
> | [  538.284667] DMAR: DRHD: handling fault status reg 2
> | [ 538.290017] DMAR: [DMA Write] Request device [02:00.4] fault addr f2910000
> | [fault reason 05] PTE Write access is not set
> |
> | somehow when crypto_authenc_encrypt() -> scatterwalk_ffwd()-> sg_set_page()
> |
> | ->sg_set_page(dst, sg_page(src), src->length - len, src->offset + len);
> |
> | src->offset + len gets set as sg->offset in sg_set_page(). Either the
> | assumption that there should be room is incorrect, or some higher order
> | crypto
> | code that ends up setting the offset did the wrong calculation.
> |
> | if src->offset is already towards the end of the page, then offset+len will
> | go beyond the end of page.
> 
>   Hhmmm, it seems like we need Herbert to comment on this.
> 
>   Herbert, is there any specific debugging information that you'd like to
> see here?

OK I was mistaken.  While SG lists can contain entries that are
larger than PAGE_SIZE, there is no reason why scatterwalk_ffwd
should gratuitously insert a page_offset that is greater than
PAGE_SIZE.

Harsh, can you please submit your original patch with a sign-off?

Thanks,
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
