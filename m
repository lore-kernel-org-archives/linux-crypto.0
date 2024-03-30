Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B955A4A99C
	for <linux-crypto@vger.kernel.org>; Sat, 30 Mar 2024 21:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711834316; cv=none; b=gJOWbCyvO2wtkvwciM/WUn8K+63Vnj9hz4hIrEViYMB6osXbRvppY2HaPm/gXqzRj+bqDLby+VuHviSU1DcX0wDDatXtgQ7dC1UhM2GQnaOBDSm4tMHJN3assWEr6MqPP3qXh7zw5PTlINp4RmiXDTaU6YdNSDHe2nvc6c23oRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711834316; c=relaxed/simple;
	bh=t1KY6wPgvCWcWD2NOTNvE0vD4k8SIvXspJg1UZfO6R0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I8MgwMWfkZ70ClUhNdirX7OjjzUN+ChPioz9Xi7p5D0HT7V6vponoVF5u+ai0TsCGc+jh9J7pv/eToum7iPl7wNC7kSnP8BdlYiJ3PzsJkFGzsAYrWr/WNP98b7m5XYqJPQQ7Vx87BfJvxgM52HdXU5HOpJSztf1vF3IgNRn2PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=edl35z9B; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="edl35z9B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711834313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2Lxl+j+xR8FWVtx6+a/UxVWMhMmDhnJi8YYlIddCdSo=;
	b=edl35z9BPmJeVyfZue1DBgASBuJwOLiOFe38iSAg3czBXAE1pMtMh9BlYE5AQtD6STQIS0
	wok+P2jmy3CzbzdFwx1Zv4ThEy1G1K7H9WTPFgpvl6jLovXeYj89p6/1Y9IOqUWPyaSkpR
	QPqnhGKuj4lhUTNKIWo2ftLdwiMmoso=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-mSWmyoLTOQiBvVXwGihu9A-1; Sat, 30 Mar 2024 17:31:52 -0400
X-MC-Unique: mSWmyoLTOQiBvVXwGihu9A-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a4dfdbdaf06so157031766b.3
        for <linux-crypto@vger.kernel.org>; Sat, 30 Mar 2024 14:31:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711834311; x=1712439111;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2Lxl+j+xR8FWVtx6+a/UxVWMhMmDhnJi8YYlIddCdSo=;
        b=Oc2LG+GE+DDKDmSH+fvQsj06iJWMrb80J/8jLSV7MpNls3l9Fn2Ya+WNZ4Clgsq6nT
         ZaqGVm4UoCG9V75XoQw0gVYdq5bM8yaUkz5tzjjA2KuF7HHPzPVzQSeyO8KxZXcuz+Re
         6dG+3Wb597wHCyPuG7Atks0j4TOAnnEVPZYPCNnn0+UqUoSYPImbfyIhBpEGDWiPoDD3
         YdmyB+aq+WXLQPlrEtlejS9eugdUX4maJDIu/4YvNZtXZONZOyQVXtxQ8NyhfjahOcz5
         z4xMl0cek5tErsJuhvxYsIq+fNj1jdv3Y+H2Dnp0ilj9HADAIxUV5+4MLeGjVgHOXqWj
         QLng==
X-Forwarded-Encrypted: i=1; AJvYcCXOeMlo9rfHJCVICvAHrL9p6fFtUQraOFmSMkcRTFOfC7yVzk23LCRmAHxxnoCd+MO3SbI16b2ZcCS22BFgNtewdJFvOcIiYC63zBBz
X-Gm-Message-State: AOJu0YwAqeDoV6DB+hWen3FF67uv7QnIbasMxe8ZlxJRMixqkgsrizfd
	Mw3ccXv8aAxXC9IM+HkPFAdTjRmkSWzkUEek1P5a2XcxvW7lpcAFpDEpcaMm+m9AASrAS4NC0c4
	tW175QvIzbYXtg5EmN74x1KmCfkb8+ORJ0LtKesnsPxtGgsNUfFUaYomWyqNwkA==
X-Received: by 2002:a17:907:9693:b0:a4e:17c5:9944 with SMTP id hd19-20020a170907969300b00a4e17c59944mr4619562ejc.61.1711834311182;
        Sat, 30 Mar 2024 14:31:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH4ZTkjUa1qAw9ZLrLn5Cmk/KIYm4xouooLm1o+DG2vC/bIdk1gQWLiRdSLYKS8JVSoO2kgWw==
X-Received: by 2002:a17:907:9693:b0:a4e:17c5:9944 with SMTP id hd19-20020a170907969300b00a4e17c59944mr4619522ejc.61.1711834310761;
        Sat, 30 Mar 2024 14:31:50 -0700 (PDT)
Received: from [192.168.10.4] ([151.95.49.219])
        by smtp.googlemail.com with ESMTPSA id h19-20020a1709060f5300b00a4e30ff4cbcsm2438004ejj.194.2024.03.30.14.31.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Mar 2024 14:31:50 -0700 (PDT)
Message-ID: <f1e5aef5-989c-4f07-82af-9ed54cc192be@redhat.com>
Date: Sat, 30 Mar 2024 22:31:47 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 22/29] KVM: SEV: Implement gmem hook for invalidating
 private pages
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
 nikunj.dadhania@amd.com, pankaj.gupta@amd.com, liam.merwick@oracle.com
References: <20240329225835.400662-1-michael.roth@amd.com>
 <20240329225835.400662-23-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240329225835.400662-23-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/29/24 23:58, Michael Roth wrote:
> +		/*
> +		 * If an unaligned PFN corresponds to a 2M region assigned as a
> +		 * large page in he RMP table, PSMASH the region into individual
> +		 * 4K RMP entries before attempting to convert a 4K sub-page.
> +		 */
> +		if (!use_2m_update && rmp_level > PG_LEVEL_4K) {
> +			rc = snp_rmptable_psmash(pfn);
> +			if (rc)
> +				pr_err_ratelimited("SEV: Failed to PSMASH RMP entry for PFN 0x%llx error %d\n",
> +						   pfn, rc);
> +		}

Ignoring the PSMASH failure is pretty scary...  At this point 
.free_folio cannot fail, should the psmash part of this patch be done in 
kvm_gmem_invalidate_begin() before kvm_mmu_unmap_gfn_range()?

Also, can you get PSMASH_FAIL_INUSE and if so what's the best way to 
address it?  Should fallocate() return -EBUSY?

Thanks,

Paolo

