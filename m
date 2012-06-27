From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] Using alloc_coherent for caam job rings
Date: Wed, 27 Jun 2012 14:34:11 -0500
Message-ID: <20120627143411.b33d3ddab40e67b511297dcd@freescale.com>
References: <1340774912-19042-1-git-send-email-bharat.bhushan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
	Bharat Bhushan <Bharat.Bhushan@freescale.com>,
	Bharat Bhushan <bharat.bhushan@freescale.com>
To: Bharat Bhushan <r65777@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:42926
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756046Ab2F0TgM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Jun 2012 15:36:12 -0400
In-Reply-To: <1340774912-19042-1-git-send-email-bharat.bhushan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 27 Jun 2012 10:58:32 +0530
Bharat Bhushan <r65777@freescale.com> wrote:

> This resolves the Linux boot crash issue when "swiotlb=force" is set
> in bootargs on systems which have memory more than 4G.

Acked-by: Kim Phillips <kim.phillips@freescale.com>

Thanks Bharat,

Kim
