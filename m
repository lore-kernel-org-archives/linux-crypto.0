Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A87BC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Nov 2021 10:13:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8930261AED
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Nov 2021 10:13:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245623AbhKRKQx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Nov 2021 05:16:53 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:52495 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245664AbhKRKOw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Nov 2021 05:14:52 -0500
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 8BEA922175;
        Thu, 18 Nov 2021 11:11:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1637230310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nA/zdxS7sNYSW0oahJjdohaCGTaiUpU5dX8a274QxUQ=;
        b=i03lmLLsC70LASUUNI8kZnjkkzAbbtnvYz3PwIL9JHkxbGOwXyK6zWijyZ7XDrWAQ4x6eJ
        gVw5aXmXQ43VsRLQoC5tCSeKoin/G3Rdz/TUKGPmSfnEElot42Yw2yZOeTfBYSN5gx4q5h
        lTjYm6V+Q/MoomBzq7i+A7RyLTQYjtU=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 18 Nov 2021 11:11:48 +0100
From:   Michael Walle <michael@walle.cc>
To:     ZHIZHIKIN Andrey <andrey.zhizhikin@leica-geosystems.com>
Cc:     =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>, Gaurav Jain <gaurav.jain@nxp.com>
Subject: Re: [PATCH v2 2/2] crypto: caam - check jr permissions before probing
In-Reply-To: <AM6PR06MB46915C392B6AE207F9BFD24CA69B9@AM6PR06MB4691.eurprd06.prod.outlook.com>
References: <20211104162114.2019509-1-andrey.zhizhikin@leica-geosystems.com>
 <20211111164601.13135-1-andrey.zhizhikin@leica-geosystems.com>
 <20211111164601.13135-3-andrey.zhizhikin@leica-geosystems.com>
 <e8456cc0bb9e4fc306e8188c5bd666d0@walle.cc>
 <AM6PR06MB46914ECA12815ABFCE8C1A59A6989@AM6PR06MB4691.eurprd06.prod.outlook.com>
 <59c04d9d-7acf-5468-1382-ce22bff8292d@nxp.com>
 <144f646753cb6e0c7818dfaf116b5d54@walle.cc>
 <AM6PR06MB46915C392B6AE207F9BFD24CA69B9@AM6PR06MB4691.eurprd06.prod.outlook.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <754950612adc3a5b66f976f866aee07b@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am 2021-11-18 11:08, schrieb ZHIZHIKIN Andrey:
> I guess there would not be much left of this patch once I'd use DT 
> approach,
> so I'd re-spin the series to include DT bindings instead. JR driver 
> clean-up
> to remove static JR counter :| would go into the first one then.

I really like the cleanup though! Esp. the removing of the static 
variable.

-michael
