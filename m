From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: DMA error when sg->offset value is greater than PAGE_SIZE in
	Intel IOMMU
Date: Mon, 25 Sep 2017 13:11:04 -0700
Message-ID: <CAPcyv4ihhJM5+iHTMzH2m5n7X5347MHkj0h2DC5KGobjby5nmg@mail.gmail.com>
References: <20170920080151.GA3348@gondor.apana.org.au>
	<26992a1e-edb3-ed78-ce8e-31e0739d75f4@arm.com>
	<MWHPR12MB160092A868C613FF64CA9EE9C87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
	<CAPcyv4j3J41eY2eR07nTvo75F0yCbL9bNHM8GmXEFOHDQUuf8Q@mail.gmail.com>
	<MWHPR12MB1600948B2F57696189FC7C22C87A0@MWHPR12MB1600.namprd12.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	"linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>,
	"linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Harsh Jain <Harsh-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, David Woodhouse <David.Woodhouse-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
To: Casey Leedom <leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <MWHPR12MB1600948B2F57696189FC7C22C87A0-Gy0DoCVfaSVsWITs4OkDoAdYzm3356FpvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
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

On Mon, Sep 25, 2017 at 1:05 PM, Casey Leedom <leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org> wrote:
> | From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> | Sent: Monday, September 25, 2017 12:31 PM
> | ...
> | IIUC it looks like this has been broken ever since commit e1605495c716
> | "intel-iommu: Introduce domain_sg_mapping() to speed up
> | intel_map_sg()". I.e. it looks like the calculation for pte_val should
> | be:
> |
> |     pteval = (page_to_phys(sg_page(sg)) + sg->offset) | prot;
>
> Hhmmm, shouldn't that be:
>
>     pteval = (page_to_phys(sg_page(sg)) + (sg->offset>>PAGE_SHIFT)) | prot;

Yes, I think you're right. We do want to mask off the page-unaligned
portion of sg->offset.
