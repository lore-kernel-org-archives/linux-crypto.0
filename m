From: David Miller <davem@davemloft.net>
Subject: Re: unaligned access in pkcs7_verify
Date: Mon, 12 Oct 2015 07:06:34 -0700 (PDT)
Message-ID: <20151012.070634.1545145319630456859.davem@davemloft.net>
References: <20151008131519.GA24362@gondor.apana.org.au>
	<20151008144343.GE19655@oracle.com>
	<20151012133209.GA27746@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: sowmini.varadhan@oracle.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:36940 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbbJLNuj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Oct 2015 09:50:39 -0400
In-Reply-To: <20151012133209.GA27746@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Mon, 12 Oct 2015 21:32:09 +0800

> The sparc sha algorithms themselves need to declare the alignment
> that they require.  Currently they claim to be able to handle any
> alignment which appears to not be the case.

The sparc SHA assembler can handle arbitrary alignment.
