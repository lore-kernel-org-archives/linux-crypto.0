From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 4/8] s390: add System z hardware support for CTR mode
Date: Wed, 4 May 2011 15:10:57 +1000
Message-ID: <20110504051057.GA7005@gondor.apana.org.au>
References: <20110419192913.888086020@linux.vnet.ibm.com> <20110419193248.399099652@linux.vnet.ibm.com> <20110426063437.GA19539@gondor.apana.org.au> <1303900640.3495.12.camel@localhost.localdomain> <20110427104004.GA1697@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Jan Glauber <jang@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:49216 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab1EDFLJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 May 2011 01:11:09 -0400
Content-Disposition: inline
In-Reply-To: <20110427104004.GA1697@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 27, 2011 at 08:40:04PM +1000, Herbert Xu wrote:
> On Wed, Apr 27, 2011 at 12:37:20PM +0200, Jan Glauber wrote:
>
> > This hunk is a left-over from development in the XTS patch and
> > superfluous so it should be removed. Should I repost the whole series?
> 
> No worries.  I'll just kill it in the combined XTS patch.

OK, it's all applied and I will push it out in a jiffy.  Please
double-check to see if I've mangled any of the patches.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
