Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBE63C1F41
	for <linux-crypto@vger.kernel.org>; Tue,  1 Sep 2026 08:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788252345; cv=none; b=JU/MKbUM5jwbmL56jEWXblB72y3mwS3OI8CyI8GXLqomCC/K1jUHkJbq5xNhy+Xm00phmSOiQoiLZG5iUFyMLzbtiRSzcBEhX1DWiiVrCIbxVLttUMR82htjWdC0MHqHnL1+mMZbasc6PcD8Q91kasBePR3U3d20jEgvH7EwKLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788252345; c=relaxed/simple;
	bh=NqTxINwb1HrwNQ1C3UPbPXHe4X/ixOFkMb9l+HizzJQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=qhhTKjzKEuHpQYwMWbaiUXazjhWhX9DuLRVnvuy0AZUxIv2hWNxSj7s8qWJEYEUQrRwY/JSswuXUrD6nWuzy03PeJK18uhwlYCyCwdn2oOUika68bZzAzCJW92//vL3TZETY1rQ3q5gBeER9YtBekVuLpU+DDNajBOOXTTK8vms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=il1m+6jp; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=DJf9/DG6; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="il1m+6jp";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="DJf9/DG6"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68179PXt2321959
	for <linux-crypto@vger.kernel.org>; Tue, 1 Sep 2026 08:45:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	qVQ+V8VOF2NgD3rXPJBaSCvYCX8htWETCdnhtAXLvX4=; b=il1m+6jpoWXHfsyE
	8ru/Vz85ws9/hPknCOf3Dxx72NtEeETLpLfwtjP0HP3tmlusXsXnO/933vHeKNH0
	5TogAV4bthfUAJGSwzX6LML6BzYGh1s97eIvaRQl26c61N9TEar414zH26Pi9bU4
	WhE9lHlPmW1kkBApl/zWu14o01Mo513Vf/fVQyBRp3Qirg7LgpeYRmwlpQsR7/RH
	Shv83iJrt4GQUZX2kXaDwH0vduYscVnjNxUbVqmc6pk6/Fgn9bi9IznaGivvHVlF
	GpuRV+9waU8NwyWPt/MAteDP1Bqs8a5qTr4yVxk4PrAQPC3zXKWFR8zzwZxE2oHn
	9yaAew==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gdfchb1bc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 01 Sep 2026 08:45:40 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-395543dc382so6448078a91.0
        for <linux-crypto@vger.kernel.org>; Tue, 01 Sep 2026 01:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788252339; x=1788857139; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=qVQ+V8VOF2NgD3rXPJBaSCvYCX8htWETCdnhtAXLvX4=;
        b=DJf9/DG6k8b2RDLdC0WfxC5RQiTIfOOEVZB04vGMruz1FRGdX88lhJ47gp//aYdJfp
         XdZvGdnVQHB4kv87znkxgyQx4cTd385fSjR/vUntZH/5t9dXkgalkMp6CBMjH86ZA+EC
         zOtHWye/kaIhDPGM4N7egGrSzl2QACfNSZKY+xSo9N/R9y8PdcMcfp7zL9HlT9OnygM2
         huoUerE6MHnAuQdMWTDwMIKLw5HsBz5qhlJ4TcdEqgPs45xAmIq0BIAahtbua7kr3JTL
         xvJNNHDQcf20Kth3nylkTv4DCJKhkBhNht5FyM2RGZIPrhYurPwZUh9j51Z39EnkCTkG
         Y/8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788252339; x=1788857139;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qVQ+V8VOF2NgD3rXPJBaSCvYCX8htWETCdnhtAXLvX4=;
        b=tYhqIDtF9a/c40E7FE5VFXOGZPVPWappW45y3sXT3ob6bTmCmdJtq+zZ4VqTyr4E21
         81Y+hmxbLLImRLe3SAegH+4cnc4auoHszbrFAkyY0r0VU2bsIpIQbJPtitPH768TBibP
         uVhEqO/2cjX4WLjwGG6ktPFw+3D9w/QDsW1Uzd2AoqtHNihvnD3bch7aZ5PHyzzjhndg
         YwdqCj6VX8dysk+MQlV4TCujt3pcqpOtK+NxpH+ojPJsNDWKwQe/FeGZ+J9vtYITZnlT
         f4IHDsOjovomBU6McJvzJ2PceNHxylExHQmOXulA3zEtmhdyDgxsq4X4QCwK6TabDEX3
         ntQw==
