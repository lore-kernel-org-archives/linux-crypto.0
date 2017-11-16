From: "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] iommu/vt-d: Fix scatterlist offset handling
Date: Thu, 16 Nov 2017 13:09:33 -0800
Message-ID: <20171116210933.GA53016@otc-nc-03>
References: <644c3e01654f8bd48d669c36e424959d6ef0e27e.1506607370.git.robin.murphy@arm.com>
	<1507035334.29211.105.camel@infradead.org>
	<db8c70d7-5978-20e8-d29a-91a4312f97dd@arm.com>
	<20171006144309.GA30803@8bytes.org>
	<20171106104709.06b38f7c@jacob-builder>
	<20171115155456.141a6dc8@jacob-builder>
	<20171116143244.2583d044@t450s.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Harsh-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
To: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171116143244.2583d044-1yVPhWWZRC1BDLzU/O5InQ@public.gmane.org>
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

Hi Alex

On Thu, Nov 16, 2017 at 02:32:44PM -0700, Alex Williamson wrote:
> On Wed, 15 Nov 2017 15:54:56 -0800
> Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> 
> > Hi Alex and all,
> > 
> > Just wondering if you could merge Robin's patch for the next rc. From
> > all our testing, this seems to be a solid fix and should be included in
> > the stable releases as well.
> 
> Hi Jacob,
> 
> Sorry, this wasn't on my radar, I only scanned for patches back through
> about when Joerg refreshed his next branch (others on the list speak up
> if I didn't pickup your patches for the v4.15 merge window).
> 
> This patch makes sense to me and I'm glad you were able to work through
> the anomaly Harsh saw in testing as an unrelated issue, but...
> 
> 
> What do we do about this?  I certainly can't rip out large page support
> and put a stable tag on the patch.  I'm not really spotting what's
> wrong with large page support here, other than the comment about it
> being a mess.  Suggestions?  Thanks,
> 

Largepage seems to work and i don't think we need to rip it out. When
Harsh tested it at one point we thought disabling super-page seemed to make
the problem go away. Jacob tested and we still saw the need for Robin's patch.

Yes, the function looks humongous but i don't think we should wait for that 
before this merge.

Cheers,
Ashok
