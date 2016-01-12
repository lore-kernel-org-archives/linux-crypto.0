From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: crypto: ablk_decrypt causes BUG in scatterwalk
Date: Tue, 12 Jan 2016 14:23:05 +0100
Message-ID: <CACT4Y+awm8d-tjVJi8RZdTh0zAP9PqXYcWDzc9xQV=RLbKKtuw@mail.gmail.com>
References: <CACT4Y+bjJ9Hs-jT1SAWZS95xnr+dxP-1H8jGb8u7XzpEZKDX8Q@mail.gmail.com>
 <20160112131644.GA906@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Eric Dumazet <edumazet@google.com>
To: syzkaller <syzkaller@googlegroups.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:36977 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbcALNX0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jan 2016 08:23:26 -0500
Received: by mail-wm0-f54.google.com with SMTP id f206so319967081wmf.0
        for <linux-crypto@vger.kernel.org>; Tue, 12 Jan 2016 05:23:25 -0800 (PST)
In-Reply-To: <20160112131644.GA906@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 12, 2016 at 2:16 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Jan 12, 2016 at 10:27:44AM +0100, Dmitry Vyukov wrote:
>> Hello,
>>
>> The following program cause BUG in scatterwalk:
>
> Weird, I can't reproduce the crash.  Can you perhaps convert this to
> a non-racy reproduction, possibly by using strace to find the order
> of execution that leads to the crash?


Concurrent execution seems to be important to reproduce the crash. I
wasn't able to reproduce it in single-threaded mode.
Try to run it in a tight parallel loop for some time.
