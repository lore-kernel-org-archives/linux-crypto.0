From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH v2] crypt: bfin_crc: access crc registers by readl and writel functions
Date: Thu, 10 Apr 2014 10:01:34 +0200
Message-ID: <201404101001.34907.marex@denx.de>
References: <1397111456-17371-1-git-send-email-sonic.adi@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org,
	adi-buildroot-devel@lists.sourceforge.net,
	Sonic Zhang <sonic.zhang@analog.com>
To: Sonic Zhang <sonic.adi@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:49185 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965557AbaDJIUw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Apr 2014 04:20:52 -0400
In-Reply-To: <1397111456-17371-1-git-send-email-sonic.adi@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thursday, April 10, 2014 at 08:30:56 AM, Sonic Zhang wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
> 
> Move architecture independant crc header file out of the blackfin folder.
> 
> 
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> ---
> v2-changes:
> - avoid combine the IO accessors into each other
> - use readl/writel other than ioread32/iowrite32

Reviewed-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
