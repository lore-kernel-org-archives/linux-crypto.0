From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Possible bug: blkcipher_walk_done()
Date: Wed, 10 Feb 2010 11:42:13 +0200
Message-ID: <4B727F75.20305@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:52277 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab0BJJmr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Feb 2010 04:42:47 -0500
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o1A9gFvh014313
	for <linux-crypto@vger.kernel.org>; Wed, 10 Feb 2010 03:42:46 -0600
Received: from [172.21.41.3] (kds.research.nokia.com [172.21.41.3])
	by mgw-da01.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o1A9gDxW005577
	for <linux-crypto@vger.kernel.org>; Wed, 10 Feb 2010 11:42:14 +0200
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

It seems that there is a mistake in the implementation of

int blkcipher_walk_done(struct blkcipher_desc *desc,
            struct blkcipher_walk *walk, int err)

blkcipher_walk_virt() will call crypto_kmap() to map page.

But in the case then err argument is < 0 and we cannot continue then
blkcipher_walk_done() will not
unmap the page.

What do you think?

- Dmitry

