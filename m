Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF25EC43334
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Jul 2022 15:18:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236725AbiGMPSx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Jul 2022 11:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236820AbiGMPSw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Jul 2022 11:18:52 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC551BEB4;
        Wed, 13 Jul 2022 08:18:50 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26DFAtMO020938;
        Wed, 13 Jul 2022 15:18:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : cc : subject : reply-to : in-reply-to : references :
 message-id : content-type : content-transfer-encoding; s=pp1;
 bh=JpSP+Mrde1nC1K5f41hIiwAFNPS3aOa6wLy84bh2DGE=;
 b=kXaiRWVK8aTNWVtki4MAF6iXPdzgt+9s3HeQ80srtSGhtp1Jz7zP5R+5DWHeTvCq2e7Z
 /L39MmcUvrwS5zBzLIPw1sT1Bg1/r/92kzEE0WvwDJ7rgyBSS7hJuEucJsFL4PD/O77k
 UnuTojHKKZ1jJ7+8oh7mt+Q5BWVouhu08Z+E3uP8x3MrpPzTq/gT/Efj4m3GEomHdYmv
 4I7IMn+yigyaGZyYGJdc+wj0r9CFOdqnqGcQaFSqBP723V1ZcAG7cDHW2lSuBRoyvfW5
 1dC2dJUwPXKvNmG7N6R8LI7oTH8QLpupf6I7PsOgNIBR5hOXmzsQlrGOzA4llEJwWHXu bg== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ha02xsd2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 15:18:49 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26DF8l5x020732;
        Wed, 13 Jul 2022 15:18:48 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma02dal.us.ibm.com with ESMTP id 3h9am4rcpe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 15:18:48 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26DFIlo161669712
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jul 2022 15:18:47 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E6EAB2067;
        Wed, 13 Jul 2022 15:18:47 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 463B2B2064;
        Wed, 13 Jul 2022 15:18:47 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jul 2022 15:18:47 +0000 (GMT)
MIME-Version: 1.0
Date:   Wed, 13 Jul 2022 17:18:47 +0200
From:   Harald Freudenberger <freude@linux.ibm.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux390-list@tuxmaker.boeblingen.de.ibm.com,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        jchrist@linux.ibm.com, dengler@linux.ibm.com
Subject: Re: [PATCH] s390/archrandom: remove CPACF trng invocations in irq
 context
Reply-To: freude@linux.ibm.com
In-Reply-To: <Ys7NMKkrELPT3T6H@zx2c4.com>
References: <20220713131721.257907-1-freude@linux.ibm.com>
 <Ys7NMKkrELPT3T6H@zx2c4.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <38033968bc22cf97427109be0df243e1@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zxifmqE_fkxnvN4kA9jcUrEx_UsR5467
