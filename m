From: Melchior FRANZ <mfranz@aon.at>
Subject: dm/crypt oops in 2.6.28.5 ... but nvidia users aren't supposed to report?
Date: Sat, 7 Mar 2009 01:35:28 +0100
Message-ID: <200903070135.28847@rk-nord.at>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: bugme-admin@linux-foundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nat-warsl417-01.aon.at ([195.3.96.119]:31822 "EHLO email.aon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752886AbZCGAfh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Mar 2009 19:35:37 -0500
Received: from smarthub94.highway.telekom.at (HELO email.aon.at) ([172.18.5.236])
          (envelope-sender <mfranz@aon.at>)
          by fallback43.highway.telekom.at (qmail-ldap-1.03) with SMTP
          for <linux-crypto@vger.kernel.org>; 7 Mar 2009 00:35:33 -0000
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I was about to report an oops in the crypt module (NULL pointer
dereferencing), but when I was half-way through entering the bug
in bugzilla, I read that people with nvidia tainted kernels aren't
supposed to file bug reports.

So the bug is going to remain unfixed!? Sounds like a smart move ...

m.
