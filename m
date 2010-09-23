From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v1 1/4] PPC4xx: Generalizing ADMA driver modifications
Date: Thu, 23 Sep 2010 15:38:20 -0700
Message-ID: <4C9BD6DC.3070707@intel.com>
References: <1285279839-16588-1-git-send-email-tmarri@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"yur@emcraft.com" <yur@emcraft.com>,
	"herbert@gondor.hengli.com.au" <herbert@gondor.hengli.com.au>
To: "tmarri@apm.com" <tmarri@apm.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1285279839-16588-1-git-send-email-tmarri@apm.com>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 9/23/2010 3:10 PM, tmarri@apm.com wrote:
> From: Tirumala Marri<tmarri@apm.com>
>
> This patch generalizes the existing drver/dma/ppc4xx/adma.c, so that
> common code can be shared between different similar DMA engine
> drivers in other SoCs. Also Makefile and Kconfig changed to accommodate
> PPC4XX.
>
> Signed-off-by: Tirumala R Marri<tmarri@apm.com>
> ---
> V1:
>    * No change.
> ---
>   arch/powerpc/include/asm/async_tx.h |    4 +-
>   drivers/dma/Kconfig                 |    6 +-
>   drivers/dma/Makefile                |    2 +-
>   drivers/dma/ppc4xx/Makefile         |    2 +-
>   drivers/dma/ppc4xx/adma.c           | 4437 +++--------------------------------
>   drivers/dma/ppc4xx/adma.h           |   92 +-
>   6 files changed, 354 insertions(+), 4189 deletions(-)

Did you look at this changelog before sending?  It just deletes 4000 
lines of code??

Moving and renaming code in one patch makes it very difficult to verify 
the result.  When generalizing code the first thing I want to see with a 
very quick glance at the patch(es) is that the existing implementation 
is not harmed.  One way to go about this is to first identify the 
portions of existing code that you want to reuse in your driver and the 
pieces that are truly ppc440spe specific.  Move the ppc440spe pieces to 
their own file (get this reviewed and approved by the ppc440spe 
authors).  The remaining code in adma.c will be assumed generic.  You 
can then have another patch to do a simple s/ppc440spe/ppc4xx/ in adma.c 
(no other logic changes or code movement).  Then you can introduce your 
ppc460ex unique implementation that calls into adma.c.

I don't want to see patches along the lines of "rename 
drivers/dma/ppc4xx/adma.c to drivers/dma/ppc4xx/ppc4xx-adma.c" because 
that is just redundant.  Assume that the existing generic file names are 
where the common code will lie and then add hw-implementation specific 
files to call into that base.

Another rule is that the conversion should be bisectable at every step, 
I should be able to apply each patch in the series and still have a 
functional/runnable result.

--
Dan
