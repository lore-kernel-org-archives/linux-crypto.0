Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3190A2C190
	for <linux-crypto@vger.kernel.org>; Wed, 11 Sep 2024 13:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726062655; cv=none; b=Aqvj7rBnaa0L0whw0d966bvIgX+rTod/YJVHZgvbE/6HR6qS+bVlMonTQ+cSV+cLnUjA2IeiqULMFnCp8fV0EgQgUxA5EWNCE/sgaQReS21wbJVs15xDk3M+/ulce5iNtKRoYeljVmxxplfTYPph9G/9hIbgo6yB+vPaOcEH23o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726062655; c=relaxed/simple;
	bh=l8BPDo+1BuzydZyuFpIOELgJBeUFpbT9c1TtheG6HUc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ddHyR1pyIMMdYQSe0J4Tvkh6VjoUkJkpJYq8HPeIFsJsnZnsIcx0hUXSo3QKtsXmzmCMrosrC7edCbnqNz52QcsRsaM6E7kQlexvYjUlYl/EWwVm9aa9djWxEwbKZmZnmMkoLmh/P5+3V0pC2t2gceaiY/0jn+3/QaW8TvBcB9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u08ng2IQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u08ng2IQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4790C4CEC0
	for <linux-crypto@vger.kernel.org>; Wed, 11 Sep 2024 13:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726062654;
	bh=l8BPDo+1BuzydZyuFpIOELgJBeUFpbT9c1TtheG6HUc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=u08ng2IQz9jcVNd5BhTYtTH7+VCk6951/8/ddt4UazmhvvS2d8KFB1umXhecR110F
	 kEU+nZv8OEzTkDMQWxhSS3brUtVxRt9rOLaBqt7BU7ZByeda8LshKbiw3U1O+Ppgy6
	 9W/YA7LOlh3LNXuETw57PB4k9Dcq/qQh97zPB5FKaQtD2TWex6mW3KVN+fRpzMoT1b
	 etkZC6xYD1UxAWe5L/5PaQGD1ciXdo7gF5RO6lgBRAGb/O1jfF/W+pOEwOfBlUJnNs
	 Q/QvjLIgal/zwVKFxy+gebWi77ZN0F880zFWWQ23Ppge+Hoh2MoShMKc9yXfWN3rOv
	 Hm/BLvliB43WA==
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2f75c205e4aso50669661fa.0
        for <linux-crypto@vger.kernel.org>; Wed, 11 Sep 2024 06:50:54 -0700 (PDT)
X-Gm-Message-State: AOJu0YyaP/iqc2vAh/eI7jvFQlGIqY8jVFp+setTYn5IBXyKWdWBTX+j
	JMzvmjcVm08aQJAtN6XjwgAToF+78SVLIhyujLz7FUfcx9SxrqwQuB/CoBab9gNuFBYXIsExpFS
	zXQFMKq6ebdl6ouOtSuph1vK8IOE=
X-Google-Smtp-Source: AGHT+IFcu1h0nv6Aq93COeA8goXXJPxZZBSbdOFJeFrcEp6BtqaYCe1wNdDAzH6nFMqn68W1wAykl+sknGqZQX8GxYE=
X-Received: by 2002:a2e:4c01:0:b0:2f0:25dc:1894 with SMTP id
 38308e7fff4ca-2f751eaf1c3mr97359651fa.2.1726062653156; Wed, 11 Sep 2024
 06:50:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <SA6PR21MB418301113B9F45171814851DC79B2@SA6PR21MB4183.namprd21.prod.outlook.com>
In-Reply-To: <SA6PR21MB418301113B9F45171814851DC79B2@SA6PR21MB4183.namprd21.prod.outlook.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 11 Sep 2024 15:50:41 +0200
X-Gmail-Original-Message-ID: <CAMj1kXH7ubpkNQbSrvukvbJHnDDGSq+JWyMaPvPtUcYH=Mvsvw@mail.gmail.com>
Message-ID: <CAMj1kXH7ubpkNQbSrvukvbJHnDDGSq+JWyMaPvPtUcYH=Mvsvw@mail.gmail.com>
Subject: Re: Incorrect SHA Returned from crypto_shash_digest
To: Jeff Barnes <jeffbarnes@microsoft.com>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Sept 2024 at 15:17, Jeff Barnes <jeffbarnes@microsoft.com> wrote=
:
>
> Hello,
>
> **Environment:**
> - Kernel v6.6.14
> - x86
>
> I am currently refactoring an ACVP test harness kernel module for an upco=
ming FIPS certification. We are certifying the kernel SHA3 implementation, =
so I have added test handling code for SHA3 to the module. While the Monte =
Carlo tests and functional tests are providing correct output for SHA3, the=
 Large Data Tests (LDT) are failing. Below is a snippet of the code I added=
 for LDT with error handling removed for clarity. The sdesc was created els=
ewhere in the code.
>
> unsigned char *large_data =3D NULL;
> unsigned long long int cp_size =3D tc->msg_len;
>
> large_data =3D (unsigned char *)vmalloc(tc->exp_len); /* 1, 2, 4 or 8 Gig=
 */
> cp_size =3D tc->msg_len;
> // Expand the test case message to the full size of the large_data object
> memcpy(large_data, tc->msg, cp_size);
> while (cp_size * 2 <=3D tc->exp_len) {
>     memcpy(large_data + cp_size, large_data, cp_size);
>     cp_size *=3D 2;
> }
> if (tc->exp_len - cp_size > 0) memcpy(large_data + cp_size, large_data, t=
c->exp_len - cp_size);
> err =3D crypto_shash_digest(sdesc, large_data, tc->exp_len, tc->md);
>
> if (large_data) vfree(large_data);
>
> I verified that large_data has the expected data with printk's.
>
> I also tried using update/final with smaller large_data sizes, but I get =
the same incorrect SHA in _final as from _digest. When I run the equivalent=
 test with libkcapi, I get the correct md. It seems the kernel needs data t=
his large to be sent by send/vmsplice in userspace for this to work. Is thi=
s correct?
>
> Any help would be appreciated.
>

Hi Jeff,

AFAIK the crypto APIs generally don't support inputs larger than U32_MAX.
