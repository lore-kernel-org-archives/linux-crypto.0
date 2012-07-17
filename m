From: Li Yang <leoli@freescale.com>
Subject: Re: [PATCH v3 3/4] fsl-dma: change release process of dma descriptor
 for supporting async_tx
Date: Tue, 17 Jul 2012 11:36:41 +0800
Message-ID: <CADRPPNS-cOwCTVYnjq==W-f1-AAWctyOFg_6bkSDZPtM8Jf+Lw@mail.gmail.com>
References: <1342411709-29895-1-git-send-email-qiang.liu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	"Ira W. Snyder" <iws@ovro.caltech.edu>,
	Vinod Koul <vinod.koul@intel.com>,
	herbert@gondor.hengli.com.au,
	Dan Williams <dan.j.williams@intel.com>, davem@davemloft.net
To: Qiang Liu <qiang.liu@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:47783 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab2GQDgm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Jul 2012 23:36:42 -0400
Received: by gglu4 with SMTP id u4so5745565ggl.19
        for <linux-crypto@vger.kernel.org>; Mon, 16 Jul 2012 20:36:41 -0700 (PDT)
In-Reply-To: <1342411709-29895-1-git-send-email-qiang.liu@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 16, 2012 at 12:08 PM, Qiang Liu <qiang.liu@freescale.com> wrote:
> Fix the potential risk when enable config NET_DMA and ASYNC_TX.
> Async_tx is lack of support in current release process of dma descriptor,
> all descriptors will be released whatever is acked or no-acked by async_tx,
> so there is a potential race condition when dma engine is uesd by others
> clients (e.g. when enable NET_DMA to offload TCP).
>
> In our case, a race condition which is raised when use both of talitos
> and dmaengine to offload xor is because napi scheduler will sync all
> pending requests in dma channels, it affects the process of raid operations
> due to ack_tx is not checked in fsl dma. The no-acked descriptor is freed
> which is submitted just now, as a dependent tx, this freed descriptor trigger
> BUG_ON(async_tx_test_ack(depend_tx)) in async_tx_submit().
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Li Yang <leoli@freescale.com>
> Cc: Ira W. Snyder <iws@ovro.caltech.edu>
> Signed-off-by: Qiang Liu <qiang.liu@freescale.com>

Also separate the function ordering change and real code change into
different patches when you work on the next patch set.

- Leo
