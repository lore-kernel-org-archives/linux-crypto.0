Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B85F28A405;
	Thu, 24 Jul 2025 18:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753381803; cv=none; b=Sd4xA4FgExmOf4L2HmuhvC3RrSOys+sWkoIKa/RFhXlS1K2sgiTpGLtWTMBRjDvmXP4R42QLyG1OaPRd2CPRAI9tyxwVm/QmfdEenm2LNjTUvaaC3qSy1umQYlyqs6QXpKPFeCJl9HU9oJNBOBUpWVpsgcW/tstlJA+A0Ci0plc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753381803; c=relaxed/simple;
	bh=EpaMIxWsBUPuhKYaLifcZ0NMSt1WzkvvfjimSjf3bwI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RiZIYjCs7B4y4SeG/L42VKXUD0JcbDoulbNhq9nTFHffNqz0G0vNfIk3GoKwCRw6g0py0TzDfvpb7c3BpS8sKsfn7sysn1ClHLvv9XK8UwD27AP7ex1U/n0AEG1t0zk+WI5FQyzHNBstfOKOC3pRSZsKSd+b8zPqeIIt8oguLgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jNJHIdcA; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jNJHIdcA"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-23636167afeso11908095ad.3;
        Thu, 24 Jul 2025 11:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753381801; x=1753986601; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WaAiBzsaAc/lbPRxNN6yjLeFfWl5531LYpt2gKVqrbA=;
        b=jNJHIdcAluwImWojp5a20P1Sz49qQ2CZEDnfj2CHGKv/SZRN9jD4+7G/WdAX7v0Cm+
         GKyL60XO2+e1rlI+oZDT48AUxqF/l1VJowFiUlcL9f6wjTlYgrIVYXq2VHp6PicQvcmN
         5mHLsUrNPwrEEk3i5OdAHu8KxEFT+WnCd8llChkwFfUrQhxszvWo7qQvhJ2p57Ggtupy
         Zdu+ub+J0Ze/fRijTWgfcx5pLnWROpq7O2NyNFdX941mOZNBSMxBoPdzzQXwh3Cztik9
         XLyU62j0SLxmni3ZsH6mTfAphZh16wNlgAIJLz6dAus4lsJmGuJ3a81/fpLuW4+9Esfl
         dDTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753381801; x=1753986601;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WaAiBzsaAc/lbPRxNN6yjLeFfWl5531LYpt2gKVqrbA=;
        b=smm/9iivZrUzF4piJ6hwGoCw2XsUwG3P+6yszkc0BJU91ccRPo5oyTFilw3WcZBaVE
         ogLju4dzX+mH1QW9uKAyzRrA4IBR+UZxAtn3xGhaCO5amLC2XwVnU2rvBgsrTl8h6Gnf
         nltNfE88seNIYf/2lPawUVrlsoxUjqVtFUwusQn1U9SMHlXn4tdIDEk/sLaOqYv7tZ57
         gXBvVoJKGgPVTqX88+0i+5PpbjvDBl3VYhXyBphNOZQI6NoDQXSVCyce1W3s6GOt9h+7
         SeVUN1jllZMLE40MKiQT6A11ntVs/7W833uQE5RtWkWPFbMc2i0OmBo3eFwbm61z6M/C
         u/TA==
X-Forwarded-Encrypted: i=1; AJvYcCUwyUiGHXJvax4cxC5ubFmqah6WQhB8LoxXJS+wWNVwbmm9//MxIxxhpYMS8Jye5yrOWIJnfLy8luf3vhGO@vger.kernel.org, AJvYcCVYRGeBbUfrHfZes/q8RYzc9fzPsP4mLwKKaGGl7p2Tbum3pE+ZgANlL/snrzq5EOy/UIpCSdwyGYPrRzc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzfie4IFmJDSdIw86OzarfAiVKfWhNuIQLnzJaO9NJen/2gDRfx
	WyBEI6WgPJkAHz77kOXPUqdsaoJg+gPwl7RAPymG7ya98XJhiQTes2wS
X-Gm-Gg: ASbGncviy9M+rEhQuQFZDk9kbmL9pNQ2tcZ9V46NTSmDOI3EPAIPx4pgodLh6qXS/kC
	cv9tu/dOSyNNgioSabcSW/Ru7PXlwR6QvWqYyG3fMzThUNmOMcMPY8wMm3hmGKsOIItJ0Fseuai
	e65urSUtSMQqf3kTaCvBKE1SAQjSZT6NR9fKy1zpUW4Qm8Bm3igkDxBxjou53DrBa6+Wr02Ln4I
	U8xHAlz+G61CZyT3OndjtiY0W5sj9oGXpNJFA0RLr2e41OYOu3gBPb5vzarhkx/W+ZDLAVU85As
	3/E4XvaH4pUQ5zIJ/lMCeMhmnC6plox3u7OuHlo+7p/DJaUiYHO1dbHK6/xGn8HqBP+EeZmgJbD
	nr/p3naOFBuOdIMSWBAXgWEYE2MxZB5GgYNo=
X-Google-Smtp-Source: AGHT+IGRfjee+c8gg5iN2tNL1LkNioumGX4ihN3LxA3wTboZxTKi2NJ9OUnmuBQgdXUKZS3K6AvLNQ==
X-Received: by 2002:a17:902:cec4:b0:23d:fa76:5c3b with SMTP id d9443c01a7336-23f9814e9a7mr127456245ad.22.1753381800503;
        Thu, 24 Jul 2025 11:30:00 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fa475f7fdsm20823965ad.17.2025.07.24.11.29.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 11:29:59 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 24 Jul 2025 11:29:58 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Eric Biggers <ebiggers@kernel.org>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: tests: Annotate worker to be on stack
Message-ID: <b4bdb833-5fdd-48e6-989a-1d4059e9cd81@roeck-us.net>
References: <20250721231917.3182029-1-linux@roeck-us.net>
 <20250722031603.GA1298@sol>
 <a534e0ad-35db-45f5-a1c9-9bd34cd3dafd@roeck-us.net>
 <20250724162615.GA26800@sol>
 <57d41f7c-44ea-4097-a7ae-458e785fd694@roeck-us.net>
 <20250724173657.GB26800@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724173657.GB26800@sol>

On Thu, Jul 24, 2025 at 10:36:57AM -0700, Eric Biggers wrote:
> > 
> > Configuration file and decoded stacktrace are at
> > 
> > http://server.roeck-us.net/qemu/crypto/
> > 
> > Please let me know if you need anything else.
> 
> Thanks!  It seems the kconfig is actually unrelated; what matters is how
> the kernel is being run.  It reproduces only in QEMU with KVM disabled.
> It doesn't reproduce with KVM enabled or on bare metal.
> 
> The crashed instruction is 'vinserti128 $0x1,0x30(%rsi),%ymm8,%ymm8'.
> 
> I think it's a QEMU bug: its implementation of vinserti128 reads 32
> bytes from memory instead of 16.  I'll report it to qemu-devel once I
> have a bit more information.
> 
> It will be the second QEMU bug found by the crypto tests this month....
> https://lore.kernel.org/r/20250710052824.GA608727@sol/ was the first.
> 

Oh well :-(. Thanks for tracking it down. I'll disable this test
for the time being for x86 tests. I'll let you know if I see it
or something similar for other architectures.

Thanks,
Guenter
