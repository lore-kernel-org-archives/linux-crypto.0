From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: cavium/cpt: Fix couple of static checker errors
Date: Mon, 27 Feb 2017 18:36:59 +0800
Message-ID: <20170227103659.GA31739@gondor.apana.org.au>
References: <1487162539-29269-1-git-send-email-george.cherian@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, dan.carpenter@oracle.com,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: George Cherian <george.cherian@cavium.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:32869 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751620AbdB0K7S (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Feb 2017 05:59:18 -0500
Content-Disposition: inline
In-Reply-To: <1487162539-29269-1-git-send-email-george.cherian@cavium.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 15, 2017 at 12:42:19PM +0000, George Cherian wrote:
> Fix the following smatch errors
> cptvf_reqmanager.c:333 do_post_process() warn: variable dereferenced
> before check 'cptvf'
> cptvf_main.c:825 cptvf_remove() error: we previously assumed 'cptvf'
> could be null
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: George Cherian <george.cherian@cavium.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
