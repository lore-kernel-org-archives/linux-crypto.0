Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C2022D9ED
	for <linux-crypto@vger.kernel.org>; Mon,  2 Jun 2025 14:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875578; cv=none; b=mugRKr1qGfLjgCKR3jmfeS3qAp970QasI3pb6r58+2lZ8M0riwfPlD1Fhtoo9RBvTK2vdCPsSKMw6ENK2mHU6BcAu7bubdDAEuRg06kJHFlEzMDXCYYXWpfnHJqnea+ljN8fQBJFQ18fRCYAyT8Dmg00QjGo0/rhzXnZh6DJVuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875578; c=relaxed/simple;
	bh=BMdmqxyCVbd7fEc++ql37zNwaBo1D8/TV+gOsCFIGWs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pAbz2tWGGVS/FUL1TpO9CPQ77XCX7Pgs+EGkGixI/m+jXWQ0qCiPK60ZoGNb0d2xCywkYhmocpJ3gaPdkupm5eCf7FhEggvMxQaWEoWA3DMPknME8ma7kc1rNQ4qhRstraMsCDZHThjLMEeRsEPzXhd65OEVVeK9vIjfrArcbd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iCTZiqW3; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iCTZiqW3"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ad891bb0957so793278066b.3
        for <linux-crypto@vger.kernel.org>; Mon, 02 Jun 2025 07:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1748875574; x=1749480374; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Cg0dwJvYfbYUNtSY86lpjPZ26U71B5eHF51TBSSqPe4=;
        b=iCTZiqW3SJ/t+gdVt4ga6XGES01PXlH3Pq9wsq25SikMyzqQGVB1A4voeRnuBnYXtl
         Lv1Vcb+Yh2amgvfjPEnC8KOu7W3T73s6Nqbz63LNbLoXUqmX+e0bzBT0cfm4bq/WWMrk
         kRyq12vg8k4Sek8Cr88188sUtM9vIJ5gDkLrQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748875574; x=1749480374;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Cg0dwJvYfbYUNtSY86lpjPZ26U71B5eHF51TBSSqPe4=;
        b=HPsjKlREkpJp8Cj2yh6RCvEtgQWVFsDKv6MxI7W2vYiXO/PtOxJxo/VejF3NtCqe/E
         fsBhnDe2vBHPSKZCwJfZu7s7UwFyTbWAH0rJkDlziuAzQeFdi5aUGxFGKcYaw0irYech
         19rozgTpDukRtFsjfewnNxJrxgPFE4wVs+IWpxvLs9eLu2JtHOH92m5KvCqrCaWhxAZ8
         kTpXqRkAFpGnuGiKdIXPdl31/2omkdLHf3yJDGWxHfh5Bj1tA/TOKHprgjsnCigFVqJH
         BqUIsUAUrHWLe3LuO7NF8hsPqtBlP/CTysnYVGYktZmZ/eeldmIACVGoWDYQDxjg6WQM
         1R9g==
X-Forwarded-Encrypted: i=1; AJvYcCWCTLS1EKNo3j6pi/989Oyrn1j++GwjT1qp8acRm0VJYMD+kZXtikCLAlOb1Mbwse4r+MfTLtnKSs9JR/4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9LAVCEpPR7E55zFnh/qjL+sMFTmcXwDC2mOmZAYWGEzbjTxLY
	6uthJuaekiGU+I4t9uAl60eB7E2dgSGhKOSEdeufzmsXLpSiDe0Fk72Rj153hmOpAWGDtsm6JIM
	Uwe1p96c=
X-Gm-Gg: ASbGncvbSH8xgnyrSL+KX+irJaZmk0ysziQ1uY6bPSauMSxpMhnkY+Xs6y/SKkCQ2fu
	+vrxYKWWrS1QgZM437hWr/eILvD1U/eI0oIEjjNDh2at+n+YvUUoF+Jk55oph9SYvaVkIMqg/+L
	yf+TvhnBT2hVQVs3fn1VrsWLKE2kB301fg/cp07iKHRLWI7FL/bXrm0tEMVf+gSgpg5Umd4YvXY
	29+qN/TBXLrMNetMcNk0Do60md68BQ9OtAUCpCBtPWEcTXmXkiZt01h1zigpw+AmIytKOY0lBuV
	RhfPOE2l37+DHKFS5X/nGAcQVb30GjZbqBI6c7CGaaNVv97+ebuyQdJUGVb/YOJ1OfChOzA5r9N
	V3QG/kiOR95kzshfSZq5tKY3ZYQ==
X-Google-Smtp-Source: AGHT+IEmr04ClFqealFXGlYrjSPghj8vDvUxJ4WUcKGhMNI6/OHUlxc7pvZNVicPSdmqeuPzzL+yag==
X-Received: by 2002:a17:907:2da6:b0:ad5:59ef:7f56 with SMTP id a640c23a62f3a-adb3248a805mr1353030166b.48.1748875574301;
        Mon, 02 Jun 2025 07:46:14 -0700 (PDT)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com. [209.85.208.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada5dd043a9sm802625566b.89.2025.06.02.07.46.13
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Jun 2025 07:46:13 -0700 (PDT)
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-606741e8e7cso1355621a12.1
        for <linux-crypto@vger.kernel.org>; Mon, 02 Jun 2025 07:46:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUDN+eqQzYTVBtknqzxXIQQXPne8z1h9gOjr2lp3pJbJhISBsUgVKpagSZ1spKfdSzme3o0bQ/+/fCUyRo=@vger.kernel.org
X-Received: by 2002:a05:6402:5205:b0:606:3146:4e85 with SMTP id
 4fb4d7f45d1cf-60631464feemr3563572a12.4.1748875572780; Mon, 02 Jun 2025
 07:46:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250428170040.423825-1-ebiggers@kernel.org> <20250428170040.423825-9-ebiggers@kernel.org>
 <20250529110526.6d2959a9.alex.williamson@redhat.com> <20250529173702.GA3840196@google.com>
 <CAHk-=whCp-nMWyLxAot4e6yVMCGANTUCWErGfvmwqNkEfTQ=Sw@mail.gmail.com>
 <20250529211639.GD23614@sol> <CAHk-=wh+H-9649NHK5cayNKn0pmReH41rvG6hWee+oposb3EUg@mail.gmail.com>
 <20250530001858.GD3840196@google.com> <20250601230014.GB1228@sol>
In-Reply-To: <20250601230014.GB1228@sol>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 2 Jun 2025 07:45:56 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjO+t0FBrg=bHkbnXVsZ_U0TPgT9ZWUzu12-5NurCaWCA@mail.gmail.com>
X-Gm-Features: AX0GCFuodXM8SKmhJCuuDQhW2iq8pjrSnsjy_QXiBCm4TA9D0azfhocKT2KWhmk
Message-ID: <CAHk-=wjO+t0FBrg=bHkbnXVsZ_U0TPgT9ZWUzu12-5NurCaWCA@mail.gmail.com>
Subject: Re: [PATCH v4 08/13] crypto: s390/sha256 - implement library instead
 of shash
To: Eric Biggers <ebiggers@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	sparclinux@vger.kernel.org, linux-s390@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"

On Sun, 1 Jun 2025 at 16:00, Eric Biggers <ebiggers@kernel.org> wrote:
>
> I implemented my proposal, for lib/crc first,

Ok, I scanned through that series, and it looks good to me. A clear improvement.

         Linus
