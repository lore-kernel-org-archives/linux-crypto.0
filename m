From: Dan Streetman <ddstreet@ieee.org>
Subject: Re: [PATCH] drivers/crypto/nx: Add CRC and validation support for nx842
Date: Thu, 24 Sep 2015 08:32:52 -0400
Message-ID: <CALZtONDtmumecqDehV2LXODme5JTTgAD9Gt48F-abGwKYP67fQ@mail.gmail.com>
References: <1442707362.6178.11.camel@hbabu-laptop> <20150921142607.GA2405@gondor.apana.org.au>
 <CALZtONDbOxorPmy2A9FkD7rpY2HsOMaEs9Vvqg2kHh1qtM0GqA@mail.gmail.com>
 <20150922122117.GA11522@gondor.apana.org.au> <CALZtONBYYTnRE6FyQKVL8kyAAb8BuXJzyGA5mYNHiXtSNcDv9Q@mail.gmail.com>
 <20150922144219.GA12943@gondor.apana.org.au> <CALZtONCaauoG3CBnbGWfUXTU2_QXD_F0rVxzgO24VmMTLxV0og@mail.gmail.com>
 <20150923095401.GA20580@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Haren Myneni <haren@linux.vnet.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Haren Myneni <hbabu@us.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:36414 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243AbbIXMdc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 24 Sep 2015 08:33:32 -0400
In-Reply-To: <20150923095401.GA20580@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 23, 2015 at 5:54 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Sep 22, 2015 at 11:08:22AM -0400, Dan Streetman wrote:
>>
>> you think we should just strip out the 842-nx alignment/sizing code
>> and change it to fallback to the sw driver?
>
> Right, if the only intended user can provide aligned input then
> by all means make the unaligned case use the software fallback as
> there is no point in investing any effort in making it fast.

ok sounds good.  thanks!

>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
