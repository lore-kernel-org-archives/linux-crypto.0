From: Liu Qiang-B32616 <B32616@freescale.com>
Subject: RE: [linuxppc-release] [PATCH v2 4/4] fsl-dma: use spin_lock_bh to
 instead of spin_lock_irqsave
Date: Thu, 12 Jul 2012 09:07:08 +0000
Message-ID: <BCB48C05FCE8BC4D9E61E841ECBE6DB70C0987@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1341997326-18495-1-git-send-email-qiang.liu@freescale.com>
 <4FFD952D.8040201@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	Vinod Koul <vinod.koul@intel.com>,
	"herbert@gondor.hengli.com.au" <herbert@gondor.hengli.com.au>,
	Dan Williams <dan.j.williams@intel.com>,
	Li Yang-R58472 <r58472@freescale.com>,
	"davem@davemloft.net" <davem@davemloft.net>
To: Tabi Timur-B04825 <B04825@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:38579
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932983Ab2GLJHQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Jul 2012 05:07:16 -0400
In-Reply-To: <4FFD952D.8040201@freescale.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> -----Original Message-----
> From: Tabi Timur-B04825
> Sent: Wednesday, July 11, 2012 11:01 PM
> To: Liu Qiang-B32616
> Cc: linux-crypto@vger.kernel.org; linuxppc-dev@lists.ozlabs.org; Vinod
> Koul; herbert@gondor.hengli.com.au; Dan Williams; Li Yang-R58472;
> davem@davemloft.net
> Subject: Re: [linuxppc-release] [PATCH v2 4/4] fsl-dma: use spin_lock_bh
> to instead of spin_lock_irqsave
> 
> Qiang Liu wrote:
> > Use spin_lock_bh to instead of spin_lock_irqsave for improving
> performance.
> 
> Please provide some evidence that performance has improved, as well as an
> explanation why it's okay to use spin_lock_bh, and why it's faster.
I compared my test result before and after this patch, write performance can
improved by 15%. I will send the latest patches sooner because of Ira's concern.
I will give a complete description about the improvement of spin_lock_bh().

About your question, spin_lock_bh is used in the case of bottom/half as its
name, there is no need to protect a running/pending list with spin_lock_irqsave.

Thanks.

> --
> Timur Tabi
> Linux kernel developer at Freescale