X-Forwarded-Encrypted: i=1; AKwUvBwLzq50ZpwarmAzHfsVJLMq7tBOKP4079B0y4MYE2O7UCXQDtpKYa2dA/Wg+jphCV2a9u5+RG0S95lMWzg=@vger.kernel.org
X-Gm-Message-State: AFuF++lB0ldtxfsFLZZz5EsbqBnQPaj0wn699MpLpDLLqHIVYkEpoeel
	FTyS0QuB6yw8Lp3B58Pz+wnnHMsCvqCxLcZRJx2egvyCWPkvpm2jjoEsG8xACibU50TkPH3YCYC
	iCtZIH4zckNXebbu71bVqZoaMO/ckJI7KE3xmnyGWFjBKV3G1LUqB1Y7TvtMTPU9cMG4=
X-Gm-Gg: AYBFou2HZx77URkItc+n68LimAs3TC7+ixbXtoFC6aUw9OgWqLI4TCRTbpxnB/tg1vr
	9WTB7HU7U3u0u6BO4T2gaO6Lg2PoCBg4yJnDpicnlk+gJuxE0ZYtxGCP06C/VDTUImod/EzmZyr
	MO/gyIxM0f59Hto0JNaf5h7FI8PTtan9i6D39UEwwu0b65R/uy7x1yh6fPIB4Fjbzyk64ppDBQY
	kVo0Vhg72extxjWLCdzMx35oejFE5s5wnhvYIuy+tyeN6nWUQjbDzqdM4R6yQ7WqZUsoJBdUIAG
	doPA571HAIhK6QoHnML1B6r8tZUVlk98YDEQC7AgFhpBkfnV6zuCS59epRmXrC/U+NaTKv6nDxf
	CsrlARJwP9Bs7Fqcrqv1UZ7xNaVhSkZciP5xS4w+7MaYSMZXLsi4AWH7U
X-Received: by 2002:a17:90b:3ec5:b0:398:e6b6:acc1 with SMTP id 98e67ed59e1d1-39907d6563cmr9127844a91.15.1788252339069;
        Tue, 01 Sep 2026 01:45:39 -0700 (PDT)
X-Received: by 2002:a17:90b:3ec5:b0:398:e6b6:acc1 with SMTP id 98e67ed59e1d1-39907d6563cmr9127787a91.15.1788252338477;
        Tue, 01 Sep 2026 01:45:38 -0700 (PDT)
Received: from [10.110.34.210] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-32e5ce04233sm2901973eec.22.2026.09.01.01.45.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 01:45:35 -0700 (PDT)
Message-ID: <d7ce6c39-d9c0-4746-ba18-1c37a929819b@oss.qualcomm.com>
Date: Tue, 1 Sep 2026 16:45:19 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 00/11] FBE virtualization: inline encryption for
 virtio-blk guests
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: axboe@kernel.dk, mst@redhat.com, jasowangio@gmail.com,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-scsi@vger.kernel.org, virtualization@lists.linux.dev,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        neeraj.soni@oss.qualcomm.com, gaurav.kashyap@oss.qualcomm.com,
        mani@kernel.org, andersson@kernel.org, konradybcio@kernel.org,
        bvanassche@acm.org, alim.akhtar@samsung.com, avri.altman@sandisk.com,
        stefanha@redhat.com, pbonzini@redhat.com, eperezma@redhat.com,
        xuanzhuo@linux.alibaba.com, linux-kernel@vger.kernel.org
References: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
 <20260827184219.GB2137493@google.com>
 <d81e347e-8ca7-40a1-a428-5bce6f0d4b02@oss.qualcomm.com>
 <20260831210759.GE86114@quark>
 <ca838905-f0f8-4f0a-96aa-2bc05ab6c0a7@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <ca838905-f0f8-4f0a-96aa-2bc05ab6c0a7@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: 6wl0SbhcyvdJfWX_yIhqM-PWue7EeiEO
X-Authority-Analysis: v=2.4 cv=G9Ms1dk5 c=1 sm=1 tr=0 ts=6a9690b4 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=urKErBX1ud2WTkT0OPcA:9 a=QEXdDO2ut3YA:10 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-GUID: 6wl0SbhcyvdJfWX_yIhqM-PWue7EeiEO
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA3NyBTYWx0ZWRfX2QnPvxSSfdqt
 EUwNPGlDpxt78u2uApzkx3ai8XoL77r6+NErZ0RdhoCyXX8bgASxIv4T0Ep4uh6H0kJc7C2GnEY
 pcs2fgYgluF00l+Y2hFBYTOlKkCzl/Q=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA3NyBTYWx0ZWRfXy5IhyoHH5/NJ
 /IEdxyt9UzCL9q2xkdTuIlt62+aKVIF8+GdyqvPkYhM1iU5NCNIq2zpfKLo7kA0W7FMV3On3CXY
 dIRgFdktEV4c3HJi2gEhn89bdsNXfGAeiJbmfp30DgPAnl2+CHOA+/HDkshdWFp4TOaxIeGmuIC
 pfb5ThFhqV0bMd93YkuQ8gN1qLcXK6Wht9+gnTMgMdih6QQei8PVCbyF4kUgl7WFhAlWUjAKhl3
 VRw9m5KzFsjZ1KcUmJVfPdIOM0mGstmO4XqsAZJaCWD8IDAUoOreuNozt/f9mqLt6OSiBmBj2AL
 gl4US2CdDRuz4O9Rr9BFkwpWkD9LMMJI1WZdH8kDFwTN/QHaKnnL5t3LnwVAgwsePybl+k1r7WW
 yH1vuOAM4ewzRtYrEPVhKQK/YWWYpRfTJKNcBEnpFq2bB9AKTlija3eeorvrso8ekvFbTFrDv3A
 qtj7FXDsB4O+5ACL4+w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_02,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 impostorscore=0 spamscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609010077



