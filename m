From: "Tan Swee Heng" <thesweeheng@gmail.com>
Subject: [PATCH 2/3] salsa20_i586: Salsa20 stream cipher algorithm (i586 version)
Date: Thu, 22 Nov 2007 05:17:30 +0800
Message-ID: <fd3e431c0711211317rcec242t88fb44fba3def1ae@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>
To: "Linux Crypto" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.185]:9954 "EHLO
	rn-out-0102.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751620AbXKUVRc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Nov 2007 16:17:32 -0500
Received: by rn-out-0102.google.com with SMTP id s46so3768408rnb
        for <linux-crypto@vger.kernel.org>; Wed, 21 Nov 2007 13:17:30 -0800 (PST)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch implements the glue code that uses the Salsa20 x86-pm
assembly code written by D. J. Bernstein.
Original assembly code is available at
<http://cr.yp.to/snuffle/salsa20/x86-pm/salsa20.s>.

Signed-off-by: Tan Swee Heng <thesweeheng@gmail.com>
