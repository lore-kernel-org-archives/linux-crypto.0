From: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
Subject: Where has CRYPTO_TFM_MODE_nnn gone?
Date: Thu, 7 Jun 2007 17:06:17 -0700
Message-ID: <46689D79.8020908@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Cc: Shane McDonald <Shane_McDonald@pmc-sierra.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from father.pmc-sierra.com ([216.241.224.13]:39251 "HELO
	father.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1765426AbXFHANg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 7 Jun 2007 20:13:36 -0400
Received: from bby1exi01.pmc_nt.nt.pmc-sierra.bc.ca (bby1exi01.pmc-sierra.bc.ca [216.241.231.251])
	by pmxedge2.pmc-sierra.bc.ca (8.13.4/8.12.7) with ESMTP id l5806sdr003867
	for <linux-crypto@vger.kernel.org>; Thu, 7 Jun 2007 17:06:54 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi all,

I'm porting a security engine driver from 2.6.18 to 2.6.21/22. I've found
that although 'cit_mode' is still in struct cipher_tfm, the definitions
for CRYPTO_TFM_MODE_ECB and CRYPTO_TFM_MODE_CBC are gone!

Our HW needs to know what mode to set up some SA flags. Any advice on
how to best find this mode from a common cipher function which can handle
AES, DES and 3DES?

Advance thanks,
Marc
