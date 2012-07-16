From: Tabi Timur-B04825 <B04825@freescale.com>
Subject: Re: [linuxppc-release] [PATCH v3 4/4] fsl-dma: use spin_lock_bh to
 instead of spin_lock_irqsave
Date: Mon, 16 Jul 2012 14:25:18 +0000
Message-ID: <5004244D.4000106@freescale.com>
References: <1342411780-29930-1-git-send-email-qiang.liu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	Vinod Koul <vinod.koul@intel.com>,
	"herbert@gondor.hengli.com.au" <herbert@gondor.hengli.com.au>,
	Dan Williams <dan.j.williams@intel.com>,
	Li Yang-R58472 <r58472@freescale.com>,
	"davem@davemloft.net" <davem@davemloft.net>
To: Liu Qiang-B32616 <B32616@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:49484
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752678Ab2GPOZY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Jul 2012 10:25:24 -0400
In-Reply-To: <1342411780-29930-1-git-send-email-qiang.liu@freescale.com>
Content-Language: en-US
Content-ID: <5765241592447A4E9A74A072F8F14E81@mgd.freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Qiang Liu wrote:
> Use spin_lock_bh to instead of spin_lock_irqsave for improving performance.

You forgot to include the evidence that performance has improved, as well 
as an explanation why it's okay to use spin_lock_bh, and why it's faster. 
  I told you to respin the patch with that information in the patch 
description.

-- 
Timur Tabi
Linux kernel developer at Freescale
