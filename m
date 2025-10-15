Received: from psionic.psi5.com (psionic.psi5.com [185.187.169.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A8828850C
	for <linux-crypto@vger.kernel.org>; Wed, 15 Oct 2025 05:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.187.169.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760504842; cv=none; b=aWm2okVcqX5icwwfbT46QutwAcU08NUkh5qAQgvUwbr7H0FRUax2mqXk5VwcuUd1bybs8MLH/5WzDdc2Yp//rYwic3zCzX2yem/V2YzG4YzedQUqZ1i6Ohi30F38n93pnLKxwOHmo00ePIS2BT1gNdTpiiSpFO8KHvg7FwR/8nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760504842; c=relaxed/simple;
	bh=ApbaFJ/v3owwWa1seKjCOJUE0Q/HftZ+DqWgpSFO264=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UnJXmj2Mj771bVMWKYiwUNL+04QLe9Z/ybtUgYF/Q96LooedQZyP3+OsftomYnIZu2IUTHmNQsIdWPiO8lN2AHPgQ4BVSpiPMoyh5xeh1gUMB+WbDiCaymy8cAwhlwkt4T6puPkxBr6qsr3rTyNPUIQeYZVVv7Zsv4V7+IsZ/7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hogyros.de; spf=pass smtp.mailfrom=hogyros.de; arc=none smtp.client-ip=185.187.169.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hogyros.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hogyros.de
Received: from [IPV6:2400:2410:b120:f200:a1f3:73da:3a04:160d] (unknown [IPv6:2400:2410:b120:f200:a1f3:73da:3a04:160d])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by psionic.psi5.com (Postfix) with ESMTPSA id 6A2853F116;
	Wed, 15 Oct 2025 06:59:26 +0200 (CEST)
Message-ID: <6d91b973-e448-4271-b29e-c16fc137cd84@hogyros.de>
Date: Wed, 15 Oct 2025 13:59:23 +0900
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Adding algorithm agility to the crypto library functions
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
 Ard Biesheuvel <ardb@kernel.org>, Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
References: <d4449ec09cf103bf3d937f78a13720dcae93fb4e.camel@HansenPartnership.com>
 <20251014165541.GA1544@sol>
 <CAMj1kXHzGm53xL4zn-2fYpae2ayxL_GneWfHGunCXdtx6E1H4w@mail.gmail.com>
 <607ba12f2700e4a5bca9e403dd4c215d7cb6e078.camel@HansenPartnership.com>
Content-Language: en-US
From: Simon Richter <Simon.Richter@hogyros.de>
In-Reply-To: <607ba12f2700e4a5bca9e403dd4c215d7cb6e078.camel@HansenPartnership.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 10/15/25 2:32 AM, James Bottomley wrote:

> The question we'll get asked in the trouble tickets
> is why won't the kernel process an object my TPM created.  I'm happy
> saying because sha1 is deprecated [...]
This is largely a policy decision, though, so it should be left to the 
user, perhaps with a default of "following NIST policy."

    Simon
