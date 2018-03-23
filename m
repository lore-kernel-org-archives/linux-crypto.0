From: Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: Re: [PATCH 0/3] crypto: inside-secure: improve clock management
Date: Fri, 23 Mar 2018 17:30:46 +0100
Message-ID: <874ll6wy89.fsf@bootlin.com>
References: <20180313164842.20042-1-gregory.clement@bootlin.com>
 <20180323160149.GC2186@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
 Antoine Tenart <antoine.tenart@bootlin.com>, Hanna Hawa <hannah@marvell.com>,
 Omri Itach <omrii@marvell.com>, davem@davemloft.net,
 Nadav Haklai <nadavh@marvell.com>, Igal Liberman <igall@marvell.com>,
 Shadi Ammouri <shadi@marvell.com>, linux-crypto@vger.kernel.org,
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
 =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
 Marcin Wojtas <mw@semihalf.com>, oferh@marvell.com,
 linux-arm-kernel@lists.infradead.org,
 Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180323160149.GC2186@gondor.apana.org.au> (Herbert Xu's message
 of "Sat, 24 Mar 2018 00:01:49 +0800")
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,
 
 On sam., mars 24 2018, Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Tue, Mar 13, 2018 at 05:48:39PM +0100, Gregory CLEMENT wrote:
>> Hi,
>> 
>> This short series fixes the way the clocks are used for the SafeXcel
>> EIP-197 controller embedded in the Marvell Armada 7K/8K SoCs. On these
>> SoCs a second one is needed in order to clock the registers. It was
>> not noticed until now because we relied on the bootloader and also
>> because the clock driver was wrong.
>> 
>> Thanks to this fix, it would be possible to fix the clock driver
>> without introducing a regression.
>> 
>> While I was working on the clocks I found a bug in the clock
>> management which was fixed with the first patch and should be applied
>> to v4.16.
>
> I haven't applied it to the crypto 4.16 tree because your other
> patches depend on it and I don't think the issue doesn't seem to
> be that severe.
>
> In future it would help if you can avoid such dependencies if you
> wish the patches to go in as soon as possible.

Yes sure. And I agree with you, the issue is not that severe, so it can
wait for 4.17.

>
>> The second patch is a small improvement which is aim for v4.17 as well
>> as the last patch.
>> 
>> Thanks,
>> 
>> Gregory
>> 
>> Gregory CLEMENT (3):
>>   crypto: inside-secure - fix clock management
>>   crypto: inside-secure - improve clock initialization
>>   crypto: inside-secure - fix clock resource by adding a register clock
>> 
>>  .../bindings/crypto/inside-secure-safexcel.txt     |  6 ++-
>>  drivers/crypto/inside-secure/safexcel.c            | 47 +++++++++++++++-------
>>  drivers/crypto/inside-secure/safexcel.h            |  1 +
>>  3 files changed, 38 insertions(+), 16 deletions(-)
>
> All applied.  Thanks.

Thanks

> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

-- 
Gregory Clement, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
http://bootlin.com
