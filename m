From: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>
Subject: Re: [PATCH] [XFRM] Camellia: fixed to add compat name for Camellia.
Date: Mon, 21 May 2007 11:44:15 +0900 (JST)
Message-ID: <20070521.114415.432839959.takamiya@po.ntts.co.jp>
References: <20061018.161749.782295638.takamiya@po.ntts.co.jp>
	<20070516.165231.783376564.takamiya@po.ntts.co.jp>
	<20070516091856.GA21695@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
	camellia-oss@sec.ms.ntts.co.jp
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail2.ics.ntts.co.jp ([202.32.24.42]:34895 "EHLO
	mail2.ics.ntts.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbXEUCph (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 20 May 2007 22:45:37 -0400
In-Reply-To: <20070516091856.GA21695@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

  Sorry for late reply.

>> Wed, 16 May 2007 19:18:56 +1000
>> [Subject: Re: [PATCH] [XFRM] Camellia: fixed to add compat name for Camellia.]
>> Herbert Xu <herbert@gondor.apana.org.au> wrote...

> Actually this was deliberate.  The compat name only exists so that
> existing users aren't broken.  New users should always configure
> it with the full name, that is, "cbc(camellia)".

  Thank you for clarification.

> Is there a case where this is difficult?

  As you said, ipsec-tools(setkey) won't have such problem. I think of
  the user who uses iproute(ip).

  Now, 2.6.21 is going to be shipped in Fedora Core7. So the user of
  Camellia on the FC7 must use keyword "cbc(camellia)" with iproute.

  I know it is my miss, but I hope this fix mamkes the configuration
  to be more easy by using iproute.

  Regards,

P.S.
  I don't know how many users use iproute to set IPsec:-).

--
Noriaki TAKAMIYA
