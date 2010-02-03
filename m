From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: crypto_shash_update & CRYPTO_TFM_REQ_MAY_SLEEP
Date: Wed, 03 Feb 2010 19:21:01 +0200
Message-ID: <4B69B07D.9010909@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:57825 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932622Ab0BCRVR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Feb 2010 12:21:17 -0500
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx06.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o13HKptJ017369
	for <linux-crypto@vger.kernel.org>; Wed, 3 Feb 2010 19:21:14 +0200
Received: from [172.21.41.3] (kds.research.nokia.com [172.21.41.3])
	by mgw-sa02.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o13HL1gN012520
	for <linux-crypto@vger.kernel.org>; Wed, 3 Feb 2010 19:21:01 +0200
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

One interesting issue

Many clients in the kernel set CRYPTO_TFM_REQ_MAY_SLEEP to desc.flags.
It is used by crypto_yeld().

But the flags also available in the driver.
One can assume that it is possible to sleep, but is not, because crypto
walk will
    walk->data = crypto_kmap(walk->pg, 0);

------------------
    for (nbytes = crypto_hash_walk_first_compat(hdesc, &walk, sg, len);
         nbytes > 0; nbytes = crypto_hash_walk_done(&walk, nbytes))
        nbytes = crypto_shash_update(desc, walk.data, nbytes);
------------------

That is quite confusing...
I would expect that driver could sleep while hw is doing calculation.

Seems most of the clients uses sync API (linux/net has only sync).

Any comments? Ideas?

Thanks.

- Dmitry

