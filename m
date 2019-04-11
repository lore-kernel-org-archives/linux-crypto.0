Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 935A4C10F13
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 04:39:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F44F21841
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 04:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554957579;
	bh=zRe4hT2wLPGrkGrDM5o092pBXMx64ey3Cu6aA1nRW9Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=NFijNqSlFq6jPS/pJWeNpWGGm554xX/OoZalPtJpHtTsTOTVSmbbyLqW+Ttv/Wyn2
	 90lKyQISF0zjSRbbby99nJqEr8Be9nFnE6VQCgpMg53VUBLzX6Maprupnk5loRTYXQ
	 E0hf8viL6V84PcOlebXCPArHJVBMXNA+PX2B+tb4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbfDKEji (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 00:39:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:52456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfDKEji (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 00:39:38 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 409D6217D4;
        Thu, 11 Apr 2019 04:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554957576;
        bh=zRe4hT2wLPGrkGrDM5o092pBXMx64ey3Cu6aA1nRW9Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U6pJgjv7k1v5fZ/fa2QHTExOqVP2swQp5BquVC/4VPNOsGU7M8tB5mhVQNx8LG+u+
         LMHjz9iM8QNhuBKk2778QysjB6CR6nTE1fdnrAwwcJqq7eDSJR7vWa8xBKLfMYOnH5
         yLrQe/0P0xWchvlOuUYjvoxMtOPDc+WIqquiyHx8=
Date:   Wed, 10 Apr 2019 21:39:34 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Guenter Roeck <linux@roeck-us.net>, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>, tglx@linutronix.de
Subject: Re: [PATCH 2/2] crypto: scompress: Use per-CPU struct instead
 multiple variables
Message-ID: <20190411043933.GA5866@sol.localdomain>
References: <20190329130956.15935-1-bigeasy@linutronix.de>
 <20190329130956.15935-2-bigeasy@linutronix.de>
 <20190411040734.GA2292@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190411040734.GA2292@roeck-us.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 10, 2019 at 09:07:35PM -0700, Guenter Roeck wrote:
> Hi Sebastian,
> 
> On Fri, Mar 29, 2019 at 02:09:56PM +0100, Sebastian Andrzej Siewior wrote:
> > Two per-CPU variables are allocated as pointer to per-CPU memory which
> > then are used as scratch buffers.
> > We could be smart about this and use instead a per-CPU struct which
> > contains the pointers already and then we need to allocate just the
> > scratch buffers.
> > Add a lock to the struct. By doing so we can avoid the get_cpu()
> > statement and gain lockdep coverage (if enabled) to ensure that the lock
> > is always acquired in the right context. On non-preemptible kernels the
> > lock vanishes.
> > It is okay to use raw_cpu_ptr() in order to get a pointer to the struct
> > since it is protected by the spinlock.
> > 
> > The diffstat of this is negative and according to size scompress.o:
> >    text    data     bss     dec     hex filename
> >    1847     160      24    2031     7ef dbg_before.o
> >    1754     232       4    1990     7c6 dbg_after.o
> >    1799      64      24    1887     75f no_dbg-before.o
> >    1703      88       4    1795     703 no_dbg-after.o
> > 
> > The overall size increase difference is also negative. The increase in
> > the data section is only four bytes without lockdep.
> > 
> 
> Unfortunately, this patch causes random crashes.
> 
> [   13.084225] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
> [   13.084687] Mem abort info:
> [   13.084821]   ESR = 0x96000044
> [   13.085008]   Exception class = DABT (current EL), IL = 32 bits
> [   13.085189]   SET = 0, FnV = 0
> [   13.085331]   EA = 0, S1PTW = 0
> [   13.085468] Data abort info:
> [   13.086018]   ISV = 0, ISS = 0x00000044
> [   13.086185]   CM = 0, WnR = 1
> [   13.086379] [0000000000000000] user address but active_mm is swapper
> [   13.087032] Internal error: Oops: 96000044 [#1] PREEMPT SMP
> [   13.087322] Modules linked in:
> [   13.087645] Process cryptomgr_test (pid: 165, stack limit = 0x(____ptrval____))
> [   13.088038] CPU: 1 PID: 165 Comm: cryptomgr_test Not tainted 5.1.0-rc4-next-20190410 #1
> [   13.088250] Hardware name: ZynqMP ZCU102 Rev1.0 (DT)
> [   13.088530] pstate: 80000005 (Nzcv daif -PAN -UAO)
> [   13.088740] pc : __memcpy+0xc0/0x180
> [   13.088887] lr : scatterwalk_copychunks+0xd4/0x1e8
> [   13.089033] sp : ffff000012f2ba50
> [   13.089139] x29: ffff000012f2ba50 x28: ffff80007a7c0500 
> [   13.089324] x27: 0000000000000000 x26: ffff000012f2bae8 
> [   13.089460] x25: 0000000000000046 x24: 0000000000000046 
> [   13.089643] x23: ffff80007a004440 x22: 0000000000000046 
> [   13.089815] x21: 0000000000000000 x20: 000081ffffffffff 
> [   13.089974] x19: 0000000000000000 x18: 00000000000007ff 
> [   13.090111] x17: 0000000000000000 x16: 0000000000000000 
> [   13.090264] x15: ffff0000130ff748 x14: 0000000000000000 
> [   13.090414] x13: ffff000011c509e8 x12: ffff000011a46980 
> [   13.090569] x11: ffff000011a46000 x10: 0000000000000001 
> [   13.090736] x9 : 0000000000000000 x8 : 20646e6120776f6e 
> [   13.090885] x7 : 207375206e696f4a x6 : 0000000000000000 
> [   13.091022] x5 : ffff0000117bf808 x4 : 0000000000000000 
> [   13.091168] x3 : 0000000000000000 x2 : ffffffffffffffc6 
> [   13.091313] x1 : ffff80007a62e610 x0 : 0000000000000000 
> [   13.091554] Call trace:
> [   13.091682]  __memcpy+0xc0/0x180
> [   13.091810]  scatterwalk_map_and_copy+0x88/0xf0
> [   13.091956]  scomp_acomp_comp_decomp+0x94/0x140
> [   13.092083]  scomp_acomp_compress+0x10/0x18
> [   13.092201]  test_acomp+0x158/0x5c0
> [   13.092307]  alg_test_comp+0x298/0x440
> [   13.092420]  alg_test.part.8+0xbc/0x398
> [   13.092542]  alg_test+0x3c/0x68
> [   13.092642]  cryptomgr_test+0x44/0x50
> [   13.092754]  kthread+0x128/0x130
> [   13.092867]  ret_from_fork+0x10/0x18
> [   13.093158] Code: 14000028 f1020042 5400024a a8c12027 (a88120c7) 
> 
> This is seen with an arm64 image running on qemu with machine xlnx-zcu102
> and two CPUs, and crypto test options enabled. It happens roughly every
> other boot. Reverting the patch fixes the problem. Bisect log (from
> crypto/master) is attached.
> 
> Guenter

Well, from a quick read of the patch, it's probably because it uses
raw_cpu_ptr() instead of per_cpu_ptr() when allocating/freeing the buffers, so
they are unlikely to actually be allocated for all CPUs.

Also Sebastian, I don't understand the point of the spinlock.  What was wrong
with get_cpu()?  Note that taking the spinlock disables preemption too...  Also
now it's possible to spin for a long time on the spinlock, for no reason really.

- Eric
