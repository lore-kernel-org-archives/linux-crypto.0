From: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH 0/5] Use dma_pool_zalloc
Date: Tue, 3 May 2016 12:25:34 +0530
Message-ID: <20160503065533.GO2274@localhost>
References: <1461960552-7429-1-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	=?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
	linux-kernel@vger.kernel.org,
	Dan Williams <dan.j.williams@intel.com>,
	dmaengine@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
To: Julia Lawall <Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1461960552-7429-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Apr 29, 2016 at 10:09:07PM +0200, Julia Lawall wrote:
> Dma_pool_zalloc combines dma_pool_alloc and memset 0.  The semantic patch
> that makes this transformation is as follows: (http://coccinelle.lip6.fr/)

Applied all dmaengine patches

-- 
~Vinod
