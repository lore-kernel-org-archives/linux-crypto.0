Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C062357D19
	for <linux-crypto@vger.kernel.org>; Mon, 31 Aug 2026 06:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788157323; cv=none; b=OtvkGNI/2JnbS1OoqZl7spkj1N67A1kN0Y3N+j/pjBWLF8PR6Uy/8ckjriTZjrnVwyMsdugy2QjNVgq7e0x9nxnVgtWNAO3IKLF6gTj4Ah0vyiHGJCuPDVQT2xnDRc4KMpOjJXl5Ap6nPkT2VfaphcxBZFxaA7OPJuKv7cNE4B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788157323; c=relaxed/simple;
	bh=WqBC9k9dQo1Fkp8FeGnmJpcacq5DVytNnWXm1742Lso=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=mmDhy3Nf2EqBMgs7jQN0PaFCJSXkSBquzmVk6zHTpEPiDzwpRL0jel/PKp1NhWgqF3npUV7g4KFspxQ3PQzn7YMGC+AlKeuTQCTCPV7g0pr2aC2hhjoyiFBkltupPLSytROlZ9csvzsMcrlz6eUsSz5QsFfaqQL3bRtbSEi4/cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Kn1YWkQ+; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=CTXoUPlF; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Kn1YWkQ+";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="CTXoUPlF"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67V52VRn2680012
	for <linux-crypto@vger.kernel.org>; Mon, 31 Aug 2026 06:22:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	wcg0Ez9nJOyV/8LnbrobWqWP9ec96FQgJeXfFdTZe98=; b=Kn1YWkQ+vhRQHjuO
	SVI5IsM2hTE6k/B7tdf0xyH4PlNsXgYl0N7x5vnWCEca9O8XKKg3jahYZUWkPR0n
	+qeSVd8FRmIHiewURxfvjSJx+uB64pJtZrLrdWPHjCg9DpizkuocQjaFcrVAYkdA
	WDc0L3w92gEM5Q6XgPxrcAVACH75rTknrsWOyWoifZj6aMGpw+/JdPW8KpmmqdTR
	2DNyt5eb9xVa2A/rliKmaFuK9WT9pS/5fEYovg4utjnON5Xd8G3nJx79Paor08QO
	Y4IZqDQaCcKxlz8U8G4vQ1MSFmarnUr5FdbXlPv8RgNsz599hGjCmB4+7NR8x6nI
	mTa+6g==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gbqhwcvq2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 31 Aug 2026 06:22:00 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38e475f83a2so5482950a91.1
        for <linux-crypto@vger.kernel.org>; Sun, 30 Aug 2026 23:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788157320; x=1788762120; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wcg0Ez9nJOyV/8LnbrobWqWP9ec96FQgJeXfFdTZe98=;
        b=CTXoUPlFxDy5AjZY6a2DZj94A/vhfWRpXd7rGiup+u4Tc0zbU9uNwhexOwweSvyxPw
         2Zso9xODn7Yp80lPj8bZMMYTew5Q10i5omdUpQRrXlAtNQqSMlAAdR+Swko4rG3RennM
         tjZBgjEvcxAzZ3u8+Sq6H7FF7K5Ll4nCZji9S7FuIHyj06qvOGeV/kR1tbP5p90g8TZ/
         yx8aHBQGLq7SibJMxdi3CQPcBVKNWQVZRD3TWxvevGN0lmgoAoPPLXJ3V1B112u+IraR
         g46S8pzPTWVJvzmDM0bmrpcPR1QHEcgun1gjSGmGbyxNLPrFP3pQ0WHt94tGON4JuLeP
         4Iew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788157320; x=1788762120;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wcg0Ez9nJOyV/8LnbrobWqWP9ec96FQgJeXfFdTZe98=;
        b=TKyH+u5ahwbZih5dx6eg5Ddx+mhoTH5QK6CJX552Q4/dOJ84e/ORLDesn+XILSSZTT
         ICA70CSmfb6JUAokDRepVMb47T081Rfty2pzY+biChJ6Aobrq3uSKGIXLCdbZKjHLFln
         qoGmivAiTE1XxjEGok3GECqv/lygl5VSmLlMGrAZ5yx+9czC14bMWc2sjhbBErKkO6lg
         SZDIAPR99VtBVc3Evvqdi5hQIxycIdwdsTrctrZaiwfzamFsBTFeVAaQ7YVPdHq5zOHv
         ec+0LtNNMY8o+TRmDJLhxzUHAsPOqVaPXdX5ZSfx54W6xJk4dZsOW2eWp21Ve3eyKEAg
         8sbQ==
