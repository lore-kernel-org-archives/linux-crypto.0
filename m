From: Harald Freudenberger <freude@linux.vnet.ibm.com>
Subject: [PATCH] s390/crypto: fix aes ctr concurrency issue
Date: Tue, 19 Nov 2013 11:22:11 +0100
Message-ID: <1384856532-17247-1-git-send-email-freude@linux.vnet.ibm.com>
Cc: linux-crypto@vger.kernel.org,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Ingo Tuchscherer <ingo.tuchscherer@linux.vnet.ibm.com>,
	Gerald Schaefer <gerald.schaefer@de.ibm.com>,
	Harald Freudenberger <freude@de.ibm.com>,
	Harald Freudenberger <freude@linux.vnet.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:58973 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab3KSKWh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Nov 2013 05:22:37 -0500
Received: from /spool/local
	by e06smtp13.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <freude@linux.vnet.ibm.com>;
	Tue, 19 Nov 2013 10:22:34 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
	by d06dlp01.portsmouth.uk.ibm.com (Postfix) with ESMTP id 29EE417D806E
	for <linux-crypto@vger.kernel.org>; Tue, 19 Nov 2013 10:22:15 +0000 (GMT)
Received: from d06av07.portsmouth.uk.ibm.com (d06av07.portsmouth.uk.ibm.com [9.149.37.248])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id rAJAMID266846896
	for <linux-crypto@vger.kernel.org>; Tue, 19 Nov 2013 10:22:18 GMT
Received: from d06av07.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av07.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id rAJAMUuf010019
	for <linux-crypto@vger.kernel.org>; Tue, 19 Nov 2013 05:22:30 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The aes-ctr mode used one preallocated page without any concurrency
protection. When multiple threads run aes-ctr encryption or decryption
this could lead to data corruption.

The patch introduces locking for the preallocated page and alternatively
allocating and freeing of an temp page in concurrency situations.

Signed-off-by: Harald Freudenberger <freude@linux.vnet.ibm.com>

Harald Freudenberger (1):
  s390/crypto: fix aes ctr concurrency issue

 arch/s390/crypto/aes_s390.c |   55 ++++++++++++++++++++++++++++++++----------
 1 files changed, 42 insertions(+), 13 deletions(-)
