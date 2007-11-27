From: "Tan Swee Heng" <thesweeheng@gmail.com>
Subject: [PATCH 1/2] tcrypt.c: Support for more test vectors
Date: Wed, 28 Nov 2007 07:19:17 +0800
Message-ID: <fd3e431c0711271519j14fcd71aqc399c1dc524df274@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Herbert Xu" <herbert@gondor.apana.org.au>,
	"Linux Crypto" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.190]:13793 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbXK0XTS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 Nov 2007 18:19:18 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1048879rvb
        for <linux-crypto@vger.kernel.org>; Tue, 27 Nov 2007 15:19:18 -0800 (PST)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Currently the number of entries in a cipher test vector template is
limited by TVMEMSIZE/sizeof(struct cipher_testvec). This patch
circumvents the problem by pointing cipher_tv to each entry in the
template, rather than the template itself.

Signed-off-by: Tan Swee Heng <thesweeheng@gmail.com>
