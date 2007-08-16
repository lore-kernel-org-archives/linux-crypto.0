From: Joy Latten <latten@austin.ibm.com>
Subject: can CTR use blkcipher_walk_virt()?
Date: Thu, 16 Aug 2007 16:00:26 -0500
Message-ID: <200708162100.l7GL0Qt4010595@faith.austin.ibm.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50490 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758513AbXHPVDJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Aug 2007 17:03:09 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l7GL381H009592
	for <linux-crypto@vger.kernel.org>; Thu, 16 Aug 2007 17:03:08 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l7GL38jD513272
	for <linux-crypto@vger.kernel.org>; Thu, 16 Aug 2007 17:03:08 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7GL38Zj021257
	for <linux-crypto@vger.kernel.org>; Thu, 16 Aug 2007 17:03:08 -0400
Received: from austin.ibm.com (netmail1.austin.ibm.com [9.41.248.175])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l7GL37BV021238
	for <linux-crypto@vger.kernel.org>; Thu, 16 Aug 2007 17:03:07 -0400
Received: from faith.austin.ibm.com (faith.austin.ibm.com [9.53.40.35])
	by austin.ibm.com (8.13.8/8.12.10) with ESMTP id l7GL37qF046490
	for <linux-crypto@vger.kernel.org>; Thu, 16 Aug 2007 16:03:07 -0500
Received: from faith.austin.ibm.com (localhost.localdomain [127.0.0.1])
	by faith.austin.ibm.com (8.13.4/8.12.8) with ESMTP id l7GL0Qqc010596
	for <linux-crypto@vger.kernel.org>; Thu, 16 Aug 2007 16:00:26 -0500
Received: (from jml@localhost)
	by faith.austin.ibm.com (8.13.4/8.13.4/Submit) id l7GL0Qt4010595
	for linux-crypto@vger.kernel.org; Thu, 16 Aug 2007 16:00:26 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

I am in learning mode and have been looking into CTR.
Based on the fact that CTR does not require the plaintext to 
be a multiple of the blocksize nor is padding required,
should I use cipher.c routines (as xcbc does) instead
of blkcipher.c routines (as cbc does)?
(I've been referencing rfc 3686.)

If it is possible to receive plaintext < blocksize in CTR...
then, wouldn't blkcipher_walk_virt() result in error because 
walk->total < blocksize.  (Error would occur in blcipher_walk_next.)

Regards,
Joy
