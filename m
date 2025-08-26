Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C91A2FFDEB;
	Tue, 26 Aug 2025 13:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216278; cv=none; b=M0IMAvxctzFhu8NItdC58hNpv8+RGk1xed1xS87GPGj1eRLkTwOJtQmpUrPEqkUYm97qerG8vnGkv4+nEX4lINBkAg0Fuf8Zk3GY3iSmtIL7fg+aVnSCSqqDAyMEXW5HW5TNqwIPK5pDGZV0BlLXcZ1RjUTIHeXul5xgmwWVE40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216278; c=relaxed/simple;
	bh=E+JdUlZSCoxiieHGl3mpSbH/9mo3TqI95VAZ0RUIIHY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VsNmn8MwtlHWuUtXYcGmqUgx5Nt7TPEM/SjeRSY49Elu9qJXDHkA9/TT1towbR71A+w8BhRpVJ7Xrb7V42I3Vf9TCTd3BMYhUr2ydvIrI1pS5pZ1KzWy1TaWa6ZD9Z1XF7rg7WLm6H3yURONy+BvEjAmOKpc0aMUwul6QyAfC38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sc6wMYRh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sc6wMYRh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D55BC116B1;
	Tue, 26 Aug 2025 13:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756216278;
	bh=E+JdUlZSCoxiieHGl3mpSbH/9mo3TqI95VAZ0RUIIHY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Sc6wMYRhwe+2yFmHtb/sAK74i+xU1B1QCVabPKnc4HdJUZPUad0EoQHVzV9d8wrko
	 9DAt558o6l7RIDXP6iXPGhFJXhcemyvrn7gm5c9J88VmLZhyfujInCNedCBn64rWRU
	 j3zU2uysz2bSSFTj1Zg60hyApBBgvY9hW45zRYYPHG/WA1sBXyf52y0lbV51P9X+n9
	 abOYZ4+laK94Y7LugwyC3JdwajQGKDUH1rH7PSMzonlrzgR/m6dWJNzwpscCt4N18I
	 npmbRUem2eIDEMTC7CWqwBMKtcfu6cry855rU1YjlJM4s9nOC5yizxqjUw7hyDCYxC
	 8mrtLed+qYRAA==
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-55f527db6f6so69708e87.2;
        Tue, 26 Aug 2025 06:51:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVvayU37+ZNT7cPmYGE2CliiTUXMWa4lFotuIFeJrznvSBzaWWeGJ+bw8+CsoHNqgACz+BY/OafYeACC63U@vger.kernel.org, AJvYcCWLk9pN2e3LXzv6Q3WUaKDOrbB1JxsTQwKd69X1kKZOu6gCyU8p+a3feMWDFUhpgIgZbFmcDx2BQeESopA=@vger.kernel.org, AJvYcCWss/OtD0niIEsgReoaDjWXn6v1xWFhcVg+A/GvemnD11tJrNyBELp5A55LtETreHGOb8apz8NJrPKxMxmALALb@vger.kernel.org
X-Gm-Message-State: AOJu0YxFn/LCKuAYZid+2uqS6XaCLnXHnDh9T6Un6KhTBNZqsIP6cTLD
	YPRJa5ThdLgusGD1SeZHvVxTZYVhGESUme6fK+JGokGAC4A71MnlvPcOo5Js0DspK+s4o041Ht6
	DGTIabvZ61wCUl75QB2nuIOYVKUBMehk=
X-Google-Smtp-Source: AGHT+IEyERKJpY0dTTeTMtR+lCc7K9/yDgg91XPe10BR+4CJOA+0bojzARWxfItbUWZV8G72TOeEw7wifxB7E0hNJWU=
X-Received: by 2002:ac2:51c9:0:b0:55f:445d:e47f with SMTP id
 2adb3069b0e04-55f445de605mr2110419e87.45.1756216276581; Tue, 26 Aug 2025
 06:51:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <6895b041.050a0220.7f033.0058.GAE@google.com> <tencent_B406618996EEF22ED6CC8EA7DF46FD92D206@qq.com>
 <aKBMjQpA9P70EA0z@gondor.apana.org.au>
In-Reply-To: <aKBMjQpA9P70EA0z@gondor.apana.org.au>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 26 Aug 2025 15:51:04 +0200
X-Gmail-Original-Message-ID: <CAMj1kXF4aRL02CKnO5T9kKnvSV=BcMDiD=mDW7CKQx5t_HmaHw@mail.gmail.com>
X-Gm-Features: Ac12FXxgukB0I0sVPP_wpsET2YYNjVapHKDPsCvg_1qYbfuYo-T1sYScgpJ45do
Message-ID: <CAMj1kXF4aRL02CKnO5T9kKnvSV=BcMDiD=mDW7CKQx5t_HmaHw@mail.gmail.com>
Subject: Re: [PATCH] crypto: Prevent kernel-infoleak in rng_recvmsg
To: Herbert Xu <herbert@gondor.apana.org.au>, linux-hardening@vger.kernel.org, 
	Kees Cook <kees@kernel.org>
Cc: Edward Adam Davis <eadavis@qq.com>, syzbot+e8bcd7ee3db6cb5cb875@syzkaller.appspotmail.com, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

(cc Kees)

On Sat, 16 Aug 2025 at 11:17, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Sat, Aug 09, 2025 at 05:59:43PM +0800, Edward Adam Davis wrote:
> > Initialize the intermediary array member to 0 to prevent the kernel from
> > leaking uninitialized data to user space.
> >
> > Reported-by: syzbot+e8bcd7ee3db6cb5cb875@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=e8bcd7ee3db6cb5cb875
> > Tested-by: syzbot+e8bcd7ee3db6cb5cb875@syzkaller.appspotmail.com
> > Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> > ---
> >  crypto/jitterentropy-kcapi.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
> > index c24d4ff2b4a8..9e9e069f55af 100644
> > --- a/crypto/jitterentropy-kcapi.c
> > +++ b/crypto/jitterentropy-kcapi.c
> > @@ -107,7 +107,7 @@ int jent_hash_time(void *hash_state, __u64 time, u8 *addtl,
> >  {
> >       struct shash_desc *hash_state_desc = (struct shash_desc *)hash_state;
> >       SHASH_DESC_ON_STACK(desc, hash_state_desc->tfm);
> > -     u8 intermediary[SHA3_256_DIGEST_SIZE];
> > +     u8 intermediary[SHA3_256_DIGEST_SIZE] = { 0 };
>
> This is not a leak! The stack memroy is hashed and fed into the
> entropy pool.

Is there still a point to doing this now that the compiler
zero-initializes automatic variables? Or does that not apply to u8
arrays? (asking Kees)
