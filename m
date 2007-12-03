From: Jan Glauber <jang@linux.vnet.ibm.com>
Subject: HMAC broken on s390
Date: Mon, 03 Dec 2007 14:31:40 +0100
Message-ID: <1196688700.4799.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.29.155]:16069 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbXLCNcE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Dec 2007 08:32:04 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate6.de.ibm.com (8.13.8/8.13.8) with ESMTP id lB3DVrvA041590
	for <linux-crypto@vger.kernel.org>; Mon, 3 Dec 2007 13:31:53 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lB3DVrrs2867280
	for <linux-crypto@vger.kernel.org>; Mon, 3 Dec 2007 14:31:53 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lB3DVqQG015292
	for <linux-crypto@vger.kernel.org>; Mon, 3 Dec 2007 14:31:52 +0100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

commit 788fefa33b0b50581585925c53c230a36af35d0e in cryptodev breaks hmac
on s390 du to the usage of sg_chain():

static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
                            struct scatterlist *sgl)
{
#ifndef ARCH_HAS_SG_CHAIN
        BUG();
#endif

ARCH_HAS_SG_CHAIN is false for s390 (and also for some other arch's).

What should we do with this?

Cheers,
Jan