X-Forwarded-Encrypted: i=1; AKwUvByPb31mS9j2e7ONY1h7H7lVNdSbf6x0nLwzAf27tUmQ8KTsmjcLsojH8XCLOTuh4RXJFQwULUjSx4AoDXo=@vger.kernel.org
X-Gm-Message-State: AFuF++m3i6EXkS4nt64Fm6ih8rVzU5WfBdMmcZh8Sl80l3KeJI1+X5kw
	yqyKiecXuWC2c7/VbrSPijBkrQenUuSShK/BWE/7rN1dFP2qN02I0YJ8pqzCNmCdJyUyy+3ZOQW
	Vi3K3UznM9K5T9Qi5EVftlXjcKfjOdqS8lO1xugnezEIBs8Mwgk7JF7Q4vR47A1bZwkY=
X-Gm-Gg: AYBFou36Xfyoq4SQCPPiIC2uoNGkZBUjVIntzBoysNKDPVf+xv6HC1r7ZVIe3zG1ySK
	/D/FE4QoaUmXB3aRWMPFb/Ds+Ta9T3FEvWa7sk7RCjBBQMurQWaR8WOSLuCSj78sGnWRNWLBrqV
	FtfwjghP1eyfu6N9QUbCKEgnhl6FG+BNwCKYeG7EAanma/i20OP1n5mDIpj06DWGiep6DNmRqjt
	uqKe+5q6uLiUuMjkgms6cW+v37rU4RjWieT50o+jn9BVZKgG5D4zyNTdxbNurevPWUALvYPrJfs
	6/Tv1jDt4N/Ed1yJFCHk2cR9g5oN1AS+7uQUU+KVGICOyPuv/MHuOFlp6fxe+e8PQVLjzxjn4kn
	lkPxxbUUIs9hIMPgMHHbMxyUvGPEcYKw1r3GO1GKA6YFs5LRzEzBeLzibRw==
X-Received: by 2002:a17:90b:4d0c:b0:37f:c97a:939f with SMTP id 98e67ed59e1d1-396d0dd5069mr33909576a91.7.1788157319610;
        Sun, 30 Aug 2026 23:21:59 -0700 (PDT)
X-Received: by 2002:a17:90b:4d0c:b0:37f:c97a:939f with SMTP id 98e67ed59e1d1-396d0dd5069mr33909493a91.7.1788157319060;
        Sun, 30 Aug 2026 23:21:59 -0700 (PDT)
