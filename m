From: Timur Tabi <timur@freescale.com>
Subject: Re: [linuxppc-release] [PATCH v2 4/4] fsl-dma: use spin_lock_bh to
 instead of spin_lock_irqsave
Date: Wed, 11 Jul 2012 10:01:01 -0500
Message-ID: <4FFD952D.8040201@freescale.com>
References: <1341997326-18495-1-git-send-email-qiang.liu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
	Vinod Koul <vinod.koul@intel.com>,
	<herbert@gondor.hengli.com.au>,
	Dan Williams <dan.j.williams@intel.com>,
	Li Yang <leoli@freescale.com>, <davem@davemloft.net>
To: Qiang Liu <qiang.liu@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:31656
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755172Ab2GKPBI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Jul 2012 11:01:08 -0400
In-Reply-To: <1341997326-18495-1-git-send-email-qiang.liu@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Qiang Liu wrote:
> Use spin_lock_bh to instead of spin_lock_irqsave for improving performance.

Please provide some evidence that performance has improved, as well as an
explanation why it's okay to use spin_lock_bh, and why it's faster.

-- 
Timur Tabi
Linux kernel developer at Freescale
