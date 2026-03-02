Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A49A39EF36
	for <linux-crypto@vger.kernel.org>; Mon,  2 Mar 2026 21:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772485205; cv=pass; b=Z7CngkEwg1yhXbBwnq5xPgSvuDyO/JejIB0dNwJndOXCcIKThDXQuG8qEjVqDuBu6rnhMlAmJ0flJS0RPhQkylHUMUEuF+lmSFRGgFeUZvV/vSgBkUbekDdTKvQpc3zWoRfSxKtC23qzONRHBFMs9OUZa5OUPDM0KgDSSB+fI00=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772485205; c=relaxed/simple;
	bh=KjgbAzL1E1IdcmiEt5GtmmF34JBS0gwFcSJFm9y6PXw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TyXaBL2HgbbepVxYkd2VjFcVVmC1+Lm38T5HaX3kEFEt+yRCE9zCBW0Ow7Ch4TNgXFt/qR6hnbdp+In4CEVNI8NHKLbolootzEIYs3SsCzOa5ozY2NFVUKD0EeuC3cKaRt3W2x7mC3m0D13ATnU+UDICysOQb8wI8heEk/BQTNU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b89AdYD+; arc=pass smtp.client-ip=74.125.82.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b89AdYD+"
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-2be1b5fe11cso1043662eec.0
        for <linux-crypto@vger.kernel.org>; Mon, 02 Mar 2026 13:00:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772485202; cv=none;
        d=google.com; s=arc-20240605;
        b=Af43wrOV9KDMyoNCNk/cgIH0M/mSjGNLhA1wU3cgho+ePoQsSWXeJfrDVxSV46XCEX
         KeEGXKtLk734ULUa7zhOX+HlcFwcH2B9cEvLxv/6QJQYbdlZVump70zcoKJ1ng4rB4Sz
         vUKczikIGq+3Edhaq6K2pWhEcJ62vPmXAje8T6EJmGa4gLCZKuYJQv+4E3/RUKKILIlT
         cjYFUUi4BzIC7fBPdrSNXC3OjCGUdT0s6OOYa49xK2zazLNU0x4ECaEh+H9jv1hAlTGL
         AoqExNgi8TW5cVpyFVxtaWh6u4OCqX8MsSRQ1Tc5nothSr5Rl6iKQwGDY7zv3CorGGES
         X1ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=LJpwXOwpNuN50/jhnvI9Iu6aocDAFHqTStHaEOppP4E=;
        fh=F5HeW5xURq2W2lpeCMlX58s+pPHEBI2YtYa9oBVvBnY=;
        b=FEHODZwaQYMtCFw/oB10FE3CAPsfFivZ+gq+sKl7SFUbHbi1+V+b34dBWlWBDrF5hQ
         6Ca25S1o2F6D6OFKiKo5I3EBWoGWTkc8QGSUxwlfJv3a3RVe97bJVScmDJI60aCIVU9l
         HUlXxe39ZdVED1tlHztSejDHw4D3zFtKsZPInuVMw+UIyDVGLmJ3IB1grxZNFxfBYeMc
         ZJ7qSOsx5FRWcbZQdeZVLxoKG7choLj3QBUVETv4KHtEodMDIXyVrgtpJck0FZpq19TN
         LkN9f9Ox0qAKm34qsqqhJ18RVRnahS8VhlKhDDluU3ANlO2zaFlQYI9GKcReFFMe+t62
         vPQg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772485202; x=1773090002; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LJpwXOwpNuN50/jhnvI9Iu6aocDAFHqTStHaEOppP4E=;
        b=b89AdYD+VhDkxxWNjWXPUvruqjHpT9mAICFNkE2SU5wfIyERnLN/cMLYA45Vj3FtnU
         WfUnEcw8mS8wSDvSj4jm/nvcdCCfiE4WLy+VvNomgkxw1vIEXt6OlNRSqEOLel0v5we+
         8JU4O2zO3c8rghNL/V05MbR9HMArzrCMt82cCn0KA4CKu/McD1u1rVuYgjGM+JIPVO/h
         Lm18wjuJX/CvwCKV/sh1o4FsnSuCCF0z7JJYxFsvENSHlC/yyk9PcwlBYUWs3chDrhk5
         cX64aYFPCMSq2URvn8kmh0ksSely8MdXek9YxNjxj1d2surlkyVZUo3kp5IfGTdSs32r
         VxwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772485202; x=1773090002;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LJpwXOwpNuN50/jhnvI9Iu6aocDAFHqTStHaEOppP4E=;
        b=oQC//8iQsExhSmiv6a2uLWaON60FhW1V0TVCpEVR3csTABGSIP9QCycEumbZ6MiPeG
         pg8pyPUIbVQwXkxbFDsbl5ZHuDqNIFUICJ28UZ1qNAdLrnQ/ao8BXclt7cQdECHUxSYe
         sft5FdnaRg/eqH84GIxDXknq3qzJJfyW7PNbsWZz3DIZSd6W8bA7gvcOv3caLk+IpV/j
         HuwxMl+yMzwSYowMeQXaiOsSYC4GCyewtBGPS8xlf7+O5oQ5U7SCxaPbZkNaZkuRBvfy
         Zdax9S27tXJYdUYhEZAkOF47P0PzbUL17dpSRYcb+eQJi6bn/gheoeX/KdKJ4YrIp1uE
         PZSQ==
