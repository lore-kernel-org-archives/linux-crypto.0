From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCHv1] crypto: caam - Added property fsl, sec-era in SEC4.0 device tree binding.
Date: Tue, 12 Feb 2013 14:04:49 -0600
Message-ID: <8E12AE5C-7927-458A-B563-F7FC39143DEF@kernel.crashing.org>
References: <1358925668-10330-1-git-send-email-vakul@freescale.com>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: <linuxppc-dev@lists.ozlabs.org>,
	<devicetree-discuss@lists.ozlabs.org>,
	<linux-crypto@vger.kernel.org>
To: Vakul Garg <vakul@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:40446 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822Ab3BLUHR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Feb 2013 15:07:17 -0500
In-Reply-To: <1358925668-10330-1-git-send-email-vakul@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On Jan 23, 2013, at 1:21 AM, Vakul Garg wrote:

> This new property defines the era of the particular SEC version.
> The compatible property in device tree "crypto" node has been updated
> not to contain SEC era numbers.
> 
> Signed-off-by: Vakul Garg <vakul@freescale.com>
> ---
> Changelog:
> 	1. Marked fsl,sec-era as 'optional'.
> 
> .../devicetree/bindings/crypto/fsl-sec4.txt        |   12 +++++++++---
> 1 files changed, 9 insertions(+), 3 deletions(-)

applied to next.

I assume this supersedes http://patchwork.ozlabs.org/patch/204431/

- k
