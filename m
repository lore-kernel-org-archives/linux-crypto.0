From: Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: [PATCH 0/7] arm64: marvell: add cryptographic engine support for 7k/8k
Date: Tue, 11 Apr 2017 18:12:25 +0200
Message-ID: <87efwyj53q.fsf@free-electrons.com>
References: <20170329124432.27457-1-antoine.tenart@free-electrons.com>
        <20170410093903.GA8035@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        davem@davemloft.net, jason@lakedaemon.net, andrew@lunn.ch,
        sebastian.hesselbarth@gmail.com, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        thomas.petazzoni@free-electrons.com,
        boris.brezillon@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:36457 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751848AbdDKQM1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Apr 2017 12:12:27 -0400
In-Reply-To: <20170410093903.GA8035@gondor.apana.org.au> (Herbert Xu's message
        of "Mon, 10 Apr 2017 17:39:03 +0800")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,
 
 On lun., avril 10 2017, Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Wed, Mar 29, 2017 at 02:44:25PM +0200, Antoine Tenart wrote:
>> Hi all,
>> 
>> This series adds support for the Inside Secure SafeXcel EIP197
>> cryptographic engine which can be found on Marvell Armada 7k and 8k
>> boards. A new cryptographic engine driver is added, as well as the
>> relevant device tree definition for the Armada 7040 DB and 8040 DB
>> boards.
>> 
>> This driver needs two firmwares to work correctly. These firmware are
>> usually used for more advanced operations than the ones supported (as of
>> now), but we still need them to pass the data to the internal
>> cryptographic engine.
>> 
>> This series was tested in various ways on both the Armada 7040 DB and
>> the Armada 8040 DB: using the crypto framework self tests, using tcrypt
>> and while performing various transfers with iperf on top of IPsec.
>> 
>> This series is based on top of v4.11-rc1, and is available on a branch
>> (which also contains the PPv2 support for 7k/8k, to ease the process of
>> testing IPsec): https://github.com/atenart/linux  v4.11-rc1/7k8k-crypto
>> I can rebase if needed.
>> 
>> Thanks,
>> Antoine
>> 
>> 
>> Antoine Tenart (7):
>>   Documentation/bindings: Document the SafeXel cryptographic engine
>>     driver
>>   crypto: inside-secure: add SafeXcel EIP197 crypto engine driver
>>   MAINTAINERS: add a maintainer for the Inside Secure crypto driver
>>   arm64: marvell: dts: add crypto engine description for 7k/8k
>>   arm64: marvell: dts: enable the crypto engine on the Armada 7040 DB
>>   arm64: marvell: dts: enable the crypto engine on the Armada 8040 DB
>>   arm64: defconfig: enable the Safexcel crypto engine as a module
>
> I have no problems with the crypto bits.

Does it means that you agree that I apply the arm-soc related patches
(from 4 to 7) to my mvebu trees?

Thanks,

Gregory

>
> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
