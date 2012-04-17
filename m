From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: RAID5 XOR speed vs RAID6 Q speed (was Re: AVX RAID5 xor checksumming)
Date: Tue, 17 Apr 2012 18:32:42 +0300
Message-ID: <4F8D8D1A.4090600@panasas.com>
References: <4F7ACF94.5080505@anonymous.org.uk> <1333497379-2640-1-git-send-email-james.t.kukunas@linux.intel.com> <CAA9_cmcE5BfZX2RwOpo=qng2_2wnvhm5dB-dBfjFGOUWiSy3fw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jim Kukunas <james.t.kukunas@linux.intel.com>,
	<linux-raid@vger.kernel.org>, <linux-crypto@vger.kernel.org>
To: Dan Williams <dan.j.williams@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmcE5BfZX2RwOpo=qng2_2wnvhm5dB-dBfjFGOUWiSy3fw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 04/06/2012 11:43 PM, Dan Williams wrote:

> [adding Boaz since he also made an attempt at fixing this]
> 
> http://marc.info/?l=linux-crypto-vger&m=131829241111450&w=2
> 
> ...I had meant to follow up on this, but was buried in 'isci' issues.
> 
> 


Sorry was traveling.

Yes I have an old fix for this. Which I need to cleanup and retest.
My original problem was an hang in UML, but I noticed the timing problems
as well.

Please give me til the end of the week to settle in and come up to speed.

[Current patch: http://marc.info/?l=linux-crypto-vger&m=131829242311458&w=2]

Thanks
Boaz

> On Tue, Apr 3, 2012 at 4:56 PM, Jim Kukunas
> <james.t.kukunas@linux.intel.com> wrote:
>> On Tue, Apr 03, 2012 at 11:23:16AM +0100, John Robinson wrote:
>>> On 02/04/2012 23:48, Jim Kukunas wrote:
>>>> On Sat, Mar 31, 2012 at 12:38:56PM +0100, John Robinson wrote:
>>> [...]
>>>>> I just noticed in my logs the other day (recent el5 kernel on a Core 2):
>>>>>
>>>>> raid5: automatically using best checksumming function: generic_sse
>>>>>      generic_sse:  7805.000 MB/sec
>>>>> raid5: using function: generic_sse (7805.000 MB/sec)
>>> [...]
>>>>> raid6: using algorithm sse2x4 (8237 MB/s)
>>>>>
>>>>> I was just wondering how it's possible to do the RAID6 Q calculation
>>>>> faster than the RAID5 XOR calculation - or am I reading this log excerpt
>>>>> wrongly?
>>>>
>>>> Out of curiosity, are you running with CONFIG_PREEMPT=y?
>>>
>>> No. Here's an excerpt from my .config:
>>>
>>> # CONFIG_PREEMPT_NONE is not set
>>> CONFIG_PREEMPT_VOLUNTARY=y
>>> # CONFIG_PREEMPT is not set
>>> CONFIG_PREEMPT_BKL=y
>>> CONFIG_PREEMPT_NOTIFIERS=y
>>>
>>> But this is a Xen dom0 kernel, 2.6.18-308.1.1.el5.centos.plusxen. Now, a
>>> non-Xen kernel (2.6.18-308.1.1.el5) says:
>>> raid5: automatically using best checksumming function: generic_sse
>>>     generic_sse: 11892.000 MB/sec
>>> raid5: using function: generic_sse (11892.000 MB/sec)
>>> raid6: int64x1   2644 MB/s
>>> raid6: int64x2   3238 MB/s
>>> raid6: int64x4   3011 MB/s
>>> raid6: int64x8   2503 MB/s
>>> raid6: sse2x1    5375 MB/s
>>> raid6: sse2x2    5851 MB/s
>>> raid6: sse2x4    9136 MB/s
>>> raid6: using algorithm sse2x4 (9136 MB/s)
>>>
>>> Looks like it loses a chunk of performance running as a Xen dom0.
>>>
>>> Even still, 11892 MB/s for XOR vs 9136 MB/s for XOR+Q - it still seems
>>> remarkable that the XOR can't be done several times faster than the Q.
>>
>> Taking a look at do_xor_speed, I see two issues which might be the cause
>> of the disparity you reported.
>>
>> 0) In the RAID5 xor benchmark, we get the current jiffy, then run do_2() until
>> the jiffy increments. This means we could potentially be testing for less
>> than a full jiffy. The RAID6 benchmark handles this by obtaining the current
>> jiffy, then calling cpu_relax() until the jiffy increments, and then running
>> the test. This is addressed by my first patch.
>>
>> 1) The only way I could reproduce your findings of a higher throughput for
>> RAID6 than for RAID5 xor checksumming was with CONFIG_PREEMPT=y. It seems
>> that you encountered this while running as XEN dom0. Currently, we disable
>> preemption during the RAID6 benchmark, but don't in the RAID5 benchmark.
>> This is addressed by my second patch.
>>
>> I've added linux-crypto to the discussion as both of these patches affect
>> code in crypto/
>>
>> Thanks.
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html


