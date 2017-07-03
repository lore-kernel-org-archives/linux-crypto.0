From: Harald Freudenberger <freude@linux.vnet.ibm.com>
Subject: [PATCH 0/3] crypto hwrng consider quality value, remember user choice
Date: Mon,  3 Jul 2017 12:03:21 +0200
Message-ID: <1499076204-18547-1-git-send-email-freude@linux.vnet.ibm.com>
Cc: herbert@gondor.apana.org.au, arnd@arndb.de,
        gregkh@linuxfoundation.org, schwidefsky@de.ibm.com,
        Harald Freudenberger <freude@linux.vnet.ibm.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49445 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753800AbdGCKDm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jul 2017 06:03:42 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v639wgKx065920
        for <linux-crypto@vger.kernel.org>; Mon, 3 Jul 2017 06:03:42 -0400
Received: from e06smtp13.uk.ibm.com (e06smtp13.uk.ibm.com [195.75.94.109])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2bfdbcdh28-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Mon, 03 Jul 2017 06:03:41 -0400
Received: from localhost
        by e06smtp13.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <freude@de.ibm.com>;
        Mon, 3 Jul 2017 11:03:40 +0100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The hwrng core implementation currently doesn't consider the
quality field of the struct hwrng. So the first registered rng
is the winner and further rng sources even with much better
quality are ignored.

The behavior should be that always the best rng with the highest
quality rate should be used as current rng source. Only if the
user explicitly chooses a rng source (via writing a rng name
to /sys/class/misc/hw_random/rng_current) the decision for the
best quality should be suppressed.

This set of patches makes hwrng always hold a list of registered
rng sources sorted decreasing by quality. On registration of a new
hwrng source the list is updated and if the current rng source was
not chosen by user and the new rng provides better quality set as
new current rng source. Similar on unregistration of an rng, if it
was the current used rng source the one with the next highest quality
is used. If a rng source has been set via sysfs from userland as
long as this one doesn't unregister it is kept as current rng
regardless of registration of 'better' rng sources.

Patch 1 introduces the sorted list of registered rngs and the
always use the best quality behavior.

Patch 2 makes hwrng remember that the user has selected an
rng via echo to /sys/class/misc/hw_random/rng_current.

Patch 3 adds a new sysfs attribute file 'rng_selected' to the
rng core. This file shows the chosen rng name if a selection
from userspace took place otherwise 'none'.

Patch 3 is just a simple implementation of an possible improvement
and may act as a starting point for further discussions. For example,
the implementation could be reworked to accept also currently not
known rng sources and upon appearing instantly select this user
chosen rng. However, this would require to hold an string buffer
and this would introduce some string length limit on the rng name.
Another idea is that there should be a possibility to unselect
the user's choice. An echo 'none' to rng_current may be a way to
remove the selection and the hwrng may act by using the quality best
rng.

Harald Freudenberger (3):
  crypto: hwrng use rng source with best quality
  crypto: hwrng remember rng chosen by user
  crypto: hwrng add sysfs attribute to show user selected rng

 drivers/char/hw_random/core.c | 43 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 37 insertions(+), 6 deletions(-)

-- 
2.7.4
