Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA5BF265CA6
	for <linux-crypto@vger.kernel.org>; Mon,  8 Dec 2025 15:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765206903; cv=none; b=L7667TqA4wJZpkyx9ktTUipUY30YQaYYSc0OF+u/YyGb0btMNktfNbj58aU3bguVOOKP+2aLy40EewTnolfX2ZUW2r+0x/qiRq+xBGnmhSd8rzaCp15mrpmOMg+KGVigwlYTWPy6zgSxsG/cZUrOrtT36P9qCbL/V1j9aWBYKSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765206903; c=relaxed/simple;
	bh=HtgTxKR/MGm5uNzQXr2WwDYvrqqyhNRePBvsHDCG4i0=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=PUqdZaoEA1BGQ0a+0UoXtc2a9suGAlLGs07+QdkhLGvpLx8KtB8KWJ6aqBOde6AIabflUyuSit9TObnjt1V7EAOI5VJ6uFtkygwaaUeOKxOuUjNHwJrq9zhRRNeeMEasIFwyC+f94iyRGS7Wctm2J8pbcInxlg7UtJhKvLPAyKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=tNAUW2Cn; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="tNAUW2Cn"
Received: from [100.96.208.134] (unknown [52.167.115.14])
	by linux.microsoft.com (Postfix) with ESMTPSA id 1C693211603E
	for <linux-crypto@vger.kernel.org>; Mon,  8 Dec 2025 07:14:54 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1C693211603E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1765206895;
	bh=ElTtl2h/G7PcEWDgZSuT+En2sksNs4x3/uM24/ZTnYE=;
	h=Date:To:From:Subject:From;
	b=tNAUW2CnygkYhJvQyWgx01TAsvMVprKR49vXGbDLh5AmbWYpXSOGUUo453XqmQC/9
	 KI9YhAt4qvfFMLEPAXRjAl6lcIV3BTgCQXpanpjrKcA0muBJPkuTJ/izvrRKOw450P
	 Z3yeUv1mTWI5E0amrzirWj3lr/0AWkD0fWp5ntc4=
Message-ID: <6715b21c-94b4-45d5-83ee-fda8813716e2@linux.microsoft.com>
Date: Mon, 8 Dec 2025 10:14:53 -0500
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-crypto@vger.kernel.org
From: Jeff Barnes <jeffbarnes@linux.microsoft.com>
Subject: Questions on AES-GCM Compliance with NIST SP 800-38D and FIPS 140-3
 Requirements
Autocrypt: addr=jeffbarnes@linux.microsoft.com; keydata=
 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
 BR++r9M2JSHIgP5LESF8KrBJ6s2f4TqSBCpQ
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello,

I'm working on FIPS 140-3 compliance for a Linux-based environment and 
have a couple of questions regarding AES-GCM in the kernel crypto API:

IV Uniqueness Requirement
     NIST SP 800-38D (Sections 8.2&8.3) mandates that each AES-GCM 
instantiation must use a unique IV per key.
         1) How does the Linux kernel ensure IV uniqueness for AES-GCM 
templates?
         2) Are there recommended mechanisms or APIs for deterministic 
IV generation when using crypto_aead interfaces?

Service Indicator for Compliance
     FIPS 140-3 Implementation Guidance and CAVP testing require modules 
to indicate when an algorithm instance is operating in an approved mode 
(e.g., instantiated with a unique IV).
         1) Does the kernel provide a flag or attribute (such as 
CRYPTO_ALG_FIPS140_COMPLIANT or CRYPTO_TFM_FIPS_COMPLIANCE) for AES-GCM?
         2) If so, what conditions must be met for this indicator to be 
set, and how can user-space verify it?

Any pointers to documentation, code references, or best practices for 
these compliance aspects would be greatly appreciated.

Thank you for your time and guidance.

Best regards,
Jeff Barnes
SR Software Engineer

