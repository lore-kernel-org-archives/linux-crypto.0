Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99B52AD21
	for <linux-crypto@vger.kernel.org>; Sat, 30 Mar 2024 20:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711830709; cv=none; b=dlIYjdZHIrkX8Zmml21pEfuQ203mYqTo2pJuVLP+fHY50MJvJtcZt7WWYUN4i1kPyJkUuYPutSyK4HVEChAFsd+BWtn5mqxgCfxLq6GQUGIjg1U+cN9MjG34p09ayWQEkVVOkdAPcdE1ONrAJoOJxpctEg5PnuHdLvOkDixTTno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711830709; c=relaxed/simple;
	bh=6ctr9IjTD/fi10pl5bm0p03fWwzEss7WctNWnahmYJ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mxKzDJRPf3vxgRaUy2Bg8HbgyH7xYy6r4cgd4lvIgzrvVM35qRtLMkU3cJ84ELl+TfjxIpaPkcqtTjPYw7WtP8znHouuhfgcUdK4/AjhAvn9Q23YL3PfIAgF6rh6avcAI2RdZUafor//uIN0Qzpf9zCXxsIzjNIyOQY/LQNOa28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NGRXK6eR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NGRXK6eR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711830706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5D9RsBB4kciPmaMVEYgR85qIqWcP45dPbiaFBD383j8=;
	b=NGRXK6eRbDKMeBI6wqSaVeW6bfxT32AK137mJVIJzUTneNyqco+mCcZ/Jxxt5TaJlZIjXj
	Uwfuq5SFbQMMuR/7jOPrpX5QK+hYMJ6SnZgunyPkm8kYOlX8Ybnx3YcBYVaA4EdofbYFE2
	v+csROiqL/wkosZeKiqvj0aUS2wb+Ks=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-ZpkZdFrbOcymOOMkb5-zWA-1; Sat, 30 Mar 2024 16:31:45 -0400
X-MC-Unique: ZpkZdFrbOcymOOMkb5-zWA-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a466c7b0587so204067966b.0
        for <linux-crypto@vger.kernel.org>; Sat, 30 Mar 2024 13:31:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711830704; x=1712435504;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5D9RsBB4kciPmaMVEYgR85qIqWcP45dPbiaFBD383j8=;
        b=q6BfGaMP4rCuggwUWGSTMpOPH0aSXMvI/luVm4eJ5cEV+1nOH6R06LcmYALOmTmjyL
         f4ukS/yKpI9Mm5X4YBLGGVr+7yC/LQsfyRaHOjNu5L5+M6IfbskKD02yS0uZpiWETbIe
         UCdNP9cRz/RyHLV1Qj4saMHtREhMQdoJxxmDOttgfWjIcL44lV2vT6J0JmLMdq4oAYZf
         mslKGgJn9/tLFmo7Xft7JLi/jiUdGmbCC/bvEUFFc/d3UQjB0NumzdX0YIwt4kSnFstm
         G4sioqbzMFfwXvnoME+1EaNf7PkL9x0akXw0PKxV9fz4KA2BqPUbry7wDzCiq1B51vqe
         Z+iw==
X-Forwarded-Encrypted: i=1; AJvYcCVyp5ky2EoCjsoCtLR9nJ/La6zrhiFvDEWU0k8fprsIOK0fBGo5Tc6M09OLK+3ZN1/+69lFMMReHi50d3Z52Q62bXj365+M7WbbPZcV
X-Gm-Message-State: AOJu0YyEGBlq4tAarGy4zrZxlNnMOQK2Kp7HfmEwJW9+Iv3pW2YuBaZ7
	iuexh6IB/iakSCcraYrzDXK/abpFZJ3405YqVCkhpA+8eqRUaTXSYAeNYFSoS1Qov0AH+/yg6Qf
	OAYeyY8mXh7l0u926OsHAmesV+hLWnizDbFKIFz3Hd7Km6F7FiKttItPSUW9wcg==
X-Received: by 2002:a17:907:9445:b0:a4e:5540:7c0c with SMTP id dl5-20020a170907944500b00a4e55407c0cmr1073507ejc.70.1711830704072;
        Sat, 30 Mar 2024 13:31:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFLGTizDL+ipqWK8vAakREtH5rqSNheH+umOQZwMHVXU0gaVZFxsEwVnS2XB/8MH8LYIGhcfQ==
X-Received: by 2002:a17:907:9445:b0:a4e:5540:7c0c with SMTP id dl5-20020a170907944500b00a4e55407c0cmr1073479ejc.70.1711830703673;
        Sat, 30 Mar 2024 13:31:43 -0700 (PDT)
Received: from [192.168.10.4] ([151.95.49.219])
        by smtp.googlemail.com with ESMTPSA id p17-20020a170906785100b00a4e08e81e7esm3389899ejm.27.2024.03.30.13.31.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Mar 2024 13:31:43 -0700 (PDT)
Message-ID: <8c3685a6-833c-4b3c-83f4-c0bd78bba36e@redhat.com>
Date: Sat, 30 Mar 2024 21:31:40 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 11/29] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, seanjc@google.com,
 vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
 dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
 peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
 rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
 vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
 tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
 nikunj.dadhania@amd.com, pankaj.gupta@amd.com, liam.merwick@oracle.com,
 Brijesh Singh <brijesh.singh@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
 <20240329225835.400662-12-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240329225835.400662-12-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/29/24 23:58, Michael Roth wrote:
> +	memslot = gfn_to_memslot(kvm, params.gfn_start);
> +	if (!kvm_slot_can_be_private(memslot)) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +

This can be moved to kvm_gmem_populate.

> +	populate_args.src = u64_to_user_ptr(params.uaddr);

This is not used if !do_memcpy, and in fact src is redundant with 
do_memcpy.  Overall the arguments can be "kvm, gfn, src, npages, 
post_populate, opaque" which are relatively few and do not need the struct.

I'll do that when posting the next version of the patches in kvm-coco-queue.

Paolo

