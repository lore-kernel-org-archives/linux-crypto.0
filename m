From: Timur Tabi <b04825@freescale.com>
Subject: Re: [linuxppc-release] [PATCH v3 4/4] fsl-dma: use spin_lock_bh to
 instead of spin_lock_irqsave
Date: Tue, 17 Jul 2012 10:29:11 -0500
Message-ID: <500584C7.8080501@freescale.com>
References: <1342411780-29930-1-git-send-email-qiang.liu@freescale.com> <5004244D.4000106@freescale.com> <BCB48C05FCE8BC4D9E61E841ECBE6DB70C2788@039-SN2MPN1-011.039d.mgd.msft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	Vinod Koul <vinod.koul@intel.com>,
	"herbert@gondor.hengli.com.au" <herbert@gondor.hengli.com.au>,
	Dan Williams <dan.j.williams@intel.com>,
	Li Yang-R58472 <r58472@freescale.com>,
	"davem@davemloft.net" <davem@davemloft.net>
To: Liu Qiang-B32616 <B32616@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:15739
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755753Ab2GQP4v (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Jul 2012 11:56:51 -0400
In-Reply-To: <BCB48C05FCE8BC4D9E61E841ECBE6DB70C2788@039-SN2MPN1-011.039d.mgd.msft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Liu Qiang-B32616 wrote:
> I attached the test result in v3 0/4, performance is improved by 2%.
> For my understanding, there is not any place to access descriptor lists
> in fsl-dma interrupt service handler except its tasklet, spin_lock_bh()
> is born for this. Interrupts will be turned off and context will be save in
> irqsave, there is needless to use irqsave in our case. You can refer to the
> implement of mv_xor.c or ioap-adma.c.
> If you think my explanation is ok, I can add it in the patch.

Yes, the explanation is ok.  Please make it part of the patch description,
so that it is saved in the git history.

-- 
Timur Tabi
Linux kernel developer at Freescale
