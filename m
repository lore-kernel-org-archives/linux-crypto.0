From: Martin Willi <martin@strongswan.org>
Subject: Re: crypto: chacha20poly1305 - Convert to new AEAD interface
Date: Thu, 16 Jul 2015 18:12:41 +0200
Message-ID: <1437063161.2912.7.camel@martin>
References: <20150716043508.GA9441@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sitav-80046.hsr.ch ([152.96.80.46]:43955 "EHLO
	mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336AbbGPQMo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Jul 2015 12:12:44 -0400
In-Reply-To: <20150716043508.GA9441@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert,

> This patch converts rfc7539 and rfc7539esp to the new AEAD interface.
> The test vectors for rfc7539esp have also been updated to include
> the IV.

Thanks for taking care of it, I haven't found the time yet to do it
myself. I can confirm that it works fine under IPsec load, so you may
add my:

Tested-by: Martin Willi <martin@strongswan.org>

Regards
Martin
