From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/2] PPC4xx: Generelizing drivers/dma/ppc4xx/adma.c
Date: Thu, 23 Sep 2010 13:22:03 -0700
Message-ID: <4C9BB6EB.7020802@intel.com>
References: <1284774145-14543-1-git-send-email-tmarri@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"yur@emcraft.com" <yur@emcraft.com>,
	"herbert@gondor.hengli.com.au" <herbert@gondor.hengli.com.au>,
	"neilb@suse.de" <neilb@suse.de>
To: "tmarri@apm.com" <tmarri@apm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:17964 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502Ab0IWUWF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Sep 2010 16:22:05 -0400
In-Reply-To: <1284774145-14543-1-git-send-email-tmarri@apm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 9/17/2010 6:42 PM, tmarri@apm.com wrote:
> From: Tirumala Marri<tmarri@apm.com>
>
> This patch generalizes the existing drver/dma/ppc4xx/adma.c, so that
> common code can be shared between different similar DMA engine
> drivers in other SoCs.
>
> Signed-off-by: Tirumala R Marri<tmarri@apm.com>
> ---
>   drivers/dma/ppc4xx/adma.c        | 4370 +++-----------------------------------
>   drivers/dma/ppc4xx/adma.h        |  116 +-
>   drivers/dma/ppc4xx/ppc4xx-adma.h | 4020 +++++++++++++++++++++++++++++++++++
>   3 files changed, 4357 insertions(+), 4149 deletions(-)
>   create mode 100644 drivers/dma/ppc4xx/ppc4xx-adma.h
>

Will both versions of this driver exist in the same kernel build?  For 
example the iop-adma driver supports iop13xx and iop3xx, but we select 
the archtitecture at build time?  Or, as I assume in this case, will the 
two (maybe more?) ppc4xx adma drivers all be built in the same image, 
more like ioatdma?

In the latter case I would recommend a file structure like:

drivers/dma/ppc4xx/adma.c
drivers/dma/ppc4xx/adma_440spe.c
drivers/dma/ppc4xx/adma_460ex.c

With patches to move the chipset specific pieces to their own file. 
Minimizing the code churn in adma.c, or at least showing a progression 
of what is unique and needs to be moved.

This would be similar to how ioatdma is structured and compiles a single 
driver to cover the three major hardware revisions.

--
Dan
