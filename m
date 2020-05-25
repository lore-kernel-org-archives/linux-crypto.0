Return-Path: <SRS0=4LZm=7H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80886C433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 25 May 2020 07:36:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 542502073B
	for <linux-crypto@archiver.kernel.org>; Mon, 25 May 2020 07:36:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="LOONeXda"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389060AbgEYHgu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 May 2020 03:36:50 -0400
Received: from mout.web.de ([212.227.15.14]:54773 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388947AbgEYHgu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 May 2020 03:36:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1590392175;
        bh=iT/gUwaQaqpVOkJUsfa0h7grUSdC7vPh/BmrUkNL7Co=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=LOONeXdasncb8scIBtkcSCT49xRV/hWYYO9JGEHy59O3ErTo5pPykSN7K1YUUAbZc
         g0/6lCo81+PNU1BMWzRRFl20tcOH6z1use2DAwSlUDkPkxHcSCtKB0bmAyUdjTX11u
         PqtFowuKV9ifpV+fbOM8laWJppXsg8D01f7fM6Q8=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.135.186.124]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MbQbk-1jMYAt00gO-00IhhJ; Mon, 25
 May 2020 09:36:15 +0200
Subject: Re: [2/2] crypto: virtio: Fix use-after-free in
 virtio_crypto_skcipher_finalize_req()
To:     Longpeng <longpeng2@huawei.com>, linux-crypto@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     Arei Gonglei <arei.gonglei@huawei.com>,
        Corentin Labbe <clabbe@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
