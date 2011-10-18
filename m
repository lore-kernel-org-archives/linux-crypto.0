From: Matthias-Christian Ott <ott@mirix.org>
Subject: Hardware acceleration indication in af_alg
Date: Tue, 18 Oct 2011 15:13:52 +0200
Message-ID: <20111018131351.GB24865@qi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mirix.org ([78.46.130.147]:50883 "EHLO a.mirix.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755265Ab1JRNfu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 18 Oct 2011 09:35:50 -0400
Received: from [139.18.255.53] (helo=qi)
	by a.mirix.org with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.76)
	(envelope-from <ott@mirix.org>)
	id 1RG9UP-0000SA-Fo
	for linux-crypto@vger.kernel.org; Tue, 18 Oct 2011 15:13:53 +0200
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I did some experiments with af_alg and noticed that to be really
useful, it should indicate whether a certain algorithm is hardware
accelerated. I guess this has to be inferred by the priority of the
algorithm could be made available via a read-only socket option. Any
thoughts on this?

I can imagine, an alternative approach and perhaps better approach
would be to measure the speed of the kernel provided algorithm against
a software implementation, but there are many other factors that could
influence the results. Therefore, it is perhaps better to just make
the assumption that hardware acceleration is faster which is made in
the kernel anyhow.

Regards,
Matthias-Christian
