Return-Path: <SRS0=7Iqi=AE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36479C433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jun 2020 18:13:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A0D7207FB
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jun 2020 18:13:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="FcJRzYUs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733075AbgFWSNT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Jun 2020 14:13:19 -0400
Received: from mout.web.de ([212.227.15.14]:59015 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728916AbgFWSNS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Jun 2020 14:13:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1592935946;
        bh=ta4B5U7NcnWlkKMrrXTDnwiIOLEapRNu6S62MdMg4MM=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=FcJRzYUsTn4yZBHwp8cofCKX7TR/HZWLQVjZ2s/HApmneq+dnb1k0Xg0SJe7O2jPa
         QrOCEO1qJTDoz3xb5EKRv+jFZCoFiA46uMyfPj4YvYOemuMP5d9woXCuaoBq5R0SBv
         jkf3W7EzSizLeKye5DM6Q48uX5NQ0DehqDwjobaY=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.49.105.198]) by smtp.web.de (mrweb002
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LqDHE-1jALzW0b44-00dkuC; Tue, 23
 Jun 2020 20:12:26 +0200
Subject: Re: [PATCH] crypto: sun8i-ce - Fix runtime PM imbalance in
 sun8i_ce_cipher_init
To:     Maxime Ripard <maxime@cerno.tech>,
        Dinghao Liu <dinghao.liu@zju.edu.cn>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Cc:     Aditya Pakki <pakki001@umn.edu>,
        Navid Emamdoost <emamd001@umn.edu>, Kangjie Lu <kjlu@umn.edu>,
        Qiushi Wu <wu000273@umn.edu>, linux-kernel@vger.kernel.org,
        YueHaibing <yuehaibing@huawei.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Chen-Yu Tsai <wens@csie.org>
References: <265c3a75-f8ce-fb34-d559-39e58a4dfb4f@web.de>
 <20200623134442.wj4i3r3dlp6rtpaq@gilmour.lan>
 <16341716-aeb6-febc-441c-c1826da8c4d3@web.de>
 <20200623165615.i7iphakzjeu2d3fq@gilmour.lan>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <b567ca26-17a2-2116-1cab-335a21c21be9@web.de>
Date:   Tue, 23 Jun 2020 20:12:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200623165615.i7iphakzjeu2d3fq@gilmour.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:i2OKciW/q0yre7Qi0ZXqZg8dnUijUgxS0e8iCzrANnntusFQ15Y
 q0m5rXDqAqjjxxtPVmX/Iq3LRcrOMffqov6eIHk4FEodx8tc+Slm6e9pOEV+Lf8MCI+ATBi
 nIVeLSzVSfTkhbwpAdjkMa0CA1k+b7m3uptM0EDNiYBj6x4fIuRQVmNc4qdbdj0gbRgSVVv
 NlRIVdkA4phpwpZIWZSgQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:oit216Wzny0=:1UEVGowrtz67JAcMmugdnF
 W30gTJC9f30nzaMZMZFJ7I/CST5Bxtgt4XSzEKqwfC4Zp/Ot5MfaH3SACnAshOscB9RVldRsW
 TRI5D3hY90N8lwV6DV+qKnMeqTjk4Cw50yrMLmxAV3+o0Pyjvc+A6PJExt03SwY7rkU3MB4OZ
 2Y4QDLXdnfPLu/8sU6EkGtoUNHfLEuQrbfYibpu7cc9Rw6z9e0Pls/PQQRe1//BWyPo43ECQW
 D6zyIaDYw5L72+g5mTNlrZodhTfTp/9X4CVsK786d5zjYW73YfmRb3cuBuz37SFzWrjwHPG4C
 GQUWI6OkeUr+RZ/5Uc18fqHwZzu9XxXYymj7zcu0AMGx0jKasz6kltbzJMAOys4KDRYKEAKm0
 sqjn+NcLv+AEDZHMAmg5GwPW/r7y0rurE2+2nzkvmYgAirgR9xBSAPLXLFvfLvPTLhTvE42HU
 V0D7S7X/QTp8oKfjEBiHY1Z5VQGY7LDe7OCPBNlP1ykwgRkhadMbJdp6uj4gmiNAXgRuA2Quy
 kka8Age9zz2wGBXe8n8kVTRJnqaAJxCiixdTjhDHdQz/EwCaOcTeX8DNf1eBL6ZJmADdA7ExY
 /dqPwYsEPOnDBeb/PBMeYYEHsvigalkUbPepuovD4AY9Rzg2J5GhDLRqGW3BaWTxqvgqr9ESC
 pm52ofTf280yZD0Hki6a31ROmc/lFPdP0Un9xvMiV0rd4cLVZ5/B0/kUP00XyqsWl6jkuF+iQ
 I8Scg938bftD2+lVNXoxfAiZXqzw8dcvMFWQnu5GtA58X5nIRgry4RptZSNx7tfympJYrid4Z
 fJtz+lFBp7fsMpJJuEONyVq1NlF7/8v1sIF85DZxQb2c+ujKAOO23bcFXNnMqUuSmnQWx9Gfd
 S826OeEyvDJT87yWG8CirKjVXPvh7Y0d0mnPoMtIPknSqH3Vyv97QHmsKt5vzCjLYRCQv680m
 8f2nimfC85zdmd/JJc9ReJZOuN2DbbT85r1KdJh22pKlBh2vE4QxK/78JUKDRK7GNkDGHqNow
 ggnTVrH99WURxcHDyEFlo7epkYok6kjlz3RfkrfQWtjhDa8x5cj5EZxnQFiLsbBYO2DpKMWHv
 jAA6a+hbQwVPELo0HjvURUq5PTx83w5sVTuM7xKgfds8nNZCilT20kLrm197/W1IVan01zHSd
 ivFAyOrVxgdObQPZYA7nQUgH2Buk+ZD3T7B5QP/bSTEDx4KAdIsOIKVvbgtDfoIOA5gdWaZ0d
 KtIFA5yxGTbtg8aB+
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

>>>>> Fix this by =E2=80=A6
>>>>
>>>> Please replace the beginning of this sentence with the tag =E2=80=9CF=
ixes=E2=80=9D.
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tr=
ee/Documentation/process/submitting-patches.rst?id=3D625d3449788f855690967=
80592549d0340e9c0c7#n183
>>>
>>> No, not really. The comment you (partially) quoted explains how the
>>> issue is fixed, your suggestion explains what commit introduced the fi=
x
>>> in the first place. They are both beneficial, but there's strictly no
>>> reason to remove the former for the latter.
>>
>> Do you care to improve this change description another bit?
>
> I'm not sure which change description you're talking about?

Repetition:
https://lore.kernel.org/patchwork/patch/1260551/
https://lore.kernel.org/linux-crypto/20200622024014.11347-1-dinghao.liu@zj=
u.edu.cn/

pm_runtime_get_sync() increments the runtime PM usage counter even
the call returns an error code. Thus a corresponding decrement is
needed on the error handling path to keep the counter balanced.

Fix this by adding the missed function call.



How do you think about to avoid a wording weakness there (for example)
besides other possible adjustments?

Regards,
Markus
