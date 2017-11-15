From: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] iommu/vt-d: Fix scatterlist offset handling
Date: Wed, 15 Nov 2017 15:54:56 -0800
Message-ID: <20171115155456.141a6dc8@jacob-builder>
References: <644c3e01654f8bd48d669c36e424959d6ef0e27e.1506607370.git.robin.murphy@arm.com>
	<1507035334.29211.105.camel@infradead.org>
	<db8c70d7-5978-20e8-d29a-91a4312f97dd@arm.com>
	<20171006144309.GA30803@8bytes.org>
	<20171106104709.06b38f7c@jacob-builder>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org,
	David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harsh-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
To: Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Alex Williamson
	<alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20171106104709.06b38f7c@jacob-builder>
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

Hi Alex and all,

Just wondering if you could merge Robin's patch for the next rc. From
all our testing, this seems to be a solid fix and should be included in
the stable releases as well.

Thanks,

Jacob

On Mon, 6 Nov 2017 10:47:09 -0800
Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:

> On Fri, 6 Oct 2017 16:43:09 +0200
> Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org> wrote:
> 
> > On Tue, Oct 03, 2017 at 07:05:17PM +0100, Robin Murphy wrote:  
> > > Now, there are indeed plenty of drivers and subsystems which do
> > > work on lists of explicitly single pages - anything doing some
> > > variant of "addr = kmap_atomic(sg_page(sg)) + sg->offset;" is easy
> > > to spot - but I don't think DMA API implementations are in a
> > > position to make any kind of assumption; nearly all of them just
> > > shut up and handle sg->length bytes from sg_phys(sg) without
> > > questioning the caller, and I reckon that's exactly what they
> > > should be doing.    
> > 
> > I agree with that, it is not explicitly forbidden to have an
> > sg->offset > PAGE_SIZE and most IOMMU drivers handle this case.
> > 
> > So this is a problem I'd like to see resolved in the VT-d driver
> > too. If nobody comes up with a correct fix soon I'll apply this one
> > and rip out the large-page support from __domain_mapping() to make
> > it work.
> >   
> Hi All,
> 
> Just to give an update on the offline debugging of this issue. With
> Robin's patch applied, I was able to reproduce the failure with
> similar configuration that Jain helped to set up.
> 
> I added trace prints just to see the map/unmap activities leading to
> the DMAR fault. When fault occurs, the trace shows there is an unmap
> to the offending iova pfn. So I think this is a separate problem than
> Robin's patch is fixing. I think we should move forward to merge this
> patch upstream and stable. The remaining problem is likely a race
> condition between unmap and DMA activities.
> 
> Here a brief extracted log, ee3d7 is the iova pfn in question.
> #1. map sg pfn ee3d7
>           <idle>-0     [076] 74124.154254: bprint:
> __domain_mapping: vpfn:ee3d7, pgoff=2126, np:1, da:ee3d784e,
> len:1464 ,
> ppfn:1849c9c                                                                                                                        
> 
> #2. unmap ee3d7000
>          <idle>-0     [054] 74124.154301: bprint:
> intel_unmap: Device 0000:18:00.4 unmapping: pfn ee3d7-ee3d7
> <idle>-0     [076] 74124.154301: bprint:
> __domain_mapping: lvlpg:1, nrpg 0, vpfn:ec2ff, ppfn:183221a, sg_res:0
> <idle>-0     [059] 74124.154302: bprint:
> __domain_mapping: lvlpg:1, nrpg 0, vpfn:ee719, ppfn:c3e4dd, sg_res:0
> <idle>-0     [076] 74124.154302: bprint:
> __domain_mapping: vpfn:f183b, pgoff=78, np:1, da:f183b04e, len:1464, 
> 
> #3. DMA to unmapped address ee3d7000, DMAR fault raised.
>   +2.952861] dmar_fault: 6 callbacks
> suppressed +0.000002] DMAR: DRHD: handling fault status reg
> 2 +0.005588] turning tracing
> off +0.003592] DMAR: [DMA Write] Request device [18:00.4] fault addr
> ee3d7000 [fault reason 05] PTE Write access is not set 
>                                                                                                                                                                                                                                                                
>          <idle>-0     [000] 74124.156906: bputs:
>          0xffffffffb259916bs: turning tracing off     
> 
> 
> Thanks,
> 
> Jacob
> 
> > Speaking of __domain_mapping(), this function is a big
> > unmaintainable mess which should be split and rewritten. A clean
> > and maintainable rewrite can alse re-add the large-page support.
> > 
> > 
> > Regards,
> > 
> > 	Joerg
> > 
> > _______________________________________________
> > iommu mailing list
> > iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
> > https://lists.linuxfoundation.org/mailman/listinfo/iommu  
> 
> [Jacob Pan]

[Jacob Pan]
