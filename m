From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 0/2] crytpo: rsa - use mpi sgl helpers
Date: Wed, 23 Sep 2015 15:48:53 -0700
Message-ID: <20150923224853.23780.95440.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:54719 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754359AbbIWWus (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Sep 2015 18:50:48 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This series introduces new mpi helpers to read from and
write to an sgl without a need of using an intermediate
flat buffer.

First patch adds helpers to mpi library.
Second patch changes rsa implementation to use the new
functions.

This is an incremental patch series on top of these two:
https://patchwork.kernel.org/patch/7241041/
https://patchwork.kernel.org/patch/7241051/

A simple test for the new helpers can be found here:
https://github.com/tstruk/mpi_sgl_test/blob/master/test.c

---

Tadeusz Struk (2):
      lib/mpi: Add mpi sgl helpers
      crytpo: rsa - use mpi slg helpers to import and export data


 crypto/rsa.c        |  110 ++----------------------------
 include/linux/mpi.h |    4 +
 lib/mpi/mpicoder.c  |  186 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 198 insertions(+), 102 deletions(-)

--
