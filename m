Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342B33A641F
	for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 15:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781709226; cv=pass; b=L6EENJSUkdd3h9ZCi9c9IXry5kR2rNU67c4Nsq9KCuBF9DgHTSR1C1kGt9pbM6JJDFpSomh+5Hr37XPH40C0dBfSbVYdVsm+i19aRR4x4mIoGPxXU9uusEMw+cNr53lSicg/dsnGXrTF3opyj1+CDfmxECoBJyQzQGldJTORl3c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781709226; c=relaxed/simple;
	bh=1YeOeVcaV3t2A2us7OOjCzRwIaW3U9bhvKRMSctJIqo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lk7/jsUS/XFkzttvyJdXqCsO2tRY4oTfZ6k6QbxF2dhIRt029EdozZjB81iRRI/w6JQj/jc0z1fmVLEX4Doj1csRMrCRt1Ul4aXdtc20F0HocqGKMJIgIGBXXg1klUK/VwcmhtP4ubf+eru9vC62A73uOUbp+fTdOIt1daKBA1o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a3IPLQQH; arc=pass smtp.client-ip=74.125.82.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a3IPLQQH"
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-304d4e57d33so309048eec.3
        for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 08:13:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781709224; cv=none;
        d=google.com; s=arc-20240605;
        b=agBUmo5QNWP8L3YrenNQcBHoKnfksEm6bW4vdiA8HeTUsgOy1NyUXvGXEkMOzZHKH7
         uPdGc863LllMVIo1dGE2VJPj8Hm7jkmtLHiXW8y1Jfu//ieMRouRp5jgW1EgM5dGJmXX
         V0CmCDanOfgBWIMST5159R45RNFoOFWowgqg1+lj2mw5UVumqZZiAdsQyZJ3g+NSK9Xe
         J9viMAt29MVW93Zh4TzasS3j8KaxToEwrknkgboXc6D7pRu6t/qBa5E0SiHDLJ4zw4M5
         ucYC+Wg3fZZZWFqHv9+pomOEnA1wJCzGSjKtOQMNoSBuGUERfHX0UaTp4WjHw/2plGEx
         KyqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1YeOeVcaV3t2A2us7OOjCzRwIaW3U9bhvKRMSctJIqo=;
        fh=fnZkbbTBl6x/0JtlrV804UhcXC4rsEI4TB2+qoC5O80=;
        b=LyG2Rdl3ggtmaiMvycOdqMr6TSB59a1sE5Cvd12LV36LhOj8QbXIC6y7LNVBq9SQ9s
         KIrmTqc3S197v6J8YMFw39Hd2r50VOSTP17BPvXDMeDuGscq0OIXOeCLI78m3uKAb281
         cPHCc4Wlc0aIRXLPVO2R6emLeRrbpz+HtnahKICcCIzxe/jG33rSKECPeFA6sVGcGpBJ
         S8Jg32Fc3CGob94S6BDGnJjlU8rU9gUIRwqV0MeIrK8TrhYNGXoB+02yhL7A/7FyjoHD
         Kc7hE4jQ0EBhj3zMPXPA9LD47hWSA4V4zg9rDGtXIXAH6WBW4PoHAUVi80UKnhF4cEeM
         fRvQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781709224; x=1782314024; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1YeOeVcaV3t2A2us7OOjCzRwIaW3U9bhvKRMSctJIqo=;
        b=a3IPLQQHU3TzqK+rzjoHYChzlNkxQuFmzyiPDoaJFs1hbkBE9aaneuRYHcS4AbjEdQ
         8ChIrZH1O5VzZrY5yDVTr9SHYIMH3k1mVX3kGR4IV6yArKaogOvArdKYCJTygTNfHEVI
         u7yK38oiIfe+TvWZndP/LwVfQOXIraUxSDbzNa5je6a2PsznukCkGsKy7YHK+DuGU8R0
         YUII8KL6Ud4YuYSDlZQrO8rO+u1EXwGZ6CspE+DBcyX7zs85Fq24ZMhnhowh1XhDeq0r
         UOY8Ic7uqXZyVI4M/HIOorYdP+RviLxaKPkgyUTqDfYwixLor5X/bI2dHVPDpQS+yAja
         XQvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781709224; x=1782314024;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1YeOeVcaV3t2A2us7OOjCzRwIaW3U9bhvKRMSctJIqo=;
        b=T2OzXDUoiON8sGOkMozoPezFr+FzM8RLaMm5LfNCZFy6tsHgzyGodenQuNOrnc4P7g
         qisInASEDhXaQpt4ySv1AwXbZaq9nh3BpqCYC3+9t7clhwuZRoVFLPrH+UoVhaIOBQvY
         gNaJpJzhlOjNRMAG+V6OzeaHU47IVPsDglNeZwMgaybt44wBrVNA5v7/guSZlPcOXTrP
         4NxBMmmJBhyo42g+386d/Kxng4o3gxlnQSVg4GgphVbluT2DxHwxUQQ348GGABvy0REK
         hcQAcvsRIU4bBxhjTUTDU4GgLSX/bVrNRqiSVzc/xYj6gP91tfnhxgDFo4hctIjLnfFw
         832w==
