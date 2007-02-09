From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: Asynchronus crypto API
Date: Fri, 9 Feb 2007 14:31:11 +0300
Message-ID: <20070209113108.GA11467@2ka.mipt.ru>
References: <20070209110800.GB25171@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Joerg Roedel <joerg.roedel@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:56033 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946354AbXBILcf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Feb 2007 06:32:35 -0500
Content-Disposition: inline
In-Reply-To: <20070209110800.GB25171@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Feb 09, 2007 at 12:08:00PM +0100, Joerg Roedel (joerg.roedel@amd.com) wrote:
> Background: I recently bought a HIFN crypto card and would like to use
> it under Linux without the need to use some external patchsets :)

Not for now - either use acrypto [1] or ocf [2].

Current stage in cryptoapi only supports sync interface, but having new
registration mechanism allows a bit easier implementation of different
algos, but still no async hardware is supported.

1. acrypto
http://tservice.net.ru/~s0mbre/old/?section=projects&item=acrypto

2. ocf
http://ocf-linux.sourceforge.net/

-- 
	Evgeniy Polyakov
