From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: crypto: qat - Add support for RSA algorithm
Date: Mon, 20 Jul 2015 18:12:47 +0300
Message-ID: <20150720151247.GK5422@mwanda>
References: <20150720151236.GA5464@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: qat-linux@intel.com, linux-crypto@vger.kernel.org
To: tadeusz.struk@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29847 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbbGTPMw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Jul 2015 11:12:52 -0400
Content-Disposition: inline
In-Reply-To: <20150720151236.GA5464@mwanda>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Also:

	drivers/crypto/qat/qat_common/qat_asym_algs.c:513 qat_rsa_get_d()
	warn: was && intended here instead of ||?

regards,
dan carpenter
