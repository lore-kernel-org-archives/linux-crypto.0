From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] drivers/crypto/ccp: return NULL instead of 0
Date: Mon, 19 Jun 2017 14:39:02 +0800
Message-ID: <20170619063902.GB13651@gondor.apana.org.au>
References: <1493784129-32613-1-git-send-email-pushkar.iit@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER"
        <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
To: Pushkar Jambhlekar <pushkar.iit@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:59642 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750952AbdFSGjW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jun 2017 02:39:22 -0400
Content-Disposition: inline
In-Reply-To: <1493784129-32613-1-git-send-email-pushkar.iit@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 03, 2017 at 09:32:09AM +0530, Pushkar Jambhlekar wrote:
> This change is to handle sparse warning. Return type of function is a pointer to the structure and
> it returns 0. Instead it should return NULL.
> 
> Signed-off-by: Pushkar Jambhlekar <pushkar.iit@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
