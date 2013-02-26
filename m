From: Zeev Zilberman <zeev@annapurnaLabs.com>
Subject: ahash and crc32c
Date: Tue, 26 Feb 2013 17:11:55 +0000
Message-ID: <CD52BAD7.26798%zeev@annapurnalabs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:23924
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752852Ab3BZRMQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Feb 2013 12:12:16 -0500
Received: from mail90-am1 (localhost [127.0.0.1])	by mail90-am1-R.bigfish.com
 (Postfix) with ESMTP id BF436C0369	for <linux-crypto@vger.kernel.org>; Tue,
 26 Feb 2013 17:12:13 +0000 (UTC)
Received: from AM1EHSMHS015.bigfish.com (unknown [10.3.201.227])	by
 mail90-am1.bigfish.com (Postfix) with ESMTP id 34B362E00D1	for
 <linux-crypto@vger.kernel.org>; Tue, 26 Feb 2013 17:12:11 +0000 (UTC)
Content-Language: en-US
Content-ID: <7E2D26D740443645920FCBB8CB9C6453@apcprd02.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I'm working on an ahash driver that supports CRC32C.
I saw that all existing CRC32C implementations (except blackfin) are
implementing shash interface, but ahash seems to be the correct choice
in our case.
On the other hand I saw that CRC32C test in testmgr.c tries to create
shash tfm for CRC32C and assumes that the CRC context is saved in first
4 bytes of the shash context.

When I implement CRC32C algorithm this part of the test fails.

How should I treat this failure? What is the reason for the requirement
that is tested in this scenario?

Thank you.
Zeev.
