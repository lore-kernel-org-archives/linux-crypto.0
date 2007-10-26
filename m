From: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>
Subject: Re: [PATCH 4/5] camellia: de-unrolling
Date: Fri, 26 Oct 2007 17:45:29 +0900 (JST)
Message-ID: <20071026.174529.596524432.takamiya@po.ntts.co.jp>
References: <200710251243.58701.vda.linux@googlemail.com>
	<200710251247.16843.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	takamiya@po.ntts.co.jp
To: vda.linux@googlemail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail2.ics.ntts.co.jp ([202.32.24.42]:33472 "EHLO
	mail2.ics.ntts.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbXJZJMH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Oct 2007 05:12:07 -0400
In-Reply-To: <200710251247.16843.vda.linux@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

>> Thu, 25 Oct 2007 12:47:16 +0100
>> [Subject: [PATCH 4/5] camellia: de-unrolling]
>> Denys Vlasenko <vda.linux@googlemail.com> wrote...

> On Thursday 25 October 2007 12:43, Denys Vlasenko wrote:
> > Hi Hervert,
> > 
> > Please review and maybe propagate upstream following patches.
> > 
> > camellia4.diff
> >     Move huge unrolled pieces of code (3 screenfuls) at the end of
> >     128/256 key setup routines into common camellia_setup_tail(),
> >     convert it to loop there.
> >     Loop is still unrolled six times, so performance hit is very small,
> >     code size win is big.
> 
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
> --
> vda
Acked-by: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>

--
Noriaki TAKAMIYA
