From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH 1/1 v8] Add CryptoAPI User Interface Support v8
Date: Fri, 21 Nov 2008 17:02:47 +0300
Message-ID: <20081121140247.GA21035@2ka.mipt.ru>
References: <DB599F406D04E34389140B7D99C71B1B0670C3FD@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, Loc Ho <lho@amcc.com>
To: Shasi Pulijala <spulijala@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.80.65]:51422 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170AbYKUOII (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Nov 2008 09:08:08 -0500
Content-Disposition: inline
In-Reply-To: <DB599F406D04E34389140B7D99C71B1B0670C3FD@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi.

On Mon, Nov 17, 2008 at 03:31:42PM -0800, Shasi Pulijala (spulijala@amcc.com) wrote:
> This patch v8 includes the code that prevents synchronous calls from freeing data when request completion is interrupted, while the data may still be accessed by the crypto code in parallel.
> From: Shasi Pulijala <spulijala@amcc.com>

Looks ok, I did not find any obvious error.

-- 
	Evgeniy Polyakov
