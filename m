Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2865240096C
	for <linux-crypto@vger.kernel.org>; Tue, 11 Aug 2026 20:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786479515; cv=none; b=JhVCq5+dSeZcKech2Hue93xToSc/zVMflzVjZWS4ToeqRX0OyEFqBxebful+UZYy6TiOpgPPGsnKCLX+GXNoAfImjPi+ZUf3hMhe++4OmmRxcqNHSEXwEzj0Up8nDAJHptCcOH+FUzGKKapVzm1jsH800G2mIXYiNGKKUe1GoUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786479515; c=relaxed/simple;
	bh=ccUlQITujjKDxvsizPgp3QY5vJYvUp9kjFimThDnMxk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oYSYbOdC5Z/IGt8FW+CynGgiUHsmzY6o6kSBcJHBLTAH6agL88hNBa2ruXI3Ay/9/FAPvXwFmEpYyHylQd+n2f+3z5I7Ne3BBbIVCtKJFcgh/0rLXuI45cLxQznWM4lTxeCvDFBtV7WBZNxs2or5T9X56tZASFWjQeU2G5n2zck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pa7YLGEj; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pa7YLGEj"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-47db714766aso891503f8f.0
        for <linux-crypto@vger.kernel.org>; Tue, 11 Aug 2026 13:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786479511; x=1787084311; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JFLe6tkLYuEC2gnEl/GsgjOSVqwPRw7abghLXfye9/g=;
        b=Pa7YLGEjq+OIlzTFZMUQczrnv8nhodyrexeB8TosOw5rd2s7hrHMHVv2IxRnKOxePx
         iHhHvEtRUoR06HeffIfbA0Ffu7+N9K4t0D/dC6xnu+gHofT7gtQJ5iVnjqtTZJ3lNEGE
         2n/+ciBMi4W3n3MVJz6jXrIBlQubrTfFR7rXzRp9Plqdd9Kk/ub2nnX5WyOzstA/t1YI
         kR0GvxM1Z/phs/XDzVJEs81p4NjrhUei7611y8D/QTZk1Z+g9SNQ4U+zVR+J8pIS23NP
         SsT8q8ZWd+UJOgKSnCoe38k2JzvrEemASF53MWxAqvL51fYBLWe6KY4pZYDHyWaGdCIq
         Wqzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786479511; x=1787084311;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JFLe6tkLYuEC2gnEl/GsgjOSVqwPRw7abghLXfye9/g=;
        b=hubWkaeOBcoLoE8lbSaVXvKGvKYBXdSSdyLnl80bMLO17jnLimK2kJsgZWcxifma22
         DD6pXaHjYls0pDCpVLA0rVjZg/1a8cHeWONfckpq0/dceHo40eg3JmAx5IKUcj3xYPna
         moBnsaCbLNU3Ba5M6bRiezIK/uLi9qmZYSXTfzgZKm7eKa8+yNSOMVIRFNr82AInR/QY
         pdi83NA1DrB9jz0ZWKLWvXgP5CVO5DDWYUXyb7cGhYdHi8OGIox8CA1hjJYQdhc8Zrp7
         A/36pL4F1E94nNigDToQThhrSPKRSZIyHpWkcO3A3D3bXYu/l9GHJIEJdAnisdN33rPM
         sqaA==
X-Forwarded-Encrypted: i=1; AHgh+RqR+swWmeKa2fwO+p3QY9uq2ZPDAu8bNewjRZHgnSQTcKTZR5Z3zWEZjXdYZbH5tcNN6BSiN8oO+SXSlWs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3f8C5yzHlIC63eXiouCUwXe6voeaMK/hNMR2PIs5HBMn1jpyG
	zkBwvmPuIP//tHx0m29trdKdPqVUKsdk8MUQhAWll6HSDKsmssNn4Gdg
