Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F19523376BA
	for <linux-crypto@vger.kernel.org>; Wed,  3 Dec 2025 19:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764789875; cv=none; b=aZ/FBHuWkVYQ9niM5LpqgZ82M9vtc5HVFY7LuVVQ8br6xSFzSVPCBnVavojI83BuCyW7NgI5tw2OVKrNKQweG2b30ak5zVwazhGZjs9oQZc68II1nW/vxoRNwmesKGoJAj3xEAQLZ/w9ix2abMYcVwulNL2K9GhyR2t0vkP+/Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764789875; c=relaxed/simple;
	bh=rXtDsikl+ZmJ58CWgrgBz76cohjE0po0vxToMWJd5f0=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=JHMChlFvnopZfrm1pJfNi69gfrpp9llgoXdX1brrpTxidqeC/VwR151M9awSOyliprN1jR0fzuncGBde/vzjIe6slRAN3ynptg6iKRL4Mx6cAI5wwz4i4YGkchu9ROi1S6RTNEAxRYHRDAIQHNw44z5ZIQ38pWXSAfIjDLLfguc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=r/Eobem4; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="r/Eobem4"
Received: from [100.96.234.58] (unknown [52.177.6.198])
	by linux.microsoft.com (Postfix) with ESMTPSA id 0D9682120712
	for <linux-crypto@vger.kernel.org>; Wed,  3 Dec 2025 11:24:32 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0D9682120712
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1764789873;
	bh=b6urpNGllUfdtUjPG5/9ph0jvslZXGcq2YoIpQlDlpw=;
	h=Date:To:From:Subject:From;
	b=r/Eobem4DjGcnK9iri9L9GK8GMS2wY+VuN2o47kYL7GfxTlKwRqb1I8Y3gYFbvo77
	 LN8YfPVGUqv9uwHZEkvUy3TJ0cctrDDuj/RX/4svAZMHBuFzTd7giFvstVpylVU5JI
	 VV8BHif1jme5To6tCsEbHFWyoGl1T1Y5bIX3Vo7E=
Message-ID: <242beb94-8e29-490e-ac3b-56858a27b4a6@linux.microsoft.com>
Date: Wed, 3 Dec 2025 14:24:31 -0500
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
Subject: gcm(aes) iv generation uniqueness
Autocrypt: addr=jeffbarnes@linux.microsoft.com; keydata=
 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
 BR++r9M2JSHIgP5LESF8KrBJ6s2f4TqSBCpQ
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Does the kernel crypto api provide a uniqueness guarantee for internally 
generated IVs for AES-GCM? How about externally generated IVs?

It looks like RedHat and Ubuntu have different mechanisms for a seqiv 
for uniqueness. Is there any active patch with either or perhaps an 
alternative one?


Best,

Jeff Barnes

