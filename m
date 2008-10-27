From: "Loc Ho" <lho@amcc.com>
Subject: RE: [PATCH 1/1 v7] Add Crypto API User Interface Support
Date: Mon, 27 Oct 2008 10:04:23 -0700
Message-ID: <0CA0A16855646F4FA96D25A158E299D6053E6528@SDCEXCHANGE01.ad.amcc.com>
References: <1224786829-32405-1-git-send-email-spulijala@amcc.com> <DB599F406D04E34389140B7D99C71B1B064CADB6@SDCEXCHANGE01.ad.amcc.com> <0CA0A16855646F4FA96D25A158E299D6053E62E9@SDCEXCHANGE01.ad.amcc.com> <DB599F406D04E34389140B7D99C71B1B064CB159@SDCEXCHANGE01.ad.amcc.com> <20081024210755.GB26930@ioremap.net> <0CA0A16855646F4FA96D25A158E299D6053E6363@SDCEXCHANGE01.ad.amcc.com> <20081025135035.GA22426@ioremap.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Cc: "Shasi Pulijala" <spulijala@amcc.com>,
	"Herbert Xu" <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>
To: "Evgeniy Polyakov" <zbr@ioremap.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sdcmail02.amcc.com ([198.137.200.73]:7022 "EHLO
	sdcmail02.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbYJ0REb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 27 Oct 2008 13:04:31 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20081025135035.GA22426@ioremap.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

>> I don't understand what you are referring to here. Let's assume that operation is submitted synchronously to >>cryptodev, cryptodev in turn will submit to the underlying driver. If the underlying driver is software based, >>it will completed synchronous and return without calling wait_for_completion. If the underlying driver is >>hardware based or asynchronous, it will wait for completion via the callback function signaling the event wait >>object. Now, let's assume that operation is submitted asynchronously to cryptodev, crypto in turn will submit >>to the underlying driver. If the underlying driver is software based and completed, it just return. If the >>underlying driver is asynchronous such as hardware, it will return immediately without waiting. CryptoDev will >>call the AIO callb
 ack function when the crypto driver call cryptodev callback function. Therefore, what is the >>issue?
>>
>With async driver crypto_ablkcipher_encrypt() (and other crypto
>processing functions)  will return immediately (with
>-EINPROGRESS return value in case of HIFN driver for example),
>but your code will wait for request completion at
>wait_for_completion_interruptible() point.

[Loc Ho]
Yes... This is the exact behavior that we wanted for synchronous user space application. As Linux CryptoDev support two interfaces - asynchronous and synchronous. If the user space application wants its operations to be synchronous (by calling vector write), then Linux CryptoDev musts complete the required operation synchronously. An example of this type of application is the current OpenSSL. If the application wants to take full capabilities of the Linux CryptoDev, then it should use AIO interface instead. In this case, we will return immediately as well. When the operation is completely, Linux CryptoDev will perform the necessary step to notify the caller (via AIO framework).

-Loc
