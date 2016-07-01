From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - make qat_asym_algs.o depend on asn1 headers
Date: Fri, 1 Jul 2016 17:30:08 +0800
Message-ID: <20160701093008.GB13424@gondor.apana.org.au>
References: <a53076f443d43d1153dcef0fb35126b5753b08c7.1467281942.git.jstancek@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tadeusz.struk@intel.com, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Salvatore Benedetto <salvatore.benedetto@intel.com>
To: Jan Stancek <jstancek@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43083 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbcGAJca (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 1 Jul 2016 05:32:30 -0400
Content-Disposition: inline
In-Reply-To: <a53076f443d43d1153dcef0fb35126b5753b08c7.1467281942.git.jstancek@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 30, 2016 at 12:23:51PM +0200, Jan Stancek wrote:
> Parallel build can sporadically fail because asn1 headers may
> not be built yet by the time qat_asym_algs.o is compiled:
>   drivers/crypto/qat/qat_common/qat_asym_algs.c:55:32: fatal error: qat_rsapubkey-asn1.h: No such file or directory
>    #include "qat_rsapubkey-asn1.h"
> 
> Signed-off-by: Jan Stancek <jstancek@redhat.com>
> Cc: Tadeusz Struk <tadeusz.struk@intel.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>

Jan, Salvatore just posted a patch to delete the qat ASN code
altogether, so your patch won't be needed.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
