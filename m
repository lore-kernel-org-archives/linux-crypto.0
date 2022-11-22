Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC9DCC43219
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Nov 2022 13:24:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233761AbiKVNYF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Nov 2022 08:24:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233175AbiKVNX7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Nov 2022 08:23:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC66F2B18F;
        Tue, 22 Nov 2022 05:23:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E07FB81B34;
        Tue, 22 Nov 2022 13:23:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CABF6C433C1;
        Tue, 22 Nov 2022 13:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669123432;
        bh=TrGdsxnKmIHui2RRQxMhxRK2ImgyiQwSaHZqW+YNmIQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MvtBuuIhZ9MXhAtyelT3qJeVn0jV6ooN4SV3AMj6P8SlruA5ifGJDiWcAITsU09gD
         neeH8ueUlV6ZkhM68xuzfizub6xLat+h1RUNo93+6auouYEa2IonTaa7GmvE+Y+Enn
         C3QTLV1JwmCBoSLlYKWDszPK+ARaaqt5Hy7RWcXPjOkUs0mek/z9G6OtoFTqdwPHb1
         aXmtvVAHyScVdRa2L2z8f8/EWQ9bmmmwd2Sp6UfwUCZIdTAmFQ742eyyk9fo6b1FeM
         hIFrK4iovn4SxlEMDtt+rB3FoOAcOcKkvPK+jSzkWH9tAiPTuZloTqDNFHfoXT8MHE
         T5OCMrBgL1S4w==
Date:   Tue, 22 Nov 2022 13:23:42 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Tudor Ambarus <tudor.ambarus@microchip.com>
Cc:     robh+dt@kernel.org, akpm@linux-foundation.org,
        herbert@gondor.apana.org.au, krzysztof.kozlowski+dt@linaro.org,
        nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
        claudiu.beznea@microchip.com, qyousef@layalina.io, arnd@arndb.de,
        atishp@atishpatra.org, anup@brainfault.org, tkhai@ya.ru,
        quic_abhinavk@quicinc.com, vasily.averin@linux.dev,
        baolin.wang@linux.alibaba.com, colin.i.king@gmail.com,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-spi@vger.kernel.org, linux-mtd@lists.infradead.org,
        pratyush@kernel.org, michael@walle.cc, miquel.raynal@bootlin.com,
        richard@nod.at
Subject: Re: [PATCH] MAINTAINERS: Update email of Tudor Ambarus
Message-ID: <Y3zNXjoraLeugNzS@sirena.org.uk>
References: <20221122125244.175295-1-tudor.ambarus@microchip.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="8Vur0n2Nqa/eczlq"
Content-Disposition: inline
In-Reply-To: <20221122125244.175295-1-tudor.ambarus@microchip.com>
X-Cookie: That's what she said.
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--8Vur0n2Nqa/eczlq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 22, 2022 at 02:52:44PM +0200, Tudor Ambarus wrote:
> My professional email will change and the microchip one will bounce after
> mid-november of 2022.

Acked-by: Mark Brown <broonie@kernel.org>

--8Vur0n2Nqa/eczlq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmN8zV0ACgkQJNaLcl1U
h9ClDAgAgIY214kn4I7zM3+oaKJO2vk03Oi6WrlTHYaDO3jmE1HH3SUPdPeio9u+
QaaYSZYfnuJqGiq8CN8DygTvB6kOObFY4hYGD+dL6i9kjurhSTNW5NB1Km5FTTvS
Vs3fS7GOmvkzrOKBPSV6AJoEKB8sNJbtPYS/xC1s5d2ydhVtA2bOjzfGTBL2FZfs
TzFjy68JLcB3avXPCJrZ4IB07/TdOj4V3DRHx4G1kbJ+HQO3eREYGClg5e9RHzY8
GIyfRoPiC+PHAQADviznqrgypRL/RM5NZrv3miQTINs58zH6hMvYqZRJelXlyWXb
BzBf4yMOpCU/P2IKnPOppRYXIhK8Dw==
=QKj9
-----END PGP SIGNATURE-----

--8Vur0n2Nqa/eczlq--
