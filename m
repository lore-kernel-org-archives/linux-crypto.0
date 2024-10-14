Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770641A7265;
	Mon, 14 Oct 2024 12:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728909555; cv=none; b=SO7J3O5CqpLD7paV1VE7FUvuyyAQD+DxuiN3SIftw+hd0qC72Q+6z/hQCZb5bww6pt1cgosVW0BiAnQ7aV8vjJHWKVPx6yqXVTwH4nzUeoA1KecQLmyyc11EykEaDfhBjNX8YqubZdk6FliHNYjQq+XsBB08gVZ6FftgU7e91xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728909555; c=relaxed/simple;
	bh=XZyY0KuM07YJInMFaM7Se7sFC7lQZa50ST7saN4/Alc=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=ZYuWC7/Q/I4ejlsRrlRS8ZOfsTSDqWeVcD2x7CfKTavyi0nw+EYqff5AD6EIXeLFUjc6u5TUpNfqG43D2Wl3X0B4MOZMhNOzs5dGWJRgJuQsO9KWKsukNMGryGGTFdBqe+/RFN7w3hwSuxaiKSP8OgjQtnLikENyUmG48fU360o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QWBH4902; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QWBH4902"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-20caea61132so24051415ad.2;
        Mon, 14 Oct 2024 05:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728909552; x=1729514352; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JrKFn42xuc1H7J8Te5llpeV6Qi1vNIgovxPBFsGJQa8=;
        b=QWBH4902/IVD69yEA+bkMQ1PdX97273HXZzEle7Alm6Ew2EC7eBtr99m9lzGJjGElD
         coZQ/otH5FG7Z52bKnRNe66wt1MfXZnumVOs+Ztz8xpsXVYWOn9eDBpy5p1FjZJUTSzn
         9FvkubWbNu3Ao+06mtER2qF5pPHvB2ahxME1AGxf7Vah/if1e2K8CFuBX0DZLUTA8gJE
         YS7FHAeUIJSzg+MvLX/QHACkHbN9UEpa+E8LOvfMETJF9FMpzxxGBpKjhTKz4jDLQSuN
         LyaHJbApGEWE7drRJ6DjMqgkCuN1HHZs+z6dbzc11VPjyb6pTq9f8QZCMIP1OE9wO2TO
         KXTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728909552; x=1729514352;
        h=references:message-id:date:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JrKFn42xuc1H7J8Te5llpeV6Qi1vNIgovxPBFsGJQa8=;
        b=iRonqHrSUbHA2gl0xYSM5aPPgwG37Or5dhVcAnszXYNpGbGvPhT43DqqbCldmPjFTr
         C06PmVR7XcYXrtP0uIXWwpudu4CyBW8JzWFxbWQsa9hSmiP8hcCO4lMIzkTZHd4OYhGi
         e/aGQlrH5QfmoiL1i3Up3cWdWwQoG8eoNrpZMFrpZ/Afkxlh8p+F7S5xuBykQCpk+Ep1
         iTSrDgMK5F3JbQS1//cHdlvzCKgVt6qJ8Iisv7Tuyy7JCaumO9ZsTN0L3q6FuXMRSKLx
         7Wsr7j/vdoPLVNTphxUY65Cf2stbT2P3hkC2VtQ28XQprofr/w6kc+1SqDaeR93SEVBH
         UjNQ==
X-Forwarded-Encrypted: i=1; AJvYcCVIuEB07/o6mKC6EEpDRSBpNETbXlQDw2tcBvRgTWC4dB006eR28rZuogObzb1cAiLhlIt3xMU5PV9UPLk=@vger.kernel.org, AJvYcCVu6eZo50WrzXmFLeJB/o0U4LN11SVZ+cmlXDIE52kAzCL8zFkvSSJsxmkEfu8bgBkr7v/7ltyrwUSaKsLw@vger.kernel.org
X-Gm-Message-State: AOJu0YwsDDLHSSw0n4c86SSm3cfOVetKVfnWkNFbYS1wiJDLPeeuo1qS
	Athmto/BoGQ6jCiTkxuSICqLUU7joT5vPqcFG2j9w/qtrY853quu98FDFQ==
