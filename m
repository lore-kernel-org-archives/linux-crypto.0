Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1284C48BD7
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 19:01:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0EEA20B7C
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 19:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561662087;
	bh=SiphXzRsjkt9u/8qMecCrA/HDYZQ8r7Ed2YaFAJ3ydE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=RECm8wc0HnW+HqW1xSQ/RVHsqnYnij5erCm7ZmH7W79cnh9N0YNFZjBg1G34hmMjq
	 X/J5G9haGe1mDk52LqJCtaNr4Oq6hnnsZVzx4wUHzAKyXyDpsFeduwgueGufgRi0re
	 0AaNbX0JCBRNFQ44S30GQk2XKSljA9V39bHE57Qc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbfF0TB0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 15:01:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:52718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726463AbfF0TB0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 15:01:26 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D39B720645;
        Thu, 27 Jun 2019 19:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561662085;
        bh=SiphXzRsjkt9u/8qMecCrA/HDYZQ8r7Ed2YaFAJ3ydE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FOZc8IQyuJ7j3PvBsrfrZOP9Q8hYRNwMr6PTulP3yWA5XPyRMa2AMso654M2Acwhs
         oXutCbF68J/zxN+Lel285WNGKP5treE4rpmT70Fl4N06DdqTEyrUvUVWVSy7Q0T/JV
         70df5JUSMn6mDgGCICoBmLYxf1/bLaPS8x3OgQbU=
Date:   Thu, 27 Jun 2019 12:01:23 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        Dave Watson <davejwatson@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        davem@davemloft.net, glider@google.com,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com>
Subject: Re: [net/tls] Re: KMSAN: uninit-value in aesti_encrypt
Message-ID: <20190627190123.GA669@sol.localdomain>
References: <000000000000a97a15058c50c52e@google.com>
 <20190627164627.GF686@sol.localdomain>
 <5d1508c79587a_e392b1ee39f65b45b@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d1508c79587a_e392b1ee39f65b45b@john-XPS-13-9370.notmuch>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 27, 2019 at 11:19:51AM -0700, John Fastabend wrote:
> Eric Biggers wrote:
> > [+TLS maintainers]
> > 
> > Very likely a net/tls bug, not a crypto bug.
> > 
> > Possibly a duplicate of other reports such as "KMSAN: uninit-value in gf128mul_4k_lle (3)"
> > 
> > See https://lore.kernel.org/netdev/20190625055019.GD17703@sol.localdomain/ for
> > the list of 17 other open syzbot bugs I've assigned to the TLS subsystem.  TLS
> > maintainers, when are you planning to look into these?
> > 
> > On Thu, Jun 27, 2019 at 09:37:05AM -0700, syzbot wrote:
> 
> I'm looking at this issue now. There is a series on bpf list now to address
> many of those 17 open issues but this is a separate issue. I can reproduce
> it locally so should have a fix soon.
> 

Okay, great!  However, just to clarify, the 17 syzbot bugs I assigned to TLS are
in addition to the 30 I assigned to BPF
(https://lore.kernel.org/lkml/20190624050114.GA30702@sol.localdomain/).
(Well, since I sent that it's actually up to 35 now.)

I do expect most of these are duplicates, so when you are fixing the bugs, it
would be really helpful (for everyone, including you in the future :-) ) if you
would include the corresponding Reported-by syzbot line for *every* syzbot
report you think is addressed, so they get closed.

- Eric
