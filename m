From: Dan Williams <djbw@fb.com>
Subject: Re: [PATCH v7 6/8] fsl-dma: use spin_lock_bh to instead of spin_lock_irqsave
Date: Sun, 2 Sep 2012 01:41:18 -0700
Message-ID: <CAA9_cmeFamCX1u+z3fP_gxAqe83JFbY9Beqpqgb-PjRoJ8BrWA@mail.gmail.com>
References: <1344500582-11110-1-git-send-email-qiang.liu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, vinod.koul@intel.com,
	kim.phillips@freescale.com, herbert@gondor.hengli.com.au,
	davem@davemloft.net, arnd@arndb.de, gregkh@linuxfoundation.org,
	Li Yang <leoli@freescale.com>, Timur Tabi <timur@freescale.com>
To: qiang.liu@freescale.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35379 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab2IBIlT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 2 Sep 2012 04:41:19 -0400
In-Reply-To: <1344500582-11110-1-git-send-email-qiang.liu@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 9, 2012 at 1:23 AM,  <qiang.liu@freescale.com> wrote:
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

It seems you are coordinating fsl-dma copy and talitos xor operations.
 It looks like fsl-dma will be called through
talitos_process_pending()->dma_run_dependencies(), which is
potentially called in hard irq context.

This all comes back to the need to fix raid offload to manage the
channels explicitly rather than the current dependency chains.

--
Dan
