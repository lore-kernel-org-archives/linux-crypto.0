From: Nathan Royce <nroycea+kernel@gmail.com>
Subject: Re: XTS Crypto Not Found In /proc/crypto Even After Compiled for 4.10.1.
Date: Fri, 3 Mar 2017 04:36:18 -0600
Message-ID: <CALaQ_hoafES-K1ds-XUPC6h4VnHX_ebym4LYjeuq1jHdbLYuDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

I do have ECB selected as well:
DM_CRYPT=y
CRYPTO_ECB=y
CRYPTO_XTS=y

name         : ecb(aes)
driver       : ecb-aes-s5p
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : ablkcipher
async        : yes
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 0
geniv        : <default>
//still no "xts" can be found in the list

I saw this about the regression that sounds similar to my issue,
except even when I built-in dm_crypt (no initramfs. just diving
straight into system), it still fails:
http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg23748.html

On Fri, Mar 3, 2017 at 3:33 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Fri, Mar 03, 2017 at 03:00:26AM -0600, Nathan Royce wrote:
>> OK, I went ahead and enabled self tests
>> "CRYPTO_MANAGER_DISABLE_TESTS=n", and my system was able to boot,
>> albeit with failures:
>> *****
>> Mar 02 23:14:38 server kernel: ---[ end trace 1c8a91f28cbcebf3 ]---
>> Mar 02 23:14:38 server kernel: alg: skcipher: encryption failed on
>> test 1 for xts(ecb-aes-s5p): ret=35
>> Mar 02 23:14:38 server kernel: device-mapper: table: 254:0: crypt:
>> Error allocating crypto tfm
>> Mar 02 23:14:38 server kernel: device-mapper: ioctl: error adding
>> target to table
>> Mar 02 23:14:39 server systemd-cryptsetup[234]: Failed to activate
>> with key file '/dev/urandom': Invalid argument
>> *****
>> (weird that it asked for the passphrase)
>>
>> But I do question whether the root issue is related to s5p... Maybe
>> there is a correlation in the warning, but to me it looks like the
>> issue is something else.
>
> I see.  Do you have ECB enabled in your config? The new XTS requires
> ECB to be present so that could be your problem.
>
> There is already a patch on its way to stable to add the Kconfig
> select on ECB.
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
