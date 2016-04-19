From: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Subject: console noise after commit c1e9b3b0eea
Date: Tue, 19 Apr 2016 15:33:25 -0700 (PDT)
Message-ID: <20160419223325.GA15852@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: sparclinux@vger.kernel.org, herbert@gondor.apana.org.au,
	mpm@selenic.com, linux-crypto@vger.kernel.org,
	larry.bassel@oracle.com
To: matorola@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51853 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbcDSWeB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Apr 2016 18:34:01 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Hi Anatoly,

after commit c1e9b3b0eea1 ("hwrng: n2 - Attach on T5/M5, T7/M7 SPARC CPUs")
I get a *lot* of console noise on my T5-2, of the form:

n2rng f028f21c: Selftest failed on unit 0
n2rng f028f21c: Test buffer slot 0 [0x0000000000000000]
n2rng f028f21c: Test buffer slot 1 [0xe63f56d6a22eb116]
n2rng f028f21c: Test buffer slot 2 [0xe63f56d6a22eb116]
n2rng f028f21c: Test buffer slot 3 [0xe63f56d6a22eb116]
n2rng f028f21c: Test buffer slot 4 [0xe63f56d6a22eb116]
n2rng f028f21c: Test buffer slot 5 [0xe63f56d6a22eb116]
n2rng f028f21c: Test buffer slot 6 [0xe63f56d6a22eb116]
n2rng f028f21c: Test buffer slot 7 [0xe63f56d6a22eb116]

Why/when is your commit needed on my T5-2?

I'm not sure how this was tested, but if you need to revise it and test
on sparc, please let me know- I think it needs more work on sparc.

--Sowmini
