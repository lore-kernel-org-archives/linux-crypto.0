From: Anatoly Pugachev <matorola@gmail.com>
Subject: Re: [crypto / sparc64] cryptomgr_test OOPS
Date: Thu, 5 May 2016 18:12:02 +0300
Message-ID: <CADxRZqy1Fi6yt7ajDKV=5uG_7TS4LNjfH0i0a1FNfPJsChddwg@mail.gmail.com>
References: <20160503.123301.298039059390449291.davem@davemloft.net>
	<20160504040731.GA25758@gondor.apana.org.au>
	<CADxRZqws2yAMSqeMDYb6w6OUXJMMbv9wMaY7Zc6YX+szk2vO3g@mail.gmail.com>
	<20160505084249.GA4971@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	sparclinux@vger.kernel.org, Nicolai Stange <nicstange@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20160505084249.GA4971@gondor.apana.org.au>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, May 5, 2016 at 11:42 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Wed, May 04, 2016 at 05:49:04PM +0300, Anatoly Pugachev wrote:
>>
>> just tested cryptodev (
>> http://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
>> ) kernel, same OOPS, but kernel version is 4.6.0-rc2+ .
>> kernel OOPS message - https://paste.fedoraproject.org/362554/23732641/
>
> Anatoly, could you please test this patch on top of cryptodev?
> Thanks!
>
> ---8<---
> Subject: crypto: testmgr - Use kmalloc memory for RSA input
>
> As akcipher uses an SG interface, you must not use vmalloc memory
> as input for it.  This patch fixes testmgr to copy the vmalloc
> test vectors to kmalloc memory before running the test.
>
> This patch also removes a superfluous sg_virt call in do_test_rsa.


Herbert,

this patch, applied to your cryptodev git kernel, fixes OOPS and my
debian sparc64 installation boots successfully:

[5684721.625447] Unpacking initramfs...
[5684721.858235] Freeing initrd memory: 11720K (fff8002034000000 -
fff8002034b72000)
[5684721.867127] futex hash table entries: 65536 (order: 9, 4194304 bytes)
[5684721.868551] audit: initializing netlink subsys (disabled)
[5684721.868640] audit: type=2000 audit(0.476:1): initialized
[5684721.868868] Initialise system trusted keyring
[5684721.869765] workingset: timestamp_bits=45 max_order=21 bucket_order=0
[5684721.869879] zbud: loaded
[5684721.920120] Key type asymmetric registered
[5684721.920173] Asymmetric key parser 'x509' registered
[5684721.920582] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 252)
[5684721.921249] io scheduler noop registered
[5684721.921297] io scheduler deadline registered
[5684721.921628] io scheduler cfq registered (default)
[5684721.922101] f029b808: ttyS0 at I/O 0x0 (irq = 1, base_baud =
115200) is a SUN4V HCONS
[5684721.922352] console [ttyHV0] enabled
[5684721.923480] sunvdc.c:v1.2 (November 24, 2014)


Thanks.
