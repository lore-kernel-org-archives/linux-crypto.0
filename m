Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19EB36AE4
	for <linux-crypto@vger.kernel.org>; Sat, 30 Mar 2024 20:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711832147; cv=none; b=fSTTOH3ubQ+X2NIDUhwzg927GiwyRQ/00sS+QzooAfxriCS1AJVKxknSy+FkzEY2+P9zuFmqxsCYj9PpfP+ultE0emhbtzi/+DSfxz3/kS8M6dqf6BX12IocVcE06sTula/wMxIlrBctswhvz+MOnst138ygcxlsxGaGsL/UfHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711832147; c=relaxed/simple;
	bh=z7TmabSrZt9asoh9147M/NyurNg5SlDymoLAfpK3VzY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mGCpbAjirk5UQJ/ZPpG4hGjsn5+yXvEdUcSjrkpu1srJZkHIsfU+FbtVl9sPiavOMu4AClTK0YkqsoQriw1bbj21Ceo621rTjIUYpWxurCIdRunX4AZFH2zk0k7TZHdmYnkJL2WcmyfwfhKP4FKPC294SFIOFhH7Buz3trgU5gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hl6eELnV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hl6eELnV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711832144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jyi6SED43RWjiHARW2FnY3B2JhkS1d2lHNCRYyCsMcg=;
	b=hl6eELnV0t7CvxcVkDU/ihH+xSbaVr3a1Ryu2cp8yTwlDXYVlvf4JZNv0aSBSyfLIO/W8I
	4qijzh02FFkamT+YlxopeY3ykUQh4UvZ8dNV8pmrJZ9i1Xmdcp7qGBAQJLCrawF7NbT4J8
	MB0nW2/Jbb5eNzBRk1WL854Hks4hK1k=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-604-FfbG8reuOzW4mj_xRLvqGQ-1; Sat, 30 Mar 2024 16:55:42 -0400
X-MC-Unique: FfbG8reuOzW4mj_xRLvqGQ-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2d6c8f170e2so28720921fa.3
        for <linux-crypto@vger.kernel.org>; Sat, 30 Mar 2024 13:55:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711832141; x=1712436941;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jyi6SED43RWjiHARW2FnY3B2JhkS1d2lHNCRYyCsMcg=;
        b=s8K4v3tT2gTtGtnwrAVJVmsaHO02nEly2PCqZ1xA2oqKErrm8DA5NL6yUpedTDUi5P
         OLgQfDwm6vBpbmCL+HIRGXBUiE4YPWSHl+JFCuV4tZtvYQiUJUVxfsvIGTGV0yRYXN4u
         q4q2Tgh64025HIPHdeytoDDP6HxPknbEFOMBJOlK/+0L20JG+KxhKYYTHJgsFwjQHRMH
         z5W45ci5/xLFCTO5zauBHKTvIfBPi/YmWJKomTT+XhiNDPTm7/3TgUq088KCpcA0I+Qb
         UnLDh5ZNv+uSokb1nbSBeaLPPCTBHY9L066VrY1OCTbzvI0unefTDaYzf9qgtzA+7WmY
         49wQ==
X-Forwarded-Encrypted: i=1; AJvYcCWDar44IWOVGL2DuQSXfgPvYEitdE4VMcfvaC3UUHqkXC+/DDkvmRnuA2BqfwbLi+DlhSOZTM8TEL1aBwidlQgaMicMMlzN7YO8ueNa
X-Gm-Message-State: AOJu0Yyoc3lP07sOdD3jBktyEROr8+xcfgcMCbRPZ+zReOFym+DUne9h
	Ktr1edjBp/jT9w8b81dLweyH5cOxq/3aFMuNU6s49gBs0CWxWczDViayOZoROJDlTexYOdLQ9Oc
	wgZNo8kCCwD/Dxh4n4EcmNsOifOjmFxbhGXPMBUMreebNs1krhOZstgCpw86HeA==
X-Received: by 2002:a2e:3307:0:b0:2d8:1096:6913 with SMTP id d7-20020a2e3307000000b002d810966913mr136874ljc.20.1711832141153;
        Sat, 30 Mar 2024 13:55:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE3w4cwAv4h4Eb58plOtyeNT/FqmpU2M4qH41wQ1IThyW9pWf1IBmQXNxSRhgLNhjfSlLWhkg==
X-Received: by 2002:a2e:3307:0:b0:2d8:1096:6913 with SMTP id d7-20020a2e3307000000b002d810966913mr136864ljc.20.1711832140682;
        Sat, 30 Mar 2024 13:55:40 -0700 (PDT)
Received: from [192.168.10.4] ([151.95.49.219])
        by smtp.googlemail.com with ESMTPSA id 17-20020a170906301100b00a45c9945251sm3414724ejz.192.2024.03.30.13.55.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Mar 2024 13:55:40 -0700 (PDT)
Message-ID: <37941671-9ece-4078-b308-b185579e8d7a@redhat.com>
Date: Sat, 30 Mar 2024 21:55:37 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 17/29] KVM: SEV: Add support to handle RMP nested page
 faults
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
 <20240329225835.400662-18-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240329225835.400662-18-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/29/24 23:58, Michael Roth wrote:
> +	if (rmp_level == PG_LEVEL_4K) {
> +		pr_debug_ratelimited("%s: Spurious RMP fault for GPA 0x%llx, error_code 0x%llx",
> +				     __func__, gpa, error_code);
> +		goto out;
> +	}
> +
> +	pr_debug_ratelimited("%s: Splitting 2M RMP entry for GPA 0x%llx, error_code 0x%llx",
> +			     __func__, gpa, error_code);
> +	ret = snp_rmptable_psmash(pfn);
> +	if (ret && ret != PSMASH_FAIL_INUSE) {
> +		/*
> +		 * Look it up again. If it's 4K now then the PSMASH may have raced with
> +		 * another process and the issue has already resolved itself.
> +		 */
> +		if (!snp_lookup_rmpentry(pfn, &assigned, &rmp_level) && assigned &&
> +		    rmp_level == PG_LEVEL_4K) {
> +			pr_debug_ratelimited("%s: PSMASH for GPA 0x%llx failed with ret %d due to potential race",
> +					     __func__, gpa, ret);
> +			goto out;
> +		}

Please change these pr_debug_ratelimited() to just a single trace point 
after the call to snp_rmptable_psmash().

Paolo

