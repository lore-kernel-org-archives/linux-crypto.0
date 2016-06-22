From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v10 2/3] crypto: kpp - Add DH software implementation
Date: Wed, 22 Jun 2016 18:03:41 +0800
Message-ID: <20160622100341.GA30383@gondor.apana.org.au>
References: <1466541931-2875-1-git-send-email-salvatore.benedetto@intel.com>
 <1466541931-2875-3-git-send-email-salvatore.benedetto@intel.com>
 <20160622005115.GB27134@gondor.apana.org.au>
 <309B30E91F5E2846B79BD9AA9711D03193664C@IRSMSX102.ger.corp.intel.com>
 <20160622064047.GA29318@gondor.apana.org.au>
 <309B30E91F5E2846B79BD9AA9711D0319366BB@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: "Benedetto, Salvatore" <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51957 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbcFVKDs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 06:03:48 -0400
Content-Disposition: inline
In-Reply-To: <309B30E91F5E2846B79BD9AA9711D0319366BB@IRSMSX102.ger.corp.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 22, 2016 at 08:18:42AM +0000, Benedetto, Salvatore wrote:
>
> If I have to pack the secret into a bytestream, where do you expect the endianness
> of the sizes to be handled? If I understood you correctly I'll pack them in little endian,
> but when decoding I have to take that into account. Wouldn't that result in pointless
> endianness management in the decode functions?

It is not pointless if it means that we can have a single test
function like most other types.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
