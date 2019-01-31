Return-Path: <SRS0=09LE=QH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC399C169C4
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Jan 2019 12:06:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95E602086C
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Jan 2019 12:06:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbfAaMGN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Jan 2019 07:06:13 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:50778 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbfAaMGN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Jan 2019 07:06:13 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gpB6V-0004wT-In; Thu, 31 Jan 2019 20:05:59 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gpB6E-0003hY-L5; Thu, 31 Jan 2019 20:05:42 +0800
Date:   Thu, 31 Jan 2019 20:05:42 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jens Wiklander <jens.wiklander@linaro.org>
Cc:     Matt Mackall <mpm@selenic.com>, Olof Johansson <olof@lixom.net>,
        arnd@arndb.de, Sumit Garg <sumit.garg@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com,
        michal.lkml@markovi.net, robh+dt@kernel.org, mark.rutland@arm.com,
        daniel.thompson@linaro.org, ard.biesheuvel@linaro.org,
        bhsharma@redhat.com, tee-dev@lists.linaro.org
Subject: Re: [PATCH v6 0/4] Introduce TEE bus driver framework
Message-ID: <20190131120542.g7wtnhzuz5nuqbcc@gondor.apana.org.au>
References: <1548740978-28495-1-git-send-email-sumit.garg@linaro.org>
 <20190131084142.GA21196@jax.urgonet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190131084142.GA21196@jax.urgonet>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 31, 2019 at 09:41:43AM +0100, Jens Wiklander wrote:
>
> I think this patch series is good now. It has received comments which
> has been addressed and have also gathered a few R-B tags.
> 
> All patches but "hwrng: add OP-TEE based rng driver" covers what I
> normally send pull requests to arm-soc for.
> 
> Matt, Herbert, are you fine with the patch
> "hwrng: add OP-TEE based rng driver"?
> If so, is it also OK if I take it via my tree which I then will include
> in a pull request to arm-soc? An Acked-By tag would be nice to have.

Sure you can add my ack-by:

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
