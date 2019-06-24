Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34E28C4646C
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 21:17:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06B6620663
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 21:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561411062;
	bh=zOBYbFXqM8DxgurbaRhW+kE+i14AA0Y+8NLki53wcTA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Wyq9yuB9U/Vd/gy1oWX9aAaSlcEXvOalgTGbVzBqs24t+d7yq8v1eoOyWBLHZ3lLB
	 M4hjrFEQmEBo6AD8Pr8ktIFTSRz+dkUW/dFPMSynz41lGASCQ/tMf4+zlfBTzdI6FD
	 LK4zDBbRePWm/52mWMBWbHcpuVBr9KjcEATCtCCE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbfFXVRk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 17:17:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbfFXVRk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 17:17:40 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27569205F4;
        Mon, 24 Jun 2019 21:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561411059;
        bh=zOBYbFXqM8DxgurbaRhW+kE+i14AA0Y+8NLki53wcTA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=waLY1k8P6FJMdjUwsPgNvvgYFeQZXZwOIamcvkCbdQu289JkncbHHDtycSm65OapF
         wNxNIidoA2Ym6QYRowuSqUwqDnkKWdaZ6Jp9BYufjGezsdPzE35lBd1goJUAZgBWIk
         XJaGZnOk39lWQHd/QV5NV1bWE6h866lH8cfQ/pg0=
Date:   Mon, 24 Jun 2019 14:17:37 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     syzbot <syzbot+f7baccc38dcc1e094e77@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: lib/mpi: Fix karactx leak in mpi_powm
Message-ID: <20190624211736.GA237341@gmail.com>
References: <000000000000617b4a058c0cbd60@google.com>
 <20190624103226.fbjvc6eumu325ifw@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624103226.fbjvc6eumu325ifw@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 24, 2019 at 06:32:26PM +0800, Herbert Xu wrote:
> On Mon, Jun 24, 2019 at 12:27:08AM -0700, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following crash on:
> > 
> > HEAD commit:    abf02e29 Merge tag 'pm-5.2-rc6' of git://git.kernel.org/pu..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=17a8bfeaa00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=56f1da14935c3cce
> > dashboard link: https://syzkaller.appspot.com/bug?extid=f7baccc38dcc1e094e77
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=171aa7e6a00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=153306cea00000
> > 
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+f7baccc38dcc1e094e77@syzkaller.appspotmail.com
> 
> The only memory leak that I can find is on the out-of-memory error
> path:
> 
> ---8<---
> Sometimes mpi_powm will leak karactx because a memory allocation
> failure causes a bail-out that skips the freeing of karactx.  This
> patch moves the freeing of karactx to the end of the function like
> everything else so that it can't be skipped.
> 
> Reported-by: syzbot+f7baccc38dcc1e094e77@syzkaller.appspotmail.com
> Fixes: cdec9cb5167a ("crypto: GnuPG based MPI lib - source files...")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/lib/mpi/mpi-pow.c b/lib/mpi/mpi-pow.c
> index 82b19e4f1189..2fd7a46d55ec 100644
> --- a/lib/mpi/mpi-pow.c
> +++ b/lib/mpi/mpi-pow.c
> @@ -24,6 +24,7 @@
>  int mpi_powm(MPI res, MPI base, MPI exp, MPI mod)
>  {
>  	mpi_ptr_t mp_marker = NULL, bp_marker = NULL, ep_marker = NULL;
> +	struct karatsuba_ctx karactx = {};
>  	mpi_ptr_t xp_marker = NULL;
>  	mpi_ptr_t tspace = NULL;
>  	mpi_ptr_t rp, ep, mp, bp;
> @@ -150,13 +151,11 @@ int mpi_powm(MPI res, MPI base, MPI exp, MPI mod)
>  		int c;
>  		mpi_limb_t e;
>  		mpi_limb_t carry_limb;
> -		struct karatsuba_ctx karactx;
>  
>  		xp = xp_marker = mpi_alloc_limb_space(2 * (msize + 1));
>  		if (!xp)
>  			goto enomem;
>  
> -		memset(&karactx, 0, sizeof karactx);
>  		negative_result = (ep[0] & 1) && base->sign;
>  
>  		i = esize - 1;
> @@ -281,8 +280,6 @@ int mpi_powm(MPI res, MPI base, MPI exp, MPI mod)
>  		if (mod_shift_cnt)
>  			mpihelp_rshift(rp, rp, rsize, mod_shift_cnt);
>  		MPN_NORMALIZE(rp, rsize);
> -
> -		mpihelp_release_karatsuba_ctx(&karactx);
>  	}
>  
>  	if (negative_result && rsize) {
> @@ -299,6 +296,7 @@ int mpi_powm(MPI res, MPI base, MPI exp, MPI mod)
>  leave:
>  	rc = 0;
>  enomem:
> +	mpihelp_release_karatsuba_ctx(&karactx);
>  	if (assign_rp)
>  		mpi_assign_limb_space(res, rp, size);
>  	if (mp_marker)
> -- 

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

- Eric
