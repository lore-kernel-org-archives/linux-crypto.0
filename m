From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: [PATCH] crypto: twofish - add x86_64/avx assembler
 implementation
Date: Wed, 15 Aug 2012 11:42:16 +0300
Message-ID: <20120815114216.209814z4mq3hxqe8@www.81.fi>
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
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:41390 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab2HOImT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Aug 2012 04:42:19 -0400
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
> Tcrypt benchmark results:
>
> Intel Core i5-2500 CPU (fam:6, model:42, step:7)

I started thinking about the performance on AMD Bulldozer.  
vmovq/vmovd/vpextr*/vpinsr* between FPU and general purpose registers  
on AMD CPU is alot slower (latencies from 8 to 12 cycles) than on  
Intel sandy-bridge (where instructions have latency of 1 to 2). See:  
http://www.agner.org/optimize/instruction_tables.pdf

It would be really good, if implementation could be tested on AMD CPU  
to determinate, if it causes performance regression. However I don't  
have access to machine with such CPU.

-Jussi
