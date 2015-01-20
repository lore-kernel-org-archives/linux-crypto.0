From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: Re: [PATCH] crypto: testmgr: notify expected failures on aead tests
Date: Tue, 20 Jan 2015 09:58:58 +0200
Message-ID: <54BE0AC2.4020607@freescale.com>
References: <1421675664-26107-1-git-send-email-cristian.stoica@freescale.com>
 <20150120033549.GA10814@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
	<horia.geanta@freescale.com>, <tudor.ambarus@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0148.outbound.protection.outlook.com ([207.46.100.148]:7935
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750722AbbATH7F (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Jan 2015 02:59:05 -0500
In-Reply-To: <20150120033549.GA10814@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/20/2015 05:35 AM, Herbert Xu wrote:
> No, I'm not going to create spam in everybody's dmesg just so that
> you can make sense of the spam coming from one driver.

Indeed, I found that it makes things far worse for the rest of the
drivers and the clarity improvement is questionable.
It was a bad idea.

Cristian S.
