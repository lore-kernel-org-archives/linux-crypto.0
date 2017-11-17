From: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] iommu/vt-d: Fix scatterlist offset handling
Date: Fri, 17 Nov 2017 10:09:23 -0800
Message-ID: <20171117100923.4d9175b5@jacob-builder>
References: <644c3e01654f8bd48d669c36e424959d6ef0e27e.1506607370.git.robin.murphy@arm.com>
	<1507035334.29211.105.camel@infradead.org>
	<db8c70d7-5978-20e8-d29a-91a4312f97dd@arm.com>
	<20171006144309.GA30803@8bytes.org>
	<20171106104709.06b38f7c@jacob-builder>
	<20171115155456.141a6dc8@jacob-builder>
	<20171116143244.2583d044@t450s.home>
	<20171116210933.GA53016@otc-nc-03>
	<20171117091814.6673aecf@t450s.home>
	<20171117154833.GA56337@otc-nc-03>
	<SN1PR12MB035214EF471935B6F4220E36C82F0@SN1PR12MB0352.namprd12.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>,
	Atul Gupta <atul.gupta-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>,
	"linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Harsh Jain <Harsh-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>,
	"herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org" <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
To: Casey Leedom <leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <SN1PR12MB035214EF471935B6F4220E36C82F0-z7L1TMIYDg4e2a8M8f4RFAdYzm3356FpvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
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

On Fri, 17 Nov 2017 17:44:57 +0000
Casey Leedom <leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org> wrote:

> | From: Raj, Ashok <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> | Sent: Friday, November 17, 2017 7:48 AM
> | 
> | Reported by: Harsh <harsh-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> | Reviewed by: Ashok Raj <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> | Tested by: Jacob Pan <jacob.jun.pan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Thanks everyone!  I've updated our internal bug on this issue
> and noted that we need to track down the remaining problems
> which may be in our own code.
> 
All sounds good to me, let me know if you need further assistance on
vt-d driver.

Jacob
> Casey
