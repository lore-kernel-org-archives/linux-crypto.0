Return-Path: <SRS0=/YgZ=AD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04938C433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jun 2020 17:51:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D157D20707
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jun 2020 17:51:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="qyEf69un"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730132AbgFVRvP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Jun 2020 13:51:15 -0400
Received: from mout.web.de ([212.227.15.3]:41315 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730124AbgFVRvO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jun 2020 13:51:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1592848217;
        bh=hUD5B0OXQqFhcHukPwK74TlGNcrPDU2XpmqaEPVtFXw=;
        h=X-UI-Sender-Class:Cc:Subject:To:From:Date;
        b=qyEf69unEDpdxHlMbeUPVPPhlFEFU0OKok6/Y4UhL1Ar3GhFb4BXi50uFoO0sQe1g
         Iq6gZZR9sunPErx5OZRC2hXiXMukmIUn3DElqVQiOcoTmEMQTkNz3TnXCVg6RGlVUD
         KKRykDxC8Vd0YTUq4QwpIZ4FmEx+qrGALZA22N3Q=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.49.69.81]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MS1tK-1jPfJD2N0U-00TDmR; Mon, 22
 Jun 2020 19:50:17 +0200
Cc:     Aditya Pakki <pakki001@umn.edu>,
        Navid Emamdoost <emamd001@umn.edu>, Kangjie Lu <kjlu@umn.edu>,
        Qiushi Wu <wu000273@umn.edu>, linux-kernel@vger.kernel.org,
        YueHaibing <yuehaibing@huawei.com>,
        Maxime Ripard <mripard@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Chen-Yu Tsai <wens@csie.org>
Subject: Re: [PATCH] crypto: sun8i-ce - Fix runtime PM imbalance in
 sun8i_ce_cipher_init
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <265c3a75-f8ce-fb34-d559-39e58a4dfb4f@web.de>
Date:   Mon, 22 Jun 2020 19:50:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:D8er+pJ68yBwV1LEICsFb18mGAlCZ0B44JJW50fqtQpO24AiRlU
 cOwS4HFWbMJmPhe0QjAmJXjvBWqF56+Ywsw0/YK0FXrhlahCAkdtjWQnRBdmtQxKibjS9wo
 5HucL8Pp3mRlV+MTfscFlMoj04kUMR+oX49YzSYwD6d1SLNuRr7XuAIuHorQCDpXXEwiNYO
 VXPyzTDaYv1FvmIvKRWuA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:DS1HQa6FHgM=:FOS9eK/hAh8NxRoYHHmlYf
 Jv09zt0mD/cssZfIPvBENZIwI7VqJgYvdbt6wQLYWe5nnF9fj0nqUv5Uq5Sunwvex2SBalhmP
 U3LBoSMJqKW+DCWV8Rkmx5UP8hUALxf9jURzLAzdTBxN6bLBpz20fDxTZyWWikQxroZ3jF9MP
 OuwBDAxtgK+9HjwT6qSY7MSamKXmEma2G9PRtcjY4FX4TE8mILCXBLHpH0ov8uM8YiKo7bkcu
 mUhQrZr51PhOIFlrpbwRzxzzB99lXckz00lds/LnyfYBYV31DGQ9Fy0mUPHwdfmyWliQQlRWg
 ATnAFqUzHYmx7+84egq1Nlymw0bWMj/HSjttIfXIC5Q+yJTC3xAtBBqHJGHZZFIE/LM4/dkbl
 N/5rEFk0MVppIYkOu2MO7GfpCcJz4ylDVI/HJ1xjhvhYypGufWJR4oZfLXBvd90pUnWJj0qqR
 tRNXX+00mTvV3nKt/u4sPKFgBnbRUvy3P7FUQ4pB6VGxowuNJ+yDVzqEbAlnWEb2l2bdY3VLK
 xGqCSGPXiIKamSl/IFKqIlR/sNO3Bo545XLWikPfzcd5LzO1Mb/STlqmpaPTwrQSkmlMoLDE0
 es5PD2nQoiChylY1g6CuXWxs3SpFJ6IaQDYF1PBGgujE0d2AZIL6WZoPf0d7sEzXZFiBkJvW1
 v3x1tonIXRyXroZFY00Ywql6lpsAhXZZrkDhWZrhNmX00ZRGDQ9+kBUkluxWA85QTor6lKUbZ
 fP4OEUEw2Wbxmcy4JjSe9b4Z1xNKoFI3j55LmhHSMdWyRgL85CQdlNeMeqBY/rU8m0FR4T0y1
 RXBHdlaUYv+Gun8MH51vIOfUiUnf+MxRLpPcqos9CvW9dOjI2tGmkIns2v1jbuB14y1rG0vf0
 yyf7NHwBesggzyfYTdUuuXVJ4FGEb81WqorHQE4WvDu312YBmeTOKYNgRew5vr6yIst6H9IiM
 YP7afEzlUNjTbw1UCGuuJL3HtFeXJCy0xd/g587T6csIqv8uhhCjtN+HwZ/ZCgSjSCdHNYHqX
 KuCp0ZxJoCNaFQopVI6SrdA503lbO8TuKm+blhQjqSWCwweVHQVDkLsq8HNaUvG2XiZ7a6zWj
 3yrZvtzbbbcmP5o0khzA0b3ZcZ2UGRxORslcdo4dOeMReeHHqkX1cFSOdWiqzj3zjgcBbphma
 oBKLRdzP1+gkB6tlb3yQXMsopM6/E9f+imXrQbIrE8qlad6VRv6z4KyTAqmx3RpBgZN9n+hhS
 pA54UsGYVKvTjRqCo
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> Fix this by =E2=80=A6

Please replace the beginning of this sentence with the tag =E2=80=9CFixes=
=E2=80=9D.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?id=3D625d3449788f85569096780592=
549d0340e9c0c7#n183

Regards,
Markus
