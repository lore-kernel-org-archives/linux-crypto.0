From: Andreas Ziegler <andreas.ziegler@fau.de>
Subject: select on non-existing Kconfig option CRC32C
Date: Wed, 15 Jun 2016 12:00:59 +0200
Message-ID: <5761275B.4010508@fau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx-rz-1.rrze.uni-erlangen.de ([131.188.11.20]:45299 "EHLO
	mx-rz-1.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750976AbcFOKIs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jun 2016 06:08:48 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Hendrik,

your patch "s390/crc32-vx: add crypto API module for optimized CRC-32
algorithms" showed up in linux-next today (next-20160615) as commit 	364148e0b195.

The patch defines the Kconfig option CRYPTO_CRC32_S390 which 'select's CRC32C.
However, this should probably have been CRYPTO_CRC32C, as CRC32C does not exist.
Should I prepare a trivial patch to fix this up or would you like to do that on
your side?

I found this issue by comparing yesterday's tree and today's tree using
'scripts/checkkconfigsymbols -f -d next-20160614..next-20160615'.

Best regards,

Andreas
