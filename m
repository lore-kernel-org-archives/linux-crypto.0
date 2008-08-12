From: "Shasi Pulijala" <spulijala@amcc.com>
Subject: RE: [PATCH 1/1 v1] Add CryptoAPI PKA Support
Date: Mon, 11 Aug 2008 17:55:18 -0700
Message-ID: <DB599F406D04E34389140B7D99C71B1B05E540D6@SDCEXCHANGE01.ad.amcc.com>
References: <DB599F406D04E34389140B7D99C71B1B05D9E03B@SDCEXCHANGE01.ad.amcc.com> <20080810104304.GC4526@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: <linux-crypto@vger.kernel.org>, "Loc Ho" <lho@amcc.com>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sdcmail02-ext1.amcc.com ([198.137.200.73]:7052 "EHLO
	sdcmail02.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbYHLAzs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Aug 2008 20:55:48 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20080810104304.GC4526@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

 
Hi,
 
>Could you please tell us why we need this at all? For instance, what hardware devices will be supported and who will be the users?

[Shasi Pulijala]
The Public Key Acceleration Engine is an integral HW Offload module for many of our AMCC 4xx SOC's. And hence providing a PKA user interface through the linux Crypto API would give us a good option to validate and test our HW. 

>No, multiplexed interfaces are bad in general.  Please provide separate interfaces for each operation.
[Shasi Pulijala]
Would you be suggesting like a transform per operation(per add, sub etc) or a single transform for all the operations and multiple request interfaces for each of them.
 
>You should also post a software implementation so that

>1) You illustrate what this is all about.
>2) We have a yardstick for the hardware devices.

[Shasi Pulijala]
We do not have enough resources at this time to provide the Software Implementation, but sure can come up with something at a later time.

-Shasi
