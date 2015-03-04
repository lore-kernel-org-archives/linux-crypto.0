From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [v1,1/3] crypto: powerpc/md5 - assembler
Date: Wed, 4 Mar 2015 22:17:38 +1300
Message-ID: <20150304091738.GA9268@gondor.apana.org.au>
References: <dfab72c4-908c-43ce-bb28-480afc0c9536@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
To: Markus Stockhausen <stockhausen@collogia.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:56696 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759600AbbCDJRo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 Mar 2015 04:17:44 -0500
Content-Disposition: inline
In-Reply-To: <dfab72c4-908c-43ce-bb28-480afc0c9536@EXCHANGE.collogia.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Mar 01, 2015 at 07:30:35PM +0100, Markus Stockhausen wrote:
> This is the assembler code for the MD5 implementation.
> Handling of algorithm constants has been slightly
> changed to reduce register usage and make better use
> of cores with multiple ALUs. Thus they are stored as
> delta values.
> 
> Signed-off-by: Markus Stockhausen <stockhausen@collogia.de>

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
