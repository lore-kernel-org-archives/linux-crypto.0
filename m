Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB76FC433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Dec 2021 02:52:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234011AbhLTCwv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 19 Dec 2021 21:52:51 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:58286 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231167AbhLTCwv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 19 Dec 2021 21:52:51 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1mz8n7-0001rC-KK; Mon, 20 Dec 2021 13:52:46 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 20 Dec 2021 13:52:45 +1100
Date:   Mon, 20 Dec 2021 13:52:45 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc:     linux-crypto@vger.kernel.org, simo@redhat.com, skozina@redhat.com,
        Nicolai Stange <nstange@suse.de>
Subject: Re: [PATCH v2] crypto: jitter - add oversampling of noise source
Message-ID: <20211220025245.GA20311@gondor.apana.org.au>
References: <2573346.vuYhMxLoTh@positron.chronox.de>
 <4712718.vXUDI8C0e8@positron.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4712718.vXUDI8C0e8@positron.chronox.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Dec 19, 2021 at 05:25:32PM +0100, Stephan Müller wrote:
>
> +#include "linux/fips.h"

Shouldn't this be <linux/fips.h>?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
