From: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>
Subject: Re: [PATCH 3/5] camellia: cleanup
Date: Fri, 26 Oct 2007 17:44:58 +0900 (JST)
Message-ID: <20071026.174458.497715610.takamiya@po.ntts.co.jp>
References: <200710251243.58701.vda.linux@googlemail.com>
	<200710251246.35917.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	camellia-oss@sec.ms.ntts.co.jp
To: vda.linux@googlemail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail2.ics.ntts.co.jp ([202.32.24.42]:33445 "EHLO
	mail2.ics.ntts.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbXJZJL7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Oct 2007 05:11:59 -0400
In-Reply-To: <200710251246.35917.vda.linux@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

>> Thu, 25 Oct 2007 12:46:35 +0100
>> [Subject: [PATCH 3/5] camellia: cleanup]
>> Denys Vlasenko <vda.linux@googlemail.com> wrote...

> On Thursday 25 October 2007 12:43, Denys Vlasenko wrote:
> > Hi Hervert,
> > 
> > Please review and maybe propagate upstream following patches.
> > 
> > camellia3.diff
> >     Optimize GETU32 to use 4-byte memcpy (modern gcc will convert
> >     such memcpy to single move instruction on i386).
> >     Original GETU32 did four byte fetches, and shifted/XORed those.
> 
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

Acked-by: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>

--
Noriaki TAKAMIYA
