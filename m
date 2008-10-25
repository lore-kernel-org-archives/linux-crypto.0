From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [PATCH 1/1 v7] Add Crypto API User Interface Support
Date: Sat, 25 Oct 2008 17:50:35 +0400
Message-ID: <20081025135035.GA22426@ioremap.net>
References: <1224786829-32405-1-git-send-email-spulijala@amcc.com> <DB599F406D04E34389140B7D99C71B1B064CADB6@SDCEXCHANGE01.ad.amcc.com> <0CA0A16855646F4FA96D25A158E299D6053E62E9@SDCEXCHANGE01.ad.amcc.com> <DB599F406D04E34389140B7D99C71B1B064CB159@SDCEXCHANGE01.ad.amcc.com> <20081024210755.GB26930@ioremap.net> <0CA0A16855646F4FA96D25A158E299D6053E6363@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Shasi Pulijala <spulijala@amcc.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Loc Ho <lho@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cet.com.ru ([195.178.208.66]:55531 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752861AbYJYNui (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 25 Oct 2008 09:50:38 -0400
Content-Disposition: inline
In-Reply-To: <0CA0A16855646F4FA96D25A158E299D6053E6363@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi.

On Fri, Oct 24, 2008 at 03:16:52PM -0700, Loc Ho (lho@amcc.com) wrote:
> I don't understand what you are referring to here. Let's assume that operation is submitted synchronously to cryptodev, cryptodev in turn will submit to the underlying driver. If the underlying driver is software based, it will completed synchronous and return without calling wait_for_completion. If the underlying driver is hardware based or asynchronous, it will wait for completion via the callback function signaling the event wait object. Now, let's assume that operation is submitted asynchronously to cryptodev, crypto in turn will submit to the underlying driver. If the underlying driver is software based and completed, it just return. If the underlying driver is asynchronous such as hardware, it will return immediately without waiting. CryptoDev will call the AIO callback function wh
 en the crypto driver call cryptodev callback function. Therefore, what is the issue?

With async driver crypto_ablkcipher_encrypt() (and other crypto
processing functions)  will return immediately (with
-EINPROGRESS return value in case of HIFN driver for example),
but your code will wait for request completion at
wait_for_completion_interruptible() point.

-- 
	Evgeniy Polyakov
