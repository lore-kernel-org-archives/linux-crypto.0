From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: HMAC and stuff
Date: Thu, 29 Dec 2011 20:31:02 +0300
Message-ID: <20111229173101.GA3706@p183.telecom.by>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:46582 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab1L2RbH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 29 Dec 2011 12:31:07 -0500
Received: by wibhm6 with SMTP id hm6so6428423wib.19
        for <linux-crypto@vger.kernel.org>; Thu, 29 Dec 2011 09:31:05 -0800 (PST)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

aalg_list array contains list of "approved" HMAC algorightms.
Do I understand correctly that to update this list some sort of
official document like RFC has to be present?

For example, it contains hmac(rmd160) entry, but doesn't contain hmac(rmd128)
and other RIPEMD functions (there is even test for hmac(rmd128)).

Also, kernel has more cryptographic hash functions than there are allowed
by ipsec code like Tiger hashes, Whirlpool etc. They are dead code, if
IPSec code doesn't user to use them.
