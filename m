Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE1D2CDB474
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Oct 2023 02:35:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233178AbjJWCfs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Oct 2023 22:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233161AbjJWCfr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Oct 2023 22:35:47 -0400
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E92B19E
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 19:35:44 -0700 (PDT)
Received: from [192.168.68.112] (ppp118-210-136-142.adl-adc-lon-bras33.tpg.internode.on.net [118.210.136.142])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id 6060C20135;
        Mon, 23 Oct 2023 10:35:32 +0800 (AWST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=codeconstruct.com.au; s=2022a; t=1698028538;
        bh=ksZFs0+9URFXS1sX1+Yy7wy4eAGcVDR9NHIRtCYuewg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References;
        b=ZfT0hYZYms8spw6jXbPStQQlg52hfTGVHOUFxhjEkX8uRAjguFgFbTePOydMJjQH3
         xZegnqm5re/nlXNV3nydYmNyOuJJ98OwhDwZpeUd05tVttUvLdM1wH9puv+M5ZTzU4
         h0jCXfBSPdQEuMtlQp8YFVDkEtrLhbI+01N076TRLAUdiCP6p45Srbuj59aU3zM22J
         v9XghnLtItK9P9uyrvZdXLhR3KRpeAvGidMtkW31nycd95dsoaFN6kgdk1mnyk+JFk
         AruB1hA95UfWJmbtpmk5an6ZGJkL+10Mv88di0HdNcKexlNe7erTkVVIfBUrFine7Y
         D0N0SwzetRsCg==
Message-ID: <5201a2fc9fc9bdbdc3f76e504b3a2a2d6d4d21d4.camel@codeconstruct.com.au>
Subject: Re: [PATCH 06/42] crypto: aspeed-acry - Convert to platform remove
 callback returning void
From:   Andrew Jeffery <andrew@codeconstruct.com.au>
To:     Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Neal Liu <neal_liu@aspeedtech.com>, Joel Stanley <joel@jms.id.au>,
        linux-aspeed@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Date:   Mon, 23 Oct 2023 13:05:30 +1030
In-Reply-To: <20231020075521.2121571-50-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
         <20231020075521.2121571-50-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 2023-10-20 at 09:55 +0200, Uwe Kleine-K=C3=B6nig wrote:
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is ignored (apart
> from emitting a warning) and this typically results in resource leaks.
>=20
> To improve here there is a quest to make the remove callback return
> void. In the first step of this quest all drivers are converted to
> .remove_new(), which already returns void. Eventually after all drivers
> are converted, .remove_new() will be renamed to .remove().
>=20
> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.
>=20
> Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>

Reviewed-by: Andrew Jeffery <andrew@codeconstruct.com.au>
