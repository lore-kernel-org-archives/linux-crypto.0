From: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>
Subject: Re: crypto: nx - Fix reentrancy bugs
Date: Wed, 8 Jul 2015 10:46:31 -0300
Message-ID: <20150708134630.GA7214@bluepex.com>
References: <20150707093025.GA31368@gondor.apana.org.au>
 <20150707184837.GA9341@bluepex.com>
 <20150707221047.GA7655@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>,
	pfsmorigo@linux.vnet.ibm.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:38055 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933378AbbGHNqi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jul 2015 09:46:38 -0400
Received: from /spool/local
	by e24smtp04.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <leosilva@linux.vnet.ibm.com>;
	Wed, 8 Jul 2015 10:46:36 -0300
Received: from d24relay02.br.ibm.com (d24relay02.br.ibm.com [9.13.184.26])
	by d24dlp01.br.ibm.com (Postfix) with ESMTP id 05BB93520064
	for <linux-crypto@vger.kernel.org>; Wed,  8 Jul 2015 09:45:30 -0400 (EDT)
Received: from d24av03.br.ibm.com (d24av03.br.ibm.com [9.8.31.95])
	by d24relay02.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t68Dj65o54132770
	for <linux-crypto@vger.kernel.org>; Wed, 8 Jul 2015 10:45:07 -0300
Received: from d24av03.br.ibm.com (localhost [127.0.0.1])
	by d24av03.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t68DkXBR016481
	for <linux-crypto@vger.kernel.org>; Wed, 8 Jul 2015 10:46:33 -0300
Content-Disposition: inline
In-Reply-To: <20150707221047.GA7655@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> PS it would appear that you can make this completely reentrant
> by moving all the data from the tfm into the reqeust.  Could you
> work on this and remove the spinlock completely?

Yes.

Thank you!
