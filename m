Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53276201279
	for <linux-crypto@vger.kernel.org>; Wed, 27 Nov 2024 18:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.62.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732733970; cv=none; b=HiUe4L33XWwY9fBMdQmLrAA+9YlMZzR5soIYulUbkrjeV3y8Vh0s5aYhBMRiVVlncdu4mCD5cFVQiOaD9rPbg/WEhmu8XIt34pcJpTn5n2sEIVo7IRJzijxI/YKyahOvz13TqrPBQsS/TOdtO+jFUPAMR2povZKtf+Ul2naEDww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732733970; c=relaxed/simple;
	bh=/imuxOh1Hqf011Yk1bMnQgHUMasJHcgBVT1sZLWpzZM=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=dnlJ5SnrfnsSUZxmBIMXXyVURlGWYhVLr6+92yO445bMYalVp/91VwS4201sbvYpsickyvB1teUZMOKoS2rP2cKTLPXMc8Dtee+WgiIe6zVdjzSb8+etCWGEsC2sB0zQeAaTx9jpOPv689F3ddlklVNG1wYD2agVXLI6O37RUzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=YTOPibfj; arc=none smtp.client-ip=85.214.62.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="YTOPibfj"
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id 0EB78897FB;
	Wed, 27 Nov 2024 19:59:18 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1732733960;
	bh=Z/HrkJo0/BODnVSbshEJQ2R7ff0HmfNC99GX46QxJ+0=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=YTOPibfjQdnukDuVfAtWkczch+kwZFRrfE9REyESg634zR/akAye7ITcql/ntvLj5
	 lKweL2E0GC/XtuCreKN70CxH8u2mXxPb64h3H67e6xz+f5Hl8m+kkooZaNK/ZYEKeI
	 hyikIMb2i3MFYbQmy21D7qEWPBWGl74LBtdPVihPNXYKgvgUx3wWhI3Pa9IPG/l/Gp
	 vb/56vJy0A6xsGqa+rd1rX08jwZ1xoW/jjbxYuGssA97OFOBztT5ZcXBbmbczoUemZ
	 lmjtEwIpAFDeELVgm97v57r7va2EUx+oofp26wVrnPkakZ2TmlNeB8f1gcgJv2kxrs
	 38VUOyqE7ljDQ==
Message-ID: <76ffb184-5047-4446-879e-2b42a7191b42@denx.de>
Date: Wed, 27 Nov 2024 19:59:00 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH 1/2] [RFC] hwrng: fix khwrng lifecycle
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
 Dominik Brodowski <linux@dominikbrodowski.net>,
 Harald Freudenberger <freude@linux.ibm.com>,
 Li Zhijian <lizhijian@fujitsu.com>, Masahiro Yamada <masahiroy@kernel.org>,
 Olivia Mackall <olivia@selenic.com>
References: <20241024163121.246420-1-marex@denx.de>
 <ZyX7ind-SnHoDt7E@gondor.apana.org.au>
Content-Language: en-US
In-Reply-To: <ZyX7ind-SnHoDt7E@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean

On 11/2/24 11:14 AM, Herbert Xu wrote:
> On Thu, Oct 24, 2024 at 06:30:15PM +0200, Marek Vasut wrote:
>>
>> @@ -582,15 +585,12 @@ void hwrng_unregister(struct hwrng *rng)
>>   	}
>>   
>>   	new_rng = get_current_rng_nolock();
>> -	if (list_empty(&rng_list)) {
>> -		mutex_unlock(&rng_mutex);
>> -		if (hwrng_fill)
>> -			kthread_stop(hwrng_fill);
>> -	} else
>> -		mutex_unlock(&rng_mutex);
>> +	mutex_unlock(&rng_mutex);
>>   
>>   	if (new_rng)
>>   		put_rng(new_rng);
>> +	else
>> +		kthread_park(hwrng_fill);
> 
> The kthread_park should be moved back into the locked region
> of rng_mute).  The kthread_stop was moved out because it could
> dead-lock waiting on the kthread that's also taking the same
> lock.  This is no longer an issue with kthread_park since it
> simply sets a flag.
> 
> Having it outside of the locked region is potentially dangerous
> since a pair of hwrng_unregister and hwrng_register could be
> re-ordered resulting in the kthread being parked forever.

Sorry for the late reply.

I'm afraid this problem is still present, since kthread_park() 
synchronously waits for the kthread to call kthread_parkme(), see 
kernel/kthread.c :

  655 int kthread_park(struct task_struct *k)
  656 {
...
  665         set_bit(KTHREAD_SHOULD_PARK, &kthread->flags);
  666         if (k != current) {
  667                 wake_up_process(k);
  668                 /*
  669                  * Wait for __kthread_parkme() to complete(), this 
means we
  670                  * _will_ have TASK_PARKED and are about to call 
schedule().
  671                  */
  672                 wait_for_completion(&kthread->parked);
                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                      This part .

The hwrng_fillfn() may call put_rng() which locks rng_mutex() for a 
short time, and if kthread_park() is called before hwrng_fillfn() calls 
put_rng() within a section protected by rng_mutex too, put_rng() could 
never claim rng_mutex and hwrng_fillfn() can never reach 
kthread_parkme() call, causing a deadlock.