X-Google-Smtp-Source: AGHT+IE+bM7+WY+9RLsixhECD+emhDXilhTCLtkjvV3sehkEtjOAqtlL8CRTc0dajOpGcaehvXLwtQ==
X-Received: by 2002:a17:902:f708:b0:20c:79bf:6793 with SMTP id d9443c01a7336-20cbb1a9697mr111971195ad.3.1728909551714;
        Mon, 14 Oct 2024 05:39:11 -0700 (PDT)
Received: from dw-tp ([171.76.85.106])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7ea748b036bsm3396987a12.0.2024.10.14.05.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2024 05:39:11 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Vishal Chourasia <vishalc@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, Naveen N Rao <naveen@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, Sourabh Jain <sourabhjain@linux.ibm.com>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: drivers/nx: Invalid wait context issue when rebooting
In-Reply-To: <ZwkbOJN5Jmjy_wkJ@linux.ibm.com>
Date: Mon, 14 Oct 2024 17:54:44 +0530
Message-ID: <87a5f6zxbn.fsf@gmail.com>
References: <ZwjjXJ5UtZ28FH6s@linux.ibm.com> <87wmif53iw.fsf@mail.lhotse> <ZwkbOJN5Jmjy_wkJ@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Vishal Chourasia <vishalc@linux.ibm.com> writes:

> On Fri, Oct 11, 2024 at 09:37:27PM +1100, Michael Ellerman wrote:
>> 
>> I don't see why of_reconfig_notifier_unregister() needs to be called
>> with the devdata_mutext held, but I haven't looked that closely at it.
>> 
>> So the change below might work.
>> 
>> cheers
>> 
>> diff --git a/drivers/crypto/nx/nx-common-pseries.c b/drivers/crypto/nx/nx-common-pseries.c
>> index 35f2d0d8507e..a2050c5fb11d 100644
>> --- a/drivers/crypto/nx/nx-common-pseries.c
>> +++ b/drivers/crypto/nx/nx-common-pseries.c
>> @@ -1122,10 +1122,11 @@ static void nx842_remove(struct vio_dev *viodev)
>>  
>>  	crypto_unregister_alg(&nx842_pseries_alg);
>>  
>> +	of_reconfig_notifier_unregister(&nx842_of_nb);
>> +
>>  	spin_lock_irqsave(&devdata_mutex, flags);
>>  	old_devdata = rcu_dereference_check(devdata,
>>  			lockdep_is_held(&devdata_mutex));
>> -	of_reconfig_notifier_unregister(&nx842_of_nb);
>>  	RCU_INIT_POINTER(devdata, NULL);
>>  	spin_unlock_irqrestore(&devdata_mutex, flags);
>>  	synchronize_rcu();
>> 
> With above changes, I see another similar bug, but what's strange is
> swapper does not hold any lock and still this bug is being triggered

Looking at the below stack, it looks like you discovered a new problem
after the above problem was fixed with the above changes.
(So maybe you could submit this fix along with [1])
Also looking at the history of changes, seems the above problem always
existed. Not sure why it wasn't caught earlier then?

[1]: https://lore.kernel.org/linuxppc-dev/ZwyqD-w5hEhrnqTB@linux.ibm.com/T/#u

I am not much aware of the below code paths. Nor it is evident from the
stack on why "Invalid wait context". Maybe you can give git bisect a try
for below issue (or can also wait for someone to comment on below stack).
(But you might have to keep the nx-common-pseries driver disabled for git bisect to work). 

