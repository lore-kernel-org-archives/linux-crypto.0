From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] powerpc/crypto: caam - add backward compatible string
 sec4.0
Date: Thu, 22 Mar 2012 19:15:09 -0500
Message-ID: <20120322191509.9e049a78b87a10f71bc6ebeb@freescale.com>
References: <1332310150-8274-1-git-send-email-Shengzhou.Liu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <herbert@gondor.hengli.com.au>
To: Shengzhou Liu <Shengzhou.Liu@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:36426
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031572Ab2CWAQt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Mar 2012 20:16:49 -0400
In-Reply-To: <1332310150-8274-1-git-send-email-Shengzhou.Liu@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 21 Mar 2012 14:09:10 +0800
Shengzhou Liu <Shengzhou.Liu@freescale.com> wrote:

> In some device trees of previous version, there were string "fsl,sec4.0".
> To be backward compatible with device trees, we have CAAM driver first
> check "fsl,sec-v4.0", if it fails, then check for "fsl,sec4.0".
> 
> Signed-off-by: Shengzhou Liu <Shengzhou.Liu@freescale.com>
> ---

Acked-by: Kim Phillips <kim.phillips@freescale.com>

Thanks,

Kim
