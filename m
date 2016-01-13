From: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH] crypto: sahara: Fill the statesize field
Date: Wed, 13 Jan 2016 14:42:30 -0200
Message-ID: <CAOMZO5A2eome5yGV_K9+qOwh9ndu=n71f_Vtee0VowVq0rm40g@mail.gmail.com>
References: <1452687005-16444-1-git-send-email-festevam@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	linux-crypto@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:36688 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbcAMQmb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 Jan 2016 11:42:31 -0500
Received: by mail-ig0-f175.google.com with SMTP id z14so155133906igp.1
        for <linux-crypto@vger.kernel.org>; Wed, 13 Jan 2016 08:42:31 -0800 (PST)
In-Reply-To: <1452687005-16444-1-git-send-email-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 13, 2016 at 10:10 AM, Fabio Estevam <festevam@gmail.com> wrote:

> diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
> index f68c24a..d05d849 100644
> --- a/drivers/crypto/sahara.c
> +++ b/drivers/crypto/sahara.c
> @@ -1260,6 +1260,7 @@ static struct ahash_alg sha_v3_algs[] = {
>         .export         = sahara_sha_export,
>         .import         = sahara_sha_import,
>         .halg.digestsize        = SHA1_DIGEST_SIZE,
> +       .halg.statesize         = sizeof(struct sahara_ctx),

Or should this be sizeof(struct sha1_state) instead?

>         .halg.base      = {
>                 .cra_name               = "sha1",
>                 .cra_driver_name        = "sahara-sha1",
> @@ -1287,6 +1288,7 @@ static struct ahash_alg sha_v4_algs[] = {
>         .export         = sahara_sha_export,
>         .import         = sahara_sha_import,
>         .halg.digestsize        = SHA256_DIGEST_SIZE,
> +       .halg.statesize         = sizeof(struct sahara_ctx),

Or should this be sizeof(struct sha256_state) instead?

Thanks
