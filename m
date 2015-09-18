From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 4/7] lib: introduce sg_nents_for_len2
Date: Fri, 18 Sep 2015 19:53:00 +0800
Message-ID: <20150918115300.GC7638@gondor.apana.org.au>
References: <1441891302-12014-1-git-send-email-clabbe.montjoie@gmail.com>
 <1441891302-12014-5-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46350 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbbIRLxF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Sep 2015 07:53:05 -0400
Content-Disposition: inline
In-Reply-To: <1441891302-12014-5-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 10, 2015 at 03:21:39PM +0200, LABBE Corentin wrote:
> Some driver use a modified version of sg_nents_for_len with an
> additional parameter bool *chained for knowing if the scatterlist is
> chained or not.
> 
> So, for removing duplicate code, add sg_nents_for_len2 in
> lib/scatterlist.c

This name is rather awkward.  Perhaps sg_nents_len_chained?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
