From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Why null skcipher to copy AAD data?
Date: Tue, 5 Jul 2016 13:03:56 +0800
Message-ID: <20160705050355.GA5724@gondor.apana.org.au>
References: <CAFXBA==GZRefGrLxjYtNbViPEyasdvbbHwJ4hS+swtVfSR=HQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Harsh Jain <harshjain.prof@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42898 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204AbcGEFEA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Jul 2016 01:04:00 -0400
Content-Disposition: inline
In-Reply-To: <CAFXBA==GZRefGrLxjYtNbViPEyasdvbbHwJ4hS+swtVfSR=HQA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Harsh Jain <harshjain.prof@gmail.com> wrote:
> 
> Why we need null skcipher to copy AAD from src to dst buffer. We can
> do the same with some function,who can copy data from src sg list to
> dst sg list.

Well first of all we don't have such a function, and even if
you took the trouble of actually writing one would it really
be that much faster than using the null skcipher?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
