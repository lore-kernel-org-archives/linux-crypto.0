From: Jan Glauber <jang@linux.vnet.ibm.com>
Subject: [PATCH 0/4] CPU accelerated implementation for sha512/384 on s390
Date: Mon, 03 Mar 2008 17:19:40 +0100
Message-ID: <1204561180.6025.50.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:25520 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040AbYCCQUJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Mar 2008 11:20:09 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate7.de.ibm.com (8.13.8/8.13.8) with ESMTP id m23GK26A320212
	for <linux-crypto@vger.kernel.org>; Mon, 3 Mar 2008 16:20:02 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m23GJZE4163848
	for <linux-crypto@vger.kernel.org>; Mon, 3 Mar 2008 17:19:36 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m23GJZrh019597
	for <linux-crypto@vger.kernel.org>; Mon, 3 Mar 2008 16:19:35 GMT
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

this patch series adds hardware acceleration to sha512 & sha384 for s390.
Beside the hardware support I've added a generic implementation for the
update and final functions.

Please add these patches to your crypto tree, so they can go into 2.6.26. 

thanks, Jan

