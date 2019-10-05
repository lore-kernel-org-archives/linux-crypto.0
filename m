Return-Path: <SRS0=f3/+=X6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 738E7C4740A
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Oct 2019 15:27:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 477B9222C0
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Oct 2019 15:27:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="XIA4YZru"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbfJEP1r (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 5 Oct 2019 11:27:47 -0400
Received: from mout.web.de ([212.227.15.14]:43909 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725826AbfJEP1r (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Oct 2019 11:27:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1570289250;
        bh=TGPGZ4BC982UpJnrecztHM+J1YSIyZDa1AkZc1zUtX8=;
        h=X-UI-Sender-Class:Cc:References:Subject:To:From:Date:In-Reply-To;
        b=XIA4YZruqPkmBOla1K6dSDST2VEXym3xIMA8D6B1MWwpSy/20RmyJRtoB2mGm2s9P
         v7bqpuUElAGZ7t1g635pLnACP7Zui10tpWETrQj8UV2U5TW+4iz7UFdWqjvYGGWsIC
         AZElSY5Dnz4tA7AHv8p1ersYWD/fINV7gEavB5XE=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.135.178.111]) by smtp.web.de (mrweb004
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MVXnr-1icW4r07xP-00Z3W5; Sat, 05
 Oct 2019 17:27:30 +0200
Cc:     Navid Emamdoost <emamd001@umn.edu>, Kangjie Lu <kjlu@umn.edu>,
        Stephen McCamant <smccaman@umn.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20191004193455.18348-1-navid.emamdoost@gmail.com>
Subject: Re: [PATCH] crypto: user - fix memory leak in crypto_reportstat
To:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        linux-crypto@vger.kernel.org
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <ddfd75b0-f0e7-8eaf-3631-95e2dc81bf63@web.de>
Date:   Sat, 5 Oct 2019 17:27:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191004193455.18348-1-navid.emamdoost@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Provags-ID: V03:K1:cl3hnurCDS8Um1oNZYIEd2gOJYJRGd1F019xMwreAp0J6i3V+Co
 nCBlP0b/hvKk9EOmH6AUSjnM2awnxVLV0R2O3g8MnA1TyeKNtVBvXwBJbfTog5bdAFQa/Ou
 zWsXCzJFX+jQ5jQe5esVjhQcEoNRde9GHucysQ6UFqlgbfqaI1pgyegWqF07f9jYizSriAF
 XBAeIoVabB0L/dL2Hns/g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:nHDuIekP1tA=:S/b+1iqcU3FP6FPR1xoaRV
 MImz52vR4Jg9ppR+7jZyuoaC/xfcrrRQgDpyylDEKIzm5s83MFaFXbRFbLMx2cj4GgOI7EI3V
 MGnQPPc9z1oyp/LECt1EAS8FYHAa3OpD2YVS7TUpcM0UXsnAf8W67xtb4Vcf1r9L1ZCz4nNlp
 KrNB1sjbqECKa+DUGihCMgt/ABwzOqmegG6ngEtzFE8evwkH8YLPZp9iYmEAcDyP8SnaJYxdQ
 fXu0siOD9fZQQJ/gUv7Ey4azKI2Ff1aTe3EPa1SbaZbLiFzqf86Z0thUV3JwqAgiXK8X7vyY+
 vUXnJUkf1V35f5A+j93W8G7v2neMLLM+i2RYip6JtKGkXw/l0uhlPcbrqC7+83OkRuPVA8dHS
 Sr4sr9PpfUr2pOLlFlKvGhwD7Ym6eChHgGuZ88ySyu5ASiGQzdrnmS2tS/pdFiR/six0gpYZU
 xummSUewmB3E7k3B6VY3jutBgrzI0zSMw6nfRZR33F6I6JeYoxdsHLR12Rruo7bHjNtd+UjZ3
 i343zUhpl3No8s/ChI91PLqH8AhaATGpu8yEJ+2lSOsriO6Uxz/8fiLCzqwahWHUsBcMdtONz
 kXPP46Aa4b6CRdEktL9/ZbEmeRG20b0/qYjZOrC33/RiZKPPxeJIuI4CXBmjktnwUhgEsNdTU
 6Zwp1Hmx4p84nOgjHpLEHfqhZZJzbgsnT91pLTI7RZN9RZ9KlfkP8oHBpn2Chogspj+1l3ewU
 S+p6S/PK4j4AWgiGfwvAdNepwjb3wk/2pZvffDlzClSCzccqxaxAXHz2dHr/XffStUlcMTcm6
 7LOo4PBal9H4NC8PoF+W5DZgeeN2jG37jfxM5xs/IEhYc+sInDQP1kVtzEmOdoujKz4pEIZbs
 K61SK2Ioeke4n5qoP1NBFPi9U1FOP/HqeL6W+gFlYEK2bQdkDn+hdSK6yCPn0jAcQCKdVBOqM
 2BRApn4L7xymaMeu1mAw3nIW73aCbmKij1WA+/B/i5Ox9xE2piFlgpgzIxuzCb/O082SiIWm8
 pT2sDddslOtTkNTD55eVDAuf20iKAob9l3v/m58kMAn/XXOB/QsgJ0Klf5jPRCMeMuRL+w95J
 JE+t0zehx46JTIqZvEDwOxxLO438EscAwH1mD89kRGUfNamUkITycC3ppo22GM2SoOgZcgHoS
 lylmIoQMwxgp5WuyFN/RaK2k0OWgfETd2wKsnCGd8HckKghsE1PgG7fWdvuT3txQ1Ehg74XWW
 9QrWxaE9fPnm3rC5A+PTLg+p6x5jcdPxzAWjihDT8e6MUvsHqFYjOpKYQ85Y=
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> In crypto_reportstat, a new skb is created by nlmsg_new(). This skb is
> leaked if crypto_reportstat_alg() fails. Required release for skb is
> added.

Please improve this change description.

Regards,
Markus
