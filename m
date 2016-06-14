From: Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>
Subject: RE: [PATCH v5] crypto: rsa - return raw integers for the ASN.1 parser
Date: Tue, 14 Jun 2016 14:35:40 +0000
Message-ID: <AMSPR04MB53680C1D3CBC3F27950B5C1B8540@AMSPR04MB536.eurprd04.prod.outlook.com>
References: <1465910098-16349-1-git-send-email-tudor-dan.ambarus@nxp.com>
 <2066344.ohg9RiuaKP@tauon.atsec.com>
 <20160614133806.GA22193@gondor.apana.org.au>
 <1920297.cMHx9vzUDS@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-am1on0064.outbound.protection.outlook.com ([157.56.112.64]:44535
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751483AbcFNOfm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jun 2016 10:35:42 -0400
In-Reply-To: <1920297.cMHx9vzUDS@tauon.atsec.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

> But then I need to refine my question: isn't rsa_parse_priv_key allocating
> the
> MPIs (at least rsa_parse_priv_key seems to hint to that considering the
> error
> code path)? So, shouldn't the MPIs be freed here with free_mpis()? This
> would
> apply to parse_pub_key too.

rsa_parse_priv_key is not allocating the MPIs, mpi_read_raw_data is.

MPIs are freed on error path. On success, they are freed when exiting
the tfm or when setting a new key.

Thanks,
ta
