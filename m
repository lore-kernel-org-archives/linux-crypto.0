From: Nicolai Stange <nicstange@gmail.com>
Subject: [PATCH RESEND v2 00/14] lib/mpi: bug fixes and cleanup
Date: Mon, 21 Mar 2016 14:26:01 +0100
Message-ID: <1458566775-5239-1-git-send-email-nicstange@gmail.com>
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	Michal Marek <mmarek@suse.com>,
	Andrzej Zaborowski <andrew.zaborowski@intel.com>,
	Stephan Mueller <smueller@chronox.de>,
	Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Nicolai Stange <nicstange@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36241 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbcCUN0e (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Mar 2016 09:26:34 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a resend of v2 with the crypto people properly CC'd.

The original v1 can be found here:

  http://lkml.kernel.org/g/1458237606-4954-1-git-send-email-nicstange@gmail.com


While v1 (hopefully) fixed some issues in mpi_write_sgl() and
mpi_read_buffer() introduced by
  commit 2d4d1eea540b ("lib/mpi: Add mpi sgl helpers") and by
  commit 9cbe21d8f89d ("lib/mpi: only require buffers as big as needed for
                        the integer"),
I missed that there are some, including out-of-bounds buffer accesses,
in mpi_read_raw_from_sgl() as well.

Hence v2, which includes the original stuff from v1 plus my new fixes to
mpi_read_raw_from_sgl().


Applicable to linux-next-20160318.


Changes to v1:
  - [1-8/14]
    former [1-8/8], unchanged.

  - [9-14/14]
    Added in v2. Fixes to mpi_read_raw_from_sgl().

Nicolai Stange (14):
  lib/mpi: mpi_write_sgl(): fix skipping of leading zero limbs
  lib/mpi: mpi_write_sgl(): fix style issue with lzero decrement
  lib/mpi: mpi_write_sgl(): purge redundant pointer arithmetic
  lib/mpi: mpi_write_sgl(): fix out-of-bounds stack access
  lib/mpi: mpi_write_sgl(): replace open coded endian conversion
  lib/mpi: mpi_read_buffer(): optimize skipping of leading zero limbs
  lib/mpi: mpi_read_buffer(): replace open coded endian conversion
  lib/mpi: mpi_read_buffer(): fix buffer overflow
  lib/mpi: mpi_read_raw_from_sgl(): replace len argument by nbytes
  lib/mpi: mpi_read_raw_from_sgl(): don't include leading zero SGEs in
    nbytes
  lib/mpi: mpi_read_raw_from_sgl(): purge redundant clearing of nbits
  lib/mpi: mpi_read_raw_from_sgl(): fix nbits calculation
  lib/mpi: mpi_read_raw_from_sgl(): sanitize meaning of indices
  lib/mpi: mpi_read_raw_from_sgl(): fix out-of-bounds buffer access

 lib/mpi/mpicoder.c | 122 +++++++++++++++++++----------------------------------
 1 file changed, 43 insertions(+), 79 deletions(-)

-- 
2.7.3
