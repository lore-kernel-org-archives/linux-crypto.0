Return-Path: <SRS0=8ziv=TJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,T_DKIMWL_WL_HIGH,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76D15C04AB1
	for <linux-crypto@archiver.kernel.org>; Thu,  9 May 2019 22:46:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 447A8217D7
	for <linux-crypto@archiver.kernel.org>; Thu,  9 May 2019 22:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1557441971;
	bh=i/UMiMU6i3kh02Y5CMeawWXg7Uk/18fTEcz2/cBnt1o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=DxsXSb1Vdme3Ttn4E7xogatxkMXKOFUDcqo8DurlDUCrpgIGtmmy24OqPt5YV0m4I
	 n1Lfb2jYdnZCdhAR3hlSXX5erPvaN9jfXpkUskhQsUnJhzPYKOth+9IAgWQwhti4H+
	 aZ7E6MQ+FDGxZWLN4/Yn1B6PD2LmR0GrHEJ3UXr8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfEIWqK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 May 2019 18:46:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:51828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726704AbfEIWqK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 May 2019 18:46:10 -0400
Received: from localhost.localdomain (c-73-223-200-170.hsd1.ca.comcast.net [73.223.200.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0482D21744;
        Thu,  9 May 2019 22:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557441969;
        bh=i/UMiMU6i3kh02Y5CMeawWXg7Uk/18fTEcz2/cBnt1o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=v1zS6auFvajq57Rx08XepDS9+BxKlnAsfiJE6vEXu1AOkb2uPx15xcbYvKsrlAt61
         2KbSU8w3piMDzHLYya3gfgRlCAooT0BMWJyKLVa8zOfVzG64PpEkzZXL5emg0mrPQQ
         WTnXS9rg037jj5nNdwWL1J3kIJfNwRA3+udzWj4w=
Date:   Thu, 9 May 2019 15:46:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     bugzilla-daemon@bugzilla.kernel.org, linux-crypto@vger.kernel.org,
        mihai.dontu@gmail.com
Subject: Re: [Bug 203559] New: usercopy_abort triggered by build_test_sglist
Message-Id: <20190509154608.6bf58b45ac6492c8bd7fddeb@linux-foundation.org>
In-Reply-To: <bug-203559-27@https.bugzilla.kernel.org/>
References: <bug-203559-27@https.bugzilla.kernel.org/>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Thu, 09 May 2019 09:37:08 +0000 bugzilla-daemon@bugzilla.kernel.org wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=203559
> 
>             Bug ID: 203559
>            Summary: usercopy_abort triggered by build_test_sglist
>            Product: Memory Management
>            Version: 2.5
>     Kernel Version: 5.1
>           Hardware: x86-64
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: low
>           Priority: P1
>          Component: Other
>           Assignee: akpm@linux-foundation.org
>           Reporter: mihai.dontu@gmail.com
>         Regression: No
> 
> Created attachment 282687
>   --> https://bugzilla.kernel.org/attachment.cgi?id=282687&action=edit
> kernel config
> 
> I have CONFIG_CRYPTO_FIPS and CONFIG_HARDENED_USERCOPY_PAGESPAN enabled from an
> experiment I forgot about, that started triggering a crash very early at boot
> with kernel 5.1:
> 
> usercopy: Kernel memory overwrite attempt detected to spans multiple pages
> (offset 0, size 372)!
> ------------[ cut here]------------
> kernel BUG at mm/usercopy.c:102!
> invalid opcode: 0000 [#1] PREEMPT SMP PTI
> CPU: 0 PID: 42 Comm: cryptomgr_test Trainted: G        T 5.1.0-gentoo #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-1.fc28
> 04/01/2014
> RIP: 0010:usercopy_abort+0x87/0x89
> Code: c3 ae 48 c7 c6 c9 9c ba ae 41 55 48 c7 c7 38 9e bb ae 48 0f 45 d1 48 c7
> c1 51
>       9d bb ae 50 48 0f 45 f1 4c 89 e1 e8 fb 50 e8 ff <0f> 0b 49 89 d8 31 c9 44
> 89
>       ea 31 f6 48 c7 c7 9a 9d bb ae e8 61 ff
> ...
> Call Trace:
>  __check_object_size.cold+0x16/0xa6
>  build_test_sglist+0x283/0x370
>  ? skcipher_walk_done+0x105/0x220
>  ? ecb_crypt+0xa5/0x110
>  build_cipher_test_sglist+0xa0/0x120
>  test_skcipher_vec_cfg+0x1c4/0x6e0
> ...
> 
> The information above is from a screenshot, thus some opcodes or offsets might
> be wrong.
> 
> The 5.0.13 kernel does not have this issue.
> 
> -- 
> You are receiving this mail because:
> You are the assignee for the bug.
