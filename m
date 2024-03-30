Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2912AD21
	for <linux-crypto@vger.kernel.org>; Sat, 30 Mar 2024 20:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711831300; cv=none; b=CB8bqXoEV55AwzqqUpJA8aUNjU+BVFHkgEAr/I1icnv0qHUcBR2g/x8tJf/093XkeSu7an4ivWz0DeAdsxOmmMJMtwnzUAZ9QXON71FxYsQhB1H7ctfayh8H344TXJ8wNBgGRCLM6Zxs8N5LVXG2UzqzSxJKg8ThiCgOtMVpgsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711831300; c=relaxed/simple;
	bh=7dTdkj6dbfeGOX49aszp3xV2V9j0UCoyFUvP/lOs9+I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tgyyQgqrAFf/8JRrlC12KPtSLgA8WCFr/RfLPRHeywlHad6SMfyxn4/MIEqz3bDpgZNz2OfW5qI4aWOGDIsfzS7QFaa7dgKZAIgpQXemsCP+d7XilurjjVBRNttOoruBEXGK1MsRkAcgkbrYDg2yEDGuXspvckm1DS+6SV97Scc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q8XsfkiU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q8XsfkiU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711831297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CPc6/ijvCVVJ1Ov2sZYMdJlGOmW3NElQ82lFIMviPGU=;
	b=Q8XsfkiUQsPzUWsihYyKLunPTLiMwAKlb0tGxlKoiePy6g29kD4/v/DKL8DT/sKQwEx/6V
	/Kym8KvGcDqG6TRw+b4AgYHxCfyX+mt7Dq0LcOPXREA37TaYDb9rg4laJtVqkQZIZoFATp
	mXv42WKKbooDZnoiiVB58YulDzAFM1o=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-473-AesHeceLN3K93Z_PfiRyMA-1; Sat, 30 Mar 2024 16:41:35 -0400
X-MC-Unique: AesHeceLN3K93Z_PfiRyMA-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a4e43a04626so60694866b.0
        for <linux-crypto@vger.kernel.org>; Sat, 30 Mar 2024 13:41:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711831294; x=1712436094;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CPc6/ijvCVVJ1Ov2sZYMdJlGOmW3NElQ82lFIMviPGU=;
        b=P6XfwTBHd5vr/ZGAkeGQFggq6ZSBmkg0UW+m9YWPCdYpZoAz3gdJiVVNTs+HTAv/Ry
         jm+SmiqX+d7c252yVQ5uHDHOrz+Z7nbPmriXuUR7u5NhXryOUvS6fGeUaW0ncPHpk70p
         Tw7s4ZTovf5PQ25Y8k6sfq43Yi0XgifLKywXkZrXPQBayk4UC1ZK1ylgb9at5Lvev1qG
         3USwV+eeuEaeoc0+ZE6Q+wiGqB8qog7TnpoOMsi8tYvY77wc6qfIdyUu0JpJ0+150PbV
         zBMcMEJbks8msG19ksyxDl3SKG1iBOgEH8xtfRNfQHfcmvOVkoNrbLzxnMQ0G0EwlCIt
         PuVw==
X-Forwarded-Encrypted: i=1; AJvYcCWsK7y944e1euYYvycGvgjr6srdsQO98+ZYS/oLfhBQ3pSnOru7+mDjPAMWD5N7BKwdrIhJecaX3eTPgGDS8q75dp3sblJboOx27uSw
X-Gm-Message-State: AOJu0Yx+gVBRdPaeoMFuynI92pSTbXUA1m/Ha7MT34hn+KXXwi+WTYSI
	yTu2DP3gH0QHixnE95zSiZCc5u3j8f6U0EJOUInPADc0D2QrOjIN0pIqFLX1ml3bjgArPTo0YT+
	2L6g+OgFvu3BfFbGhIEfatUUwlyF0N2vU++34klY9/FYZe8lLOTq4KlXMMzuCpA==
X-Received: by 2002:a05:6402:2745:b0:56c:2ef7:f3e6 with SMTP id z5-20020a056402274500b0056c2ef7f3e6mr4376422edd.0.1711831294661;
        Sat, 30 Mar 2024 13:41:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF9Gbkjn/ZWKYbzmUfYSMj2NejhWxYSZ/mEpFdvV+HFgC3/+irSlMKFkDAQ95tTo6ihx/AnRw==
X-Received: by 2002:a05:6402:2745:b0:56c:2ef7:f3e6 with SMTP id z5-20020a056402274500b0056c2ef7f3e6mr4376399edd.0.1711831294379;
        Sat, 30 Mar 2024 13:41:34 -0700 (PDT)
Received: from [192.168.10.4] ([151.95.49.219])
        by smtp.googlemail.com with ESMTPSA id fg4-20020a056402548400b0056c41068d8dsm3549732edb.17.2024.03.30.13.41.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Mar 2024 13:41:33 -0700 (PDT)
Message-ID: <40382494-7253-442b-91a8-e80c38fb4f2c@redhat.com>
Date: Sat, 30 Mar 2024 21:41:30 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 12/29] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_FINISH command
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
 Brijesh Singh <brijesh.singh@amd.com>, Harald Hoyer <harald@profian.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
 <20240329225835.400662-13-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240329225835.400662-13-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/29/24 23:58, Michael Roth wrote:
> 
> +		/* Handle boot vCPU first to ensure consistent measurement of initial state. */
> +		if (!boot_vcpu_handled && vcpu->vcpu_id != 0)
> +			continue;
> +
> +		if (boot_vcpu_handled && vcpu->vcpu_id == 0)
> +			continue;

Why was this not necessary for KVM_SEV_LAUNCH_UPDATE_VMSA?  Do we need 
it now?

> +See SEV-SNP specification [snp-fw-abi]_ for SNP_LAUNCH_FINISH further details
> +on launch finish input parameters.

See SNP_LAUNCH_FINISH in the SEV-SNP specification [snp-fw-abi]_ for 
further details on the input parameters in ``struct 
kvm_sev_snp_launch_finish``.

Paolo

