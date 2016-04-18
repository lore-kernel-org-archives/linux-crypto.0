From: Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH v2 0/4] Introduce bulk mode for crypto engine framework
Date: Mon, 18 Apr 2016 23:22:29 +0200
Message-ID: <57155015.2090104@redhat.com>
References: <cover.1458023695.git.baolin.wang@linaro.org>
 <20160415134849.GA32694@gondor.apana.org.au>
 <CAMz4ku+hXbgx1+YcdJWbCBW7KoeFisk5qcquAAg0fD5Qw5XDFQ@mail.gmail.com>
 <20160418133612.GA16853@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>,
	Alasdair G Kergon <agk@redhat.com>,
	Jens Axboe <axboe@fb.com>, dm-devel@redhat.com,
	Andrew Morton <akpm@linux-foundation.org>,
	david.s.gordon@intel.com, Tom Lendacky <thomas.lendacky@amd.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	smueller@chronox.de, tadeusz.struk@intel.com,
	Masanari Iida <standby24x7@gmail.com>, shli@kernel.org,
	Mark Brown <broonie@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>,
	Baolin Wang <baolin.wang@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbcDRVWm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Apr 2016 17:22:42 -0400
In-Reply-To: <20160418133612.GA16853@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 04/18/2016 03:36 PM, Mike Snitzer wrote:
> On Mon, Apr 18 2016 at  1:31am -0400,
> Baolin Wang <baolin.wang@linaro.org> wrote:
> 
>> Hi Herbert,
>>
>> On 15 April 2016 at 21:48, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>>> On Tue, Mar 15, 2016 at 03:47:58PM +0800, Baolin Wang wrote:
>>>> Now some cipher hardware engines prefer to handle bulk block by merging requests
>>>> to increase the block size and thus increase the hardware engine processing speed.
>>>>
>>>> This patchset introduces request bulk mode to help the crypto hardware drivers
>>>> improve in efficiency.
>>>
>>> Could you please explain why this merging can't be done in dm-crypt
>>> instead?
>>
>> We've tried to do this in dm-crypt, but it failed.
>> The dm-crypt maintainer explained to me that I should optimize the
>> driver, not add strange hw-dependent crypto modes to dm-crypt, this is
>> not the first crypto accelerator that is just not suited for this kind
>> of use.
> 
> As a DM mainatiner my only contribution to this line of discussion was
> relative to your proposal to train the dm-crypt target (which is
> bio-based) to also provide request-based support, see:
> https://www.redhat.com/archives/dm-devel/2015-November/msg00112.html
> 
> But follow-up discussion occured, primarily with Milan Broz, which led
> to this bulk mode support in the crypto layer.  Pretty strange Milan
> wasn't cc'd on your patchset posting (I've now cc'd him).

My complaint was mainly that the proposed dmcrypt based version just did
not work properly.
https://lkml.org/lkml/2016/1/2/109

(I did not test the new version we are replying here. I wonder how the problem
I mentioned is fixed though.
Also see Mikulas' comments https://www.redhat.com/archives/dm-devel/2016-January/msg00145.html)
 
Anyway, all this seems to optimize case for specific crypto hw, that
is not able to perform optimally with pattern dmcrypt produces.

I do not think dmcrypt should do optimizations for specific hw.

But if we decide that it is needed there, it should not cause any performance
or compatibility problems elsewhere...

Milan
