From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RESEND] crypto: gf128mul - remove dead gf128mul_64k_lle
 code
Date: Sun, 13 Nov 2016 19:31:42 +0800
Message-ID: <20161113113142.GA8028@gondor.apana.org.au>
References: <1478654218-49724-1-git-send-email-alexcope@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, alexcope@google.com
To: Alex Cope <alexcope@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36928 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934420AbcKMLbv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Nov 2016 06:31:51 -0500
Content-Disposition: inline
In-Reply-To: <1478654218-49724-1-git-send-email-alexcope@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Alex Cope <alexcope@google.com> wrote:
> This code is unlikely to be useful in the future because transforms
> don't know how often keys will be changed, new algorithms are unlikely
> to use lle representation, and tables should be replaced with
> carryless multiplication instructions when available.
> 
> Signed-off-by: Alex Cope <alexcope@google.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
