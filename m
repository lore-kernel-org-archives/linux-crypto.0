From: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>
Subject: Re: [PATCH 5/5] camellia: de-unrolling, 64bit-ization
Date: Fri, 26 Oct 2007 17:45:55 +0900 (JST)
Message-ID: <20071026.174555.957835159.takamiya@po.ntts.co.jp>
References: <200710251243.58701.vda.linux@googlemail.com>
	<200710251248.29746.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	camellia-oss@sec.ms.ntts.co.jp
To: vda.linux@googlemail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail2.ics.ntts.co.jp ([202.32.24.42]:33550 "EHLO
	mail2.ics.ntts.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbXJZJND (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Oct 2007 05:13:03 -0400
In-Reply-To: <200710251248.29746.vda.linux@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

>> Thu, 25 Oct 2007 12:48:29 +0100
>> [Subject: [PATCH 5/5] camellia: de-unrolling, 64bit-ization]
>> Denys Vlasenko <vda.linux@googlemail.com> wrote...

> On Thursday 25 October 2007 12:43, Denys Vlasenko wrote:
> > Hi Hervert,
> > 
> > Please review and maybe propagate upstream following patches.
> > 
> > camellia5.diff
> >     Use alternative key setup implementation with mostly 64-bit ops
> >     if BITS_PER_LONG >= 64. Both much smaller and much faster.
> > 
> >     Unify camellia_en/decrypt128/256 into camellia_do_en/decrypt.
> >     Code was similar, with just one additional if() we can use came code.
> > 
> >     If CONFIG_CC_OPTIMIZE_FOR_SIZE is defined,
> >     use loop in camellia_do_en/decrypt instead of unrolled code.
> >     ~5% encrypt/decrypt slowdown.
> > 
> >     Replace (x & 0xff) with (u8)x, gcc is not smart enough to realize
> >     that it can do (x & 0xff) this way (which is smaller at least on i386).
> > 
> >     Don't do (x & 0xff) in a few places where x cannot be > 255 anyway:
> >         t0 = il >> 16; v = camellia_sp0222[(t1 >> 8) & 0xff];
> >     il16 is u32, (thus t1 >> 8) is one byte!
> 
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
> --
> vda
Acked-by: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>

--
Noriaki TAKAMIYA
