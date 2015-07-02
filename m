From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Subject: [PATCH 0/6] drivers/nx-842: reduce verbosity of logging
Date: Thu, 2 Jul 2015 15:38:00 -0700
Message-ID: <20150702223800.GA1712@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	gustavold@linux.vnet.ibm.com
To: Dan Streetman <ddstreet@us.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:55539 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128AbbGBWiF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jul 2015 18:38:05 -0400
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <nacc@linux.vnet.ibm.com>;
	Thu, 2 Jul 2015 16:38:14 -0600
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 103DF1FF0045
	for <linux-crypto@vger.kernel.org>; Thu,  2 Jul 2015 16:29:13 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t62MbMfJ40566822
	for <linux-crypto@vger.kernel.org>; Thu, 2 Jul 2015 15:37:22 -0700
Received: from d03av02.boulder.ibm.com (localhost [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t62Mc1CP008234
	for <linux-crypto@vger.kernel.org>; Thu, 2 Jul 2015 16:38:02 -0600
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currently, on a LPAR with the nx-842 device disabled, the following
messages are emitted:

nx_compress: no nx842 driver found. [1]
Registering IBM Power 842 compression driver
nx_compress_pseries ibm,compression-v1: nx842_OF_upd_status: status 'disabled' is not 'okay'
nx_compress_pseries ibm,compression-v1: nx842_OF_upd: max_sync_size new:4096 old:0 [2]
nx_compress_pseries ibm,compression-v1: nx842_OF_upd: max_sync_sg new:510 old:0
nx_compress_pseries ibm,compression-v1: nx842_OF_upd: max_sg_len new:4080 old:0
nx_compress_powernv: loading [3]
nx_compress_powernv: no coprocessors found
alg: No test for 842 (842-nx) [4]

[1] is the result of an ordering issue when the CONFIG_ options are set =y. [2]
is the result of nx842_OF_upd_status() not returning the correct error code.
[3] is the result of attempting to load the PowerNV platform driver on a
non-PowerNV platform. [4] is the result of there simply not being any test for
842 in the crypto test manager.

After the changes in the series, the same system as above emits:

Registering IBM Power 842 compression driver
nx_compress_pseries ibm,compression-v1: nx842_OF_upd: device disabled

which seems to me, at least, to be far clearer.

Dan, I think there is still a issue in the code. If CONFIG_DEV_NX_COMPRESS=y
and CONFIG_DEV_NX_COMPRESS_PSERIES=m/CONFIG_DEV_NX_COMPRESS_POWERNV=m, it seems
like the request_module() is not working properly and we simply get a "
nx_compress: no nx842 driver found." at boot (even if I ensure the platform
drivers are in the initrd). If I make CONFIG_DEV_NX_COMPRESS=m, though, the
module(s) load successfully. Does it make sense/is it possible to have these
three symbols always be the same (either all =y or all =m)?

[1/6] crypto/nx-842-pseries: nx842_OF_upd_status should return ENODEV if device is not 'okay'
 drivers/crypto/nx/nx-842-pseries.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)
[2/6] nx-842-pseries: rename nx842_{init,exit} to nx842_pseries_{init,exit}
 drivers/crypto/nx/nx-842-pseries.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)
[3/6] nx-842-pseries: do not emit extra output if status is disabled
 drivers/crypto/nx/nx-842-pseries.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)
[4/6] crypto/nx-842-{powerpc,pseries}: only load on the appropriate machine type
 drivers/crypto/nx/nx-842-powernv.c | 6 ++++++
 drivers/crypto/nx/nx-842-pseries.c | 6 ++++++
 drivers/crypto/nx/nx-842.h         | 1 +
 3 files changed, 13 insertions(+)
[5/6] crypto/testmgr: add null test for 842 algorithm
 crypto/testmgr.c | 3 +++
 1 file changed, 3 insertions(+)
[6/6] nx-842-platform: if NX842 platform drivers are not modules, don't try to load them
 drivers/crypto/nx/nx-842-platform.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)