X-Proofpoint-ORIG-GUID: zxifmqE_fkxnvN4kA9jcUrEx_UsR5467
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-13_04,2022-07-13_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 mlxscore=0 priorityscore=1501 adultscore=0 phishscore=0
 bulkscore=0 clxscore=1015 spamscore=0 mlxlogscore=612 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207130059
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2022-07-13 15:48, Jason A. Donenfeld wrote:
> Hi Harald,
> 
> On Wed, Jul 13, 2022 at 03:17:21PM +0200, Harald Freudenberger wrote:
>> This patch slightly reworks the s390 arch_get_random_seed_{int,long}
>> implementation: Make sure the CPACF trng instruction is never
>> called in any interrupt context. This is done by adding an
>> additional condition in_task().
>> 
>> Justification:
>> 
>> There are some constrains to satisfy for the invocation of the
>> arch_get_random_seed_{int,long}() functions:
>> - They should provide good random data during kernel initialization.
>> - They should not be called in interrupt context as the TRNG
>>   instruction is relatively heavy weight and may for example
>>   make some network loads cause to timeout and buck.
>> 
>> However, it was not clear what kind of interrupt context is exactly
>> encountered during kernel init or network traffic eventually calling
>> arch_get_random_seed_long().
>> 
>> After some days of investigations it is clear that the s390
>> start_kernel function is not running in any interrupt context and
>> so the trng is called:
>> 
>> Jul 11 18:33:39 t35lp54 kernel:  [<00000001064e90ca>] 
>> arch_get_random_seed_long.part.0+0x32/0x70
>> Jul 11 18:33:39 t35lp54 kernel:  [<000000010715f246>] 
>> random_init+0xf6/0x238
>> Jul 11 18:33:39 t35lp54 kernel:  [<000000010712545c>] 
>> start_kernel+0x4a4/0x628
>> Jul 11 18:33:39 t35lp54 kernel:  [<000000010590402a>] 
>> startup_continue+0x2a/0x40
>> 
>> The condition in_task() is true and the CPACF trng provides random 
>> data
>> during kernel startup.
>> 
>> The network traffic however, is more difficult. A typical call stack
>> looks like this:
>> 
>> Jul 06 17:37:07 t35lp54 kernel:  [<000000008b5600fc>] 
>> extract_entropy.constprop.0+0x23c/0x240
>> Jul 06 17:37:07 t35lp54 kernel:  [<000000008b560136>] 
>> crng_reseed+0x36/0xd8
>> Jul 06 17:37:07 t35lp54 kernel:  [<000000008b5604b8>] 
>> crng_make_state+0x78/0x340
>> Jul 06 17:37:07 t35lp54 kernel:  [<000000008b5607e0>] 
>> _get_random_bytes+0x60/0xf8
>> Jul 06 17:37:07 t35lp54 kernel:  [<000000008b56108a>] 
>> get_random_u32+0xda/0x248
>> Jul 06 17:37:07 t35lp54 kernel:  [<000000008aefe7a8>] 
>> kfence_guarded_alloc+0x48/0x4b8
>> Jul 06 17:37:07 t35lp54 kernel:  [<000000008aeff35e>] 
>> __kfence_alloc+0x18e/0x1b8
>> Jul 06 17:37:07 t35lp54 kernel:  [<000000008aef7f10>] 
>> __kmalloc_node_track_caller+0x368/0x4d8
>> Jul 06 17:37:07 t35lp54 kernel:  [<000000008b611eac>] 
>> kmalloc_reserve+0x44/0xa0
>> Jul 06 17:37:07 t35lp54 kernel:  [<000000008b611f98>] 
>> __alloc_skb+0x90/0x178
>> Jul 06 17:37:07 t35lp54 kernel:  [<000000008b6120dc>] 
>> __napi_alloc_skb+0x5c/0x118
>> Jul 06 17:37:07 t35lp54 kernel:  [<000000008b8f06b4>] 
>> qeth_extract_skb+0x13c/0x680
>> Jul 06 17:37:07 t35lp54 kernel:  [<000000008b8f6526>] 
>> qeth_poll+0x256/0x3f8
>> Jul 06 17:37:07 t35lp54 kernel:  [<000000008b63d76e>] 
>> __napi_poll.constprop.0+0x46/0x2f8
>> Jul 06 17:37:07 t35lp54 kernel:  [<000000008b63dbec>] 
>> net_rx_action+0x1cc/0x408
>> Jul 06 17:37:07 t35lp54 kernel:  [<000000008b937302>] 
>> __do_softirq+0x132/0x6b0
>> Jul 06 17:37:07 t35lp54 kernel:  [<000000008abf46ce>] 
>> __irq_exit_rcu+0x13e/0x170
>> Jul 06 17:37:07 t35lp54 kernel:  [<000000008abf531a>] 
>> irq_exit_rcu+0x22/0x50
>> Jul 06 17:37:07 t35lp54 kernel:  [<000000008b922506>] 
>> do_io_irq+0xe6/0x198
>> Jul 06 17:37:07 t35lp54 kernel:  [<000000008b935826>] 
>> io_int_handler+0xd6/0x110
>> Jul 06 17:37:07 t35lp54 kernel:  [<000000008b9358a6>] 
>> psw_idle_exit+0x0/0xa
>> Jul 06 17:37:07 t35lp54 kernel: ([<000000008ab9c59a>] 
>> arch_cpu_idle+0x52/0xe0)
>> Jul 06 17:37:07 t35lp54 kernel:  [<000000008b933cfe>] 
>> default_idle_call+0x6e/0xd0
>> Jul 06 17:37:07 t35lp54 kernel:  [<000000008ac59f4e>] 
>> do_idle+0xf6/0x1b0
>> Jul 06 17:37:07 t35lp54 kernel:  [<000000008ac5a28e>] 
>> cpu_startup_entry+0x36/0x40
>> Jul 06 17:37:07 t35lp54 kernel:  [<000000008abb0d90>] 
>> smp_start_secondary+0x148/0x158
>> Jul 06 17:37:07 t35lp54 kernel:  [<000000008b935b9e>] 
>> restart_int_handler+0x6e/0x90
>> 
>> which confirms that the call is in softirq context. So in_task() 
>> covers exactly
>> the cases where we want to have CPACF trng called: not in nmi, not in 
>> hard irq,
>> not in soft irq but in normal task context and during kernel init.
> 
> Reluctantly,
> 
>    Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>
> 
> I'll let you know if I ever get rid of or optimize the call from
> kfence_guarded_alloc() so that maybe there's a chance of reverting 
> this.
> 
> One small unimportant nit:
> 
>>  	if (static_branch_likely(&s390_arch_random_available)) {
>> -		cpacf_trng(NULL, 0, (u8 *)v, sizeof(*v));
>> -		atomic64_add(sizeof(*v), &s390_arch_random_counter);
>> -		return true;
>> +		if (in_task()) {
> 
> You can avoid a level of indentation by making this:
> 
>     if (static_branch_likely(&s390_arch_random_available) && in_task())
> 
> But not my code so doesn't really matter to me. So have my Ack above 
> and
> I'll stop being nitpicky :).
> 
> Jason

Thanks for your ack. I'll do the improvement you suggested and then push
this patch into the s390 subsystem (with cc: stable).

... and then let's see if we can establish something like
arch_get_random_seed_ bytes() and a way to invoke the trng in interrupt
context without the network guys complaining.

regards
Harald Freudenberger
