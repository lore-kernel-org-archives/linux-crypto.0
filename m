Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2345413FD8E
	for <linux-crypto@vger.kernel.org>; Tue, 23 Apr 2024 17:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713895163; cv=none; b=BrMzbPeiWB8n9LPcJ/B34wirxOXfsTHr7juYBX9QC5ZoWLWL9idKrkTEmKbN/aruP1acyoX/L6bB3lmk7YhChT+jN3ONapfrdNIYRNTIWI/LGY5/Bo4w5v8Ps7PoGhYhN45ZMsgKOXunszrzl4jqa73M9vcKerc3+M3Z4ycvuTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713895163; c=relaxed/simple;
	bh=/QM7xbwXSMIsTORfyD6ZF9d+C2sqkJU3CAFveILaYp0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TfA7bQrEd38QRwdFUhSuShpESb45jNYLJI7AFyCtGTx3MdN8SrafPdXbHtW1suZtSJ7mjEc4JG14QBjxLnSiEebuZJEYvZ6zdFJEaAQbJmLtvvucSk6UyoNgM7BvsAGzJsJeHGAC4+5SpIIUSS5fQNoe+wq/L5Z9ojDuJTFZcxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=cpdngGVh; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="cpdngGVh"
Received: from [100.65.128.125] (unknown [20.236.11.102])
	by linux.microsoft.com (Postfix) with ESMTPSA id 5F5C020FFC2F;
	Tue, 23 Apr 2024 10:59:21 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5F5C020FFC2F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1713895161;
	bh=TNqB+ZhIOhoyajBObdpT8tOY1r1hHnd2LZ83wPlbrj4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cpdngGVhhVJ9mNg4pL2qoZHaf5XdPpTfq3Ygy1ikSDbxcQbGA4Z0bQsmSJWZPMut7
	 Ra8mXJgF+PH0n61uW75hnk55DgIJXC1v3dQ17dHHA02zVXI6Uweu/xoolZhBZksx2+
	 nXmRWujvABmEnVXrlglb1LfdqNs/tXcRn/EGLF0Q=
Message-ID: <1eb6f953-7c4d-4dc8-aa31-cd47810eb6a7@linux.microsoft.com>
Date: Tue, 23 Apr 2024 10:59:20 -0700
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
 <5f3af250-da94-410f-858e-822b974b14bf@linux.microsoft.com>
 <CALxtO0moQmdki44w9j1B-41925YCQ3-1mrbbGcoOXroKMaVsYw@mail.gmail.com>
Content-Language: en-CA
From: Easwar Hariharan <eahariha@linux.microsoft.com>
In-Reply-To: <CALxtO0moQmdki44w9j1B-41925YCQ3-1mrbbGcoOXroKMaVsYw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/23/2024 4:12 AM, Pavitrakumar Managutte wrote:
> Hi Easwar,
>    We have broken the main driver patch into 4 patches as shown below
> 
>   LOC    PATCH
>   4979 - 0001-Add-SPAcc-Skcipher-support.patch
>   1470 - 0002-Enable-SPAcc-AUTODETECT.patch
>   1283 - 0003-Add-SPAcc-ahash-support.patch
>   1333 - 0004-Add-SPAcc-aead-support.patch
> 
>    138 - 0005-Add-SPAcc-Kconfig-and-Makefile.patch
>     33  - 0006-Add-SPAcc-node-zynqmp-dts.patch
>     60  - 0007-Enable-Driver-compilation-in-crypto-Kconfig-and-Make.patch
> 
>   I have NOT broken the first patch into a "core" and a "skcipher"
> patch because the core patch
>   will throw warnings for "Functions defined but not used" if applied
> standalone during kernel CI/CD.
>   No compilation errors, so nothing is going to break; but there will
> be warnings.
> 
>   Core patch provides the infrastructure that cipher, hash and aead modules use.
>   I will check with the kernel CI/CD team regarding this but do let me
> know if you have any
>   details related to this.
> 
>   If thats not a problem for kernel CI/CD, i.e. if the kernel CI/CD is
> run only after all patches
>   are applied in order, then I can break up the first patch further
> into two. So the core patch
>   will mostly be around 4k Lines of Code.
> 
>   Do let me know.
> 
> Warm regards,
> PK
> 

<snip>

I think it's ok if you don't split (the new) patch 1, because it's not just a matter of 
kernel CI/CD, but also of allowing future bisects to build with -Werror=unused (or Clang
 equivalent) if that's their methodology. I would go ahead and post v3 with the breakup 
that you have shown.

- Easwar

