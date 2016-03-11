From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 3/3] crypto: add basic driver for the MXC SCC
Date: Fri, 11 Mar 2016 21:16:40 +0800
Message-ID: <20160311131640.GA23963@gondor.apana.org.au>
References: <1457352005-17457-1-git-send-email-s.trumtrar@pengutronix.de>
 <1457352005-17457-3-git-send-email-s.trumtrar@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Shawn Guo <shawnguo@kernel.org>, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	kernel@pengutronix.de
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54457 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbcCKNRH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Mar 2016 08:17:07 -0500
Content-Disposition: inline
In-Reply-To: <1457352005-17457-3-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 07, 2016 at 01:00:05PM +0100, Steffen Trumtrar wrote:
>
> +	if (ctx->ctrl & SCC_SCM_CTRL_CBC_MODE && req->info)
> +		memcpy(scc->base + SCC_SCM_INIT_VECTOR_0, req->info,
> +		       scc->block_size_bytes);

Please ensure that the IV is copied back on exit.  I know many
other drivers currently also don't do this but I'm trying to fix
this so I'd rather not add more work for myself down the track :)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
