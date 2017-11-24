From: Stephan Mueller <smueller@chronox.de>
Subject: Re: x509 parsing bug + fuzzing crypto in the userspace
Date: Fri, 24 Nov 2017 15:36:56 +0100
Message-ID: <2631912.1nF8QvS07C@tauon.chronox.de>
References: <CAG_fn=XJZG_MJXXgos5jZmOThKho=uSvwgfhkMSYONZ04PKKaw@mail.gmail.com> <3132962.8EQ63lqCxc@tauon.chronox.de> <CACT4Y+Zp39AMymVXB8ZdGA1VRYwRVsouuEXdhY3nmP5oawcfEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Eric Biggers <ebiggers@google.com>,
        Alexander Potapenko <glider@google.com>,
        linux-crypto@vger.kernel.org, Kostya Serebryany <kcc@google.com>,
        keyrings@vger.kernel.org, Andrey Konovalov <andreyknvl@google.com>
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:42446 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752501AbdKXOhA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Nov 2017 09:37:00 -0500
In-Reply-To: <CACT4Y+Zp39AMymVXB8ZdGA1VRYwRVsouuEXdhY3nmP5oawcfEQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 24. November 2017, 14:49:49 CET schrieb Dmitry Vyukov:

Hi Dmitry,

> On Thu, Nov 23, 2017 at 1:35 PM, Stephan Mueller <smueller@chronox.de> 
wrote:
> > Am Donnerstag, 23. November 2017, 12:34:54 CET schrieb Dmitry Vyukov:
> > 
> > Hi Dmitry,
> > 
> >> Btw, I've started doing some minimal improvements, did not yet sorted
> >> out alg types/names, and fuzzer started scratching surface:
> >> 
> >> WARNING: kernel stack regs has bad 'bp' value 77 Nov 23 2017 12:29:36 CET
> >> general protection fault in af_alg_free_areq_sgls 54 Nov 23 2017 12:23:30
> >> CET general protection fault in crypto_chacha20_crypt 100 Nov 23 2017
> >> 12:29:48 CET suspicious RCU usage at ./include/trace/events/kmem.h:LINE
> >> 88
> >> Nov 23 2017 12:29:15 CET
> > 
> > This all looks strange. Where would RCU come into play with
> > af_alg_free_areq_sgls?
> > 
> > Do you have a reproducer?
> > 
> >> This strongly suggests that we need to dig deeper.
> > 
> > Absolutely. That is why I started my fuzzer that turned up already quite
> > some issues.
> 
> I've cooked syzkaller change that teaches it to generate more
> algorithm names. Probably not idea, but much better than was before:
> https://github.com/google/syzkaller/blob/ddf7b3e0655cf6dfeacfe509e477c1486d2
> cc7db/sys/linux/alg.go (if you see any obvious issues there, feedback is
> welcome,

I will peek into that code shortly.

> I still did not figure out completely difference between e.g.
> HASH/AHASH,

AHASH is the asynchronous hash. I.e. the implementation can sleep.

HASH == SHASH and is the synchronous hash. I.e. that implementation will never 
sleep.

An SHASH can be turned into an AHASH by using cryptd().

An AHASH can never be turned into an SHASH.

To use SHASH implementations, you use the *_shash API calls. This API does not 
require a request structure.

To use AHASH implementations, you use the *_ahash API calls. This API requires 
the use of ahash_request_* calls. By transparently employing cryptd(), the 
kernel allows the use of SHASH implementations with the AHASH API.

Currently there is only one real AHASH implementation outside specific 
hardware drivers: sha1_mb and sha2*_mb found in arch/x86/crypto/. This 
implementation can only be used with the AHASH API. All (other) SHASH 
implementations can be used with either the shash or the ahash API, because 
when using it as AHASH, the kernel automatically uses the cryptd() under the 
hood.


> BLKCIPHER/ABLKCIPHER as most of them seem to be interchangable; this
> was mostly based on try and trial approach).

Dto. BLKCIPHER is the synchronous and ABLKCIPHER is the asynchronous 
implementation. The same logic applies here as discussed for the SHASH/AHASH.

There used to be a blkcipher and ablkcipher API just like the shash/ahash 
which follows exactly the same logic.

About a year ago, the skcipher API was introduced which tries to get rid of 
the blkcipher API and supersedes the ablkcipher API. I.e. per default, the 
skcipher is asynchronous in nature. Yet, you can make it synchronous by 
supplying a specific flag/mask combo during crypto_skcipher_alloc.

Again, BLKCIPHERS are turned into async implementations using the cryptd 
transparently by the kernel.

PS: AF_ALG does *not* allow choosing the API discussed above. It always uses 
the async API (which implies that *all* cipher implementations are 
accessible). Though, it provides two types of interfaces:

1. the sync API

2. the async API

The sync API simply does a sendmsg/recvmsg.

The async API uses the io_submit and friends.

You can see implementations for both in libkcapi.
> 
> All bugs with details will soon be reported by syzbot
> (https://goo.gl/tpsmEJ) to kernel mailing lists with all details.
> 
> Stephan, thanks for your help!

You are welcome.


Ciao
Stephan
