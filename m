From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCHv2] arm: crypto: Add optimized SHA-256/224
Date: Tue, 24 Mar 2015 22:46:06 +1100
Message-ID: <20150324114606.GA11744@gondor.apana.org.au>
References: <20150316154835.GA31336@google.com>
 <20150323135009.GB820@google.com>
 <CAKv+Gu8qcVVTqy6Fd8PMA8ZTxiMssKz+TbMQW=fAhCBpUH2jTw@mail.gmail.com>
 <20150324113502.GE11405@gondor.apana.org.au>
 <CAKv+Gu9RtkorW1qiX4xohxDYQ-SfbFnY0NgeiXCxdZ1xx6SA9w@mail.gmail.com>
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
Received: from ringil.hengli.com.au ([178.18.16.133]:35111 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbbCXLqS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 Mar 2015 07:46:18 -0400
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9RtkorW1qiX4xohxDYQ-SfbFnY0NgeiXCxdZ1xx6SA9w@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 24, 2015 at 12:40:50PM +0100, Ard Biesheuvel wrote:
>
> Not so easily. It consists (among other things) of a .pl file that
> generates a .S file, but to prevent introducing a build time
> dependency on perl, the .S file is included as a .S_shipped file. That
> is the big one.
> 
> i suppose we could add the .S_shipped file in a separate patch, but
> I'd prefer to keep it as is

OK then this will have to go up on a website somewhere and then
the URL can be posted to the list for review.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
