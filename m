From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] crypto: tcrypt - fix buffer lengths in
 test_aead_speed()
Date: Fri, 3 Nov 2017 22:22:12 +0800
Message-ID: <20171103142212.GC9011@gondor.apana.org.au>
References: <1507630920-9014-1-git-send-email-robert.baronescu@nxp.com>
 <1507630920-9014-2-git-send-email-robert.baronescu@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Robert Baronescu <robert.baronescu@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:38062 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751387AbdKCOWi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Nov 2017 10:22:38 -0400
Content-Disposition: inline
In-Reply-To: <1507630920-9014-2-git-send-email-robert.baronescu@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 10, 2017 at 01:22:00PM +0300, Robert Baronescu wrote:
> Fix the way the length of the buffers used for
> encryption / decryption are computed.
> For e.g. in case of encryption, input buffer does not contain
> an authentication tag.
> 
> Signed-off-by: Robert Baronescu <robert.baronescu@nxp.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
