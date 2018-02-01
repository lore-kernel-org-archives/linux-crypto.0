From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: AF_ALG AIO - lock context IV
Date: Thu, 01 Feb 2018 11:15:48 +0100
Message-ID: <3443894.2QtSl4gYip@tauon.chronox.de>
References: <2118226.LQArbCsRu5@tauon.chronox.de> <1794487.2xX5c1mbjk@tauon.chronox.de> <CAOtvUMeLGRS-NJvf7R_J5bX1CB77htasZO0wKCU4uXeNE93Ttw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Harsh Jain <harsh@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linuxarm@huawei.com
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59118 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751749AbeBAKPu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Feb 2018 05:15:50 -0500
In-Reply-To: <CAOtvUMeLGRS-NJvf7R_J5bX1CB77htasZO0wKCU4uXeNE93Ttw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 1. Februar 2018, 11:06:30 CET schrieb Gilad Ben-Yossef:

Hi Gilad,

> 2. Pointing out that the problem solved (and rightfully so) by mutex in
> AF_ALG AIO implementation must exists elsewhere as well - for example
> IPsec, and is probably solved there too, so if we add the flag as
> suggested, it can be used there as well to gain similar benefits to what
> Jonathan is suggesting.

You are quite right. this patch could speed up things for IPSec and the disk 
encryption logic too. So I think we should CC also the IPSec folks and the 
disk crypto folks to review the patch.

Ciao
Stephan
