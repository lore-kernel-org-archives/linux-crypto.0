From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH -next] crypto: drbg - fix error return code
Date: Sat, 20 Aug 2016 21:13:26 +0200
Message-ID: <16945364.yku3VmKOzu@positron.chronox.de>
References: <1471705611-19309-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:37138 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751510AbcHTTNe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 20 Aug 2016 15:13:34 -0400
In-Reply-To: <1471705611-19309-1-git-send-email-weiyj.lk@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Samstag, 20. August 2016, 15:06:51 CEST schrieb Wei Yongjun:

Hi Wei,

> Fix to return a negative error code from the error handling
> case instead of 0.
> 
> Signed-off-by: Wei Yongjun <weiyj.lk@gmail.com>

Acked-by: Stephan Mueller <smueller@chronox.de>

Ciao
Stephan
