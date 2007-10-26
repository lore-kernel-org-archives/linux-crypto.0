From: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>
Subject: Re: [PATCH 2/5] camellia: cleanup
Date: Fri, 26 Oct 2007 17:44:20 +0900 (JST)
Message-ID: <20071026.174420.719893157.takamiya@po.ntts.co.jp>
References: <200710251243.58701.vda.linux@googlemail.com>
	<200710251245.42880.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	camellia-oss@sec.ms.ntts.co.jp
To: vda.linux@googlemail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail2.ics.ntts.co.jp ([202.32.24.42]:33511 "EHLO
	mail2.ics.ntts.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbXJZJMV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Oct 2007 05:12:21 -0400
In-Reply-To: <200710251245.42880.vda.linux@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

>> Thu, 25 Oct 2007 12:45:42 +0100
>> [Subject: [PATCH 2/5] camellia: cleanup]
>> Denys Vlasenko <vda.linux@googlemail.com> wrote...

> On Thursday 25 October 2007 12:43, Denys Vlasenko wrote:
> > Hi Hervert,
> > 
> > Please review and maybe propagate upstream following patches.
> > 
> > camellia2.diff
> >     Rename some macros to shorter names: CAMELLIA_RR8 -> ROR8,
> >     making it easier to understand that it is just a right rotation,
> >     nothing camellia-specific in it.
> >     CAMELLIA_SUBKEY_L() -> SUBKEY_L() - just shorter.
> > 
> >     Move be32 <-> cpu conversions out of en/decrypt128/256 and into
> >     camellia_en/decrypt - no reason to have that code duplicated twice.
> 
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

Acked-by: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>

--
Noriaki TAKAMIYA
