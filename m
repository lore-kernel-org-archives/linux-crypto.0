Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899DC198A32
	for <linux-crypto@vger.kernel.org>; Thu,  5 Sep 2024 11:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725536479; cv=none; b=HOEvnHuh6ftgU0oz24XIAMvLxIAK4KMSC5Hnvpmu/keYPNxI3+saSQ3c0S1RxKLd2gwI5R3UMo+Im+PU0MC7Zf+2WyLieM/JNdBaDjOmTwVU9r4K8jeVLdY3fBSrid0vCxwh6GHoRoS63YAa2FPygaiLKSbRcW6YPTPFcsveppM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725536479; c=relaxed/simple;
	bh=2QEVjx+MlTHhoVGdzHum4LU9/N3eoTsARlC2If8rVuc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VmPVGBjrIM1/cIRydULHAEbLEKAb1hQhVQwe94A8z0e1chHmP+fOsQ7zGPWQRQCdXsuBbajzNwxmllSYPdN40V0A9rGamjyu2qU+sT8bYmJOtzmqoJSohGnIPba2IK2kB3jOIHqPAaNgd8R9zaoIEeP1cA0V/NSYiyWlnraXFJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=Yvp3RQyC; arc=none smtp.client-ip=209.85.219.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="Yvp3RQyC"
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-e164caa76e4so764389276.1
        for <linux-crypto@vger.kernel.org>; Thu, 05 Sep 2024 04:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1725536476; x=1726141276; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HtSAX+216jMJtoMBnL6lxxSTsEgCZuMZElWXjk6/+cs=;
        b=Yvp3RQyCdzDLzHvMyzaFR0WjZbpVthRjmZV16DkipODk7eBQBx07JX5sWyU3y8WdCm
         Fr7jqdg66xbNNm3snogQAwyPeKXcxxOh8vciu6YL9Sd94nG6U/8FDuaqEN7WWWlIa+LR
         DiNZP9yTGlOtGDvQztUWjScgJkXjpuGAQ1mq4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725536476; x=1726141276;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HtSAX+216jMJtoMBnL6lxxSTsEgCZuMZElWXjk6/+cs=;
        b=slRO7aIDEdtMHXwrH4ITTYwL2dESgLyWKr9u+r+yLmEQp5Ojumr08DAPR84YAHk6VU
         iuU7ucnkuntXy+UhK966U55jH54wVTIBDQcjQdhG0hKCJbGscQON6jcWV8r2G4Hf2GaJ
         rcvKBXpKqharqzRPqfMCXAA6e8cIuWBCWv28mpj80gPNMBVNfFQshG/HBiM9y9Ai8NI/
         gdaw/gvYja/iphdd8QCBUe+BinO51j+d17I6o1GkBn8dLXQXHEp/b661Qg5mKGxDtL5w
         sKcf4GipYPz7VWE35rX0aX7BUB0PEQY43rD/AngIcwJHTds0aqqmav/pV5W2lGJXTzOS
         CyAA==
X-Forwarded-Encrypted: i=1; AJvYcCUJYSRWGj15tx8hMkL/Mh0Q+sD5j5i4h9W5QP0JBauH7ukv0B1Z5+DipRKqiFzSI6CUh5QZ9kQ16CL240s=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGc9Kg98H/U1RilUtDX4eHgkqLD/yHfRg6kIgmwE6WrEMI+0To
	lB+gp80Yn4MEg4D27jTo7tOnXHUSA/1gTwB80gzObsSjaTxCnn0zCbnk8oDkw+v9KBAecNvhWGN
	UNqtG2OknKcX+6mrm+pw9AGl+1xF4H7oOu38fwg==
X-Google-Smtp-Source: AGHT+IGi8wnzScNEI8rFGJKFdFpGKefsVcSO7Wjmuh/fMkmZRpwfghLLZ3eHyH5VZeYlpTtAE1G4tBzNx+S88y+oIig=
X-Received: by 2002:a05:6902:100b:b0:e1a:7830:c6e6 with SMTP id
 3f1490d57ef6-e1a7a02eae3mr22145812276.27.1725536476520; Thu, 05 Sep 2024
 04:41:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240729041350.380633-1-pavitrakumarm@vayavyalabs.com>
 <ZrcHGxcYnsejQ7H_@gondor.apana.org.au> <20240903172509.GA1754429-robh@kernel.org>
 <ZteU3EvBxSCTeiBY@gondor.apana.org.au> <CALxtO0=PTBk3Va-LcRfTKUb4JCSDB0ac6DBcGin+cwit_LDCDg@mail.gmail.com>
 <ZtfUH0l-bDzLaj25@gondor.apana.org.au> <CALxtO0n==jLP=5cb3yJduFgbP=vdZ3FNX4OpCv2K1uoaqYbPEg@mail.gmail.com>
In-Reply-To: <CALxtO0n==jLP=5cb3yJduFgbP=vdZ3FNX4OpCv2K1uoaqYbPEg@mail.gmail.com>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Thu, 5 Sep 2024 17:11:05 +0530
Message-ID: <CALxtO0kCrhM-T79CwnYCMACQ-_EKu8Ptp9O=GWbpUk2O45VfxA@mail.gmail.com>
Subject: Re: [PATCH v7 0/6] Add SPAcc Crypto Driver Support
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Rob Herring <robh@kernel.org>, linux-crypto@vger.kernel.org, Ruud.Derwig@synopsys.com, 
	manjunath.hadli@vayavyalabs.com, bhoomikak@vayavyalabs.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Herbert,
   I have pushed the SPAcc driver patches and the SPAcc DT bindings as
a separate patch.
   I have pulled in all the fixes which had been merged.
   Requesting a review.

Warm regards,
PK


On Wed, Sep 4, 2024 at 9:11=E2=80=AFAM Pavitrakumar Managutte
<pavitrakumarm@vayavyalabs.com> wrote:
>
> Hi Herbert,
>   I am pushing all the driver patches again (with the merged fixes) and w=
ith the DT bindings.
>
> Warm Regards,
> PK
>
>
>
> On Wed, Sep 4, 2024 at 8:59=E2=80=AFAM Herbert Xu <herbert@gondor.apana.o=
rg.au> wrote:
>>
>> On Wed, Sep 04, 2024 at 08:24:42AM +0530, Pavitrakumar Managutte wrote:
>> >   I am pushing the incremental patch. Please review it if the driver
>> > it not reverted yet.
>>
>> Sorry, the driver has already been reverted so you will need to
>> repost the whole thing with bindings.
>>
>> Thanks,
>> --
>> Email: Herbert Xu <herbert@gondor.apana.org.au>
>> Home Page: http://gondor.apana.org.au/~herbert/
>> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
