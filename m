From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH -next] PKCS#7: fix sparse non static symbol warning
Date: Mon, 28 Jul 2014 14:57:48 +0100
Message-ID: <2892.1406555868@warthog.procyon.org.uk>
References: <1406553432-29676-1-git-send-email-weiyj_lk@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, Herbert Xu <herbert@gondor.apana.org.au>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	linux-crypto@vger.kernel.org
To: weiyj_lk@163.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbaG1N6I (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 Jul 2014 09:58:08 -0400
In-Reply-To: <1406553432-29676-1-git-send-email-weiyj_lk@163.com>
Content-ID: <2891.1406555868.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

weiyj_lk@163.com wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fixes the following sparse warnings:
> 
> crypto/asymmetric_keys/pkcs7_key_type.c:73:17: warning:
>  symbol 'key_type_pkcs7' was not declared. Should it be static?
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Applied.
