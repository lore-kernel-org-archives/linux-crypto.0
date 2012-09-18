From: David Miller <davem@davemloft.net>
Subject: cbc(des)
Date: Mon, 17 Sep 2012 23:06:41 -0400 (EDT)
Message-ID: <20120917.230641.1507824806487249244.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:36140 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab2IRDGn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Sep 2012 23:06:43 -0400
Received: from localhost (cpe-66-108-116-58.nyc.res.rr.com [66.108.116.58])
	by shards.monkeyblade.net (Postfix) with ESMTPSA id E8294587E18
	for <linux-crypto@vger.kernel.org>; Mon, 17 Sep 2012 20:06:44 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


I just noticed that none of the testmgr.h cbc(des) test cases
actually exercise doing more than one loop over the input data.

Therefore, the updating of the IV in the inner loop is never exercised
and if you get it wrong the crypto layer test cases will not catch it.

The cbc(des3_ede) test cases, on the other hand, have a 128 byte input
test for both encryption and decryption, so do not fail to cover this
aspect of the implementation.