On 9/1/2026 4:22 PM, Linlin Zhang wrote:
> 
> 
> On 9/1/2026 5:07 AM, Eric Biggers wrote:
>> On Fri, Aug 28, 2026 at 11:37:57PM +0800, Linlin Zhang wrote:
>>> Thanks for your comments!
>>>
>>> Not making virtio-blk itself support key programming and eviction is
>>> something done deliberately. Based on that HW-wrapped key management
>>> operations are also handled in the out-of-band path.
>>>
>>> There are bellow 2 approaches I investigated to let virtio-blk programming
>>> the key.
>>>
>>>   1. virtio_blk implements blk_crypto_ll_ops interfaces, including program
>>>      key and evict key interfaces.(Same to 'the virtio-blk interface standardized
>>>      blk_crypto_ll_ops requests' mentioned by Stefan in the virtio SPEC thread)
>>>
>>>      The guest's block crypto profile manages the keyslot in virtual slot
>>>      format in this scenario.
>>>
>>>       - block crypto key and virt_slot index it passed to the hypervisor's
>>>        (EL2) device emulation (QEMU, using QEMU in the following) which
>>>        runs in userspace of the host. Besides of transferring the virtual
>>>        slot to the physical slot, a programming block crypto key UAPI need
>>>        be added. Follow current blk-crypto design, it may be like
>>>        BLKCRYPTOGENERATEKEY. I thought this results in a security risk that
>>>        allows userspace process a key into a key slot.
>>>
>>>      - For key eviction, it's similar to above key programming handling, also
>>>        need a key eviction in blk IOCTLs, but leads to the security risk
>>>        that allow userspace client to evict a key in a key slot.
>>>
>>>     virt_slot, DUN and DUSize is appended to virtblk request during crypto
>>>     I/O.
>>>
>>>   2. virtio_blk implements blk_crypto_ll_ops interfaces, excluding program
>>>      key and evict key interfaces.
>>>
>>>      The guest's block crypto profile doesn't manage keyslot for the guest,
>>>      the host's block crypto profile manages keyslot for both the guest and
>>>      the host. The trigger of key programming operation is moved from the
>>>      guest to the host.
>>>
>>>        - The whole block crypto key (key size, key bytes, blk_crypto_config)
>>>          and DUN are appended to the virtblk request during IO, a little
>>>          high payload.
>>>
>>>          The backend parses the crypto message in the virtio queue and
>>>          construct a block crypto key and DUN for the bio_crypto_ctx
>>>          set to the BIO. So that the IO flow in the host can program
>>>          the key. 
>>>
>>>          The question is that the blk-crypto-profile distinguishs the
>>>          block crypto key via the key's address. But the host has
>>>          different key addresses for the programming and eviction key
>>>          operations of the same block crypto key from GVM, because the
>>>          key is re-constructed in the host for the key program and
>>>          eviction operations. 
>>>
>>>          To fix it, the approach I thought is maintaining a new key
>>>          hash table in the backend, and comparing the block crypto key
>>>          content and DUN parsed from virtio queue with that in the key
>>>          hash table. 
>>>          My major concern is that this need keep the keys synchronization
>>>          b/w this new hash table and the blk-crypto-profile's hash table
>>>          carefully, avoiding that key is still present in the
>>>          blk-crypto-profile's hash table, but removed in backend hash
>>>          table. Another point is that the whole block crypto key and
>>>          DUN are appended into virtio block request per crypto I/O.
>>>
>>>        - For key eviction, adding a key eviction in blk IOCTLs allows
>>>          userspace client to evict a key in a key slot. I thought this
>>>          is a security concern.
>>>
>>>
>>>      This option doesn't need map virt_slot to physical one.
>>>
>>>
>>> Taking all the above into account, I made a compromise to implement
>>> blk_crypto_ll_ops interfaces in a out-of-band path, which lets the virtio
>>> blk only need focus on the data path. I agree that it is complex than
>>> the second option mentioned in the above, but small payload (only
>>> virt_slot, DUN, DUSize) in the virtio block request and no security
>>> risk of key eviction from userspace.
>>>
>>>
>>> I would like to hear your thoughts about the above and am appreciated
>>> if you could share your insights about the design of inline
>>> encryption in virtio block.
>>
>> Well, the way it should work is that each virtio-blk device should have
>> its own set of *virtual* keyslots on the host side.  From the guest's
>> perspective it would act very similarly to UFS / eMMC inline encryption,
>> and it would be easy to integrate into the existing stack.
>>
>> Then to process encrypted I/O, the host would use the keyslot number in
>> the I/O to look up the blk_crypto_key it previously saved, and issue I/O
>> using that key (using bio_crypt_set_ctx()).  The existing keyslot
>> management logic in the block layer would allocate or wait for a
>> physical keyslot as needed, so it should just work.
>>
>> Eviction would similarly be passed through to blk_crypto_evict_key().
>>
>> Note that with this design, there would be no static partitioning of the
>> physical keyslots.  The host would just allocate and release them as
>> needed, similar to memory allocation.  The total number of virtual
>> keyslots could be greater than the number of physical keyslots.
>>
>> This design would also work with hardware-wrapped keys.
>>
>> The hardest part is still the UAPIs for the VMM to do what it needs to
>> do (assuming that it even needs to support physical inline encryption
>> hardware at all, and not simply use the AES acceleration on the CPU),
>> but that is the case with any of the proposals.
>>
>> - Eric
> 
> Thanks for your insights and clarification.
> 
> This is a very clear architecture for virtio-blk inline encryption support
> and is quite similar to what I referred to as approach 1, with a few notable
> differences:
> 
>   - The host maintains a set of virtual keyslots per virtio-blk device.
>   - Physical keyslots are not statically partitioned.
>   - The virtual-to-physical slot mapping is managed as part of the virtio-blk
>     device implementation rather than being tied to a VM-wide slot table.
> 
> With this design, I believe there would be two VM exits associated with
> encrypted I/O:
>   1. Key programming
>      Before encrypted I/O can be submitted, the guest needs to program a key
>      into a virtual keyslot:
>      
>      Guest virtio-blk driver
>          -> VM exit
>          -> virtio-blk backend (e.g. QEMU)
>          -> ioctl
>          -> host virtio-blk proxy driver
>             (stores the blk_crypto_key in a virtual keyslot)
> 
>   2. Encrypted I/O submission
>      The I/O request carries the virtual keyslot number and DUN:
> 
>      Guest virtio-blk driver
>         -> VM exit
>         -> virtio-blk backend (e.g. QEMU)
>         -> ioctl
>         -> host virtio-blk proxy driver
>            (looks up the blk_crypto_key associated with the virtual keyslot
>             and submits I/O using bio_crypt_set_ctx())

Supplementation.
This may be a potential security concern. The host virtio-blk proxy driver exposes
API for key programming, the input parameters are blk_crypto key and virtual
slot. If a malicious program replace the key in a specific virtual slot between
key program call and I/O submission via this API, the data would be encrypted
by the unintentional key.

> 
> I have been wondering whether a model similar to the passthrough
> blk-crypto-profile used by certain dm targets could be applicable here.
> 
> In such a design, ownership of keyslot management would effectively and totally
> move to the host. The guest would no longer manage virtual keyslots, and the
> host block layer would continue using its existing keyslot manager to allocate,
> reuse, and evict physical keyslots as needed.
> 
> This corresponds to what I previously described as approach 2.
> With this approach, encrypted I/O would require only a single VM exit:
>   1. Encrypted I/O submission
>      The I/O request carries the blk_crypto_key and DUN:
> 
>      Guest virtio-blk driver
>         -> VM exit
>         -> virtio-blk backend (e.g. QEMU)
>         -> ioctl
>         -> host virtio-blk proxy driver
>            (receives the blk_crypto_key and DUN, then submits I/O using
>             bio_crypt_set_ctx())
> 
> Regardless of which approach is used, the host would still need to maintain a
> key lookup table so that the host blk-crypto layer consistently sees the same
> blk_crypto_key object for a guest key until that key is evicted.
> 
> Note that, the key table format is
>   - approach 1: <virtual_slot, blk_crypto_key>
>   - approach 2: <hash_id of blk_crypto_key, blk_crypto_key>
> 
> Therefore, if transferring blk_crypto_key material from the guest to the host
> (and from userspace to kernel space) is considered acceptable, I wonder whether
> approach 2 might be preferable because it avoids virtual keyslots entirely and
> reduces the encrypted I/O path to a single VM exit.
> 
> Do you see any major drawbacks with such an approach? In particular, do you
> think reducing the number of VM exits by eliminating virtual keyslots is a
> worthwhile direction for virtio-blk inline encryption support?
> 
> - Linlin

