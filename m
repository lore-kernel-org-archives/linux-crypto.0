From: Harsh Jain <Harsh-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: Re: DMA error when sg->offset value is greater than PAGE_SIZE in
	Intel IOMMU
Date: Thu, 28 Sep 2017 19:08:21 +0530
Message-ID: <26d68681-a157-26d3-84cb-6684dcaf3135@chelsio.com>
References: <MWHPR12MB160092A868C613FF64CA9EE9C87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
	<20170925155430.GB131920@otc-nc-03>
	<MWHPR12MB16004E2A92CC3FFEC6313DDBC87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
	<afa02763-4556-0e14-7d1b-1c044cdc1ff7@chelsio.com>
	<6d2af675-7b97-6eaf-4daa-d7bf80a05923@chelsio.com>
	<437a9bd8-d4d6-22ca-1a64-1a3e73f1101a@arm.com>
	<MWHPR12MB1600694D099E1CFAD6849A68C87B0@MWHPR12MB1600.namprd12.prod.outlook.com>
	<CAPcyv4jtYMZJ6V5VoXkGrcZ+ykWvYp1=qXrqJkjknk8Q_BVwgA@mail.gmail.com>
	<MWHPR12MB160060436AC70CB5BE8C0C6EC8780@MWHPR12MB1600.namprd12.prod.outlook.com>
	<20170927181802.3dcd7efb@m750.lan> <20170927144847.GA95654@otc-nc-03>
	<MWHPR12MB16005D59D7A33F3D5BE43395C8780@MWHPR12MB1600.namprd12.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "nd-5wv7dgnIgG8@public.gmane.org" <nd-5wv7dgnIgG8@public.gmane.org>, Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>,
	"linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	Michael Werner <werner-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>,
	"dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
To: Casey Leedom <leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <MWHPR12MB16005D59D7A33F3D5BE43395C8780-Gy0DoCVfaSVsWITs4OkDoAdYzm3356FpvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
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



On 28-09-2017 02:59, Casey Leedom wrote:
> Hey Raj,
>
>   Let us know if you need help in gathering more debugging information.  For
> the time being we've decided to ERRATA the use of the Intel I/O MMU with
> IPsec till we Root Cause the issue.  But this is still at the top of Harsh's
> bug list.
>  
>   With Robin's comments, I'm almost sure that the:
>
>     (iov_pfn + sg->offset) << VTD_PAGE_SHIFT)
>
> in your suggested patch is an issue.  iov_pfn is a Page Frame Number and
> sg->offset is a Byte Offset.  It feels like this should be:
>
>     size_t page_off = sg->offset & ~VTD_PAGE_MASK;
>     unsigned long pfn_off = sg->offset >> VTD_PAGE_MASK;
>     ...
>     sg->dma_address = ((dma_addr_t)
>                        (iov_pfn + pfn_off) << VTD_PAGE_SHIFT) + page_off;
>
> When Harsh tried your original patch, Harsh' test system wouldn't even boot.
Today I tried with "Intel_iommu=sp_off" boot option. Traffic runs without any error for more than 1 hrs. What magic this option did? :)
>
> Casey
