From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v6 0/3] Add Support for Cavium Cryptographic Acceleration
 Unit
Date: Sat, 11 Feb 2017 18:57:07 +0800
Message-ID: <20170211105707.GL855@gondor.apana.org.au>
References: <1486479075-1813-1-git-send-email-george.cherian@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, david.daney@cavium.com,
        clabbe.montjoie@gmail.com, smueller@chronox.de,
        levinsasha928@gmail.com, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
To: George Cherian <george.cherian@cavium.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36097 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751014AbdBKS7E (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Feb 2017 13:59:04 -0500
Content-Disposition: inline
In-Reply-To: <1486479075-1813-1-git-send-email-george.cherian@cavium.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 07, 2017 at 02:51:12PM +0000, George Cherian wrote:
> This series adds the support for Cavium Cryptographic Accelerarion Unit (CPT) 
> CPT is available in Cavium's Octeon-Tx SoC series.                            
>                                                                               
> The series was tested with ecryptfs and dm-crypt for in kernel cryptographic
> offload operations. This driver needs a firmware to work, I will be sending the
> firmware to linux-firmware once the driver is accepted.
> 
> Cahnges v5 -> v6
> 	-- Addressed Sasha Levin's comments.
> 		- Remove open coding of hlist_for_each_entry_safe, instead use
> 		  the same.
> 		- Remove the direct access of hlist members
> 		- Remove unwanted argument checks.

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
