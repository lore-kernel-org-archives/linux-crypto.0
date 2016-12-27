From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCHv2] crypto: testmgr: Use heap buffer for acomp test input
Date: Tue, 27 Dec 2016 18:06:33 +0800
Message-ID: <20161227100633.GH10629@gondor.apana.org.au>
References: <1482352374-22750-1-git-send-email-labbott@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Christopher Covington <cov@codeaurora.org>
To: Laura Abbott <labbott@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40443 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752940AbcL0KGy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Dec 2016 05:06:54 -0500
Content-Disposition: inline
In-Reply-To: <1482352374-22750-1-git-send-email-labbott@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 21, 2016 at 12:32:54PM -0800, Laura Abbott wrote:
> 
> Christopher Covington reported a crash on aarch64 on recent Fedora
> kernels:
> 
> kernel BUG at ./include/linux/scatterlist.h:140!
> Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
> Modules linked in:
> CPU: 2 PID: 752 Comm: cryptomgr_test Not tainted 4.9.0-11815-ge93b1cc #162
> Hardware name: linux,dummy-virt (DT)
> task: ffff80007c650080 task.stack: ffff800008910000
> PC is at sg_init_one+0xa0/0xb8
> LR is at sg_init_one+0x24/0xb8
> ...
> [<ffff000008398db8>] sg_init_one+0xa0/0xb8
> [<ffff000008350a44>] test_acomp+0x10c/0x438
> [<ffff000008350e20>] alg_test_comp+0xb0/0x118
> [<ffff00000834f28c>] alg_test+0x17c/0x2f0
> [<ffff00000834c6a4>] cryptomgr_test+0x44/0x50
> [<ffff0000080dac70>] kthread+0xf8/0x128
> [<ffff000008082ec0>] ret_from_fork+0x10/0x50
> 
> The test vectors used for input are part of the kernel image. These
> inputs are passed as a buffer to sg_init_one which eventually blows up
> with BUG_ON(!virt_addr_valid(buf)). On arm64, virt_addr_valid returns
> false for the kernel image since virt_to_page will not return the
> correct page. Fix this by copying the input vectors to heap buffer
> before setting up the scatterlist.
> 
> Reported-by: Christopher Covington <cov@codeaurora.org>
> Fixes: d7db7a882deb ("crypto: acomp - update testmgr with support for acomp")
> Signed-off-by: Laura Abbott <labbott@redhat.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
