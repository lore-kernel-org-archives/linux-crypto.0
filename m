Received: from www.kot-begemot.co.uk (ns1.kot-begemot.co.uk [217.160.28.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4273E866C;
	Fri, 26 Jun 2026 09:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.160.28.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782464514; cv=none; b=A/yJV0o+0aYSuDiF+YUyqtH6I+b8yfGZCPtcLaADgxK6/NWru44EPebsGJA9SB7oX3Y+PyCg2hGWtTBg8EBBENPz1Ae3zvlcB37wvDfw2vbkXjI32R8u3SfmvWp4lh+wqDFhDG+OqC6j7qLYCpxgGznXinRDKLdv5Wn7osmoE0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782464514; c=relaxed/simple;
	bh=sEWrR8kYZ2BiJFak+x25+Vh8Z+DSlNqSjgiodK9Lmmo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dVkZYCnC7UVMJRzKpxfm1HtPfemBqrGIjoEgLadoUP5iPZ2JqiUuGJG5HXY3wm5Mj7tMXDXyxosKCNdyu6i2x/t62KXRHj2hFYSOim83ZaGPujW2puEayW1LqSFk5N65q0rMXM2+endOjJlSgYEjWd6r4h2BkV7+Gha+mQRk1iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cambridgegreys.com; spf=pass smtp.mailfrom=cambridgegreys.com; arc=none smtp.client-ip=217.160.28.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cambridgegreys.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cambridgegreys.com
Received: from [192.168.17.6] (helo=jain.kot-begemot.co.uk)
	by www.kot-begemot.co.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <anton.ivanov@cambridgegreys.com>)
	id 1wd1ot-001u1R-T0; Fri, 26 Jun 2026 08:21:51 +0000
Received: from [192.168.21.56]
	by jain.kot-begemot.co.uk with esmtp (Exim 4.98.2)
	(envelope-from <anton.ivanov@cambridgegreys.com>)
	id 1wd1kq-0000000BoSt-0qIQ;
	Fri, 26 Jun 2026 09:21:50 +0100
Message-ID: <6a20b442-b97f-4cae-9168-30201d5ef82c@cambridgegreys.com>
Date: Fri, 26 Jun 2026 09:21:49 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/8] um: Check for missing AVX and AVX-512 xstate bits
To: David Laight <david.laight.linux@gmail.com>,
 Eric Biggers <ebiggers@kernel.org>
Cc: x86@kernel.org, linux-um@lists.infradead.org, linux-raid@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>
References: <20260626043731.319287-1-ebiggers@kernel.org>
 <20260626043731.319287-3-ebiggers@kernel.org>
 <20260626084113.42eae31c@pumpkin>
Content-Language: en-US
From: Anton Ivanov <anton.ivanov@cambridgegreys.com>
In-Reply-To: <20260626084113.42eae31c@pumpkin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0
X-Spam-Score: -1.0
X-Clacks-Overhead: GNU Terry Pratchett



On 26/06/2026 08:41, David Laight wrote:
> On Thu, 25 Jun 2026 21:37:25 -0700
> Eric Biggers <ebiggers@kernel.org> wrote:
> 
>> If the CPU declares AVX or AVX-512 support, verify that all the
>> corresponding xstate bits are also set.  If any are missing, warn and
>> don't set the corresponding X86_FEATURE_* flags.
>>
>> This eliminates the perceived need for UML-supporting AVX and AVX-512
>> optimized code in the kernel (that is, lib/raid/ currently) to start
>> checking the xstate bits in addition to X86_FEATURE_AVX*.
>>
> ...
>>   static void __init parse_host_cpu_flags(char *line)
>>   {
>> +	u64 xcr0 = read_xcr0();
>>   	int i;
>> +
>>   	for (i = 0; i < 32*NCAPINTS; i++) {
>>   		if ((x86_cap_flags[i] != NULL) && strstr(line, x86_cap_flags[i]))
> 
> 'line' comes from /proc/cpuinfo
> Surely something would be terribly wrong if that included something the kernel
> had disabled (or didn't support).
> 
> 	David
> 
> 
>> -			set_cpu_cap(&boot_cpu_data, i);
>> +			validate_and_set_cpu_cap(i, xcr0);
>>   	}
>>   }
>>   
>>   static void __init parse_cache_line(char *line)
>>   {
> 
> 
> 
 >
Lots of other stuff will go wrong before that. Glibc, things compiled with LLVM, python, perl, etc.

Half of the userland will go belly up, because AVX is used in string operations and hashing if it is available.

UML is just another userland application from this perspective, so there is no reason for it to behave any different from the rest of the userland.
-- 
Anton R. Ivanov
Cambridgegreys Limited. Registered in England. Company Number 10273661


