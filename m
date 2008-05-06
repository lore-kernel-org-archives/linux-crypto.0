From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [dm-devel] Desynchronizing dm-raid1
Date: Tue, 06 May 2008 18:29:29 +0800
Message-ID: <E1JtKQL-0004Nm-00@gondolin.me.apana.org.au>
References: <Pine.LNX.4.64.0805051737580.25016@engineering.redhat.com>
Cc: linux-crypto@vger.kernel.org, dm-devel@redhat.com,
	malahal@us.ibm.com
To: mpatocka@redhat.com (Mikulas Patocka)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:39496 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751162AbYEFK3c (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 May 2008 06:29:32 -0400
In-Reply-To: <Pine.LNX.4.64.0805051737580.25016@engineering.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Mikulas Patocka <mpatocka@redhat.com> wrote:
>
> BTW: is it guaranteed for crypto functions that they read the source data 
> only once?

There is no such guarantee.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
