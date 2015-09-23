From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] drivers/crypto/nx: Add CRC and validation support for
 nx842
Date: Wed, 23 Sep 2015 17:54:01 +0800
Message-ID: <20150923095401.GA20580@gondor.apana.org.au>
References: <1442707362.6178.11.camel@hbabu-laptop>
 <20150921142607.GA2405@gondor.apana.org.au>
 <CALZtONDbOxorPmy2A9FkD7rpY2HsOMaEs9Vvqg2kHh1qtM0GqA@mail.gmail.com>
 <20150922122117.GA11522@gondor.apana.org.au>
 <CALZtONBYYTnRE6FyQKVL8kyAAb8BuXJzyGA5mYNHiXtSNcDv9Q@mail.gmail.com>
 <20150922144219.GA12943@gondor.apana.org.au>
 <CALZtONCaauoG3CBnbGWfUXTU2_QXD_F0rVxzgO24VmMTLxV0og@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Haren Myneni <haren@linux.vnet.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Haren Myneni <hbabu@us.ibm.com>
To: Dan Streetman <ddstreet@ieee.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43976 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbbIWJyS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Sep 2015 05:54:18 -0400
Content-Disposition: inline
In-Reply-To: <CALZtONCaauoG3CBnbGWfUXTU2_QXD_F0rVxzgO24VmMTLxV0og@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 22, 2015 at 11:08:22AM -0400, Dan Streetman wrote:
>
> you think we should just strip out the 842-nx alignment/sizing code
> and change it to fallback to the sw driver?

Right, if the only intended user can provide aligned input then
by all means make the unaligned case use the software fallback as
there is no point in investing any effort in making it fast.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
