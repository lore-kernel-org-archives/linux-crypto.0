From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Subject: Re: [PATCH 1/2] crypto: Add Imagination Technologies hw hash accelerator
Date: Tue, 11 Nov 2014 17:12:24 +0200
Message-ID: <54622758.7050907@mentor.com>
References: <1415621455-10468-1-git-send-email-james.hartley@imgtec.com> <1415621455-10468-2-git-send-email-james.hartley@imgtec.com> <5460D540.6070205@mentor.com> <72BC0C8BD7BB6F45988A99382E5FBAE54433BAC5@hhmail02.hh.imgtec.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"joe@perches.com" <joe@perches.com>,
	"mchehab@osg.samsung.com" <mchehab@osg.samsung.com>,
	"crope@iki.fi" <crope@iki.fi>,
	"jg1.han@samsung.com" <jg1.han@samsung.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"pawel.moll@arm.com" <pawel.moll@arm.com>,
	"mark.rutland@arm.com" <mark.rutland@arm.com>,
	"ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
	"galak@codeaurora.org" <galak@codeaurora.org>,
	"abrestic@chromium.org" <abrestic@chromium.org>,
	Ezequiel Garcia <Ezequiel.Garcia@imgtec.com>
To: James Hartley <James.Hartley@imgtec.com>,
	"grant.likely@linaro.org" <grant.likely@linaro.org>,
	"robh+dt@kernel.org" <robh+dt@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:57608 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaKKPMd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 Nov 2014 10:12:33 -0500
In-Reply-To: <72BC0C8BD7BB6F45988A99382E5FBAE54433BAC5@hhmail02.hh.imgtec.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi James,

On 11.11.2014 16:59, James Hartley wrote:
> Hi Vladimir, thanks for the review! 
> 
>> -----Original Message-----
>> From: Vladimir Zapolskiy [mailto:vladimir_zapolskiy@mentor.com]
>> Sent: 10 November 2014 15:10
>> To: James Hartley; herbert@gondor.apana.org.au; davem@davemloft.net;
>> grant.likely@linaro.org; robh+dt@kernel.org; akpm@linux-foundation.org;
>> gregkh@linuxfoundation.org; joe@perches.com;
>> mchehab@osg.samsung.com; crope@iki.fi; jg1.han@samsung.com; linux-
>> crypto@vger.kernel.org
>> Cc: devicetree@vger.kernel.org; pawel.moll@arm.com;
>> mark.rutland@arm.com; ijc+devicetree@hellion.org.uk;
>> galak@codeaurora.org; abrestic@chromium.org; Ezequiel Garcia
>> Subject: Re: [PATCH 1/2] crypto: Add Imagination Technologies hw hash
>> accelerator
>>
>> Hello James,
>>
>> On 10.11.2014 14:10, James Hartley wrote:
>>> This adds support for the Imagination Technologies hash accelerator
>>> that provides hardware acceleration for
>>> SHA1 SHA224 SHA256 and MD5 Hashes.
>>>
>>> Signed-off-by: James Hartley <james.hartley@imgtec.com>
>>> ---
>>

[snip]

>>> +
>>> +	return 0;
>>> +
>>> +err_algs:
>>> +	spin_lock(&img_hash.lock);
>>> +	list_del(&hdev->list);
>>> +	spin_unlock(&img_hash.lock);
>>> +	dma_release_channel(hdev->dma_lch);
>>> +err_dma:
>>> +	iounmap(hdev->io_base);
>>
>> Mixing of devm_* resource initialization and commodity resource release
>> leads to double decrement of clock usage count reference.
> 
> Ok, changed to devm_iounmap
> 

just one small comment, please double check, but most probably you don't
need to call devm_iounmap() explicitly on error path.

[snip]

> 
>>
>>> +
>>> +static int img_hash_remove(struct platform_device *pdev) {
>>> +	static struct img_hash_dev *hdev;
>>> +
>>> +	hdev = platform_get_drvdata(pdev);
>>> +	if (!hdev)
>>> +		return -ENODEV;
>>> +	spin_lock(&img_hash.lock);
>>> +	list_del(&hdev->list);
>>> +	spin_unlock(&img_hash.lock);
>>> +
>>> +	img_unregister_algs(hdev);
>>> +
>>> +	tasklet_kill(&hdev->done_task);
>>> +	tasklet_kill(&hdev->dma_task);
>>> +	img_hash_dma_cleanup(hdev);
>>> +
>>> +	iounmap(hdev->io_base);
>>
>> Same as above, devres iounmap() is good enough.
> 
> Done
> 

Same as above, I suppose you can simply remove iounmap() call without
adding explicit devm_iounmap().

--
With best wishes,
Vladimir
