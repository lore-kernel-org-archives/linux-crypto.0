From: David McCullough <David_Mccullough@securecomputing.com>
Subject: ocf-linux-20070727 - Asynchronous Crypto support for linux
Date: Fri, 27 Jul 2007 23:36:41 +1000
Message-ID: <20070727133641.GA29614@securecomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rex.snapgear.com ([203.143.235.140]:42601 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760896AbXG0Nel (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Jul 2007 09:34:41 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Hi all,

A new release of the ocf-linux package is up (20070727):

    http://ocf-linux.sourceforge.net/

This is really a test release for some people developing drivers on
newer kernels and I didn't want to hold them out any longer.  It's
stable but not everything I want to do has been included yet.  I expect
to do another release within a week or so with some small extras and
fixups.  The high level changes from the previous release:

    * sync up with latest FreeBSD API Changes.
    * pull in quite a few changes from the OpenSwan OCF version (more coming).
    * 2.6 kernel support up to and including 2.6.22.
    * 2.4 kernel support up to and including 2.4.35.
    * full cryptosoft support for new kernel crypto API.
    * updated openswan patch to 2.4.9 (with additional support for above
      kernels).

Tested under 2.4.35 and 2.6.22 across multiple architectures.
Also,  join up the mailing list if you are interested/working on this:

    http://lists.sourceforge.net/mailman/listinfo/ocf-linux-users

Cheers,
Davidm

-- 
David McCullough,  david_mccullough@securecomputing.com,   Ph:+61 734352815
Secure Computing - SnapGear  http://www.uCdot.org http://www.cyberguard.com
