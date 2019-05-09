Return-Path: <SRS0=8ziv=TJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,T_DKIMWL_WL_HIGH,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69F7AC04AB1
	for <linux-crypto@archiver.kernel.org>; Thu,  9 May 2019 23:21:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B6622182B
	for <linux-crypto@archiver.kernel.org>; Thu,  9 May 2019 23:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1557444064;
	bh=H1tBeGJzzEs6GGwrMAjYcY0cKCikcUHOuaWR2T5VJg8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=F995AN+voYYCPu04OAgmsMC2nePm4lS+mbTLYIJeSoXYK6mdwm3aNld6HMuhgJxEY
	 tXIW7D+lIh8NO7wrCkBjUswLF3TtaVKLE0eANvLWX8jE0hBsLOjV9Jkkos3ijLorqG
	 22JncBckfqmbOSoDqG3Yp0HB9EdWKRDq7Pa8bxW8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbfEIXVC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 May 2019 19:21:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:36296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726108AbfEIXVC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 May 2019 19:21:02 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5948A2173C;
        Thu,  9 May 2019 23:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557444061;
        bh=H1tBeGJzzEs6GGwrMAjYcY0cKCikcUHOuaWR2T5VJg8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o27rFMllaAgUplp+gWAOvaQAEUKPO9yj08nYYbQpbVMbab0794VZhVWm5HOECttj/
         jUyKimW1HfgzNkZCwDCcQG+zRWLRdzf0hXuMSYX++VN102VmNq2Ws2VGxIPfjGIQ3W
         QVGg7CXpBPyDdtqtc+34jr1r2+58nzKs7vlxn1Jc=
Date:   Thu, 9 May 2019 16:20:59 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        bugzilla-daemon@bugzilla.kernel.org, linux-crypto@vger.kernel.org,
        mihai.dontu@gmail.com, Kees Cook <keescook@chromium.org>
Subject: Re: [Bug 203559] New: usercopy_abort triggered by build_test_sglist
Message-ID: <20190509232058.GC42815@gmail.com>
References: <bug-203559-27@https.bugzilla.kernel.org/>
 <20190509154608.6bf58b45ac6492c8bd7fddeb@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509154608.6bf58b45ac6492c8bd7fddeb@linux-foundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

[+Kees Cook <keescook@chromium.org>]

On Thu, May 09, 2019 at 03:46:08PM -0700, Andrew Morton wrote:
> 
> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).
> 
> On Thu, 09 May 2019 09:37:08 +0000 bugzilla-daemon@bugzilla.kernel.org wrote:
> 
> > https://bugzilla.kernel.org/show_bug.cgi?id=203559
> > 
> >             Bug ID: 203559
> >            Summary: usercopy_abort triggered by build_test_sglist
> >            Product: Memory Management
> >            Version: 2.5
> >     Kernel Version: 5.1
> >           Hardware: x86-64
> >                 OS: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: low
> >           Priority: P1
> >          Component: Other
> >           Assignee: akpm@linux-foundation.org
> >           Reporter: mihai.dontu@gmail.com
> >         Regression: No
> > 
> > Created attachment 282687
> >   --> https://bugzilla.kernel.org/attachment.cgi?id=282687&action=edit
> > kernel config
> > 
> > I have CONFIG_CRYPTO_FIPS and CONFIG_HARDENED_USERCOPY_PAGESPAN enabled from an
> > experiment I forgot about, that started triggering a crash very early at boot
> > with kernel 5.1:
> > 
> > usercopy: Kernel memory overwrite attempt detected to spans multiple pages
> > (offset 0, size 372)!
> > ------------[ cut here]------------
> > kernel BUG at mm/usercopy.c:102!
> > invalid opcode: 0000 [#1] PREEMPT SMP PTI
> > CPU: 0 PID: 42 Comm: cryptomgr_test Trainted: G        T 5.1.0-gentoo #1
> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-1.fc28
> > 04/01/2014
> > RIP: 0010:usercopy_abort+0x87/0x89
> > Code: c3 ae 48 c7 c6 c9 9c ba ae 41 55 48 c7 c7 38 9e bb ae 48 0f 45 d1 48 c7
> > c1 51
> >       9d bb ae 50 48 0f 45 f1 4c 89 e1 e8 fb 50 e8 ff <0f> 0b 49 89 d8 31 c9 44
> > 89
> >       ea 31 f6 48 c7 c7 9a 9d bb ae e8 61 ff
> > ...
> > Call Trace:
> >  __check_object_size.cold+0x16/0xa6
> >  build_test_sglist+0x283/0x370
> >  ? skcipher_walk_done+0x105/0x220
> >  ? ecb_crypt+0xa5/0x110
> >  build_cipher_test_sglist+0xa0/0x120
> >  test_skcipher_vec_cfg+0x1c4/0x6e0
> > ...
> > 
> > The information above is from a screenshot, thus some opcodes or offsets might
> > be wrong.
> > 
> > The 5.0.13 kernel does not have this issue.
> > 
> > -- 
> > You are receiving this mail because:
> > You are the assignee for the bug.

There was already a long discussion on this where it was concluded that the
pagespan check is broken.  See https://lkml.org/lkml/2019/3/19/279 and
https://lkml.org/lkml/2019/4/14/313

I think CONFIG_HARDENED_USERCOPY_PAGESPAN should be removed or marked 'depends
on BROKEN', until someone can find a way to make it work properly.

- Eric
