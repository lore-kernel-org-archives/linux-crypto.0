Return-Path: <SRS0=4LZm=7H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBA68C433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 25 May 2020 06:05:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A695B206D5
	for <linux-crypto@archiver.kernel.org>; Mon, 25 May 2020 06:05:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="jF2kJHUM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388787AbgEYGFp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 May 2020 02:05:45 -0400
Received: from mout.web.de ([212.227.15.4]:58789 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388772AbgEYGFo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 May 2020 02:05:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1590386713;
        bh=AZ5lex9OczzMAvJaxc7Y2dYDY+Uz+nr3GAaKgYS5dB0=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=jF2kJHUMH5XNcH2BTQVRixREFKhXdXIXCVjuPD9rbmx0bPQ8Tlhrs6WY/XaY3+uwa
         wpvd5jPV2E5Zme4kJmJ4vAabTofaxaLMWkvuoKeQxGd4n8bQ3/PGsWAMpxf5ftI/Y4
         UOAH53ujKJRe5Yjx/PSqoEsNOL8OlSPAwCENu9JU=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.135.186.124]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MqqPN-1jGwps0VoP-00muVI; Mon, 25
 May 2020 08:05:13 +0200
To:     longpeng2@huawei.com, linux-crypto@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     linux-kernel@vger.kernel.org,
        Arei Gonglei <arei.gonglei@huawei.com>,
        Corentin Labbe <clabbe@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 1/2] crypto: virtio: Fix src/dst scatterlist calculation
 in __virtio_crypto_skcipher_do_req()
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <21478291-9191-1da3-a7e5-65e87c743a3c@web.de>
Date:   Mon, 25 May 2020 08:05:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:clpeR0/szSLHOsLIRqTN3+KpiRF3FrgDoBZbzaJKXWtsidRl2Fl
 3wNTkuW4jRB+EmQo+2Ms75Ms+AC3S25qO6W8TixoRv01KOKm5RuYyaOUHy/ScPjb4+XULNL
 Kiw81w+ibePY2W/qaJz6eNm4kWD+YQEmr6A9GBubsMBSMWa7rNmSRWS1Mza0GLH88J0ByYe
 2WLbV2PbfJvyZFj5cw1HQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:AJM2L6DAP3k=:oRylNq+Ln1Br145F7FbeMc
 mQxLS13ky9YKkyllEeOO+UKfhHwaOfHYU7DO5GIuLsVzoEwm/DAyZNoRcscVYgiJ/QGW7EbXu
 LywQMmBl6Q6oGnqCQDg/kSA1C3WP6cANocnFToS7lFRCFAYFH6oxqy939LO/WVRh7ROda2bmu
 sqaygefyx//pqm7OtZz1Vvcb+giy8kodeP5iOnZgSA34OicYGWQG/LzLcduuU0N3HS8/5uYBW
 fmX0H763BzetkApZKn0mLJNs2ZELpHxjnkxWbNJI++251RHHN+qKEV6Gz9TUm6IXIfrditbAN
 a50k8wlOY1YUR9wPnxP8ej+soq0iG5CJ4SQmSDZ+iFRDXuoo5SOwhIHPmivvfCJHa+PmHxj6Z
 h2CwdzfF4HQRPT8+5tfBqKNbb9aO30zCrhm39emLRiAUpTETEXbNFIqp/dSBvghY4Vkm1IySl
 CjPI2YimFaZrrWp8zBVyCVihP9Ezozy6WkHw4lFaGdribciGgLljvwrjxKMJ3XOIdsS6clNvl
 moqg+ZXv8gogVuZI4zWrjjUTwj2XvRCHaqt8FpSkMTCTBzjCD6bccXNbvOxngchtX+d1+Sm85
 igj/lkJvP/Mak5Jj/RF+aybSq52R5LN7c0EVwdzPtyRH11CoY2exp1/s0UkzqtPLvU3ai+Hh5
 8Aqobtpw4/1JBaHSruNw/N9KT1HGWfZn+w6I9MCraf5aaTPc5fkxq8pmfAPEWTfsnWZqQ4fIW
 v/+aESWd+P22NXToGKKa+qg7qgZ3znrZ+gzPueEacM9sGKhdPNXlODoXyhJ4amamDnojuu4k1
 T42CiCa0dH/3fNXZVcRuaqaNH2WXtXeNx7o8MjcAoTR4+pIzn0nq66cew7shnXHu7/hi5QwKS
 floZCJCAXUYnU70tTcTa0OzZvOKFHKfehirwgbD6W85oTs0TSPG3mFL0eWyMKZS8/zimxKvSm
 Pzpe/sLUMO/fe7qzv/vSYw2NlBDNh0+/DGKSgj90m0EDrbVoKx/g1xzneaGPTAnzTf2Nlblki
 0htdevRiPcjg7QbmKWL6qPZ6q6vRi68/q21WLpDxmh7UEJxhOBkgeHOH4WJdhvBLoV1UehG/w
 LywVgT0v/2op0qFEObr/Fg6Sl91zGMpuqtkW8DcTkki5p50vwXLE6oTrbBeDH5NjHRbMTAjVs
 JwZZtgmzFUn8ZQyndMR7Uvv/PiGaZ0YReTcViLDnsSeuxHJsHts2ifCYZsECEf9Hw9VgAM/pE
 Hkr3tSgIsZ/QPWFgB
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> The system will crash when we insmod crypto/tcrypt.ko whit mode=3D38.

* I suggest to use the word =E2=80=9Cwith=E2=80=9D in this sentence.

* Will it be helpful to explain the passed mode number?


> BTW I add a check for sg_nents_for_len() its return value since
> sg_nents_for_len() function could fail.

Please reconsider also development consequences for this suggestion.
Will a separate update step be more appropriate for the addition of
an input parameter validation?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?id=3D9cb1fd0efd195590b828b9b865=
421ad345a4a145#n138

Would you like to add the tag =E2=80=9CFixes=E2=80=9D to the commit messag=
e?

Regards,
Markus
