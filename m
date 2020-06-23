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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71EF2C433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jun 2020 15:01:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5016B20723
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jun 2020 15:01:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="Yp0K+IOW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732840AbgFWPBi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Jun 2020 11:01:38 -0400
Received: from mout.web.de ([212.227.15.14]:46001 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732825AbgFWPBi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Jun 2020 11:01:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1592924443;
        bh=+coI3JfYNCV4UF7/JcV7kSjNGrAGQIh2FbuwBFWVxBc=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=Yp0K+IOWvTNor+CC4qAl+LlKAdRRxT4d9V3gBqHdYCYEzPgSKTnfMbMl68Ff30kqR
         DiCcr8YTnsYCycXQ0ijfkc1IQSOwzaCkKIeori7qZII4CCtXijcOtitpGS1f261coy
         sOIakVuxVElCYGQErXKBexGAJh8qT7gUiJQQ37ko=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.49.105.198]) by smtp.web.de (mrweb002
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0M7sga-1isk0Y013I-00vQWW; Tue, 23
 Jun 2020 17:00:42 +0200
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
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <16341716-aeb6-febc-441c-c1826da8c4d3@web.de>
Date:   Tue, 23 Jun 2020 17:00:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200623134442.wj4i3r3dlp6rtpaq@gilmour.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:mMKUokk8fovtqD5tghmymSY93EI4uigOGaMvcY740VBFSAg7naK
 8/OBzwNN2n8Sj1gHz/o5o+651Z91wCiQlLtRR3XmvtJ0AcV0G3ZSD6z1ofFI1pfwuqIwf4z
 qn1M8PJV8vzpOFFvGrRka7fhUxZGGIdtCCk7JzdDYiPHX/sG7zH+ZLJ3ZXsc/Jx+dzFHpTi
 TeGCxQZYrJ08KT20KFovQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:JR2i3DCHEww=:Y7DTo9RyHx2gp5N00qoaoX
 0ZzwP5W6JJlynL5gNNymCx6FMjOdM72oeRNv/DOZrFHN31Y26SHZ5WENMajILLNCfUUU48ARw
 PzSL7dACJ7ADg4W2y8DOW9hiI9Jzyke9xrlVXpnhiqgDkKZIqJ1riYspYDBC/knlwA5WQNHmD
 AdZGRRBknyZZ5Znt6h6AzLRJIIYm4RsAVmxPA+GGsz5yr1h/PrfygexOrf8psNGxpir2R7jYw
 0KQCGuZeSF1GyadtmvqSvlY/7bo5EJXftHA6ekliIVk1ljX7qVyT+KNWc1rcoAryVBWrVyWzF
 22AewpVY8415hMYHdhr47tVJPKi+L/Sh1OL7XEqr++ffUiUHH/ielPDtFXWodR+w+zwqXfW5a
 scIAFEa5tD+hie7dRVKxUnRWuxtuyUs3zXOw9Ezft11y4e1RNfU2CUGeK5P+yTeWWD5rC/sW4
 e9n7AalCV+NKOIf3Jis5OJNGKlbXA0bh6iXQAYVx2XGw46mt6+xTEXg/I58ut70+u7qNC49RW
 S7ZpgdLaC4+HIFfA2Ii8nzCveIig9lm96mNTwiXKObsvfd9Wn7DmuMIIM8krVYEIdnEdnFpUH
 l5peSd5jHF/G/BTBSEQeZx21djiqr6SEzwAXjdoKd/kgLZFd+HDLtoRNe3MbKHNIKqvPasaHo
 LeHT1O0eLhgGASNp6m87RbhpUYIRNeAJpxWQ+m972zVXgwEm6dNnMF+qyRbjKpTvRdQa/zyJU
 FxTxUx+gIOID6kYUKnfNHvDZBlNAxHeiPHhOCvM/owm79c6U8NQc1R6lV4CQ9lUagpmbzUg18
 8EnIkdDurDz9NFewB4h2wupfx7OoqHd1sQY0SdrImrihe9gB42cl4VeOJwx7BOPy3O48p1LBH
 S1jOeg13wftJcQcqsgcxIp/kikP8TgujYOZ4m2Rl4NGilx2bW4JCMNBXh0Ox3E5qcCXFJztW6
 pcXyeKmrO6l5k0anzMflsVHgkIcDUKDiI+/bGQj200IJP+RKGkUM7ksBXiWl47XPnZ9nbQF9p
 pWvtOdPntdezTDWbSgtU9RS9XlaRtlHqmSjCB9nJatoYOsZiE0Xtq+avbWmsI4vZgY54qI8oP
 aTp+RqttBNIzp3w3b/ebQ9V72keeJ3/Pbs8fhThOY6cEnf6i2gx4vkJ4CsczWyXEgcb3DFnEt
 1CbquSdxuFkLwHPmARjtBUGxweOuNt4ASHjnu/r3oaa9gXWJgulVcpyF/mLisfkp3uvmMyMFU
 e7aoPYrmYy53YiTwQ
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

>>> Fix this by =E2=80=A6
>>
>> Please replace the beginning of this sentence with the tag =E2=80=9CFix=
es=E2=80=9D.
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/Documentation/process/submitting-patches.rst?id=3D625d3449788f85569096780=
592549d0340e9c0c7#n183
>
> No, not really. The comment you (partially) quoted explains how the
> issue is fixed, your suggestion explains what commit introduced the fix
> in the first place. They are both beneficial, but there's strictly no
> reason to remove the former for the latter.

Do you care to improve this change description another bit?

Regards,
Markus
