Return-Path: <SRS0=xZqV=TK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37777C04AB2
	for <linux-crypto@archiver.kernel.org>; Fri, 10 May 2019 17:40:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13F10217D6
	for <linux-crypto@archiver.kernel.org>; Fri, 10 May 2019 17:40:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727580AbfEJRkc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 May 2019 13:40:32 -0400
Received: from smtprelay0045.hostedemail.com ([216.40.44.45]:37638 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727557AbfEJRkc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 May 2019 13:40:32 -0400
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave03.hostedemail.com (Postfix) with ESMTP id 753E118032814;
        Fri, 10 May 2019 17:40:31 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 9FE56442F;
        Fri, 10 May 2019 17:40:30 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: crook38_414a83b1b407
X-Filterd-Recvd-Size: 2787
Received: from XPS-9350 (unknown [172.58.19.107])
        (Authenticated sender: joe@perches.com)
        by omf11.hostedemail.com (Postfix) with ESMTPA;
        Fri, 10 May 2019 17:40:27 +0000 (UTC)
Message-ID: <10021f43dc5b377340fde9a7716e083f6f1261c1.camel@perches.com>
Subject: Re: [PATCH 1/2] zstd: pass pointer rathen than structure to
 functions
From:   Joe Perches <joe@perches.com>
To:     Maninder Singh <maninder1.s@samsung.com>, terrelln@fb.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        keescook@chromium.org, gustavo@embeddedor.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        a.sahrawat@samsung.com, pankaj.m@samsung.com,
        Vaneet Narang <v.narang@samsung.com>
Date:   Fri, 10 May 2019 10:39:57 -0700
In-Reply-To: <1557468704-3014-1-git-send-email-maninder1.s@samsung.com>
References: <CGME20190510061311epcas5p19e9bf3d08319ac99890e03e0bd59e478@epcas5p1.samsung.com>
         <1557468704-3014-1-git-send-email-maninder1.s@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.1-1build1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 2019-05-10 at 11:41 +0530, Maninder Singh wrote:
> currently params structure is passed in all functions, which increases
> stack usage in all the function and lead to stack overflow on target like
> ARM with kernel stack size of 8 KB so better to pass pointer.
[]
> diff --git a/lib/zstd/compress.c b/lib/zstd/compress.c
[]
> @@ -206,18 +206,18 @@ ZSTD_compressionParameters ZSTD_adjustCParams(ZSTD_compressionParameters cPar, u
>  	return cPar;
>  }
>  
> -static U32 ZSTD_equivalentParams(ZSTD_parameters param1, ZSTD_parameters param2)
> +static U32 ZSTD_equivalentParams(const ZSTD_parameters *param1, const ZSTD_parameters *param2)
>  {
> -	return (param1.cParams.hashLog == param2.cParams.hashLog) & (param1.cParams.chainLog == param2.cParams.chainLog) &
> -	       (param1.cParams.strategy == param2.cParams.strategy) & ((param1.cParams.searchLength == 3) == (param2.cParams.searchLength == 3));
> +	return (param1->cParams.hashLog == param2->cParams.hashLog) & (param1->cParams.chainLog == param2->cParams.chainLog) &
> +	       (param1->cParams.strategy == param2->cParams.strategy) & ((param1->cParams.searchLength == 3) == (param2->cParams.searchLength == 3));
>  }

trivia:

Using & instead of && makes this somewhat difficult to read.
It's hard to believe this is a performance optimization.

It might be better as

	return param1->cParams.hashLog == param2->cParams.hashLog &&
	       param1->cParams.chainLog == param2->cParams.chainLog &&
	       param1->cParams.strategy == param2->cParams.strategy &&
	       param1->cParams.searchLength == 3 &&
	       param1->cParams.searchLength == param2->cParams.searchLength;


