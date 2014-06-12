From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [patch] crypto: caam - remove duplicate FIFOST_CONT_MASK define
Date: Thu, 12 Jun 2014 18:18:12 -0500
Message-ID: <20140612181812.cbc7c9b0adfe42d74ea2f636@freescale.com>
References: <20140609151941.GN9600@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Alex Porosanu <alexandru.porosanu@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:6362
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752331AbaFLXXg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Jun 2014 19:23:36 -0400
In-Reply-To: <20140609151941.GN9600@mwanda>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 9 Jun 2014 18:19:41 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> The FIFOST_CONT_MASK define is cut and pasted twice so we can delete the
> second instance.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Kim Phillips <kim.phillips@freescale.com>

Thanks,

Kim
