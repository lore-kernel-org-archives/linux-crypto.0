From: Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: [PATCH 0/2] crypto: add new driver for Marvell CESA
Date: Fri, 17 Apr 2015 16:40:43 +0200
Message-ID: <55311B6B.2090108@free-electrons.com>
References: <20150410171148.07bc9429@bbrezillon> <20150410223008.GA18660@io.lakedaemon.net> <552B8EC4.209@free-electrons.com> <20150413124711.GI18660@io.lakedaemon.net> <87r3rom2qu.fsf@natisbad.org> <20150413201146.GL18660@io.lakedaemon.net> <20150417103356.6ce78145@bbrezillon> <20150417103946.2a46c243@bbrezillon> <5531040D.4000007@free-electrons.com> <20150417161922.54adec64@bbrezillon> <20150417143216.GQ15807@lukather>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Arnaud Ebalard <arno@natisbad.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Thomas Petazzoni <info@free-electrons.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Pawel Moll <pawel.moll@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Eran Ben-Avi <benavi@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>, devicetree@vger.kernel.org,
	Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
	linux-crypto@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
	Tawfik Bayouk <tawfik@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Lior Amsalem <alior@marvell.com>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150417143216.GQ15807@lukather>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Maxime,

On 17/04/2015 16:32, Maxime Ripard wrote:
> On Fri, Apr 17, 2015 at 04:19:22PM +0200, Boris Brezillon wrote:
>> Hi Gregory,
>>
>> On Fri, 17 Apr 2015 15:01:01 +0200
>> Gregory CLEMENT <gregory.clement@free-electrons.com> wrote:
>>
>>> Hi Boris,
>>>
>>> On 17/04/2015 10:39, Boris Brezillon wrote:
>>>> On Fri, 17 Apr 2015 10:33:56 +0200
>>>> Boris Brezillon <boris.brezillon@free-electrons.com> wrote:
>>>>
>>>>> Hi Jason,
>>>>>
>>>>> On Mon, 13 Apr 2015 20:11:46 +0000
>>>>> Jason Cooper <jason@lakedaemon.net> wrote:
>>>>>
>>>>>>>
>>>>>>>> I'd appreciate if we'd look into it.  I understand from on-list and
>>>>>>>> off-list discussion that the rewrite was unavoidable.  So I'm willing to
>>>>>>>> concede that.  Giving people time to migrate from old to new while still
>>>>>>>> being able to update for other security fixes seems reasonable.
>>>>>>>
>>>>>>> Jason, what do you think of the approach above? 
>>>>>>
>>>>>> I say keep it simple.  We shouldn't use the DT changes to trigger one
>>>>>> vice the other.  We need to be able to build both, but only load one at
>>>>>> a time.  If that's anything other than simple to do, then we make it a
>>>>>> Kconfig binary choice and move on.
>>>>>
>>>>> Actually I was planning to handle it with a Kconfig dependency rule
>>>>> (NEW_DRIVER depends on !OLD_DRIVER and OLD_DRIVER depends
>>>>> on !NEW_DRIVER).
>>>>> I don't know how to make it a runtime check without adding new
>>>>> compatible strings for the kirkwood, dove and orion platforms, and I'm
>>>>> sure sure this is a good idea.
>>>>   ^ not
>>>>
>>>>> Do you have any ideas ?
>>>
>>> You use devm_ioremap_resource() in the new driver, so if the old one
>>> is already loaded the memory region will be already hold and the new
>>> driver will simply fail during the probe. So for this part it is OK.
>>
>> I like the idea :-).
> 
> Not really, how do you know which device is going to be probed? For
> that matter, it's pretty much random, and you have no control over it.
> 
> Why not just have a choice option, and select which one you want to
> enable?

Because you can't prevent an user to build a module, then modifying the
configuration and building the other module. So even if there is a choice at
build time, and I think that it is something expected for the v2, we still need
preventing having the both drivers trying accessing the same hardware in the
same time.


Thanks,

Gregory



> 
> Maxime
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
