From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2 4/4] crypto: add CRYPTO_TFM_REQ_PARALLEL flag
Date: Wed, 07 Feb 2018 17:25:19 +0100
Message-ID: <3566380.RG3SDDhjom@tauon.chronox.de>
References: <2118226.LQArbCsRu5@tauon.chronox.de> <2396074.YQ3hgbV6mL@tauon.chronox.de> <20180207161412.00007bbe@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Harsh Jain <harsh@chelsio.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linuxarm@huawei.com
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59426 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754138AbeBGQZV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Feb 2018 11:25:21 -0500
In-Reply-To: <20180207161412.00007bbe@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 7. Februar 2018, 17:14:12 CET schrieb Jonathan Cameron:

Hi Jonathan,

> Actually those were fine on the basis that inline iv is
> obvious enough, it was CRYPTO_TFM_REQ_PARALLEL that
> was causing me confusion.
> 
> Sorry, wasn't terribly clear on that!

Ok, I will add some comments around that new REQ flag.

Ciao
Stephan
