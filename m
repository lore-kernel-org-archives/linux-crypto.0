From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: crypto_shash_digest API
Date: Tue, 23 Nov 2010 09:34:01 -0500
Message-ID: <1290522841.2606.168.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37580 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754436Ab0KWOeH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Nov 2010 09:34:07 -0500
Received: from d01dlp02.pok.ibm.com (d01dlp02.pok.ibm.com [9.56.224.85])
	by e1.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id oANEQCbO018172
	for <linux-crypto@vger.kernel.org>; Tue, 23 Nov 2010 09:26:12 -0500
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id ABF0C4DE8039
	for <linux-crypto@vger.kernel.org>; Tue, 23 Nov 2010 09:32:41 -0500 (EST)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id oANEY2TM1912940
	for <linux-crypto@vger.kernel.org>; Tue, 23 Nov 2010 09:34:02 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id oANEY1kX025925
	for <linux-crypto@vger.kernel.org>; Tue, 23 Nov 2010 12:34:02 -0200
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi!

Am having problems finding any shash API documentation.  Could someone
tell me if 'out' needs to be zeroed before calling crypto_shash_digest?

int crypto_shash_digest(struct shash_desc *desc, const u8 *data,
                        unsigned int len, u8 *out)

thanks,

Mimi