Received: from [10.110.79.126] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-142e0d38207sm25010026c88.5.2026.08.30.23.21.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 Aug 2026 23:21:58 -0700 (PDT)
Message-ID: <e09d1622-29aa-43f3-8e3f-776dc78c3641@oss.qualcomm.com>
Date: Mon, 31 Aug 2026 14:21:50 +0800
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
Content-Language: en-US
In-Reply-To: <d81e347e-8ca7-40a1-a428-5bce6f0d4b02@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: IwvojOdk5swvgdx5eGROPwc_61Qp5XIk
X-Proofpoint-ORIG-GUID: IwvojOdk5swvgdx5eGROPwc_61Qp5XIk
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMxMDA1MyBTYWx0ZWRfX0re6SpJHH7I/
 S8LB4IQ6GrrwDQVPanewbNSbrjs1p2NV5Nthhb6+f8nVrgpb0OI+O7d8DdbK77TqebKDyli+8Ly
 mwDTVhARK3VBa9RTgzcendgBZJZmMgU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMxMDA1MyBTYWx0ZWRfXwJH/ZAD/JBRK
 GKULsheNjnkyy/IlUVIFq3KxcjXV9k5szbRq51mGDZALcf8flSmF90CZJ3T2Ar+/xUYZDHm8tMg
 kkpnVoG4dyjn/08WWtI4N3y/3zqfZXcY6US+HfnYi/jjKfOyDuLcfTsqzjrmDbMLSkIcGOk5HRg
 84hCFVFyqEM62PdBseyf7vgZJEiB71jexYst5AcFVJX6gqmDnneHZ3qeESysxbjh+EZCe/bACKM
 /WOx9W1hFTXsZeQsoUt2HXQD9xktyNxb+27L4BW1HUpKvldmgpgOJobUKo8GOpWVmpIe+DNYBYI
 reeVwrR/WAT6yOF0yPIXVGFshu64lhE2d3OLJNKCDiw1kt3PjO/Ks/LAU4gPDHxUxfsDI7xXvZg
 wG3bZMU35mP/Su1CmoqlQ0RsufBJQEoKUYbhoVNTpHZIuaLFlI+Ky/AxZOqVt7Futik5GKzgkwN
 J/Hr/NTKB3dcNftxj/g==
X-Authority-Analysis: v=2.4 cv=YKKvDxGx c=1 sm=1 tr=0 ts=6a951d88 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=_h6NAR8LnRz2utxSRfIA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-31_02,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608310053



