From: Tzvi Chumash <tzvi@research.att.com>
Subject: blowfish from openSSL to kernel cryptoAPI
Date: Mon, 02 May 2011 18:34:30 -0400
Message-ID: <ipnbl5$ug4$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:53215 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646Ab1EBWkI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 May 2011 18:40:08 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkc-linux-crypto@m.gmane.org>)
	id 1QH1mg-0000EU-7B
	for linux-crypto@vger.kernel.org; Tue, 03 May 2011 00:40:06 +0200
Received: from 135.207.174.202 ([135.207.174.202])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-crypto@vger.kernel.org>; Tue, 03 May 2011 00:40:06 +0200
Received: from tzvi by 135.207.174.202 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-crypto@vger.kernel.org>; Tue, 03 May 2011 00:40:06 +0200
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I'm trying (without much success) to decrypt in-kernel 
(2.6.18-194.el5PAE) a cipher that was created using openSSL 
(0.9.8e-fips-rhel5) using blowfish with a 56-byte key/8-byte iv. Are the 
implementations incompatible (i.e. can't encrypt in one and decrypt in 
the other?) or am I doing something wrong?

Thanks,

Tzvi
