From: David McCullough <David_Mccullough@securecomputing.com>
Subject: ocf-linux-20071215 - Asynchronous Crypto support for linux
Date: Sat, 15 Dec 2007 22:40:02 +1000
Message-ID: <20071215124002.GA10221@securecomputing.com>
References: <20070727133641.GA29614@securecomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: ocf-linux-users@lists.sourceforge.net, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rex.snapgear.com ([203.143.235.140]:35387 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752240AbXLOMf0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 15 Dec 2007 07:35:26 -0500
Content-Disposition: inline
In-Reply-To: <20070727133641.GA29614@securecomputing.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Hi all,

A new release of the ocf-linux package is up (20071215):

    http://ocf-linux.sourceforge.net/

Most of the fallout from the last release which included some
significant API changes has been cleaned up.  The notable updates are:

	* New PA Semi driver
	* Talitos driver fully updated
	* various locking bugs fixed
	* other cleanups
	* openssl-0.9.8g patch
	* openswan-2.4.11 patch
	* linux-2.6.23 support

Tested under 2.4.35 and 2.6.23 across multiple architectures.
Also,  join up the mailing list if you are interested/working on this:

    http://lists.sourceforge.net/mailman/listinfo/ocf-linux-users

Cheers,
Davidm

-- 
David McCullough,  david_mccullough@securecomputing.com,   Ph:+61 734352815
Secure Computing - SnapGear  http://www.uCdot.org http://www.cyberguard.com
