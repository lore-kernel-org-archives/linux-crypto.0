From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: crypto: ablk_decrypt causes BUG in scatterwalk
Date: Tue, 12 Jan 2016 17:27:53 +0100
Message-ID: <CACT4Y+aFyPyZHV5TnW_Z_MMgEunS0F1V-dvBqzSbSGeWU_TNYw@mail.gmail.com>
References: <CACT4Y+bjJ9Hs-jT1SAWZS95xnr+dxP-1H8jGb8u7XzpEZKDX8Q@mail.gmail.com>
 <20160112131644.GA906@gondor.apana.org.au> <CACT4Y+awm8d-tjVJi8RZdTh0zAP9PqXYcWDzc9xQV=RLbKKtuw@mail.gmail.com>
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
Received: from mail-wm0-f43.google.com ([74.125.82.43]:36891 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955AbcALQ2N (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jan 2016 11:28:13 -0500
Received: by mail-wm0-f43.google.com with SMTP id f206so329234076wmf.0
        for <linux-crypto@vger.kernel.org>; Tue, 12 Jan 2016 08:28:13 -0800 (PST)
In-Reply-To: <CACT4Y+awm8d-tjVJi8RZdTh0zAP9PqXYcWDzc9xQV=RLbKKtuw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 12, 2016 at 2:23 PM, Dmitry Vyukov <dvyukov@google.com> wrote:
> On Tue, Jan 12, 2016 at 2:16 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>> On Tue, Jan 12, 2016 at 10:27:44AM +0100, Dmitry Vyukov wrote:
>>> Hello,
>>>
>>> The following program cause BUG in scatterwalk:
>>
>> Weird, I can't reproduce the crash.  Can you perhaps convert this to
>> a non-racy reproduction, possibly by using strace to find the order
>> of execution that leads to the crash?
>
>
> Concurrent execution seems to be important to reproduce the crash. I
> wasn't able to reproduce it in single-threaded mode.
> Try to run it in a tight parallel loop for some time.


I've extracted another reproducer:
https://gist.githubusercontent.com/dvyukov/94aed45494edf1dff0a8/raw/a31f439fdcdd8a8905235a9bce6e5863ca8ccf68/gistfile1.txt

I don't know whether there is a simpler way to run a reproducer in a
tight parallel loop, but I use:
$ go get golang.org/x/tools/cmd/stress
$ GOPATH/bin/stress -p 16 ./a.out

It triggers the BUG within seconds for me.
