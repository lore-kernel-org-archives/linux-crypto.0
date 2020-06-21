Return-Path: <SRS0=+94A=AC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC7A0C433DF
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jun 2020 13:15:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B5AF206F1
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jun 2020 13:15:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="Q+6/+Ny6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730092AbgFUNPm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Jun 2020 09:15:42 -0400
Received: from mout.web.de ([212.227.15.14]:59859 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730071AbgFUNPl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Jun 2020 09:15:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1592745328;
        bh=kNDqV4Y9iwk4ngQtcCZhjKxwK0e3ASAnQOTNbokvWxQ=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=Q+6/+Ny6ZDNhNNPgf2vFDkPjfLDo+5bgIUEGoAYtTFueHi2vI9LuNfUOJG4hRVJUd
         4ivLvFVUluq9fNZ8DRgCH1/m+T5/uERQZu/9mTty1PkTb1toxjM9r9NAnRpOaJjtG8
         Bnaiz5T8pagQy1vimZmpTlM+2PB9y/4ntT2pCWKc=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.131.145.213]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1M1aE3-1jjxoh31jv-0038HX; Sun, 21
 Jun 2020 15:15:28 +0200
Subject: Re: [PATCH v2 2/3] crypto: ccree: adapt ccree essiv support to kcapi
To:     Gilad Ben-Yossef <gilad@benyossef.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Libo Wang <libo.wang@arm.com>, Ofir Drang <ofir.drang@arm.com>
References: <20200621112000.31495-1-gilad@benyossef.com>
 <20200621112000.31495-3-gilad@benyossef.com>
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
Message-ID: <53ec2baa-eada-0fa4-2c91-082ab4a21901@web.de>
Date:   Sun, 21 Jun 2020 15:15:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200621112000.31495-3-gilad@benyossef.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:uuR1KvMfvfSyH1HhtsetqM565HoIkSTeUhdS0WdiuNe1xk4l8pe
 X1lp3B7wrpf6SFS3eEInpxfW5BAq1hOQjciut/3m9X8dnu7rDJivyfYPvVQxg94rN4sfCb+
 imqdiXiOEWGe/JtKTGTuPjJe8hLTb2liYiMYpT1SY19omRKiQNl9LKzGRa9EdpPX0Q2YUUC
 mhyfvMRVADCFlSVNvScgQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:RFOvZ8fLRTY=:kC7WzlDTyP39ml6reA9Zxv
 VtuNkIu5bH/tZbFsDx+gkpu8PwwiDHag3IC6kXkZK1UgBV6BNN0BL4eX3ftv9AYJsK4RqYsML
 VFBNIW2ZIu3QVJtIPGyfPE8kHlk7pp5MzZ88kLrX51oH6vwqpy3ip384fpONIzZPBKEOe7STL
 khcKiYG2mZr6h5ejEByQRlPVTV+NcenYoLE0gAy5+RKa2W1BvWvr1u7TEyH3ePuhaBpQ9QaXv
 ZaGTd4gdsaPrxdMg2ZZXtGCNaXbGU0WjvIQD0CtuvwWcKr1mrnYdxGKmGBzwVw+xAFEpXQtBO
 W+ddKGslhh+I7lrYch3irPivOkmfcBowoVZck3kb2R/QEJTZAtAEtd5w+KoTLK5z1m93wtqWg
 gjMfF4z42E3b7rjP/zwn0wScojyAIKrxzCL9sT3BxAeQyi08Oxc4i5phVpWImy/pYt7oDksZW
 va1jioWTga9K8zZgtqwVQoK2QHHkMhjE5FoOrzexUkqsF8rSBAtsDXBBcLsIpOuMikxG6CU7u
 FCvMo7RPs18JPANbEtKUiY37wLiDItc54R0Zyw4kC3DlCTy6eVqWHh+musdad4jF8t+axZYpH
 tMRJBZDoqpqIfcXpZddCcye5IASgkLyaBr3vd7i0+NZCajs8uD+Xy7pZOm6VfVau0sk+wieyZ
 IwdCzLadYNnKqk8SKLe4raztji0m7MgXD+ez12HiUVqNaCP7K/cGIhRt/kg4L35b6DWQWMlij
 b2XQx6CE+IKkCkvRIFnCtndEd4Ea8qx8YL4UyWGZPwNOs5okUPLdpnbRyP++sVsLGZ4MEnchb
 eKZNlB9f7y8I2FNRk731S1Fp9h2KByn24a0mRd/dEyb7jYmoAkMt6Ytchs5y3jna7ROyu8ggi
 fPucRwFopuZkcVThXIIOuNEU6jgZSkZqvubBvJigFEGwa7kjfFmil4I6bgFV7rEsDZQkPDbYw
 36DbN6K3P7q6oALr/6oxwjwSy8v8WW17cEHVigfd27fxkZ6FClz5YSi+TuNSnsqLafBmHmDd4
 aF2CAgopvHZ5zkAT8K65hBk7KgsOscI/aMRd2ZOdfSoPg0hu56Vx+4kYLaW1IUyVOPt3ImlU2
 CeYhiP8MuqQ3ubrJEBiiRDGUehFSga27N+6M0x2WCzk01rHTWSm674esWZl/LhdnoKO2X2MWB
 r60E81xpwpgLsMUb1+PwgtLBv+B1uxwYSs4NfxUL41A4LSUMuXdU0LlpAYX/tdOriuPBqpKZ/
 scJ9uOo9m6URm41pk
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> Brings the ccree essiv interface =E2=80=A6

Wording adjustments:
Bring the =E2=80=A6


> also use a fallback if requested a smaller key size.

=E2=80=A6 fallback if a smaller key size was requested.

Regards,
Markus
