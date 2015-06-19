From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: variable iv lengths for aes-gcm
Date: Fri, 19 Jun 2015 08:18:21 +0800
Message-ID: <20150619001821.GA7103@gondor.apana.org.au>
References: <55827696.20704@freescale.com>
 <20150618080707.GA29218@gondor.apana.org.au>
 <558292E6.3060708@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Ambarus Tudor-Dan-B38632 <b38632@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47742 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbbFSASo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Jun 2015 20:18:44 -0400
Content-Disposition: inline
In-Reply-To: <558292E6.3060708@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 18, 2015 at 12:44:06PM +0300, Ambarus Tudor-Dan-B38632 wrote:
>
> The reason is to cover a wide range of applications. Your question
> also applies to the gcm NIST publication.
> 
> Users may want to use a crypto module that meets the requirements of
> FIPS Pub. for various applications that use variable lengths for IV.

What are these applications?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
