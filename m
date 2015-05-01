From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: Constify (de)compression parameters
Date: Fri, 1 May 2015 11:21:25 +0800
Message-ID: <20150501032125.GB371@gondor.apana.org.au>
References: <20150428143630.7186.86312.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48275 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbbEADV2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Apr 2015 23:21:28 -0400
Content-Disposition: inline
In-Reply-To: <20150428143630.7186.86312.stgit@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 28, 2015 at 03:36:30PM +0100, David Howells wrote:
> In testmgr, struct pcomp_testvec takes a non-const 'params' field, which is
> pointed to a const deflate_comp_params or deflate_decomp_params object.  With
> gcc-5 this incurs the following warnings:
> 
> In file included from ../crypto/testmgr.c:44:0:
> ../crypto/testmgr.h:28736:13: warning: initialization discards 'const' qualifier from pointer target type [-Wdiscarded-array-qualifiers]
>    .params = &deflate_comp_params,
>              ^
> ../crypto/testmgr.h:28748:13: warning: initialization discards 'const' qualifier from pointer target type [-Wdiscarded-array-qualifiers]
>    .params = &deflate_comp_params,
>              ^
> ../crypto/testmgr.h:28776:13: warning: initialization discards 'const' qualifier from pointer target type [-Wdiscarded-array-qualifiers]
>    .params = &deflate_decomp_params,
>              ^
> ../crypto/testmgr.h:28800:13: warning: initialization discards 'const' qualifier from pointer target type [-Wdiscarded-array-qualifiers]
>    .params = &deflate_decomp_params,
>              ^
> 
> Fix this by making the parameters pointer const and constifying the things
> that use it.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Both patches applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
