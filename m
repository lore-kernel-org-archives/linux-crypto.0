Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HiV/TA4Y"
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84E812A
	for <linux-crypto@vger.kernel.org>; Wed, 13 Dec 2023 02:51:28 -0800 (PST)
Received: by mail-qv1-xf36.google.com with SMTP id 6a1803df08f44-67ab5e015aaso43813166d6.0
        for <linux-crypto@vger.kernel.org>; Wed, 13 Dec 2023 02:51:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702464688; x=1703069488; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LsRX4OChLjIi43OniRoBz0jKL2cIX50vjKJWm+IfNkg=;
        b=HiV/TA4Y2ZVntbDB7i+K2E9FxKszVZzIfl/mynW/dhKrlAfl/7vfTdBHXIaMa2vldp
         RKsPUm/jVHz8APKy/yYtGGRdjtZ9OozyQj2IbmgCcJWFVrbYedC0MB9SDB9yGAvtVcXG
         mxgh2vH7i9KQkAuCBNP9+fkAN+qKPykxDs9XS9GhMK4tAtKyMlT3VQ8qfbFQt3SFT6Fc
         /4Jxv4clJq+kOD647L0NCFxrwftoPD0UfZaKbeiSjWjQoQ0Lyb10+QLE6p23XN+tSjwc
         S2RFJW4GeZfB0M1trIcTfteHWCICl6aFLhQHSUfr9pzwetXwQvA/XYwzLFp/lWopoSGB
         iUXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702464688; x=1703069488;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LsRX4OChLjIi43OniRoBz0jKL2cIX50vjKJWm+IfNkg=;
        b=ZXSY+huJMXacIlQm6mAjcQiClASvxNXMS/2qrrbyoIztaMQXWdDZdcFlfDpOgZy5Mt
         tValhLXEjdVGqkEkbxAh5n0AMJez1dphiZJJfi+Cs+8XWI/tZvWf/ows6F5o0J8WB/BB
         HBrSTwY2mXpZYy/9gHqkubuklHPPzBURdvZiMAG3lqYTBpy2NudyXWmIn2VywhT4IXua
         RG+So9FzBRoKhhVXbgf0b1+koxuKxrPYjZXxIZSLcc3Qz3zPVCO8kOJs1hDHUXxdqOgv
         v4wyMSmq7TlYU3Cxby0gtBcdhFZ8ekn7CtoSshKIREgSqfuiZHsjX+XlBI9krUIPyQIu
         dImA==
X-Gm-Message-State: AOJu0Yxs8x3tXhtWr9kvbdrMuMg8VnCBEPT3mX77N06+beCeAKhRST55
	jP68R0AjPUwtrUaR5MKB3tdHIQ2zBgKLR1oQxzrHpA==
X-Google-Smtp-Source: AGHT+IFjgwPpHwzbvxbC3Tisbj77ZSIg/pKABb/74yh5X1y4ErdCCfythI2bN3xslqJOop8lR67H7T1SPck2ziqINEA=
X-Received: by 2002:a05:6214:5606:b0:67e:cf4b:4071 with SMTP id
 mg6-20020a056214560600b0067ecf4b4071mr5725767qvb.49.1702464687697; Wed, 13
 Dec 2023 02:51:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <000000000000f66a3005fa578223@google.com> <20231213104950.1587730-1-glider@google.com>
In-Reply-To: <20231213104950.1587730-1-glider@google.com>
From: Alexander Potapenko <glider@google.com>
Date: Wed, 13 Dec 2023 11:50:50 +0100
Message-ID: <CAG_fn=XDZehsCQbTfKjjBuan9=ri74n6AtXDg-Q9nbzYskVc4Q@mail.gmail.com>
Subject: Re: [syzbot] [crypto?] KMSAN: uninit-value in __crc32c_le_base (3)
To: syzbot+a6d6b8fffa294705dbd8@syzkaller.appspotmail.com, hch@lst.de, 
	dchinner@redhat.com
Cc: davem@davemloft.net, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 13, 2023 at 11:49=E2=80=AFAM Alexander Potapenko <glider@google=
.com> wrote:
>
> Hi Christoph, Dave,
>
> The repro provided by Xingwei indeed works.
(the mentioned repro is at
https://lore.kernel.org/all/CABOYnLzjtGnP35qE3VVyiu_mawizPtiugFATSaWwmdL1w+=
pqWA@mail.gmail.com/)
