From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Asynchronous usage of PCOMPRESS
Date: Mon, 10 Nov 2014 12:16:51 -0600
Message-ID: <54610113.3040200@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
To: Herbert Xu <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0116.outbound.protection.outlook.com ([157.56.110.116]:17608
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751264AbaKJSvs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Nov 2014 13:51:48 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

Is the PCOMPRESS algorithm supposed to support asynchronous
implementations? In other words, are callers expected to handle the
-EINPROGRESS or -EAGAIN return codes that can be returned by an
asynchronous implementation?

Or is it assumed that if the CRYPTO_ALG_ASYNC flag is not set then the
code path must be synchronous?  If that's the case, should the pcompress
support be updated to look for synchronous implementations if the
CRYPTO_ALG_ASYNC flag isn't set or should asynchronous implementations
provide a synchronous fallback?

Thanks,
Tom
