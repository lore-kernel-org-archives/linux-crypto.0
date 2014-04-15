From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v5 1/6] SP800-90A Deterministic Random Bit Generator
Date: Mon, 14 Apr 2014 22:51:05 -0700
Message-ID: <1397541065.16090.11.camel@joe-AO722>
References: <2396177.vxvG2ljJL8@myon.chronox.de>
	 <1952806.u8ySj6rIyr@myon.chronox.de> <3972168.arX3qfUzsN@myon.chronox.de>
	 <1635225.UnHjb6h9ND@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	aquini@redhat.com, jeremy.wayne.powell@gmail.com,
	clemens@ladisch.de, pwalten@au1.ibm.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtprelay0043.hostedemail.com ([216.40.44.43]:58518 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750875AbaDOFvK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Apr 2014 01:51:10 -0400
In-Reply-To: <1635225.UnHjb6h9ND@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2014-04-15 at 07:35 +0200, Stephan Mueller wrote:
> diff --git a/crypto/drbg.c b/crypto/drbg.c
[]
> @@ -0,0 +1,1997 @@
[]
> +/***************************************************************
> + * Backend cipher definitions available to DRBG
> + ***************************************************************/
> +
> +const struct drbg_core cores[] = {

cores isn't a very good global name.
I presume this should be static.
