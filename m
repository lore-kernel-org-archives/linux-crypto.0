From: Melchior FRANZ <melchior.franz@gmail.com>
Subject: Re: [2.6.28.5] dm/crypt oops: "unable to handle kernel NULL pointer dereference" (tainted)
Date: Mon, 16 Mar 2009 14:38:35 +0100
Message-ID: <200903161438.35634@rk-nord.at>
References: <200903111319.43778@rk-nord.at> <49B82232.2090802@redhat.com> <20090313134916.GI7445@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, Milan Broz <mbroz@redhat.com>
To: Alasdair G Kergon <agk@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nat-warsl417-02.aon.at ([195.3.96.120]:60338 "EHLO email.aon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751340AbZCPNin (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Mar 2009 09:38:43 -0400
Received: from smarthub94.highway.telekom.at (HELO email.aon.at) ([172.18.5.236])
          (envelope-sender <melchior.franz@gmail.com>)
          by fallback44.highway.telekom.at (qmail-ldap-1.03) with SMTP
          for <linux-crypto@vger.kernel.org>; 16 Mar 2009 13:38:39 -0000
In-Reply-To: <20090313134916.GI7445@agk.fab.redhat.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Alasdair G Kergon -- Friday 13 March 2009:
> Latest version of this patch - please give this some testing!

Thanks. I've applied it to 2.6.29-rc8-git2, and can confirm that
my loop-mounted crypto file still works. Of course, I can't say
if it fixes the oops bug, as I only ever got that once in a few
years, and it would take another few years to be reasonably sure.

Unfortunately, it looks as if 2.6.29-rc8-git2 doesn't run all
USB devices that I depend on, so I can't even test the patch
for a day. (Yes, I'll file an USB bug report once I know more
about that.)

m.

