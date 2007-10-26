From: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>
Subject: Re: [PATCH 1/5] camellia: cleanup
Date: Fri, 26 Oct 2007 17:43:48 +0900 (JST)
Message-ID: <20071026.174348.424246239.takamiya@po.ntts.co.jp>
References: <200710251243.58701.vda.linux@googlemail.com>
	<200710251245.04132.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	camellia-oss@sec.ms.ntts.co.jp
To: vda.linux@googlemail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail2.ics.ntts.co.jp ([202.32.24.42]:33533 "EHLO
	mail2.ics.ntts.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbXJZJMb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Oct 2007 05:12:31 -0400
In-Reply-To: <200710251245.04132.vda.linux@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

>> Thu, 25 Oct 2007 12:45:04 +0100
>> [Subject: [PATCH 1/5] camellia: cleanup]
>> Denys Vlasenko <vda.linux@googlemail.com> wrote...

> On Thursday 25 October 2007 12:43, Denys Vlasenko wrote:
> > Hi Hervert,
> > 
> > Please review and maybe propagate upstream following patches.
> > 
> > camellia1.diff:
> >     Move code blocks around so that related pieces are closer together:
> >     e.g. CAMELLIA_ROUNDSM macro does not need to be separated
> >     from the rest of the code by huge array of constants.
> > 
> >     Remove unused macros (COPY4WORD, SWAP4WORD, XOR4WORD[2])
> > 
> >     Drop SUBL(), SUBR() macros which only obscure things.
> >     Same for CAMELLIA_SP1110() macro and KEY_TABLE_TYPE typedef.
> > 
> >     Remove useless comments:
> >     /* encryption */ -- well it's obvious enough already!
> >     void camellia_encrypt128(...)
> > 
> >     Combine swap with copying at the beginning/end of encrypt/decrypt.
> 
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

Acked-by: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>

--
Noriaki TAKAMIYA
