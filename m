From: Stefan Roese <sr@denx.de>
Subject: Re: [PATCH 1/2] PPC4xx: Generelizing drivers/dma/ppc4xx/adma.c
Date: Fri, 24 Sep 2010 08:58:04 +0200
Message-ID: <201009240858.05018.sr@denx.de>
References: <1284774145-14543-1-git-send-email-tmarri@apm.com> <4C9BB6EB.7020802@intel.com> <d2d7c3068b5582bde7529ccc65d71e52@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Tirumala Marri <tmarri@apm.com>,
	Dan Williams <dan.j.williams@intel.com>, neilb@suse.de,
	yur@emcraft.com, linux-raid@vger.kernel.org,
	herbert@gondor.hengli.com.au, linux-crypto@vger.kernel.org
To: linuxppc-dev@lists.ozlabs.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:57313 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab0IXG6Q (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Sep 2010 02:58:16 -0400
In-Reply-To: <d2d7c3068b5582bde7529ccc65d71e52@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Friday 24 September 2010 00:39:47 Tirumala Marri wrote:
> > Will both versions of this driver exist in the same kernel build?  For
> > example the iop-adma driver supports iop13xx and iop3xx, but we select
> > the archtitecture at build time?  Or, as I assume in this case, will
> > the
> > two (maybe more?) ppc4xx adma drivers all be built in the same image,
> > more like ioatdma?
> 
> [Marri] We select the architecture at build time.

It would be really preferable to support all those platforms in a single Linux 
image. If technically possible, please try to move this direction.

Thanks.

Cheers,
Stefan