X-Forwarded-Encrypted: i=1; AJvYcCXgumsSe3eMOIEtt8nZXCX84aEmHDy0z042d12iZgvgNW+k9irEQ3kL1Sg+BCij3D5wqDUzi6w8t7NuGHg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8bq+5fkGGOR9m5bKQYmAepU1+Trlb7zDrsQg2LEuD9mObNyN0
	AzudYCRgf6qYVVW2xq1CSfVvRm2oaSiDXK9c1kKm7jya3YlGsrj7MKSASmukjuXkxWJksJaCZvS
	wuJNwyMQ11htBjI9sUkWnHwUlocOqG3Y=
X-Gm-Gg: ATEYQzyWFpv0E/VDVSknAud2ZrOo6D/f1TBCZATgUQ1LdovDafJXCcScriLi339Ed68
	r07KLB3wx+oqfFgTr3BLa7CTS/Ltnzu5ovkMp6DX2KfvLvjoBt1MhbWLnzR3RCgz9crcZsQnJoP
	W5zT+HHowXXHoH9MaeTK3qBKwwT1/XJxXKZl2nF7Lcz75pgc2sTFzKLOkvjrVbs7owiRt1CPhrF
	DrJyyb4gVlBRRg3dN9KRFphC6SRoYncNTIKGtHz/eE6UZooPS4bY2J9TDutR0WBrdzXmwX0s5F6
	oWKxMQT+BOVKBhgkTVMun09O1zWTOV6Bjuh8vibmgw==
X-Received: by 2002:a05:693c:409a:b0:2be:8da:321c with SMTP id
 5a478bee46e88-2be08da3393mr1740887eec.2.1772485202409; Mon, 02 Mar 2026
 13:00:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260302203600.13561-1-ebiggers@kernel.org>
In-Reply-To: <20260302203600.13561-1-ebiggers@kernel.org>
From: Dmitry Safonov <0x7f454c46@gmail.com>
Date: Mon, 2 Mar 2026 20:59:50 +0000
X-Gm-Features: AaiRm52sgjZJdZRrfWpXsEb9jJIE1M7aZEwhGDOdaP19FXauiP7ZogndER0-Nag
Message-ID: <CAJwJo6Yt9v8pscqFB7mfuHGhwNSOE2no4Y5fu8o67atn=EtnUA@mail.gmail.com>
Subject: Re: [PATCH net] net/tcp-ao: Fix MAC comparison to be constant-time
To: Eric Biggers <ebiggers@kernel.org>
Cc: netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 2 Mar 2026 at 20:36, Eric Biggers <ebiggers@kernel.org> wrote:
>
> To prevent timing attacks, MACs need to be compared in constant
> time.  Use the appropriate helper function for this.
>
> Fixes: 0a3a809089eb ("net/tcp: Verify inbound TCP-AO signed segments")
> Cc: stable@vger.kernel.org
> Cc: Dmitry Safonov <0x7f454c46@gmail.com>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Thanks, Eric, LGTM.

Reviewed-by: Dmitry Safonov <0x7f454c46@gmail.com>

Could you also send a similar patch for TCP-MD5?
tcp_inbound_md5_hash(), tcp_v{4,6}_send_reset() would need the same change.

> ---
>  net/ipv4/Kconfig  | 1 +
>  net/ipv4/tcp_ao.c | 3 ++-
>  2 files changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
> index b71c22475c515..3ab6247be5853 100644
> --- a/net/ipv4/Kconfig
> +++ b/net/ipv4/Kconfig
> @@ -746,10 +746,11 @@ config TCP_SIGPOOL
>         tristate
>
>  config TCP_AO
>         bool "TCP: Authentication Option (RFC5925)"
>         select CRYPTO
> +       select CRYPTO_LIB_UTILS
>         select TCP_SIGPOOL
>         depends on 64BIT && IPV6 != m # seq-number extension needs WRITE_ONCE(u64)
>         help
>           TCP-AO specifies the use of stronger Message Authentication Codes (MACs),
>           protects against replays for long-lived TCP connections, and
> diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
> index 4980caddb0fc4..a97cdf3e6af4c 100644
> --- a/net/ipv4/tcp_ao.c
> +++ b/net/ipv4/tcp_ao.c
> @@ -8,10 +8,11 @@
>   *             Salam Noureddine <noureddine@arista.com>
>   */
>  #define pr_fmt(fmt) "TCP: " fmt
>
>  #include <crypto/hash.h>
> +#include <crypto/utils.h>
>  #include <linux/inetdevice.h>
>  #include <linux/tcp.h>
>
>  #include <net/tcp.h>
>  #include <net/ipv6.h>
> @@ -920,11 +921,11 @@ tcp_ao_verify_hash(const struct sock *sk, const struct sk_buff *skb,
>                 return SKB_DROP_REASON_NOT_SPECIFIED;
>
>         /* XXX: make it per-AF callback? */
>         tcp_ao_hash_skb(family, hash_buf, key, sk, skb, traffic_key,
>                         (phash - (u8 *)th), sne);
> -       if (memcmp(phash, hash_buf, maclen)) {
> +       if (crypto_memneq(phash, hash_buf, maclen)) {
>                 NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOBAD);
>                 atomic64_inc(&info->counters.pkt_bad);
>                 atomic64_inc(&key->pkt_bad);
>                 trace_tcp_ao_mismatch(sk, skb, aoh->keyid,
>                                       aoh->rnext_keyid, maclen);
>
> base-commit: 9439a661c2e80485406ce2c90b107ca17858382d
> --
> 2.53.0
>
