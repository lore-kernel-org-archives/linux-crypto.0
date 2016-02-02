From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/3] crypto: sahara - avoid needlessly saving and
 restoring sahara_ctx
Date: Tue, 2 Feb 2016 22:43:09 +0800
Message-ID: <20160202144309.GA17909@gondor.apana.org.au>
References: <1452707524-7695-1-git-send-email-festevam@gmail.com>
 <20160125140728.GA8414@gondor.apana.org.au>
 <CAOMZO5BE49yzqpEy3TAGAyY52XR_sq6NtFa6e1fdkDAP9Xt4Ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Marek =?utf-8?B?VmHFoXV0?= <marex@denx.de>,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Russell King <linux@arm.linux.org.uk>,
	linux-crypto@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>
To: Fabio Estevam <festevam@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33409 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755774AbcBBOna (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Feb 2016 09:43:30 -0500
Content-Disposition: inline
In-Reply-To: <CAOMZO5BE49yzqpEy3TAGAyY52XR_sq6NtFa6e1fdkDAP9Xt4Ow@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 02, 2016 at 11:41:56AM -0200, Fabio Estevam wrote:
>
> static int sahara_sha_import(struct ahash_request *req, const void *in)
> {
>     struct sahara_sha_reqctx *rctx = ahash_request_ctx(req);
> 
>     mutex_init(&rctx->mutex);
>     memcpy(rctx, in, sizeof(struct sahara_sha_reqctx));

Preferably you shouldn't include the mutex in the exported state
at all.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
