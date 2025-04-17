Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2401E1DEB;
	Thu, 17 Apr 2025 07:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744875637; cv=none; b=ZdyhVxqQuP7wMVjlKJJwFPurKbBgdquTLn1zC8UKOSvgoFfIjriV+3Cx6TjePokf8p3Ko4VWPfDrLMSgr8unnToJbZo5xfwhzdKEGBN0gyReDcNErDFnP7Owfq0ZfZCou5K1sYiS+LTB1jK9Lg1ma3xjf21bR7SbzUVpkl+vfz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744875637; c=relaxed/simple;
	bh=4aj28yefpFzrt0vHw/4ikT3uCCLQxvA66d7zlCi1C50=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QGSkBkdtHCu42NlALrXfKF2QViLbPd4Rl7fRf2mSk0tpOH5Fqr3adw29XFdvDXmW33dECk22Yuu4BV1aseUdm3Fv21Rfi8AnLY0GyDPlyQ9lFgD1j0fxmUJ1BsnWw3w94YBEwyqtJExqb2nHXZswA7k9pADWVPAY+X/oDWN9BDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FRiuAAk/; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FRiuAAk/"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-30eef9ce7feso4747501fa.0;
        Thu, 17 Apr 2025 00:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744875634; x=1745480434; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9x7gR7Yz7XNUFWa+lwCa2rWEWOau+/yNpWiz9libhis=;
        b=FRiuAAk/9vU3qR7puS0/DtBtmIr7bU61GXfz8ERX4tZMP2J6SMTPZ2CBNiXu8n8LwV
         mzt7v8ClTEzhYk25P1jvHNp397FNF0tj13LtKi57KL7RJJAYsE9h1//2lTOdKP4iJ9cb
         27Kc5KBPJIa7mf+lXk+RK069ZSc0fpqmZxYSPhxdnYWmVlIXodKZBK2fEfD9er4Ktwib
         owwHzCEDnhaOR39mKXYXd29mMvrFUp0hkCLA8eNGFgGLp9YrJKpPWf9DsAvR8pQBgV7W
         LWoN4sC5Fwtgx03Zp/rqyaaIXBqL0c8yzssXi+9fjwfmhot08dGtL9afFfbtxljpLUhD
         IDJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744875634; x=1745480434;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9x7gR7Yz7XNUFWa+lwCa2rWEWOau+/yNpWiz9libhis=;
        b=mes1Jj6TjKz2Dbe/q0yQ0ijzEr49cE8TADnTuffkRQ+ZgYFYcaalMi0p9H478w6LeZ
         AwPr6h/Pj4qDI6dsFdogKnnJzfVU3/u3J/De4j5PiHPprNv/uLAH9LRVirAADiDikQCj
         Wi0p98WNw57WeNuPw21R/TLDLosPt7Lvra6IsnyGVUGsq1kfJ9n/Wm1u8BXCnpslHr3s
         Lk3HLo5KTktNnaQkcpPapWh5eDO2kENApgS5cqflOvNvucBYeYn14ZSZ9IG7ifKCCSnT
         zIZO9KFoHgAK+/jGZt9e4aoDXCgB1q92/pYOafYAy0bz4Hh4iYTYeXPhnkOyubZlvCSQ
         P+dQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1Wj4ifoQIr+lA+gEYWBSZWx/z9ziuIvRydtDLLzDy7+nFBhpaihKPtk7tOJbeEWhTBg9BubM3kayiwS8=@vger.kernel.org, AJvYcCWcBFIAz8YR2mT2jP3clN1WXAmILZE/UclgZnLynd/m8HxZaNpwbL2Q/cfJ4nNgpgIstZZysfY1ibC6idJw@vger.kernel.org
X-Gm-Message-State: AOJu0YxAzEMBZ4NSatSps1nZ3z4mCcGIiKqH+8snfyuEr7+cuhJtmEqK
	cQVFxLCr9HGwCmN5KznQzJRPIHwO5dBJxMaGiDW9tPQCWQ4DwD9ErlZPjQVsLtRFEcVZVrafmQF
	1/5eR/MuVdfxQqkyx+7I3GRVPY48=
X-Gm-Gg: ASbGncsJ/jGtjBIMRsjgoMCXP0dTXnXWTEiiQAEMeZDVSQuq0ASSAs4RuYNjqTKd+JO
	jQWxSAG/v6eQTTel6GFr1uM88OXxKdTJpa2CIwddnAytnvfRCLnikuq8fZug1PGx915qPHJkbsQ
	52UTl3Qe6qr3rUciDEuI0b
X-Google-Smtp-Source: AGHT+IGZnKMxCdpzpwJnWblYSUd3QLkAetoc1gHCWvz1x15KmhiEoEGPl0XQ1oZjMxaysNCUGExVqyOCz6W5GquFftY=
X-Received: by 2002:a2e:a990:0:b0:30d:e104:b593 with SMTP id
 38308e7fff4ca-3107f73a78cmr16127281fa.39.1744875633362; Thu, 17 Apr 2025
 00:40:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250417064940.68469-1-dqfext@gmail.com> <CAMj1kXFPAVXOtPoETKvHB49kjZUPYrsAqsJwdL7p5Cu4xk75Rg@mail.gmail.com>
 <CALW65jY=LnVBYoKPOQnSKgGSA0brKzmo0vqoRDcqF_=jofLAng@mail.gmail.com>
In-Reply-To: <CALW65jY=LnVBYoKPOQnSKgGSA0brKzmo0vqoRDcqF_=jofLAng@mail.gmail.com>
Reply-To: noloader@gmail.com
From: Jeffrey Walton <noloader@gmail.com>
Date: Thu, 17 Apr 2025 03:39:56 -0400
X-Gm-Features: ATxdqUG0eIH-yuy96XaXV-0vu-m2nutTChvWUTplyUTZfzB8DNwZOqlnJL5Xq5c
Message-ID: <CAH8yC8=9u42jK0-FrHOXvWDM-Z3jUKSSSFznTMVWUiPAgCFcTA@mail.gmail.com>
Subject: Re: [RFC PATCH] crypto: riscv: scalar accelerated GHASH
To: Qingfang Deng <dqfext@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>, Eric Biggers <ebiggers@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, linux-crypto@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	=?UTF-8?Q?Christoph_M=C3=BCllner?= <christoph.muellner@vrull.eu>, 
	Heiko Stuebner <heiko.stuebner@vrull.eu>, Qingfang Deng <qingfang.deng@siflower.com.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 17, 2025 at 3:25=E2=80=AFAM Qingfang Deng <dqfext@gmail.com> wr=
ote:
>
> Hi Ard,
>
> On Thu, Apr 17, 2025 at 2:58=E2=80=AFPM Ard Biesheuvel <ardb@kernel.org> =
wrote:
> > [...]
> >
> > Also, do you need to test for int128 support? Or is that guaranteed
> > for all compilers that are supported by the RISC-V port?
>
> I believe int128 support is available for all 64-bit targets.

You can verify the compiler supports int128 with the following macro:

    #if (__SIZEOF_INT128__ >=3D 16)
    ...
    #endif

Also see <https://gcc.gnu.org/pipermail/gcc-help/2015-August/124862.html>.

Jeff
