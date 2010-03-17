From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: cryptodev support
Date: Wed, 17 Mar 2010 13:50:05 +0100
Message-ID: <4BA0CFFD.7080705@gnutls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:43876 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab0CQMuK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Mar 2010 08:50:10 -0400
Received: by ey-out-2122.google.com with SMTP id d26so51417eyd.19
        for <linux-crypto@vger.kernel.org>; Wed, 17 Mar 2010 05:50:09 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,
 I needed to access crypto hardware modules from userspace and I made
that by adding cryptodev support on top of linux-crypto. It is a
separate module available at:
http://repo.or.cz/w/cryptodev-linux.git

It was originally based on the old cryptodev module found at
http://www.logix.cz/michal/devel/cryptodev/

In the extras directory there is a patch for openssl that will make use
of the /dev/crypto. Gnutls (2.9.x) will use /dev/crypto if it compiled
with --enable-cryptodev.

regards,
Nikos
