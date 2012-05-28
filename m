From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: [PATCH] crypto: twofish - add x86_64/avx assembler
 implementation
Date: Mon, 28 May 2012 09:25:05 +0300
Message-ID: <20120528092505.211453i11cwxhp4w@naisho.dyndns.info>
References: <20120527144919.GE17705@kronos.redsun>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Tilo =?iso-8859-1?b?TfxsbGVy?=
	<tilo.mueller@informatik.uni-erlangen.de>
To: Johannes Goetzfried
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:55876 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab2E1GZJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 May 2012 02:25:09 -0400
In-Reply-To: <20120527144919.GE17705@kronos.redsun>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Quoting Johannes Goetzfried  
<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>:

> This patch adds a x86_64/avx assembler implementation of the Twofish block
> cipher. The implementation processes eight blocks in parallel (two 4 block
> chunk AVX operations). The table-lookups are done in general-purpose  
> registers.
> For small blocksizes the 3way-parallel functions from the twofish-x86_64-3way
> module are called. A good performance increase is provided for blocksizes
> greater or equal to 128B.
>
> Patch has been tested with tcrypt and automated filesystem tests.
>

It would be benefical to expand the twofish vectors in  
crypto/testmgr.h from 3 blocks
to 8 blocks so that 8-way algorithm(s) can be checked runtime. And  
while at expanding
test-vectors, why not just expand to 16 blocks... AVX2 is just one year away:
   
https://github.com/jkivilin/crypto-avx2/commit/1a72d7a6a1553aee70ad4b6a1980ca372181f40d

>
> Tcrypt benchmark results:
>
> Intel Core i5-2500 CPU (fam:6, model:42, step:7)

<snip>

> +/*
> + * Glue Code for AVX assembler version of Twofish Cipher
> + *
> + * Copyright (C) 2012 Johannes Goetzfried
> + *     <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
> + *
> + * Glue code based on twofish_sse2_glue.c by:
> + *  Copyright (C) 2011 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

I think you mean serpent_sse2_glue.c :)

-Jussi
