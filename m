From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [dm-devel] Desynchronizing dm-raid1
Date: Thu, 22 May 2008 10:42:25 +0800
Message-ID: <20080522024225.GA28400@gondor.apana.org.au>
References: <E1JtKQL-0004Nm-00@gondolin.me.apana.org.au> <Pine.LNX.4.64.0805061849020.7260@engineering.redhat.com> <Pine.LNX.4.64.0805122325050.373@engineering.redhat.com> <20080513033822.GA9604@gondor.apana.org.au> <Pine.LNX.4.64.0805131622120.486@engineering.redhat.com> <20080514011457.GB18728@gondor.apana.org.au> <Pine.LNX.4.64.0805212210330.17520@engineering.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alasdair G Kergon <agk@redhat.com>, linux-crypto@vger.kernel.org,
	dm-devel@redhat.com, malahal@us.ibm.com
To: Mikulas Patocka <mpatocka@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:41827 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753023AbYEVCma (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 May 2008 22:42:30 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805212210330.17520@engineering.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 21, 2008 at 10:18:43PM -0400, Mikulas Patocka wrote:
>
> All the ciphers comply, so the bug is only a theroretical issue (but I 
> didn't check assembler versions --- they should be checked by the person 
> who wrote them, assembler is write-only language).

Since every current algorithm sets the flag could you invert
its sense? Sorry to have to do this to you :)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
