Return-Path: <SRS0=+94A=AC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58EAFC433E0
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jun 2020 10:11:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29D7A208A7
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jun 2020 10:11:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="aG7LBsT/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729719AbgFUKLA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Jun 2020 06:11:00 -0400
Received: from mout.web.de ([212.227.15.4]:41983 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729687AbgFUKLA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Jun 2020 06:11:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1592734245;
        bh=p+D6AQpitT2CYsOhHezJYTBqsp+E5HcAYLkeSqNN9pQ=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=aG7LBsT/dLUQg7J+5k696g+gDiS/yzh1RVXkWVMx0y074yP8CA0yLCuaFvGNcRxDL
         MQ0MEZy0HgvfHY/8MSXutYUdNPuL9gNaQw4UnkmPXNVrUuwmu6AoACgXcDRa2q7Xrb
         Uw693KPoc114gqnjnKlxl9rXz3g71rE48M6jHQEo=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.131.145.213]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1Mpl0r-1j5sTo1j8X-00qCIM; Sun, 21
 Jun 2020 12:10:45 +0200
To:     Gilad Ben-Yossef <gilad@benyossef.com>,
        linux-crypto@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Libo Wang <libo.wang@arm.com>, Ofir Drang <ofir.drang@arm.com>
Subject: Re: [PATCH 2/3] crypto: ccree: adapt ccree essiv support to kcapi
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <0a8aabe8-26c4-d530-9ba0-f7f177ba0afa@web.de>
Date:   Sun, 21 Jun 2020 12:10:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:XgbPbFe+CFXKgGmgnBvELpemV/dejK74IaGKBUWI8uDsfOpQLNp
 D5bigQ/FEQWuWqEmBssL9ABxGfrAM2IifeYD7GWXKaL5zHNgrlq3htjkcTDOKhiK99EW7jD
 PYFllJKTQaS1z5K01S2Cn/jAohoOKusOs+gjsE87R+DDyO6ozygbhFSi9JtowYGxjOEizJu
 L91Mi0gPogkV1yLLqeXLw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ZZ42yJARiv8=:nDxG63DqGL/LkSfSPB/eZq
 Ptp41g4891PUwNSzKo09qDxqeyZCUCC2apfZgJNJaprTdx47LQyBLkVgoGRnKWNeZHPjy532z
 61BrI1kLDJaFfHThcrr6vhvB4Ct/tYliWN82A84hV5kjw9Lt46zLmfJJDpEUB5W8etRYOEqIJ
 wZU1howyVtG1eE1SD+gzQZPGq8YJjGsEc386XbzahP4cnRE0qIv4zQnFkFbVhKsI40Iukf6fh
 x13/A1qg1NFT5vz+sS4S6CLZdGNCk7gV/SDg7LG3U8LYOIamAGS2v8dWHnUpcBDjxdIsJWTez
 k7O2ZeWF3Z61TPrVaob/XIk2aFS5kgLU5QoDxCBhkHvZGHSaB+hd9NjqSIgJozw62ogVnQRQB
 fpL6mzBrOes9SRkOGkCaosZRp+AnBa9Ula7QPh8ccfBwCDzCIb4FVxFmS4WkjWKTo2o5pwJuv
 SA2aySFsR6MRXYsmdP8nCCyOCQ3scRE7SOTSTTCDfnLi5g5G7PHmf2jxcDQJ0eHSQLTsc5MYf
 CtsCJ8vOP/QbJnrT7F6FBZkH0GRo2ysH7bsFk2hjrYhc5LKtmYquXzr+M7GveWvifKOjPoHx9
 Vkn9PGNeUf7npf7BWT3ZK1Y/irbEOQwiifknGr1hwlGfZDNRD5vMM/OmZIAxM9gE+0IJbCE++
 eK5uwORLjZKgvwj7vW/giXHjGvc+Kf6LvFUTbnkwSITKe0tmn7XbPhq6gc2iVsSmZABg5ZJSt
 ZnZzqHXWfxHdKHzrjW4kGbpWyyiamNnOYradddTsF+PaoXBSfIv5PEpy7gsMYhn07lQn3yhXK
 IRAsY7uZU2bvugbtIdhU1nQszNM0XodSJsmlReI6T9S/ot86UVD1+EOTzRVkKn8SJAw41eOZu
 dncGww3WG655kytt77OeQm4V0Lq/Xl+wFGmjTWbtq85NB2nTfdzThgVL1SSmSPM/5k0vnWVqI
 a9h8T1W2O82r/HgY3PshzD+mIVSVm6LGNzk1gRZUdR8xi71OyYBGJM6Ck6r0KYqWDgNcl2XzK
 yuOItQ4Hb/zQ/K6faxvSmYqVQvkl3dt6X3M5vsN1coqzsnDJ+lLmhbnQUE+/2XV3FeNP8ZkDe
 9myngzjAXYIqmqMtI0eMqfI33oALl+akeONTvBCbonWDHxaPJajrtQebkAAsj8DxMR908Wu9T
 LykjywJ9oG/f+w57JIdTJv8grhMAt9wq1Jfn051xRJJGeWMC9AP3oPDuFTiJz242c27fmmaRH
 PU6OcyCyf1OgC2Aqx
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

I propose to avoid a typo in the previous patch subject.


> This patch brings the ccree essiv interface into
> compliance with kernel crypto api one.

Can an imperative wording be nicer for the commit message?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?id=64677779e8962c20b580b471790fe42367750599#n151

Regards,
Markus
