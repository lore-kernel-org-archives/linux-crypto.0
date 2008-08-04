From: "Loc Ho" <lho@amcc.com>
Subject: RE: [PATCH 1/1 v4] Add CryptoAPI User Interface Support
Date: Mon, 4 Aug 2008 10:43:13 -0700
Message-ID: <0CA0A16855646F4FA96D25A158E299D604CB04AE@SDCEXCHANGE01.ad.amcc.com>
References: <0CA0A16855646F4FA96D25A158E299D604CAFC9B@SDCEXCHANGE01.ad.amcc.com> <20080804142143.GA21120@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
	"Shasi Pulijala" <spulijala@amcc.com>,
	<linux-crypto@vger.kernel.org>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sdcmail02-ext1.amcc.com ([198.137.200.73]:63095 "EHLO
	sdcmail02.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbYHDRnR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Aug 2008 13:43:17 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20080804142143.GA21120@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

>
>What does prevent from simultaneous command execution? Or setkey() vs.
>run() race? Do you rely on BKL which 'guards' ioctl execution? How is
>->write() protected from ioctl()?
>

We wasn't plan on protecting this. It is the caller responsibity to call in the proper order. If the caller want to change the key, it musts do so before issue run or after all run operations completed. Actually, I think it is better if we drop setkey. If the caller want to operate on a different key, create another transform. Are you concern that the underlying driver might have problem handling key change?

Sync (ioctl) and Async (AIO) are not meant to be use concurrently. But if the caller issus both, I believe this shouldn't be a problem. Do you see a problem?

-Loc
