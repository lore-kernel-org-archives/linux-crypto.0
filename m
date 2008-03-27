From: "Loc Ho" <lho@amcc.com>
Subject: User Space API handling of large buffer
Date: Thu, 27 Mar 2008 14:50:47 -0700
Message-ID: <0CA0A16855646F4FA96D25A158E299D604466B38@SDCEXCHANGE01.ad.amcc.com>
References: <20080220202543.3209.47410.stgit@jazz.citi.umich.edu> <20080324131204.GA7324@gondor.apana.org.au> <0CA0A16855646F4FA96D25A158E299D6043EDC6C@SDCEXCHANGE01.ad.amcc.com> <20080325030723.GA12830@gondor.apana.org.au> <20080325122656.GA15675@2ka.mipt.ru> <0CA0A16855646F4FA96D25A158E299D6043EDDC3@SDCEXCHANGE01.ad.amcc.com> <20080326214821.GA4066@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sdcmail01-ext1.amcc.com ([198.137.200.72]:41402 "EHLO
	sdcmail01.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757619AbYC0Vus convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Mar 2008 17:50:48 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20080326214821.GA4066@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

While creating user space API for Linux Crypto, I have a problem with
large buffer. I am look for suggestion as to how to handle large user
buffer greater than PAGE_SIZE. In the event, call issues an operation
with data larger than PAGE_SIZE, must I create an array of page size
scatterlist? Or can I using just one scatterlist entry? 

Would Linux allocates non-continuous memory but use TLB to make them
look continous when calling kmalloc?

-Loc
