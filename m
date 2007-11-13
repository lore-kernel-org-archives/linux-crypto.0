From: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>
Subject: Re: [PATCH 5/5] camellia: de-unrolling, 64bit-ization
Date: Tue, 13 Nov 2007 15:07:02 +0900 (JST)
Message-ID: <20071113.150702.628183529.takamiya@po.ntts.co.jp>
References: <20071106142314.GE24423@gondor.apana.org.au>
	<200711071322.52630.vda.linux@googlemail.com>
	<20071108133019.GD17186@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Cc: vda.linux@googlemail.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail2.ics.ntts.co.jp ([202.32.24.42]:53516 "EHLO
	mail2.ics.ntts.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbXKMGIE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Nov 2007 01:08:04 -0500
In-Reply-To: <20071108133019.GD17186@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

  Sorry for late reply

>> Thu, 8 Nov 2007 21:30:20 +0800 頃、
>> [Subject: Re: [PATCH 5/5] camellia: de-unrolling, 64bit-ization] において、
>> Herbert Xu <herbert@gondor.apana.org.au>さんが書きました....

> On Wed, Nov 07, 2007 at 01:22:52PM +0000, Denys Vlasenko wrote:
> >
> > *I* am happy with 5% speed sacrifice. I'm afraid other people won't be.
> 
> I'd like to hear the opinion of the author.
> 
> Takamiya-san, what do you think about this change?

  For IPsec processing, I think performance is important.

  If this fix improves the performance, it is acceptable.

  But, there are many duplicate decralations between camellia.c and
  camellia_64.c...
  (e.g., CAMELLIA_MIN_KEY_SIZE and so on)

  Regards,

--
Noriaki TAKAMIYA
