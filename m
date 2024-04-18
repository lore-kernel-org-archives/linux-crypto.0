Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8CC3171E6C
	for <linux-crypto@vger.kernel.org>; Thu, 18 Apr 2024 17:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713460397; cv=none; b=a3vW+B3bKt0fkImcuZuVS6BjZdJnPRprcUkZZ8AiqVEaJMAWmiTLR3nhNL7swmCAl1mPvQAGq53dyVt/RlQZKOphHAua9q5GMufbbGrCM+sccAl4m0hsFkl9PD31mUP5FCs4yL7wxbjDrx7FrKPe3tUJ7VfHqEZNkTZteKKIrHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713460397; c=relaxed/simple;
	bh=cKl7vVw/m77nL3WLLLN3W+8x33YckJRuttk/sqUEfGk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=McJiVVkd6joomnCplhtRwnVomQoI+lWDkwlGeL7NYAG5UHFCLUxNksZPmHvByCHslrNuu9VmtbTFzO/BhYOrRGtmHHk8SLGdgNKFT+q3ZTqouXUDrBRXTRVnsrRzvL95wFUH69mWzs71vgiWC3sEI6YxHwr7p7lG4DFh/Z9BKU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=NnxptRXP; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="NnxptRXP"
Received: from [100.72.0.75] (unknown [20.236.10.129])
	by linux.microsoft.com (Postfix) with ESMTPSA id 4051220FD8CD;
	Thu, 18 Apr 2024 10:13:15 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4051220FD8CD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1713460395;
	bh=PKVAUvObaRtj45+ZpVtop1cEHTreFiwy7hRfqnJ/n7I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NnxptRXPlGnGEbxr9FDdGH6De3BXr4mjn+q++3ab/IKHwnIwdeXolB6emHHO+Uwno
	 vnSAt3n589SOZq2wREQmv/PcEVLHpCuS7GioWM0wcMcex3t2jOD23lhJXrDHB6FLon
	 hSO+j7d7m6+CfJhL99PyozgaGXKBmaJG1pHqU/vc=
Message-ID: <5f3af250-da94-410f-858e-822b974b14bf@linux.microsoft.com>
Date: Thu, 18 Apr 2024 10:13:16 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] Add SPAcc driver to Linux kernel
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
 Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com,
 bhoomikak@vayavyalabs.com, shwetar <shwetar@vayavyalabs.com>
References: <20240412035342.1233930-1-pavitrakumarm@vayavyalabs.com>
 <20240412035342.1233930-2-pavitrakumarm@vayavyalabs.com>
 <51a5305d-04d2-4c6b-8ea3-0edc6e10c188@linux.microsoft.com>
 <CALxtO0=UT=KDY+WzZcdVj6nwPfcsmQVTCpmRGx65_SZvh91eqQ@mail.gmail.com>
Content-Language: en-CA
From: Easwar Hariharan <eahariha@linux.microsoft.com>
In-Reply-To: <CALxtO0=UT=KDY+WzZcdVj6nwPfcsmQVTCpmRGx65_SZvh91eqQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/17/2024 8:54 PM, Pavitrakumar Managutte wrote:
> Hi Easwar,
>    The driver has legacy code which was taking time in splitting, so
> pushed the v2
> patch without splitting. I am splitting AEAD, Hash and Cipher module code, which
> would be easier to review instead of a single 9k loc patch.
> 
> I do appreciate your valuable time and feedback on the patches.
> 
> Warm regards,
> PK
> 

Thanks, I'll wait for that v3 to continue review.

- Easwar

