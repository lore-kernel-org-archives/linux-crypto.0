From: Nathan Royce <nroycea@gmail.com>
Subject: Re: XTS Crypto Not Found In /proc/crypto Even After Compiled for 4.10.1.
Date: Fri, 3 Mar 2017 03:00:26 -0600
Message-ID: <CALaQ_hruPpfO0ggwcQZ_j+WB9=ONDatLbe3sERviVd=w1iNhSw@mail.gmail.com>
References: <CALaQ_hoZ6wh-H_NNoT80r6kthvFpL05zNWr7upVqispknXMEvg@mail.gmail.com>
 <20170303040210.GA24737@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170303040210.GA24737@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

OK, I went ahead and enabled self tests
"CRYPTO_MANAGER_DISABLE_TESTS=n", and my system was able to boot,
albeit with failures:
*****
Mar 02 23:14:38 server kernel: ---[ end trace 1c8a91f28cbcebf3 ]---
Mar 02 23:14:38 server kernel: alg: skcipher: encryption failed on
test 1 for xts(ecb-aes-s5p): ret=35
Mar 02 23:14:38 server kernel: device-mapper: table: 254:0: crypt:
Error allocating crypto tfm
Mar 02 23:14:38 server kernel: device-mapper: ioctl: error adding
target to table
Mar 02 23:14:39 server systemd-cryptsetup[234]: Failed to activate
with key file '/dev/urandom': Invalid argument
*****
(weird that it asked for the passphrase)

But I do question whether the root issue is related to s5p... Maybe
there is a correlation in the warning, but to me it looks like the
issue is something else.
In my OP, I noted that the xts crypto isn't even found in /proc/crypto
in 4.10. I'd think it would at least be listed, even if it isn't used.
CBC is listed in /proc/crypto with kernel 4.9.13 and 4.10.1 (cbc-aes-s5p)
XTS is listed in /proc/crypto with kernel 4.9.13 but NOT 4.10.1

I should also add that I didn't include other tainted messages since
they followed the messages I first posted.
I was assuming that when the first issue would work, the others would
follow suit. I just didn't want to inundate with possible junk.
I still have the log file if you think it would be helpful to post the rest.

PS: I also noticed the bounce from my first mail submission because I
didn't enable plain-text for the e-mail (marked as spam because the
email contained html). I rectified that for this reply.

On Thu, Mar 2, 2017 at 10:02 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Thu, Mar 02, 2017 at 05:35:30PM -0600, Nathan Royce wrote:
>> ARM ODroid XU4
>>
>> $ cat /proc/config.gz | gunzip | grep XTS
>> CONFIG_CRYPTO_XTS=y
>>
>> $ grep xts /proc/crypto
>> //4.9.13
>> name         : xts(aes)
>> driver       : xts(aes-generic)
>> //4.10.1
>> <blank>
>> //cbc can be found though
>>
>> CRYPTTAB:
>> cryptswap1 UUID=<sanitized> /dev/urandom
>> swap,offset=2048,cipher=aes-xts-plain64:sha512,size=512,nofail
>>
>> FSTAB:
>> /dev/mapper/cryptswap1 none swap sw 0 0
>>
>> Boot Log:
>> [   10.535985] ------------[ cut here ]------------
>> [   10.539252] WARNING: CPU: 0 PID: 0 at crypto/skcipher.c:430
>> skcipher_walk_first+0x13c/0x14c
>> [   10.547542] Modules linked in: xor xor_neon aes_arm zlib_deflate
>> dm_crypt raid6_pq nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
>> ip_tables x_tables
>> [   10.561716] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.10.1-dirty #1
>> [   10.568049] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
>> [   10.574171] [<c010eb54>] (unwind_backtrace) from [<c010b408>]
>> (show_stack+0x10/0x14)
>> [   10.581893] [<c010b408>] (show_stack) from [<c036772c>]
>> (dump_stack+0x84/0x98)
>> [   10.589073] [<c036772c>] (dump_stack) from [<c011bb20>]
>> (__warn+0xe8/0x100)
>> [   10.595975] [<c011bb20>] (__warn) from [<c011bc30>]
>> (warn_slowpath_null+0x20/0x28)
>> [   10.603546] [<c011bc30>] (warn_slowpath_null) from [<c0329a48>]
>> (skcipher_walk_first+0x13c/0x14c)
>> [   10.612390] [<c0329a48>] (skcipher_walk_first) from [<c0329b30>]
>> (skcipher_walk_virt+0x1c/0x38)
>> [   10.621056] [<c0329b30>] (skcipher_walk_virt) from [<c0330ed0>]
>> (post_crypt+0x38/0x1c4)
>> [   10.629022] [<c0330ed0>] (post_crypt) from [<c0331470>]
>> (decrypt_done+0x4c/0x54)
>> [   10.636389] [<c0331470>] (decrypt_done) from [<c05a03f0>]
>> (s5p_aes_complete+0x70/0xfc)
>> [   10.644274] [<c05a03f0>] (s5p_aes_complete) from [<c05a05b0>]
>> (s5p_aes_interrupt+0x134/0x1a0)
>> [   10.652771] [<c05a05b0>] (s5p_aes_interrupt) from [<c016dc3c>]
>> (__handle_irq_event_percpu+0x9c/0x124)
>
> This looks like a bug in the s5p driver.  It's calling the completion
> function straight from the IRQ handler, which is triggering the
> sanity check in skcipher_walk_first.
>
> The s5p driver needs to schedule a tasklet to call the completion
> function.
>
> Do you have crypto self-test enabled? If so it should've caught
> this at run-time.  Otherwise you can disable the s5p driver until
> it's fixed.
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
