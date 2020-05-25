Return-Path: <SRS0=4LZm=7H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAEE8C433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 25 May 2020 06:30:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0E3C207DA
	for <linux-crypto@archiver.kernel.org>; Mon, 25 May 2020 06:30:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="bYFkPCKo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388631AbgEYGa6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 May 2020 02:30:58 -0400
Received: from mout.web.de ([212.227.15.14]:50863 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730230AbgEYGa6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 May 2020 02:30:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1590388230;
        bh=/9wdd84b0g/HMv7RXAUNfPCz7+7xvBghiVydVXUx/Do=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=bYFkPCKohKalPBvVtSGg/IyepEKh6g87eNjk5i8Bthsxcdnuz2J3JXF3L/LuFrrx6
         drWJgMmpdpsjGAHBMCn3/7JAF5v4iUUObHc2Pd/yOylJFMZ67Va0ef5UzGbFWVfIDF
         l325C1PY0e2qpBxQhd73DJwRX5hHhNR7IzzP7gvU=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.135.186.124]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MSav6-1jVIck20Yu-00RXNc; Mon, 25
 May 2020 08:30:30 +0200
To:     longpeng2@huawei.com, linux-crypto@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     Arei Gonglei <arei.gonglei@huawei.com>,
        Corentin Labbe <clabbe@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] crypto: virtio: Fix use-after-free in
 virtio_crypto_skcipher_finalize_req()
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <a5ef5d51-e35c-983f-8e7f-5f19552abe9e@web.de>
Date:   Mon, 25 May 2020 08:30:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:VpT8RmlK7bFo+DOwudvu5JNO6USiDs8hkfQYz79/Sk+bIDV6cDj
 Dkr6wSQ0zk+ZGXLQIMD+abbTYszW6IH+nL+npKo1/eofVyPciPgMLEHbJBQOPz4KjlpL1Wj
 Fap4Jv4Hc+CCG5C53QTK24FJ5o8tJnfpS4MVrxGcROtQim8x/PQIKmcECw2q5VuyA7+/vjs
 Qg/TKsEOl1nN71UR9yWUg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:hDZsTX06wJ0=:QI4dWr01mdXggwDu7dDYa2
 hysYAVgzxDRgYnwhkbsU3NsAWZlCoHgva5ooWoUtkagJo7W572O5XDH544Xwtrt4T9NQ/ctaw
 q/2J8HY9ZDJYMNsJxa0s/DSpaAhwfcIHwAOqhmvvRUoBPkpe3l/K6j5XuuTE7Zz0vkIqUb71G
 OjxL8UEEjKffnQ3A+S+brVKEWpOXFc+UEr55pqd3uFP+T8wO5/fv2tl2OAk6P25NtIshr7FTO
 04kY7b7PtSaScT3RsTB/h+r/qnFq7kA7eRSuajlm89CJbVz7v54XV1HTn1D8A4qMMvqa4Y5Kf
 M8/D6niqRaG1jzkQV+crYyiM1KE1KA7VFAHD9lAExcWjFdAZEoO3cwAG8v6p3J6tL05bBkk7y
 pwPjJvOJCcsKDQKp1o4H/vRyEtQxfGb3K5+UNb6/wyCwwVKB9Yx4Oj3l10goAoVQ4bXCTb7FC
 67rAvGa8jRbTJgyBM3qan8gmo+BAetxfzZsn5LGoCvLx5F736Y5coX+b/BL8jrX8BPtLMfzTt
 SnT5TeVZDNFzxWzCcMXXt2JIHRem98poteEsKXfwXv9R2NMv55yKO1dE6ekdUzdwM1oY/R+Zl
 Nc2aFkxe5rqgDJkA5Jklv0Pdv8vH0aGlyj/8dAeulb2GP8XexC1Hu6pIJ7pk/Ny3q8iQb6MKq
 QwshlKBWhw8Ap6xqrlGeuH+3TMBBb4MOn15t4YxevwGPPk3t9jPufttuv9UOgOGNBRFHChias
 NIrIzD8c3td5cYBsrApotu2qM/sceoTRxseIxx1egGMHFp/5v7JK5N72m9SMcC9tbAermY4IJ
 bEHzEBAIXpiE+NIexmKUe4LQz2CXtnjDze1tCYDrWbp+D5hj+Qko+pRVwFVHOaKMk30TZIVTb
 G2jq/7AVK6CMMskl/7Ohq2t+L4HaEft7exODTjI8tL1IkMNA0OoNs6CMaOxIegCjitdKqjOX/
 D/2s10mfG1YyrxqI4KVI4kfQlTfb+zmp7G/xF7SgjxEiu5MhbCsQX2b5sjzDnttR8UaKqsEFA
 9+axxj0XtTkUfvBmgip0XyVKd5fXTUUQqV0sfq000cciFJ3fOxEQl11u9Aj95CB5HqRYJ46W9
 TG7w2giu7IwTLaK80Hqd3EE+vX65eVpBRFHeJi6RjcX2aKN859DtBubjRSVEu+/YtziUL2n29
 +YQ5CgUOxGZWGKvOCNlurqBB6bJQu50Z+G2/3x1in5jvMc+VNGibpajZKXKraJ0Y7+x0dmSzj
 ngQaDTH3sEQEqy1he
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> =E2=80=A6 So the system will crash
> at last when this memory be used again.

I would prefer a wording with less typos here.


> We can free the resources before calling ->complete to fix this issue.

* An imperative wording can be nicer.
  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/=
Documentation/process/submitting-patches.rst?id=3D9cb1fd0efd195590b828b9b8=
65421ad345a4a145#n151

* You proposed to move a call of the function =E2=80=9Ccrypto_finalize_skc=
ipher_request=E2=80=9D.
  How does this change fit to the mentioned position?

* Would you like to add the tag =E2=80=9CFixes=E2=80=9D to the commit mess=
age?

Regards,
Markus
