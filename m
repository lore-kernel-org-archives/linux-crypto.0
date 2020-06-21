Return-Path: <SRS0=+94A=AC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C50BC433E0
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jun 2020 13:35:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5EB222CF8
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jun 2020 13:35:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="m7F031/l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729954AbgFUNfo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Jun 2020 09:35:44 -0400
Received: from mout.web.de ([212.227.15.4]:37105 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729676AbgFUNfn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Jun 2020 09:35:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1592746528;
        bh=32EHmNT2W6hWhT/oG2ZIm+o9q2WdVg5h20rHxrEe0H4=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=m7F031/lxeRjJJdGlAymP1eaIF6Fkj2CRKkTIM/NtE5WFbTfUiruiniZj3Q4n/4iw
         1YNDLwfNNGh0e4pV1Xx89rWP1R5OE6SqKRkd6ybiACETjaTavbKSpIFhw0Kj7UVMoC
         gbmnEHrtZWLPNnvjgK1rDAeS0zd0E1wcsBCIeob0=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.131.145.213]) by smtp.web.de (mrweb002
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LeLin-1j5xoI42O5-00qASH; Sun, 21
 Jun 2020 15:35:28 +0200
Subject: Re: [PATCH v2 1/3] crypto: ccree: fix resource leak on error path
To:     Gilad Ben-Yossef <gilad@benyossef.com>,
        linux-crypto@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ofir Drang <ofir.drang@arm.com>
References: <20200621112000.31495-1-gilad@benyossef.com>
 <20200621112000.31495-2-gilad@benyossef.com>
 <2857f54e-e752-0555-f43a-a451f64f6302@web.de>
 <CAOtvUMcVHfhiY=f0RutGWkQXPiWy_8e4QQ_ytgv5m=h+gg0bqA@mail.gmail.com>
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
Message-ID: <ae426611-51b9-4a0c-b733-ca962f19bc3b@web.de>
Date:   Sun, 21 Jun 2020 15:35:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CAOtvUMcVHfhiY=f0RutGWkQXPiWy_8e4QQ_ytgv5m=h+gg0bqA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
X-Provags-ID: V03:K1:+rff4gUemAuTUKHU5RGyvcXuu0y/9AemWwMNHicvpSUXxpaR4eR
 WAJC++WZo+vLnhDe/XEjKi3ccMoPTEns8RZ23Ygwak+89AXtXaDVJiW+O37u148FQBa+hdp
 Sld30xUE2hvpQZ1kDx1OQSdZXj96OXLCJVEtUrXXYewipoD/mE22Hg6tkeqFMztfWlii7bN
 9W6PSUFIFC+6vtQ+V8p1g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:3+6F3uL7ers=:Ussc9A3lk4cr2qEl9Gb4H/
 ZN7+sukuRS78POsHhkWMSbDMijLYWRi9n/c/dL/Yk/HlTSS4DUGJh5f+qvDqPAe5SDw1aGNB9
 Mt4BaceXBP4xeHBaeH5xNe2IqaBstUmEOpZp4zHlz/eiNz38Vx1XclHE+LsCRgiRJiT50zYwH
 IGQniT+JjjogIVItc/xeQNoxckXAvS17EWZQ0DwMGdPMJIIpZa9kn3T+EnSXD/gqR4lbUxOa3
 /PdCTf8cuO7CM/zm/2kQE/AuTn2fG7qL0LkmMktsqYd5+O1WZpynq6AzEGLLHDYxTBgsAx6Ru
 4KYX/aVKL56LtnkiVEc7CWQVVGsHHnd5TWnWpBvBZ7N+GWWFXMnvqYLcNAJrL0rk/+v/4OpCL
 4XWkG8fuvGywx6DtZAzQB7db52JkWIcl5K6cojOt9LW+E82HNtzjJtxW3PhsC7JN21KwWnpAm
 mfYkJPy10nhCKkRDXV35jBFmS/+g0iE4FeYH2bKuxqeDXPVXnC1QZCL/FWyv5bzQFtY9mCIhI
 N9loGUA0cxVxW2rUZAEApk7Ajn7wdmzpk6j4nT3WQiJZ2NBcf+RlSCxsBPHI2VP6kY6fyWjxN
 fmKCo7HlpgdJ6/CBwQ1kFT1viFMJiG23FeeNKbG0fRX3tvFUYZubAZa6OKX5MyfzCZVEmoLvJ
 213D4hfsRCM/n7f6pVcya+GF9xbEptzfQV5HD9kCNR5WPG3rWQnpGmmimovFkdiYj5kGreOw5
 KEPkp7xG8ZBlvRzQxAE1o8kYOYKv64GOaRNSalyABreZxvtRGofDDLDkRVBXk7LaFF9nuUK64
 ZcHtye6oT6kUzgz08D6V0CDI36EAXHy3LpPyjrcifUA+1Foevoy4pCSNuhQs7suERt/Tcfx2n
 COJVOkVcQ+0jLBqKDOnzNOyz8TjMfeY7KpHiTInK7AvmHWArhZn5YQyQbbsRE10Wn4cFQv2ZH
 X1TH4NLvAt5mtdTwc5AtXR3siU8oNKnotcRZ/+V0iIuGs8yr5w3GOBfmIe1dIANdL9n7E76+8
 FIGZ78D3TFbsbg0nbHjQJ4vLoGHYS7vs2NixdfqRLphSOxG5TtjyyFwJQLq7Q+sxGUgcWydsl
 euRbB7dt+hfueRuC6HdRY3daQBTn6pSaYMNxiIs+O3dLCqFQaHBPaI0l5vVJ39lF7sDVemh7A
 pMYXcqwIyEKlMOC0nruFIbjlBu4p5a3k5i0/xr03s1FwG3M83Pd9Lxe36266bfxlZfiPtAHM1
 XhdaYgXHsvo/1BpUj
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> Indeed and I did but for some reason I cannot fathom the cover letter
> did not make it to the list.

Now it seems that I have got a questionable impression because you chose
to send only two messages from this patch series also to my email address directly.

[PATCH 0/3] fixes and update to essiv support
https://lkml.org/lkml/2020/6/21/67

Will any fine-tuning trigger further consequences?

Regards,
Markus