X-Forwarded-Encrypted: i=1; AFNElJ/91IkKgYmECeqa51Usxefk1Wt/vCrxMJs8usPPNsmotYm16/JedW3Z90eqoEfloTeZKwg8p1HVrHL9588=@vger.kernel.org
X-Gm-Message-State: AOJu0YxK9MwJg7DQM3NxxcJ+YDIVzGIBdNIe3zmfSFb/3MPw30MA7KwE
	kTll/+8gMzlNk7M3gO5PWy3yyqiz3HlNO3nSPVTMK6cfHr+jcYoy6DwLi70L58dhlky6z+NCI8n
	COKGWs4y+lxxKPyWRytimyg+H1son3V8=
X-Gm-Gg: AfdE7clBt/GdLi/r2p5JSWoIPIz9mLwNbJHr8cMSdEW1sxhHJSdLrVwDSNzH3NartNO
	Kdqvmc1jKxO8wSvH/NcO3iWhmLd2zvvtUvRpLkn+zrq3h4R69VFHgxsPamOWpGipKHrZqGXBpEJ
	bTC8vkVNCjrCmCAC6f9fxTpo+aeo5gp3kLQj7UojSbkNZcSJX5sOgEeQXfFtOE83UNESdAoCq5G
	Q4frntm0juoKe27h0Y5N+gh/IuT59lldALEIznVqqoLXp/uDJGrb7BiqejK9/gDXYoWbKQdMOFJ
	xhc8t1QgulI0DyTBySAfOThGQoDNBLuKW9X+JqroQkH54zHH2E7JDyMGhrzn6K1MZkeC2ykB125
	Wo71lr6HKpioJ
X-Received: by 2002:a05:7301:670a:b0:30b:ab02:9e5d with SMTP id
 5a478bee46e88-30bca0ff9a4mr1011746eec.6.1781709224326; Wed, 17 Jun 2026
 08:13:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260617150143.2152-1-mike@fireburn.co.uk>
In-Reply-To: <20260617150143.2152-1-mike@fireburn.co.uk>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 17 Jun 2026 17:13:32 +0200
X-Gm-Features: AVVi8Ccbv3X1xkwu2DB9qCxLaen8yiIiQN6moOtMJGKTe61-EHWEqACwA8v8LdI
Message-ID: <CANiq72=me+GZCOW1H5FtfE-b1OY5FXN0yT2S3661vP+S0EDVwQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] rust: crypto: library AES-128 / SHA-256 / HMAC + RSA
To: Mike Lothian <mike@fireburn.co.uk>
Cc: rust-for-linux@vger.kernel.org, linux-crypto@vger.kernel.org, 
	Eric Biggers <ebiggers@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Ard Biesheuvel <ardb@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 17, 2026 at 5:01=E2=80=AFPM Mike Lothian <mike@fireburn.co.uk> =
wrote:
>
> Both were factored out of an out-of-tree in-kernel Rust DisplayLink DL3
> dock driver (which needs SHA/HMAC/AES for HDCP 2.2 and RSA for the AKE),
> but the module is generic. Compile-tested in-tree against drm-next.

Same question as in the other patch series you just sent: is this only
expected for an out-of-tree driver? Maintainers generally cannot take
dead code, unless there is a good justification behind it -- is the
driver expected to land upstream? Do you have a link to the code?

Thanks!

Cheers,
Miguel
