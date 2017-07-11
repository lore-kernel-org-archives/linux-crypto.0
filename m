From: Harald Freudenberger <freude@linux.vnet.ibm.com>
Subject: [PATCH v2 0/2] crypto hwrng consider quality value, remember user choice
Date: Tue, 11 Jul 2017 09:36:21 +0200
Message-ID: <1499758583-14626-1-git-send-email-freude@linux.vnet.ibm.com>
Cc: herbert@gondor.apana.org.au, arnd@arndb.de,
        gregkh@linuxfoundation.org, prasannatsmkumar@gmail.com,
        schwidefsky@de.ibm.com,
        Harald Freudenberger <freude@linux.vnet.ibm.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33779 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755359AbdGKHhC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jul 2017 03:37:02 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6B7YMSs061296
        for <linux-crypto@vger.kernel.org>; Tue, 11 Jul 2017 03:37:01 -0400
Received: from e06smtp15.uk.ibm.com (e06smtp15.uk.ibm.com [195.75.94.111])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2bmc7nbdcf-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Tue, 11 Jul 2017 03:37:01 -0400
Received: from localhost
        by e06smtp15.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <freude@de.ibm.com>;
        Tue, 11 Jul 2017 08:36:58 +0100
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

This two patches make hwrng always hold a list of registered
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
rng via echo to /sys/class/misc/hw_random/rng_current and
adds a new sysfs attribute file 'rng_selected' to the rng core.

Harald Freudenberger (2):
  crypto: hwrng use rng source with best quality
  crypto: hwrng remember rng chosen by user

 drivers/char/hw_random/core.c | 42 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 36 insertions(+), 6 deletions(-)

-- 
2.7.4
