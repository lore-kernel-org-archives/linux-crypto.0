Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38421C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 31 Jan 2022 00:20:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235063AbiAaAUv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 30 Jan 2022 19:20:51 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:60734 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233085AbiAaAUu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 30 Jan 2022 19:20:50 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nEKR0-0004h2-Ph; Mon, 31 Jan 2022 11:20:43 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 31 Jan 2022 11:20:42 +1100
Date:   Mon, 31 Jan 2022 11:20:42 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     Fabio Estevam <festevam@gmail.com>,
        Andrei Botila <andrei.botila@nxp.com>,
        "andrew.smirnov@gmail.com" <andrew.smirnov@gmail.com>,
        "fredrik.yhlen@endian.se" <fredrik.yhlen@endian.se>,
        "hs@denx.de" <hs@denx.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Fabio Estevam <festevam@denx.de>
Subject: Re: [PATCH] crypto: caam - enable prediction resistance conditionally
Message-ID: <YfcrWnCS/8XHfzhs@gondor.apana.org.au>
References: <20220111124104.2379295-1-festevam@gmail.com>
 <YfOL3Yxvb5srGKp4@gondor.apana.org.au>
 <ee43a9f9-3746-a48d-5615-b9f4166eaa46@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ee43a9f9-3746-a48d-5615-b9f4166eaa46@nxp.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jan 28, 2022 at 09:44:09AM +0200, Horia Geantă wrote:
>
> Herbert, could you please revert this patch?

OK I will revert this.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
