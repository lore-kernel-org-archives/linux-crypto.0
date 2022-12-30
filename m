Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44247C4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Dec 2022 06:55:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234507AbiL3GzH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Dec 2022 01:55:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234503AbiL3Gy6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Dec 2022 01:54:58 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5441EBC2C
        for <linux-crypto@vger.kernel.org>; Thu, 29 Dec 2022 22:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1672383290; bh=Pwkpsiwz+unYOPWAvqDpgwSyb08uwK9VvrOla2/0nxs=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:Date:In-Reply-To:References;
        b=Brb8SrfsZ4DOUhjhHZTnR6s/fQFmNRHT8cTaHtBGLqyr10YYvww/UpqulcbWHWslG
         V5NNO6xNq9h5cHhaE46tpqDPyBiZrMjoCZojcqmkpFMzp4yIb3JwCAEHByHyyzH/KO
         4DLluvuEFijuRDzAJce583J+zcypA8i0BaQ8zRCc4lToS4X5E+75dMmTjdGsR1INm0
         26/OLao+S2zhK23X0BOmroEa4faBP+si+x4aksXvMMOmmRcAUz/8wF19w3DUkTvj9s
         R1wjuLXbmMTzD9soOjXzitz6ClsnHRinlOpd+bBFQWQyzF2X+1DnAqrZ/VWivjnzwr
         8RBbmxeVOLy+A==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [10.0.2.15] ([94.31.82.22]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MDhhX-1p10fd09GZ-00AlR4; Fri, 30
 Dec 2022 07:54:50 +0100
Message-ID: <fd63830411b73a4928bd68f91fa072abb88746a5.camel@gmx.de>
Subject: Re: [PATCH v2 0/6] crypto/realtek: add new driver
From:   Markus Stockhausen <markus.stockhausen@gmx.de>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org
Date:   Fri, 30 Dec 2022 07:54:48 +0100
In-Reply-To: <20221206192037.608808-1-markus.stockhausen@gmx.de>
References: <20221206192037.608808-1-markus.stockhausen@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.2 (3.46.2-1.fc37) 
MIME-Version: 1.0
X-Provags-ID: V03:K1:8omdL937KjpxD5ocMZdMQSy3/13ATMumwiIn0tmQ4AlE9IJ86s4
 GrInrmgxpbLWkXDq86Q2sNO9CqHNp0qVhjHA3pHFRe8CPHkbhPlM1SuyqID+hq/WcnOSffd
 teNGyMVEm1K5BqsX1YCsO9Km9V0G+APmpmIaUH3Q8ibi9RwzLwU1AvIM5ZflQaycaZcr1A0
 hStjtTAJFXB9D6h6zvJSQ==
UI-OutboundReport: notjunk:1;M01:P0:bou6L3epHWI=;ntOktdXfytdf8DMp1A7SfcYAizB
 BkmogU6tKzUcs5A9YkdWWlqrrmrzZIlDUch2B5XMM9UeA3G0Mb+ZLa6MNShJRjjGz/qLpKem2
 5k6KNMyDiJZ86etbxWPQXUT2Zq6R9uzkqdiF7mMbcgpuCwT6a5X62mhW2ZaRInryUfa+pYLal
 b6VSp8vBLKIbvFHc74R997tF1iaA/DEKL63wa6TjB6U4F8v/3E12b+Pq1FZBD6YYalV8Pkaw3
 tMkEOOkAdM19gE+Y1mhfAhNiDRt2I+hkIqdbassq4EqzzkeC8qn7QSOA8CJezVKc34BopnIpy
 qprZseuCzkrRElWPRSwD4rARVQ+iTP5oddfK9IORqqS7ueSQLQWA3+pmMRsQV64t2K5aJ9Q5t
 PYflCeooP1cCzYg0o2oBXVQjyv9pnF2h0rU85GrQ9M0vFj4pRSBPzWOheOikirOqlMmPs7qq1
 kMHIHm2mkZAsRlDEAsHOC38JbaxJ9UPyucdp+aVuFefWuvlu/ia0AQm8fT1ZyaWurxlOa7Q0R
 4TnMkG19oxei4gDt4FZcKYPnF1vC0O5+dcZWtrfCaW9WE7LMLcm7IsA+o9jNJXdhnVM5DYm77
 Jdahle7RhQdRo1QgXIMp8QBRes3y9NmNpPT0nzrZjCfJBduqAp/DMS4XYQer4bZ8qeiJ4r+2E
 JdqZGiGpOhj17itTvaSzwrEInaXk6m5UyTX3LrUYbeAhfenkNl0GMAntwqaNFC7D+RjTgmQQK
 XrpUxczsoGvKUqaYzoEFoHmHPTfMDNcdXgb2PcqVS0PbMcc1oAkEo4yeSg/jG0f1Ys54avJ9A
 Yr1TFB5n2N8ghb25vKRXCaKDbgLKWrB3eedEr+8JwAChXUGUPJVOfPFvUOdzM+l7zWnGTUDQX
 y3f6NY0DbEcKSDHE7hWLmzQgQPcNwGtg8vyrq+J8BgrjJtaSz7A7ePyI5ZG5obw3xaIGSy7pe
 Xo+mCg==
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

once again a short check, if I still have a todo on the driver.

Best regards.

