Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD57FC433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Sep 2021 17:55:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8C7B6115A
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Sep 2021 17:55:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236982AbhIVR47 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Sep 2021 13:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236837AbhIVR45 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Sep 2021 13:56:57 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A5FC061574;
        Wed, 22 Sep 2021 10:55:27 -0700 (PDT)
Received: from [127.0.0.1] (unknown [185.4.193.222])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id C1184221E6;
        Wed, 22 Sep 2021 19:55:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1632333324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0THVwF9iAKj4pPRjEVgX91l84SyJxAaaWm9eRVaEVkY=;
        b=iWnj/83IE4y3KEVOOSn8ejEeL1qvzYRcbCofDpFwmh+h/2EQHtqgtO5+M7Rb9qzsU+4KkF
        aOnqeYbak/rLpRBi52kxQiO2blw7AiRher2ektMt+u5T8OHqSIaY1xY92keOWW6AsbfgUb
        +qVA0vfLeR+o3WqxdFKB9/Sc7iIShxk=
Date:   Wed, 22 Sep 2021 19:55:09 +0200
From:   Michael Walle <michael@walle.cc>
To:     =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Pankaj Gupta <pankaj.gupta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: caam: disable pkc for non-E SoCs
User-Agent: K-9 Mail for Android
In-Reply-To: <0b8ae053-698b-2c03-c729-c4c86ba79550@nxp.com>
References: <20210915220307.3079917-1-michael@walle.cc> <0b8ae053-698b-2c03-c729-c4c86ba79550@nxp.com>
Message-ID: <936221D6-08D2-4656-86AF-DC921E3CB14A@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am 22=2E September 2021 17:51:23 MESZ schrieb "Horia Geant=C4=83" <horia=2E=
geanta@nxp=2Ecom>:
>On 9/16/2021 1:03 AM, Michael Walle wrote:
>> On newer CAAM versions, not all accelerators are disabled if the SoC is
>> a non-E variant=2E While the driver checks most of the modules for
>> availability, there is one - PKHA - which sticks out=2E On non-E varian=
ts
>Currently there's no dedicated support for "partially disabled" non-E
>(export-controlled) parts in Linux kernel caam driver(s)=2E
>
>Up until recently firmware (U-boot) was deleting the "crypto" DT node
>for all non-E parts [1]=2E
>Modifying the f/w indeed triggers changes across the s/w stack=2E

Well, it does check if a module is available or not=2E And this seem to be=
 the only module which have "something in between"=2E I=2Ee=2E the number o=
f available modules is not zero but it also doesn't work as expected=2E=20

>Since you are modifying only the caam code handling PKHA, is it correct
>to assume that everything else is working fine?

Everything else is skipped because the "number of instances" is zero=2E=20

>For example: is the number of AES accelerators (AESA_VERSION[AESA_NUM])
>being reported as 0 on non-E parts?=20

yes, see above=2E=20

>> it is still reported as available, that is the number of instances is
>> non-zero, but it has limited functionality=2E In particular it doesn't
>> support encryption and decryption, but just signing and verifying=2E Th=
is
>> is indicated by a bit in the PKHA_MISC field=2E Take this bit into acco=
unt
>> if we are checking for availablitly=2E
>typo:			 ^ availability

If there is nothing else wrong, could this be fixed while applying?

>>=20
>> This will the following error:
>> [    8=2E167817] caam_jr 8020000=2Ejr: 20000b0f: CCB: desc idx 11: : In=
valid CHA selected=2E
>>=20
>> Tested on an NXP LS1028A (non-E) SoC=2E
>Thanks=2E
>Unfortunately I don't have a non-E part to test on=2E

You can take a look at the ls1028a RM where this bit is=2E described to ve=
rify what the patch is doing ;)=20

Thanks for taking a look=2E=20

-michael=20

>
>Horia
>
>[1] https://lore=2Ekernel=2Eorg/u-boot/ff146322-e8c7-2418-ceb1-a3c0d4cee1=
a1@nxp=2Ecom
>4eecc6f1a104 ("armv8: layerscape: don't remove crypto node if just partia=
lly disabled")

