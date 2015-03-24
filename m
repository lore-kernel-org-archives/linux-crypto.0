From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCHv2] arm: crypto: Add optimized SHA-256/224
Date: Tue, 24 Mar 2015 22:35:02 +1100
Message-ID: <20150324113502.GE11405@gondor.apana.org.au>
References: <20150316154835.GA31336@google.com>
 <20150323135009.GB820@google.com>
 <CAKv+Gu8qcVVTqy6Fd8PMA8ZTxiMssKz+TbMQW=fAhCBpUH2jTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sami Tolvanen <samitolvanen@google.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Andy Polyakov <appro@openssl.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:47981 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbbCXLfL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 Mar 2015 07:35:11 -0400
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8qcVVTqy6Fd8PMA8ZTxiMssKz+TbMQW=fAhCBpUH2jTw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 23, 2015 at 07:26:03PM +0100, Ard Biesheuvel wrote:
> (resending due to size bounce)

Aha that's why the patch didn't make it through.  Can it be split
up?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
