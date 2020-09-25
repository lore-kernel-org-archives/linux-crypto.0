Return-Path: <SRS0=J/bj=DC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F32AFC4727F
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Sep 2020 08:11:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F34F2087D
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Sep 2020 08:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbgIYILh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Sep 2020 04:11:37 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:53174 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727395AbgIYILg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Sep 2020 04:11:36 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kLior-00071V-BS; Fri, 25 Sep 2020 18:11:06 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 25 Sep 2020 18:11:05 +1000
Date:   Fri, 25 Sep 2020 18:11:05 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     =?utf-8?B?5ZGo55Cw5p2wIChaaG91IFlhbmppZSk=?= 
        <zhouyanjie@wanyeetech.com>
Cc:     arnd@arndb.de, gregkh@linuxfoundation.org, mpm@selenic.com,
        robh+dt@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        hadar.gat@arm.com, geert+renesas@glider.be, krzk@kernel.org,
        wahrenst@gmx.net, masahiroy@kernel.org, tmaimon77@gmail.com,
        rdunlap@infradead.org, qianweili@huawei.com,
        daniel.thompson@linaro.org, xuzaibo@huawei.com,
        olivier.sobrie@silexinsight.com, dongsheng.qiu@ingenic.com,
        aric.pzqi@ingenic.com, rick.tyliu@ingenic.com,
        yanfei.li@ingenic.com, sernia.zhou@foxmail.com,
        zhenwenjin@gmail.com
Subject: Re: [PATCH 0/2] Add support for the TRNG in Ingenic X1830.
Message-ID: <20200925081105.GA6381@gondor.apana.org.au>
References: <20200913161021.120226-1-zhouyanjie@wanyeetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200913161021.120226-1-zhouyanjie@wanyeetech.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 14, 2020 at 12:10:19AM +0800, 周琰杰 (Zhou Yanjie) wrote:
> 1.Add the TRNG bindings for the X1830 SoC from Ingenic.
> 2.Add X1830 SoC digital true random number generator driver.
> 
> 周琰杰 (Zhou Yanjie) (2):
>   dt-bindings: RNG: Add Ingenic TRNG bindings.
>   crypto: Ingenic: Add hardware TRNG for Ingenic X1830.
> 
>  .../devicetree/bindings/rng/ingenic,trng.yaml      |  43 ++++++
>  drivers/char/hw_random/Kconfig                     |  14 ++
>  drivers/char/hw_random/Makefile                    |   1 +
>  drivers/char/hw_random/ingenic-trng.c              | 161 +++++++++++++++++++++
>  4 files changed, 219 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rng/ingenic,trng.yaml
>  create mode 100644 drivers/char/hw_random/ingenic-trng.c

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
