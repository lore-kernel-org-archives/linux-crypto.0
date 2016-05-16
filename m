From: Stephan Mueller <smueller@chronox.de>
Subject: Costs of asym self tests
Date: Mon, 16 May 2016 15:30:09 +0200
Message-ID: <2344876.zyy5ByWqZi@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "Struk, Tadeusz" <tadeusz.struk@intel.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.atsec.com ([195.30.99.214]:37970 "EHLO mail.atsec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815AbcEPNaO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 May 2016 09:30:14 -0400
Received: from mail.atsec.com (localhost [127.0.0.1])
	by mail.atsec.com (Postfix) with ESMTP id 065C52131B
	for <linux-crypto@vger.kernel.org>; Mon, 16 May 2016 15:30:11 +0200 (CEST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

albeit it makes most sense to have asym self tests in the test manager as we 
do right now, may I suggest some changes to it as follows. The issue I see is 
that asym operations are very expensive.

As we currently have RSA only, I can only refer to its implementation. But in 
general, all new-and-coming asym self tests should be assessed accordingly.

May I suggest to do the following:

- remove all self tests except the 2k tests. As the math works independent of 
the key size, testing one key size is sufficient to demonstrate that the math 
still works.

- If we booted in FIPS mode, and we have PKCS#1 compiled, then:

	* do not execute the raw RSA self test mentioned above

	* perform an enc/dec test using the kernel crypto API with a 2k key

	* if the asym key API is compiled, add a self test for siggen/ver

With this approach, I would see that we limit the impact of the self test to 
"normal" users as well as FIPS related use cases.

If agreed, I could offer to implement the changes.

Note, currently the self tests for RSA is not appropriate to allow the cipher 
in FIPS mode (i.e. the fips_allowed=1 flag is actually not correct in the 
current implementation).

Ciao
Stephan
