Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A13726AABF;
	Fri, 28 Feb 2025 12:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740746643; cv=none; b=L8cx1Bw0g90WqH1LNmXKrX2w4SIGawE/ftkDpaVFsu8W9rBX7l8Qsl9sBxf62haeLf4QVUtWucoZB9yEMsQAj9wJo+U6heEyBEUegesexcFhYdypB/nF62pKNwiULtKLfhDt2ZyQL9xzMFr9rkEFpgNPWDVmNTsm4eiBemo8Zn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740746643; c=relaxed/simple;
	bh=zdXip2FYZUEqtBBqgGrnFxMSITYB0sBgruxmuMhZuGA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vcr7OeMjUutyubvYGyR4y1GDeQRHuDNLOYUds16E9Hl/N60i80W2ayGMmGA2io0alj3HUKt9+9yIVm592dITpOL4mGNWAEY0mvOnod3MSmEHWBDZ4XYviEtaLaM+XOAJn7COVB92HPRYGE0fzW+EGYZO2EDnQ7GL3LwV7BfdNE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JnYFLf//; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JnYFLf//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1659C4CEE7;
	Fri, 28 Feb 2025 12:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740746642;
	bh=zdXip2FYZUEqtBBqgGrnFxMSITYB0sBgruxmuMhZuGA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=JnYFLf//Yqe46jhUuz2wyiXBupsKVnH7nHF5H2Y2O8NQG33br4Fm671pFwOleQm/C
	 rnqk+zM2akxM/JkrujUpngW/avkmhpMNlBagAhT4KVhAPRbo5JitBLaH58Jc8oDBgl
	 BEKuxLNXg9MGXO425n/rCIci0qAlDc1pKJpUCyaE/ArUuHvWDbQeb7xl9vk+vmgSAY
	 hUVMXDoWIQBi7FrdZC3ci38wDqk5rDzTf0Ym2qCru/wGCn5itWErayVsXbMrIXlWbx
	 15zO7unswkjX8etwSt8jeCwzBt7nI6jydxeVakwQMnvnc1hagyjX81ok8NMeUL3P2O
	 zFjEtraZPXSRQ==
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-30a36eecb9dso24594621fa.2;
        Fri, 28 Feb 2025 04:44:02 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUeD2VcaJmUsa+TN/clh6MP1uWUJqojXKWvZnjKmYApJjfiNK+GQblFQt+2Nl62ZGGmg1A+OZw5NTSlvso=@vger.kernel.org, AJvYcCV6TeLynZTVRbSkVDEm2voGfdYRVJKKpwvf/QJKzzrS/jsw84i3yec1gFR2lx9V9lfxsUa5cUt+ekfvw9oO@vger.kernel.org
X-Gm-Message-State: AOJu0Yyop584OALeZUDN0o+vMTmWVCFoVkJb4rHN7yN9ePlzuCLDeeNm
	KEhpDule8Q3VGaje7iTiwhoM7+jYC537t9OBCI3znwUihysSMb+Vje9JW9CF9XM2bayyIgEaKIa
	Xmm94Fq8dRj4QFTcUxTLIwrF0AUg=
X-Google-Smtp-Source: AGHT+IGSFonTM2tA84B5Bx6euBEN58t9VKOoQn5q8Je78hewQwZkeCN8PBkPYsIPynya7vLCOWfPSnsJTp7sP3NAKYw=
X-Received: by 2002:a05:651c:158a:b0:30b:8f60:cdb7 with SMTP id
 38308e7fff4ca-30b932da780mr12662301fa.24.1740746641179; Fri, 28 Feb 2025
 04:44:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Z7rGXJSX57gEfXPw@gondor.apana.org.au> <20250226130037.GS5777@twin.jikos.cz>
 <qahmi4ozfatd4q5h4qiykinucdry6jcbee6eg4rzelyge2zmlg@norwskwechx6>
In-Reply-To: <qahmi4ozfatd4q5h4qiykinucdry6jcbee6eg4rzelyge2zmlg@norwskwechx6>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 28 Feb 2025 13:43:50 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFKBynkfBFmQ1tbgZ0fTOP0pg5453NFGxVGvmePrKssug@mail.gmail.com>
X-Gm-Features: AQ5f1JqIOExld1avZ7R_dc18PeVvNeFx8ju7YRn-qvNjpIyXvXD0V3XBYYy_LL8
Message-ID: <CAMj1kXFKBynkfBFmQ1tbgZ0fTOP0pg5453NFGxVGvmePrKssug@mail.gmail.com>
Subject: Re: [PATCH] lib/lzo: Avoid output overruns when compressing
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: David Sterba <dsterba@suse.cz>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Nitin Gupta <nitingupta910@gmail.com>, 
	Richard Purdie <rpurdie@openedhand.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, 
	"Markus F.X.J. Oberhumer" <markus@oberhumer.com>, Dave Rodgman <dave.rodgman@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 28 Feb 2025 at 06:24, Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> On (25/02/26 14:00), David Sterba wrote:
> > What strikes me as alarming that you insert about 20 branches into a
> > realtime compression algorithm, where everything is basically a hot
> > path.  Branches that almost never happen, and never if the output buffer
> > is big enough.
> >
> > Please drop the patch.
>
> David, just for educational purposes, there's only safe variant of lzo
> decompression, which seems to be doing a lot of NEED_OP (HAVE_OP) adding
> branches and so on, basically what Herbert is adding to the compression
> path.  So my question is - why NEED_OP (if (!HAVE_OP(x)) goto output_overrun)
> is a no go for compression, but appears to be fine for decompression?
>

Because compression has a bounded worst case (compressing data with
LZO can actually increase the size but only by a limited amount),
whereas decompressing a small input could produce gigabytes of output.
