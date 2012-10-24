From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: [PATCH 2/3] crypto: camellia-x86_64 - share common functions
 and move structures and function definitions to header file
Date: Wed, 24 Oct 2012 10:35:13 +0300
Message-ID: <20121024103513.11123nsgi8jnitq8@www.dalek.fi>
References: <20121023180251.6263.14957.stgit@localhost6.localdomain6>
 <20121023180257.6263.93870.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:41518 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934401Ab2JXHfR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Oct 2012 03:35:17 -0400
In-Reply-To: <20121023180257.6263.93870.stgit@localhost6.localdomain6>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I guess yesterday was one of those days, when nothing goes right. Obviously
this patch is missing the header file that was split from camellia_glue.c.

On top of that I managed to overwrite the not-commited header file when
rebasing AVX2 patchset on top of these. So after remaking this patch, I
need to retest everything. So I'll take few days of distance to this work
and resend this patchset again in a few days or so.

Sorry for the hassle.

-Jussi

Quoting Jussi Kivilinna <jussi.kivilinna@mbnet.fi>:

> Prepare camellia-x86_64 functions to be reused from AVX/AESNI implementation
> module.
>
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> ---
>  arch/x86/crypto/camellia_glue.c |   80  
> +++++++++++----------------------------
>  1 file changed, 23 insertions(+), 57 deletions(-)
