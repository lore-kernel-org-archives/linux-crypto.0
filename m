From: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>
Subject: Re: [camellia-oss:00952] Re: [PATCH 5/5] camellia: de-unrolling,
 64bit-ization
Date: Tue, 13 Nov 2007 15:25:45 +0900 (JST)
Message-ID: <20071113.152545.859492002.takamiya@po.ntts.co.jp>
References: <200711071322.52630.vda.linux@googlemail.com>
	<20071108133019.GD17186@gondor.apana.org.au>
	<20071113.150702.628183529.takamiya@po.ntts.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: vda.linux@googlemail.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail2.ics.ntts.co.jp ([202.32.24.42]:54001 "EHLO
	mail2.ics.ntts.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbXKMG0o (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Nov 2007 01:26:44 -0500
In-Reply-To: <20071113.150702.628183529.takamiya@po.ntts.co.jp>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

  sorry, again.

>> Tue, 13 Nov 2007 15:07:02 +0900 (JST) 
>> [Subject: [camellia-oss:00952] Re: [PATCH 5/5] camellia: de-unrolling, 64bit-ization] 
>> Noriaki TAKAMIYA <takamiya@po.ntts.co.jp> wrote...

> > I'd like to hear the opinion of the author.
> > 
> > Takamiya-san, what do you think about this change?
> 
>   For IPsec processing, I think performance is important.
> 
>   If this fix improves the performance, it is acceptable.

  I misunderstood the meaning. If this fix decreases the performance,
  I wouldn't prefer this patch(and the below is also one of the
  reason).

>   But, there are many duplicate decralations between camellia.c and
>   camellia_64.c...
>   (e.g., CAMELLIA_MIN_KEY_SIZE and so on)

  Regards,

--
Noriaki TAKAMIYA
