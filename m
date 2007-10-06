From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [1/1 take 2] HIFN 795x driver.
Date: Sat, 6 Oct 2007 23:58:57 +0200
Message-ID: <20071006215857.GB3645@Chamillionaire.breakpoint.cc>
References: <20071002150013.GA6023@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:38004 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764290AbXJFV7A (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 6 Oct 2007 17:59:00 -0400
Content-Disposition: inline
In-Reply-To: <20071002150013.GA6023@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Evgeniy Polyakov | 2007-10-02 19:00:13 [+0400]:

>+MODULE_LICENSE("GPL");
>+MODULE_AUTHOR("Evgeniy Polyakov <johnpol@2ka.mipt.ru>");
>+MODULE_DESCRIPTION("Driver for HIFN 795x crypto accelerator chip.");

Please also add MODULE_ALIAS for algos (that was aes, des and 3des as
far as I remember).

Sebastian
