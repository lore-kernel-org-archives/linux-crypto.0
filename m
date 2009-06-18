From: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [RFC 1/7] crypto: Add GHASH digest algorithm for GCM
Date: Thu, 18 Jun 2009 09:27:28 +0200
Message-ID: <20090618072728.GA2770@Chamillionaire.breakpoint.cc>
References: <1244704226.5320.124.camel@yhuang-dev.sh.intel.com> <20090617200410.GB28694@Chamillionaire.breakpoint.cc> <1245290907.11965.201.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:56312 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752556AbZFRH12 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Jun 2009 03:27:28 -0400
Content-Disposition: inline
In-Reply-To: <1245290907.11965.201.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Huang Ying | 2009-06-18 10:08:27 [+0800]:

>On Thu, 2009-06-18 at 04:04 +0800, Sebastian Andrzej Siewior wrote:
>> >+#include <linux/module.h>
>> >+#include <linux/init.h>
>> >+#include <linux/kernel.h>
>> >+#include <linux/crypto.h>
>> >+#include <crypto/gf128mul.h>
>> >+#include <crypto/algapi.h>
>> >+#include <crypto/internal/hash.h>
>> Do you mind to sort them?
>
>Sorry, can you tell me what is the better order?

For header files it shouldn't matter if you include linux/module.h
followed by linux/init.h or the other way around. If you have them in
one place and sorted you can easily find out where to put the next one
and tell whether a specific header file is allready included. You also
make it a little harder to include one header file twice. If you think
this does not happen, a quick grep over the scsi tree shows:

|$ fgrep -R '#include ' drivers/scsi/ | sort > sort.txt
|$ fgrep -R '#include ' drivers/scsi/ | sort -u > sort-u.txt
|$ diff -u sort.txt sort-u.txt
|--- sort.txt  2009-06-18 09:12:27.551876506 +0200
|+++ sort-u.txt  2009-06-18 09:12:36.226342283 +0200
|@@ -1347,7 +1347,6 @@
| drivers/scsi/fcoe/libfcoe.c:#include <linux/list.h>
| drivers/scsi/fcoe/libfcoe.c:#include <linux/module.h>
| drivers/scsi/fcoe/libfcoe.c:#include <linux/netdevice.h>
|-drivers/scsi/fcoe/libfcoe.c:#include <linux/netdevice.h>
| drivers/scsi/fcoe/libfcoe.c:#include <linux/spinlock.h>
| drivers/scsi/fcoe/libfcoe.c:#include <linux/timer.h>
| drivers/scsi/fcoe/libfcoe.c:#include <linux/types.h>
|@@ -1623,7 +1622,6 @@
| drivers/scsi/gdth.h:#include <linux/types.h>
| drivers/scsi/gdth_proc.c:#include <linux/completion.h>
| drivers/scsi/gvp11.c:#include "gvp11.h"
|-drivers/scsi/gvp11.c:#include "gvp11.h"
| drivers/scsi/gvp11.c:#include "scsi.h"
| drivers/scsi/gvp11.c:#include "scsi_module.c"
| drivers/scsi/gvp11.c:#include "wd33c93.h"
|@@ -1718,7 +1716,6 @@
| drivers/scsi/ibmvscsi/ibmvfc.h:#include <linux/types.h>
| drivers/scsi/ibmvscsi/ibmvscsi.c:#include "ibmvscsi.h"
| drivers/scsi/ibmvscsi/ibmvscsi.c:#include <asm/firmware.h>
|-drivers/scsi/ibmvscsi/ibmvscsi.c:#include <asm/firmware.h>
| drivers/scsi/ibmvscsi/ibmvscsi.c:#include <asm/vio.h>
| drivers/scsi/ibmvscsi/ibmvscsi.c:#include <linux/delay.h>
| drivers/scsi/ibmvscsi/ibmvscsi.c:#include <linux/dma-mapping.h>
|@@ -2633,7 +2630,6 @@
| drivers/scsi/mpt2sas/mpt2sas_transport.c:#include <scsi/scsi_host.h>
| drivers/scsi/mpt2sas/mpt2sas_transport.c:#include <scsi/scsi_transport_sas.h>
| drivers/scsi/mvme147.c:#include "mvme147.h"
|-drivers/scsi/mvme147.c:#include "mvme147.h"
| drivers/scsi/mvme147.c:#include "scsi.h"
| drivers/scsi/mvme147.c:#include "scsi_module.c"
| drivers/scsi/mvme147.c:#include "wd33c93.h"

SCSI was just a random example.

>Best Regards,
>Huang Ying

Sebastian
