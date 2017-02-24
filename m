From: Harald Freudenberger <freude@linux.vnet.ibm.com>
Subject: Re: crypto: hang in crypto_larval_lookup
Date: Fri, 24 Feb 2017 11:32:11 +0100
Message-ID: <66fa483d-9961-728a-b147-46036bd6557b@linux.vnet.ibm.com>
References: <02b80c39-0fd5-b7bd-39da-07e5d71abbad@linux.vnet.ibm.com>
 <20170223111957.GA14000@gondor.apana.org.au>
 <20170223113909.GA14090@gondor.apana.org.au>
 <d7cc7cd8-3632-2508-9931-a5e0875a54cd@linux.vnet.ibm.com>
 <5e3fb7fe-2229-d098-139a-7d749de8ff73@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, schwidefsky@de.ibm.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56515 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751080AbdBXKcY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Feb 2017 05:32:24 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v1OASoD6127672
        for <linux-crypto@vger.kernel.org>; Fri, 24 Feb 2017 05:32:23 -0500
Received: from e06smtp12.uk.ibm.com (e06smtp12.uk.ibm.com [195.75.94.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 28t0aw6umm-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Fri, 24 Feb 2017 05:32:23 -0500
Received: from localhost
        by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <freude@linux.vnet.ibm.com>;
        Fri, 24 Feb 2017 10:32:20 -0000
In-Reply-To: <5e3fb7fe-2229-d098-139a-7d749de8ff73@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/24/2017 09:42 AM, Harald Freudenberger wrote:
> On 02/23/2017 05:02 PM, Harald Freudenberger wrote:
>> On 02/23/2017 12:39 PM, Herbert Xu wrote:
>>> On Thu, Feb 23, 2017 at 07:19:57PM +0800, Herbert Xu wrote:
>>>> Harald Freudenberger <freude@linux.vnet.ibm.com> wrote:
>>>>> Hello all
>>>>>
>>>>> I am currently following a hang at modprobe aes_s390 where
>>>>> crypto_register_alg() does not come back for the xts(aes) algorithm.
>>>>>
>>>>> The registration is waiting forever in algapi.c crypto_wait_for_test() but
>>>>> the completion never occurs. The cryptomgr is triggering a test via
>>>>> kthread_run to invoce cryptomgr_probe and this thread is calling the
>>>>> create() function of the xts template (file xts.c). Following this thread
>>>>> it comes down to api.c crypto_larval_lookup(name="aes") which is first
>>>>> requesting the module "crypto-aes" via request_module() successful and then
>>>>> blocking forever in requesting the module "crypto-aes-all".
>>>>>
>>>>> The xts(aes) has at registration CRYPTO_ALG_NEED_FALLBACK flag on.
>>>>>
>>>>> This problem is seen since about 6 weeks now, first only on the linux next
>>>>> kernel. Now it appers on the 4.10-rc kernels as well. And I still have no
>>>>> idea on how this could be fixed or what's wrong with just the xts
>>>>> registration (ecb, cbc, ctr work fine).
>>>>>
>>>>> Any ideas or hints?
>>>> Sorry, my fault.  I should've converted all the fallback users of
>>>> the old blkcipher interface over to skcipher before converting the
>>>> core algorithms to skcipher.
>>>>
>>>> I'll send a patch.
>>> Hmm, actually looks like I did convert this one :)
>>>
>>> Do you have ECB enabled in your configuration? XTS doesn't work
>>> without it.  Currently the Kconfig is missing a select on ECB so
>>> it could stop the generic XTS from loading.
>>>
>>> However, you seem to be stuck on straight AES which quite strange.
>>> The reason is that s390 crypto registers AES as the first thing so
>>> it should already be available.
>>>
>>> The fact that it hangs is expected because it's trying to find
>>> an acceptable AES implementation and in doing so it's loading
>>> s390-aes again.
>>>
>>> So we need to get to the bottom of why there is no acceptable
>>> "aes" registered.  Can you check /proc/crypto to see if the simple
>>> aes cipher is correctly registered (passing the selftest) after
>>> it hangs?
>>>
>>> You could also print out the type/mask in crypto_larval_lookup
>>> to see if perhaps the caller is asking for something unreasonable.
>>>
>>> Thanks,
>> Thanks for your help, here is cat /proc/crypto:
>> name         : xts(aes)
>> driver       :
>> module       : kernel
>> priority     : -1
>> refcnt       : 3
>> selftest     : passed
>> internal     : no
>> type         : larval
>> flags        : 0x415
>>
>> name         : xts(aes)
>> driver       : xts-aes-s390
>> module       : kernel
>> priority     : 400
>> refcnt       : 1
>> selftest     : passed
>> internal     : no
>> type         : larval
>> flags        : 0x514
>>
>> name         : xts(aes)
>> driver       : xts-aes-s390
>> module       : aes_s390
>> priority     : 400
>> refcnt       : 4
>> selftest     : unknown
>> internal     : no
>> type         : blkcipher
>> blocksize    : 16
>> min keysize  : 32
>> max keysize  : 64
>> ivsize       : 16
>> geniv        : <default>
>>
>> ...
>>
>> name         : ecb(aes)
>> driver       : ecb(aes-s390)
>> module       : kernel
>> priority     : 300
>> refcnt       : 1
>> selftest     : passed
>> internal     : no
>> type         : blkcipher
>> blocksize    : 16
>> min keysize  : 16
>> max keysize  : 32
>> ivsize       : 0
>> geniv        : <default>
>>
>> name         : ecb(aes)
>> driver       : ecb-aes-s390
>> module       : aes_s390
>> priority     : 400
>> refcnt       : 1
>> selftest     : passed
>> internal     : no
>> type         : blkcipher
>> blocksize    : 16
>> min keysize  : 16
>> max keysize  : 32
>> ivsize       : 0
>> geniv        : <default>
>>
>> name         : aes
>> driver       : aes-s390
>> module       : aes_s390
>> priority     : 300
>> refcnt       : 1
>> selftest     : passed
>> internal     : no
>> type         : cipher
>> blocksize    : 16
>> min keysize  : 16
>> max keysize  : 32
>> ...
>>
>> at the time where the modprobe hangs.
>>
>> And here is some syslog output (I added some printks for debugging) maybe
>> it may give you some hints about whats going on during the modprobe:
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_larval_lookup calling crypto_alg_lookup()
>> Feb 23 16:52:08 r35lp49 kernel: ->__crypto_alg_lookup(name=aes)
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_alg_get(alg.cra_name=aes) alg=0000000000f2dd68 alg.cra_refcnt=2
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_mod_get(alg.cra_name=aes alg=0000000000f2dd68 alg.cra_driver_name=aes-generic alg.cra_module.name=(null))
>> Feb 23 16:52:08 r35lp49 kernel: <-__crypto_alg_lookup(name=aes) alg=0000000000f2dd68
>> Feb 23 16:52:08 r35lp49 kernel: <-crypto_larval_lookup(name=aes) alg=0000000000f2dd68
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_mod_put(alg.cra_name=aes alg=0000000000f2dd68 alg.cra_driver_name=aes-generic, alg.cra_module.name=(null))
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_alg_put(alg.cra_name=aes alg=0000000000f2dd68 alg.cra_refcnt=2)
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_mod_put(alg.cra_name=aes alg=000003ff80178480 alg.cra_driver_name=aes-s390, alg.cra_module.name=aes_s390)
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_alg_put(alg.cra_name=aes alg=000003ff80178480 alg.cra_refcnt=2)
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_mod_put(alg.cra_name=cbc(aes) alg=00000000b92d3548 alg.cra_driver_name=cbc(aes-s390), alg.cra_module.name=(null))
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_alg_put(alg.cra_name=cbc(aes) alg=00000000b92d3548 alg.cra_refcnt=4)
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_alg_get(alg.cra_name=cbc(aes)) alg=00000000b92d3548 alg.cra_refcnt=4
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_mod_get(alg.cra_name=cbc(aes) alg=00000000b92d3548 alg.cra_driver_name=cbc(aes-s390) alg.cra_module.name=(null))
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_alg_put(alg.cra_name=cbc(aes) alg=00000000b92d4598 alg.cra_refcnt=1)
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_mod_put(alg.cra_name=cbc(aes) alg=00000000b92d3548 alg.cra_driver_name=cbc(aes-s390), alg.cra_module.name=(null))
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_alg_put(alg.cra_name=cbc(aes) alg=00000000b92d3548 alg.cra_refcnt=4)
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_mod_put(alg.cra_name=cbc(aes) alg=00000000b92d3548 alg.cra_driver_name=cbc(aes-s390), alg.cra_module.name=(null))
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_alg_put(alg.cra_name=cbc(aes) alg=00000000b92d3548 alg.cra_refcnt=3)
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_alg_put(alg.cra_name=cbc(aes) alg=00000000b92d3858 alg.cra_refcnt=3)
>> Feb 23 16:52:08 r35lp49 kernel: <-cryptomgr_probe(data=00000000b8b5d698)
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_alg_get(alg.cra_name=cbc(aes)) alg=00000000b92d3548 alg.cra_refcnt=3
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_mod_get(alg.cra_name=cbc(aes) alg=00000000b92d3548 alg.cra_driver_name=cbc(aes-s390) alg.cra_module.name=(null))
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_mod_put(alg.cra_name=cbc(aes) alg=00000000b92d3858 alg.cra_driver_name=, alg.cra_module.name=(null))
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_alg_put(alg.cra_name=cbc(aes) alg=00000000b92d3858 alg.cra_refcnt=2)
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_alg_put(alg.cra_name=cbc(aes) alg=00000000b92d3858 alg.cra_refcnt=1)
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_mod_put(alg.cra_name=cbc(aes) alg=00000000b92d3548 alg.cra_driver_name=cbc(aes-s390), alg.cra_module.name=(null))
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_alg_put(alg.cra_name=cbc(aes) alg=00000000b92d3548 alg.cra_refcnt=3)
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_alg_get(alg.cra_name=aes) alg=000003ff80178480 alg.cra_refcnt=2
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_mod_get(alg.cra_name=aes alg=000003ff80178480 alg.cra_driver_name=aes-s390 alg.cra_module.name=aes_s390)
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_alg_mod_lookup(name=aes)
>> Feb 23 16:52:08 r35lp49 kernel: ->crypto_larval_lookup(name=aes)
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_larval_lookup calling crypto_alg_lookup()
>> Feb 23 16:52:08 r35lp49 kernel: ->__crypto_alg_lookup(name=aes)
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_alg_get(alg.cra_name=aes) alg=0000000000f2dd68 alg.cra_refcnt=2
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_mod_get(alg.cra_name=aes alg=0000000000f2dd68 alg.cra_driver_name=aes-generic alg.cra_module.name=(null))
>> Feb 23 16:52:08 r35lp49 kernel: <-__crypto_alg_lookup(name=aes) alg=0000000000f2dd68
>> Feb 23 16:52:08 r35lp49 kernel: <-crypto_larval_lookup(name=aes) alg=0000000000f2dd68
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_mod_put(alg.cra_name=aes alg=0000000000f2dd68 alg.cra_driver_name=aes-generic, alg.cra_module.name=(null))
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_alg_put(alg.cra_name=aes alg=0000000000f2dd68 alg.cra_refcnt=2)
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_mod_put(alg.cra_name=aes alg=000003ff80178480 alg.cra_driver_name=aes-s390, alg.cra_module.name=aes_s390)
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_alg_put(alg.cra_name=aes alg=000003ff80178480 alg.cra_refcnt=2)
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_mod_put(alg.cra_name=cbc(aes) alg=00000000b92d3548 alg.cra_driver_name=cbc(aes-s390), alg.cra_module.name=(null))
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_alg_put(alg.cra_name=cbc(aes) alg=00000000b92d3548 alg.cra_refcnt=2)
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_mod_put(alg.cra_name=cbc(aes) alg=000003ff80178240 alg.cra_driver_name=cbc-aes-s390, alg.cra_module.name=aes_s390)
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_alg_put(alg.cra_name=cbc(aes) alg=000003ff80178240 alg.cra_refcnt=4)
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_mod_put(alg.cra_name=cbc(aes) alg=000003ff80178240 alg.cra_driver_name=cbc-aes-s390, alg.cra_module.name=aes_s390)
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_alg_put(alg.cra_name=cbc(aes) alg=000003ff80178240 alg.cra_refcnt=3)
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_alg_put(alg.cra_name=cbc(aes) alg=00000000b92d4248 alg.cra_refcnt=1)
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_mod_put(alg.cra_name=cbc(aes) alg=000003ff80178240 alg.cra_driver_name=cbc-aes-s390, alg.cra_module.name=aes_s390)
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_alg_put(alg.cra_name=cbc(aes) alg=000003ff80178240 alg.cra_refcnt=2)
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_alg_get(alg.cra_name=xts(aes)) alg=000003ff80178120 alg.cra_refcnt=2
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_mod_get(alg.cra_name=xts(aes) alg=000003ff80178120 alg.cra_driver_name=xts-aes-s390 alg.cra_module.name=aes_s390)
>> Feb 23 16:52:08 r35lp49 kernel:   cryptomgr_notify(data=000003ff80178120)
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_alg_mod_lookup(name=xts-aes-s390)
>> Feb 23 16:52:08 r35lp49 kernel: ->crypto_larval_lookup(name=xts-aes-s390)
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_larval_lookup calling crypto_alg_lookup()
>> Feb 23 16:52:08 r35lp49 kernel: ->__crypto_alg_lookup(name=xts-aes-s390)
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_alg_get(alg.cra_name=xts(aes)) alg=000003ff80178120 alg.cra_refcnt=3
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_mod_get(alg.cra_name=xts(aes) alg=000003ff80178120 alg.cra_driver_name=xts-aes-s390 alg.cra_module.name=aes_s390)
>> Feb 23 16:52:08 r35lp49 kernel: <-__crypto_alg_lookup(name=xts-aes-s390) alg=000003ff80178120
>> Feb 23 16:52:08 r35lp49 kernel: <-crypto_larval_lookup(name=xts-aes-s390) alg=000003ff80178120
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_alg_get(alg.cra_name=xts(aes)) alg=000003ff80178120 alg.cra_refcnt=4
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_mod_get(alg.cra_name=xts(aes) alg=000003ff80178120 alg.cra_driver_name=xts-aes-s390 alg.cra_module.name=aes_s390)
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_alg_mod_lookup(name=xts(aes))
>> Feb 23 16:52:08 r35lp49 kernel: ->crypto_larval_lookup(name=xts(aes))
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_larval_lookup calling crypto_alg_lookup()
>> Feb 23 16:52:08 r35lp49 kernel: ->__crypto_alg_lookup(name=xts(aes))
>> Feb 23 16:52:08 r35lp49 kernel: <-__crypto_alg_lookup(name=xts(aes)) alg=          (null)
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_larval_lookup calling request_module(crypto-xts(aes))
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_larval_lookup calling crypto_alg_lookup(xts(aes))
>> Feb 23 16:52:08 r35lp49 kernel: ->__crypto_alg_lookup(name=xts(aes))
>> Feb 23 16:52:08 r35lp49 kernel: <-__crypto_alg_lookup(name=xts(aes)) alg=          (null)
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_larval_lookup calling crypto_larval_add(xts(aes))
>> Feb 23 16:52:08 r35lp49 kernel: ->__crypto_alg_lookup(name=xts(aes))
>> Feb 23 16:52:08 r35lp49 kernel: <-__crypto_alg_lookup(name=xts(aes)) alg=          (null)
>> Feb 23 16:52:08 r35lp49 kernel: <-crypto_larval_lookup(name=xts(aes)) alg=00000000b92d48e8
>> Feb 23 16:52:08 r35lp49 kernel:   cryptomgr_notify(data=00000000b92d48e8)
>> Feb 23 16:52:08 r35lp49 kernel:   cryptomgr_schedule_probe(larval=00000000b92d48e8 larval.alg=00000000b92d48e8)
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_alg_get(alg.cra_name=xts(aes)) alg=00000000b92d48e8 alg.cra_refcnt=3
>> Feb 23 16:52:08 r35lp49 kernel: ->cryptomgr_probe(data=00000000b8b5d698 param.larval=00000000b92d48e8 param.larval.alg=00000000b92d48e8)
>> Feb 23 16:52:08 r35lp49 kernel: ->__crypto_lookup_template(xts)
>> Feb 23 16:52:08 r35lp49 kernel: <-__crypto_lookup_template() tmpl=0000000000f2dc00
>> Feb 23 16:52:08 r35lp49 kernel:   cryptomgr_probe(data=00000000b8b5d698) tmpl=0000000000f2dc00 tmpl.create=00000000006e00b8 err=-11
>> Feb 23 16:52:08 r35lp49 kernel: ->create(tmpl.name=xts)
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_alg_mod_lookup(name=aes)
>> Feb 23 16:52:08 r35lp49 kernel: ->crypto_larval_lookup(name=aes)
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_larval_lookup calling crypto_alg_lookup()
>> Feb 23 16:52:08 r35lp49 kernel: ->__crypto_alg_lookup(name=aes)
>> Feb 23 16:52:08 r35lp49 kernel: <-__crypto_alg_lookup(name=aes) alg=          (null)
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_larval_lookup calling request_module(crypto-aes)
>> Feb 23 16:52:08 r35lp49 kernel:   crypto_larval_lookup calling request_module(crypto-aes-all)
>> --- modprobe aes_s390 hang ---
>>
>> regards H.Freudenberger
>>
> Here are the type and mask values:
>
> ...
> Feb 24 09:28:10 r35lp49 kernel: ->crypto_larval_lookup(name=aes,type=0x00000405,mask=0x0000248c)
> Feb 24 09:28:10 r35lp49 kernel:   crypto_larval_lookup calling crypto_alg_lookup(aes,0x00000405,0x0000248c)
> Feb 24 09:28:10 r35lp49 kernel: ->__crypto_alg_lookup(name=aes)
> Feb 24 09:28:10 r35lp49 kernel: <-__crypto_alg_lookup(name=aes) alg=          (null)
> Feb 24 09:28:10 r35lp49 kernel:   crypto_larval_lookup calling request_module(crypto-aes)
> Feb 24 09:28:10 r35lp49 kernel:   crypto_larval_lookup calling request_module(crypto-aes-all)
>
> type=0x00000405 = CRYPTO_ALG_TESTED, CRYPTO_ALG_TYPE_SKCIPHER
> mask=0x0000248c = CRYPTO_ALG_INTERNAL, CRYPTO_ALG_TESTED, CRYPTO_ALG_ASYNC, CRYPTO_ALG_TYPE_BLKCIPHER_MASK
>
I catched it: Thanks Herbert for your hint. The aes algorith registers with:
  .cra_flags = CRYPTO_ALG_TYPE_CIPHER |CRYPTO_ALG_NEED_FALLBACK
so later at __crypto_alg_lookup(aes, 0x0405, 0x248c)
this alg is not choosen because the check
  if ((q->cra_flags ^ type) & mask)
is true q->cra_flags = 0x0501 ^ 0x0405 & 0x248x => 0x0004

@Martin, I'll commit a patch asap.

Thanks for your help :-)

regards, H.Freudenberger
