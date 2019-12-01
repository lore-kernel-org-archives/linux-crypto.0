Return-Path: <SRS0=52Dc=ZX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D3BFC432C0
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Dec 2019 19:22:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2860B2146E
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Dec 2019 19:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575228146;
	bh=LqSjHZ1ACIJwh8P9lzwhU6FweZm1EuAFTDpQ9wW+Ot4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=S/QfZ9GCxasMAq5fBYFk/6nYAcYLNvhFpjbYgN6fm2wCTwUmnMNHn5eYhtADfyqS/
	 t42Rqnlbs9Nz11KfHFSW6gpL/QDGpSsMtNNFtVdE0l7WXHZi30Rlw4F61kuAikYZF+
	 Bfcpy4v8rfZSq4FVCWeOaenrZb+2DIHTqsBNDVCM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbfLATWZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 1 Dec 2019 14:22:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:39790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726965AbfLATWZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 1 Dec 2019 14:22:25 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25BE220833;
        Sun,  1 Dec 2019 19:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575228144;
        bh=LqSjHZ1ACIJwh8P9lzwhU6FweZm1EuAFTDpQ9wW+Ot4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SqUh8YbI75T/BSHVNZ3JXg5O+Sts7rgLFZ46DZhYC71PQDIP1brgTFTFlgYnbNiqQ
         k+MsQu2VHJaoJN/OmUI3S5+SEgv+7sRsoMGoWM1cD+gQJOwJIFPj8vuFLtpG92fTdq
         cNfpYuVjVg2g8VGJQvYj/NzFE1l0u+0RJBb2lHcM=
Date:   Sun, 1 Dec 2019 11:22:22 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc:     syzbot 
        <syzbot+56c7151cad94eec37c521f0e47d2eee53f9361c4@syzkaller.appspotmail.com>,
        davem@davemloft.net, dvyukov@google.com,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        peterz@infradead.org, steffen.klassert@secunet.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: INFO: task hung in aead_recvmsg
Message-ID: <20191201192222.GA1186@sol.localdomain>
References: <00000000000065e61505989fd2c3@google.com>
 <2842590.QEqkPaeV8v@positron.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2842590.QEqkPaeV8v@positron.chronox.de>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Dec 01, 2019 at 06:58:17PM +0100, Stephan Müller wrote:
> Am Sonntag, 1. Dezember 2019, 08:58:00 CET schrieb syzbot:
> 
> Hi,
> 
> > syzbot has bisected this bug to:
> > 
> > commit 0c1e16cd1ec41987cc6671a2bff46ac958c41eb5
> > Author: Stephan Mueller <smueller@chronox.de>
> > Date:   Mon Dec 5 14:26:19 2016 +0000
> > 
> >      crypto: algif_aead - fix AEAD tag memory handling
> > 
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12d6d0a6e00000
> > start commit:   618d919c Merge tag 'libnvdimm-fixes-5.1-rc6' of git://git...
> > git tree:       upstream
> > final crash:    https://syzkaller.appspot.com/x/report.txt?x=11d6d0a6e00000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=16d6d0a6e00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=856fc6d0fbbeede9
> > dashboard link:
> > https://syzkaller.appspot.com/bug?extid=56c7151cad94eec37c521f0e47d2eee53f93
> > 61c4 syz repro:     
> > https://syzkaller.appspot.com/x/repro.syz?x=11ef592d200000 C reproducer:  
> > https://syzkaller.appspot.com/x/repro.c?x=16b865fd200000
> > 
> > Reported-by:
> > syzbot+56c7151cad94eec37c521f0e47d2eee53f9361c4@syzkaller.appspotmail.com
> > Fixes: 0c1e16cd1ec4 ("crypto: algif_aead - fix AEAD tag memory handling")
> > 
> > For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> 
> This issue seems to be triggered when using pcrypt. Pcrypt received a number 
> of fixes recently.
> 
> Did the test include all of those fixes?
> 
> Thanks a lot for the testing!
> 

No, the pcrypt fixes haven't been applied yet.  One of Herbert's patches has:

	Reported-by: syzbot+56c7151cad94eec37c521f0e47d2eee53f9361c4@syzkaller.appspotmail.com

... so syzbot will close this bug report once this patch is applied and reaches
upstream or linux-next.  It's just a coincidence that syzbot happened to report
a bisection result now.

- Eric
