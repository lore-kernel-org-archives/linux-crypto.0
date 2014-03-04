From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH 0/3] take 2: repurposing blkcipher walk api for aead
Date: Tue, 4 Mar 2014 15:53:38 +0800
Message-ID: <20140304075337.GA10810@gondor.apana.org.au>
References: <1393910920-5796-1-git-send-email-ard.biesheuvel@linaro.org>
 <20140304074627.GA10695@gondor.apana.org.au>
 <CAKv+Gu9A6PEVE47a3xERzo3J10OP3Qvd3cNFQwWsGkNKwVFchw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:52161 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291AbaCDHxm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 4 Mar 2014 02:53:42 -0500
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9A6PEVE47a3xERzo3J10OP3Qvd3cNFQwWsGkNKwVFchw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 04, 2014 at 03:51:11PM +0800, Ard Biesheuvel wrote:
> 
> Is there anything else required before you can take these patches?
> Note that the first one should go through the arm64 tree, and may need
> further review on the arm list as well, but for the first two, it is
> completely up to you.

OK I'll take the first two right now.  You can add my ack to the
last patch for arm.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
