From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH 4/7] lib: introduce sg_nents_for_len2
Date: Fri, 18 Sep 2015 14:20:48 +0200
Message-ID: <20150918122048.GA22045@Red>
References: <1441891302-12014-1-git-send-email-clabbe.montjoie@gmail.com>
 <1441891302-12014-5-git-send-email-clabbe.montjoie@gmail.com>
 <20150918115300.GC7638@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:34034 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739AbbIRMUw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Sep 2015 08:20:52 -0400
Content-Disposition: inline
In-Reply-To: <20150918115300.GC7638@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 18, 2015 at 07:53:00PM +0800, Herbert Xu wrote:
> On Thu, Sep 10, 2015 at 03:21:39PM +0200, LABBE Corentin wrote:
> > Some driver use a modified version of sg_nents_for_len with an
> > additional parameter bool *chained for knowing if the scatterlist is
> > chained or not.
> > 
> > So, for removing duplicate code, add sg_nents_for_len2 in
> > lib/scatterlist.c
> 
> This name is rather awkward.  Perhaps sg_nents_len_chained?

Perfect, thanks

I will send the modified patch series with this function name soon.

Regards