References: <a5ef5d51-e35c-983f-8e7f-5f19552abe9e@web.de>
 <a17850bb-f70d-1f77-3823-afd70816ce57@huawei.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 mQINBFg2+xABEADBJW2hoUoFXVFWTeKbqqif8VjszdMkriilx90WB5c0ddWQX14h6w5bT/A8
 +v43YoGpDNyhgA0w9CEhuwfZrE91GocMtjLO67TAc2i2nxMc/FJRDI0OemO4VJ9RwID6ltwt
 mpVJgXGKkNJ1ey+QOXouzlErVvE2fRh+KXXN1Q7fSmTJlAW9XJYHS3BDHb0uRpymRSX3O+E2
 lA87C7R8qAigPDZi6Z7UmwIA83ZMKXQ5stA0lhPyYgQcM7fh7V4ZYhnR0I5/qkUoxKpqaYLp
 YHBczVP+Zx/zHOM0KQphOMbU7X3c1pmMruoe6ti9uZzqZSLsF+NKXFEPBS665tQr66HJvZvY
 GMDlntZFAZ6xQvCC1r3MGoxEC1tuEa24vPCC9RZ9wk2sY5Csbva0WwYv3WKRZZBv8eIhGMxs
 rcpeGShRFyZ/0BYO53wZAPV1pEhGLLxd8eLN/nEWjJE0ejakPC1H/mt5F+yQBJAzz9JzbToU
 5jKLu0SugNI18MspJut8AiA1M44CIWrNHXvWsQ+nnBKHDHHYZu7MoXlOmB32ndsfPthR3GSv
 jN7YD4Ad724H8fhRijmC1+RpuSce7w2JLj5cYj4MlccmNb8YUxsE8brY2WkXQYS8Ivse39MX
 BE66MQN0r5DQ6oqgoJ4gHIVBUv/ZwgcmUNS5gQkNCFA0dWXznQARAQABtCZNYXJrdXMgRWxm
 cmluZyA8TWFya3VzLkVsZnJpbmdAd2ViLmRlPokCVAQTAQgAPhYhBHDP0hzibeXjwQ/ITuU9
 Figxg9azBQJYNvsQAhsjBQkJZgGABQsJCAcCBhUICQoLAgQWAgMBAh4BAheAAAoJEOU9Figx
 g9azcyMP/iVihZkZ4VyH3/wlV3nRiXvSreqg+pGPI3c8J6DjP9zvz7QHN35zWM++1yNek7Ar
 OVXwuKBo18ASlYzZPTFJZwQQdkZSV+atwIzG3US50ZZ4p7VyUuDuQQVVqFlaf6qZOkwHSnk+
 CeGxlDz1POSHY17VbJG2CzPuqMfgBtqIU1dODFLpFq4oIAwEOG6fxRa59qbsTLXxyw+PzRaR
 LIjVOit28raM83Efk07JKow8URb4u1n7k9RGAcnsM5/WMLRbDYjWTx0lJ2WO9zYwPgRykhn2
 sOyJVXk9xVESGTwEPbTtfHM+4x0n0gC6GzfTMvwvZ9G6xoM0S4/+lgbaaa9t5tT/PrsvJiob
 kfqDrPbmSwr2G5mHnSM9M7B+w8odjmQFOwAjfcxoVIHxC4Cl/GAAKsX3KNKTspCHR0Yag78w
 i8duH/eEd4tB8twcqCi3aCgWoIrhjNS0myusmuA89kAWFFW5z26qNCOefovCx8drdMXQfMYv
 g5lRk821ZCNBosfRUvcMXoY6lTwHLIDrEfkJQtjxfdTlWQdwr0mM5ye7vd83AManSQwutgpI
 q+wE8CNY2VN9xAlE7OhcmWXlnAw3MJLW863SXdGlnkA3N+U4BoKQSIToGuXARQ14IMNvfeKX
 NphLPpUUnUNdfxAHu/S3tPTc/E/oePbHo794dnEm57LuuQINBFg2+xABEADZg/T+4o5qj4cw
 nd0G5pFy7ACxk28mSrLuva9tyzqPgRZ2bdPiwNXJUvBg1es2u81urekeUvGvnERB/TKekp25
 4wU3I2lEhIXj5NVdLc6eU5czZQs4YEZbu1U5iqhhZmKhlLrhLlZv2whLOXRlLwi4jAzXIZAu
 76mT813jbczl2dwxFxcT8XRzk9+dwzNTdOg75683uinMgskiiul+dzd6sumdOhRZR7YBT+xC
 wzfykOgBKnzfFscMwKR0iuHNB+VdEnZw80XGZi4N1ku81DHxmo2HG3icg7CwO1ih2jx8ik0r
 riIyMhJrTXgR1hF6kQnX7p2mXe6K0s8tQFK0ZZmYpZuGYYsV05OvU8yqrRVL/GYvy4Xgplm3
 DuMuC7/A9/BfmxZVEPAS1gW6QQ8vSO4zf60zREKoSNYeiv+tURM2KOEj8tCMZN3k3sNASfoG
 fMvTvOjT0yzMbJsI1jwLwy5uA2JVdSLoWzBD8awZ2X/eCU9YDZeGuWmxzIHvkuMj8FfX8cK/
 2m437UA877eqmcgiEy/3B7XeHUipOL83gjfq4ETzVmxVswkVvZvR6j2blQVr+MhCZPq83Ota
 xNB7QptPxJuNRZ49gtT6uQkyGI+2daXqkj/Mot5tKxNKtM1Vbr/3b+AEMA7qLz7QjhgGJcie
 qp4b0gELjY1Oe9dBAXMiDwARAQABiQI8BBgBCAAmFiEEcM/SHOJt5ePBD8hO5T0WKDGD1rMF
 Alg2+xACGwwFCQlmAYAACgkQ5T0WKDGD1rOYSw/+P6fYSZjTJDAl9XNfXRjRRyJSfaw6N1pA
 Ahuu0MIa3djFRuFCrAHUaaFZf5V2iW5xhGnrhDwE1Ksf7tlstSne/G0a+Ef7vhUyeTn6U/0m
 +/BrsCsBUXhqeNuraGUtaleatQijXfuemUwgB+mE3B0SobE601XLo6MYIhPh8MG32MKO5kOY
 hB5jzyor7WoN3ETVNQoGgMzPVWIRElwpcXr+yGoTLAOpG7nkAUBBj9n9TPpSdt/npfok9ZfL
 /Q+ranrxb2Cy4tvOPxeVfR58XveX85ICrW9VHPVq9sJf/a24bMm6+qEg1V/G7u/AM3fM8U2m
 tdrTqOrfxklZ7beppGKzC1/WLrcr072vrdiN0icyOHQlfWmaPv0pUnW3AwtiMYngT96BevfA
 qlwaymjPTvH+cTXScnbydfOQW8220JQwykUe+sHRZfAF5TS2YCkQvsyf7vIpSqo/ttDk4+xc
 Z/wsLiWTgKlih2QYULvW61XU+mWsK8+ZlYUrRMpkauN4CJ5yTpvp+Orcz5KixHQmc5tbkLWf
 x0n1QFc1xxJhbzN+r9djSGGN/5IBDfUqSANC8cWzHpWaHmSuU3JSAMB/N+yQjIad2ztTckZY
 pwT6oxng29LzZspTYUEzMz3wK2jQHw+U66qBFk8whA7B2uAU1QdGyPgahLYSOa4XAEGb6wbI FEE=
