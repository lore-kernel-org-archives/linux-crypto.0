From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Is a crypto_ahash_init required before invoking crypto_ahash_import?
Date: Thu, 25 Feb 2016 15:56:31 -0600
Message-ID: <56CF788F.5050209@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0084.outbound.protection.outlook.com ([207.46.100.84]:59648
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750830AbcBYV4h (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Feb 2016 16:56:37 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I'm seeing an issue on one system that I wasn't seeing on another
system. It turns out that the testmgr sha testing exports an ahash
request context, allocates a new ahash request context and then imports
into that new ahash request context. Since crypto_ahash_init() is not
performed the driver request context could have random data in it,
which ends up causing an error. As part of the import/export support
that I added for the ccp driver I reduced the amount of data that was
exported, but I guess I always assumed that crypto_ahash_init() would
have been called before doing a crypto_ahash_import().

I can fix this in the driver by doing a memset to zero of the request
context area during the import. But I guess I'm also wondering if there
is an expectation/requirement that crypto_ahash_init() be called before
doing an import?  If there is the I can add that to the testmgr code
instead.

Thanks,
Tom
