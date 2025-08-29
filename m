Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D7731A54E;
	Fri, 29 Aug 2025 13:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756472951; cv=none; b=lIRSrARqImWUfeE+rc93jsd447gUlsao+6WrK/yj8xxoJUf7sDg4+IwxpS5BNMyVsbyCGXF47ZocKRQJKKcnnllgf5H/TeA1LV448jiCgB3y0AHB/edqdrjNxYZFRB11SVn2PTWF3JmUenZFyRkbQW/9jBrFErlfMzlgakFlM0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756472951; c=relaxed/simple;
	bh=+x8k+F/e77Z8aTKTvPcle7nacxjsHrzWmdqf6Ase76I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MtdrbGTG80j6dGDpjJd3wdExjOKsoiLl/fLfqBhAiU3jmJOFvcKJrLdUPYfygR88uyRxQeraM0ALNc/p8f+9udTiDVAFxTNOCOlECrZ8/05JEvVxk49CRPvfnSxh5QWjD+MihIXLfr836uLNN7I+FSaTmRhKWWEA3ZlQkrwM5vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QVkRIlg0; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QVkRIlg0"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-afe84202bc2so302920466b.2;
        Fri, 29 Aug 2025 06:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756472948; x=1757077748; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uOlGULRRBESS1B6FKAmb2SdwU8XK+0w4GrnM3lfwOWQ=;
        b=QVkRIlg0aSKW+DBfJ09Iguxal+OmmmIM6cK9g2S5fCteAmbjXCgTVX8yRt+dpQ9vQh
         E+hvzKR/NtErmQoKweN1Ev+mReGqrHq1Kd3KjTnYGj2ZGqGz9WqYIkz4PuzFCp6cTKxT
         7BdVkvXZAW/QpUJ4aBcPm+IhHTdUjoimCc95gKHdLRTsxZ9gMCwrxrU3WXt01lg3cSsm
         l7svpknlB0TyLwp53wzOLOJah752Eib6zKiRvEl/+HitjUVSjeoEZVA/Uq3ZM8Ym5hqf
         sSQ8HFlrAQoTfPXmVhjj22VaOYREPGp5l4ncPXsT7VvZAMtnKYHNQjyCPc/fCuIqai3P
         tJog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756472948; x=1757077748;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uOlGULRRBESS1B6FKAmb2SdwU8XK+0w4GrnM3lfwOWQ=;
        b=R7iNtv7PbQmjzKaB6Di1HQCyKvZMZP/+NfJibO9ow3FYooreESMQ4oA+K/XrCxecgB
         IWMuVzDgsttrtmvZmmcf2Y51+6LX2tKJKmj+Yv5m3N2vf69tWclLwYNpnxt3pKWF1+ls
         zGxMgrqwvAoy3eg5XpuHkwZr9eWeTWSp4vKkWMgQiXYvbwxhuExGuwFA+EC4UxwDYYwd
         DbRZ+af9KacuV4H6DnIScleR4do9wFle719e+tdq6yuSaKBFoEYtIgNw9BLm+yDjRQZ6
         MCb0lYi+rxUxK8mzzzZONRrRj5lRHA5l7nmaiNwBe5tAaFAFDLLyD6Kuay1NZQethtaO
         F5aA==
X-Forwarded-Encrypted: i=1; AJvYcCVMR9K0MHuoyCt56mIhDYLGVUrD0pPFoahN6XiXPyncXdvGvCmco9ucA3NXb+7bHflHfFUEq6Ox8d98ekk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYYlv2KneNsXP7Aq0dfygLgE5u98cVxV/u9aUbIASPe0S9V1Oc
	cgfa1L678esQfSLlkKUUGhfrtGoAlg9YpQ+Stby6pvmEBNQhx2K/hd8Vi844/FDlRMEvq+msWq5
	MPt9jWRRN6nnOdqNhZs8hIFRUwm00TeI=
X-Gm-Gg: ASbGncuWzKnErz2s+9qe2oEdxPF/2ecuQ6fLn6Fs10kagrSIRNSjZA6H5Ea0r61t82n
	GOQofWuI0LEO3BaC+FcYz9BmwK4LsxIJdkmFAzz09OOJ601I2l05on+YzyvWs2FbPdgc30ZVE2i
	MveKz/IcwcCzro6ngd4jV+xApywQpYOW7s0wm6D1ONcNR7h7w7P9CkefRMjfSbKmySbk3f+N7tw
	5kW9j7jNKHd78v3xC+lOJSoHyGU+k//i9XYckmfxOcmjozo3k6OcqCEpMZftlmUdEt4Ohe/tuMs
	4ejB4U95Z8diqoqBzQDEboFD1QKPcZAPtmfaUkEceZH1tHmYj3K9L9wlvwXqumigToM=
X-Google-Smtp-Source: AGHT+IGID0Yr7NzhLbvdcJDd5PR7loGNbghiuTkZejFibNh1I3F9FhGziJlTcPTrI2a3z865+5IAXbKTbH+jTM98IOM=
X-Received: by 2002:a17:906:4ec3:b0:afe:74a3:f76d with SMTP id
 a640c23a62f3a-afe74a3fda1mr1537152666b.16.1756472947953; Fri, 29 Aug 2025
 06:09:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250827151131.27733-1-ebiggers@kernel.org> <20250827151131.27733-10-ebiggers@kernel.org>
In-Reply-To: <20250827151131.27733-10-ebiggers@kernel.org>
From: Honza Fikar <j.fikar@gmail.com>
Date: Fri, 29 Aug 2025 15:08:56 +0200
X-Gm-Features: Ac12FXzP7AMNvKr3rovHU6ozQ9uIXQuWW18zjeyPmWZydBzIv70_f24LOqsCh7k
Message-ID: <CAEH5pPY98CaSm+EXiuOzo6EuWzGu7rEQjGa3eojk18HP29Rs7w@mail.gmail.com>
Subject: Re: [PATCH 09/12] lib/crypto: blake2s: Always enable arch-optimized
 BLAKE2s code
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>, x86@kernel.org, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 29, 2025 at 2:54=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:

> Currently, BLAKE2s support is always enabled ('obj-y'), since random.c
> uses it.  Therefore, the arch-optimized BLAKE2s code, which exists for
> ARM and x86_64, should be always enabled too.

Maybe a stupid question: what about ARM64? The current NEON
implementation in kernel arch/arm/crypto/blake2s-core.S seems to be just
for ARM.

While the upstream BLAKE2s with NEON is both for ARM and Aarch64 (ARM64):

https://github.com/BLAKE2/BLAKE2/blob/master/neon
