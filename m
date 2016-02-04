From: Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH v2 04/10] crypto/compress: add asynchronous compression support
Date: Fri, 5 Feb 2016 01:19:29 +0900
Message-ID: <CAAmzW4OzVE0JfhCDe6+TP-cT8gv3061ER9iXt66jSRjgoSNfww@mail.gmail.com>
References: <20160127074140.GA30335@gondor.apana.org.au>
	<56A878C9.8050202@intel.com>
	<20160127080355.GA31330@gondor.apana.org.au>
	<20160127080926.GA31516@gondor.apana.org.au>
	<20160128031941.GA14467@js1304-P5Q-DELUXE>
	<20160129100901.GA17272@gondor.apana.org.au>
	<20160201021141.GA32125@js1304-P5Q-DELUXE>
	<56B2C4A7.6060106@intel.com>
	<20160204032850.GA2060@gondor.apana.org.au>
	<CAAmzW4NcXR+n5qeQh4NP7tJ-thhun_OE89WpLVAUnJ28U6n=3Q@mail.gmail.com>
	<20160204145338.GA7202@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Li, Weigang" <weigang.li@intel.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	Dan Streetman <ddstreet@ieee.org>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:36569 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbcBDQTa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Feb 2016 11:19:30 -0500
In-Reply-To: <20160204145338.GA7202@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

2016-02-04 23:53 GMT+09:00 Herbert Xu <herbert@gondor.apana.org.au>:
> On Thu, Feb 04, 2016 at 04:17:41PM +0900, Joonsoo Kim wrote:
>>
>> Do you think not to merge scomp? Please let me know your overall
>> plan about this.?
>
> I'm fine with a driver-side scomp interface.  But I'd rather
> avoid having yet another user-side compression interface in the
> form of scomp if we can avoid it.

I mentioned that there are usecases that scomp is needed for performance,
it means that we can't avoid it. Or do you think this usecase differently?
I understand it's rather pain that we have two interfaces but scomp interface
is just wrapping layer to handle various S/W compression algorithms and
implementation is not that complex. I guess it doesn't cause much
maintenance cost.

Thanks.
