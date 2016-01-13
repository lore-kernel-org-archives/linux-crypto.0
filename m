From: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH] crypto: sahara: Fill the statesize field
Date: Wed, 13 Jan 2016 15:24:20 -0200
Message-ID: <CAOMZO5BUg9U61XUSFqnndjvuei2wGzuvK43FTVG_tTpYk6Kshg@mail.gmail.com>
References: <1452687005-16444-1-git-send-email-festevam@gmail.com>
	<CAOMZO5A2eome5yGV_K9+qOwh9ndu=n71f_Vtee0VowVq0rm40g@mail.gmail.com>
	<569682C3.8020408@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	linux-crypto@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:35735 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114AbcAMRYU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 Jan 2016 12:24:20 -0500
Received: by mail-ig0-f177.google.com with SMTP id t15so150763993igr.0
        for <linux-crypto@vger.kernel.org>; Wed, 13 Jan 2016 09:24:20 -0800 (PST)
In-Reply-To: <569682C3.8020408@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 13, 2016 at 3:00 PM, Tom Lendacky <thomas.lendacky@amd.com> wrote:

> It should actually be the size of the data that your import and export
> routines copy. Looking at those it should be sizeof(struct sahara_ctx) +
> sizeof(struct sahara_sha_reqctx).
>
> Should the struct sahara_ctx be part of the import and export data,
> though?

Thanks, Tom. Will send a v2.
