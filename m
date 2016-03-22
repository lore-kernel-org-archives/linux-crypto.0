From: Nicolai Stange <nicstange@gmail.com>
Subject: [PATCH v3 00/14] lib/mpi: bug fixes and cleanup
Date: Tue, 22 Mar 2016 13:12:34 +0100
Message-ID: <1458648768-1469-1-git-send-email-nicstange@gmail.com>
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	Michal Marek <mmarek@suse.com>,
	Andrzej Zaborowski <andrew.zaborowski@intel.com>,
	Stephan Mueller <smueller@chronox.de>,
	Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Nicolai Stange <nicstange@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33189 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbcCVMNz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Mar 2016 08:13:55 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Former v2 can be found here:

  http://lkml.kernel.org/g/1458566775-5239-1-git-send-email-nicstange@gmail.com


This v3 series incorporates a fix to the pointer arithmetic issue in v2's
[8/14] ("lib/mpi: mpi_read_buffer(): fix buffer overflow") spotted by
Tadeusz Struk.

The rest, that is [1-7,9-14/14], go unchanged and have got a

  Tested-by: Tadeusz Struk <tadeusz.struk@intel.com>

already.


Applicable to linux-next-20160322.

Changes to v2:
  - [8/14] ("lib/mpi: mpi_read_buffer(): fix buffer overflow")
    + Fix the pointer arithmetic issue found by Tadeusz Struk


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
2.7.4