On 8/28/2026 11:37 PM, Linlin Zhang wrote:
> 
> 
> On 8/28/2026 2:42 AM, Eric Biggers wrote:
>> On Thu, Aug 27, 2026 at 09:07:09AM -0700, Linlin Zhang wrote:
>>> From: linlzhan <linlin.zhang@oss.qualcomm.com>
>>>
>>> Current virtio-blk does not provide a mechanism for a guest to
>>> program hardware keys or submit encrypted I/O using pre-programmed
>>> keyslots.  It drops the crypto context when issuing a bio request
>>> to the virtio-blk queue, preventing inline-encryption-based FBE
>>> on virtio block devices.
>>>
>>> This series enables File-Based Encryption in guest VMs on Qualcomm
>>> GVM platforms where the ICE inline encryption hardware is shared
>>> between the host and guests.  In this environment the guest kernel
>>> has no access to the ICE hardware directly; it supplies a virtual
>>> keyslot index and data unit number with each encrypted I/O request
>>> via VIRTIO_BLK_F_INLINE_ENCRYPTION, and the host must translate the
>>> virtual slot to a physical ICE keyslot and submit the bio — without
>>> transferring raw key material across the VM boundary.
>>
>> This seems to be designed incorrectly by not making virtio-blk itself
>> support key programming and eviction.  That complicates things
>> significantly by then having to handle the key programming and eviction
>> out-of-band using Qualcomm-specific SCM calls.  It also means that
>> adding other implementations of this would be very difficult.
>>
>> There are some claims that not transmitting keys across the VM boundary
>> is desirable.  But that doesn't seem meaningful, given that all the I/O
>> is transmitted across that boundary in plaintext anyway, and also it
>> seems that hardware-wrapped keys will be supported too.
>>
>> Please make virtio-blk support the key programming, eviction, and
>> HW-wrapped key management operations that are needed for this to work.
>>
>> - Eric
> 
> Thanks for your comments!
> 
> Not making virtio-blk itself support key programming and eviction is
> something done deliberately. Based on that HW-wrapped key management
> operations are also handled in the out-of-band path.
> 
> There are bellow 2 approaches I investigated to let virtio-blk programming
> the key.
> 
>   1. virtio_blk implements blk_crypto_ll_ops interfaces, including program
>      key and evict key interfaces.(Same to 'the virtio-blk interface standardized
>      blk_crypto_ll_ops requests' mentioned by Stefan in the virtio SPEC thread)
> 
>      The guest's block crypto profile manages the keyslot in virtual slot
>      format in this scenario.
> 
>       - block crypto key and virt_slot index it passed to the hypervisor's
>        (EL2) device emulation (QEMU, using QEMU in the following) which
>        runs in userspace of the host. Besides of transferring the virtual
>        slot to the physical slot, a programming block crypto key UAPI need
>        be added. Follow current blk-crypto design, it may be like
>        BLKCRYPTOGENERATEKEY. I thought this results in a security risk that
>        allows userspace process a key into a key slot.
> 
>      - For key eviction, it's similar to above key programming handling, also
>        need a key eviction in blk IOCTLs, but leads to the security risk
>        that allow userspace client to evict a key in a key slot.
> 
>     virt_slot, DUN and DUSize is appended to virtblk request during crypto
>     I/O.
> 
>   2. virtio_blk implements blk_crypto_ll_ops interfaces, excluding program
>      key and evict key interfaces.
> 
>      The guest's block crypto profile doesn't manage keyslot for the guest,
>      the host's block crypto profile manages keyslot for both the guest and
>      the host. The trigger of key programming operation is moved from the
>      guest to the host.
> 
>        - The whole block crypto key (key size, key bytes, blk_crypto_config)
>          and DUN are appended to the virtblk request during IO, a little
>          high payload.
> 
>          The backend parses the crypto message in the virtio queue and
>          construct a block crypto key and DUN for the bio_crypto_ctx
>          set to the BIO. So that the IO flow in the host can program
>          the key. 
> 
>          The question is that the blk-crypto-profile distinguishs the
>          block crypto key via the key's address. But the host has
>          different key addresses for the programming and eviction key
>          operations of the same block crypto key from GVM, because the
>          key is re-constructed in the host for the key program and
>          eviction operations. 
> 
>          To fix it, the approach I thought is maintaining a new key
>          hash table in the backend, and comparing the block crypto key
>          content and DUN parsed from virtio queue with that in the key
>          hash table. 
>          My major concern is that this need keep the keys synchronization
>          b/w this new hash table and the blk-crypto-profile's hash table
>          carefully, avoiding that key is still present in the
>          blk-crypto-profile's hash table, but removed in backend hash
>          table. Another point is that the whole block crypto key and
>          DUN are appended into virtio block request per crypto I/O.
> 
>        - For key eviction, adding a key eviction in blk IOCTLs allows
>          userspace client to evict a key in a key slot. I thought this
>          is a security concern.

Correction.

The key eviction operation is also moved from the Guest's blk_crypto_profile
to the Host's blk_crypto_profile. As a result, the entire block crypto key
(including the key size, key material, and blk_crypto_config) is appended to
the virtblk request. The backend parses the supplied blk_crypto_key, looks
it up in its key hash table, and can then invoke blk_crypto_evict_key() to
evict the corresponding key from the ICE keyslot. Unlike Approach 1, Approach
2 does not allow the guest to specify the keyslot to be evicted through the
block ioctl interface.

I'm appreciated if you can share your insights and thoughts about these 3
approaches.

> 
> 
>      This option doesn't need map virt_slot to physical one.
> 
> 
> Taking all the above into account, I made a compromise to implement
> blk_crypto_ll_ops interfaces in a out-of-band path, which lets the virtio
> blk only need focus on the data path. I agree that it is complex than
> the second option mentioned in the above, but small payload (only
> virt_slot, DUN, DUSize) in the virtio block request and no security
> risk of key eviction from userspace.
> 
> 
> I would like to hear your thoughts about the above and am appreciated
> if you could share your insights about the design of inline
> encryption in virtio block.
> 
> Regards,
> Linlin
> 
> 
> 

