Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F501C54A7
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jan 2025 21:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737667042; cv=none; b=thRkwDqb1eM+5X3jiEAdtckUWYlxWRGGHfrU46V3OkAQDL2egBLmrnp8nmCq3nbgyxHhrSub99r3SHRxcuaQraejOTJbbW1uZTIj4f+gVmdKNBexeJJXiJpbrR3rSD0ylNYUA8c77A6fjM5NhUIMCfc7BuNXkO++ypbcwznTHWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737667042; c=relaxed/simple;
	bh=LhP215z1xU95pTPKSN0xSy4qut+hlbcHEY14YelYgPA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ea/dgsNW+hcZ/H8YDTtf+F9AqfZNvamy10WK2HjLGbmHyCOhig7oizXP9Ir3y5LapEV1r1GrrRs/dCtprxAe7v5XsPRwQ+OAXO9dUwhtf8f6aqXJC43uiZIDOVD2bP/VaY6nIXEdQn24kaCL6/SKye4ClsHUfmVw9/UgWYwjmZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bABMVhQf; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bABMVhQf"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5d647d5df90so2474597a12.2
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jan 2025 13:17:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1737667036; x=1738271836; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+c1m1FICxvzfYRA5u3XGSGM/PTq6nJ74bTecG4JYrAc=;
        b=bABMVhQfiPlwW2kkwgtfZ0UyKpAoaPo85v1comgXu22AZ1lH/lcB34MhB9/BeFFVqF
         sE+nctcbNeWo/dWkJF1rUCXFTjUPGceKEboGZ1CqYSclu+QN5r7H90qeIq+5o7znXGyF
         4yvu7iyhr3uP7pNAspQl0Oh6xy28vSjKDeDU8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737667036; x=1738271836;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+c1m1FICxvzfYRA5u3XGSGM/PTq6nJ74bTecG4JYrAc=;
        b=m+BUHEWSuw756zyKeSK31H3eKbN8jIyiillyn7pvXQwqnqKlWqzEHNZabmJN2Uqn5x
         FKLoY8ausrMUhCyuxaWXA4BWPWCDNZ2zL/5tre3OqxbZm02rPUKxRVH+KGmNT5htNv9X
         52oA7Qqt1hvPH2n5oVWT77n2Yr7ZgMfifJhRZ23P0AbWsJD3HjW5qLYTWeTYQTCTyCZ2
         hepNNLlzaLC68pYkTRTZ4fabY+UlFnqKIje3s+qMum2AWmbZW7072OYajuoaikKUZl0o
         dZ9hYc2lTVzHGwe4CniUN6xTiRyHHomytVlxMfv1TzUzAqhQGoARciJ3BsaHUVG/xtvS
         8scg==
X-Forwarded-Encrypted: i=1; AJvYcCUkO3wwK9hDi6h4DhM4bfh2qqMrDXkiWF0vsFb6VDuDgdrBQePi51hG7xSL352DvcLBYBDm4PKLmxFBlik=@vger.kernel.org
X-Gm-Message-State: AOJu0YybEOx2LHQn8pXFoXrklBCzEQin+YZLTKNI9O8FojCDrXUqoMCr
	6fD81ebYLU/77T3rOmGUMhEDQx6xbCTyBljMx9R6FqjS15P90yLtYoU1ffd25sdH1APxrX/xoKg
	HQzkVjQ==
X-Gm-Gg: ASbGncsjbutqDLs5GIN8JzMzYRdkTJJRjlg237R9cFalrrvMM0Mv5KC543l2hbkhDEK
	4QXOMFqL35FTxbbm5sWfPtGzu2wP78Kqo3xyvuv8gt5SYIys5GXCiz0UzN9h61wf1n/EF0/B8TO
	cKpaLCfGcWvaRL1h84Q9wUiq6qpqPSyrM8nQ9DlymUizcyBqiAA+d6vBO7JSkzRb2fJSr8tjjHP
	zDDgcD07+PNaAw0NeKX7dt5OCq90SlZ0pEiXyVoPQLppsuM5kjge9vMelvetdKD9CjnaL+vtk9u
	P14g6qRBj5bXNBRQETiLO5dKempf9td43dSONGbu5agfGGdjty8Jvjk=
X-Google-Smtp-Source: AGHT+IGEJvYC1xaHmUFcN5M5z9mcyuCUyHdJY6/iHAR7aRKHocs4k1mOtM9BGw/9VpvlOVlhPgU1SA==
X-Received: by 2002:a05:6402:3550:b0:5d3:ce7f:abee with SMTP id 4fb4d7f45d1cf-5db7db08623mr25282017a12.25.1737667036629;
        Thu, 23 Jan 2025 13:17:16 -0800 (PST)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com. [209.85.218.47])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dc18628c88sm175237a12.30.2025.01.23.13.17.14
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2025 13:17:15 -0800 (PST)
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-aaeec07b705so282449766b.2
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jan 2025 13:17:14 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWSoIqr59qrpD9+VNduqSUc3CgjVvHB/kBmOfeN/560FnlYWtuIfx1PHVA3/5/20KSJYE2YnfSX+sMZG8w=@vger.kernel.org
X-Received: by 2002:a17:907:7e95:b0:ab2:ffcb:edb4 with SMTP id
 a640c23a62f3a-ab38b162801mr2134086966b.25.1737667033654; Thu, 23 Jan 2025
 13:17:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250119225118.GA15398@sol.localdomain> <CAHk-=wgqAZf7Sdyrka5RQQ2MVC1V_C1Gp68KrN=mHjPiRw70Jg@mail.gmail.com>
 <20250123051633.GA183612@sol.localdomain> <20250123074618.GB183612@sol.localdomain>
 <20250123140744.GB3875121@mit.edu> <20250123181818.GA2117666@google.com>
 <CAHk-=wiVRnaD5zrJHR=022H0g9CXb15OobYSjOwku3m54Vyb4A@mail.gmail.com> <20250123211317.GA88607@sol.localdomain>
In-Reply-To: <20250123211317.GA88607@sol.localdomain>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 23 Jan 2025 13:16:57 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgmda2CvAiOrg+zznFroPTo2TrdjnHo9f4_Kv1Pwn5iOA@mail.gmail.com>
X-Gm-Features: AWEUYZkgJr0C-HIVypIhOLVKOKoeKvpeJ33HizapkhrDoRryp7x5yxh45PNB_bY
Message-ID: <CAHk-=wgmda2CvAiOrg+zznFroPTo2TrdjnHo9f4_Kv1Pwn5iOA@mail.gmail.com>
Subject: Re: [GIT PULL] CRC updates for 6.14
To: Eric Biggers <ebiggers@kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, Chao Yu <chao@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Vinicius Peixoto <vpeixoto@lkcamp.dev>, 
	WangYuli <wangyuli@grjsls0nwwnnilyahiblcmlmlcaoki5s.yundunwaf1.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 23 Jan 2025 at 13:13, Eric Biggers <ebiggers@kernel.org> wrote:
>
> x86 unfortunately only has an instruction for crc32c

Yeah, but isn't that like 90% of the uses?

IOW, if you'd make the "select" statements a bit more specific, and
make ext4 (and others) do "select CRC32C" instead, the other ones
wouldn't even get selected?

              Linus
