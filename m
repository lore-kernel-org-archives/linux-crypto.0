Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48CBA1E48A
	for <linux-crypto@vger.kernel.org>; Wed, 17 Apr 2024 17:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713375519; cv=none; b=sCzggrkybFuzoOpckOvYMHEavVSOxcQ+q8zpqT8XXmilPhXc5RPIhJVakW+lNk2iyojJKTc3l5f6oZIXJgu65B9qFBaq/ACiBbbzSw55UzeTYXKkadn9D1s6c3oCk7W/O1DnekAE628SaUqajTH5IyE92i7u/ovX3cfTJu2vsI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713375519; c=relaxed/simple;
	bh=BkgRqVzpiBJbsQdtCxhJw29Yr/Le+gOVYZw2LkqhlU4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QJKN5D3ojORAJ8Yh3UMXetzWyCzFtpPI81ComKiO3yd9RlQvJsg8b7utapopB5pRrLQQ7UrD9iX9L2VY7L589Q5e+Zxe+daMtXa76wmbfl4eeKjjXbIDbCjZGDQ+nFKPDnPCkqiFyaE7L5C2Cfxfigl1Wm639wwZ4jEBlYcA9TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=WVu/xEt4; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="WVu/xEt4"
Received: from [10.137.193.18] (unknown [131.107.159.18])
	by linux.microsoft.com (Postfix) with ESMTPSA id 1101420FD463;
	Wed, 17 Apr 2024 10:38:32 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1101420FD463
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1713375512;
	bh=VIPtpUDr+q+7J5J6xpR9HqVNcJK6mWPGfCLaHzJ6+NM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WVu/xEt43JYedQjob3MO31UECv+6j4Kt16v20sRu/3m5WitRX0pSb0C1YKQEnZOJV
	 4weUHd4eoUN/nxFd4XFExIDtX6NXZrLxzhYJLyR/6K9NkQd74v0qi3w22LjPjzdmM4
	 3A8u+JqA0KuB5p+SAI2cagCeevz/TyVT9Q7WMtT4=
Message-ID: <51a5305d-04d2-4c6b-8ea3-0edc6e10c188@linux.microsoft.com>
Date: Wed, 17 Apr 2024 10:38:31 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] Add SPAcc driver to Linux kernel
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
 herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com,
 bhoomikak@vayavyalabs.com, shwetar <shwetar@vayavyalabs.com>
References: <20240412035342.1233930-1-pavitrakumarm@vayavyalabs.com>
 <20240412035342.1233930-2-pavitrakumarm@vayavyalabs.com>
Content-Language: en-CA
From: Easwar Hariharan <eahariha@linux.microsoft.com>
In-Reply-To: <20240412035342.1233930-2-pavitrakumarm@vayavyalabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/11/2024 8:53 PM, Pavitrakumar M wrote:
> Signed-off-by: shwetar <shwetar@vayavyalabs.com>
> Signed-off-by: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
> Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
> ---
>  drivers/crypto/dwc-spacc/spacc_aead.c      | 1317 +++++++++
>  drivers/crypto/dwc-spacc/spacc_ahash.c     | 1171 ++++++++
>  drivers/crypto/dwc-spacc/spacc_core.c      | 2910 ++++++++++++++++++++
>  drivers/crypto/dwc-spacc/spacc_core.h      |  839 ++++++
>  drivers/crypto/dwc-spacc/spacc_device.c    |  324 +++
>  drivers/crypto/dwc-spacc/spacc_device.h    |  236 ++
>  drivers/crypto/dwc-spacc/spacc_hal.c       |  365 +++
>  drivers/crypto/dwc-spacc/spacc_hal.h       |  113 +
>  drivers/crypto/dwc-spacc/spacc_interrupt.c |  204 ++
>  drivers/crypto/dwc-spacc/spacc_manager.c   |  670 +++++
>  drivers/crypto/dwc-spacc/spacc_skcipher.c  |  720 +++++
>  11 files changed, 8869 insertions(+)
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_aead.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_ahash.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_core.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_core.h
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_device.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_device.h
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.h
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_interrupt.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_manager.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_skcipher.c
> 


Sorry, cannot feasibly review ~9000 lines between my other responsibilities. As mentioned in v1,
make it easier on the folks who're giving their time by splitting up the series.

Thanks,
Easwar

