From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [RFC PATCH 2/3] crypto: hisilicon hacv1 driver
Date: Mon, 05 Feb 2018 15:10:59 +0100
Message-ID: <25300210.7qS7PduyPT@tauon.chronox.de>
References: <20180130152953.14068-1-jonathan.cameron@huawei.com> <7706135.m10557lhAe@positron.chronox.de> <20180205140203.00007e46@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linuxarm@huawei.com,
        xuzaibo@huawei.com, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Xiongfeng Wang <xiongfeng.wang@linaro.org>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59310 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752607AbeBEOLC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Feb 2018 09:11:02 -0500
In-Reply-To: <20180205140203.00007e46@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 5. Februar 2018, 15:02:03 CET schrieb Jonathan Cameron:

Hi Jonathan,

> I could drop this for the initial submission and bring it in as an
> optimization with supporting numbers as a follow up patch.

I am not disputing the code itself. It just occurred to me that the code is 
similar to the fixed code which did not handle an SGL with a leading SG entry 
having no associated page. Thus, I thought I ask :-)

Ciao
Stephan
