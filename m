From: Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: [PATCH v3 14/16] ARM: marvell/dt: enable crypto on armada-xp-gp
Date: Wed, 27 May 2015 12:20:49 +0200
Message-ID: <55659A81.3040600@free-electrons.com>
References: <1432301642-11470-1-git-send-email-boris.brezillon@free-electrons.com>	<1432301642-11470-15-git-send-email-boris.brezillon@free-electrons.com>	<55633B6D.7080307@free-electrons.com> <20150526105936.25db3afb@bbrezillon>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Arnaud Ebalard <arno@natisbad.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Tawfik Bayouk <tawfik@marvell.com>,
	Lior Amsalem <alior@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Eran Ben-Avi <benavi@marvell.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:55700 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750959AbbE0KUw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 May 2015 06:20:52 -0400
In-Reply-To: <20150526105936.25db3afb@bbrezillon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 26/05/2015 10:59, Boris Brezillon wrote:
> On Mon, 25 May 2015 17:10:37 +0200
> Gregory CLEMENT <gregory.clement@free-electrons.com> wrote:
> 
>> Hi Boris,
>>
>> On 22/05/2015 15:34, Boris Brezillon wrote:
>>> Enable the crypto IP on armada-xp-gp.
>>>
>>> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
>>> ---
>>>  arch/arm/boot/dts/armada-xp-gp.dts | 4 +++-
>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/arm/boot/dts/armada-xp-gp.dts b/arch/arm/boot/dts/armada-xp-gp.dts
>>> index 565227e..8a739f4 100644
>>> --- a/arch/arm/boot/dts/armada-xp-gp.dts
>>> +++ b/arch/arm/boot/dts/armada-xp-gp.dts
>>> @@ -94,7 +94,9 @@
>>>  	soc {
>>>  		ranges = <MBUS_ID(0xf0, 0x01) 0 0 0xf1000000 0x100000
>>>  			  MBUS_ID(0x01, 0x1d) 0 0 0xfff00000 0x100000
>>> -			  MBUS_ID(0x01, 0x2f) 0 0 0xf0000000 0x1000000>;
>>> +			  MBUS_ID(0x01, 0x2f) 0 0 0xf0000000 0x1000000
>>> +			  MBUS_ID(0x09, 0x09) 0 0 0xf1100000 0x10000
>>> +			  MBUS_ID(0x09, 0x05) 0 0 0xf1110000 0x10000>;
>>
>> As the crypto engine really depend on the SoC itself and not of the board,
>> what about updating the dts of the other board using an Armada XP?
> 
> But that means introducing changes I haven't tested. Are you okay with
> that ?

Maybe I missed something but as the crypto is fully integrated in the SoC,
if for a given SoC it works on a board it would work on all the boards using
the same SoC.

The board specific part seems about setting memory address on the mbus.

By the way could you add a comment in front of the new line ? so next time
someone will copy and past one of the dts file, he will understand the
signification of these two lines.

But is it really depending of the board itself?
I see that the first lines are the same on all the dts, I just remember that
there was a reason why we could not put it in the dtsi. My point here, is as
the configuration is the same on all the boards, adding the crypto on all the
board should work without any issue.


Thanks,

Gregory





> 
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
