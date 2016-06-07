From: Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCH 02/28] crypto: omap-sham: Don't idle/start SHA device
 between Encrypt operations
Date: Tue, 7 Jun 2016 15:24:43 +0300
Message-ID: <5756BD0B.4030506@ti.com>
References: <1464771389-10640-1-git-send-email-t-kristo@ti.com>
 <1464771389-10640-3-git-send-email-t-kristo@ti.com> <574EB091.6040001@ti.com>
 <574F69D8.1010809@ti.com> <20160607100837.GA30875@gondor.apana.org.au>
 <5756B584.2000900@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-omap@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<davem@davemloft.net>, <tony@atomide.com>,
	<linux-arm-kernel@lists.infradead.org>, <lokeshvutla@ti.com>
To: Tero Kristo <t-kristo@ti.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Dave Gerlach <d-gerlach@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:38353 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754756AbcFGMZQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jun 2016 08:25:16 -0400
In-Reply-To: <5756B584.2000900@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/07/2016 02:52 PM, Tero Kristo wrote:
> On 07/06/16 13:08, Herbert Xu wrote:
>> On Wed, Jun 01, 2016 at 06:03:52PM -0500, Dave Gerlach wrote:
>>> On 06/01/2016 04:53 AM, Grygorii Strashko wrote:
>>>> On 06/01/2016 11:56 AM, Tero Kristo wrote:
>>>>> From: Lokesh Vutla <lokeshvutla@ti.com>
>>>>>
>>>>> Calling runtime PM API for every block causes serious perf hit to
>>>>> crypto operations that are done on a long buffer.
>>>>> As crypto is performed on a page boundary, encrypting large buffers
>>>>> can
>>>>> cause a series of crypto operations divided by page. The runtime PM
>>>>> API
>>>>> is also called those many times.
>>>>>
>>>>> We call runtime_pm_get_sync only at beginning on the session
>>>>> (cra_init)
>>>>> and runtime_pm_put at the end. This result in upto a 50% speedup.
>>>>> This doesn't make the driver to keep the system awake as runtime
>>>>> get/put
>>>>> is only called during a crypto session which completes usually
>>>>> quickly.
>>>>>
>>>>> Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
>>>>> Signed-off-by: Tero Kristo <t-kristo@ti.com>
>>>>> ---
>>>>>   drivers/crypto/omap-sham.c | 27 +++++++++++++++++----------
>>>>>   1 file changed, 17 insertions(+), 10 deletions(-)
>>>>>
>>>>> diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
>>>>> index 6eefaa2..bd0258f 100644
>>>>> --- a/drivers/crypto/omap-sham.c
>>>>> +++ b/drivers/crypto/omap-sham.c
>>>>> @@ -360,14 +360,6 @@ static void omap_sham_copy_ready_hash(struct
>>>>> ahash_request *req)
>>>>>
>>>>>   static int omap_sham_hw_init(struct omap_sham_dev *dd)
>>>>>   {
>>>>> -    int err;
>>>>> -
>>>>> -    err = pm_runtime_get_sync(dd->dev);
>>>>> -    if (err < 0) {
>>>>> -        dev_err(dd->dev, "failed to get sync: %d\n", err);
>>>>> -        return err;
>>>>> -    }
>>>>> -
>>>
>>> Would it be worth it to investigate a pm_runtime autosuspend
>>> approach rather than knocking runtime PM out here completely? I am
>>> not clear if the overhead is coming from the pm_runtime calls
>>> themselves or the actual idling of the IP, but if it's the idling of
>>> the IP causing the slowdown, with a large enough autosuspend_delay
>>> we don't actually sleep between each block but after a long enough
>>> period of idle time we would actually suspend.
>>
>> Indeed, I think this patch is bogus.  cra_init is associated
>> with the tfm object which is usually long-lived.  So doing power
>> management there makes no sense.
>>
>> Cheers,
>>
>
> I can investigate this further, but I believe this patch itself gave a
> noticeable performance boost.
>
> This is an optimization anyway, and not critical for functionality.
>

It is not critical only if below code would not introduce races
+	spin_lock_bh(&sham.lock);
+	list_for_each_entry(dd, &sham.dev_list, list) {
+		break;
+	}
+	spin_unlock_bh(&sham.lock);

Is it guaranteed that dd will alive always at this moment?

+
+	pm_runtime_get_sync(dd->dev);



-- 
regards,
-grygorii
