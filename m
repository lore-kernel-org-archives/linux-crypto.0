From: Nicolai Stange <nicstange@gmail.com>
Subject: [PATCH 0/5] refactor mpi_read_from_buffer()
Date: Thu, 26 May 2016 23:19:50 +0200
Message-ID: <1464297595-24032-1-git-send-email-nicstange@gmail.com>
Cc: David Howells <dhowells@redhat.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Michal Marek <mmarek@suse.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Nicolai Stange <nicstange@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33101 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114AbcEZVUI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 May 2016 17:20:08 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

mpi_read_from_buffer() and mpi_read_raw_data() do almost the same and share a
fair amount of common code.

This patchset attempts to rewrite mpi_read_from_buffer() in order to implement
it in terms of mpi_read_raw_data().

The patches 1 and 3, i.e.
  "lib/mpi: mpi_read_from_buffer(): return error code"
and
  "lib/mpi: mpi_read_from_buffer(): return -EINVAL upon too short buffer"
do the groundwork in that they move any error detection unique to
mpi_read_from_buffer() out of the data handling loop.

The patches 2 and 4, that is
  "lib/digsig: digsig_verify_rsa(): return -EINVAL if modulo length is zero"
and
  "lib/mpi: mpi_read_from_buffer(): sanitize short buffer printk"
are not strictly necessary for the refactoring: they cleanup some minor oddities
related to error handling I came across.

Finally, the last patch in this series,
  "lib/mpi: refactor mpi_read_from_buffer() in terms of mpi_read_raw_data()"
actually does what this series is all about.


Applicable to linux-next-20160325.

A note on testing: allmodconfig on x86_64 builds fine. 
However, the only caller of mpi_read_from_buffer() is digsig_verify_rsa()
and this one is solely used by the IMA/EVM infrastructure.
In my current setup, I don't have any IMA/EVM stuff in place and thus,
I can't do any runtime tests without putting *much* effort into it.
I would really appreciate if someone with a working IMA/EVM setup could do some
brief testing...

Nicolai Stange (5):
  lib/mpi: mpi_read_from_buffer(): return error code
  lib/digsig: digsig_verify_rsa(): return -EINVAL if modulo length is
    zero
  lib/mpi: mpi_read_from_buffer(): return -EINVAL upon too short buffer
  lib/mpi: mpi_read_from_buffer(): sanitize short buffer printk
  lib/mpi: refactor mpi_read_from_buffer() in terms of
    mpi_read_raw_data()

 lib/digsig.c       | 16 +++++++++++-----
 lib/mpi/mpicoder.c | 46 +++++++++++++---------------------------------
 2 files changed, 24 insertions(+), 38 deletions(-)

-- 
2.8.2
