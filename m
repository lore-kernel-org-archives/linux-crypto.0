From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: crypto: use-after-free in hash_sock_destruct_common
Date: Wed, 13 Jan 2016 11:27:18 +0100
Message-ID: <CACT4Y+ab_8UnsYzCP6ZhZD_PUCVJ==r_OcO+O+mcd33mqDGozQ@mail.gmail.com>
References: <CACT4Y+YP0Ppj41P9mX1SPSEXkV=ffe0vuK1Ap7r0Ub8GROD5nQ@mail.gmail.com>
 <20160113065729.GA8123@gondor.apana.org.au> <CACT4Y+YOiaC1px6SD2hTAGwSd4i8GsTm59uQ+ux1U8EzdoQfPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Eric Dumazet <edumazet@google.com>,
	syzkaller <syzkaller@googlegroups.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACT4Y+YOiaC1px6SD2hTAGwSd4i8GsTm59uQ+ux1U8EzdoQfPA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jan 13, 2016 at 11:25 AM, Dmitry Vyukov <dvyukov@google.com> wrote:
> On Wed, Jan 13, 2016 at 7:57 AM, Herbert Xu <herbert@gondor.apana.org.au>
> wrote:
>>
>> On Tue, Jan 12, 2016 at 07:31:03PM +0100, Dmitry Vyukov wrote:
>> >
>> > The following program triggers use-after-free in
>> > hash_sock_destruct_common. This is on master of
>> > git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git
>> > (cd7e98414462b9db70067ac29896c58210b13b69). I've also seen a similar
>> > crash in skcipher_sock_destruct_common.
>>
>> OK the new compatibility nokey path introduced some new problems.
>> Please try the following patches.
>
>
> Yes, these 4 patches fix the crash for me. Thanks for quick fix!
>
> Tested-by: Dmitry Vyukov <dvyukov@google.com>

Oops, resending as plain text.
