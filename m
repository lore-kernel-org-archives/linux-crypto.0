From: Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: Re: [PATCH] crypto: 842 - remove .cra_list initialization
Date: Wed, 29 Aug 2012 17:12:49 -0500
Message-ID: <503E93E1.3070408@linux.vnet.ibm.com>
References: <20120829203725.6424.60519.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Robert Jennings <rcj@linux.vnet.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:59020 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753853Ab2H2WNB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Aug 2012 18:13:01 -0400
Received: from /spool/local
	by e3.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <sjenning@linux.vnet.ibm.com>;
	Wed, 29 Aug 2012 18:12:59 -0400
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id D54A1C90041
	for <linux-crypto@vger.kernel.org>; Wed, 29 Aug 2012 18:12:51 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q7TMCpEF109636
	for <linux-crypto@vger.kernel.org>; Wed, 29 Aug 2012 18:12:51 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q7TMCoxq009995
	for <linux-crypto@vger.kernel.org>; Wed, 29 Aug 2012 19:12:51 -0300
In-Reply-To: <20120829203725.6424.60519.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 08/29/2012 03:37 PM, Jussi Kivilinna wrote:
> .cra_list initialization is unneeded and have been removed from all other
> crypto modules except 842.
> 
> Cc: Robert Jennings <rcj@linux.vnet.ibm.com>
> Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> 
> ---
> 
> I don't have ppc64 cross-compiler set up, so I couldn't test this. However
> patch is obvious and should work.

Applied on top of next-20120824 and it builds on ppc64, just
for peace of mind :)

I see the other patch in next that did this for all the others.

Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

--
Seth
