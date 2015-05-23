From: Dan Streetman <ddstreet@ieee.org>
Subject: Re: [PATCH] crypto: move Kconfig 842 to end of list, default to N
Date: Fri, 22 May 2015 20:35:40 -0400
Message-ID: <CALZtONC-BxmutKoao7o1Lj5ufMaAx4nFHpvBeDKaip5gB-v1Kw@mail.gmail.com>
References: <1432339708-4340-1-git-send-email-ddstreet@ieee.org> <20150523003405.GA12622@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "David S. Miller" <davem@davemloft.net>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:36359 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757034AbbEWAgB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 May 2015 20:36:01 -0400
In-Reply-To: <20150523003405.GA12622@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 22, 2015 at 8:34 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Fri, May 22, 2015 at 08:08:28PM -0400, Dan Streetman wrote:
>> Move the 842 compression alg choice to last in the list, so it's
>> not in the middle of LZO/LZ4/LZ4HC.  Change its default to N, as it
>> is a very slow alg, which generally should only be used with
>> compression hardware that's capable of doing it much faster.
>>
>> Signed-off-by: Dan Streetman <ddstreet@ieee.org>
>
> The default default is "n" so this is redundant.

ah ok. never mind then! :-)

>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
