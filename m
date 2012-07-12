From: Timur Tabi <b04825@freescale.com>
Subject: Re: [linuxppc-release] [PATCH v2 4/4] fsl-dma: use spin_lock_bh to
 instead of spin_lock_irqsave
Date: Thu, 12 Jul 2012 13:23:47 -0500
Message-ID: <4FFF1633.1080308@freescale.com>
References: <1341997326-18495-1-git-send-email-qiang.liu@freescale.com> <4FFD952D.8040201@freescale.com> <BCB48C05FCE8BC4D9E61E841ECBE6DB70C0987@039-SN2MPN1-011.039d.mgd.msft.net>
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
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:33324
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751112Ab2GLSXy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Jul 2012 14:23:54 -0400
In-Reply-To: <BCB48C05FCE8BC4D9E61E841ECBE6DB70C0987@039-SN2MPN1-011.039d.mgd.msft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Liu Qiang-B32616 wrote:
> I compared my test result before and after this patch, write performance can
> improved by 15%. I will send the latest patches sooner because of Ira's concern.
> I will give a complete description about the improvement of spin_lock_bh().
> 
> About your question, spin_lock_bh is used in the case of bottom/half as its
> name, there is no need to protect a running/pending list with spin_lock_irqsave.

Please respin the patch and include this information in the patch description.

-- 
Timur Tabi
Linux kernel developer at Freescale
