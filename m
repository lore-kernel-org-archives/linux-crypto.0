Return-Path: <SRS0=RIhc=ZC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73B68C43331
	for <linux-crypto@archiver.kernel.org>; Sun, 10 Nov 2019 00:30:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32A87206DF
	for <linux-crypto@archiver.kernel.org>; Sun, 10 Nov 2019 00:30:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfKJAad (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 9 Nov 2019 19:30:33 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:34644 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726537AbfKJAac (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 9 Nov 2019 19:30:32 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92.3)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1iTb7S-0007jw-4C; Sun, 10 Nov 2019 01:30:18 +0100
Subject: Re: [PATCH v3] hwrng: core: Freeze khwrng thread during suspend
To:     Stephen Boyd <swboyd@chromium.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Andrey Pronin <apronin@chromium.org>,
        Duncan Laurie <dlaurie@chromium.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <groeck@chromium.org>,
        Alexander Steffen <Alexander.Steffen@infineon.com>,
        Amit Shah <amit@kernel.org>
References: <20190805233241.220521-1-swboyd@chromium.org>
 <4a45b3e0-ed3a-61d3-bfc6-957c7ba631bb@maciej.szmigiero.name>
 <5db85058.1c69fb81.202d7.e3d0@mx.google.com>
 <fbe7268f-3cda-ee0f-d02a-f2e78a599de5@maciej.szmigiero.name>
 <5dc0c12e.1c69fb81.2ce1c.01ee@mx.google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Autocrypt: addr=mail@maciej.szmigiero.name; prefer-encrypt=mutual; keydata=
 mQINBFpGusUBEADXUMM2t7y9sHhI79+2QUnDdpauIBjZDukPZArwD+sDlx5P+jxaZ13XjUQc
 6oJdk+jpvKiyzlbKqlDtw/Y2Ob24tg1g/zvkHn8AVUwX+ZWWewSZ0vcwp7u/LvA+w2nJbIL1
 N0/QUUdmxfkWTHhNqgkNX5hEmYqhwUPozFR0zblfD/6+XFR7VM9yT0fZPLqYLNOmGfqAXlxY
 m8nWmi+lxkd/PYqQQwOq6GQwxjRFEvSc09m/YPYo9hxh7a6s8hAP88YOf2PD8oBB1r5E7KGb
 Fv10Qss4CU/3zaiyRTExWwOJnTQdzSbtnM3S8/ZO/sL0FY/b4VLtlZzERAraxHdnPn8GgxYk
 oPtAqoyf52RkCabL9dsXPWYQjkwG8WEUPScHDy8Uoo6imQujshG23A99iPuXcWc/5ld9mIo/
 Ee7kN50MOXwS4vCJSv0cMkVhh77CmGUv5++E/rPcbXPLTPeRVy6SHgdDhIj7elmx2Lgo0cyh
 uyxyBKSuzPvb61nh5EKAGL7kPqflNw7LJkInzHqKHDNu57rVuCHEx4yxcKNB4pdE2SgyPxs9
 9W7Cz0q2Hd7Yu8GOXvMfQfrBiEV4q4PzidUtV6sLqVq0RMK7LEi0RiZpthwxz0IUFwRw2KS/
 9Kgs9LmOXYimodrV0pMxpVqcyTepmDSoWzyXNP2NL1+GuQtaTQARAQABtDBNYWNpZWogUy4g
 U3ptaWdpZXJvIDxtYWlsQG1hY2llai5zem1pZ2llcm8ubmFtZT6JAlQEEwEIAD4WIQRyeg1N
 257Z9gOb7O+Ef143kM4JdwUCWka6xQIbAwUJA8JnAAULCQgHAgYVCgkICwIEFgIDAQIeAQIX
 gAAKCRCEf143kM4Jdx4+EACwi1bXraGxNwgFj+KI8T0Xar3fYdaOF7bb7cAHllBCPQkutjnx
 8SkYxqGvSNbBhGtpL1TqAYLB1Jr+ElB8qWEV6bJrffbRmsiBPORAxMfu8FF+kVqCYZs3nbku
 XNzmzp6R/eii40S+XySiscmpsrVQvz7I+xIIYdC0OTUu0Vl3IHf718GBYSD+TodCazEdN96k
 p9uD9kWNCU1vnL7FzhqClhPYLjPCkotrWM4gBNDbRiEHv1zMXb0/jVIR/wcDIUv6SLhzDIQn
 Lhre8LyKwid+WQxq7ZF0H+0VnPf5q56990cEBeB4xSyI+tr47uNP2K1kmW1FPd5q6XlIlvh2
 WxsG6RNphbo8lIE6sd7NWSY3wXu4/R1AGdn2mnXKMp2O9039ewY6IhoeodCKN39ZR9LNld2w
 Dp0MU39LukPZKkVtbMEOEi0R1LXQAY0TQO//0IlAehfbkkYv6IAuNDd/exnj59GtwRfsXaVR
 Nw7XR/8bCvwU4svyRqI4luSuEiXvM9rwDAXbRKmu+Pk5h+1AOV+KjKPWCkBEHaASOxuApouQ
 aPZw6HDJ3fdFmN+m+vNcRPzST30QxGrXlS5GgY6CJ10W9gt/IJrFGoGxGxYjj4WzO97Rg6Mq
 WMa7wMPPNcnX5Nc/b8HW67Jhs3trj0szq6FKhqBsACktOU4g/ksV8eEtnLkBjQRaRrtSAQwA
 1c8skXiNYGgitv7X8osxlkOGiqvy1WVV6jJsv068W6irDhVETSB6lSc7Qozk9podxjlrae9b
 vqfaJxsWhuwQjd+QKAvklWiLqw4dll2R3+aanBcRJcdZ9iw0T63ctD26xz84Wm7HIVhGOKsS
 yHHWJv2CVHjfD9ppxs62XuQNNb3vP3i7LEto9zT1Zwt6TKsJy5kWSjfRr+2eoSi0LIzBFaGN
 D8UOP8FdpS7MEkqUQPMI17E+02+5XCLh33yXgHFVyWUxChqL2r8y57iXBYE/9XF3j4+58oTD
 ne/3ef+6dwZGyqyP1C34vWoh/IBq2Ld4cKWhzOUXlqKJno0V6pR0UgnIJN7SchdZy5jd0Mrq
 yEI5k7fcQHJxLK6wvoQv3mogZok4ddLRJdADifE4+OMyKwzjLXtmjqNtW1iLGc/JjMXQxRi0
 ksC8iTXgOjY0f7G4iMkgZkBfd1zqfS+5DfcGdxgpM0m9EZ1mhERRR80U6C+ZZ5VzXga2bj0o
 ZSumgODJABEBAAGJA/IEGAEIACYWIQRyeg1N257Z9gOb7O+Ef143kM4JdwUCWka7UgIbAgUJ
 A8JnAAHACRCEf143kM4Jd8D0IAQZAQgAHRYhBOJ3aqugjib/WhtKCVKx1ulR0M4HBQJaRrtS
 AAoJEFKx1ulR0M4Hc7UL/j0YQlUOylLkDBLzGh/q3NRiGh0+iIG75++2xBtSnd/Y195SQ3cm
 V61asRcpS7uuK/vZB3grJTPlKv31DPeKHe3FxpLwlu0k9TFBkN4Pv6wH/PBeZfio1My0ocNr
 MRJT/rIxkBkOMy5b3uTGqxrVeEx+nSZQ12U7ccB6LR2Q4gNm1HiWC5TAIIMCzP6wUvcX8rTD
 bhZPFNEx0f01cL7t1cpo3ToyZ0nnBcrvYkbJEV3PCwPScag235hE3j4NXT3ocYsIDL3Yt1nW
 JOAQdcDJdDHZ1NhGtwHY1N51/lHP56TzLw7s2ovWQO/7VRtUWkISBJS/OfgOU29ls5dCKDtZ
 E2n5GkDQTkrRHjtX4S0s+f9w7fnTjqsae1bsEh6hF2943OloJ8GYophfL7xsxNjzQQLiAMBi
 LWNn5KRm5W5pjW/6mGRI3W1TY3yV8lcns//0KIlK0JNrAvZzS+82ExDKHLiRTfdGttefIeb3
 tagU9I6VMevTpMkfPw8ZwBJo9OFkqGIZD/9gi2tFPcZvQbjuKrRqM/S21CZrI+HfyQTUw/DO
 OtYqCnhmw7Xcg1YRo9zsp/ffo/OQR1a3d8DryBX9ye8o7uZsd+hshlvLExXHJLvkrGGK5aFA
 ozlp9hqylIHoCBrWTUuKuuL8Tdxn3qahQiMCpCacULWar/wCYsQvM/SUxosonItS7fShdp7n
 ObAHB4JToNGS6QfmVWHakeZSmz+vAi/FHjL2+w2RcaPteIcLdGPxcJ9oDMyVv2xKsyA4Xnfp
 eSWa5mKD1RW1TweWqcPqWlCW5LAUPtOSnexbIQB0ZoYZE6x65BHPgXKlkSqnPstyCp619qLG
 JOo85L9OCnyKDeQy5+lZEs5YhXy2cmOQ5Ns6kz20IZS/VwIQWBogsBv46OyPE9oaLvngj6ZJ
 YXqE2pgh2O3rCk6kFPiNwmihCo/EoL73I6HUWUIFeUq9Gm57Z49H+lLrBcXf5k8HcV89CGAU
 sbn2vAl0pU8oHOwnA/v44D3zJ/Z2agJeYAlb4GgrPqbeIyOt3I99SbCKUZyt7BIB6Uie6GE0
 9RGs1+rbnsSDPdIVl+yhV1QhdBLsRc3oOTP+us9V2IMepipsClfkA0nBJ4+dRe2GitjCU9l3
 8Cyk96OvgngkkbYJQSrpXvM/BIyWTtTSfzNwhUltQLNoqfw0plDRlA0j6i/jrvrVaoy177kB
 jQRaRrwiAQwAxnVmJqeP9VUTISps+WbyYFYlMFfIurl7tzK74bc67KUBp+PHuDP9p4ZcJUGC
 3UZJP85/GlUVdE1NairYWEJQUB7bpogTuzMI825QXIB9z842HwWfP2RW5eDtJMeujzJeFaUp
 meTG9snzaYxYN3r0TDKj5dZwSIThIMQpsmhH2zylkT0jH7kBPxb8IkCQ1c6wgKITwoHFjTIO
 0B75U7bBNSDpXUaUDvd6T3xd1Fz57ujAvKHrZfWtaNSGwLmUYQAcFvrKDGPB5Z3ggkiTtkmW
 3OCQbnIxGJJw/+HefYhB5/kCcpKUQ2RYcYgCZ0/WcES1xU5dnNe4i0a5gsOFSOYCpNCfTHtt
 VxKxZZTQ/rxjXwTuToXmTI4Nehn96t25DHZ0t9L9UEJ0yxH2y8Av4rtf75K2yAXFZa8dHnQg
 CkyjA/gs0ujGwD+Gs7dYQxP4i+rLhwBWD3mawJxLxY0vGwkG7k7npqanlsWlATHpOdqBMUiA
 R22hs02FikAoiXNgWTy7ABEBAAGJAjwEGAEIACYWIQRyeg1N257Z9gOb7O+Ef143kM4JdwUC
 Wka8IgIbDAUJA8JnAAAKCRCEf143kM4Jd9nXD/9jstJU6L1MLyr/ydKOnY48pSlZYgII9rSn
 FyLUHzNcW2c/qw9LPMlDcK13tiVRQgKT4W+RvsET/tZCQcap2OF3Z6vd1naTur7oJvgvVM5l
 VhUia2O60kEZXNlMLFwLSmGXhaAXNBySpzN2xStSLCtbK58r7Vf9QS0mR0PGU2v68Cb8fFWc
 Yu2Yzn3RXf0YdIVWvaQG9whxZq5MdJm5dknfTcCG+MtmbP/DnpQpjAlgVmDgMgYTBW1W9etU
 36YW0pTqEYuv6cmRgSAKEDaYHhFLTR1+lLJkp5fFo3Sjm7XqmXzfSv9JGJGMKzoFOMBoLYv+
 VFnMoLX5UJAs0JyFqFY2YxGyLd4J103NI/ocqQeU0TVvOZGVkENPSxIESnbxPghsEC0MWEbG
 svqA8FwvU7XfGhZPYzTRf7CndDnezEA69EhwpZXKs4CvxbXo5PDTv0OWzVaAWqq8s8aTMJWW
 AhvobFozJ63zafYHkuEjMo0Xps3o3uvKg7coooH521nNsv4ci+KeBq3mgMCRAy0g/Ef+Ql7m
 t900RCBHu4tktOhPc3J1ep/e2WAJ4ngUqJhilzyCJnzVJ4cT79VK/uPtlfUCZdUz+jTC88Tm
 P1p5wlucS31kThy/CV4cqDFB8yzEujTSiRzd7neG3sH0vcxBd69uvSxLZPLGID840k0v5sft PA==
Message-ID: <fe7e608e-d94d-a15c-bdc0-8431e9fce5c1@maciej.szmigiero.name>
Date:   Sun, 10 Nov 2019 01:30:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <5dc0c12e.1c69fb81.2ce1c.01ee@mx.google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 05.11.2019 01:24, Stephen Boyd wrote:
> Quoting Maciej S. Szmigiero (2019-10-29 08:50:52)
>> On 29.10.2019 15:44, Stephen Boyd wrote:
>>> Quoting Maciej S. Szmigiero (2019-10-28 16:45:31)
>>>> Hi Stephen,
>>>>
>>>> On 06.08.2019 01:32, Stephen Boyd wrote:
>>>>> The hwrng_fill() function can run while devices are suspending and
>>>>> resuming. If the hwrng is behind a bus such as i2c or SPI and that bus
>>>>> is suspended, the hwrng may hang the bus while attempting to add some
>>>>> randomness. It's been observed on ChromeOS devices with suspend-to-idle
>>>>> (s2idle) and an i2c based hwrng that this kthread may run and ask the
>>>>> hwrng device for randomness before the i2c bus has been resumed.
>>>>>
>>>>> Let's make this kthread freezable so that we don't try to touch the
>>>>> hwrng during suspend/resume. This ensures that we can't cause the hwrng
>>>>> backing driver to get into a bad state because the device is guaranteed
>>>>> to be resumed before the hwrng kthread is thawed.
>>>>
>>>> This patch broke suspend with virtio-rng loaded (it hangs).
>>>>
>>>> The problematic call chain is:
>>>> virtrng_freeze() -> remove_common() -> hwrng_unregister() ->
>>>> kthread_stop().
>>>>
>>>> It looks like kthread_stop() can't finish on a frozen khwrng thread.
>>>
>>> Can you provide the suspend/resume logs?
>>
>> There isn't much in the kernel log, the closest thing I can get is
>> with dyndbg="file drivers/base/power/main.c +p":
>> [   58.441073][ T3511] virtio-pci 0000:00:06.0: bus freeze
>> [   58.448744][ T3511] virtio-pci 0000:00:05.0: bus freeze
>> [   58.454500][ T3511] virtio-pci 0000:00:04.0: bus freeze
>> [   58.456873][ T3511] virtio-pci 0000:00:03.0: bus freeze
>>
>> And then the VM hangs.
>>
>> The 0000:00:03.0 pci device is virtio-rng.
>>
>> If I add printks around that kthread_stop() in hwrng_unregister()
>> only the first one gets printed.
> 
> Ok. I don't know why virtio rng wants to remove itself and then reprobe
> across suspend/resume. Do you know the history there?

Hard to tell, I have added Amit, who had implemented these PM callbacks
back in 2012, to CC now.

> Can you enable the dynamic debug printk in __refrigerator()?
> 
> 	file kernel/freezer.c +p
> 
> That will let us know when the kthread has been frozen/thawed.
> 
> Either way, it sounds like maybe it's what you say, virtio rng wants to
> call kthread_stop() on a kthread that's been frozen already and then it
> just hangs waiting for the thread to wake up, which it never does. I
> can't convince myself that the schedule() inside __refrigerator() won't
> wake up though. I would think it leaves the refrigerator when
> kthread_stop() is called because the kthread will wakeup from
> wake_up_process() in kthread_stop(), see it should stop in
> __refrigerator() and eventually exit. Maybe the hwrng thread is stuck
> somewhere else?
> 

Yes, it turns out the hwrng kthread is actually stuck inside
add_hwgenerator_randomness() in wait_event_freezable() call introduced
by commit 59b569480dc8
("random: Use wait_event_freezable() in add_hwgenerator_randomness()").

wait_event_freezable() ultimately calls __refrigerator() with its
check_kthr_stop argument set to false, which causes it to keep the
kthread frozen even if somebody calls kthread_stop() on it.

Calling wait_event_freezable() with kthread_should_stop() as a condition
seems racy because it doesn't take into account the situation where this
condition becomes true on a kthread marked for freezing only after it
has been checked.

I was able to make the VM write a s2disk image with the following change:
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -2500,8 +2500,8 @@ void add_hwgenerator_randomness(const char *buffer, size_t count,
 	 * We'll be woken up again once below random_write_wakeup_thresh,
 	 * or when the calling thread is about to terminate.
 	 */
-	wait_event_freezable(random_write_wait,
-			kthread_should_stop() ||
+	wait_event_interruptible(random_write_wait,
+			kthread_should_stop() || freezing(current) ||
 			ENTROPY_BITS(&input_pool) <= random_write_wakeup_bits);
 	mix_pool_bytes(poolp, buffer, count);
 	credit_entropy_bits(poolp, entropy);

Calling freezing() should avoid the issue that the commit 59b569480dc8
has fixed, as it is only a checking function, it doesn't actually do
the freezing.

However, while the written image seems valid (the machine will resume
successfully from it) the suspend process still hangs, only now a bit
later.

It turns out there is a second issue where the set_freezable() call
at the beginning of hwrng_fillfn() will freeze this kthread with
(again) check_kthr_stop argument set to false when this kthread gets
relaunched when devices are resumed to write the hibernation image
at the suspend time.

That makes the frozen kthread impossible to stop on shutdown, so the
VM hangs there.

If I only clear the PF_NOFREEZE flag instead of calling set_freezable()
at the beginning of hwrng_fillfn() the suspend process will complete
successfully.

However, it seems to me that the real solution here would be to
change the virtio-rng driver to not unregister / reregister itself
on PM events rather than fight the freezer / kthread_stop()
interactions.

Maciej
