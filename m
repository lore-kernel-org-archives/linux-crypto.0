From: Joel Fernandes <joelf@ti.com>
Subject: Re: [PATCH v2] crypto: omap-sham: kmap SG pages before appending
Date: Wed, 5 Mar 2014 09:42:38 -0600
Message-ID: <531745EE.2060804@ti.com>
References: <1393957854-10961-1-git-send-email-joelf@ti.com> <20140305015953.GA20702@gondor.apana.org.au> <39412163-4B61-4490-ABC8-5BA633CC6618@ti.com> <20140305071109.GA22178@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Vutla, Lokesh" <lokeshvutla@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-omap-owner@vger.kernel.org>
In-Reply-To: <20140305071109.GA22178@gondor.apana.org.au>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 03/05/2014 01:11 AM, Herbert Xu wrote:
> On Wed, Mar 05, 2014 at 04:18:12AM +0000, Fernandes, Joel wrote:
>>
>>
>>> On Mar 4, 2014, at 8:00 PM, "Herbert Xu" <herbert@gondor.apana.org.au> wrote:
>>>
>>>> On Tue, Mar 04, 2014 at 12:30:54PM -0600, Joel Fernandes wrote:
>>>> HIGHMEM pages may not be mapped so we must kmap them before accessing.
>>>> This resolves a random OOPs error that was showing up during OpenSSL SHA tests.
>>>>
>>>> Signed-off-by: Joel Fernandes <joelf@ti.com>
>>>> Cc: Herbert Xu <herbert@gondor.apana.org.au>
>>>> ---
>>>> v2 changes:
>>>>    - don't check for HIGHMEM, kmap/kunmap do them anyway (Thanks Herbert).
>>>>
>>>> drivers/crypto/omap-sham.c |    8 +++++++-
>>>> 1 file changed, 7 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
>>>> index e45aaaf..207eac1 100644
>>>> --- a/drivers/crypto/omap-sham.c
>>>> +++ b/drivers/crypto/omap-sham.c
>>>> @@ -636,11 +636,17 @@ static size_t omap_sham_append_buffer(struct omap_sham_reqctx *ctx,
>>>> static size_t omap_sham_append_sg(struct omap_sham_reqctx *ctx)
>>>> {
>>>>    size_t count;
>>>> +    const u8 *vaddr;
>>>>
>>>>    while (ctx->sg) {
>>>> +        vaddr = kmap(sg_page(ctx->sg));
>>>
>>> Are you sure you can safely use kmap here as opposed to kmap_atomic?
>>
>> Yes I made sure it is not called in interrupt context and also tested the patch.
> 
> What about omap_sham_update => omap_sham_append_sg? As the former
> can be called in softirq context what is preventing it from calling
> kmap?

In my testing it wasn't called from softirq, I'm using cryptodev which is
called from openssl through ioctl, here is a traceback (sorry about wrap):

[<bf8010bb>] (cryptodev_ioctl+0x282/0x59c [cryptodev])
[  220.015390] [<bf8010bb>] (cryptodev_ioctl+0x282/0x59c [cryptodev]) from
[<c00cdaa5>] (do_vfs_ioctl+0x61/0x41c)
[  220.025909] [<c00cdaa5>] (do_vfs_ioctl+0x61/0x41c) from [<c00cdeab>]
(SyS_ioctl+0x4b/0x50)
[  220.034602] [<c00cdeab>] (SyS_ioctl+0x4b/0x50) from [<c000cf01>]
(ret_fast_syscall+0x1/0x46)
[  220.045254] CPU: 0 PID: 1798 Comm: openssl Tainted: G           O
3.12.9-00581-g5fa084c-dirty #32
[  220.054636] [<c0012d05>] (unwind_backtrace+0x1/0x9c) from [<c000fa6d>]
(show_stack+0x11/0x14)
[  220.063619] [<c000fa6d>] (show_stack+0x11/0x14) from [<c0342edb>]
(dump_stack+0x4b/0x60)
[  220.072144] [<c0342edb>] (dump_stack+0x4b/0x60) from [<c02a1b3f>]
(omap_sham_update+0x1f/0xa4)
[  220.081214] [<c02a1b3f>] (omap_sham_update+0x1f/0xa4) from [<bf801f67>]
(cryptodev_hash_update+0x26/0x80 [cryptodev])


Could you suggest, what other place is update() called in softirq context?
I may be missing something.

Thanks,
-Joel

> 
> Cheers,
> 

