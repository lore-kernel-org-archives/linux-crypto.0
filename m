From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ccp - Fix XTS-AES-128 support on v5 CCPs
Date: Thu, 3 Aug 2017 14:27:20 +0800
Message-ID: <20170803062720.GS12039@gondor.apana.org.au>
References: <150100993132.39127.12837177440399767043.stgit@sosxen.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
        davem@davemloft.net
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:58558 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751220AbdHCG11 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Aug 2017 02:27:27 -0400
Content-Disposition: inline
In-Reply-To: <150100993132.39127.12837177440399767043.stgit@sosxen.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 25, 2017 at 02:12:11PM -0500, Gary R Hook wrote:
> Version 5 CCPs have some new requirements for XTS-AES: the type field
> must be specified, and the key requires 512 bits, with each part
> occupying 256 bits and padded with zeroes.
> 
> cc: <stable@vger.kernel.org> # 4.9.x+
> 
> Signed-off-by: Gary R Hook <ghook@amd.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
