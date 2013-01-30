From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Subject: [PATCH 0/2] digsig and mpi cleanups
Date: Wed, 30 Jan 2013 11:30:04 +0200
Message-ID: <cover.1359538137.git.dmitry.kasatkin@intel.com>
Cc: jmorris@namei.org
To: linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.89]:26790 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751856Ab3A3JaW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 30 Jan 2013 04:30:22 -0500
Received: by mail-ea0-f200.google.com with SMTP id d14so1553565eaa.11
        for <linux-crypto@vger.kernel.org>; Wed, 30 Jan 2013 01:30:19 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Here is couple of cleanups for digsig and libmpi.

- Dmitry

Andy Shevchenko (1):
  mpilib: use DIV_ROUND_UP and remove unused macros

Dmitry Kasatkin (1):
  digsig: remove unnecessary memory allocation and copying

 lib/digsig.c           |   41 ++++++++++++++---------------------------
 lib/mpi/mpi-internal.h |    4 ----
 lib/mpi/mpicoder.c     |    8 ++++----
 3 files changed, 18 insertions(+), 35 deletions(-)

-- 
1.7.10.4
