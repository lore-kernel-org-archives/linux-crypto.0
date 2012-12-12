From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH] Revert "crypto: caam - Updated SEC-4.0 device tree binding for ERA information."
Date: Wed, 12 Dec 2012 15:29:58 -0600
Message-ID: <C38A27FC-51EF-44F3-8474-33162DE1A272@kernel.crashing.org>
References: <1354870649-3656-1-git-send-email-vakul@freescale.com>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <linuxppc-dev@ozlabs.org>,
	<devicetree-discuss@lists.ozlabs.org>
To: Vakul Garg <vakul@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:39536 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754989Ab2LLVap (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Dec 2012 16:30:45 -0500
In-Reply-To: <1354870649-3656-1-git-send-email-vakul@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On Dec 7, 2012, at 2:57 AM, Vakul Garg wrote:

> This reverts commit a2c0911c09190125f52c9941b9d187f601c2f7be.
> 
> Signed-off-by: Vakul Garg <vakul@freescale.com>
> ---
> Instead of adding SEC era information in crypto node's compatible, a new
> property 'fsl,sec-era' is being introduced into crypto node.
> 
> .../devicetree/bindings/crypto/fsl-sec4.txt        |    5 ++---
> 1 files changed, 2 insertions(+), 3 deletions(-)

What tree do you think this has been applied to?

- k
