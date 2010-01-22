From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Async Crypto API
Date: Fri, 22 Jan 2010 10:45:34 +0200
Message-ID: <4B5965AE.9060202@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:25741 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab0AVIqH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jan 2010 03:46:07 -0500
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx06.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o0M8jrQu019851
	for <linux-crypto@vger.kernel.org>; Fri, 22 Jan 2010 10:46:04 +0200
Received: from [172.21.41.3] (kds.research.nokia.com [172.21.41.3])
	by mgw-da01.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o0M8jZ92030086
	for <linux-crypto@vger.kernel.org>; Fri, 22 Jan 2010 10:45:35 +0200
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

I have one question about async api.

I work on AHASH driver and wonder about one thing.

while calculating hash, client might call many times

ahash_request_set_crypt(req, &sg, sha1, len);
crypto_ahash_update(req);
..
..
ahash_request_set_crypt(req, &sg, sha1, len);
crypto_ahash_finup(req);

right?

But because it is async and driver does not wait_for_completion,
 previous request may not be completed before client will call next update.

But what should be the behavior of the driver?

Thanks,
Dmitry