>
> =============================
> [ BUG: Invalid wait context ]
> 6.12.0-rc2-fix-invalid-wait-context-00222-g7d2910da7039-dirty #84 Not tainted
> -----------------------------
> swapper/2/0 is trying to lock:
> c000000004062128 (&xibm->lock){....}-{3:3}, at: xive_spapr_put_ipi+0xb8/0x120
> other info that might help us debug this:
> context-{2:2}
> no locks held by swapper/2/0.
> stack backtrace:
> CPU: 2 UID: 0 PID: 0 Comm: swapper/2 Not tainted 6.12.0-rc2-fix-invalid-wait-context-00222-g7d2910da7039-dirty #84
> Hardware name: IBM,9080-HEX POWER10 (architected) 0x800200 0xf000006 of:IBM,FW1060.00 (NH1060_012) hv:phyp pSeries
> Call Trace:
> [c000000004ac3420] [c00000000130d2e4] dump_stack_lvl+0xc8/0x130 (unreliable)
> [c000000004ac3460] [c000000000312ca8] __lock_acquire+0xb68/0xf00
> [c000000004ac3570] [c000000000313130] lock_acquire.part.0+0xf0/0x2a0
> [c000000004ac3690] [c0000000013955b8] _raw_spin_lock_irqsave+0x78/0x130
> kexec: waiting for cpu 2 (physical 2) to enter 2 state
> [c000000004ac36d0] [c000000000194798] xive_spapr_put_ipi+0xb8/0x120
> [c000000004ac3710] [c000000001383728] xive_cleanup_cpu_ipi+0xc8/0xf0
> [c000000004ac3750] [c0000000013837f4] xive_teardown_cpu+0xa4/0x100
> [c000000004ac3780] [c0000000001d2cc4] pseries_kexec_cpu_down+0x54/0x1e0
> [c000000004ac3800] [c000000000213674] kexec_smp_down+0x124/0x1f0
> [c000000004ac3890] [c0000000003c9ddc] __flush_smp_call_function_queue+0x28c/0xad0
> [c000000004ac3950] [c00000000005fb64] smp_ipi_demux_relaxed+0xe4/0xf0
> [c000000004ac3990] [c0000000000593d8] doorbell_exception+0x108/0x2f0
> [c000000004ac3a20] [c00000000000a26c] doorbell_super_common_virt+0x28c/0x290
> --- interrupt: a00 at plpar_hcall_norets_notrace+0x18/0x2c
> NIP:  c0000000001bee18 LR: c0000000013867a8 CTR: 0000000000000000
> REGS: c000000004ac3a50 TRAP: 0a00   Not tainted  (6.12.0-rc2-fix-invalid-wait-context-00222-g7d2910da7039-dirty)
> MSR:  800000000280b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 22000242  XER: 00000001
> CFAR: 0000000000000000 IRQMASK: 0
> GPR00: 0000000000000000 c000000004ac3cf0 c000000001e37600 0000000000000000
> GPR04: 0000000000000000 0000000000000000 0001dc4f97750361 0000000000010000
> GPR08: 00000000000000c0 0000000000000080 0001dc4f97750554 0000000000000080
> GPR12: 0000000000000000 c0000007fffee480 0000000000000000 0000000000000000
> GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
> GPR20: 0000000000000000 c000000002ebf778 0000000000000000 00000043a215d824
> GPR24: 0000000000000000 c000000000ec0f80 c000000002ebf778 0000000000000000
> GPR28: 0000000000000000 0000000000000001 c0000000021a2300 c0000000021a2308
> NIP [c0000000001bee18] plpar_hcall_norets_notrace+0x18/0x2c
> LR [c0000000013867a8] check_and_cede_processor+0x48/0x80
> --- interrupt: a00
> [c000000004ac3cf0] [0000000000982538] 0x982538 (unreliable)
> [c000000004ac3d50] [c000000001386874] dedicated_cede_loop+0x94/0x1a0
> [c000000004ac3da0] [c00000000138584c] cpuidle_enter_state+0x10c/0x8a8
> [c000000004ac3e50] [c000000000ec0f80] cpuidle_enter+0x50/0x80
> [c000000004ac3e90] [c0000000002ba9c8] call_cpuidle+0x48/0xa0
> [c000000004ac3eb0] [c0000000002cec54] cpuidle_idle_call+0x164/0x250
> [c000000004ac3f00] [c0000000002cee74] do_idle+0x134/0x1d0
> [c000000004ac3f50] [c0000000002cf34c] cpu_startup_entry+0x4c/0x50
> [c000000004ac3f80] [c0000000000607d0] start_secondary+0x280/0x2b0
> [c000000004ac3fe0] [c00000000000e058] start_secondary_prolog+0x10/0x14

-ritesh
