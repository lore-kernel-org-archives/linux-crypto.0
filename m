From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: [PATCH] crypto: testmgr - expand twofish test vectors
Date: Mon, 28 May 2012 23:57:26 +0300
Message-ID: <20120528235726.11081hnk0322lku0@www.81.fi>
References: <20120528135538.GJ17705@kronos.redsun>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Tilo =?iso-8859-1?b?TfxsbGVy?=
	<Tilo.Mueller@informatik.uni-erlangen.de>
To: Johannes Goetzfried
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:47707 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab2E1U53 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 May 2012 16:57:29 -0400
In-Reply-To: <20120528135538.GJ17705@kronos.redsun>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Quoting Johannes Goetzfried  
<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>:

> The AVX implementation of the twofish cipher processes 8 blocks  
> parallel, so we
> need to make test vectors larger to check parallel code paths. Test  
> vectors are
> also large enough to deal with 16 block parallel implementations  
> which may occur
> in the future.
>
> Signed-off-by: Johannes Goetzfried  
> <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