Message-ID: <cbd8ab27-71c3-2fb0-2fa3-263901596773@web.de>
Date:   Mon, 25 May 2020 09:36:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <a17850bb-f70d-1f77-3823-afd70816ce57@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:oTWbkHStfC2cQW/NMtlSYrAIONHigj1GRezaeL0VyuGZM4c5DhR
 PL9U+RZp/dcuvYFPKJFdyHAAhPXtGy818oxHL5G7hTudw3qG2MKlNXvn/dDsB0gTm1AHvM5
 kwDkwgzL4U+2GrfVckrD+n5SmC6pHOXX37tEjZJV9AHBwcyvDEdMgsPVD4CteMol35wyjQS
 2T2I2Nw/fTyET5zcGDcnw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Fpy6EEp9PD8=:OpUONRHDhGJHD1KUkD1WA5
 xTv8DmFKxjW4LQA1UvGmvOAkCaO/IXOyy/TyDITCf0XSxqrZpe8IkrZ20CPJwBDspAQmstX93
 VT7/6vdcOcYAYVLxBWPm2uEihYaYjgKMA0wlKb4LTvvbFX7qGS/JN/I+0BaUVYytGQrIr2uLr
 YsrafNumODuzhBoue8C3a0ZCSMSQifxgxDVAk9Q7e4dIpodeK4gJikK9KbjNaYYdmonhk6NgA
 M8ivym1tpR1TvsK5+Nj/UgH09taZPCOaWh4MsOI5ub6eUA1fwTAyuL6WJaQRVGrMwDjxbUrMn
 4PviEFSGRtcvYMHA8StTanbr0HX1YbyHIBpu3v/4hZDF0vOpf11XiTvIKMtsBPl/VXcRB/byt
 QTzQ5uPrTvZ5dy+RIb+s7hJzuZJNM6Ud9HKCPYA40/vluC2nlXulr5cav1bqrHjROKWSY6fF7
 u/QcBvCJHgkWEkte/nYf7g/cyVVTg7t9KB7NFPQAKiqdFmfqGRbEOlJoXaT1PxdeY80KSyqFC
 OTviKY5gqYkF2Z+++oIJsFTcKPHI6EXhRfHy5EbHWGt80b+VwJBvQX7B+f7nPvkX2oLnO6olH
 EWC2XMxjJ/qoctwDhtW9FUwIQSdyglQofUlDiZG2cXMJmd5WCL/Rxl8fsALY5JhPz+Lv4InuS
 k0nZd35K+m1AB8mHnu59I7ZSJGy1HGcEulKjQS3H7nd6xU69ZHclmQJS/ZNigx1j0gO2WCmYK
 pYh5zMvY7j8oSRx9pQUtP4SzZfLuSXl+u7zWX2CJ08pcEtavUgwgh1qxbVPE5V9DIjrXxh+tT
 tdKC43grpeQYy7vtwnBriy2JGA9cL/iSLJLZSnGogGg9vg4BPW6gZjYZAOXsLJqpaZPd1uA+W
 ijemlewkADX5ckaeivQ0Qa3DMr2tGNlTgRiJStyYRcErJirbp1ssNvJ8lzCiDgr5u5XxsKzQQ
 IS6oOqAzpPf/pJEPxb7En1Zio/ezILLIWuwsWRw/q23dy0aw2HSOz+2z0+Chx1JHMfuXE7hFi
 apxUkYnDwM03BP1dgQFn8UgGSuW/935wB5ufgi93qkFmFbE67e0TAmVDw25PJsUyyMCR1TGjX
 xMmqdO5H8xT4AVNDRpc0uhKJgyBWoTsxlbByB9jiRttnqF4EjB9bD5NZdjYHjqm9+6OFijMls
 OXFkRp1NEy7vpMx7JAvFuTS/SWpjPU5Fwxm38kXGMSDGedwZYiQWJycydO3GceBcqCe1SQbBj
 +8PIcK21kKAE/0cfs
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> Could you help me to make the sentence better?

How do you think about a wording variant like the following?

  So the system will crash when this memory will be used again.


>> * You proposed to move a call of the function =E2=80=9Ccrypto_finalize_=
skcipher_request=E2=80=9D.
>>   How does this change fit to the mentioned position?
>>
> The resources which need to be freed is not used anymore, but the pointe=
rs
> of these resources may be changed in the function
> "crypto_finalize_skcipher_request", so free these resources before call =
the
> function is suitable.

Another alternative:
  The resources which need to be cleaned up are not used any more.
  But the pointers of these resources may be changed in the
  function =E2=80=9Ccrypto_finalize_skcipher_request=E2=80=9D.
  Thus release specific resources before calling this function.

Regards,
Markus
