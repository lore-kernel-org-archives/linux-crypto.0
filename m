From: Richard Purdie <rpurdie@openedhand.com>
Subject: [PATCH 1/5] Add LZO compression support to the kernel
Date: Tue, 01 May 2007 15:46:47 +0100
Message-ID: <1178030807.5883.52.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
	linux-crypto@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>,
	David Woodhouse <dwmw2@infradead.org>,
	herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:58984 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754710AbXEAPIA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 1 May 2007 11:08:00 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add LZO1X compression/decompression support to the kernel.

This is based on the standard userspace lzo library, particularly 
minilzo with the headers much trimmed down and simplified for kernel
use. Its structured so that it should still diff with the userspace
version for ease of future updating.

Signed-off-by: Richard Purdie <rpurdie@openedhand.com>

---
 include/linux/lzo.h |   63 ++
 lib/Kconfig         |    5 +
 lib/Makefile        |    1 +
 lib/lzo/Makefile    |    3 +
 lib/lzo/lzoconf.h   |  186 ++++++
 lib/lzo/lzodefs.h   |  463 ++++++++++++++
 lib/lzo/lzointf.c   |   37 ++
 lib/lzo/minilzo.c   | 1771 +++++++++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 2529 insertions(+), 0 deletions(-)

http://folks.o-hand.com/richard/lzo/lzo_kernel-r1.patch
(since it exceeds the file size limit for LKML)
