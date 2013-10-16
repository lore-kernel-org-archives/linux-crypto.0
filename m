From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: mv_cesa: remove deprecated IRQF_DISABLED
Date: Wed, 16 Oct 2013 20:57:48 +0800
Message-ID: <20131016125747.GB10906@gondor.apana.org.au>
References: <1381639753-7042-1-git-send-email-michael.opdenacker@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:33083 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934239Ab3JPM5x (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Oct 2013 08:57:53 -0400
Content-Disposition: inline
In-Reply-To: <1381639753-7042-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Oct 13, 2013 at 06:49:13AM +0200, Michael Opdenacker wrote:
> This patch proposes to remove the use of the IRQF_DISABLED flag
> 
> It's a NOOP since 2.6.35 and it will be removed one day.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
