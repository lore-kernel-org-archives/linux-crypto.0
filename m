Return-Path: <SRS0=+pKF=VH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79527C73C72
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jul 2019 05:56:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4346920838
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jul 2019 05:56:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="MQI8Lwdn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbfGJF4o (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Jul 2019 01:56:44 -0400
Received: from mout.web.de ([212.227.17.11]:51793 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725791AbfGJF4n (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Jul 2019 01:56:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1562738166;
        bh=TVMPWtxhrM6Y1UVcY/Fxy6fvCMPRppnabQwd5AhobCo=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:References:Date:In-Reply-To;
        b=MQI8LwdnPo34u09NpYysmQm3Q+z3g6/gHcqOQGtQp8c8EiJXQHs6rszLd4i666B0S
         Msi+eMOCPMgJXdcT94DeK39F92BUdjcc0YIWvQ/RwZtX+2TvunJGr7UPfow5dHx6xF
         4yUINT/1F9oIMzA0KuRQZtta/U33V7y26Uvw6Wn0=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.132.42.76]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MI5ze-1hmjDE1cAI-003rjx; Wed, 10
 Jul 2019 07:56:06 +0200
Subject: Re: Coccinelle: Checking the deletion of duplicate of_node_put()
 calls with SmPL
From:   Markus Elfring <Markus.Elfring@web.de>
To:     Wen Yang <wen.yang99@zte.com.cn>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Coccinelle <cocci@systeme.lip6.fr>
Cc:     Allison Randal <allison@lohutok.net>,
        Armijn Hemel <armijn@tjaldur.nl>,
        Cheng Shengyu <cheng.shengyu@zte.com.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Xue Zhihong <xue.zhihong@zte.com.cn>,
        Yi Wang <wang.yi59@zte.com.cn>, linux-crypto@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <1562566745-7447-2-git-send-email-wen.yang99@zte.com.cn>
 <1c215500-b599-8b2f-61ea-a6f418ab4905@web.de>
Openpgp: preference=signencrypt
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <80dc77ec-16ef-4573-d80b-70452358eab8@web.de>
Date:   Wed, 10 Jul 2019 07:55:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1c215500-b599-8b2f-61ea-a6f418ab4905@web.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Provags-ID: V03:K1:2Cc53XfhSJE+KlXiuHHnzCh1W0icYpRpeHLkLHlKiwGc9fe+Tvp
 EUo4xKZZcWPr7HUb3fTvOnnvHUng/tZmMKB/rAhd+jcMZLBeWfX5xhk1HfWOrXe1WDccdlZ
 5Zc64HpmO0V9p0cl5h76M2H84Z1y8HIXiq5UL1Ip5QMr8fTr72Wr5p+Qao31P5iQYqXYQ6i
 oL2F+z+ttoJjcv0kHtrUw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:m30nMVk5pJQ=:Q8B1x3VdjBjXIzBk/mOTLr
 CbeJvC2IF+DfOrjEHXJY6o6oY/ZXTy622br15W8WyFPbrEmc0vCHFJzDX5gEHZq1OfOnS0bBS
 Arvsw36Afbmk3vSTodk4sbpaKXq7o2VQosBP6/qIwYYUo0GyLYyHPfigrBqcVUXqRhSncwSRC
 EYV/O9DK7mt5LZsXP4SKDL2rXXFnUukDtkEXgkFpod6CmJEw1JRumYUuVwNCq/3MsiDF20kSe
 B4lmdEtiCUM9wnDwMTh1YFhId3HvVDTJ/LL405rbPZinHciCZzg4VE7EEC5vxYYMwjoCzYsvJ
 2Mnj4/WmpBCMka2bbW4JlINKbBfo9kCHWyv44+k24OimG/Cj31htqaw+tZui+GYJ+YX313Bts
 +4Y1o9cuecoSUSSzo/vENK/xJt7Mu1jZ4urA7JpdvEoqt9ZFqB+zdhgW07GVEo97+84NTL4Un
 7mSKeeH20Vml31Ty4VJqUNtTyr1MHt+HfFyywrIup5/IIO0dt/yM4wYpVxRS+UJ2NiGOTDImK
 fbJ9cY+F6TZ9bI6ava77Y2lDMkN0osHypRFGBHfzVXMRD00y+2hQpXC9ZyS+xqTrcmMUmJDBy
 7Otl2q/Q24ZidjCkDytBneRXFhQ7w0UiPaZpW6Zm0O8w2216GQjC6SkPeLYU9OHp4779L6bl2
 yj+BTXZ1lKwi/LGZ6xSPAAHLM4QbY/k/MW3TfrbLqKBnIKWyHlMwm90vhePIYPNNkwPRSrXoX
 5Av/tB/76PfzG4qqgHwP4tyeUfd5DQR1uDczXCuaf3tXl7G1Ker/ePv3gB/f++wWVEyN/T9Z/
 i1O8OUboqgZ4oeG4brfaUyRNSqdf3CMk4LnTkfT19ydx6kd2e8H9N2W2KKVgiA6Eff6j64Bs3
 ycvKikKr7CVcp6MDO4o6s9uVhYWujy0FDiHAOcapVsnngLxTJYjSO4++bLLV6wgahPAJeYOPx
 Q3GcQhi3vJBiuAUyhhkbrvsSv4OWeLhqzkMj60FhtsvE/sSzH87wSbWey4Us2WktKKN55LORL
 p2e6ZfrIUk003/tGuXtsn9KHr/MNUTPt0Xc3bq5PKSLcKqg9PLyoED/SL66g4NMYTRwnjseco
 7xy28F4LkGb7Ij/glmy99EkJrIZ/KKbvMeX
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> But I wonder at the moment why it does not work (as expected) for the original
> complete source file.

I discovered that a diff hunk (or usable patch?) is generated
if the return statement is deleted (or commented out) before the jump label
which refers to a potentially unwanted function call at the mentioned place.
How will the support evolve for automatic adjustment of such source code
combinations by the semantic patch language (Coccinelle software)?

Regards,
Markus
