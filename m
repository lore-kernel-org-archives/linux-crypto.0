From: Tirumala Marri <tmarri@apm.com>
Subject: RE: [PATCH 1/2] PPC4xx: Generelizing drivers/dma/ppc4xx/adma.c
Date: Fri, 24 Sep 2010 11:52:49 -0700
Message-ID: <ba171a39721d9cfd3e7c8ca8d287f485@mail.gmail.com>
References: <1284774145-14543-1-git-send-email-tmarri@apm.com>
 <4C9BB6EB.7020802@intel.com> <d2d7c3068b5582bde7529ccc65d71e52@mail.gmail.com>
 <201009240858.05018.sr@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Dan Williams <dan.j.williams@intel.com>, neilb@suse.de,
	yur@emcraft.com, linux-raid@vger.kernel.org,
	herbert@gondor.hengli.com.au, linux-crypto@vger.kernel.org
To: Stefan Roese <sr@denx.de>, linuxppc-dev@lists.ozlabs.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from exprod5og107.obsmtp.com ([64.18.0.184]:59287 "HELO
	exprod5og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752651Ab0IXSwq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Sep 2010 14:52:46 -0400
In-Reply-To: <201009240858.05018.sr@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>
> It would be really preferable to support all those platforms in a
> single Linux
> image. If technically possible, please try to move this direction.
It is do-able for couple of SoCs. Other SoC DMA engines are quite a bit
different.
Let me first do small steps first and slowly achieve some run time
Differentiation.

Thanks,
Marri
