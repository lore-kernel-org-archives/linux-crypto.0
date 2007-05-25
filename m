From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [1/1] HIFN: preliminary HIFN 795x driver for new async cryptoapi.
Date: Fri, 25 May 2007 11:35:32 +0200
Message-ID: <20070525093532.GA29422@Chamillionaire.breakpoint.cc>
References: <20070522125828.GB8424@2ka.mipt.ru> <20070525081417.GA26691@gondor.apana.org.au> <20070525085509.GA3808@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60321 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751342AbXEYJfe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 May 2007 05:35:34 -0400
Received: id: bigeasy by Chamillionaire.breakpoint.cc with local
	(easymta 1.00 BETA 1)
	id 1HrWCq-0007gF-43
	for linux-crypto@vger.kernel.org; Fri, 25 May 2007 11:35:32 +0200
Content-Disposition: inline
In-Reply-To: <20070525085509.GA3808@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Evgeniy Polyakov | 2007-05-25 12:55:10 [+0400]:

>Well, it is just hardware queue increase, so essentially for correct
>work it should return -EBUSY in case driver does not accept requests
>anymore (no matter if they are pushed into hardware or linked into
>backlog queue). According to sleeping with CRYPTO_TFM_REQ_MAY_BACKLOG -
>what about ipsec, where it is not allowed to sleep?

Can't you the drop packet than and hope further packets will arrive
slowly or is the packet allready ACKed and you are not allowed to lose
it?

>
>-- 
>	Evgeniy Polyakov
Sebastian
