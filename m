Return-Path: <SRS0=PsuD=V6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FE89C433FF
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 04:56:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B4982073D
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 04:56:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732348AbfHBE45 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Aug 2019 00:56:57 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:48752 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732095AbfHBE45 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Aug 2019 00:56:57 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1htPcd-0006N7-LJ; Fri, 02 Aug 2019 14:56:55 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1htPcc-0004ld-Jv; Fri, 02 Aug 2019 14:56:54 +1000
Date:   Fri, 2 Aug 2019 14:56:54 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Hook, Gary" <Gary.Hook@amd.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
Subject: Re: [PATCH 0/3] AES GCM fixes for the CCP crypto driver
Message-ID: <20190802045654.GK18077@gondor.apana.org.au>
References: <20190730160454.7617-1-gary.hook@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730160454.7617-1-gary.hook@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 30, 2019 at 04:05:07PM +0000, Hook, Gary wrote:
> Additional testing features added to the crypto framework (including fuzzy
> probing and variations of the lengths of input parameters such as AAD and
> authsize) expose some gaps in robustness and function in the CCP driver.
> Address these gaps:
> 
> Input text is allowed to be zero bytes in length. In this case no
> encryption/decryption occurs, and certain data structures are not
> allocated. Don't clean up what doesn't exist.
> 
> Valid auth tag sizes are 4, 8, 12, 13, 14, 15 or 16 bytes.
> Note: since the CCP driver has been designed to be used directly, add
>       validation of the authsize parameter at this layer.
> 
> AES GCM defines the input text for decryption as the concatenation of
> the AAD, the ciphertext, and the tag. Only the cipher text needs to
> be decrypted; the tag is simple used for comparison.
> 
> Gary R Hook (3):
>   crypto: ccp - Fix oops by properly managing allocated structures
>   crypto: ccp - Add support for valid authsize values less than 16
>   crypto: ccp - Ignore tag length when decrypting GCM ciphertext
> 
>  drivers/crypto/ccp/ccp-crypto-aes-galois.c | 14 +++++++++
>  drivers/crypto/ccp/ccp-ops.c               | 33 ++++++++++++++++------
>  include/linux/ccp.h                        |  2 ++
>  3 files changed, 40 insertions(+), 9 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
