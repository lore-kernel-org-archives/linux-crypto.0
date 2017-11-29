From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: general protection fault in af_alg_free_areq_sgls
Date: Wed, 29 Nov 2017 11:51:09 -0800
Message-ID: <20171129195109.GB29498@gmail.com>
References: <001a1140f578d9710d055efb76a9@google.com>
 <20171128090252.GB23413@zzz.localdomain>
 <20171129052352.GB19831@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: syzbot
        <bot+ff72ab869817b6ea60bc570f638ee030f4fc73e5@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:33989 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752014AbdK2TvN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Nov 2017 14:51:13 -0500
Content-Disposition: inline
In-Reply-To: <20171129052352.GB19831@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 29, 2017 at 04:23:53PM +1100, Herbert Xu wrote:
> On Tue, Nov 28, 2017 at 01:02:52AM -0800, Eric Biggers wrote:
> > 
> > >From 1a7a7f86f09c50652f1fff75b8d3a32712826b32 Mon Sep 17 00:00:00 2001
> > From: Eric Biggers <ebiggers@google.com>
> > Date: Tue, 28 Nov 2017 00:46:24 -0800
> > Subject: [PATCH] crypto: af_alg - fix NULL pointer dereference in
> >  af_alg_free_areq_sgls()
> > 
> > If allocating the ->tsgl member of 'struct af_alg_async_req' failed,
> > during cleanup we dereferenced the NULL ->tsgl pointer in
> > af_alg_free_areq_sgls(), because ->tsgl_entries was nonzero.
> > 
> > Fix it by only freeing the ->tsgl list if it is non-NULL.
> > 
> > This affected both algif_skcipher and algif_aead.
> > 
> > Fixes: e870456d8e7c ("crypto: algif_skcipher - overhaul memory management")
> > Fixes: d887c52d6ae4 ("crypto: algif_aead - overhaul memory management")
> > Reported-by: syzbot <syzkaller@googlegroups.com>
> > Cc: <stable@vger.kernel.org> # v4.14+
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Patch applied.  Thanks.

Herbert, if it's not too late can you fix the subject?  It got split into two
lines:

commit 887207ed9e5812ed9239b6d07185a2d35dda91db
Author: Eric Biggers <ebiggers@google.com>
Date:   Tue Nov 28 00:46:24 2017 -0800

    crypto: af_alg - fix NULL pointer dereference in
    
     af_alg_free_areq_sgls()
    
    If allocating the ->tsgl member of 'struct af_alg_async_req' failed,
    during cleanup we dereferenced the NULL ->tsgl pointer in
    af_alg_free_areq_sgls(), because ->tsgl_entries was nonzero.
    
    Fix it by only freeing the ->tsgl list if it is non-NULL.
    
    This affected both algif_skcipher and algif_aead.
    
    Fixes: e870456d8e7c ("crypto: algif_skcipher - overhaul memory management")
    Fixes: d887c52d6ae4 ("crypto: algif_aead - overhaul memory management")
    Reported-by: syzbot <syzkaller@googlegroups.com>
    Cc: <stable@vger.kernel.org> # v4.14+
    Signed-off-by: Eric Biggers <ebiggers@google.com>
    Reviewed-by: Stephan Mueller <smueller@chronox.de>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
