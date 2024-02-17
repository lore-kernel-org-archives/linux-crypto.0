Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF55EAE5;
	Sat, 17 Feb 2024 01:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708132496; cv=none; b=iuBmVM4jophgkVujNHfzPq2vit6KgAxJcj/wVt7DLMjAujaPm2OWXRBPYt38yLvjZARxE+8q+kURlm8j8VtM0SnABwzynvmX6MkLzIafYOxz+mhngBDrnWenPKTJSkP3znd09nJNGhrRehgAKN2kSxSQgwTTbGcrkURfXb4j42c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708132496; c=relaxed/simple;
	bh=JPF+RFjKw6dUIB7ZZ0FoadsX3htbekSZ0TJYsyYTNRg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QyQzm2u+yFtpXdlEkHQ+vT9QHam9mCX6yjfUALLh5n1iusI/b8IdG+6tVpLGdMFKZLlByFQY1+CzqPFCVRFsKwbEtajx33ykBXdJxoU97nvjkIRYVoAYjUoqaNCbjPa87sEbrE33l2Pbo640zHWyonE6rVprFswA0FtZXE63sGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rb9I1-00EeTG-M9; Sat, 17 Feb 2024 09:14:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 17 Feb 2024 09:15:03 +0800
Date: Sat, 17 Feb 2024 09:15:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Damian Muszynski <damian.muszynski@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	stable@vger.kernel.org,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH] crypto: qat - resolve race condition during AER recovery
Message-ID: <ZdAIl2MfFDYVgQg8@gondor.apana.org.au>
References: <20240209124403.44781-1-damian.muszynski@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240209124403.44781-1-damian.muszynski@intel.com>

On Fri, Feb 09, 2024 at 01:43:42PM +0100, Damian Muszynski wrote:
> During the PCI AER system's error recovery process, the kernel driver
> may encounter a race condition with freeing the reset_data structure's
> memory. If the device restart will take more than 10 seconds the function
> scheduling that restart will exit due to a timeout, and the reset_data
> structure will be freed. However, this data structure is used for
> completion notification after the restart is completed, which leads
> to a UAF bug.
> 
> This results in a KFENCE bug notice.
> 
>   BUG: KFENCE: use-after-free read in adf_device_reset_worker+0x38/0xa0 [intel_qat]
>   Use-after-free read at 0x00000000bc56fddf (in kfence-#142):
>   adf_device_reset_worker+0x38/0xa0 [intel_qat]
>   process_one_work+0x173/0x340
> 
> To resolve this race condition, the memory associated to the container
> of the work_struct is freed on the worker if the timeout expired,
> otherwise on the function that schedules the worker.
> The timeout detection can be done by checking if the caller is
> still waiting for completion or not by using completion_done() function.
> 
> Fixes: d8cba25d2c68 ("crypto: qat - Intel(R) QAT driver framework")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_common/adf_aer.c | 22 ++++++++++++++-----
>  1 file changed, 16 insertions(+), 6 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