X-Gm-Gg: AR+sD11twVp/woQAGmiwzU/Ux7xrv4L5eFarYY65z9p8mavzBrmtz+kLAyXUFPtQR/R
	CUhWnB1UJd+I4m/Q0cjuflOl4jKnUPxWrUSDftMB0lnpwhCgTTqlqlMpeNL+1a4BGPWFqzkmJuS
	daF8YKLld6SPiEa3td+mAB1abB088gNJx9uasvHDkeKmfokEN3tovY13/UXx3B6yMiMLHiWb3ua
	logn+2RvRbq8TrUbSninH/VSxGR3u9uJD0+ZaRaANu64NVpCCfdOcJRQwTMhDvQW0PAhL2xOMX5
	lPh0mppxIdQuzRTnc27moSs0t2wVhecclAHop+4WqpmKe2tMI9VNV5oTiJ41T0WirhVJj7wBbct
	JKQMIafNSNow6UVFAsQH1BgMnTxfbeyNbOONwFNoMQktmrYN+SLbGShOY6q4E/3wMJEX5IpcKI3
	Wx7Lv3Rys2klbbXjI1nIkGnyb1lNWZ/tXjMiQQ88TqkhGkleVKg4ap/xS8sfCOFhyz1zK0Grjnt
	49fwmnVnpkFGQ==
X-Received: by 2002:a05:6000:430d:b0:47f:e7f9:5251 with SMTP id ffacd0b85a97d-4814ffe28b1mr3367485f8f.3.1786479511163;
        Tue, 11 Aug 2026 13:18:31 -0700 (PDT)
Received: from [192.168.2.14] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48150bf5c5fsm976683f8f.3.2026.08.11.13.18.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2026 13:18:30 -0700 (PDT)
Message-ID: <8654c2d4-8d9d-43f5-9256-adf2915209e9@gmail.com>
Date: Tue, 11 Aug 2026 22:18:27 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/13] dm crypt: wipe key material before kdump
To: =?UTF-8?Q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
 keyrings@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-nfs@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-afs@lists.infradead.org,
 netdev@vger.kernel.org, linux-fscrypt@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, dm-devel@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>, Baoquan He
 <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, Dave Young <ruirui.yang@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 David Howells <dhowells@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>, Lukas Wunner <lukas@wunner.de>,
 Ignat Korchagin <ignat@linux.win>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Keith Busch <kbusch@kernel.org>,
 Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, Trond Myklebust <trondmy@kernel.org>,
 Anna Schumaker <anna@kernel.org>, Mimi Zohar <zohar@linux.ibm.com>,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 Marc Dionne <marc.dionne@auristor.com>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Eric Biggers <ebiggers@kernel.org>,
 "Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
References: <20260811-crash-zeroize-rework-v2-0-9561d13c2340@jaseg.de>
 <20260811-crash-zeroize-rework-v2-13-9561d13c2340@jaseg.de>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <20260811-crash-zeroize-rework-v2-13-9561d13c2340@jaseg.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/11/26 7:53 PM, Jan Sebastian GÃ¶tte wrote:
> Wipe volume key/iv copies kept by dm-crypt with
> CONFIG_CRASH_WIPE_SECRETS. The backend tfms are already handled
> separately.
> 
> Add a list tracking struct crypt_config instances when
> CONFIG_CRASH_WIPE_SECRETS is set. Structs are tracked here to avoid
> having to enumerate them through some roundabout way before kdump, when
> we can't safely take locks anymore.

Well, dm-crypt has crypt_wipe_key(), which can be called through a device-mapper message.
It also sets keys to zero in the crypto API.

Why do we need yet another way to wipe keys here, reimplementing everything twice?

I can imagine an emergency wrapper callback that will suspend dm-crypt and call existing code.

> Use custom wipe handlers even for things like ivs that have existing
> wipe functions elsewhere because we need to use crash_wipe_memzero
> instead of memzero_explicit. The crash_wipe helper memzero_explicit's
> the target buffers and flushes data caches. On ARM64, missing that cache
> flush could lead to the zeros not being written to DRAM before the kdump
> code turns off the data caches moments later.

Please no. It looks to me like you are trying to fix this on the wrong layer.
This way everyone will need their own memzero...

Dunno, but I really do not like dm-crypt becoming completely bloated with code
that has nothing to do with the original purpose of this driver.

Milan


> 
> Signed-off-by: Jan Sebastian Götte <linux@jaseg.de>
> ---
>   drivers/md/dm-crypt.c | 151 ++++++++++++++++++++++++++++++++++++++++++++------
>   1 file changed, 134 insertions(+), 17 deletions(-)
> 
