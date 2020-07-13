Return-Path: <SRS0=38jD=AY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E58E7C433E3
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jul 2020 19:31:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C18BD2068F
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jul 2020 19:31:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="ExY4rOvg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbgGMTbY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Jul 2020 15:31:24 -0400
Received: from mout.web.de ([212.227.17.11]:36337 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726339AbgGMTbX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Jul 2020 15:31:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1594668656;
        bh=gLXXElVCFe9L8OGx5jqS5sISuc3MxF1NRcjZMChZvC0=;
        h=X-UI-Sender-Class:Cc:Subject:To:From:Date;
        b=ExY4rOvgftQX93pChf4z21FD4zfMcbsTk7D6sTUq1EojCvWR+uu6cjgXOjknOjgJe
         uwNVW8lNw8XXiOsrVbzlxSJNH93V1Peh5PymfYzUNbswLLkD/dXAhU6QWFe6RyiWY7
         OTYMWI+ab/LyityibOYsSeGZw9k/bCCOHie5siTg=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.243.120.168]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MZSFY-1kPKBK2bOY-00WZoV; Mon, 13
 Jul 2020 21:30:56 +0200
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: Re: [PATCH 1/2] Crypto/chcr: Avoid some code duplication
To:     Christophe Jaillet <christophe.jaillet@wanadoo.fr>,
        linux-crypto@vger.kernel.org
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
Message-ID: <2cb65b54-5be0-7fab-546d-e7fc33621c7f@web.de>
Date:   Mon, 13 Jul 2020 21:30:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
X-Provags-ID: V03:K1:PTKt9wm2yMcV5/AP8HWn76ZSareJJunVW25ucBZFB6nhcE+VdB1
 baHLJzP2JkFhi/K+SClajPNc8ISIdCs+v++mlbbu3VJ/qSKlfoQd6nrAITt2H4As6zu6dFG
 4WAFZVMkUEqLIXtl+ea/jFt5syc7+Msut0gqQH6zj3nqz+Y2NlA+hfEF8zXv/0ySzXnrmD8
 0sKzp9LjLBa9Ye1gLoYTA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:juXzugf0VRE=:vGo8NVHLNhgXslwn9I1Bnt
 Z0Qyz0gfn2NXtNfBm4E39QaT2jhe9YqeAlFLi4hXZGWB6hlbazgS9+vH3f9OCXX2KrOaE7Mdg
 vKjamfuiaxJKf1KXIbeS2ATezVS9I7CdFFHyZ7VcQA1k5mBrdORccbJ9f7tnFE98YEQj515u9
 CbWWnk5s516iMThc2wfTTPSvCAejCgRCFUXxmf/pyI9NN9w97Im8T4CgAC6mthVEC9J1aeUR6
 +fz93GEytFvSHTF0q0UPUFEqoKUbYJb5IEV4Wkad1xa+k9sfikyNV3NxTozL9X+83DnKoSamF
 uLGyXz0BwMPTc40JnEk01FG5sn7W8f7DFXmbJQYZxOs7uVaANnguDazfMPH+GCgK+lyYMF8YE
 4LrfTF8kKlaM8GSQPzJH+P9nUS4UDhsgylJtJv9Yo4v9XXNpTusMCIpHoKIi///Xqp0I7+i1o
 EDqJybcjKTKDNej/cJcmKK5OEXuQBbL9bf7NObU+n/OCky79Ql4qGuCHgguMC3Zahhoz21cWJ
 v5NHygIhEeScQicwGa9dHKHQQSKlgx5b5ZwX4frTBzL4RKpZF5SA+gHizU08A7PIzBWGLn8xh
 xth6Dq7M6P5guDk+vCnfq5LX/5r0BtIsX0QFzTuP3ijy3jEywp7+sSfJ/RqQinoRN456rRgOT
 WfAA/21lbH2fPQ8uIAUjP8IB1TtvHCbd2ZGeO8KTBRP5/5TTWvwQBm8K7kx6geR3mqrwAMP4H
 o6oc06FKIzRD5SILMDNbkDvwrTG6X9zTDDvXzFitBHdJ5tDMrHWH1zq5ZLJ50ZCxneG1ChlOK
 votd6mkbHHmuupaWb6bC+q1AezYWmRN29F4YDFWqmVcMjHKGgs0M9rTRAOikzGARXgMBZsJoX
 XlE7Q7jzm4mq17MEw/RvdmSOViarL5Icmdsk0AJWYl4DKx/LHb+01259eiCsG6YX7uaLTypg5
 f7C4SqBX8eMjQhNuevBSTbgysk5DrU0G1wgFtlFeHZSC3cYFEQlxuBnABZn0Kz6v3bDURTuuz
 hbVcvlRLBAc7e1MuqBeR37vmI+pike4ILpzb7M2R5yH+ybi8qXqA5leac0Xn9PlDJMGsdPsQM
 q6G6Mnrh/n9IPae9q2aeQF7qUN2B64Hr/ZjsF0rHZaK+dH/M9dFbY7QqBdYS2UPRWVC256KKg
 sfdZvi81cQClqdX6FBsBWArDcu2vR7EqQAWOp8f6YnmtTKOfwYgUIC6b75bSbW4iul0gEGwwe
 Xwvy//zc9rUCaahqcMI6Q8WYipUGMN0ltjPKGdQ==
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> The error handling path of 'chcr_authenc_setkey()' is the same as this
> error handling code.

I find this change description improvable.


> So just 'goto out' as done everywhere in the function to simplify the code.

I propose to adjust jump targets a bit more for better exception handling
in this function implementation.

Regards,
Markus
