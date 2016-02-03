From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/3] crypto: sahara - avoid needlessly saving and
 restoring sahara_ctx
Date: Wed, 3 Feb 2016 19:22:49 +0800
Message-ID: <20160203112249.GA28003@gondor.apana.org.au>
References: <1452707524-7695-1-git-send-email-festevam@gmail.com>
 <20160125140728.GA8414@gondor.apana.org.au>
 <CAOMZO5BE49yzqpEy3TAGAyY52XR_sq6NtFa6e1fdkDAP9Xt4Ow@mail.gmail.com>
 <20160202144309.GA17909@gondor.apana.org.au>
 <CAOMZO5D-7xEhKyWhL3QDzF23ECLT+Yt=5-mc+ZRfAazZ=QfHEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Marek =?utf-8?B?VmHFoXV0?= <marex@denx.de>,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Russell King <linux@arm.linux.org.uk>,
	linux-crypto@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>
To: Fabio Estevam <festevam@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46274 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbcBCLXI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Feb 2016 06:23:08 -0500
Content-Disposition: inline
In-Reply-To: <CAOMZO5D-7xEhKyWhL3QDzF23ECLT+Yt=5-mc+ZRfAazZ=QfHEQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 02, 2016 at 03:18:47PM -0200, Fabio Estevam wrote:
> On Tue, Feb 2, 2016 at 12:43 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> 
> > Preferably you shouldn't include the mutex in the exported state
> > at all.
> 
> Ok, so would it be safe to completely remove the mutex like this?

Hmm, indeed the mutex seems to be redundant so let's just kill
it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
