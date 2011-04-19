From: jang@linux.vnet.ibm.com
Subject: [PATCH 0/8] (3rd take) add support for z196 CPACF algorithms
Date: Tue, 19 Apr 2011 21:29:13 +0200
Message-ID: <20110419192913.888086020@linux.vnet.ibm.com>
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:34586 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab1DSTeA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Apr 2011 15:34:00 -0400
Received: from d06nrmr1307.portsmouth.uk.ibm.com (d06nrmr1307.portsmouth.uk.ibm.com [9.149.38.129])
	by mtagate6.uk.ibm.com (8.13.1/8.13.1) with ESMTP id p3JJXuhK020535
	for <linux-crypto@vger.kernel.org>; Tue, 19 Apr 2011 19:33:56 GMT
Received: from d06av06.portsmouth.uk.ibm.com (d06av06.portsmouth.uk.ibm.com [9.149.37.217])
	by d06nrmr1307.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p3JJYqdb1888352
	for <linux-crypto@vger.kernel.org>; Tue, 19 Apr 2011 20:34:52 +0100
Received: from d06av06.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av06.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p3JJXu1m022155
	for <linux-crypto@vger.kernel.org>; Tue, 19 Apr 2011 13:33:56 -0600
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Well... this time it should work... Sorry for the noise.

This patch series adds support for the algorithms that came with the latest
System z machine, z196.

Patch 1 and 2 are trivial cleanup patches to make the new code better fit in.

Patch 3,4,5 are the actual feature patches.

I tried to make the Kconfig descriptions a bit more useful by stating which
machine supports which feature, Patch 6 does this likewise for the
existing CPACF algorithms.

Patch 7 and 8 contain the changes we needed for testing with tcrypt.

Thanks, Jan

-- 
