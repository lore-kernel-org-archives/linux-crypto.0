From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: crypto: ablk_decrypt causes BUG in scatterwalk
Date: Tue, 12 Jan 2016 18:09:17 +0100
Message-ID: <CACT4Y+Y6NFH1Q9=HCW=jYmCKRewnjUpWD6Xv-+F5B5=APWFT6A@mail.gmail.com>
References: <CACT4Y+bjJ9Hs-jT1SAWZS95xnr+dxP-1H8jGb8u7XzpEZKDX8Q@mail.gmail.com>
 <20160112131644.GA906@gondor.apana.org.au> <CACT4Y+awm8d-tjVJi8RZdTh0zAP9PqXYcWDzc9xQV=RLbKKtuw@mail.gmail.com>
 <CACT4Y+aFyPyZHV5TnW_Z_MMgEunS0F1V-dvBqzSbSGeWU_TNYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Eric Dumazet <edumazet@google.com>
To: syzkaller <syzkaller@googlegroups.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACT4Y+aFyPyZHV5TnW_Z_MMgEunS0F1V-dvBqzSbSGeWU_TNYw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

I can _not_ reproduce it on clean upstream tree, nor on
git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git.
I probably messed up something with the unmerged fixes during my rebase.
Sorry.



On Tue, Jan 12, 2016 at 5:27 PM, Dmitry Vyukov <dvyukov@google.com> wrote:
> On Tue, Jan 12, 2016 at 2:23 PM, Dmitry Vyukov <dvyukov@google.com> wrote:
>> On Tue, Jan 12, 2016 at 2:16 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>>> On Tue, Jan 12, 2016 at 10:27:44AM +0100, Dmitry Vyukov wrote:
>>>> Hello,
>>>>
>>>> The following program cause BUG in scatterwalk:
>>>
>>> Weird, I can't reproduce the crash.  Can you perhaps convert this to
>>> a non-racy reproduction, possibly by using strace to find the order
>>> of execution that leads to the crash?
>>
>>
>> Concurrent execution seems to be important to reproduce the crash. I
>> wasn't able to reproduce it in single-threaded mode.
>> Try to run it in a tight parallel loop for some time.
>
>
> I've extracted another reproducer:
> https://gist.githubusercontent.com/dvyukov/94aed45494edf1dff0a8/raw/a31f439fdcdd8a8905235a9bce6e5863ca8ccf68/gistfile1.txt
>
> I don't know whether there is a simpler way to run a reproducer in a
> tight parallel loop, but I use:
> $ go get golang.org/x/tools/cmd/stress
> $ GOPATH/bin/stress -p 16 ./a.out
>
> It triggers the BUG within seconds for me.
