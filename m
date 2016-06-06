From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Unable to decrypt message
Date: Mon, 6 Jun 2016 12:17:36 +0800
Message-ID: <20160606041736.GA19710@gondor.apana.org.au>
References: <CAKJ7aR4cxqoDQXvcULgwrQyok7fbi_Cq4jTL8x=WZwd03YEbCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Gadre Nayan <gadrenayan@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46960 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbcFFERk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Jun 2016 00:17:40 -0400
Content-Disposition: inline
In-Reply-To: <CAKJ7aR4cxqoDQXvcULgwrQyok7fbi_Cq4jTL8x=WZwd03YEbCg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Gadre Nayan <gadrenayan@gmail.com> wrote:
>
> Should the Initialization vector also be the same. Since I am
> generating iv random bytes on both ends.

Yes the IV must be the same at both ends.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
