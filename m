From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: s390 ghash
Date: Wed, 13 May 2015 18:08:03 +0800
Message-ID: <20150513100803.GA29694@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>,
	Jan Glauber <jang@linux.vnet.ibm.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38317 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932954AbbEMKIM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 May 2015 06:08:12 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

It appears that your implementation of ghash is buggy:

https://bugzilla.redhat.com/show_bug.cgi?id=1207598

The gist of the report is that using s390 ghash causes IPsec
to fail when the other side is x86_64.  Using the generic ghash
code on the s390 side fixes it.

Please look into this.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
