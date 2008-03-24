From: "Loc Ho" <lho@amcc.com>
Subject: User Space API for CryptoAPI
Date: Mon, 24 Mar 2008 16:54:16 -0700
Message-ID: <0CA0A16855646F4FA96D25A158E299D6043EDC6C@SDCEXCHANGE01.ad.amcc.com>
References: <20080220202543.3209.47410.stgit@jazz.citi.umich.edu> <20080324131204.GA7324@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: <linux-crypto@vger.kernel.org>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sdcmail01-ext1.amcc.com ([198.137.200.72]:33621 "EHLO
	sdcmail01.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbYCXXyR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Mar 2008 19:54:17 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20080324131204.GA7324@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

Is there an user space API driver wrap around Linux CryptoAPI? I notice
there is OCF-Linux which has an user interface that works with OpenSSL.
It seems to use Linux CryptoAPI if there is no hardware offload with
OCF. In addition, there is a fellow which developed cryptodev patch
around Linux CryptoAPI but it is limited and doesn't support everything
and not compatible with OpenSSL. Are there anything else? 

-Loc
