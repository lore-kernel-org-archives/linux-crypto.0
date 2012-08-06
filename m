From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v6 6/8] fsl-dma: use spin_lock_bh to instead of spin_lock_irqsave
Date: Mon, 6 Aug 2012 11:57:17 +0000
Message-ID: <201208061157.17667.arnd@arndb.de>
References: <1344249361-10263-1-git-send-email-qiang.liu@freescale.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
	dan.j.williams@gmail.com, vinod.koul@intel.com,
	kim.phillips@freescale.com, herbert@gondor.hengli.com.au,
	davem@davemloft.net, gregkh@linuxfoundation.org,
	Li Yang <leoli@freescale.com>, Timur Tabi <timur@freescale.com>
To: qiang.liu@freescale.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:63001 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab2HFL5m (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Aug 2012 07:57:42 -0400
In-Reply-To: <1344249361-10263-1-git-send-email-qiang.liu@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Monday 06 August 2012, qiang.liu@freescale.com wrote:
> 
> From: Qiang Liu <qiang.liu@freescale.com>
> 
> The use of spin_lock_irqsave() is a stronger locking mechanism than is
> required throughout the driver. The minimum locking required should be
> used instead. Interrupts will be turned off and context will be saved,
> there is needless to use irqsave.
> 
> Change all instances of spin_lock_irqsave() to spin_lock_bh().
> All manipulation of protected fields is done using tasklet context or
> weaker, which makes spin_lock_bh() the correct choice.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Dan Williams <dan.j.williams@gmail.com>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Li Yang <leoli@freescale.com>
> Cc: Timur Tabi <timur@freescale.com>
> Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
> Acked-by: Ira W. Snyder <iws@ovro.caltech.edu>

Acked-by: Arnd Bergmann <arnd@arndb.de>

You could actually change the use of spin_lock_bh inside of the tasklet
function (dma_do_tasklet) do just spin_lock(), because softirqs are
already disabled there, but your version is also ok.
